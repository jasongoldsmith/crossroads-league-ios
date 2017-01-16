//
//  TRCustomError.swift
//  Traveler
//
//  Created by Ashutosh on 9/27/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation


@objc protocol CustomErrorDelegate {
    optional func okButtonPressed ()
    optional func customErrorActionButtonPressed ()
    optional func customErrorActionButtonPressedWithSelector(selector: Selector)
}


class TRCustomError: UIView {
 
    var delegate: CustomErrorDelegate?
    var selector: Selector?
    
    @IBOutlet weak var errorViewContainer: UIView!
    @IBOutlet weak var errorMessageHeader: UILabel!
    @IBOutlet weak var errorMessageDescription: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var crossButton: UIButton!
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        
        self.actionButton?.layer.cornerRadius = 2.0
        self.errorViewContainer?.layer.cornerRadius = 2.0
    }
    
    override func layoutSubviews () {
        super.layoutSubviews()
    }
    
    
    @IBAction func cancelView () {
        self.removeView()
    }
    
    @IBAction func closeView () {
        self.delegate?.okButtonPressed!()
        self.removeView()
    }
    
    @IBAction func actionButtonPressed () {
        
        if let _ = self.selector {
            self.delegate?.customErrorActionButtonPressedWithSelector!(self.selector!)
        } else {
            self.delegate?.customErrorActionButtonPressed!()
        }
        
        self.removeView()
    }
    
    func removeView () {
        if let _ = self.delegate {
            self.delegate = nil
        }
        
        self.removeFromSuperview()
    }
}