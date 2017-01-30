//
//  LoginViewController.swift
//  On The Fly
//
//  Created by Scott Higgins on 1/18/17.
//  Copyright © 2017 Team 152 - Easily The Best. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var checkBoxButton: CheckboxButton!
    @IBOutlet weak var usernameTextfield: PaddedTextField!
    @IBOutlet weak var passwordTextfield: PaddedTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        usernameTextfield.roundCorners()
        passwordTextfield.roundCorners()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func checkboxClicked(_ sender: AnyObject) {
        
        checkBoxButton.checkBox()
        
    }
    


}

