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
    @IBOutlet weak var autoCompleteTable2: UITableView!
    
    
    
    @IBOutlet weak var departureArptTextfield: PaddedTextField!
    @IBOutlet weak var arrivalArptTextfield: PaddedTextField!
    
    var pickerData: [Plane] = [Plane]()
    
    var selectedPlane: Plane?
    
    var flightToPass: Flight?
    
    var autoCompletePossibilities = GlobalVariables.sharedInstance.airports
    var autoComplete = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.registerForKeyboardNotifications()
        
        self.tableView.isHidden = true
        self.tableView.layer.cornerRadius = 8
        self.autoCompleteTable2.isHidden = true
        self.autoCompleteTable2.layer.cornerRadius = 8
        
        departureArptTextfield.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        arrivalArptTextfield.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        addKeyboardToolBar(textField: departureArptTextfield)
        addKeyboardToolBar(textField: arrivalArptTextfield)

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
        return pickerData[row].longName()
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleData = pickerData[row].longName()
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
        if let dptArpt = departureArptTextfield.text, let arvArpt = arrivalArptTextfield.text {
            if (checkValidAirports(departure: dptArpt, arrival: arvArpt)) {
                var plane: Plane!
                if let p = selectedPlane {
                    plane = p
                } else {
                    plane = pickerData[0]
                }
                
                let currDate = NSDate()
                //making it so that they can't create a flight on a date or time that has passed already
                if (datePicker.date >= currDate as Date) {
                    //question: should we stop them from putting in past dates/times?
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
                    
                    let newFlight = Flight(plane: plane.longName(), dptArpt: dptArpt, arvArpt: arvArpt, date: date, time: time, uid: uid!)
                    
                    let fireRef = FIRDatabase.database().reference()
                    let flightRef = fireRef.child("flights")
                    let newFlightRef = flightRef.childByAutoId()
                    newFlightRef.setValue(newFlight.toAnyObject())
                    
                    newFlightRef.observeSingleEvent(of: .value, with: { (snapshot) in
                        let flightToEdit = Flight(snapshot: (snapshot))
                        self.flightToPass = flightToEdit
                        self.performSegue(withIdentifier: "createFlightToEditFlight", sender: nil)
                    })
                    
                } else {
                    alert(message: "You cannot create a flight on a date that has passed.", title: "Invalid date")
                }
            } else {
                alert(message: "Please enter valid airport codes.", title: "Invalid airport codes")
            }
        }
    }
    
    
    // checking for valid airport codes and making sure they were put in
    private func checkValidAirports(departure: String, arrival: String) -> Bool {
        //for the moment, just making sure that it is a 3-4 letter code
        if (departure.characters.count > 4 || departure.characters.count < 3 || arrival.characters.count > 4 || arrival.characters.count < 3) {
            return false;
        }
        return true
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "createFlightToEditFlight" {
            let editFlightScene = segue.destination as! EditFlightViewController
            editFlightScene.flight = self.flightToPass!
        }
    }
    
    // MARK: - Auto Complete Code
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == self.departureArptTextfield {
            tableView.isHidden = true
        } else if textField == self.arrivalArptTextfield {
            autoCompleteTable2.isHidden = true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let substring = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        
        searchAutocompleteEntriesWithSubstring(tag: textField.tag, substring: substring)
        
        return true
    }
    
    func searchAutocompleteEntriesWithSubstring(tag: Int, substring: String) {
        
        autoComplete.removeAll(keepingCapacity: false)
        
        for key in autoCompletePossibilities {
            let myString: String! = (key as String).lowercased()
            
            if myString.range(of: substring.lowercased()) != nil {
                autoComplete.append(key)
            }
        }
        
        if tag == 0 {
            tableView.reloadData()
        } else {
            autoCompleteTable2.reloadData()
        }
    }
    
    func textFieldDidChange(_ textField: UITextField) {
        if textField.tag == 0 {
            if textField.text?.characters.count == 0 {
                self.tableView.isHidden = true
            } else {
                self.tableView.isHidden = false
            }
        } else {
            if textField.text?.characters.count == 0 {
                self.autoCompleteTable2.isHidden = true
            } else {
                self.autoCompleteTable2.isHidden = false
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
        
        let index = indexPath.row
        
        cell.textLabel?.numberOfLines = 0
        
        cell.textLabel!.text = autoComplete[index]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return autoComplete.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedText = autoComplete[indexPath.row]
        
        let regex = "\\(.*?\\)"
        let matches = matchesForRegexInText(regex: regex, text: selectedText)
        
        if tableView.tag == 0 {
            if matches.count > 0 {
                self.departureArptTextfield.text = matches[0].trimmingCharacters(in: .punctuationCharacters)
            } else {
                self.departureArptTextfield.text = "Error, please try again"
            }
        } else {
            if matches.count > 0 {
                self.arrivalArptTextfield.text = matches[0].trimmingCharacters(in: .punctuationCharacters)
            } else {
                self.arrivalArptTextfield.text = "Error, please try again"
            }
        }
        
        self.autoComplete = []
        
        if tableView.tag == 0 {
            self.tableView.reloadData()
            self.tableView.isHidden = true
            self.departureArptTextfield.endEditing(true)
        } else {
            self.autoCompleteTable2.reloadData()
            self.autoCompleteTable2.isHidden = true
            self.arrivalArptTextfield.endEditing(true)
        }
        
    }
    
    func matchesForRegexInText(regex: String!, text: String!) -> [String] {
        
        do {
            
            let regex = try NSRegularExpression(pattern: regex, options: [])
            let nsString = text as NSString
            
            let results = regex.matches(in: text,
                                        options: [], range: NSMakeRange(0, nsString.length))
            return results.map { nsString.substring(with: $0.range)}
            
        } catch let error as NSError {
            
            print("invalid regex: \(error.localizedDescription)")
            
            return []
        }}
    
    
    // MARK: - UITextField Navigation Keyboard Toolbar
    
    func addKeyboardToolBar(textField: UITextField) {
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = Style.darkBlueAccentColor
        
        if textField.tag == 0 {
            let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(donePressed))
            let previousButton = UIBarButtonItem(title: "Previous", style: .plain, target: self, action: #selector(previousPressed))
            previousButton.isEnabled = false
            let nextButton = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(nextPressed))
            let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            toolBar.setItems([previousButton, nextButton, spaceButton, doneButton], animated: true)
        } else {
            let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(donePressed))
            let previousButton = UIBarButtonItem(title: "Previous", style: .plain, target: self, action: #selector(previousPressed))
            let nextButton = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(nextPressed))
            nextButton.isEnabled = false
            let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            toolBar.setItems([previousButton, nextButton, spaceButton, doneButton], animated: true)
        }
        
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        
        textField.inputAccessoryView = toolBar
    }
    
    func previousPressed() {
        if self.arrivalArptTextfield.isFirstResponder {
            self.view.frame.origin.y = 0
            self.departureArptTextfield.becomeFirstResponder()
        }
    }
    
    func nextPressed() {
        if self.departureArptTextfield.isFirstResponder {
            self.arrivalArptTextfield.becomeFirstResponder()
        }
    }
    
    func donePressed() {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
        if self.departureArptTextfield.isEditing {
            self.departureArptTextfield.endEditing(false)
        } else {
            self.arrivalArptTextfield.endEditing(false)
        }
        
    }
    
    func cancelPressed() {
        self.view.endEditing(true) // or do something
    }
    
    
    // MARK: - Keyboard Appear/Disappear Handler
    
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(CreateNewFlightViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CreateNewFlightViewController.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        if self.departureArptTextfield.isEditing {
            self.view.frame.origin.y = 0
            self.view.frame.origin.y -= 40
            
        }
        
        if self.arrivalArptTextfield.isEditing {
            if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                self.view.frame.origin.y = 0
                self.view.frame.origin.y -= (keyboardSize.height - 80)
            }
        }

    }
    
    func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}
