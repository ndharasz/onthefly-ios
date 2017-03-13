//
//  ReportGenerationViewController.swift
//  On The Fly
//
//  Created by Scott Higgins on 1/26/17.
//  Copyright © 2017 Team 152 - Easily The Best. All rights reserved.
//

import UIKit

class ReportGenerationViewController: UIViewController {

    @IBOutlet weak var sendReportCheckbox: CheckboxButton!
    @IBOutlet weak var saveLocallyCheckbox: CheckboxButton!
    
    @IBOutlet weak var emailTextfield: PaddedTextField!
    
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        emailTextfield.roundCorners()
        addKeyboardToolBar(textField: emailTextfield)
        
        sendButton.addBlackBorder()
        cancelButton.addBlackBorder()        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sendReportButtonPressed(_ sender: Any) {
        sendReportCheckbox.checkBox()
    }
    
    @IBAction func saveLocallyButtonPressed(_ sender: Any) {
        saveLocallyCheckbox.checkBox()
    }
    
    @IBAction func sendButtonPressed(_ sender: AnyObject) {
        if let regEmail = emailTextfield.text {
            if (regEmail.isValidEmail()) {
                let alert = UIAlertController(title: "Report Sent!", message: "Your weight and balance report has been send to the email address above.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK. Return to Home", style: UIAlertActionStyle.default, handler: {action in
                    
                    self.performSegue(withIdentifier: "homeAfterReportSegue", sender: nil)
                    
                }))
                
                self.present(alert, animated: true, completion: nil)
            } else {
                alert(message: "The email you entered is not valid, please check the email and try again", title: "Invalid email address")
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
