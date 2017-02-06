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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        emailTextfield.roundCorners()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func resetButtonPressed(_ sender: AnyObject) {
        
        if let userEmail = emailTextfield.text {
            if userEmail.isValidEmail() {
                // do soemthing
            } else {
                // not a valid email
                alert(message: "The email you entered is not valid, please check the email and try again", title: "Invalid email address")
            }
        } else {
            alert(message: "You have not entered an email in the text field. Please try again.", title: "No email entered")
        }
        
        
//        let alert = UIAlertController(title: "Password Successfully Reset", message: "You have successfully reset the password. Select 'Okay' to return to the home screen.", preferredStyle: UIAlertControllerStyle.alert)
//        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: {action in
//            
//            self.dismiss(animated: true, completion: nil)
//            
//        }))
//            
//        self.present(alert, animated: true, completion: nil)
        
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
