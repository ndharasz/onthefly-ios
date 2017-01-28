//
//  EditFlightViewController.swift
//  On The Fly
//
//  Created by Scott Higgins on 1/25/17.
//  Copyright © 2017 Team 152 - Easily The Best. All rights reserved.
//

import UIKit

class EditFlightViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var passengerCollectionView: UICollectionView!
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var passengerViewButton: UIButton!
    @IBOutlet weak var cargoViewButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var frontCargoView: UIView!
    @IBOutlet weak var rearCargoView: UIView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        passengerCollectionView.isHidden = false
        
        pageControl.numberOfPages = 2
        
        let buttons: [UIButton] = [passengerViewButton, cargoViewButton]
        for each in buttons {
            each.layer.borderWidth = 2
            each.layer.borderColor = UIColor.white.cgColor
        }
        passengerViewButton.backgroundColor = Style.darkBlueAccentColor
        
        let addButton1 = UIButton(type: .custom)
        addButton1.frame = CGRect(x: 130, y: 80, width: 60, height: 60)
        addButton1.layer.cornerRadius = 0.5 * addButton1.bounds.size.width
        addButton1.clipsToBounds = true
        addButton1.setTitle("+", for: .normal)
        addButton1.titleLabel?.setSizeFont(sizeFont: 40)
        addButton1.setTitleColor(UIColor.black, for: .normal)
        addButton1.layer.backgroundColor = UIColor.white.cgColor
        frontCargoView.addSubview(addButton1)
        
        let addButton2 = UIButton(type: .custom)
        addButton2.frame = CGRect(x: 130, y: 80, width: 60, height: 60)
        addButton2.layer.cornerRadius = 0.5 * addButton1.bounds.size.width
        addButton2.clipsToBounds = true
        addButton2.setTitle("+", for: .normal)
        addButton2.titleLabel?.setSizeFont(sizeFont: 40)
        addButton2.setTitleColor(UIColor.black, for: .normal)
        addButton2.layer.backgroundColor = UIColor.white.cgColor
        rearCargoView.addSubview(addButton2)
        
//        addButton1.addTarget(self, action: #selector(thumbsUpButtonPressed), for: .touchUpInside)
//        addButton1.centerXAnchor.constraint(equalTo: frontCargoView.centerXAnchor).isActive = true
//        addButton1.centerYAnchor.constraint(equalTo: frontCargoView.centerYAnchor).isActive = true
//        addButton1.widthAnchor.constraint(equalToConstant: 50).isActive = true
//        addButton1.heightAnchor.constraint(equalToConstant: 50).isActive = true

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Collection View Code
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = passengerCollectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        cell.backgroundColor = Style.darkBlueAccentColor
        return cell
    }
    
    
    // MARK: - Passenger and Cargo View Button Actions
    
    @IBAction func passengerViewButtonSelected(_ sender: AnyObject) {
        passengerViewButton.backgroundColor = Style.darkBlueAccentColor
        cargoViewButton.backgroundColor = Style.mainBackgroundColor
        pageControl.currentPage = 0
        passengerCollectionView.isHidden = false
        frontCargoView.isHidden = true
        rearCargoView.isHidden = true
        containerView.isHidden = true
        
    }
    
    
    @IBAction func cargoViewButtonSelected(_ sender: AnyObject) {
        passengerViewButton.backgroundColor = Style.mainBackgroundColor
        cargoViewButton.backgroundColor = Style.darkBlueAccentColor
        pageControl.currentPage = 1
        passengerCollectionView.isHidden = true
        frontCargoView.isHidden = false
        rearCargoView.isHidden = false
        containerView.isHidden = false
        self.view.sendSubview(toBack: containerView)
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
