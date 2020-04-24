import Vapor
import Fluent
import FluentMySQLDriver

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    
    var mysqlHost: String = "127.0.0.1"
    var mysqlPort: Int = 33060
    var mysqlDB: String = "vapor"
    var mysqlUser: String = "vapor"
    var mysqlPass: String = "vapor"
    
    switch app.environment {
    case .development, .testing:
        app.http.server.configuration.port = 8083
        app.http.server.configuration.hostname = "0.0.0.0"
    case .production:
        print("Under production env")
        mysqlHost = Environment.get("MYSQL_HOST") ?? "127.0.0.1"
        mysqlPort = 33060
        mysqlDB = Environment.get("MYSQL_DB") ?? "vapor"
        mysqlUser = Environment.get("MYSQL_USER") ?? "vapor"
        mysqlPass = Environment.get("MYSQL_PASS") ?? "vapor"
    default:
        break
    }
    app.databases.use(.mysql(hostname: mysqlHost,
                             port: mysqlPort,
                             username: mysqlUser,
                             password: mysqlPass,
                             database: mysqlDB,
                             tlsConfiguration: nil), as: .mysql)
    // add migrations
    try migrations(app)
    // register routes
    try routes(app)
}
