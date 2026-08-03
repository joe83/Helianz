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
            _logger.LogInformation("Login attempt for user: {User}", request.Username);

            // Look up user by username (matches OpenDental userod table)
            var user = await conn.QueryFirstOrDefaultAsync<UserRow>(@"
                SELECT UserNum, UserName, Password, UserGroupNum, ClinicNum,
                       EmployeeNum, IsHidden
                FROM userod
                WHERE UserName = @UserName AND IsHidden = 0",
                new { request.Username });

            if (user == null)
            {
                _logger.LogWarning("User not found: {User}", request.Username);
                return null;
            }

            // Verify password hash (OpenDental format: HashType$Salt$Hash)
            if (!VerifyPassword(request.Password, user.Password))
            {
                _logger.LogWarning("Invalid password for user: {User}", request.Username);
                return null;
            }

            // Get user's clinic access
            var clinicNums = (await conn.QueryAsync<long>(@"
                SELECT ClinicNum FROM userclinic WHERE UserNum = @UserNum",
                new { user.UserNum })).ToList();

        if (clinicNums.Count == 0)
            clinicNums.Add(user.ClinicNum);

        // Build JWT token
        var token = GenerateToken(user.UserNum, user.UserName, clinicNums);

        return new LoginResponse
        {
            Token = token,
            DisplayName = user.UserName,
            UserNum = user.UserNum,
            ClinicNum = user.ClinicNum,
            ClinicNums = clinicNums,
            Modules = new List<UserModule>
            {
                new() { Name = "Patients", Enabled = true },
                new() { Name = "Appointments", Enabled = true },
                new() { Name = "Charting", Enabled = true },
                new() { Name = "Billing", Enabled = true },
                new() { Name = "Prescriptions", Enabled = true },
                new() { Name = "Notes", Enabled = true },
                new() { Name = "Reports", Enabled = true }
            }
        };
    }
    catch (Exception ex)
    {
        _logger.LogError(ex, "Login failed for user {User}", request.Username);
        throw;
    }
}

    private string GenerateToken(long userNum, string username, List<long> clinicNums)
    {
        var claims = new List<Claim>
        {
            new(ClaimTypes.NameIdentifier, userNum.ToString()),
            new(ClaimTypes.Name, username),
        };
        claims.AddRange(clinicNums.Select(c => new Claim("ClinicNum", c.ToString())));

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
        var hashBytes = SHA3_512.HashData(bytes);
        return Convert.ToBase64String(hashBytes);
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
        public string Password { get; set; } = "";
        public long UserGroupNum { get; set; }
        public long ClinicNum { get; set; }
        public long EmployeeNum { get; set; }
        public bool IsHidden { get; set; }
    }
}
