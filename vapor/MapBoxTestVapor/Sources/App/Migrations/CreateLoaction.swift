//
//  File.swift
//  
//
//  Created by YanQi on 2020/04/24.
//

import Fluent

struct CreateLoaction: Migration {

    func prepare(on database: Database) -> EventLoopFuture<Void> {
        let model = Location()
        return database.schema(Location.schema)
            .id()
            .field(model.$latitude.key, .double)
            .field(model.$longitude.key, .double)
            .field("userID", .string, .required)
            .field(model.$createdAt.field.key, .datetime)
            .field(model.$updatedAt.field.key, .datetime)
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema(Location.schema).delete()
    }
}
