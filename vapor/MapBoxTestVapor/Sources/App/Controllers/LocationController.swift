//
//  File.swift
//
//
//  Created by YanQi on 2020/04/24.
//

import Vapor
import Fluent

struct LocationController {
    func getUserLocation(req: Request) throws -> EventLoopFuture<Response> {
        let queryToken: String? = req.query["token"]
        guard let token = queryToken else {
            throw Abort(.unauthorized, reason: "illegal token")
        }
        return User.query(on: req.db)
            .filter(\.$token, .equal, token).first()
            .unwrap(or: Abort(.notFound, reason: "illegal User"))
            .flatMap {
                $0.$locations.query(on: req.db).all().encodeResponse(status: .ok, for: req)
        }
    }

    func getUserGroupLocation(req: Request) throws -> EventLoopFuture<Response> {
        let queryToken: String? = req.query["token"]
        guard let token = queryToken else {
            throw Abort(.unauthorized, reason: "illegal token")
        }

        return User.query(on: req.db)
            .filter(\.$token, .equal, token).first()
            .unwrap(or: Abort(.notFound, reason: "illegal User"))
            .flatMap { (user) -> EventLoopFuture<[Group]> in
                user.$groups.query(on: req.db).all()
            }.flatMap { (groups) -> EventLoopFuture<[User]> in
                var resp = [EventLoopFuture<[User]>]()
                for group in groups {
                    let userq = group.$users.query(on: req.db).all()
                    resp.append(userq)
                }
                return resp.flatten(on: req.eventLoop).map { (usersList) -> [User] in
                    var userlist: [User] = []
                    for users in usersList {
                        userlist.append(contentsOf: users)
                    }
                    return userlist
                }
            }.flatMap { (users) -> EventLoopFuture<Response> in
                var resp = [EventLoopFuture<[Location]>]()
                for user in users {
                    let locationq = user.$locations.query(on: req.db).all()
                    resp.append(locationq)
                }
                return resp.flatten(on: req.eventLoop).map { (locationsList) -> [Location] in
                    var locationlist: [Location] = []
                    for locations in locationsList {
                        locationlist.append(contentsOf: locations)
                    }
                    return locationlist
                }.map({ (locations) -> ([Location]) in
                    var filtedLocation: [Location] = []
                    for location in locations {
                        if filtedLocation.contains(where: { $0.id == location.id }) {
                            continue
                        } else {
                            filtedLocation.append(location)
                        }
                    }
                    return filtedLocation
                }).encodeResponse(status: .ok, for: req)
        }
    }

    func upload(req: Request) throws -> EventLoopFuture<Response> {
        let location = try req.content.decode(LocationRequest.self)
        return User.query(on: req.db)
            .filter(\.$token, .equal, location.token).first()
            .unwrap(or: Abort(.unauthorized, reason: "illegal User"))
            .flatMap {user in
                if let userIdStr = location.userIDStr {
                    return Location(latitude: location.latitude,
                             longitude: location.longitude,
                             userIDStr: userIdStr).save(on: req.db)
                        .transform(to: Response(status: .ok))
                } else {
                    return Location(latitude: location.latitude,
                                    longitude: location.longitude,
                                    userID: user.id!).save(on: req.db)
                        .transform(to: Response(status: .ok))
                }
        }
    }
}

extension LocationController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        routes.get("user", use: getUserLocation)
        routes.get("userGroup", use: getUserGroupLocation)
        routes.post("user", use: upload)
    }
}
