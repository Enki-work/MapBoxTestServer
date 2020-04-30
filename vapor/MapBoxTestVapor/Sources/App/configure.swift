import Vapor
import Fluent
import FluentMySQLDriver

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    var mysqlHost: String = Environment.get("MYSQL_HOST") ?? "127.0.0.1"
    var mysqlPort: Int = Int(Environment.get("MYSQL_PORT") ?? "33060") ?? 33060
    let mysqlDB: String = Environment.get("MYSQL_DB") ?? "vapor"
    let mysqlUser: String = Environment.get("MYSQL_USER") ?? "vapor"
    let mysqlPass: String = Environment.get("MYSQL_PASS") ?? "vapor"
    switch app.environment {
    case .development, .testing:
        app.logger.info("development, testing env")
        app.logger.info("mysqlHost:\(mysqlHost) mysqlPort:\(mysqlPort)--- \(Environment.get("MYSQL_HOST")!)")
        app.http.server.configuration.port = 8080
        app.http.server.configuration.hostname = "0.0.0.0"
    case .production:
        app.logger.info("production env")
    case .custom(name: "Xcode"):
        mysqlHost = "127.0.0.1"
        app.logger.info("Xcode env")
        app.http.server.configuration.port = 8081
        app.http.server.configuration.hostname = "0.0.0.0"
        mysqlPort = 33060
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
