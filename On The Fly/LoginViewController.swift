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
    
    @IBOutlet var keyboardToolbar: UIToolbar!
    @IBOutlet weak var kbPrevBtn: UIBarButtonItem!
    @IBOutlet weak var kbTitleBtn: UIBarButtonItem!
    @IBOutlet weak var kbDoneBtn: UIBarButtonItem!
    @IBOutlet weak var kbNextBtn: UIBarButtonItem!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var activeField: PaddedTextField?
    private var textPlaceholderLabel: UILabel = UILabel(frame: CGRect.zero)
    
    var loadingView: UIView = UIView()
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        let textfields = [usernameTextfield, passwordTextfield]
        for each in textfields {
            each!.roundCorners()
            addKeyboardToolBar(textField: each!)
        }

        loginButton.addBlackBorder()
        scrollView.isScrollEnabled = false
        
        rememberMeLogin()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        registerForKeyboardNotifications()
        if let checkboxShouldBeChecked = UserDefaults.standard.value(forKey: "rememberMeChecked") {
            if checkboxShouldBeChecked as! Bool {
                self.checkBoxButton.checkYes()
            } else {
                self.checkBoxButton.checkNo()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        deregisterFromKeyboardNotifications()
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
        textField.resignFirstResponder()
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeField = textField as? PaddedTextField
        if textField == usernameTextfield {
            kbPrevBtn.isEnabled = false
            kbNextBtn.isEnabled = true
        } else if textField == passwordTextfield {
            kbNextBtn.isEnabled = false
            kbPrevBtn.isEnabled = true
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeField = nil
    }
    
    // MARK: - UITextField Navigation Keyboard Toolbar
    
    func registerForKeyboardNotifications(){
        //Adding notifies on keyboard appearing
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func deregisterFromKeyboardNotifications(){
        //Removing notifies on keyboard appearing
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWasShown(notification: NSNotification){
        //Need to calculate keyboard exact size due to Apple suggestions
        
        textPlaceholderLabel.text = activeField?.placeholder!
        textPlaceholderLabel.sizeToFit()
        
        self.scrollView.isScrollEnabled = true
        var info = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let point2 = CGPoint(x: 0, y: activeField!.frame.origin.y + activeField!.frame.height)
        
        
        var aRect : CGRect = self.view.frame
        aRect.size.height -= keyboardSize!.height
        if let activeField = self.activeField {
            if (!aRect.contains(activeField.frame.origin) || !aRect.contains(point2)){
                print("part of view at least covered")
                let yOffset = abs(aRect.origin.y + aRect.height - point2.y) + 5
                self.scrollView.setContentOffset(CGPoint(x: 0, y: yOffset), animated: true)
            } else {
                self.scrollView.setContentOffset(CGPoint.zero, animated: true)
            }
        }
        
    }
    
    func keyboardWillBeHidden(notification: NSNotification){
        self.scrollView.setContentOffset(CGPoint.zero, animated: true)
        self.scrollView.isScrollEnabled = false
    }
    
    func addKeyboardToolBar(textField: UITextField) {
        keyboardToolbar.barStyle = .default
        keyboardToolbar.isTranslucent = true
        
        kbPrevBtn.action = #selector(previousPressed)
        kbNextBtn.action = #selector(nextPressed)
        kbDoneBtn.action = #selector(donePressed)
        
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
    
    func previousPressed() {
        switch activeField! {
        case passwordTextfield:
            usernameTextfield.becomeFirstResponder()
        default:
            print("no previous field")
        }
    }
    
    func nextPressed() {
        switch activeField! {
        case usernameTextfield:
            passwordTextfield.becomeFirstResponder()
        default:
            print("no next field")
        }
    }
    
    func donePressed() {
        self.view.endEditing(true)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
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

