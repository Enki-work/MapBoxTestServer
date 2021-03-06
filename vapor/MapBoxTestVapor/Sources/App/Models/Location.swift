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

    @Field(key: "userName")
    var userName: String?
    
    @Parent(key: "userID")
    var user: User

    init() { }

    init(id: UUID? = nil, latitude: Double, longitude: Double, userID: UUID, userName: String? = nil) {
        self.id = id
        self.$user.id = userID
        self.latitude = latitude
        self.longitude = longitude
        self.userName = userName
    }

    init(latitude: Double, longitude: Double, userIDStr: String, userName: String? = nil) {
        if let userID = UUID.init(uuidString: userIDStr) {
            self.$user.id = userID
        }
        self.latitude = latitude
        self.longitude = longitude
        self.userName = userName
    }
}
