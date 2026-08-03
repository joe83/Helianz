using Microsoft.Extensions.Options;
using MySqlConnector;

namespace HelianzApi.Data;

public class DatabaseConnectionFactory
{
    private readonly string _connectionString;

    public DatabaseConnectionFactory(IOptions<DatabaseConfig> config)
    {
        _connectionString = config.Value.GetConnectionString();
    }

    public MySqlConnection CreateConnection()
    {
        var conn = new MySqlConnection(_connectionString);
        conn.Open();
        return conn;
    }

    public string ConnectionString => _connectionString;
}
