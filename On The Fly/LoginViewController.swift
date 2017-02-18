//
//  LoginViewController.swift
//  On The Fly
//
//  Created by Scott Higgins on 1/18/17.
//  Copyright © 2017 Team 152 - Easily The Best. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var checkBoxButton: CheckboxButton!
    @IBOutlet weak var usernameTextfield: PaddedTextField!
    @IBOutlet weak var passwordTextfield: PaddedTextField!
    
    var loadingView: UIView = UIView()
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        usernameTextfield.roundCorners()
        addKeyboardToolBar(textField: usernameTextfield)
        passwordTextfield.roundCorners()
        addKeyboardToolBar(textField: passwordTextfield)
        loginButton.addBlackBorder()
        
        rememberMeLogin()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let checkboxShouldBeChecked = UserDefaults.standard.value(forKey: "rememberMeChecked") {
            if checkboxShouldBeChecked as! Bool {
                self.checkBoxButton.checkYes()
            } else {
                self.checkBoxButton.checkNo()
            }
        }
    }
    
    @IBAction func loginAction(_ sender: Any) {
        
        if self.usernameTextfield.text == "" || self.passwordTextfield.text == "" {
            
            // Alert to tell the user that there was an error because they didn't fill anything in the textfields
            
            self.alert(message: "Please enter a username and password.", title: "Login Error")
            
        } else {
            
            FIRAuth.auth()?.signIn(withEmail: self.usernameTextfield.text!, password: self.passwordTextfield.text!) { (user, error) in
                
                if error == nil {
                    
                    // Print into the console if successfully logged in
                    print("You have successfully logged in")
                    
                    if self.checkBoxButton.isChecked() {
                        let defaults = UserDefaults.standard
                        defaults.set(true, forKey: "rememberMeChecked")
                        defaults.set(self.usernameTextfield.text!, forKey: "username")
                        defaults.set(self.passwordTextfield.text!, forKey: "password")
                    } else {
                        let defaults = UserDefaults.standard
                        defaults.set(false, forKey: "rememberMeChecked")
                        defaults.removeObject(forKey: "username")
                        defaults.removeObject(forKey: "password")
                    }
                    
                    // Go to the UpcomingFlightsViewController if the login is sucessful
                    self.performSegue(withIdentifier: "HomePage", sender: nil)
                    
                } else {
                    
                    // Tells the user that there is an error and then gets Firebase to tell them the error
                    
                    self.alert(message: (error?.localizedDescription)!, title: "Login Error")
                }
            }
        }
        
    }
    
    func rememberMeLogin() {
        if let checkboxShouldBeChecked = UserDefaults.standard.value(forKey: "rememberMeChecked") {
            if checkboxShouldBeChecked as! Bool {
                self.showActivityIndicatory()
                let username = UserDefaults.standard.value(forKey: "username") as! String
                let password = UserDefaults.standard.value(forKey: "password") as! String
                FIRAuth.auth()?.signIn(withEmail: username, password: password) { (user, error) in
                    
                    if error == nil {
                        
                        // Print into the console if successfully logged in
                        print("You have successfully logged in")
                        
                        self.hideActivityIndicator()
                        // Go to the UpcomingFlightsViewController if the login is sucessful
                        self.performSegue(withIdentifier: "HomePage", sender: nil)
                        
                    } else {
                        
                        // Tells the user that there is an error and then gets Firebase to tell them the error
                        
                        self.alert(message: (error?.localizedDescription)!, title: "Login Error")
                    }
                }

            }
        }
    }
    
    // Set up a spinning activity indicator with a black background (in shape of rounded rectangle)
    func showActivityIndicatory() {
        loadingView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        loadingView.center = self.view.center
        loadingView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        activityIndicator.activityIndicatorViewStyle =
            UIActivityIndicatorViewStyle.whiteLarge
        activityIndicator.center = CGPoint(x: loadingView.frame.size.width / 2,
                                           y: loadingView.frame.size.height / 2)
        loadingView.addSubview(activityIndicator)
        self.view.addSubview(loadingView)
        activityIndicator.startAnimating()
    }
    
    // Stop animating activity indicator, and remove the black background that surrounds it
    func hideActivityIndicator() {
        activityIndicator.stopAnimating()
        self.loadingView.removeFromSuperview()
    }

    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func checkboxClicked(_ sender: AnyObject) {
        
        checkBoxButton.checkBox()
        
    }
    
    // MARK: - Text Field Delegate Functionality
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.passwordTextfield {
            self.view.frame.origin.y -= 20
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == self.passwordTextfield {
            self.view.frame.origin.y += 20
        }
    }
    
    // MARK: - UITextField Navigation Keyboard Toolbar
    
    func addKeyboardToolBar(textField: UITextField) {
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = Style.darkBlueAccentColor
        
        if textField.tag != 0 {
            let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(donePressed))
            let previousButton = UIBarButtonItem(title: "Previous", style: .plain, target: self, action: #selector(previousPressed))
            let nextButton = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(nextPressed))
            nextButton.isEnabled = false
            let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            toolBar.setItems([previousButton, nextButton, spaceButton, doneButton], animated: true)
        } else {
            let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(donePressed))
            let previousButton = UIBarButtonItem(title: "Previous", style: .plain, target: self, action: #selector(previousPressed))
            previousButton.isEnabled = false
            let nextButton = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(nextPressed))
            let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            toolBar.setItems([previousButton, nextButton, spaceButton, doneButton], animated: true)
        }
        
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        
        // either make the call "extension UIViewController: UITextFieldDelegate {" or manually set text
        // field delegate
        //        textField.delegate = self
        textField.inputAccessoryView = toolBar
    }
    
    func previousPressed() {
        if self.passwordTextfield.isFirstResponder {
            self.usernameTextfield.becomeFirstResponder()
        }
    }
    
    func nextPressed() {
        if self.usernameTextfield.isFirstResponder {
            self.passwordTextfield.becomeFirstResponder()
        }
    }
    
    func donePressed() {
        self.view.endEditing(true)
    }
    
    func cancelPressed() {
        self.view.endEditing(true) // or do something
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "HomePage" {
            self.syncPlanes()
        }
    }
    
    // MARK: - Plane Sync Function
    
    func syncPlanes() {
        // Sync the planes to the Global Database file
        GlobalVariables.sharedInstance.planeArray.removeAll(keepingCapacity: false)
        let fireRef = FIRDatabase.database().reference()
        let planeRef = fireRef.child("planes")
        
        planeRef.observeSingleEvent(of: .value, with: { (snapshot) in
            for value in snapshot.children {
                GlobalVariables.sharedInstance.planeArray.append(Plane(snapshot: (value as! FIRDataSnapshot)))
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }


}

