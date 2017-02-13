//
//  CreateNewFlightViewController.swift
//  On The Fly
//
//  Created by Scott Higgins on 1/24/17.
//  Copyright © 2017 Team 152 - Easily The Best. All rights reserved.
//

import UIKit
import Firebase

class CreateNewFlightViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var planePicker: UIPickerView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBOutlet weak var departureArptTextfield: PaddedTextField!
    @IBOutlet weak var arrivalArptTextfield: PaddedTextField!
    
    var pickerData: [String] = [String]()
    
    var selectedPlane: String?
    
    var flightToPass: Flight?
    
    var autoCompletePossibilities = GlobalVariables.sharedInstance.airports
    var autoComplete = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
        self.tableView.isHidden = true

//        pickerData = ["Piper Saratoga N736X", "King Air N799F", "Cessna Citation N899O"]
        pickerData = GlobalVariables.sharedInstance.planeArray
        
        departureArptTextfield.roundCorners()
        arrivalArptTextfield.roundCorners()
        
        datePicker.setValue(UIColor.white, forKey: "textColor")
        datePicker.setValue(true, forKey: "highlightsToday")
        
        submitButton.addBlackBorder()
        cancelButton.addBlackBorder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: - Picker View Code
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleData = pickerData[row]
        let myTitle = NSAttributedString(string: titleData, attributes: [NSForegroundColorAttributeName:UIColor.white])
        return myTitle
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedPlane = pickerData[row]
    }
    
    // MARK: - Button Functionality
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submitButtonPressed(_ sender: Any) {
        var plane = ""
        if let p = selectedPlane {
            plane = p
        } else {
            plane = pickerData[0]
        }
        let dptArpt = departureArptTextfield.text!
        let arvArpt = arrivalArptTextfield.text!
        
        let dateFormatter = DateFormatter()
        // Now we specify the display format, e.g. "08-27-2017"
        dateFormatter.dateFormat = "MM-dd-YYYY"
        // Now we get the date from the UIDatePicker and convert it to a string
        let strDate = dateFormatter.string(from: datePicker.date)
        // Finally we set the text of the label to our new string with the date
        let date = strDate
        
        dateFormatter.timeStyle = .short
        let strTime = dateFormatter.string(from: datePicker.date)
        let time = strTime
        let uid = FIRAuth.auth()?.currentUser?.uid
        
        let newFlight = Flight(plane: plane, dptArpt: dptArpt, arvArpt: arvArpt, date: date, time: time, uid: uid!)
        
        let fireRef = FIRDatabase.database().reference()
        let flightRef = fireRef.child("flights")
        let newFlightRef = flightRef.childByAutoId()
        newFlightRef.setValue(newFlight.toAnyObject())
        
        newFlightRef.observeSingleEvent(of: .value, with: { (snapshot) in
            let flightToEdit = Flight(snapshot: (snapshot))
            self.flightToPass = flightToEdit
            self.performSegue(withIdentifier: "createFlightToEditFlight", sender: nil)
        })
        
//        self.performSegue(withIdentifier: "createFlightToEditFlight", sender: nil)
    }
    
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "createFlightToEditFlight" {
            let editFlightScene = segue.destination as! EditFlightViewController
            editFlightScene.flight = self.flightToPass!
        }
    }
    
    // MARK: - Auto Complete Code
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        tableView.isHidden = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        tableView.isHidden = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let substring = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        
        searchAutocompleteEntriesWithSubstring(substring: substring)
        
        return true
    }
    
    func searchAutocompleteEntriesWithSubstring(substring: String) {
        
        autoComplete.removeAll(keepingCapacity: false)
        
        for key in autoCompletePossibilities {
            let myString: String! = key as String
            
            if myString.range(of: substring) != nil {
                autoComplete.append(key)
            }
        }
        
        tableView.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
        
        let index = indexPath.row
        
        cell.textLabel!.text = autoComplete[index]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return autoComplete.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.departureArptTextfield.text = autoComplete[indexPath.row]
        
        self.autoComplete = []
        
        self.tableView.reloadData()
        
        self.tableView.isHidden = true
    }

}
