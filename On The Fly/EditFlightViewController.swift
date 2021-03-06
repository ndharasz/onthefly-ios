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
    @IBOutlet weak var flightDetailsContainerView: UIView!
    @IBOutlet weak var departureAirportLabel: UILabel!
    @IBOutlet weak var arrivalAirportLabel: UILabel!
    
    var flight: Flight?
    var plane: Plane?
    var passengers: [(name: String, weight: Double)] = []
    var initialSelectedIndexPath: IndexPath?
    
    var issueWithFlight: Bool = false {
        didSet {
            self.createWarnings()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let thisFlight = flight {
            // Assign a plane object to this field for ease in calculations
            for each in GlobalVariables.sharedInstance.planeArray {
                if each.tailNumber == thisFlight.plane {
                    self.plane = each
                }
            }
        }
        
        self.applyUserInterfaceChanges()
        
        self.loadPassengers()
        
        self.updateTitleLabel()

        self.checkPlaneErrors()

        let longPressGesture : UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(EditFlightViewController.handleLongGesture(_:)))
        self.passengerCollectionView.addGestureRecognizer(longPressGesture)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(EditFlightViewController.swipedRight(_:)))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(EditFlightViewController.swipedLeft(_:)))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)

    }
    
    func loadPassengers() {
        if let thisFlight = flight {
            
            for _ in 0...(plane!.numSeats - 1) {
                let emptySeat = (name: "Empty", weight: 0.0)
                passengers.append(emptySeat)
            }
            
            if thisFlight.passengers != nil {
                let seatCongif = thisFlight.passengers!.sorted(by: { $0.0 < $1.0 })
                for (seatKey, seatData) in seatCongif {
                    let index = Int(seatKey.components(separatedBy: CharacterSet.decimalDigits.inverted).joined())! - 1
                    let newPassenger = (name: seatData["name"] as! String, weight: seatData["weight"] as! Double)
                    passengers.remove(at: index)
                    passengers.insert(newPassenger , at: index)
                }
            }
        }
    }
    
    func updateTitleLabel() {
        self.departureAirportLabel.text = "\(flight!.departAirport)"
        self.departureAirportLabel.sizeToFit()
        self.arrivalAirportLabel.text = "\(flight!.arriveAirport)"
        self.arrivalAirportLabel.sizeToFit()
    }
    
    func saveNewSeatConfig() {
        if let thisFlight = flight {
            let flightref = thisFlight.fireRef
            var newConfig: [String:[String:Any]] = [:]
            for i in 0...passengers.count-1 {
                let seat = passengers[i]
                if seat.name != "Empty" {
                    newConfig["seat\(i+1)"] = ["name": seat.name, "weight": seat.weight]
                }
            }
            let updates = ["passengers": newConfig]
            flightref?.updateChildValues(updates)
            self.flight?.passengers = newConfig
            self.checkPlaneErrors()
        }
    }
    
    // Check if plane is overweight and check for CoG errors
    func checkPlaneErrors() {
        do {
            try self.flight!.checkValidFlight(plane: plane!)
            self.issueWithFlight = false
        } catch FlightErrors.tooHeavyOnRamp {
            self.issueWithFlight = true
            Toast.showNegativeMessage(message: "Takeoff Weight Too High")
        } catch FlightErrors.invalidCenterOfGravity {
            self.issueWithFlight = true
            Toast.showNegativeMessage(message: "Center of Gravity Outside of Bounds")
        } catch FlightErrors.invalidLandingCog {
            self.issueWithFlight = true
            Toast.showNegativeMessage(message: "Invalid Landing Center of Gravity")
        } catch FlightErrors.invalidTakeoffCog {
            self.issueWithFlight = true
            Toast.showNegativeMessage(message: "Invalid Takeoff Center of Gravity")
        } catch FlightErrors.noStartingFuel {
            self.issueWithFlight = true
            Toast.showNegativeMessage(message: "Flight Currently Has No Fuel")
        } catch FlightErrors.insufficientFuel {
            self.issueWithFlight = true
            Toast.showNegativeMessage(message: "Insufficient Fuel for Planned Flight")
        } catch {
            self.issueWithFlight = true
            Toast.showNegativeMessage(message: "Flight Cannot Fly")
        }
        
    }
    
    // Visual feedback to user that there is something wrong with the flight
    func createWarnings() {
        if (self.issueWithFlight) {
            self.cargoContainerView.layer.borderColor = UIColor.red.cgColor
            self.passengerCollectionView.layer.borderColor = UIColor.red.cgColor
            self.flightDetailsContainerView.layer.borderColor = UIColor.red.cgColor
        } else {
            self.cargoContainerView.layer.borderColor = UIColor.white.cgColor
            self.passengerCollectionView.layer.borderColor = UIColor.white.cgColor
            self.flightDetailsContainerView.layer.borderColor = UIColor.white.cgColor
        }
    }
    
    // MARK: - Segment View Control
    
    @IBAction func segmentControlChanged(_ sender: Any) {
        updateVisibleViews()
    }
    
    func swipedLeft(_ gesture: UIGestureRecognizer) {
        switch self.segmentControl.selectedSegmentIndex {
            case 0:
                segmentControl.selectedSegmentIndex = 1
            case 1:
                segmentControl.selectedSegmentIndex = 2
            default:
                break
        }
        updateVisibleViews()
    }
    
    func swipedRight(_ gesture: UIGestureRecognizer) {
        switch self.segmentControl.selectedSegmentIndex {
        case 2:
            segmentControl.selectedSegmentIndex = 1
        case 1:
            segmentControl.selectedSegmentIndex = 0
        default:
            break
        }
        updateVisibleViews()
    }
    
    func updateVisibleViews() {
        if segmentControl.selectedSegmentIndex == 0 {
            // Flight Details view
            self.flightDetailsContainerView.isHidden = false
            self.passengerCollectionView.isHidden = true
            self.cargoContainerView.isHidden = true
        } else if segmentControl.selectedSegmentIndex == 1 {
            // Passenger seat view
            self.flightDetailsContainerView.isHidden = true
            self.passengerCollectionView.isHidden = false
            self.cargoContainerView.isHidden = true
        } else {
            // Cargo View
            self.flightDetailsContainerView.isHidden = true
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
        cell.nameLabel.textColor = UIColor.white
        cell.weightLabel.textColor = UIColor.white
        if cellPassenger.name == "Empty" {
            cell.nameLabel.text = "Add Passenger"
            cell.weightLabel.text = ""
        } else {
            cell.nameLabel.text = cellPassenger.name
            cell.weightLabel.text = "\(cellPassenger.weight)"
        }
        cell.layer.cornerRadius = 7
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        passengerSelected(passengerIndex: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if sourceIndexPath.row == 0 || sourceIndexPath.row == 1 {
            if destinationIndexPath.row == 0 || destinationIndexPath.row == 1 {
                let temp = passengers.remove(at: sourceIndexPath.item)
                passengers.insert(temp, at: destinationIndexPath.item)
                self.passengerCollectionView.reloadData()
                let standardNames: [String] = ["Pilot", "Co-Pilot"]
                
                if standardNames.contains(self.passengers[0].name) {
                    self.passengers[0].name = "Pilot"
                }
                
                if standardNames.contains(self.passengers[1].name) {
                    self.passengers[1].name = "Co-Pilot"
                }
                self.passengerCollectionView.reloadData()
            } else {
                Toast.showNegativeMessage(message: "Cannot move pilots to passenger seating")
                self.passengerCollectionView.reloadData()
            }
        } else {
            if destinationIndexPath.row != 0 && destinationIndexPath.row != 1 {
                let temp = passengers.remove(at: sourceIndexPath.item)
                passengers.insert(temp, at: destinationIndexPath.item)
                self.passengerCollectionView.reloadData()
            } else {
                Toast.showNegativeMessage(message: "Cannot move passengers to pilot seating")
                self.passengerCollectionView.reloadData()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numRows = Double(self.passengers.count) / 2.0
        let availableHeight = Double(self.passengerCollectionView.frame.height) - 2 * GlobalVariables.sharedInstance.collectionViewSpacing - GlobalVariables.sharedInstance.collectionViewSpacing * (numRows - 1.0)
        let cellHeight = Double(availableHeight) / numRows
        let availableWidth = Double(self.passengerCollectionView.frame.width) - 3 * (GlobalVariables.sharedInstance.collectionViewSpacing + 5.0)
        let cellWidth = Double(availableWidth) / 2
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func passengerSelected(passengerIndex: Int) {
        
        var alertController = UIAlertController()
        
        if isSeatEmpty(index: passengerIndex) {
            alertController = UIAlertController(title: "Add New Passenger", message: "", preferredStyle: .alert)
        } else {
            alertController = UIAlertController(title: "Edit Passenger", message: "", preferredStyle: .alert)
        }
        
        let saveAction = UIAlertAction(title: "Save", style: UIAlertActionStyle.default, handler: {
            alert -> Void in
            
            // need to add error handling
            let firstTextField = alertController.textFields![0] as UITextField
            guard let newWeight = Double(firstTextField.text!) else {
                print("invalid weight")
                return
            }
            
            let secondTextField = alertController.textFields![1] as UITextField
            guard let newName = secondTextField.text else {
                print("invalid name")
                return
            }
            
            let passenger = (name: newName, weight: newWeight)

            self.passengers[passengerIndex] = passenger
            self.passengerCollectionView.reloadData()
            
            // Update firebase with new configuration
            self.saveNewSeatConfig()

        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (action) in
            let newby = (name: "Empty", weight: 0.0)
            self.passengers[passengerIndex] = newby
            self.passengerCollectionView.reloadData()
            self.saveNewSeatConfig()
        }
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter Passenger Weight"
            textField.keyboardType = UIKeyboardType.decimalPad
            let tempPass = self.passengers[passengerIndex]
            if tempPass.name != "Empty" {
                textField.text = "\(tempPass.weight)"
            }
        }
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter Passenger Name"
            let tempPass = self.passengers[passengerIndex]
            if tempPass.name != "Empty" {
                textField.text = tempPass.name
            } else {
                switch passengerIndex {
                case 0:
                    textField.text = "Pilot"
                case 1:
                    textField.text = "Co-Pilot"
                default:
                    textField.text = "Pax"
                }
            }
        }
        
        if isSeatEmpty(index: passengerIndex) {
            alertController.addAction(saveAction)
            alertController.addAction(cancelAction)
        } else {
            alertController.addAction(saveAction)
            alertController.addAction(deleteAction)
        }
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    func isSeatEmpty(index: Int) -> Bool {
        let seatToCheck = self.passengers[index]
        return (seatToCheck.name == "Empty" && seatToCheck.weight == 0)
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
                
                let cell = self.passengerCollectionView.cellForItem(at: initialSelectedIndexPath!)
                cell?.backgroundColor = UIColor.blue
                
                break
            }
            
            self.initialSelectedIndexPath = selectedIndexPath
        
        case UIGestureRecognizerState.ended:
            guard self.passengerCollectionView.indexPathForItem(at: gesture.location(in: self.passengerCollectionView)) != nil else {
                let cell = self.passengerCollectionView.cellForItem(at: initialSelectedIndexPath!)
                cell?.backgroundColor = UIColor.blue
                self.passengerCollectionView.endInteractiveMovement()
                self.saveNewSeatConfig()
                self.passengerCollectionView.reloadData()
                
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
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        guard let flowLayout = self.passengerCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        flowLayout.invalidateLayout()
    }
    
    func applyUserInterfaceChanges() {
        let font = UIFont.systemFont(ofSize: 18)
        self.segmentControl.setTitleTextAttributes([NSFontAttributeName: font], for: .normal)
        self.segmentControlHeightConstant.constant = 40
        self.segmentControl.layer.borderWidth = 2
        self.segmentControl.layer.borderColor = UIColor.white.cgColor
        self.segmentControl.layer.cornerRadius = 6
        self.segmentControl.backgroundColor = Style.darkBlueAccentColor
        self.passengerCollectionView.layer.borderWidth = 3
        self.passengerCollectionView.layer.borderColor = UIColor.white.cgColor
        self.cargoContainerView.layer.borderWidth = 3
        self.cargoContainerView.layer.borderColor = UIColor.white.cgColor
        self.flightDetailsContainerView.layer.borderWidth = 3
        self.flightDetailsContainerView.layer.borderColor = UIColor.white.cgColor
        self.createReportButton.addBlackBorder()
        self.passengerCollectionView.isHidden = false
        self.cargoContainerView.isHidden = true
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "embedCargoView" {
            let cargoVC = segue.destination as! CargoViewController
            cargoVC.editFlightVC = self
        } else if segue.identifier == "embedFlightDetailsView" {
            let flightDetailsVC = segue.destination as! FlightDetailsViewController
            flightDetailsVC.editFlightVC = self
        } else if segue.identifier == "generateReportSegue" {
            let reportVC = segue.destination as! ReportGenerationViewController
            reportVC.flight = self.flight!
            reportVC.plane = self.plane!
        }
        
    }
    
}
