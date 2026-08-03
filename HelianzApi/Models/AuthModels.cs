namespace HelianzApi.Models;

public class LoginRequest
{
    public string Username { get; set; } = "";
    public string Password { get; set; } = "";
}

public class LoginResponse
{
    public string Token { get; set; } = "";
    public string DisplayName { get; set; } = "";
    public long UserNum { get; set; }
    public long ClinicNum { get; set; }
    public List<long> ClinicNums { get; set; } = new();
    public List<UserModule> Modules { get; set; } = new();
}

public class UserModule
{
    public string Name { get; set; } = "";
    public bool Enabled { get; set; }
}
