//
//  TRActivityCheckPointPicker.swift
//  Traveler
//
//  Created by Ashutosh on 3/10/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation
import UIKit


class TRActivityCheckPointPicker: UIView {
    
    @IBOutlet var pickerView: UIPickerView!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var buttonContainerView: UIView!
    @IBOutlet var doneButton: UIButton!

    override func layoutSubviews() {

        self.pickerView?.layer.cornerRadius = 5.0
        self.pickerView?.backgroundColor = UIColor.whiteColor()
        self.pickerView?.layer.masksToBounds = true
        
        self.buttonContainerView?.layer.cornerRadius = 5.0
        self.buttonContainerView?.backgroundColor = UIColor.whiteColor()
        self.buttonContainerView?.layer.masksToBounds = true
        
        // Setting it hidden 
        self.buttonContainerView?.hidden = true
    }
}

