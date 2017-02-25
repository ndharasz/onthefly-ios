//
//  CargoViewController.swift
//  On The Fly
//
//  Created by Scott Higgins on 2/20/17.
//  Copyright © 2017 Team 152 - Easily The Best. All rights reserved.
//

import UIKit
import Firebase

class CargoViewController: UIViewController {
    
    var editFlightVC: EditFlightViewController!
    
    @IBOutlet weak var frontCargoView: UIView!
    @IBOutlet weak var frontCargoLabel: UILabel!
    @IBOutlet weak var frontAddButton: UIButton!
    
    
    @IBOutlet weak var aftCargoView: UIView!
    @IBOutlet weak var aftCargoLabel: UILabel!
    @IBOutlet weak var aftAddButton: UIButton!
    
    
    let btnDiameter: CGFloat = 60
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        applyUserInterfaceChanges()
        
        self.frontCargoLabel.text = "Front Cargo: \(self.editFlightVC.flight!.frontBaggageWeight) lbs"
        self.aftCargoLabel.text = "Aft Cargo: \(self.editFlightVC.flight!.frontBaggageWeight) lbs"

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UI Style Changes
    
    func applyUserInterfaceChanges() {
        self.view.layer.cornerRadius = 8
        self.aftCargoView.layer.borderWidth = 2
        self.aftCargoView.layer.borderColor = UIColor.black.cgColor
        self.aftCargoView.backgroundColor = UIColor.red
        self.frontCargoView.layer.borderWidth = 2
        self.frontCargoView.layer.borderColor = UIColor.black.cgColor
        self.frontCargoView.backgroundColor = UIColor.gray
        
        
        frontAddButton.layer.cornerRadius = 0.5 * btnDiameter
        frontAddButton.clipsToBounds = true
        frontAddButton.setTitle("+", for: .normal)
        frontAddButton.titleLabel?.setSizeFont(sizeFont: 40)
        frontAddButton.setTitleColor(UIColor.black, for: .normal)
        frontAddButton.layer.backgroundColor = UIColor.white.cgColor
        
        
        aftAddButton.layer.cornerRadius = 0.5 * btnDiameter
        aftAddButton.clipsToBounds = true
        aftAddButton.setTitle("+", for: .normal)
        aftAddButton.titleLabel?.setSizeFont(sizeFont: 40)
        aftAddButton.setTitleColor(UIColor.black, for: .normal)
        aftAddButton.layer.backgroundColor = UIColor.white.cgColor
    }

}
