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
    @IBOutlet weak var frontSubtractButton: UIButton!
    @IBOutlet weak var frontAddButton: UIButton!
    @IBOutlet weak var frontClearButton: UIButton!
    
    @IBOutlet weak var aftCargoView: UIView!
    @IBOutlet weak var aftCargoLabel: UILabel!
    @IBOutlet weak var aftSubtractButton: UIButton!
    @IBOutlet weak var aftAddButton: UIButton!
    @IBOutlet weak var aftClearButton: UIButton!
    
    let btnDiameter: CGFloat = 50
    
    var frontWeight = 0
    var aftWeight = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        applyUserInterfaceChanges()
        
        self.frontWeight = self.editFlightVC.flight!.frontBaggageWeight
        self.aftWeight = self.editFlightVC.flight!.aftBaggageWeight
        
        self.updateLabels()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func updateLabels() {
        self.frontCargoLabel.text = "Front Cargo: \(self.editFlightVC.flight!.frontBaggageWeight) lbs"
        self.aftCargoLabel.text = "Aft Cargo: \(self.editFlightVC.flight!.aftBaggageWeight) lbs"
    }
    
    @IBAction func frontAddPressed(_ sender: Any) {
        let addToFront = UIAlertController(title: "Add weight", message: "", preferredStyle: UIAlertControllerStyle.alert)
        let saveAction = UIAlertAction(title: "Save", style: UIAlertActionStyle.default, handler: {
            alert -> Void in
            
            // need to add error handling
            let firstTextField = addToFront.textFields![0] as UITextField
            guard let newWeight = Int(firstTextField.text!) else {
                print("invalid weight")
                return
            }
            
            self.frontWeight += newWeight
            
            //firebase call
            self.editFlightVC.flight?.frontBaggageWeight = self.frontWeight
            self.editFlightVC.flight?.updateFrontBaggageWeight()
            
            self.updateLabels()
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: {
            (action : UIAlertAction!) -> Void in
            addToFront.dismiss(animated: true, completion: nil)
        })
        
        addToFront.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter Baggage Weight (lbs)"
            textField.keyboardType = UIKeyboardType.numberPad
        }
        
        addToFront.addAction(saveAction)
        addToFront.addAction(cancelAction)
        self.present(addToFront, animated: true, completion: nil)
        
    }
    
    @IBAction func frontSubtractPressed(_ sender: Any) {
        let subtractFromFront = UIAlertController(title: "Subtract weight", message: "", preferredStyle: UIAlertControllerStyle.alert)
        let saveAction = UIAlertAction(title: "Save", style: UIAlertActionStyle.default, handler: {
            alert -> Void in
            
            // need to add error handling
            let firstTextField = subtractFromFront.textFields![0] as UITextField
            guard let newWeight = Int(firstTextField.text!) else {
                print("invalid weight")
                return
            }
            
            self.frontWeight -= newWeight
            
            //firebase call
            self.editFlightVC.flight?.frontBaggageWeight = self.frontWeight
            self.editFlightVC.flight?.updateFrontBaggageWeight()
            
            self.updateLabels()
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: {
            (action : UIAlertAction!) -> Void in
            subtractFromFront.dismiss(animated: true, completion: nil)
        })
        
        subtractFromFront.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter Baggage Weight to be removed(lbs)"
            textField.keyboardType = UIKeyboardType.decimalPad
        }
        
        subtractFromFront.addAction(saveAction)
        subtractFromFront.addAction(cancelAction)
        self.present(subtractFromFront, animated: true, completion: nil)
    }
    
    @IBAction func frontClearPressed(_ sender: Any) {
        let subtractFromFront = UIAlertController(title: "Clear Weight", message: "Are you sure you want to delete all weight?", preferredStyle: UIAlertControllerStyle.alert)
        let saveAction = UIAlertAction(title: "Save", style: UIAlertActionStyle.default, handler: {
            alert -> Void in
            
            self.frontWeight = 0
            
            //firebase call
            self.editFlightVC.flight?.frontBaggageWeight = self.frontWeight
            self.editFlightVC.flight?.updateFrontBaggageWeight()
            
            self.updateLabels()
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: {
            (action : UIAlertAction!) -> Void in
            
        })
        
        subtractFromFront.addAction(saveAction)
        subtractFromFront.addAction(cancelAction)
        self.present(subtractFromFront, animated: true, completion: nil)
    }
    
    @IBAction func aftAddPressed(_ sender: Any) {
        let addToAft = UIAlertController(title: "Add weight", message: "", preferredStyle: UIAlertControllerStyle.alert)
        let saveAction = UIAlertAction(title: "Save", style: UIAlertActionStyle.default, handler: {
            alert -> Void in
            
            // need to add error handling
            let firstTextField = addToAft.textFields![0] as UITextField
            guard let newWeight = Int(firstTextField.text!) else {
                print("invalid weight")
                return
            }
            
            self.aftWeight += newWeight
            
            //firebase call
            self.editFlightVC.flight?.aftBaggageWeight = self.aftWeight
            self.editFlightVC.flight?.updateAftBaggageWeight()
            
            self.updateLabels()
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: {
            (action : UIAlertAction!) -> Void in
            addToAft.dismiss(animated: true, completion: nil)
        })
        
        addToAft.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter Baggage Weight (lbs)"
            textField.keyboardType = UIKeyboardType.numberPad
        }
        
        addToAft.addAction(saveAction)
        addToAft.addAction(cancelAction)
        self.present(addToAft, animated: true, completion: nil)
    }
    
    @IBAction func aftClearPressed(_ sender: Any) {
        let subtractFromAft = UIAlertController(title: "Clear Weight", message: "Are you sure you want to delete all weight?", preferredStyle: UIAlertControllerStyle.alert)
        let saveAction = UIAlertAction(title: "Save", style: UIAlertActionStyle.default, handler: {
            alert -> Void in
            
            self.aftWeight = 0
            
            //firebase call
            self.editFlightVC.flight?.aftBaggageWeight = self.aftWeight
            self.editFlightVC.flight?.updateAftBaggageWeight()
            
            self.updateLabels()
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: {
            (action : UIAlertAction!) -> Void in
            
        })
        
        subtractFromAft.addAction(saveAction)
        subtractFromAft.addAction(cancelAction)
        self.present(subtractFromAft, animated: true, completion: nil)
    }
    
    @IBAction func aftSubtractPressed(_ sender: Any) {
        let subtractFromAft = UIAlertController(title: "Subtract weight", message: "", preferredStyle: UIAlertControllerStyle.alert)
        let saveAction = UIAlertAction(title: "Save", style: UIAlertActionStyle.default, handler: {
            alert -> Void in
            
            // need to add error handling
            let firstTextField = subtractFromAft.textFields![0] as UITextField
            guard let newWeight = Int(firstTextField.text!) else {
                print("invalid weight")
                return
            }
            
            self.aftWeight -= newWeight
            
            //firebase call
            self.editFlightVC.flight?.aftBaggageWeight = self.aftWeight
            self.editFlightVC.flight?.updateAftBaggageWeight()
            
            self.updateLabels()
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: {
            (action : UIAlertAction!) -> Void in
            subtractFromAft.dismiss(animated: true, completion: nil)
        })
        
        subtractFromAft.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter Baggage Weight to be removed(lbs)"
            textField.keyboardType = UIKeyboardType.decimalPad
        }
        
        subtractFromAft.addAction(saveAction)
        subtractFromAft.addAction(cancelAction)
        self.present(subtractFromAft, animated: true, completion: nil)
    }
    
    // MARK: - UI Style Changes
    
    func applyUserInterfaceChanges() {
        self.view.layer.cornerRadius = 8
        self.aftCargoView.layer.borderWidth = 2
        self.aftCargoView.layer.borderColor = UIColor.black.cgColor
        self.aftCargoView.backgroundColor = UIColor.gray
        self.frontCargoView.layer.borderWidth = 2
        self.frontCargoView.layer.borderColor = UIColor.black.cgColor
        self.frontCargoView.backgroundColor = UIColor.gray
        
        frontAddButton.layer.cornerRadius = 0.5 * btnDiameter
        frontAddButton.clipsToBounds = true
        frontAddButton.setTitle("+", for: .normal)
        frontAddButton.titleLabel?.setSizeFont(sizeFont: 40)
        frontAddButton.setTitleColor(UIColor.black, for: .normal)
        frontAddButton.layer.backgroundColor = UIColor.white.cgColor

        frontSubtractButton.layer.cornerRadius = 0.5 * btnDiameter
        frontSubtractButton.clipsToBounds = true
        frontSubtractButton.setTitle("-", for: .normal)
        frontSubtractButton.titleLabel?.setSizeFont(sizeFont: 40)
        frontSubtractButton.setTitleColor(UIColor.black, for: .normal)
        frontSubtractButton.layer.backgroundColor = UIColor.white.cgColor
       
        frontClearButton.setTitle("Clear", for: .normal)
        frontClearButton.titleLabel?.setSizeFont(sizeFont: 30)
//        frontClearButton.setTitleColor(UIColor.black, for: .normal)
        
        aftAddButton.layer.cornerRadius = 0.5 * btnDiameter
        aftAddButton.clipsToBounds = true
        aftAddButton.setTitle("+", for: .normal)
        aftAddButton.titleLabel?.setSizeFont(sizeFont: 40)
        aftAddButton.setTitleColor(UIColor.black, for: .normal)
        aftAddButton.layer.backgroundColor = UIColor.white.cgColor
        
        aftSubtractButton.layer.cornerRadius = 0.5 * btnDiameter
        aftSubtractButton.clipsToBounds = true
        aftSubtractButton.setTitle("-", for: .normal)
        aftSubtractButton.titleLabel?.setSizeFont(sizeFont: 40)
        aftSubtractButton.setTitleColor(UIColor.black, for: .normal)
        aftSubtractButton.layer.backgroundColor = UIColor.white.cgColor

//        aftClearButton.layer.cornerRadius = 0.5 * btnDiameter
//        aftClearButton.clipsToBounds = true
        aftClearButton.setTitle("Clear", for: .normal)
        aftClearButton.titleLabel?.setSizeFont(sizeFont: 30)
//        aftClearButton.setTitleColor(UIColor.black, for: .normal)
//        aftClearButton.layer.backgroundColor = UIColor.white.cgColor
    }

}
