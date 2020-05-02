//
//  File.swift
//
//
//  Created by YanQi on 2020/04/24.
//

import Fluent
import Vapor

struct LocationSeeder: Migration {

    func prepare(on database: Database) -> EventLoopFuture<Void> {
        User.query(on: database).all().flatMap({ (users) -> EventLoopFuture<Void> in
            var locations: [Location] = []
            if let userId = users.first?.id {
                locations.append(contentsOf: [Location.init(latitude: 35.495236, longitude: 139.602820, userID: userId),
                                 Location.init(latitude: 35.498177, longitude: 139.599793, userID: userId),
                                 Location.init(latitude: 35.428308, longitude: 139.637553, userID: userId)])
            }
            
            if let userId = users[1].id {
                locations.append(contentsOf: [Location.init(latitude: 35.595236, longitude: 139.602820, userID: userId),
                                 Location.init(latitude: 35.598177, longitude: 139.599793, userID: userId)])
            }
            return locations.map { $0.save(on: database) }.flatten(on: database.eventLoop)
        })
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        return Group.query(on: database).delete()
    }
}
