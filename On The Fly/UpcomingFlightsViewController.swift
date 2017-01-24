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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(UpcomingFlightsViewController.handleTap))
        let tapRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(UpcomingFlightsViewController.handleTap))
        let tapRecognizer3 = UITapGestureRecognizer(target: self, action: #selector(UpcomingFlightsViewController.handleTap))
        let tapRecognizer4 = UITapGestureRecognizer(target: self, action: #selector(UpcomingFlightsViewController.handleTap))
        

        flightLabel1.addGestureRecognizer(tapRecognizer1)
        flightLabel2.addGestureRecognizer(tapRecognizer2)
        flightLabel3.addGestureRecognizer(tapRecognizer3)
        flightLabel4.addGestureRecognizer(tapRecognizer4)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func handleTap(gestureRecognizer: UITapGestureRecognizer) {
        print("tapped")
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
