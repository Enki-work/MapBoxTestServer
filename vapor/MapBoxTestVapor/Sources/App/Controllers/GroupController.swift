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
        let queryToken: String? = req.query["token"]
        guard let token = queryToken else {
            throw Abort(.notFound, reason: "illegal token")
        }
        return User.query(on: req.db)
            .filter(\.$token, .equal, token).first()
            .unwrap(or: Abort(.notFound, reason: "illegal User"))
            .flatMap {
                $0.$groups.query(on: req.db).all().encodeResponse(status: .ok, for: req)
        }
    }
}

extension GroupController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        routes.get("", use: get)
    }
}

