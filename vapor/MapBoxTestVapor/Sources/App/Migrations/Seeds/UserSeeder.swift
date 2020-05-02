//
//  File.swift
//  
//
//  Created by YanQi on 2020/04/21.
//

import Fluent
import Vapor

struct UserSeeder: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        [User(mailAddress: "mapbox@123.com", passWord: "mapbox"),
           User(mailAddress: "mapbox2@123.com", passWord: "mapbox")]
        .map({ $0.save(on: database).transform(to: ()) })
        .flatten(on: database.eventLoop)
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        return User.query(on: database).delete()
    }
}
