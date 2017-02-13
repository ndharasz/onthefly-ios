//
//  Flight.swift
//  On The Fly
//
//  Created by Scott Higgins on 2/8/17.
//  Copyright © 2017 Team 152 - Easily The Best. All rights reserved.
//

import Foundation
import Firebase

struct Flight {
    
    let plane: String
    let departAirport: String
    let arriveAirport: String
    let date: String
    let time: String
    let userid: String
    let fireRef: FIRDatabaseReference?
    
    init(plane: String, dptArpt: String, arvArpt: String, date: String, time: String, uid: String) {
        self.plane = plane
        self.departAirport = dptArpt
        self.arriveAirport = arvArpt
        self.date = date
        self.time = time
        self.userid = uid
        self.fireRef = nil
    }
    
    init(snapshot: FIRDataSnapshot) {
        let snapshotValue = snapshot.value as! [String: Any]
        self.plane = snapshotValue["plane"] as! String
        self.departAirport = snapshotValue["departAirport"] as! String
        self.arriveAirport = snapshotValue["arriveAirport"] as! String
        self.date = snapshotValue["date"] as! String
        self.time = snapshotValue["time"] as! String
        self.userid = snapshotValue["userid"] as! String
        self.fireRef = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            "plane": plane,
            "departAirport": departAirport,
            "arriveAirport": arriveAirport,
            "date": date,
            "time": time,
            "userid": userid
        ]
    }
    
}
