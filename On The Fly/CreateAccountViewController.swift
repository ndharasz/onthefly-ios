//
//  CreateAccountViewController.swift
//  On The Fly
//
//  Created by Scott Higgins on 1/25/17.
//  Copyright © 2017 Team 152 - Easily The Best. All rights reserved.
//

import UIKit
import Firebase

class CreateAccountViewController: UIViewController {

    @IBOutlet weak var firstNameTextField: PaddedTextField!
    @IBOutlet weak var lastNameTextField: PaddedTextField!
    @IBOutlet weak var emailTextField: PaddedTextField!
    @IBOutlet weak var passwordTextField: PaddedTextField!
    @IBOutlet weak var confirmPasswordTextField: PaddedTextField!
    
    var ref: FIRDatabaseReference = FIRDatabase.database().reference()
    
    var textFieldArray: [UITextField] = []
    
    @IBAction func createAccountButtonPressed(_ sender: UIButton) {
        // dismiss the keyboard if it is still up
        self.dismissKeyboard()
        
        // these are the variables not directly required for account creation
        let userFirstName = firstNameTextField.text
        let userLastName = lastNameTextField.text
        let userConfirmPassword = confirmPasswordTextField.text
        
        // create account
        if let userEmail = emailTextField.text, let userPassword = passwordTextField.text {
            let validPassword = checkValidPassword(password: userPassword, confirmPassword: userConfirmPassword!) //checks to make sure passwords match
            if (userEmail.isValidEmail()) {
                if (validPassword) {
                    // actually creating new user in firebase
                    FIRAuth.auth()?.createUser(withEmail: userEmail, password: userPassword, completion: { (user: FIRUser?, error) in
                        var title = ""
                        var message = ""
                        if error != nil {
                            title = "Oops!"
                            message = (error?.localizedDescription)!
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
                    alert(message: "The passwords you entered do not match, please try again.", title: "Passwords don't match")
                }
            } else {
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
    
    // adding the user's first and last name to their user id in firebase
    func addUserInfo(email: String, firstName: String, lastName: String, userID: String) {
        let newUser = [
            "email": email,
            "firstName": firstName,
            "lastName": lastName
        ]
        
        ref.child("users/\(userID)").setValue(newUser)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        textFieldArray = [firstNameTextField, lastNameTextField, emailTextField, passwordTextField, confirmPasswordTextField]
        
        for eachTextField in textFieldArray {
            eachTextField.roundCorners()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
