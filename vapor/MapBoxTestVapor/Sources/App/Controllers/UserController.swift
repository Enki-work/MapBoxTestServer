//
//  File.swift
//  
//
//  Created by YanQi on 2020/04/21.
//

import Vapor

struct UserController {
    func login(req: Request) throws -> EventLoopFuture<Response> {
//        let user = try req.content.decode(BaseUser.self)
        let queryMailaddress: String? = req.query["mailaddress"]
        let queryPassword: String? = req.query["password"]
        guard let mailaddress = queryMailaddress,
            let password = queryPassword else {
                throw Abort(HTTPResponseStatus.badRequest)
        }
        return User.query(on: req.db)
            .filter(\.$mailAddress, .equal, mailaddress)
            .filter(\.$passWord, .equal, password).first()
            .unwrap(or: Abort(.forbidden, reason: "username or password incorrect"))
            .flatMap{
                $0.encodeResponse(status: .ok, for: req)
                
        }
    }
}

extension UserController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        routes.post("login", use: login)
    }
}

