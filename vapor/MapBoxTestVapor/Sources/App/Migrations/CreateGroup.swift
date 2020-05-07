//
//  File.swift
//
//
//  Created by YanQi on 2020/04/24.
//

import Fluent

struct CreateGroup: Migration {

    func prepare(on database: Database) -> EventLoopFuture<Void> {
        let model = Group()
        return database.schema(Group.schema)
            .id()
            .field(model.$title.key, .string, .required)
            .unique(on: model.$title.key)
            .field(model.$createdAt.field.key, .datetime)
            .field(model.$updatedAt.field.key, .datetime)
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema(Group.schema).delete()
    }
}
