//
//  CreateAccountViewController.swift
//  On The Fly
//
//  Created by Scott Higgins on 1/25/17.
//  Copyright © 2017 Team 152 - Easily The Best. All rights reserved.
//

import UIKit
import Firebase

class CreateAccountViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var firstNameTextField: PaddedTextField!
    @IBOutlet weak var lastNameTextField: PaddedTextField!
    @IBOutlet weak var emailTextField: PaddedTextField!
    @IBOutlet weak var passwordTextField: PaddedTextField!
    @IBOutlet weak var confirmPasswordTextField: PaddedTextField!
    @IBOutlet weak var cancelButton: UIButton!
    
    var ref: FIRDatabaseReference = FIRDatabase.database().reference()
    
    var loadingView: UIView = UIView()
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    var textFieldArray: [UITextField] = []
    
    @IBAction func createAccountButtonPressed(_ sender: UIButton) {
        // dismiss the keyboard if it is still up
        self.dismissKeyboard()
        
        // these are the variables not directly required for account creation
        let userFirstName = firstNameTextField.text
        let userLastName = lastNameTextField.text
        let userConfirmPassword = confirmPasswordTextField.text
        
        showActivityIndicatory()
        
        // create account
        if let userEmail = emailTextField.text, let userPassword = passwordTextField.text {
            let validPassword = checkValidPassword(password: userPassword, confirmPassword: userConfirmPassword!) //checks to make sure passwords match
            let validNames = checkValidNames(firstName: userFirstName!, lastName: userLastName!) //checks for illegal characters in first and last name
            if (userEmail.isValidEmail()) {
                if (validPassword && validNames) {
                    // actually creating new user in firebase
                    FIRAuth.auth()?.createUser(withEmail: userEmail, password: userPassword, completion: { (user: FIRUser?, error) in
                        var title = ""
                        var message = ""
                        if error != nil {
                            title = "Oops!"
                            message = (error?.localizedDescription)!
                            self.hideActivityIndicator()
                            self.alert(message: message, title: title)
                        } else {
                            // add the first and last name to info
                            let userID = user?.uid
                            self.addUserInfo(email: userEmail, firstName: userFirstName!, lastName: userLastName!, userID: userID!)
                            
                            // feedback to user that the account creation worked
                            title = "Success!"
                            message = "Account created."
                            self.alertDismissView(message: message, title: title)
                        }
                    })
                    
                } else {
                    // not a valid password combo
                    hideActivityIndicator()
                    if (!validPassword) {
                        alert(message: "The passwords you entered do not match, please try again.", title: "Passwords don't match")
                    } else {
                        alert(message: "There is an illegal character in either your first or last name, please use letters only.")
                    }
                }
            } else {
                hideActivityIndicator()
                alert(message: "The email you entered is not valid, please check the email and try again", title: "Invalid email address")
            }
        }
    }
    
    // checking validity of password and making sure passwords match
    private func checkValidPassword(password: String, confirmPassword: String) -> Bool {
        if (password == confirmPassword) {
            return true
        } else {
            return false
        }
    }
    
    // checking validity of first and last name
    private func checkValidNames(firstName: String, lastName: String) -> Bool {
        var valid = true
        for chr in firstName.characters {
            if (!(chr >= "a" && chr <= "z") && !(chr >= "A" && chr <= "Z") ) {
                valid = false
            }
        }
        for chr in lastName.characters {
            if (!(chr >= "a" && chr <= "z") && !(chr >= "A" && chr <= "Z") ) {
                valid = false
            }
        }
        return valid
    }
    
    // adding the user's first and last name to their user id in firebase
    func addUserInfo(email: String, firstName: String, lastName: String, userID: String) {
        let newUser = [
            "email": email,
            "firstName": firstName,
            "lastName": lastName
        ]
        
        ref.child("users/\(userID)").setValue(newUser)
        hideActivityIndicator()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        textFieldArray = [firstNameTextField, lastNameTextField, emailTextField, passwordTextField, confirmPasswordTextField]
        
        for eachTextField in textFieldArray {
            eachTextField.roundCorners()
        }
        
        cancelButton.addBlackBorder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
    
    // MARK: - Text Field Delegate Functionality
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return false
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
