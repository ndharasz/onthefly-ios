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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createFlightButton.addBlackBorder()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchUserFlights()
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
        let fireRef = FIRDatabase.database().reference()
        let planeRef = fireRef.child("flights")
        planeRef.observeSingleEvent(of: .value, with: { (snapshot) in
            for each in snapshot.children {
                //                print((each as! FIRDataSnapshot).key)
                let newFlight = Flight(snapshot: each as! FIRDataSnapshot)
                let uid = FIRAuth.auth()!.currentUser!.uid
                if newFlight.userid == uid {
                    GlobalVariables.sharedInstance.flightArray.append(newFlight)
                }
            }
            self.flights = GlobalVariables.sharedInstance.flightArray
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
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    
    @IBAction func editButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "EditFlight", sender: nil)
    }
    
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        var randString = flights[indexPath.row]
//        
//        randString.append("\n\n\n\n")
//        
//        flights[indexPath.row] = randString
//        
//        tableView.reloadData()
//    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
