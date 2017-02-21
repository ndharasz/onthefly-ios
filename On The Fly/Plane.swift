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
    let maxRampWeight: Int
    let maxTakeoffWeight: Int
    let emptyWeight: Int
    let emptyWeightArm: Double
    let pilotSeatsArm: Double
    let rowArms: [Double]
    let frontBaggageArm: Double
    let aftBaggageArm: Double
    let fuelArm: Double
    let numSeats: Int
    let centerOfGravityEnvelope: [String:[Double]]
    let fireRef: FIRDatabaseReference?
    
    init(name: String, tailNumber: String, maxRampWeight: Int, maxTakeoffWeight: Int, emptyWeight: Int,
         emptyWeightArm: Double, pilotSeatsArm: Double, rowArms: [Double], frontBagArm: Double, aftBagArm: Double,
         fuelArm: Double, numSeats: Int, cogEnvelope: [String:[Double]]) {
        self.name = name
        self.tailNumber = tailNumber
        self.maxRampWeight = maxRampWeight
        self.maxTakeoffWeight = maxTakeoffWeight
        self.emptyWeight = emptyWeight
        self.emptyWeightArm = emptyWeightArm
        self.pilotSeatsArm = pilotSeatsArm
        self.rowArms = rowArms
        self.frontBaggageArm = frontBagArm
        self.aftBaggageArm = aftBagArm
        self.fuelArm = fuelArm
        self.numSeats = numSeats
        self.centerOfGravityEnvelope = cogEnvelope
        fireRef = nil
    }
    
    init(snapshot: FIRDataSnapshot) {
        let snapshotValue = snapshot.value as! [String: Any]
        self.name = snapshotValue["name"] as! String
        self.tailNumber = snapshotValue["tailNumber"] as! String
        self.maxRampWeight = snapshotValue["maxRampWeight"] as! Int
        self.maxTakeoffWeight = snapshotValue["maxTakeoffWeight"] as! Int
        self.emptyWeight = snapshotValue["emptyWeight"] as! Int
        self.emptyWeightArm = snapshotValue["emptyWeightArm"] as! Double
        self.pilotSeatsArm = snapshotValue["pilotSeatsArm"] as! Double
        self.rowArms = snapshotValue["rowArms"] as! [Double]
        self.frontBaggageArm = snapshotValue["frontBaggageArm"] as! Double
        self.aftBaggageArm = snapshotValue["aftBaggageArm"] as! Double
        self.fuelArm = snapshotValue["fuelArm"] as! Double
        self.numSeats = snapshotValue["numSeats"] as! Int
        self.centerOfGravityEnvelope = snapshotValue["centerOfGravityEnvelope"] as! [String:[Double]]
        self.fireRef = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            "name": name,
            "tailNumber": tailNumber,
            "maxRampWeight": maxRampWeight,
            "maxTakeoffWeight": maxTakeoffWeight,
            "emptyWeight": emptyWeight,
            "emptyWeightArm": emptyWeightArm,
            "pilotSeatsArm": pilotSeatsArm,
            "rowArms": rowArms,
            "frontBaggageArm": frontBaggageArm,
            "aftBaggageArm": aftBaggageArm,
            "fuelArm": fuelArm,
            "numSeats": numSeats,
            "centerOfGravityEnvelope": centerOfGravityEnvelope
        ]
    }
    
    func longName() -> String {
        return name + " " + tailNumber
    }
    
}
