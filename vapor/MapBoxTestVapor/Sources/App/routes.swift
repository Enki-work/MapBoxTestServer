import Vapor

func routes(_ app: Application) throws {
    app.get { req in
        return "It works!"
    }

    app.get("hello") { req -> String in
        return "Hello, world!"
    }
    
    let routes = app.grouped("hello")
    routes.on(.GET, "hello", ":name") { req -> String in
        let name = req.parameters.get("name")!
        return "Hello, \(name)!"
    }
    
    // MARK: Controllers
    let userController = UserController()
    let groupcontroller = GroupController()
    let locationController = LocationController()

    // MARK: Routes
    let apiRoutes = app.grouped("api")
    try apiRoutes.grouped("users").register(collection: userController)
    try apiRoutes.grouped("groups").register(collection: groupcontroller)
    try apiRoutes.grouped("locations").register(collection: locationController)
    
}
