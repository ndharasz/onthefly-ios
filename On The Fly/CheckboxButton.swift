//
//  CheckboxButton.swift
//  On The Fly
//
//  Created by Scott Higgins on 1/26/17.
//  Copyright © 2017 Team 152 - Easily The Best. All rights reserved.
//

import UIKit

class CheckboxButton: UIButton {
    
    var checkedImage = UIImage(named: "checkbox_checked")
    var uncheckedImage = UIImage(named: "checkbox_unchecked")
    var isClicked: Bool = false
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.setImage(uncheckedImage, for: .normal)
        self.isClicked = false
    }
    
    func checkBox() -> Void {
        if self.isClicked {
            self.isClicked = false
            self.changeImageAnimated(image: uncheckedImage)
        } else {
            self.isClicked = true
            self.changeImageAnimated(image: checkedImage)
        }

    }
    
    func checkYes() -> Void {
        self.isClicked = true
        self.imageView?.image = checkedImage
    }
    
    func checkNo() -> Void {
        self.isClicked = false
        self.imageView?.image = uncheckedImage
    }
    
    func isChecked() -> Bool {
        return self.isClicked
    }

}
