//
//  File.swift
//  
//
//  Created by YanQi on 2020/04/21.
//

import Vapor

struct UserController {
    func get(req: Request) throws -> User {
//        let user = User.init(account: "enki", password: "aaa")
        return User.init()
    }
}

extension UserController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        routes.get("", use: get)
    }
}

