//
//  Utilities.swift
//  On The Fly
//
//  Created by Scott Higgins on 1/24/17.
//  Copyright © 2017 Team 152 - Easily The Best. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    func setSizeFont (sizeFont: Double) {
        self.font =  UIFont(name: self.font.fontName, size: CGFloat(sizeFont))!
        self.sizeToFit()
    }
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}

struct Style{
    
    // MARK: ToDo Fix Colors and Font Sizes
    static var sectionHeaderTitleFont = UIFont(name: "Helvetica-Bold", size: 20)
    static var sectionHeaderTitleColor = UIColor.white
    static var sectionHeaderBackgroundColor = UIColor.black
    static var sectionHeaderBackgroundColorHighlighted = UIColor.gray
    static var sectionHeaderAlpha: CGFloat = 1.0
    
    static var mainBackgroundColor = UIColor(netHex: 0x4A75FF)
    static var greenAccentColor = UIColor(netHex: 0x35DB32)
    
    // MARK: ToDO Implement theme selection
    // http://sdbr.net/post/Themes-in-Swift/
    
}
