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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
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
