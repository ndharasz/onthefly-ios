//
//  EditFlightViewController.swift
//  On The Fly
//
//  Created by Scott Higgins on 1/25/17.
//  Copyright © 2017 Team 152 - Easily The Best. All rights reserved.
//

import UIKit

class EditFlightViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var passengerCollectionView: UICollectionView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var createReportButton: UIButton!
    
    @IBOutlet weak var segmentControlHeightConstant: NSLayoutConstraint!
    
    
    var flight: Flight?
    var plane: Plane?
    var passengers: [(name: String, weight: Int)] = []
    var initialSelectedIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let thisFlight = flight {
            print(thisFlight.toAnyObject())
            
            // Assign a plane object to this field for ease in calculations
            for each in GlobalVariables.sharedInstance.planeArray {
                if each.longName() == thisFlight.plane {
                    self.plane = each
                }
            }
        }
        
        self.applyUserInterfaceChanges()

        
        // FOR TESTING ONLY!!!!!
        passengers.append((name: "Scott", weight: 180))
        passengers.append((name: "Moose", weight: 35))
        passengers.append((name: "Traci", weight: 150))
        passengers.append((name: "Sophia", weight: 150))
        passengers.append((name: "Sami", weight: 115))
        passengers.append((name: "Scottie", weight: 180))
//        passengers.append((name: "Empty", weight: 0))
//        passengers.append((name: "Purse", weight: 3))
        
        // Example of updating and saving to Firebase from this "EditFlight" screen
//        if let thisFlight = flight {
//            let updates = ["departAirport":"SLC"]
//            thisFlight.fireRef?.updateChildValues(updates)
//        }

        
//        let addButton1 = UIButton(type: .custom)
//        addButton1.frame = CGRect(x: 130, y: 80, width: 60, height: 60)
//        addButton1.layer.cornerRadius = 0.5 * addButton1.bounds.size.width
//        addButton1.clipsToBounds = true
//        addButton1.setTitle("+", for: .normal)
//        addButton1.titleLabel?.setSizeFont(sizeFont: 40)
//        addButton1.setTitleColor(UIColor.black, for: .normal)
//        addButton1.layer.backgroundColor = UIColor.white.cgColor
//        frontCargoView.addSubview(addButton1)
//        
//        let addButton2 = UIButton(type: .custom)
//        addButton2.frame = CGRect(x: 130, y: 80, width: 60, height: 60)
//        addButton2.layer.cornerRadius = 0.5 * addButton1.bounds.size.width
//        addButton2.clipsToBounds = true
//        addButton2.setTitle("+", for: .normal)
//        addButton2.titleLabel?.setSizeFont(sizeFont: 40)
//        addButton2.setTitleColor(UIColor.black, for: .normal)
//        addButton2.layer.backgroundColor = UIColor.white.cgColor
//        rearCargoView.addSubview(addButton2)
        
        let longPressGesture : UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(EditFlightViewController.handleLongGesture(_:)))
        self.passengerCollectionView.addGestureRecognizer(longPressGesture)

    }
    
    @IBAction func segmentControlChanged(_ sender: Any) {
        let control = sender as! UISegmentedControl
        print(control.selectedSegmentIndex)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        let passenger = self.passengers[indexPath.row]
        print(passenger.name)
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
    
    func handleLongGesture(_ gesture: UILongPressGestureRecognizer) {
        
        switch(gesture.state) {
            
        case UIGestureRecognizerState.began:
            guard let selectedIndexPath = self.passengerCollectionView.indexPathForItem(at: gesture.location(in: self.passengerCollectionView)) else {
                break
            }
            self.initialSelectedIndexPath = selectedIndexPath
            let cell = self.passengerCollectionView.cellForItem(at: selectedIndexPath)
            cell?.backgroundColor = UIColor.red
            self.passengerCollectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
        
        case UIGestureRecognizerState.changed:
            self.passengerCollectionView.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
        
        case UIGestureRecognizerState.ended:
            guard let selectedIndexPath = self.passengerCollectionView.indexPathForItem(at: gesture.location(in: self.passengerCollectionView)) else {
                let cell = self.passengerCollectionView.cellForItem(at: initialSelectedIndexPath!)
                cell?.backgroundColor = UIColor.blue
                self.passengerCollectionView.endInteractiveMovement()
                break
            }
            let cell = self.passengerCollectionView.cellForItem(at: selectedIndexPath)
            cell?.backgroundColor = UIColor.blue
            self.passengerCollectionView.endInteractiveMovement()
        default:
            self.passengerCollectionView.cancelInteractiveMovement()
        }
    }
    
    // MARK: - UI Stylistic Changes
    
    func applyUserInterfaceChanges() {
        self.passengerCollectionView.layer.cornerRadius = 8
        self.passengerCollectionView.isHidden = false
        let font = UIFont.systemFont(ofSize: 22)
        self.segmentControl.setTitleTextAttributes([NSFontAttributeName: font], for: .normal)
        self.segmentControlHeightConstant.constant = 50
        self.segmentControl.layer.borderWidth = 2
        self.segmentControl.layer.borderColor = UIColor.white.cgColor
        self.segmentControl.layer.cornerRadius = 6
        self.segmentControl.backgroundColor = Style.darkBlueAccentColor
        self.createReportButton.addBlackBorder()
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
