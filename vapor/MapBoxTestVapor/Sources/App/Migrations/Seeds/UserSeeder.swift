//
//  File.swift
//  
//
//  Created by YanQi on 2020/04/21.
//

import Fluent
import Vapor

struct UserSeeder: Migration {
    let model = User(mailAddress: "mapbox@123.com", passWord: "mapbox")
    
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return model.save(on: database).transform(to: ())
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        return User.query(on: database)
            .filter(\.$mailAddress, .equal, model.mailAddress).first()
            .map{ $0?.delete(on: database) }.transform(to: ())
    }
}
