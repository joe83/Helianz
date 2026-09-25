using System.Data;
using Dapper;
using HelianzApi.Data;
using HelianzApi.Models;
using Microsoft.Extensions.Options;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Security.Cryptography;
using System.Text;

namespace HelianzApi.Auth;

public class AuthService
{
    private readonly DatabaseConnectionFactory _db;
    private readonly string _jwtKey;
    private readonly int _expiryHours;
    private readonly ILogger<AuthService> _logger;

    public AuthService(DatabaseConnectionFactory db, IConfiguration config, ILogger<AuthService> logger)
    {
        _db = db;
        _logger = logger;
        _jwtKey = config["Jwt:Key"] ?? "HelianzDevKey-ChangeInProduction-Min32Chars!";
        _expiryHours = int.TryParse(config["Jwt:ExpiryHours"], out var h) ? h : 24;
    }

    public async Task<LoginResponse?> LoginAsync(LoginRequest request)
    {
        try
        {
            using var conn = _db.CreateConnection();
            var loginIdentifier = !string.IsNullOrWhiteSpace(request.Email)
                ? request.Email.Trim()
                : (request.Username ?? "").Trim();

            _logger.LogInformation("Login attempt for identifier: {Identifier}", loginIdentifier);

            bool isEmailLogin = !string.IsNullOrWhiteSpace(request.Email) || loginIdentifier.Contains('@');

            List<UserRow> users;
            if (isEmailLogin)
            {
                // Strict executive email matching: must have non-empty Email configured in userod
                users = (await conn.QueryAsync<UserRow>(@"
                    SELECT UserNum, UserName, Email, Password, UserGroupNum, ClinicNum,
                           EmployeeNum, IsHidden, ClinicIsRestricted
                    FROM userod
                    WHERE LOWER(TRIM(Email)) = LOWER(TRIM(@Email))
                      AND Email != ''
                      AND IsHidden = 0",
                    new { Email = loginIdentifier })).ToList();

                if (users.Count == 0)
                {
                    _logger.LogWarning("Executive user not found or email not registered: {Email}", loginIdentifier);
                    return null;
                }
            }
            else
            {
                // Fallback username matching (trimmed and case-insensitive) or email
                users = (await conn.QueryAsync<UserRow>(@"
                    SELECT UserNum, UserName, Email, Password, UserGroupNum, ClinicNum,
                           EmployeeNum, IsHidden, ClinicIsRestricted
                    FROM userod
                    WHERE (LOWER(TRIM(UserName)) = LOWER(TRIM(@LoginId))
                           OR (Email != '' AND LOWER(TRIM(Email)) = LOWER(TRIM(@LoginId))))
                      AND IsHidden = 0",
                    new { LoginId = loginIdentifier })).ToList();

                if (users.Count == 0)
                {
                    _logger.LogWarning("User not found: {User}", loginIdentifier);
                    return null;
                }
            }

            // Pick user matching clinic if multiple exist, otherwise first
            UserRow user;
            if (request.ClinicNum.HasValue && request.ClinicNum.Value > 0)
            {
                user = users.FirstOrDefault(u => u.ClinicNum == request.ClinicNum.Value)
                    ?? users.FirstOrDefault(u => u.ClinicNum == 0)
                    ?? users[0];
            }
            else
            {
                user = users[0];
            }

            // Verify password hash (OpenDental format: HashType$Salt$Hash)
            if (!VerifyPassword(request.Password, user.Password))
            {
                _logger.LogWarning("Invalid password for user: {User}", loginIdentifier);
                return null;
            }

            // Get all active clinics
            var allClinics = (await conn.QueryAsync<ClinicInfo>(@"
                SELECT ClinicNum, Description, Address, City, Phone, IsHidden
                FROM clinic WHERE IsHidden = 0 ORDER BY ClinicNum")).ToList();

            List<long> clinicNums;
            List<ClinicInfo> accessibleClinics;

            if (!user.ClinicIsRestricted)
            {
                // Unrestricted user has access to all clinics (0 represents HQ/all access)
                accessibleClinics = allClinics;
                clinicNums = allClinics.Select(c => c.ClinicNum).ToList();
                if (!clinicNums.Contains(0))
                {
                    clinicNums.Insert(0, 0);
                }
            }
            else
            {
                // Restricted user: clinics explicitly linked in userclinic
                var userClinicNums = (await conn.QueryAsync<long>(@"
                    SELECT ClinicNum FROM userclinic WHERE UserNum = @UserNum",
                    new { user.UserNum })).ToHashSet();

                if (user.ClinicNum != 0)
                {
                    userClinicNums.Add(user.ClinicNum);
                }

                if (userClinicNums.Count == 0 && allClinics.Count > 0)
                {
                    userClinicNums.Add(allClinics[0].ClinicNum);
                }

                clinicNums = userClinicNums.ToList();
                accessibleClinics = allClinics.Where(c => userClinicNums.Contains(c.ClinicNum)).ToList();
            }

            // Get user's group memberships
            var userGroupNums = (await conn.QueryAsync<long>(@"
                SELECT UserGroupNum FROM usergroupattach WHERE UserNum = @UserNum",
                new { user.UserNum })).ToList();

            // Query permissions for all groups the user belongs to
            var permissions = new List<UserPermission>();
            if (userGroupNums.Count > 0)
            {
                permissions = (await conn.QueryAsync<UserPermission>(@"
                    SELECT DISTINCT gp.PermType, gp.FKey, gp.NewerDate, gp.NewerDays
                    FROM grouppermission gp
                    WHERE gp.UserGroupNum IN @UserGroupNums
                    ORDER BY gp.PermType, gp.FKey",
                    new { UserGroupNums = userGroupNums })).ToList();
            }

            // Build JWT token with permission claims
            var token = GenerateToken(user.UserNum, user.UserName, clinicNums, userGroupNums, permissions);

            var defaultClinicNum = user.ClinicNum != 0
                ? user.ClinicNum
                : (accessibleClinics.FirstOrDefault()?.ClinicNum ?? 0);

            return new LoginResponse
            {
                Token = token,
                DisplayName = user.UserName,
                Email = user.Email,
                UserNum = user.UserNum,
                ClinicNum = defaultClinicNum,
                ClinicNums = clinicNums,
                Clinics = accessibleClinics,
                ClinicIsRestricted = user.ClinicIsRestricted,
                UserGroupNums = userGroupNums,
                Permissions = permissions
            };
    }
    catch (Exception ex)
    {
        _logger.LogError(ex, "Login failed for user {User}", request.Username);
        throw;
    }
}

    /// <summary>Generate a token without password verification (debug only).</summary>
    public string GenerateDebugToken(long userNum, string username, List<long> clinicNums)
        => GenerateToken(userNum, username, clinicNums, new(), new());

    private string GenerateToken(long userNum, string username, List<long> clinicNums,
        List<long> userGroupNums, List<UserPermission> permissions)
    {
        var claims = new List<Claim>
        {
            new(ClaimTypes.NameIdentifier, userNum.ToString()),
            new(ClaimTypes.Name, username),
        };
        claims.AddRange(clinicNums.Select(c => new Claim("ClinicNum", c.ToString())));
        claims.AddRange(userGroupNums.Select(g => new Claim("UserGroupNum", g.ToString())));
        // Store key permission types as claims for quick server-side checks
        foreach (var gp in permissions.GroupBy(p => p.PermType))
        {
            var fkeys = string.Join(",", gp.Select(p => p.FKey));
            claims.Add(new Claim($"Perm_{gp.Key}", fkeys));
        }

        var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(_jwtKey));
        var creds = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);

        var token = new JwtSecurityToken(
            claims: claims,
            expires: DateTime.UtcNow.AddHours(_expiryHours),
            signingCredentials: creds);

        return new JwtSecurityTokenHandler().WriteToken(token);
    }

