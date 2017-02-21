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
    
    var plane: String
    var departAirport: String
    var arriveAirport: String
    var date: String
    var time: String
    
    var startFuel: Double
    var flightTime: Int
    var fuelFlow: Double
    var seatWeights: [String:Double]
    var frontBaggageWeight: Int
    var aftBaggageWeight: Int
    var taxiFuelBurn: Int
    
    let userid: String
    let fireRef: FIRDatabaseReference?
    
    init(plane: String, dptArpt: String, arvArpt: String, date: String, time: String, uid: String,
         startFuel: Double, flightTime: Int, fuelFlow: Double, seatWeights: [String:Double],
         frontBagWeight: Int, aftBagWeight: Int, taxiBurn: Int) {
        self.plane = plane
        self.departAirport = dptArpt
        self.arriveAirport = arvArpt
        self.date = date
        self.time = time
        self.startFuel = startFuel
        self.flightTime = flightTime
        self.fuelFlow = fuelFlow
        self.seatWeights = seatWeights
        self.frontBaggageWeight = frontBagWeight
        self.aftBaggageWeight = aftBagWeight
        self.taxiFuelBurn = taxiBurn
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
        self.startFuel = snapshotValue["startFuel"] as! Double
        self.flightTime = snapshotValue["flightTime"] as! Int
        self.fuelFlow = snapshotValue["fuelFlow"] as! Double
        self.seatWeights = snapshotValue["seatWeights"] as! [String:Double]
        self.frontBaggageWeight = snapshotValue["frontBaggageWeight"] as! Int
        self.aftBaggageWeight = snapshotValue["aftBaggageWeight"] as! Int
        self.taxiFuelBurn = snapshotValue["taxiFuelBurn"] as! Int
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
            "startFuel": startFuel,
            "flightTime": flightTime,
            "fuelFlow": fuelFlow,
            "seatWeights": seatWeights,
            "frontBaggageWeight": frontBaggageWeight,
            "aftBaggageWeight": aftBaggageWeight,
            "taxiFuelBurn": taxiFuelBurn,
            "userid": userid
        ]
    }
    
}
