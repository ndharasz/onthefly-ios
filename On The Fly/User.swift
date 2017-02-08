//
//  User.swift
//  On The Fly
//
//  Created by Scott Higgins on 2/8/17.
//  Copyright © 2017 Team 152 - Easily The Best. All rights reserved.
//

import Foundation
import Firebase

struct User {
    
    let uid: String
    let email: String
    let firstName: String
    let lastName: String
    let fireRef: FIRDatabaseReference?
    
    init(uid: String, email: String, first: String, last: String) {
        self.uid = uid
        self.email = email
        self.firstName = first
        self.lastName = last
        self.fireRef = nil
    }
    
    init(snapshot: FIRDataSnapshot) {
        let snapshotValue = snapshot.value as! [String: Any]
        self.uid = snapshot.key 
        self.email = snapshotValue["email"] as! String
        self.firstName = snapshotValue["firstName"] as! String
        self.lastName = snapshotValue["lastName"] as! String
        self.fireRef = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            "email": email,
            "firstName": firstName,
            "lastName": lastName
        ]
    }
    
}
