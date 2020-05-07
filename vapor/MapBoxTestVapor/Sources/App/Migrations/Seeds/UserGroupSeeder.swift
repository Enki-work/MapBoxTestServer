//
//  File.swift
//
//
//  Created by YanQi on 2020/04/24.
//

import Fluent
import Vapor

struct UserGroupSeeder: Migration {

    func prepare(on database: Database) -> EventLoopFuture<Void> {
        User.query(on: database).all().and(Group.query(on: database).all())
            .flatMap { (arg0) -> EventLoopFuture<Void> in
                let (users, groups) = arg0
                var usergroups: [UserGroup] = []
                usergroups.append(UserGroup(userID: users[0].id!, groupID: groups[0].id!))
                usergroups.append(UserGroup(userID: users[1].id!, groupID: groups[0].id!))
                usergroups.append(UserGroup(userID: users[2].id!, groupID: groups[0].id!))
                usergroups.append(UserGroup(userID: users[3].id!, groupID: groups[0].id!))
                usergroups.append(UserGroup(userID: users[4].id!, groupID: groups[0].id!))
                usergroups.append(UserGroup(userID: users[1].id!, groupID: groups[1].id!))
                usergroups.append(UserGroup(userID: users[2].id!, groupID: groups[1].id!))
                usergroups.append(UserGroup(userID: users[3].id!, groupID: groups[1].id!))
                usergroups.append(UserGroup(userID: users[1].id!, groupID: groups[2].id!))
                return usergroups.map { $0.save(on: database) }.flatten(on: database.eventLoop)
        }
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        return Group.query(on: database).delete()
    }
}
