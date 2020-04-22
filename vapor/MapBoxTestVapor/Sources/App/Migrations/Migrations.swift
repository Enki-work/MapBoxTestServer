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
    
    switch app.environment {
    case .development, .testing:
        app.migrations.add(UserSeeder())
    default:
        break
    }
}

