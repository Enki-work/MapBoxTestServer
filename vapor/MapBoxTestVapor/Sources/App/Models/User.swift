//
//  File.swift
//  
//
//  Created by YanQi on 2020/04/21.
//

import Vapor
import Fluent

final class UserRequest: Content {
    var mailAddress: String
    var passWord: String
}

final class User: Model, Content {
    static let schema = "users"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "mailAddress")
    var mailAddress: String
    
    @Field(key: "passWord")
    var passWord: String

    @Field(key: "name")
    var name: String
    
    @Field(key: "token")
    var token: String?

    @Timestamp(key: "createdAt", on: .create)
    var createdAt: Date?

    @Timestamp(key: "updatedAt", on: .update)
    var updatedAt: Date?
    
    @Siblings(through: UserGroup.self, from: \.$user, to: \.$group)
    var groups: [Group]

    @Children(for: \.$user)
    var locations: [Location]
    
    init() {}
    
    init(mailAddress: String,
         passWord: String,
         groupId: UUID? = nil) {
        self.mailAddress = mailAddress
        self.passWord = passWord
        //TODO:　仮name
        self.name = String(mailAddress.split(separator: "@").first ?? "")
        self.token = ""
    }
    
    func createToken() -> User {
        //TODO:仮token
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyyMMddHHmmss"
        self.token = mailAddress + passWord + dateFormatter.string(from: Date())
        return self
    }
    
    func removeToken() -> User {
        //TODO:仮token
        self.token = ""
        return self
    }
}
