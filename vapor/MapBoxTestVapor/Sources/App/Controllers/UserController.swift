//
//  File.swift
//  
//
//  Created by YanQi on 2020/04/21.
//

import Vapor

struct UserController {
    func login(req: Request) throws -> EventLoopFuture<Response> {
        let user = try req.content.decode(BaseUser.self)
        return User.query(on: req.db)
            .filter(\.$mailAddress, .equal, user.mailAddress)
            .filter(\.$passWord, .equal, user.passWord).first()
            .unwrap(or: Abort(.forbidden, reason: "username or password incorrect"))
            .flatMap{
                $0.encodeResponse(status: .ok, for: req)
        }.flatMapError { (error) -> EventLoopFuture<Response> in
            User.init(mailAddress: "", passWord: "").encodeResponse(status: .ok, for: req)
        }
    }
}

extension UserController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        routes.post("login", use: login)
    }
}

