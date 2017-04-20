//
//  UpcomingFlightsViewController.swift
//  On The Fly
//
//  Created by Scott Higgins on 1/19/17.
//  Copyright © 2017 Team 152 - Easily The Best. All rights reserved.
//

import UIKit
import Firebase

class UpcomingFlightsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var createFlightButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var logoutButton: UIButton!
    
    var flights:[Flight] = [Flight]()
    let flightsRef = FIRDatabase.database().reference(withPath: "flights")
    var flightToEdit: Flight?
    
    var messageView: UIView = UIView()
    let messageLabel: UILabel = UILabel()
    var loadingView: UIView = UIView()
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    @IBOutlet weak var headerView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        createFlightButton.addBlackBorder()
        
        fetchUserFlights()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if let selection: IndexPath = tableView.indexPathForSelectedRow {
            self.tableView.deselectRow(at: selection, animated: true)
            let cell = tableView.cellForRow(at: selection) as! UpcomingFlightTableViewCell
            cell.editButton.isHidden = true
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Logout Button Coding
    
    @IBAction func logoutButtonPressed(_ sender: Any) {
        if FIRAuth.auth()?.currentUser != nil {
            do {
                try FIRAuth.auth()?.signOut()
                print("You have successfully logged out")
                
                UserDefaults.standard.set(false, forKey: "rememberMeChecked")
                
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginPage")
                present(vc, animated: true, completion: nil)
                
            } catch let error as NSError {
                self.alert(message: error.localizedDescription, title: "Logout Error")
            }
        }
    }
    
    // MARK: - Firebase Call for Flight Retrieval
    
    func fetchUserFlights() {
        GlobalVariables.sharedInstance.flightArray = []
        
        self.showActivityIndicatory()
        
        flightsRef.queryOrdered(byChild: "date").observe(.value, with: { (snapshot) in
            var newFlights: [Flight] = []
            
            for each in snapshot.children {
                let newFlight = Flight(snapshot: each as! FIRDataSnapshot)
                let uid = FIRAuth.auth()!.currentUser!.uid
                if newFlight.userid == uid {
                    newFlights.append(newFlight)
                }
            }
            self.flights = newFlights
            self.tableView.reloadData()
            
            if self.flights.count == 0 {
                
                self.presentNoFlightMessage()
                
            } else {
                
                self.removeNoFlightMessage()
                
            }
            
            self.hideActivityIndicator()
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    
    func presentNoFlightMessage() {
        self.messageView.frame = CGRect(x: 0, y: 0, width: 300, height: 80)
        self.messageView.center = self.view.center
        self.messageView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        self.messageView.clipsToBounds = true
        self.messageView.layer.cornerRadius = 10
        
        self.messageLabel.frame = CGRect(x: 0, y: 0, width: 300, height: 45)
        self.messageLabel.numberOfLines = 0
        self.messageLabel.textColor = UIColor.white
        self.messageLabel.text = "No flights for this user"
        self.messageLabel.textAlignment = NSTextAlignment.center
        self.messageView.addSubview(messageLabel)
        self.messageLabel.center = self.messageView.center
        
        self.view.addSubview(self.messageView)
        self.view.addSubview(self.messageLabel)
    }
    
    func removeNoFlightMessage() {
        self.messageView.removeFromSuperview()
        self.messageLabel.removeFromSuperview()
    }
    
    // MARK: - TableView Functions
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.flights.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! UpcomingFlightTableViewCell
        
        cell.flightForCell = flights[indexPath.row]
        
        cell.setSimpleLabel()
        
        cell.editButton.tag = indexPath.row
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! UpcomingFlightTableViewCell
        cell.editButton.isHidden = false
//        tableView.headerView(forSection: 0)?.isHidden = true
        self.headerView.isHidden = true
        cell.setDetailedLabel()
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        let cell = tableView.cellForRow(at: indexPath) as! UpcomingFlightTableViewCell
        if cell.isSelected {
            cell.editButton.isHidden = true
//            tableView.headerView(forSection: 0)?.isHidden = false
            self.headerView.isHidden = false
            tableView.deselectRow(at: indexPath, animated: true)
            cell.setSimpleLabel()
            tableView.beginUpdates()
            tableView.endUpdates()
            return nil
        } else {
            return indexPath
        }
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! UpcomingFlightTableViewCell
        cell.editButton.isHidden = true
        tableView.headerView(forSection: 0)?.isHidden = false
        cell.setSimpleLabel()
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let flight = flights[indexPath.row]
            flight.fireRef?.removeValue()
        }
    }
    
    // MARK: - Edit Button Coding
    
    @IBAction func editButtonPressed(_ sender: UIButton) {
        self.flightToEdit = flights[sender.tag]
        self.performSegue(withIdentifier: "EditFlight", sender: nil)
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Pass the selected object to the new view controller.
        if segue.identifier == "EditFlight" {
            let editFlightScene = segue.destination as! EditFlightViewController
            editFlightScene.flight = self.flightToEdit!
        }
    }
    
    // MARK: - Activity Indicator functions
    
    // Set up a spinning activity indicator with a black background (in shape of rounded rectangle)
    func showActivityIndicatory() {
        loadingView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        loadingView.center = self.view.center
        loadingView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        activityIndicator.activityIndicatorViewStyle =
            UIActivityIndicatorViewStyle.whiteLarge
        activityIndicator.center = CGPoint(x: loadingView.frame.size.width / 2,
                                           y: loadingView.frame.size.height / 2)
        loadingView.addSubview(activityIndicator)
        self.view.addSubview(loadingView)
        activityIndicator.startAnimating()
    }
    
    // Stop animating activity indicator, and remove the black background that surrounds it
    func hideActivityIndicator() {
        activityIndicator.stopAnimating()
        self.loadingView.removeFromSuperview()
    }


}
