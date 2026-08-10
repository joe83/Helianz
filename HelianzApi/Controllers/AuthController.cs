using HelianzApi.Auth;
using HelianzApi.Data;
using HelianzApi.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Dapper;

namespace HelianzApi.Controllers;

[ApiController]
[Route("api/[controller]")]
public class AuthController : ControllerBase
{
    private readonly AuthService _auth;
    private readonly DatabaseConnectionFactory _db;

    public AuthController(AuthService auth, DatabaseConnectionFactory db) { _auth = auth; _db = db; }

    [HttpPost("login")]
    public async Task<IActionResult> Login([FromBody] LoginRequest request)
    {
        var result = await _auth.LoginAsync(request);
        if (result == null)
            return Unauthorized(new { error = "Invalid username or password" });

        return Ok(result);
    }

    /// <summary>Verify JWT token is still valid. Returns 200 with user info or 401.</summary>
    [HttpGet("verify")]
    [Authorize]
    public IActionResult Verify()
    {
        var name = User.Identity?.Name ?? "unknown";
        var userId = User.FindFirst(System.Security.Claims.ClaimTypes.NameIdentifier)?.Value;
        return Ok(new { valid = true, username = name, userNum = userId });
    }

    /// <summary>Debug: show password hash details for a user.</summary>
    [HttpGet("debug-hash")]
    public async Task<IActionResult> DebugHash([FromQuery] string username, [FromQuery] string? password)
    {
        try {
        using var conn = _db.CreateConnection();
        var user = await conn.QueryFirstOrDefaultAsync(
            "SELECT UserNum, UserName, Password FROM userod WHERE UserName = @u",
            new { u = username });
        if (user == null) return NotFound(new { error = "User not found" });

        var stored = (string)user.Password;
        var info = new Dictionary<string, object> {
            ["userName"] = (string)user.UserName,
            ["storedHash"] = stored ?? "(null)",
            ["hashLength"] = (stored ?? "").Length,
            ["hasDollar"] = (stored ?? "").Contains('$'),
            ["endsWithEquals"] = (stored ?? "").EndsWith("=="),
        };

        if (!string.IsNullOrEmpty(password) && !string.IsNullOrEmpty(stored))
        {
            try {
                var md5Bytes = System.Security.Cryptography.MD5.HashData(
                    System.Text.Encoding.Unicode.GetBytes(password));
                info["md5Unicode"] = Convert.ToBase64String(md5Bytes);
            } catch (Exception ex) { info["md5Unicode_err"] = ex.Message; }

            try {
                var md5Ascii = System.Security.Cryptography.MD5.HashData(
                    System.Text.Encoding.ASCII.GetBytes(password));
                info["md5Ascii"] = Convert.ToHexString(md5Ascii).ToLowerInvariant();
            } catch (Exception ex) { info["md5Ascii_err"] = ex.Message; }

            try {
                var sha3Bytes = System.Security.Cryptography.SHA3_512.HashData(
                    System.Text.Encoding.Unicode.GetBytes(password));
                info["sha3Unicode"] = Convert.ToBase64String(sha3Bytes);
            } catch (Exception ex) { info["sha3Unicode_err"] = ex.Message; }
        }

        return Ok(info);
        } catch (Exception ex) {
            return StatusCode(500, new { error = ex.Message, stack = ex.StackTrace });
        }
    }

    /// <summary>TEMP: auto-login as first active user for testing</summary>
    [HttpGet("debug-token")]
    public async Task<IActionResult> DebugToken()
    {
        using var conn = _db.CreateConnection();
        var user = await conn.QueryFirstOrDefaultAsync(@"
            SELECT UserNum, UserName, ClinicNum FROM userod WHERE IsHidden = 0 LIMIT 1");
        if (user == null) return NotFound(new { error = "No users found" });

        var clinicNums = (await conn.QueryAsync<long>(
            "SELECT ClinicNum FROM userclinic WHERE UserNum = @UserNum",
            new { user.UserNum })).ToList();
        if (clinicNums.Count == 0) clinicNums.Add((long)user.ClinicNum);

        var userGroupNums = (await conn.QueryAsync<long>(
            "SELECT UserGroupNum FROM usergroupattach WHERE UserNum = @UserNum",
            new { user.UserNum })).ToList();

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

        var result = await _auth.LoginAsync(new LoginRequest { Username = user.UserName, Password = "" });
        if (result == null) {
            return Ok(new LoginResponse {
                Token = _auth.GenerateDebugToken(user.UserNum, user.UserName, clinicNums),
                DisplayName = user.UserName,
                UserNum = user.UserNum,
                ClinicNum = user.ClinicNum,
                ClinicNums = clinicNums,
                UserGroupNums = userGroupNums,
                Permissions = permissions
            });
        }
        return Ok(result);
    }
}
