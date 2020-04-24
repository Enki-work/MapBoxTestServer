//
//  File.swift
//  
//
//  Created by YanQi on 2020/04/24.
//

import Fluent

struct CreateUserGroup: Migration {

    func prepare(on database: Database) -> EventLoopFuture<Void> {
        let model = UserGourp()
        return database.schema(UserGourp.schema)
            .id()
            .field(.string(model.$user.name), .string, .required)
            .field(.string(model.$group.name), .string, .required)
            .field(model.$createdAt.field.key, .datetime)
            .field(model.$updatedAt.field.key, .datetime)
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema(User.schema).delete()
    }
}
