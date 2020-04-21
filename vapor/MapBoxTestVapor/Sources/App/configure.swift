import Vapor
import Fluent
import FluentMySQLDriver

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    switch app.environment {
    case .development:
        app.http.server.configuration.port = 8081
        app.http.server.configuration.hostname = "0.0.0.0"
    default:
        break
    }
    app.databases.use(.mysql(hostname: "127.0.0.1",
                             port: 33060,
                             username: "vapor",
                             password: "vapor",
                             database: "vapor"), as: .mysql)
    // add migrations
    try migrations(app)
    // register routes
    try routes(app)
}
