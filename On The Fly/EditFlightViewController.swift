//
//  EditFlightViewController.swift
//  On The Fly
//
//  Created by Scott Higgins on 1/25/17.
//  Copyright © 2017 Team 152 - Easily The Best. All rights reserved.
//

import UIKit
import Firebase

class EditFlightViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var passengerCollectionView: WiggleUICollectionView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var createReportButton: UIButton!
    
    @IBOutlet weak var segmentControlHeightConstant: NSLayoutConstraint!
    
    @IBOutlet weak var cargoContainerView: UIView!
    
    @IBOutlet weak var trashLabel: UIImageView!
    
    
    
    var flight: Flight?
    var plane: Plane?
    var passengers: [(name: String, weight: Double)] = []
    var initialSelectedIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let thisFlight = flight {
            // Assign a plane object to this field for ease in calculations
            for each in GlobalVariables.sharedInstance.planeArray {
                if each.longName() == thisFlight.plane {
                    self.plane = each
                }
            }
        }
        
        self.applyUserInterfaceChanges()
        
        self.loadPassengers()
        
        // Example of updating and saving to Firebase from this "EditFlight" screen
//        if let thisFlight = flight {
//            let updates = ["departAirport":"SLC"]
//            thisFlight.fireRef?.updateChildValues(updates)
//        }


        let longPressGesture : UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(EditFlightViewController.handleLongGesture(_:)))
        self.passengerCollectionView.addGestureRecognizer(longPressGesture)

    }
    
    func loadPassengers() {
        if let thisFlight = flight {
            let seatCongif = thisFlight.seatWeights.sorted(by: { $0.0 < $1.0 })
            for (_, seatData) in seatCongif {
                for (name, weight) in seatData {
                    let newPassenger = (name: name, weight: weight)
                    passengers.append(newPassenger)
                }
            }
        }
    }
    
    func saveNewSeatConfig() {
        if let thisFlight = flight {
            let flightref = thisFlight.fireRef
            var newConfig: [String:[String:Double]] = [:]
            for i in 0...passengers.count-1 {
                let seat = passengers[i]
                newConfig["seat\(i+1)"] = [seat.name: seat.weight]
            }
            let updates = ["seatWeights":newConfig]
            flightref?.updateChildValues(updates)
        }
    }
    
    @IBAction func segmentControlChanged(_ sender: Any) {
        let control = sender as! UISegmentedControl
        if control.selectedSegmentIndex == 0 {
            self.passengerCollectionView.isHidden = false
            self.cargoContainerView.isHidden = true
        } else {
            self.passengerCollectionView.isHidden = true
            self.cargoContainerView.isHidden = false
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: - Collection View Code
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return passengers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = passengerCollectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! PassengerCollectionViewCell
        cell.backgroundColor = Style.darkBlueAccentColor
        let cellPassenger = self.passengers[indexPath.row]
        cell.nameLabel.text = cellPassenger.name
        cell.nameLabel.textColor = UIColor.white
        cell.weightLabel.text = "\(cellPassenger.weight)"
        cell.weightLabel.textColor = UIColor.white
        cell.layer.cornerRadius = 7
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        passengerSelected(passengerIndex: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let temp = passengers.remove(at: sourceIndexPath.item)
        passengers.insert(temp, at: destinationIndexPath.item)
        self.passengerCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numRows = Double(self.passengers.count) / 2.0
        let availableHeight = Double(self.passengerCollectionView.frame.height) - 20.0 - 10.0 * (numRows - 1.0)
        let cellHeight = Double(availableHeight) / numRows
        return CGSize(width: 125, height: cellHeight)
    }
    
    func passengerSelected(passengerIndex: Int) {
        
        let editPassenger = UIAlertController(title: "Add New Name", message: "", preferredStyle: UIAlertControllerStyle.alert)
        
        let saveAction = UIAlertAction(title: "Save", style: UIAlertActionStyle.default, handler: {
            alert -> Void in
            
            // need to add error handling
            let firstTextField = editPassenger.textFields![0] as UITextField
            guard let newName = firstTextField.text else {
                print("invalid name")
                return
            }
            
            let secondTextField = editPassenger.textFields![1] as UITextField
            guard let newWeight = Double(secondTextField.text!) else {
                print("invalid weight")
                return
            }
            let passenger = (name: newName, weight: newWeight)

            self.passengers[passengerIndex] = passenger
            self.passengerCollectionView.reloadData()
            
            // Update firebase with new configuration
            self.saveNewSeatConfig()

        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: {
            (action : UIAlertAction!) -> Void in
            
        })
        
        editPassenger.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter Passenger Name"
            let tempPass = self.passengers[passengerIndex]
            if tempPass.name != "Empty" || tempPass.weight != 0.0 {
                textField.text = tempPass.name
            }
        }
        
        editPassenger.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter Passenger Weight"
            textField.keyboardType = UIKeyboardType.decimalPad
            let tempPass = self.passengers[passengerIndex]
            if tempPass.name != "Empty" || tempPass.weight != 0.0 {
                textField.text = "\(tempPass.weight)"
            }
        }
        
        editPassenger.addAction(saveAction)
        editPassenger.addAction(cancelAction)
        self.present(editPassenger, animated: true, completion: nil)
    }
    
    func handleLongGesture(_ gesture: UILongPressGestureRecognizer) {
        
        switch(gesture.state) {
            
        case UIGestureRecognizerState.began:
            guard let selectedIndexPath = self.passengerCollectionView.indexPathForItem(at: gesture.location(in: self.passengerCollectionView)) else {
                break
            }
            self.initialSelectedIndexPath = selectedIndexPath
            _ = self.passengerCollectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
        
        case UIGestureRecognizerState.changed:
            self.passengerCollectionView.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
            
            guard let selectedIndexPath = self.passengerCollectionView.indexPathForItem(at: gesture.location(in: self.passengerCollectionView)) else {
                
                if self.trashLabel.frame.contains(gesture.location(in: self.view)) {
                    let cell = self.passengerCollectionView.cellForItem(at: initialSelectedIndexPath!)
                    cell?.backgroundColor = UIColor.red
                    
                } else {
                    let cell = self.passengerCollectionView.cellForItem(at: initialSelectedIndexPath!)
                    cell?.backgroundColor = UIColor.blue
                }
                
                break
            }
            
            self.initialSelectedIndexPath = selectedIndexPath
        
        case UIGestureRecognizerState.ended:
            guard self.passengerCollectionView.indexPathForItem(at: gesture.location(in: self.passengerCollectionView)) != nil else {
                let cell = self.passengerCollectionView.cellForItem(at: initialSelectedIndexPath!)
                cell?.backgroundColor = UIColor.blue
                self.passengerCollectionView.endInteractiveMovement()
                self.saveNewSeatConfig()
                
                if self.trashLabel.frame.contains(gesture.location(in: self.view)) {
                    let newby = (name: "Empty", weight: 0.0)
                    passengers[(initialSelectedIndexPath?.row)!] = newby
                }
                
                self.passengerCollectionView.reloadData()
                self.saveNewSeatConfig()
                
                break
            }
            
            self.passengerCollectionView.endInteractiveMovement()
            
            // Update firebase with new configuration
            self.saveNewSeatConfig()
        default:
            self.passengerCollectionView.cancelInteractiveMovement()
        }
    }
    
    // MARK: - UI Stylistic Changes
    
    func applyUserInterfaceChanges() {
        self.passengerCollectionView.layer.cornerRadius = 8
        let font = UIFont.systemFont(ofSize: 22)
        self.segmentControl.setTitleTextAttributes([NSFontAttributeName: font], for: .normal)
        self.segmentControlHeightConstant.constant = 40
        self.segmentControl.layer.borderWidth = 2
        self.segmentControl.layer.borderColor = UIColor.white.cgColor
        self.segmentControl.layer.cornerRadius = 6
        self.segmentControl.backgroundColor = Style.darkBlueAccentColor
        self.createReportButton.addBlackBorder()
        self.passengerCollectionView.isHidden = false
        self.cargoContainerView.isHidden = true
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "embedCargoView" {
            let cargoVC = segue.destination as! CargoViewController
            cargoVC.editFlightVC = self
        }
        
    }
    
}
