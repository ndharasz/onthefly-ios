//
//  FlightDetailsViewController.swift
//  On The Fly
//
//  Created by Scott Higgins on 3/7/17.
//  Copyright © 2017 Team 152 - Easily The Best. All rights reserved.
//

import UIKit

class FlightDetailsViewController: UIViewController, UITextFieldDelegate {

    var editFlightVC: EditFlightViewController!
    
    @IBOutlet weak var departAirportTextfield: PaddedTextField!
    
    @IBOutlet weak var arriveAirportTextfield: PaddedTextField!
    
    @IBOutlet weak var durationTextfield: PaddedTextField!
    
    @IBOutlet weak var startingFuelTextfield: PaddedTextField!
    
    @IBOutlet weak var flowRateTextfield: PaddedTextField!
    
    @IBOutlet weak var taxiFuelUsageTextfield: PaddedTextField!
    
    @IBOutlet weak var flightDatePicker: UIDatePicker!
    
    var activeTextfield: PaddedTextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.applyUserInterfaceChanges()
        self.loadFlightDetails()
        
        flightDatePicker.addTarget(self, action: #selector(FlightDetailsViewController.datePickerValueChanged(_:)), for: UIControlEvents.valueChanged)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func applyUserInterfaceChanges() {
        let textfieldsArray = [departAirportTextfield, arriveAirportTextfield, durationTextfield,
                               startingFuelTextfield, flowRateTextfield, taxiFuelUsageTextfield]
        for each in textfieldsArray {
            each?.roundCorners()
            addKeyboardToolBar(textField: each!)
        }
        flightDatePicker.setValue(UIColor.white, forKey: "textColor")
    }
    
    func loadFlightDetails() {
        if let thisFlight = editFlightVC.flight {
            self.departAirportTextfield.text = thisFlight.departAirport
            self.arriveAirportTextfield.text = thisFlight.arriveAirport
            self.durationTextfield.text = "\(thisFlight.flightDuration)"
            self.startingFuelTextfield.text = "\(thisFlight.startFuel)"
            self.flowRateTextfield.text = "\(thisFlight.fuelFlow)"
            self.taxiFuelUsageTextfield.text = "\(thisFlight.taxiFuelBurn)"
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM-dd-yyyy h:mm a"
            let flightDate = dateFormatter.date(from: thisFlight.date + " " + thisFlight.time)!
            flightDatePicker.setDate(flightDate, animated: true)
            
        }
    }
    
    func datePickerValueChanged(_ sender: UIDatePicker){
        
        let dateFormatter: DateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "MM-dd-yyyy"
        
        let selectedDate: String = dateFormatter.string(from: sender.date)
        
        dateFormatter.dateFormat = "h:mm a"
        
        let selectedTime: String = dateFormatter.string(from: sender.date)
        
        if var thisFlight = editFlightVC.flight {
            thisFlight.date = selectedDate
            thisFlight.time = selectedTime
            thisFlight.updateDateAndTime()
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeTextfield = textField as! PaddedTextField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == departAirportTextfield {
            
            guard let newDepartAirport = textField.text else {
                alert(message: "Invalid Airport", title: "Please enter a valid airport.")
                textField.text = editFlightVC.flight!.departAirport
                return
            }
            
            editFlightVC.flight!.departAirport = newDepartAirport
            editFlightVC.flight!.updateAirports()
            editFlightVC.updateTitleLabel()
            
        } else if textField == arriveAirportTextfield {
            
            guard let newArriveAirport = textField.text else {
                alert(message: "Invalid Airport", title: "Please enter a valid airport.")
                textField.text = editFlightVC.flight!.arriveAirport
                return
            }
            
            editFlightVC.flight!.arriveAirport = newArriveAirport
            editFlightVC.flight!.updateAirports()
            editFlightVC.updateTitleLabel()

        } else if textField == durationTextfield {
            
            guard let newDuration = textField.text else {
                alert(message: "Invalid Duration", title: "Please enter a valid duration.")
                textField.text = "\(editFlightVC.flight!.flightDuration)"
                return
            }
            
            editFlightVC.flight!.flightDuration = Int(newDuration)!
            editFlightVC.flight!.updateFlightParameters()
        } else if textField == startingFuelTextfield {
            
            guard let newStartingFuel = textField.text else {
                alert(message: "Invalid Starting Fuel", title: "Please enter a valid starting fuel amount.")
                textField.text = "\(editFlightVC.flight!.startFuel)"
                return
            }
            
            editFlightVC.flight!.startFuel = Double(newStartingFuel)!
            editFlightVC.flight!.updateFlightParameters()
        } else if textField == flowRateTextfield {
            
            guard let newFlowRate = textField.text else {
                alert(message: "Invalid Flow Rate", title: "Please enter a valid flow rate.")
                textField.text = "\(editFlightVC.flight!.fuelFlow)"
                return
            }
            
            editFlightVC.flight!.fuelFlow = Double(newFlowRate)!
            editFlightVC.flight!.updateFlightParameters()
            
        } else {
            // taxi
            
            guard let newTaxiBurn = textField.text else {
                alert(message: "Invalid Taxi Burn", title: "Please enter a valid taxi burn.")
                textField.text = "\(editFlightVC.flight!.taxiFuelBurn)"
                return
            }
            
            editFlightVC.flight!.flightDuration = Int(newTaxiBurn)!
            editFlightVC.flight!.updateFlightParameters()
            
        }
    }
    
    func addKeyboardToolBar(textField: UITextField) {
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = Style.darkBlueAccentColor
        
        let doneButton = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(donePressed))
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self,
                                           action: #selector(FlightDetailsViewController.cancelPressed))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton, cancelButton, doneButton], animated: true)
        
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        
        textField.inputAccessoryView = toolBar
    }
    
    func donePressed() {
        self.view.endEditing(true)
    }
    
    @objc func cancelPressed() {
        if self.activeTextfield == departAirportTextfield {
            
            self.activeTextfield.text = editFlightVC.flight!.departAirport
            
        } else if self.activeTextfield == arriveAirportTextfield {
            
            self.activeTextfield.text = editFlightVC.flight!.arriveAirport
            
        } else if self.activeTextfield == durationTextfield {
            
            self.activeTextfield.text = "\(editFlightVC.flight!.flightDuration)"
            
        } else if self.activeTextfield == startingFuelTextfield {
            
            self.activeTextfield.text = "\(editFlightVC.flight!.startFuel)"
            
        } else if self.activeTextfield == flowRateTextfield {
            
            self.activeTextfield.text = "\(editFlightVC.flight!.fuelFlow)"
            
        } else {
            // taxi
            
            self.activeTextfield.text = "\(editFlightVC.flight!.taxiFuelBurn)"
            
        }
        
        self.view.endEditing(true)
    }

    

}
