//
//  File.swift
//  
//
//  Created by YanQi on 2020/04/21.
//

import Fluent

struct CreateUser: Migration {

    func prepare(on database: Database) -> EventLoopFuture<Void> {
        let model = User()
        return database.schema(User.schema)
            .id()
            .field(model.$mailAddress.key, .string, .required)
            .unique(on: model.$mailAddress.key)
            .field(model.$passWord.key, .string, .required)
            .field(model.$isAdmin.key, .bool, .required)
            .field(model.$token.key, .string, .required)
            .field(model.$name.key, .string)
            .field(model.$createdAt.field.key, .datetime)
            .field(model.$updatedAt.field.key, .datetime)
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema(User.schema).delete()
    }
}
