//
//  UIViewExtension.swift
//  Traveler
//
//  Created by Ashutosh on 4/18/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
 
    func roundRectView () {
        self.roundRectView(0.5, borderColor: UIColor.whiteColor())
    }
    
    func roundRectView (borderWidth: CGFloat, borderColor: UIColor) {
        self.layer.borderWidth     = borderWidth
        self.layer.cornerRadius    = self.frame.size.width/2
        self.layer.borderColor     = borderColor.CGColor
        self.layer.masksToBounds   = true
    }
    
    func round(corners: UIRectCorner, radius: CGFloat) -> CAShapeLayer {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.CGPath
        self.layer.mask = mask
        return mask
    }
    
    func addSubviewWithLayoutConstraint(newView:UIView){
        newView.frame = self.bounds
        self.addSubview(newView)
        
        let horizontalConstraint = NSLayoutConstraint(item: newView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
        self.addConstraint(horizontalConstraint)
        
        let verticalConstraint = NSLayoutConstraint(item: newView, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0)
        self.addConstraint(verticalConstraint)
        
        let widthConstraint = NSLayoutConstraint(item: newView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: 0)
        self.addConstraint(widthConstraint)
        
        let heightConstraint = NSLayoutConstraint(item: newView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Height, multiplier: 1, constant: 0)
        self.addConstraint(heightConstraint)
    }

    func createImageFromView() -> UIImage {
        UIGraphicsBeginImageContext(self.bounds.size)
        self.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let screenShotimage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return screenShotimage
    }
}