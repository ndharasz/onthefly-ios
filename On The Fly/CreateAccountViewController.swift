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
//        text box variables
        //        let userFirstName = firstNameTextField.text
        //        let userLastName = lastNameTextField.text
        let userEmail = emailTextField.text
        let userPassword = passwordTextField.text
        //        let userConfirmPassword = confirmPasswordTextField.text
        FIRAuth.auth()?.createUser(withEmail: userEmail!, password: userPassword!, completion: { (user: FIRUser?, error) in
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
