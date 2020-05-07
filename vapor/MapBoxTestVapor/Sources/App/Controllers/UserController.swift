//
//  File.swift
//
//
//  Created by YanQi on 2020/04/21.
//

import Vapor
import Fluent

struct UserController {
    func login(req: Request) throws -> EventLoopFuture<Response> {
        let user = try req.content.decode(UserRequest.self)
        return User.query(on: req.db)
            .filter(\.$mailAddress, .equal, user.mailAddress)
            .filter(\.$passWord, .equal, user.passWord).first()
            .unwrap(or: Abort(.forbidden, reason: "username or password incorrect"))
            .flatMap { (user) -> EventLoopFuture<Response> in
                user.createToken().update(on: req.db).flatMap {
                    user.encodeResponse(status: .ok, for: req)
                }
        }
    }

    func logout(req: Request) throws -> EventLoopFuture<Response> {
        let queryToken: String? = req.query["token"]
        guard let token = queryToken else {
            throw Abort(.lengthRequired, reason: "illegal token")
        }
        return User.query(on: req.db)
            .filter(\.$token, .equal, token).first()
            .unwrap(or: Abort(.unauthorized, reason: "illegal User"))
            .flatMap { (user) -> EventLoopFuture<Response> in
                user.removeToken().update(on: req.db).transform(to: Response(status: .ok))
        }
    }
}

func register(req: Request) throws -> EventLoopFuture<Response> {
    let user = try req.content.decode(UserRequest.self)
    return _get(mailAddress: user.mailAddress, on: req.db)
        .isNil(or: Abort(.preconditionFailed, reason: "Username already taken"))
        .flatMap { _ in
            User(mailAddress: user.mailAddress,
                 passWord: user.passWord)
                .save(on: req.db).eventLoop.makeSucceededFuture(Response.init())
    }
}

private func _get(
    mailAddress: String,
    on database: Database
) -> EventLoopFuture<User?> {
    User.query(on: database)
        .filter(\.$mailAddress, .equal, mailAddress)
        .first()
}

extension UserController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        routes.post("login", use: login)
        routes.post("logout", use: logout)
        routes.post("register", use: register)
    }
}

