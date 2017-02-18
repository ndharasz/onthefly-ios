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
    let tailNumber: String
    let dryWeight: Double
    let frontBaggageArm: Double
    let rearBaggageArm: Double
    let wingBaggageArm: Double
    let pilotSeatsArm: Double
    let rowArms: [Double]
    let fuelArm: Double
    let auxTankArm: Double
    let fireRef: FIRDatabaseReference?
    
    init(name: String, tailNumber: String, dryWeight: Double, frontBagArm: Double, rearBagArm: Double, wingBagArm: Double, pilotArm: Double, rowArms: [Double], fuelArm: Double, auxTankArm: Double) {
        self.name = name
        self.tailNumber = tailNumber
        self.dryWeight = dryWeight
        self.frontBaggageArm = frontBagArm
        self.rearBaggageArm = rearBagArm
        self.wingBaggageArm = wingBagArm
        self.pilotSeatsArm = pilotArm
        self.rowArms = rowArms
        self.fuelArm = fuelArm
        self.auxTankArm = auxTankArm
        fireRef = nil
    }
    
    init(snapshot: FIRDataSnapshot) {
        let snapshotValue = snapshot.value as! [String: Any]
        self.dryWeight = snapshotValue["dryWeight"] as! Double
        self.frontBaggageArm = snapshotValue["frontBaggageArm"] as! Double
        self.rearBaggageArm = snapshotValue["rearBaggageArm"] as! Double
        self.wingBaggageArm = snapshotValue["wingBaggageArm"] as! Double
        self.pilotSeatsArm = snapshotValue["pilotSeatsArm"] as! Double
        self.rowArms = snapshotValue["rowArms"] as! [Double]
        self.fuelArm = snapshotValue["fuelArm"] as! Double
        self.auxTankArm = snapshotValue["auxTankArm"] as! Double
        self.name = snapshotValue["name"] as! String
        self.tailNumber = snapshotValue["tailNumber"] as! String
        self.fireRef = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            "name": name,
            "tailNumber": tailNumber,
            "dryWeight": dryWeight,
            "frontBaggageArm": frontBaggageArm,
            "rearBaggageArm": rearBaggageArm,
            "wingBaggageArm": wingBaggageArm,
            "pilotSeatsArm": pilotSeatsArm,
            "rowArms": rowArms,
            "fuelArm": fuelArm,
            "auxTankArm": auxTankArm
        ]
    }
    
    func longName() -> String {
        return name + " " + tailNumber
    }
    
}
