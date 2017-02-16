//
//  UpcomingFlightTableViewCell.swift
//  On The Fly
//
//  Created by Scott Higgins on 2/11/17.
//  Copyright © 2017 Team 152 - Easily The Best. All rights reserved.
//

import UIKit

class UpcomingFlightTableViewCell: UITableViewCell {

    @IBOutlet weak var editButton: UIButton!
    
    // MARK: - Expanded View UI Elements
    
    @IBOutlet weak var detailedStackView: UIStackView!
    @IBOutlet weak var firstHeaderStackView: UIStackView!
    @IBOutlet weak var firstEditableStackView: UIStackView!
    @IBOutlet weak var secondHeaderStackView: UIStackView!
    @IBOutlet weak var secondEditableStackView: UIStackView!
    
    @IBOutlet weak var dateTitleLabel: UILabel!
    @IBOutlet weak var dptArptTitleLabel: UILabel!
    @IBOutlet weak var ArrArptTitleLabel: UILabel!
    
    @IBOutlet weak var actualDateLabel: UILabel!
    @IBOutlet weak var actualDeptArptLabel: UILabel!
    @IBOutlet weak var actualArrArptLabel: UILabel!
    
    @IBOutlet weak var dptTimeTitleLabel: UILabel!
    @IBOutlet weak var arrTimeTitleLabel: UILabel!
    @IBOutlet weak var acNoTitleLabel: UILabel!
    
    @IBOutlet weak var actualDeptTimeLabel: UILabel!
    @IBOutlet weak var actualArrTimeLabel: UILabel!
    @IBOutlet weak var actualAcNoLabel: UILabel!
    
    // MARK: - Condensed View UI Elements
    
    @IBOutlet weak var simpleStackView: UIStackView!
    
    @IBOutlet weak var simpleDateLabel: UILabel!
    @IBOutlet weak var simpleDptArptLabel: UILabel!
    @IBOutlet weak var simpleArrArptLabel: UILabel!
    
    
    // MARK: - Class Variables
    
    var headerTitleLabels: [UILabel] = []
    var flightForCell: Flight?
    
    // MARK: - Basic Cell Functions
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        headerTitleLabels = [dateTitleLabel, dptArptTitleLabel, ArrArptTitleLabel, dptTimeTitleLabel, arrTimeTitleLabel, acNoTitleLabel]
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - Label Text Creation Functions
    
    func showSimpleLabel() {
        self.detailedStackView.isHidden = true
        self.firstHeaderStackView.isHidden = true
        self.secondHeaderStackView.isHidden = true
        self.firstEditableStackView.isHidden = true
        self.secondEditableStackView.isHidden = true
        self.simpleStackView.isHidden = false
//        let curWidth = simpleStackView.frame.width
//        self.simpleStackView.frame.size = CGSize(width: curWidth, height: 100)
        self.contentView.frame.size = CGSize(width: 40, height: 80)
    }
    
    func showDetailedLabel() {
        self.detailedStackView.isHidden = false
        self.firstHeaderStackView.isHidden = false
        self.secondHeaderStackView.isHidden = false
        self.firstEditableStackView.isHidden = false
        self.secondEditableStackView.isHidden = false
        self.simpleStackView.isHidden = true
        self.editButton.layer.frame.size = CGSize(width: 40, height: 120)
    }
    
    func setSimpleLabel() {
        self.showSimpleLabel()
        if let flight = self.flightForCell {
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM-dd-yy"
            
            guard let date = dateFormatter.date(from: flight.date) else {
                print("error formatting date")
                return
            }
            
            self.simpleDateLabel.text = dateFormatter.string(from: date)
            self.simpleDptArptLabel.text = "\n" + flight.departAirport + "\n"
            self.simpleArrArptLabel.text = flight.arriveAirport
            
        } else {
            print("error finding flight for cell")
        }
    }
    
    func setDetailedLabel() {
        self.showDetailedLabel()
        if let flight = self.flightForCell {
            
            let titleAttributes = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: .headline), NSForegroundColorAttributeName: UIColor.black]
            
            let titleStrings: [String] = ["Date", "Dpt Arpt", "Arr Arpt", "Dpt Time", "Arr Time", "A/C No"]
            
            for i in 0...(titleStrings.count - 1) {
                let tempString = NSAttributedString(string: titleStrings[i], attributes: titleAttributes)
                self.headerTitleLabels[i].attributedText = tempString
            }
            
            self.actualDateLabel.attributedText = makeSubtitleText(string: flight.date)
            self.actualDeptArptLabel.attributedText = makeSubtitleText(string: flight.departAirport)
            self.actualArrArptLabel.attributedText = makeSubtitleText(string: flight.arriveAirport)
            
            self.actualDeptTimeLabel.attributedText = makeSubtitleText(string: flight.time)
            // MARK: - ToDO: Replace with actual value, modify flight data model first
            self.actualArrTimeLabel.attributedText = makeSubtitleText(string: "12:00 PM")
            let random = Int(arc4random_uniform(UInt32(277)))
            self.actualAcNoLabel.attributedText = makeSubtitleText(string: "N\(random + 276)")

            
        } else {
            print("error finding flight for cell")
        }
    }
    
    func makeSubtitleText(string: String) -> NSAttributedString {
        let subtitleAttributes = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: .subheadline)]
        return NSAttributedString(string: string, attributes: subtitleAttributes)
    }
    
}
