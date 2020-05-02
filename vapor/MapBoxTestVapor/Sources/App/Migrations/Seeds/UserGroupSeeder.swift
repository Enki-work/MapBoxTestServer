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
                for group in groups {
                    switch usergroups.count {
                    case 0:
                        guard let userid = users[0].id, let groupid = group.id else { continue }
                        usergroups.append(UserGroup(userID: userid, groupID: groupid))
                    case 1:
                        guard let userid = users[0].id, let groupid = group.id else { continue }
                        usergroups.append(UserGroup(userID: userid, groupID: groupid))
                    case 2:
                        guard let userid = users[1].id, let groupid = group.id else { continue }
                        usergroups.append(UserGroup(userID: userid, groupID: groupid))
                    default:
                        break

                    }
                }
                return usergroups.map { $0.save(on: database) }.flatten(on: database.eventLoop)
        }
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        return Group.query(on: database).delete()
    }
}
