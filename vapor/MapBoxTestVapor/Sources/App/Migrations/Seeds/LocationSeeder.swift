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
            locations.append(contentsOf: [Location.init(latitude: 35.495236, longitude: 139.602820, userID: users[0].id!, userName: users[0].name),
                                          Location.init(latitude: 35.498177, longitude: 139.599793, userID: users[1].id!, userName: users[1].name),
                                          Location.init(latitude: 35.428308, longitude: 139.637553, userID: users[2].id!, userName: users[2].name)])
            locations.append(contentsOf: [Location.init(latitude: 35.595236, longitude: 139.602820, userID: users[3].id!, userName: users[3].name),
                                          Location.init(latitude: 35.598177, longitude: 139.599793, userID: users[4].id!, userName: users[4].name)])
            return locations.map { $0.save(on: database) }.flatten(on: database.eventLoop)
        })
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        return Group.query(on: database).delete()
    }
}
