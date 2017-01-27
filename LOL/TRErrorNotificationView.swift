//
//  TRErrorNotificationView.swift
//  Traveler
//
//  Created by Ashutosh on 3/17/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation
import UIKit
import pop


class TRErrorNotificationView: UIView {
    
    var errorSting: String? = nil
    @IBOutlet weak var errorMessage: TRInsertLabel!
    @IBOutlet weak var errorContainerView: UIView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.autoresizingMask = [.FlexibleRightMargin, .FlexibleLeftMargin]
    }
    
    @IBAction func closeErrorView (sender: AnyObject) {
        self.removeFromSuperview()
    }
    
    func addErrorSubViewWithMessage () {
        
        if self.superview != nil {
            return
        }
        
        guard let _ = errorSting else {
            return
        }
        
        //Adding Radius 
        self.errorContainerView.layer.cornerRadius = 3.0
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let window = appDelegate.window
        window?.addSubview(self)
        
        let yAxisDistance:CGFloat = -self.frame.height
        let xAxiDistance:CGFloat  = 0
        self.frame = CGRectMake(xAxiDistance, yAxisDistance, window!.frame.width, self.frame.height)
        self.errorMessage.text = errorSting!
        
        let popAnimation:POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPLayerPositionY)
        popAnimation.toValue = self.frame.height - 25
        self.layer.pop_addAnimation(popAnimation, forKey: "slideIn")
        
        delay(5.0) { () -> () in
            let popAnimation:POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPLayerPositionY)
            popAnimation.toValue = -self.frame.height
            popAnimation.completionBlock =  {(animation, finished) in
                self.removeFromSuperview()
            }
            self.layer.pop_addAnimation(popAnimation, forKey: "slideOut")
        }
    }
}


