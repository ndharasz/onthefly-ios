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
    
    var textFieldArray: [UITextField] = []
    
    @IBAction func createAccountButtonPressed(_ sender: UIButton) {
//      text box variables
//        let userFirstName = firstNameTextField.text
//        let userLastName = lastNameTextField.text
        let userConfirmPassword = confirmPasswordTextField.text
        if let userEmail = emailTextField.text, let userPassword = passwordTextField.text {
            let validEmail = checkValidEmail(email: userEmail)
            let validPassword = checkValidPassword(password: userPassword, confirmPassword: userConfirmPassword!)
            if (validEmail) {
                if (validPassword) {
                    FIRAuth.auth()?.createUser(withEmail: userEmail, password: userPassword, completion: { (user: FIRUser?, error) in
                        var title = ""
                        var message = ""
                        
                        if error != nil {
                            title = "Oops!"
                            message = (error?.localizedDescription)!
                            self.alert(message: message, title: title)
                        } else {
                            title = "Success!"
                            message = "Account created."
                            self.alertDismissView(message: message, title: title)
                        }
                    })
                } else {
                    //not a valid password combo
                    alert(message: "The passwords you entered do not match, please try again.", title: "Passwords don't match")
                }
            } else {
                alert(message: "The email you entered is not valid, please check the email and try again", title: "Invalid email address")
            }
        }
    }
    
    //checking validity of email address
    private func checkValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        if (email.characters.count == 0) {
            return false
        } else if (!emailTest.evaluate(with: email)) {
            return false
        } else {
            return true
        }
    }
    
    //checking validity of password and making sure passwords match
    private func checkValidPassword(password: String, confirmPassword: String) -> Bool {
        if (password == confirmPassword) {
            return true
        } else {
            return false
        }
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
