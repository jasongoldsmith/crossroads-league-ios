//
//  TRDatePicker.swift
//  Traveler
//
//  Created by Ashutosh on 8/10/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation

protocol TRDatePickerProtocol {
    func closeDatePicker()
}

class TRDatePicker: UIView {
 
    //Delegate
    var delegate: TRDatePickerProtocol?
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.datePicker?.layer.cornerRadius = 5.0
        self.datePicker?.backgroundColor = UIColor.whiteColor()
        self.datePicker?.layer.masksToBounds = true
        
        self.datePicker?.minimumDate = NSDate()
    }
    
    @IBAction func closePickerView (sender: UITapGestureRecognizer) {
        self.delegate?.closeDatePicker()
        self.delegate = nil
        self.removeFromSuperview()
    }
}