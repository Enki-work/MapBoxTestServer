//
//  File.swift
//  
//
//  Created by YanQi on 2020/04/21.
//

import Vapor
import Fluent

final class BaseUser: Content {
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
    
    @Field(key: "token")
    var token: String?

    @Timestamp(key: "createdAt", on: .create)
    var createdAt: Date?

    @Timestamp(key: "updatedAt", on: .update)
    var updatedAt: Date?
    
    @Siblings(through: UserGourp.self, from: \.$user, to: \.$group)
    var group: [Group]
    
    init() {}
    
    init(mailAddress: String,
         passWord: String,
         groupId: UUID? = nil) {
        self.mailAddress = mailAddress
        self.passWord = passWord
//        self.$group.id = userID
        //TODO:仮token
        self.token = mailAddress + passWord
    }
}
