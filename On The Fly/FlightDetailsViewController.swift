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
    
    @IBOutlet weak var deleteFlightButton: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    var activeField: PaddedTextField?
    
    var textFields: [PaddedTextField]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.applyUserInterfaceChanges()
        self.loadFlightDetails()
        registerForKeyboardNotifications()
        
        flightDatePicker.addTarget(self, action: #selector(FlightDetailsViewController.datePickerValueChanged(_:)), for: UIControlEvents.valueChanged)
        
        textFields = [departAirportTextfield, arriveAirportTextfield, durationTextfield,
                      startingFuelTextfield, flowRateTextfield, taxiFuelUsageTextfield]

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        deregisterFromKeyboardNotifications()
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
        self.activeField = textField as? PaddedTextField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == departAirportTextfield {
            
            guard let newDepartAirport = textField.text else {
                alert(message: "Invalid Airport", title: "Please enter a valid airport.")
                textField.text = editFlightVC.flight!.departAirport
                return
            }
            
            if newDepartAirport.characters.count > 4 || newDepartAirport.characters.count < 3 {
                alert(message: "Invalid Airport Code", title: "Please enter a valid airport code.")
                textField.text = editFlightVC.flight!.departAirport
                return
            }
            
            editFlightVC.flight!.departAirport = newDepartAirport.uppercased()
            textField.text = newDepartAirport.uppercased()
            editFlightVC.flight!.updateAirports()
            editFlightVC.updateTitleLabel()
            
        } else if textField == arriveAirportTextfield {
            
            guard let newArriveAirport = textField.text else {
                alert(message: "Invalid Airport", title: "Please enter a valid airport.")
                textField.text = editFlightVC.flight!.arriveAirport
                return
            }
            
            if newArriveAirport.characters.count > 4 || newArriveAirport.characters.count < 3 {
                alert(message: "Invalid Airport Code", title: "Please enter a valid airport code.")
                textField.text = editFlightVC.flight!.arriveAirport
                return
            }
            
            editFlightVC.flight!.arriveAirport = newArriveAirport.uppercased()
            textField.text = newArriveAirport.uppercased()
            editFlightVC.flight!.updateAirports()
            editFlightVC.updateTitleLabel()

        } else if textField == durationTextfield {
            
            guard let newDuration = textField.text else {
                alert(message: "Invalid Duration", title: "Please enter a valid duration.")
                textField.text = "\(editFlightVC.flight!.flightDuration)"
                return
            }
            
            if let newDurationNumber = Int(newDuration) {
                if newDurationNumber < 0 {
                    alert(message: "Invalid Duration", title: "Please enter a valid duration.")
                    textField.text = "\(editFlightVC.flight!.flightDuration)"
                    return
                } else {
                    editFlightVC.flight!.flightDuration = newDurationNumber
                    editFlightVC.flight!.updateFlightParameters()
                }
            } else {
                alert(message: "Invalid Duration", title: "Please enter a valid duration.")
                textField.text = "\(editFlightVC.flight!.flightDuration)"
                return
            }
            
        } else if textField == startingFuelTextfield {
            
            guard let newStartingFuel = textField.text else {
                alert(message: "Invalid Starting Fuel", title: "Please enter a valid starting fuel amount.")
                textField.text = "\(editFlightVC.flight!.startFuel)"
                return
            }
            
            if let newStartingFuelNumber = Double(newStartingFuel) {
                if newStartingFuelNumber < 0 {
                    alert(message: "Invalid Starting Fuel", title: "Please enter a valid starting fuel amount.")
                    textField.text = "\(editFlightVC.flight!.startFuel)"
                    return
                } else {
                    editFlightVC.flight!.startFuel = newStartingFuelNumber
                    editFlightVC.flight!.updateFlightParameters()
                }
            } else {
                alert(message: "Invalid Starting Fuel", title: "Please enter a valid starting fuel amount.")
                textField.text = "\(editFlightVC.flight!.startFuel)"
                return
            }
            
        } else if textField == flowRateTextfield {
            
            guard let newFlowRate = textField.text else {
                alert(message: "Invalid Flow Rate", title: "Please enter a valid flow rate.")
                textField.text = "\(editFlightVC.flight!.fuelFlow)"
                return
            }
            
            if let newFlowRateNumber = Double(newFlowRate) {
                if newFlowRateNumber < 0 {
                    alert(message: "Invalid Flow Rate", title: "Please enter a valid flow rate.")
                    textField.text = "\(editFlightVC.flight!.fuelFlow)"
                    return
                } else {
                    editFlightVC.flight!.fuelFlow = newFlowRateNumber
                    editFlightVC.flight!.updateFlightParameters()
                }
            } else {
                alert(message: "Invalid Flow Rate", title: "Please enter a valid flow rate.")
                textField.text = "\(editFlightVC.flight!.fuelFlow)"
                return
            }
            
        } else {
            // taxi
            
            guard let newTaxiBurn = textField.text else {
                alert(message: "Invalid Taxi Burn", title: "Please enter a valid taxi burn.")
                textField.text = "\(editFlightVC.flight!.taxiFuelBurn)"
                return
            }
            
            if let newTaxiBurnNumber = Int(newTaxiBurn) {
                if newTaxiBurnNumber < 0 {
                    editFlightVC.flight!.taxiFuelBurn = (0 - newTaxiBurnNumber)
                    textField.text = "\(editFlightVC.flight!.taxiFuelBurn)"
                    editFlightVC.flight!.updateFlightParameters()
                } else {
                    editFlightVC.flight!.taxiFuelBurn = newTaxiBurnNumber
                    editFlightVC.flight!.updateFlightParameters()
                }
            } else {
                alert(message: "Invalid Taxi Burn", title: "Please enter a valid taxi burn.")
                textField.text = "\(editFlightVC.flight!.taxiFuelBurn)"
                return
            }
        }
    }
    
    @IBAction func deleteFlightPressed(_ sender: Any) {
        
        if let flightToDelete = editFlightVC.flight {
            
            flightToDelete.fireRef?.removeValue()
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "HomePage")
            self.present(controller, animated: true, completion: nil)
            
        }
        
    }
    
    // MARK: - UITextField Navigation Keyboard Toolbar
    
    func registerForKeyboardNotifications(){
        // Adding notifies on keyboard appearing
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func deregisterFromKeyboardNotifications(){
        // Removing notifies on keyboard appearing
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWasShown(notification: NSNotification){
        
        if activeField != nil {
            if self.textFields.contains(activeField!) {
                self.scrollView.isScrollEnabled = true
                var info = notification.userInfo!
                let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
                let point2 = CGPoint(x: 0, y: activeField!.frame.origin.y + activeField!.frame.height)
                let bottomOffset = editFlightVC.flightDetailsContainerView.frame.origin.y + editFlightVC.flightDetailsContainerView.frame.height
                let totalOffset = editFlightVC.view.frame.height - bottomOffset
                
                var aRect : CGRect = self.view.frame
                aRect.size.height -= keyboardSize!.height
                if let activeField = self.activeField {
                    if (!aRect.contains(activeField.frame.origin) || !aRect.contains(point2)){
                        print("part of view at least covered")
                        let yOffset = abs(aRect.origin.y + aRect.height - point2.y) - 3 - totalOffset
                        self.scrollView.setContentOffset(CGPoint(x: 0, y: yOffset), animated: true)
                    } else {
                        self.scrollView.setContentOffset(CGPoint.zero, animated: true)
                    }
                }
            }
        }
        
    }
    
    func keyboardWillBeHidden(notification: NSNotification){
        self.scrollView.setContentOffset(CGPoint.zero, animated: true)
        self.scrollView.isScrollEnabled = false
    }
    
    func addKeyboardToolBar(textField: UITextField) {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        keyboardToolbar.barStyle = .default
        keyboardToolbar.isTranslucent = true
        
        let flexiSpacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let kbTitleBtn = UIBarButtonItem(title: "Title", style: .plain, target: nil, action: nil)
        kbTitleBtn.isEnabled = false
        
        let kbSaveBtn = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(donePressed))
        let kbCancelBtn = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelPressed))
        
        keyboardToolbar.setItems([flexiSpacer, kbTitleBtn, flexiSpacer, kbCancelBtn, kbSaveBtn], animated: true)
        
        let textPlaceholderLabel = UILabel()
        textPlaceholderLabel.sizeToFit()
        textPlaceholderLabel.backgroundColor = UIColor.clear
        textPlaceholderLabel.textAlignment = .center
        kbTitleBtn.customView = textPlaceholderLabel
        
        textPlaceholderLabel.text = textField.placeholder!
        textPlaceholderLabel.sizeToFit()
        
        keyboardToolbar.isUserInteractionEnabled = true
        keyboardToolbar.sizeToFit()
        
        textField.inputAccessoryView = keyboardToolbar
    }
    
    func cancelPressed() {
        if let activeTextField = self.activeField {
            if activeTextField == departAirportTextfield {
                
                activeTextField.text = editFlightVC.flight!.departAirport
                
            } else if activeTextField == arriveAirportTextfield {
                
                activeTextField.text = editFlightVC.flight!.arriveAirport
                
            } else if activeTextField == durationTextfield {
                
                activeTextField.text = "\(editFlightVC.flight!.flightDuration)"
                
            } else if activeTextField == startingFuelTextfield {
                
                activeTextField.text = "\(editFlightVC.flight!.startFuel)"
                
            } else if activeTextField == flowRateTextfield {
                
                activeTextField.text = "\(editFlightVC.flight!.fuelFlow)"
                
            } else {
                // taxi
                
                activeTextField.text = "\(editFlightVC.flight!.taxiFuelBurn)"
                
            }
        }
        
        self.view.endEditing(true)
    }

    
    func donePressed() {
        self.view.endEditing(true)
    }
    

}
