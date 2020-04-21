//
//  File.swift
//  
//
//  Created by YanQi on 2020/04/21.
//

import Vapor
import Fluent

final class User: Model, Content {
    static let schema = "users"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "mailAddress")
    var mailAddress: String
    
    @Field(key: "passWord")
    var passWord: String

    @Timestamp(key: "createdAt", on: .create)
    var createdAt: Date?

    @Timestamp(key: "updatedAt", on: .update)
    var updatedAt: Date?
    
    init() {}
    
    init(mailAddress: String, passWord: String) {
        self.mailAddress = mailAddress
        self.passWord = passWord
    }
}
