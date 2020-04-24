//
//  File.swift
//  
//
//  Created by YanQi on 2020/04/24.
//

import Vapor
import Fluent

struct GroupController {
    func get(req: Request) throws -> EventLoopFuture<Response> {
        let requestModel = try req.content.decode(GroupRequest.self)
        return User.query(on: req.db)
            .filter(\.$token, .equal, requestModel.token).first()
            .unwrap(or: Abort(.notFound, reason: "illegal User"))
            .flatMap {
                $0.$groups.query(on: req.db).all().encodeResponse(status: .ok, for: req)
            }.flatMapError { (error) -> EventLoopFuture<Response> in
                MBTError.init(errorCode: HTTPResponseStatus.forbidden.code,
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

extension GroupController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        routes.get("", use: get)
    }
}

