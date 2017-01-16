//
//  TRPushNotificationView.swift
//  Traveler
//
//  Created by Ashutosh on 3/17/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation
import UIKit


protocol NotificationViewProtocol {
    func activeNotificationViewClosed ()
}

class TRPushNotificationView: UIView {
    
    let ACTION_MARGIN = CGFloat(120) //%%% distance from center where the action applies. Higher = swipe further in order for the action to be called
    let SCALE_STRENGTH = CGFloat(4) //%%% how quickly the card shrinks. Higher = slower shrinking
    let SCALE_MAX = CGFloat(0.93) //%%% upper bar for how much the card shrinks. Higher = shrinks less
    let ROTATION_MAX = CGFloat(1) //%%% the maximum rotation allowed in radians.  Higher = card can keep rotating longer
    let ROTATION_STRENGTH = CGFloat(320) //%%% strength of rotation. Higher = weaker rotation
    let ROTATION_ANGLE = CGFloat(M_PI/8) //%%% Higher = stronger rotation angle
    var originalPoint: CGPoint?
    var xFromCenter = CGFloat()
    var yFromCenter = CGFloat()

    
    @IBOutlet weak var eventStatusLabel: UILabel!
    @IBOutlet weak var eventStatusDescription: UILabel!
    @IBOutlet weak var panGesture: UIPanGestureRecognizer!
    @IBOutlet weak var eventIconView: UIImageView!
    @IBOutlet weak var consoleName: UILabel!
    @IBOutlet weak var labelSecondHeightConstraint: NSLayoutConstraint!
    
    // Parents View Controller
    var delegate: NotificationViewProtocol?
    var pushInfo: TRActiveStatePushInfo?
    var parentView: TRBaseViewController?
    var eventDescriptionFrame: CGRect?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let shadowPath = UIBezierPath(rect: bounds)
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.blackColor().CGColor
        self.layer.shadowOffset = CGSizeMake(0.0, 5.0)
        self.layer.shadowOpacity = 0.5
        self.layer.shadowPath = shadowPath.CGPath
        
        //Add radius
        self.layer.cornerRadius = 2.0
    }
    
    
    
    @IBAction func openEventDetailViewController () {
        if let eventID = pushInfo?.eventID {
            self.parentView!.showEventDetailView(eventID)
            self.closeErrorView()
        }
    }
    
    func closeErrorView () {
        
        if let _ = TRApplicationManager.sharedInstance.pushNotificationViewArray.last {
            TRApplicationManager.sharedInstance.pushNotificationViewArray.removeLast()
        }

        self.parentView?.activeNotificationViewClosed()
        self.delegate?.activeNotificationViewClosed()

        self.delegate = nil
        self.pushInfo = nil
        self.parentView = nil
        self.eventDescriptionFrame = nil
        
        self.removeFromSuperview()
    }

    func closeErrorViewInBackground () {
        
        self.parentView?.activeNotificationViewClosed()
        self.delegate = nil
        self.pushInfo = nil
        self.parentView = nil
        self.eventDescriptionFrame = nil
        
        self.removeFromSuperview()
    }
    
    func addNotificationViewWithMessages (pushInfo: TRActiveStatePushInfo, parentView: TRBaseViewController) -> TRPushNotificationView {

        self.pushInfo = pushInfo
        self.parentView = parentView
        
        if pushInfo.isMessageNotification == true {
            if let alertString = pushInfo.alertString {
                self.eventStatusLabel?.text = pushInfo.playerMessageConsoleName!
                self.consoleName.hidden = true
                self.labelSecondHeightConstraint.constant = 0.0
                self.eventStatusDescription.text =  alertString
                let font = UIFont(name: "Helvetica", size: 14.0)
                let height = self.heightWithConstrainedWidth((parentView.view.frame.width - 107), font: font!)
                self.updateFrameWithHeight(height + 10)
            }
        } else {
            if let eventName = pushInfo.eventName {
                self.consoleName.text = eventName.uppercaseString
                let font = UIFont(name: "Helvetica", size: 14.0)
                let height = self.heightWithConstrainedWidth((parentView.view.frame.width - 107), font: font!)
                self.updateFrameWithHeight(height + 10)
            }
            if let alertString = pushInfo.alertString {
                self.eventStatusDescription.text =  alertString
                let font = UIFont(name: "Helvetica", size: 14.0)
                let height = self.heightWithConstrainedWidth((parentView.view.frame.width - 107), font: font!)
                self.updateFrameWithHeight(height + 10)
            }
            
            if let _ = pushInfo.eventClanName, _ = pushInfo.eventconsole {
                self.eventStatusLabel.text = pushInfo.eventconsole! + ": " + pushInfo.eventClanName!
            } else {
                self.eventStatusLabel.hidden = true
            }
        }
    
        if pushInfo.isMessageNotification == true {
            if let userHalmet = pushInfo.halmetImage {
                self.eventIconView?.sd_setImageWithURL(NSURL(string: userHalmet), placeholderImage: UIImage(named: "iconAlert"))
                self.eventIconView.roundRectView()
            }
        } else {
            if let hasImage = pushInfo.imageURL  {
                self.eventIconView?.sd_setImageWithURL(NSURL(string: hasImage), placeholderImage: UIImage(named: "iconAlert"))
                self.eventIconView?.layer.borderColor = UIColor.whiteColor().CGColor
                self.eventIconView?.layer.borderWidth     = 1.0
                self.eventIconView?.layer.borderColor     = UIColor.whiteColor().CGColor
                self.eventIconView?.layer.masksToBounds   = true
            }
        }

        self.eventDescriptionFrame = self.eventStatusDescription.frame
        
        return self
    }
    
    
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: CGFloat.max)
        
        let boundingBox = self.eventStatusDescription.text!.boundingRectWithSize(constraintRect, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        return boundingBox.height
    }
    
    func updateFrameWithHeight (height: CGFloat) {
        self.frame = CGRectMake(self.frame.origin.x + 9, self.frame.origin.y, self.frame.size.width - 18, self.eventStatusDescription.frame.origin.y + height)
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
            self.center = CGPointMake(self.originalPoint!.x + xFromCenter, self.originalPoint!.y + yFromCenter)
            
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
        if (xFromCenter > ACTION_MARGIN) {
            rightAction()
        } else if (xFromCenter < -ACTION_MARGIN){
            leftAction()
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
    
    func leftAction() {
        animateCardToTheLeft()
    }
    
    func animateCardToTheLeft() {
        let leftEdge = CGFloat(-500)
        animateCardOutTo(leftEdge)
    }
    
    func animateCardOutTo(edge: CGFloat) {
        let finishPoint = CGPointMake(edge, 2*yFromCenter + self.originalPoint!.y)
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


