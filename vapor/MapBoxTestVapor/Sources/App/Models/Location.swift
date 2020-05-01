//
//  File.swift
//
//
//  Created by YanQi on 2020/04/24.
//

import Vapor
import Fluent

final class LocationRequest: Content {
    var latitude: Double
    var longitude: Double
    var userIDStr: String?
    var token: String
}

final class Location: Model, Content {
    static let schema = "locations"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "latitude")
    var latitude: Double

    @Field(key: "longitude")
    var longitude: Double

    @Timestamp(key: "createdAt", on: .create)
    var createdAt: Date?

    @Timestamp(key: "updatedAt", on: .update)
    var updatedAt: Date?

//    @Siblings(through: UserGroup.self, from: \.$group, to: \.$user)
//    var users: [User]
    @Parent(key: "userID")
    var user: User

    init() { }

    init(id: UUID? = nil, latitude: Double, longitude: Double, userID: UUID) {
        self.id = id
        self.$user.id = userID
        self.latitude = latitude
        self.longitude = longitude
    }

    init(latitude: Double, longitude: Double, userIDStr: String) {
        if let userID = UUID.init(uuidString: userIDStr) {
            self.$user.id = userID
        }
        self.latitude = latitude
        self.longitude = longitude
    }
}
