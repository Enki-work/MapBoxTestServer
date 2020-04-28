//
//  File.swift
//  
//
//  Created by YanQi on 2020/04/24.
//

import Fluent
import Vapor

struct GroupSeeder: Migration {
    
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return[Group(title: "テストグループA"),
               Group(title: "テストグループB"),
               Group(title: "テストグループC")]
            .map({ $0.save(on: database).transform(to: ()) })
            .flatten(on: database.eventLoop)
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        return Group.query(on: database).delete()
    }
}
