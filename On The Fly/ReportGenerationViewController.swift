//
//  ReportGenerationViewController.swift
//  On The Fly
//
//  Created by Scott Higgins on 1/26/17.
//  Copyright © 2017 Team 152 - Easily The Best. All rights reserved.
//

import UIKit
import Charts

class ReportGenerationViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var sendReportCheckbox: CheckboxButton!
    @IBOutlet weak var saveLocallyCheckbox: CheckboxButton!
    
    @IBOutlet weak var emailTextfield: PaddedTextField!
    
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var lineChartView: LineChartView!
    
    var flight: Flight?
    var plane: Plane?
    var activeField: PaddedTextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerForKeyboardNotifications()
        
        emailTextfield.roundCorners()
        addKeyboardToolBar(textField: emailTextfield)
        
        sendButton.addBlackBorder()
        cancelButton.addBlackBorder()
        
        lineChartView.noDataText = "No center of gravity envelope data found."
        lineChartView.noDataTextColor = .blue
        
        var coordArray: [(ChartDataEntry, Int)] = []
        
        if let thisPlane = self.plane {
            let envPoints = thisPlane.centerOfGravityEnvelope
            for (index, element) in envPoints.enumerated() {
                let newPoint = ChartDataEntry(x: element["x"]!, y: element["y"]!)
                coordArray.append((newPoint, index))
            }
        }
        
        let ySeries = coordArray.map { x, _ in
            return x
        }
        
        ySeries.last!.x += 0.000001
        
        let bottomConnectorSeries = [ySeries.first!, ySeries.last!]
        
        var cogSeries: [ChartDataEntry] = []
        
        cogSeries.append(ChartDataEntry(x: flight!.calcLandingCenterOfGravity(plane: plane!), y: flight!.calcLandingWeight(plane: plane!)))
        
        cogSeries.append(ChartDataEntry(x: flight!.calcTakeoffCenterOfGravity(plane: plane!), y: flight!.calcTakeoffWeight(plane: plane!)))
        
        let data = LineChartData()
        
        let dataset = LineChartDataSet(values: ySeries, label: "CoG Envelope")
        dataset.colors = [NSUIColor.blue]
        data.addDataSet(dataset)
        
        let dataset2 = LineChartDataSet(values: bottomConnectorSeries, label: "Lower Limit")
        dataset2.colors = [NSUIColor.red]
        data.addDataSet(dataset2)
        
        let dataset3 = LineChartDataSet(values: cogSeries, label: "Flight Shift")
        dataset3.colors = [NSUIColor.darkGray]
        data.addDataSet(dataset3)
        
        self.lineChartView.data = data
        
        self.lineChartView.xAxis.axisMinimum = ySeries.first!.x - 2.0
        self.lineChartView.xAxis.axisMaximum = ySeries.last!.x + 2.0
        
        self.lineChartView.gridBackgroundColor = NSUIColor.white
        self.lineChartView.xAxis.drawGridLinesEnabled = true;
        self.lineChartView.xAxis.labelPosition = XAxis.LabelPosition.bottom
        self.lineChartView.chartDescription?.text = "W & B Graph"
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.lineChartView.animate(xAxisDuration: 0.5, yAxisDuration: 0.5)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        deregisterFromKeyboardNotifications()
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
    
    func registerForKeyboardNotifications(){
        // Adding notifies on keyboard appearing
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func deregisterFromKeyboardNotifications(){
        // Removing notifies on keyboard appearing
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWasShown(notification: NSNotification){
        
        self.scrollView.isScrollEnabled = true
        var info = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let point2 = CGPoint(x: 0, y: activeField!.frame.origin.y + activeField!.frame.height)
        
        
        var aRect : CGRect = self.view.frame
        aRect.size.height -= keyboardSize!.height
        if let activeField = self.activeField {
            if (!aRect.contains(activeField.frame.origin) || !aRect.contains(point2)){
                print("part of view at least covered")
                let yOffset = abs(aRect.origin.y + aRect.height - point2.y) + 30
                self.scrollView.setContentOffset(CGPoint(x: 0, y: yOffset), animated: true)
            } else {
                print("nothing covered")
                self.scrollView.setContentOffset(CGPoint.zero, animated: true)
            }
        } else {
            print("invalid active field")
        }
        
    }
    
    func keyboardWillBeHidden(notification: NSNotification){
        self.scrollView.setContentOffset(CGPoint.zero, animated: true)
    }
    
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeField = textField as? PaddedTextField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.activeField = nil
    }

}
