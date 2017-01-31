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
    
    let ACTION_MARGIN = CGFloat(20) //%%% distance from center where the action applies. Higher = swipe further in order for the action to be called
    let SCALE_STRENGTH = CGFloat(4) //%%% how quickly the card shrinks. Higher = slower shrinking
    let SCALE_MAX = CGFloat(0.93) //%%% upper bar for how much the card shrinks. Higher = shrinks less
    let ROTATION_MAX = CGFloat(1) //%%% the maximum rotation allowed in radians.  Higher = card can keep rotating longer
    let ROTATION_STRENGTH = CGFloat(320) //%%% strength of rotation. Higher = weaker rotation
    let ROTATION_ANGLE = CGFloat(M_PI/8) //%%% Higher = stronger rotation angle
    var originalPoint: CGPoint?
    var xFromCenter = CGFloat()
    var yFromCenter = CGFloat()

    
    var errorSting: String? = nil
    @IBOutlet weak var errorMessage: TRInsertLabel!
    @IBOutlet weak var errorContainerView: UIView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.autoresizingMask = [.FlexibleRightMargin, .FlexibleLeftMargin]
    }
    
    func closeErrorView () {
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
    
    //MARK:- Pan Gesture
    @IBAction func beginDragging (gestureRecognizer: UIPanGestureRecognizer) {
        
        self.xFromCenter = gestureRecognizer.translationInView(self).x
        self.yFromCenter = gestureRecognizer.translationInView(self).y
        
        switch gestureRecognizer.state {
        case .Began:
            self.originalPoint = self.center
            break
        case .Changed:
            //%%% dictates rotation (see ROTATION_MAX and ROTATION_STRENGTH for details)
            let rotationStrength = min(xFromCenter / ROTATION_STRENGTH, ROTATION_MAX)
            
            //%%% degree change in radians
            let rotationAngel: CGFloat = 0.0
            
            //%%% amount the height changes when you move the card up to a certain point
            let scale = max(1 - fabs(rotationStrength) / SCALE_STRENGTH, SCALE_MAX)
            
            //%%% move the object's center by center + gesture coordinate
            self.center = CGPointMake(self.originalPoint!.x, self.originalPoint!.y + yFromCenter)
            
            //%%% rotate by certain amount
            let transform = CGAffineTransformMakeRotation(rotationAngel)
            
            //%%% scale by certain amount
            let scaleTransform = CGAffineTransformScale(transform, scale, scale)
            
            //%%% apply transformations
            self.transform = scaleTransform
            
            break
        case .Ended:
            self.afterSwipeAction()
            break
        default:
            break
        }
    }
    
    func afterSwipeAction() {
        if (yFromCenter < -ACTION_MARGIN){
            topAction()
        } else {
            animateCardBack()
        }
    }
    
    func rightAction() {
        animateCardToTheRight()
    }
    
    func animateCardToTheRight() {
        let rightEdge = CGFloat(500)
        animateCardOutTo(rightEdge)
    }
    
    func topAction() {
        animateCardToTheTop()
    }
    
    func animateCardToTheTop() {
        let topEdge = CGFloat(-500)
        animateCardOutTo(topEdge)
    }
    
    func animateCardOutTo(edge: CGFloat) {
        let finishPoint = CGPointMake(2*xFromCenter + self.originalPoint!.x, edge)
        UIView.animateWithDuration(0.3, animations: {
            self.center = finishPoint;
            }, completion: {
                (value: Bool) in
                self.closeErrorView()
        })
    }
    
    func animateCardBack() {
        UIView.animateWithDuration(0.3, animations: {
            self.center = self.originalPoint!;
            self.transform = CGAffineTransformMakeRotation(0);
            }
        )
    }
}


