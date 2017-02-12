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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.layer.cornerRadius = 8
        
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
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    
    // MARK: - TableView Functions
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.flights.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Date            Dpt Arpt          Arr Arpt"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! UpcomingFlightTableViewCell
        
        let flight = flights[indexPath.row]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yy"
        
        guard let date = dateFormatter.date(from: flight.date) else {
            print("oops")
            return cell
        }
        
        
        cell.infoLabel.text = "\(dateFormatter.string(from: date))          \(flight.departAirport)                  \(flight.arriveAirport)"
        
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
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        let cell = tableView.cellForRow(at: indexPath) as! UpcomingFlightTableViewCell
        if cell.isSelected {
            cell.editButton.isHidden = true
            tableView.deselectRow(at: indexPath, animated: true)
            return nil
        } else {
            return indexPath
        }
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! UpcomingFlightTableViewCell
        cell.editButton.isHidden = true
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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "EditFlight" {
            let editFlightScene = segue.destination as! EditFlightViewController
            editFlightScene.flight = self.flightToEdit!
        }
    }

}
