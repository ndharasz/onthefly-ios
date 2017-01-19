//
//  LoginViewController.swift
//  On The Fly
//
//  Created by Scott Higgins on 1/18/17.
//  Copyright © 2017 Team 152 - Easily The Best. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var checkBoxButton: UIButton!
    var isRememberMeClicked = false
    var checkedImage = UIImage(named: "checkbox_checked")
    var uncheckedImage = UIImage(named: "checkbox_unchecked")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isRememberMeClicked = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func checkboxClicked(_ sender: AnyObject) {
        
        if isRememberMeClicked {
            isRememberMeClicked = false
            checkBoxButton.setImage(uncheckedImage!, for: UIControlState.normal)
        } else {
            isRememberMeClicked = true
            checkBoxButton.setImage(checkedImage!, for: UIControlState.normal)
        }
        
    }
    


}