    /// <summary>
    /// Verifies password against OpenDental hash format: HashType$Salt$Hash
    /// HashTypes: None, MD5, MD5_ECW, SHA3_512
    /// SHA3_512: Unicode(salt+pass) → SHA3-512 → Base64
    /// MD5:      Unicode(pass) → MD5 → Base64 (24 chars, ends with ==)
    /// MD5_ECW:  ASCII(pass) → MD5 → hex lowercase (32 chars)
    /// </summary>
    private static bool VerifyPassword(string plaintext, string storedHash)
    {
        if (string.IsNullOrEmpty(storedHash))
            return string.IsNullOrEmpty(plaintext);

        var parts = storedHash.Split('$');

        // Parse HashType$Salt$Hash format
        string hashType;
        string salt;
        string hash;

        if (parts.Length == 3 && Enum.TryParse<HashType>(parts[0], out _))
        {
            hashType = parts[0];
            salt = parts[1];
            hash = parts[2];
        }
        else if (storedHash.Length == 24 && storedHash.EndsWith("==") && !storedHash.Contains('$'))
        {
            // Legacy MD5 base64 hash (24 chars, no $ separator)
            hashType = "MD5";
            salt = "";
            hash = storedHash;
        }
        else
        {
            // Unknown format — treat as plain comparison
            return string.Equals(plaintext, storedHash);
        }

        string computedHash = hashType switch
        {
            "SHA3_512" => HashSHA3_512(salt + plaintext),
            "SHA512" => HashSHA3_512(salt + plaintext),
            "MD5" => HashMD5(plaintext),
            "MD5_ECW" => HashMD5_ECW(plaintext),
            "None" => plaintext,
            _ => plaintext
        };

        return ConstantEquals(computedHash, hash);
    }

