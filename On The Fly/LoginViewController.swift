//
//  LoginViewController.swift
//  On The Fly
//
//  Created by Scott Higgins on 1/18/17.
//  Copyright © 2017 Team 152 - Easily The Best. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var checkBoxButton: CheckboxButton!
    @IBOutlet weak var usernameTextfield: PaddedTextField!
    @IBOutlet weak var passwordTextfield: PaddedTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        usernameTextfield.roundCorners()
        passwordTextfield.roundCorners()
        loginButton.addBlackBorder()
        
        
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
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomePage")
                    self.present(vc!, animated: true, completion: nil)
                    
                } else {
                    
                    // Tells the user that there is an error and then gets Firebase to tell them the error
                    
                    self.alert(message: (error?.localizedDescription)!, title: "Login Error")
                }
            }
        }
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func checkboxClicked(_ sender: AnyObject) {
        
        checkBoxButton.checkBox()
        
    }
    


}

