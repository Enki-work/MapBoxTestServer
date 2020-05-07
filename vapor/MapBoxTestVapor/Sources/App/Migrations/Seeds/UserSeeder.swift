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
        [User(mailAddress: "mapbox@123.com", passWord: "mapbox", isAdmin: true),
           User(mailAddress: "mapbox2@123.com", passWord: "mapbox", isAdmin: true),
           User(mailAddress: "test1@123.com", passWord: "mapbox", isAdmin: false),
           User(mailAddress: "test2@123.com", passWord: "mapbox", isAdmin: false),
           User(mailAddress: "test3@123.com", passWord: "mapbox", isAdmin: false)]
        .map({ $0.save(on: database).transform(to: ()) })
        .flatten(on: database.eventLoop)
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        return User.query(on: database).delete()
    }
}
