//
//  Followers.swift
//  AudioSound
//
//  Created on 25/05/23.
//

import Foundation
import ParseSwift

struct Followers: ParseObject {
    // These are required by ParseObject
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?
    var originalData: Data?

    // custom properties.
    var user:User?
    var followinguser: User?
}
