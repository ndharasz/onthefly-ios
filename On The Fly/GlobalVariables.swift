//
//  GlobalVariables.swift
//  On The Fly
//
//  Created by Scott Higgins on 2/11/17.
//  Copyright © 2017 Team 152 - Easily The Best. All rights reserved.
//

import Foundation

class GlobalVariables {
    
    var tripName = "Trip Name"
    var gallonsOfFeul = 0.0      // in gallons
    var planeArray: [Plane] = []
    
    
    static let sharedInstance = GlobalVariables()
}
