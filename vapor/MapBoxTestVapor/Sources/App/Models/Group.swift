//
//  File.swift
//  
//
//  Created by YanQi on 2020/04/24.
//

import Vapor
import Fluent

final class GroupRequest: Content {
    var token: String
}

final class Group: Model, Content {
    static let schema = "groups"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "title")
    var title: String

    @Timestamp(key: "createdAt", on: .create)
    var createdAt: Date?

    @Timestamp(key: "updatedAt", on: .update)
    var updatedAt: Date?

    @Siblings(through: UserGroup.self, from: \.$group, to: \.$user)
    var users: [User]

    init() { }

    init(id: UUID? = nil, title: String) {
        self.id = id
        self.title = title
    }
}
