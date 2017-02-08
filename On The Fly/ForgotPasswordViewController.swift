//
//  ForgotPasswordViewController.swift
//  On The Fly
//
//  Created by Scott Higgins on 1/25/17.
//  Copyright © 2017 Team 152 - Easily The Best. All rights reserved.
//

import UIKit
import FirebaseAuth

class ForgotPasswordViewController: UIViewController {

    @IBOutlet weak var emailTextfield: PaddedTextField!
    
    @IBOutlet weak var resetPswdButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        emailTextfield.roundCorners()
        resetPswdButton.addBlackBorder()
        cancelButton.addBlackBorder()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func resetButtonPressed(_ sender: AnyObject) {
        
        if let userEmail = emailTextfield.text {
            if userEmail.characters.count == 0 {
                self.alert(message: "You have not entered an email in the text field above.", title: "Please try again")
            } else {
                if userEmail.isValidEmail() {
                    FIRAuth.auth()?.sendPasswordReset(withEmail: userEmail, completion: { (error) in
                        var title = ""
                        var message = ""
                        
                        if error != nil {
                            title = "Oops!"
                            message = (error?.localizedDescription)!
                            self.alert(message: message, title: title)
                        } else {
                            title = "Success!"
                            message = "Password reset email sent"
                            self.alertDismissView(message: message, title: title)
                        }
                    })
                } else {
                    // not a valid email
                    alert(message: "The email you entered is not valid, please check the email and try again", title: "Invalid email address")
                }

            }
        }
        
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
