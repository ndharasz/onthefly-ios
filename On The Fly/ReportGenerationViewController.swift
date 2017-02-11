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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        emailTextfield.roundCorners()
        
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
        
        let alert = UIAlertController(title: "Report Sent!", message: "Your weight and balance report has been send to the email address above.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK. Return to Home", style: UIAlertActionStyle.default, handler: {action in
        
            self.performSegue(withIdentifier: "homeAfterReportSegue", sender: nil)
        
        }))
        
        self.present(alert, animated: true, completion: nil)
        
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
