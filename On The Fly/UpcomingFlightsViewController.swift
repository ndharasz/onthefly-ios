//
//  UpcomingFlightsViewController.swift
//  On The Fly
//
//  Created by Scott Higgins on 1/19/17.
//  Copyright © 2017 Team 152 - Easily The Best. All rights reserved.
//

import UIKit

class UpcomingFlightsViewController: UIViewController {

    @IBOutlet weak var flightLabel1: UILabel!
    @IBOutlet weak var flightLabel2: UILabel!
    @IBOutlet weak var flightLabel3: UILabel!
    @IBOutlet weak var flightLabel4: UILabel!
    
    var label1selected = false
    var label2selected = false
    var label3selected = false
    var label4selected = false
    
    let standardOffsetDistance: CGFloat = 15.00
    let verticalOffsetDistance: CGFloat = 75.00
    
    
    @IBOutlet weak var label2from1: NSLayoutConstraint!
    @IBOutlet weak var label3from2: NSLayoutConstraint!
    @IBOutlet weak var label4from3: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label1selected = false
        label2selected = false
        label3selected = false
        label4selected = false
        
        let tapRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(UpcomingFlightsViewController.handleTap1))
        let tapRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(UpcomingFlightsViewController.handleTap2))
        let tapRecognizer3 = UITapGestureRecognizer(target: self, action: #selector(UpcomingFlightsViewController.handleTap3))
        let tapRecognizer4 = UITapGestureRecognizer(target: self, action: #selector(UpcomingFlightsViewController.handleTap4))
        

        flightLabel1.addGestureRecognizer(tapRecognizer1)
        flightLabel2.addGestureRecognizer(tapRecognizer2)
        flightLabel3.addGestureRecognizer(tapRecognizer3)
        flightLabel4.addGestureRecognizer(tapRecognizer4)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Tap Gesture Recognizers
    
    func handleTap1(gestureRecognizer: UITapGestureRecognizer) {
        if label1selected {
            label1selected = false
            label2from1.constant = standardOffsetDistance
        } else {
            label1selected = true
            label2from1.constant = verticalOffsetDistance
        }
        
    }
    
    func handleTap2(gestureRecognizer: UITapGestureRecognizer) {
        if label2selected {
            label2selected = false
            label3from2.constant = standardOffsetDistance
        } else {
            label2selected = true
            label3from2.constant = verticalOffsetDistance
        }
        
    }
    
    func handleTap3(gestureRecognizer: UITapGestureRecognizer) {
        if label3selected {
            label3selected = false
            label4from3.constant = standardOffsetDistance
        } else {
            label3selected = true
            label4from3.constant = verticalOffsetDistance
        }
        
    }
    
    func handleTap4(gestureRecognizer: UITapGestureRecognizer) {
        if label4selected {
            label4selected = false
        } else {
            label4selected = true
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
