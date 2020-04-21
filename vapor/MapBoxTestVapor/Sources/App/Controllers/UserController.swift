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
        //        let user = User.init(account: "enki", password: "aaa")
        return User.query(on: req.db)
            .filter(\.$mailAddress, .equal, user.mailaddress).all()
            .flatMap{$0.encodeResponse(status: .ok, for: req)}
    }
}

extension UserController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        routes.get("login", use: login)
    }
}

