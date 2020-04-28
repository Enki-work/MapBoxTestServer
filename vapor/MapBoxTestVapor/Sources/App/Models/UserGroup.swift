//
//  File.swift
//
//
//  Created by YanQi on 2020/04/24.
//

import Vapor
import Fluent
final class UserGroup: Model, Content {
    static let schema = "usergroups"

    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: "userID")
    var user: User
    
    @Parent(key: "groupID")
    var group: Group

    @Timestamp(key: "createdAt", on: .create)
    var createdAt: Date?

    @Timestamp(key: "updatedAt", on: .update)
    var updatedAt: Date?

    init() { }
    
    init(userID: UUID, groupID: UUID) {
        self.$group.id = groupID
        self.$user.id = userID
    }
}
