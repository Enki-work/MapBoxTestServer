//
//  File.swift
//  
//
//  Created by YanQi on 2020/04/21.
//

import Fluent
import Vapor

func migrations(_ app: Application) throws {
    // MARK: User
    app.migrations.add(CreateUser())
    app.migrations.add(CreateGroup())
    app.migrations.add(CreateUserGroup())
    
    switch app.environment {
    case .development, .testing:
        app.migrations.add(UserSeeder())
        app.migrations.add(GroupSeeder())
        app.migrations.add(UserGroupSeeder())
        
        
    default:
        break
    }
}