    private static string HashSHA3_512(string input)
    {
        if (string.IsNullOrEmpty(input)) return "";
        var bytes = Encoding.Unicode.GetBytes(input);      // UTF-16 LE
        try
        {
            var hashBytes = System.Security.Cryptography.SHA3_512.HashData(bytes);
            return Convert.ToBase64String(hashBytes);
        }
        catch (PlatformNotSupportedException)
        {
            // Windows Server 2022 lacks CNG SHA3 support — use managed implementation
            using var sha3 = SHA3.Net.Sha3.Sha3512();
            var hashBytes = sha3.ComputeHash(bytes);
            return Convert.ToBase64String(hashBytes);
        }
    }

    private static string HashMD5(string input)
    {
        if (string.IsNullOrEmpty(input)) return "";
        var bytes = Encoding.Unicode.GetBytes(input);      // UTF-16 LE
        var hashBytes = System.Security.Cryptography.MD5.HashData(bytes);
        return Convert.ToBase64String(hashBytes);
    }

    private static string HashMD5_ECW(string input)
    {
        if (string.IsNullOrEmpty(input)) return "";
        var bytes = Encoding.ASCII.GetBytes(input);
        var hashBytes = System.Security.Cryptography.MD5.HashData(bytes);
        return Convert.ToHexString(hashBytes).ToLowerInvariant();
    }

    private static bool ConstantEquals(string a, string b)
    {
        if (a.Length != b.Length) return false;
        int diff = 0;
        for (int i = 0; i < a.Length; i++)
            diff |= a[i] ^ b[i];
        return diff == 0;
    }

    private enum HashType { None, MD5, MD5_ECW, SHA3_512 }

    private class UserRow
    {
        public long UserNum { get; set; }
        public string UserName { get; set; } = "";
        public string Email { get; set; } = "";
        public string Password { get; set; } = "";
        public long UserGroupNum { get; set; }
        public long ClinicNum { get; set; }
        public long EmployeeNum { get; set; }
        public bool IsHidden { get; set; }
        public bool ClinicIsRestricted { get; set; }
    }
}
