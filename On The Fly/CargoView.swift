//
//  CargoView.swift
//  On The Fly
//
//  Created by Scott Higgins on 2/20/17.
//  Copyright © 2017 Team 152 - Easily The Best. All rights reserved.
//

import UIKit

class CargoView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    @IBOutlet weak var mainLabel: UILabel!
    
    init() {
        super.init()
        
        let editPage = self.superview?.superview as! EditFlightViewController
        self.mainLabel.text = "\(editPage.passengers.count)"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
