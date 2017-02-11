//
//  Plane.swift
//  On The Fly
//
//  Created by Scott Higgins on 2/11/17.
//  Copyright © 2017 Team 152 - Easily The Best. All rights reserved.
//

import Foundation
import Firebase

struct Plane {
    
    let name: String
    let fireRef: FIRDatabaseReference?
    
    init(name: String) {
        self.name = name
        fireRef = nil
    }
    
    init(snapshot: FIRDataSnapshot) {
        let snapshotValue = snapshot.value as! [String: Any]
        self.name = snapshotValue["name"] as! String
        self.fireRef = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            "name": name
        ]
    }
    
}
