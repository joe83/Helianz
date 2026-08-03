namespace HelianzApi.Data;

public class DatabaseConfig
{
    public string Server { get; set; } = "localhost";
    public int Port { get; set; } = 3306;
    public string Database { get; set; } = "helianz";
    public string User { get; set; } = "oduser";
    public string Password { get; set; } = "";
    public bool Pooling { get; set; } = true;
    public int MinPoolSize { get; set; } = 2;
    public int MaxPoolSize { get; set; } = 50;

    public string GetConnectionString() =>
        $"Server={Server};Port={Port};Database={Database};User={User};Password={Password};" +
        $"Pooling={Pooling};MinPoolSize={MinPoolSize};MaxPoolSize={MaxPoolSize};" +
        $"AllowUserVariables=true;DefaultCommandTimeout=60;";
}
