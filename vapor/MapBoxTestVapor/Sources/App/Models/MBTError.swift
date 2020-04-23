//
//  File.swift
//  
//
//  Created by YanQi on 2020/04/22.
//

import Vapor

struct MBTError: Content, Error {
    var errorCode: UInt
    var message: String
}
