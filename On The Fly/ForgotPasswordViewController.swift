//
//  ForgotPasswordViewController.swift
//  On The Fly
//
//  Created by Scott Higgins on 1/25/17.
//  Copyright © 2017 Team 152 - Easily The Best. All rights reserved.
//

import UIKit
import Firebase

class ForgotPasswordViewController: UIViewController {

    @IBOutlet weak var emailTextfield: PaddedTextField!
    
    @IBOutlet weak var resetPswdButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        emailTextfield.roundCorners()
        addKeyboardToolBar(textField: emailTextfield)
        resetPswdButton.addBlackBorder()
        cancelButton.addBlackBorder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
    
    // MARK: - UITextField Navigation Keyboard Toolbar
    
    func addKeyboardToolBar(textField: UITextField) {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        keyboardToolbar.barStyle = .default
        keyboardToolbar.isTranslucent = true
        
        
        
        let kbDoneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePressed))
        let blankSpacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        blankSpacer.width = kbDoneBtn.width
        let flexiSpacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let kbTitleBtn = UIBarButtonItem(title: "Title", style: .plain, target: nil, action: nil)
        kbTitleBtn.isEnabled = false
        keyboardToolbar.setItems([blankSpacer, flexiSpacer, kbTitleBtn, flexiSpacer, kbDoneBtn], animated: true)
        
        let textPlaceholderLabel = UILabel()
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
    
    func donePressed() {
        self.view.endEditing(true)
    }

}
