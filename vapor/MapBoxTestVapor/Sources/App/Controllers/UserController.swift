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
            .flatMap {
                $0.encodeResponse(status: .ok, for: req)
            }.flatMapError { (error) -> EventLoopFuture<Response> in
                MBTError.init(errorCode: HTTPResponseStatus.forbidden.code,
                              message: error.localizedDescription).encodeResponse(status: .ok, for: req)
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
            }.flatMapError { (error) -> EventLoopFuture<Response> in
                MBTError.init(errorCode: HTTPResponseStatus.preconditionFailed.code,
                              message: error.localizedDescription).encodeResponse(status: .ok, for: req)
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
}

extension UserController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        routes.post("login", use: login)
        routes.post("register", use: register)
    }
}

