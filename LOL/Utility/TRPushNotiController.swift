//
//  TRPushNotiController.swift
//  Traveler
//
//  Created by Ashutosh on 7/25/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation

import Foundation
import pop
import SlideMenuControllerSwift

class TRPushNotiController: NSObject, NotificationViewProtocol {
    
    lazy var eventDetailPushViews: [TRPushNotificationView] = []
    
    override init () {
    }
    
    func showActiveNotificationView (pushInfo: TRActiveStatePushInfo, isExistingPushView: Bool) {
        if var currentView = UIApplication.topViewController() {
            var parentView: UIViewController?
            if currentView.isKindOfClass(SlideMenuController) {
                currentView = currentView as! SlideMenuController
                let slideVewController = currentView as! SlideMenuController
                if TRApplicationManager.sharedInstance.slideMenuController.isLeftOpen() || TRApplicationManager.sharedInstance.slideMenuController.isRightOpen() {
                    return
                } else {
                    if let eventListView = slideVewController.mainViewController! as? TREventListViewController {
                        parentView = eventListView
                    }
                }
            } else {
                let slideVewController = TRApplicationManager.sharedInstance.slideMenuController
                let eventListView = slideVewController.mainViewController! as? TREventListViewController
                parentView = eventListView
            }
            
            // If Parent View is nil, just return
            guard let _ = parentView else {
                return
            }
            
            let notificationview = self.addActiveNotificationViewWithParentView(pushInfo, parentViewController: parentView as! TRBaseViewController, isExistingPushView: isExistingPushView)
            
            if isExistingPushView == false {
                notificationview.parentView = parentView as? TRBaseViewController
                parentView!.view.addSubview(notificationview)
            }
            
            //Add Animation and Move Table Down
            let lastPushView = TRApplicationManager.sharedInstance.pushNotificationViewArray.first
            if let _ = lastPushView {
                self.addPushAnimationAndResetTableViewOffSet(lastPushView!, parentView: parentView!, isExistingPushView: isExistingPushView)
            }
        }
    }
    
    func addPushAnimationAndResetTableViewOffSet (notificationview: TRPushNotificationView, parentView: UIViewController, isExistingPushView: Bool) {
        if parentView.isKindOfClass(TREventListViewController) {
            let eventView = parentView as! TREventListViewController
            eventView.notificationShowMoveTableDown(notificationview.frame.height + 13)
        }
    }
    
    func addActiveNotificationViewWithParentView (pushInfo: TRActiveStatePushInfo, parentViewController: TRBaseViewController, isExistingPushView: Bool) -> TRPushNotificationView {
        
        let yOffSet = parentViewController.isKindOfClass(TREventListViewController) ? CGFloat(107) : CGFloat(190)
        
        if TRApplicationManager.sharedInstance.pushNotificationViewArray.count < 1 {
            let notificationview = self.createNotificationViewWithMessages(pushInfo, parentViewController: parentViewController, isExistingPushView: isExistingPushView)
            notificationview.frame = CGRectMake(9, yOffSet, ((UIApplication.topViewController()?.view.frame.size.width)! - 18), notificationview.frame.size.height)
            
            return notificationview
        } else {
            let newNotificationview = self.createNotificationViewWithMessages(pushInfo, parentViewController: parentViewController, isExistingPushView: isExistingPushView)
            newNotificationview.frame = CGRectMake(9, yOffSet, (UIApplication.topViewController()!.view.frame.size.width) - 18, newNotificationview.frame.size.height)
            
            if TRApplicationManager.sharedInstance.pushNotificationViewArray.count == 1 {
                newNotificationview.eventStatusLabel.text = newNotificationview.pushInfo?.alertString
                return newNotificationview
            } else {
                for notificationView in TRApplicationManager.sharedInstance.pushNotificationViewArray where notificationView != TRApplicationManager.sharedInstance.pushNotificationViewArray.last  {
                    notificationView.frame = CGRectMake(notificationView.frame.origin.x, notificationView.frame.origin.y, notificationView.frame.size.width, newNotificationview.frame.size.height + 12)
                    
                    
                    let text = notificationView.eventStatusDescription.text
                    let stringLength = text?.characters.count
                    if notificationView.eventStatusDescription.frame.height > 32 {
                        let substringIndex = stringLength! - 70
                        if substringIndex > 15 {
                            let truncated = (text! as NSString).substringToIndex(substringIndex)
                            notificationView.eventStatusDescription.frame = newNotificationview.eventDescriptionFrame!
                            notificationView.eventStatusDescription.text = truncated
                        }
                    }
                }
            }
            
            return newNotificationview
        }
    }
    
    
    func createNotificationViewWithMessages (pushInfo: TRActiveStatePushInfo, parentViewController: TRBaseViewController, isExistingPushView: Bool) -> TRPushNotificationView {
        
        //Push Notification View
        var pushNotificationView = TRPushNotificationView()
        
        // Init Push Notification View with nib
        pushNotificationView = NSBundle.mainBundle().loadNibNamed("TRPushNotificationView", owner: self, options: nil)[0] as! TRPushNotificationView
        pushNotificationView.addNotificationViewWithMessages(pushInfo, parentView:parentViewController)
        pushNotificationView.delegate  = self
        
        if isExistingPushView == false {
            TRApplicationManager.sharedInstance.pushNotificationViewArray.append(pushNotificationView)
        }
        
        return pushNotificationView
    }
    
    func activeNotificationViewClosed () {
        
        let topNotificationview = TRApplicationManager.sharedInstance.pushNotificationViewArray.last
        
        guard let _ = topNotificationview else {
            return
        }
        
        guard let _ = topNotificationview?.pushInfo else {
            return
        }
        

        var pushNotificationView = TRPushNotificationView()
        pushNotificationView = NSBundle.mainBundle().loadNibNamed("TRPushNotificationView", owner: self, options: nil)[0] as! TRPushNotificationView
        pushNotificationView.addNotificationViewWithMessages((topNotificationview?.pushInfo)!, parentView:(topNotificationview?.parentView)!)
        
        topNotificationview!.frame = CGRectMake((topNotificationview?.frame.origin.x)!, (topNotificationview?.frame.origin.y)!, (topNotificationview?.frame.width)!, pushNotificationView.frame.size.height)
        topNotificationview?.eventStatusDescription.text = (topNotificationview?.pushInfo?.alertString)!
        
        for notificationView in TRApplicationManager.sharedInstance.pushNotificationViewArray where notificationView != TRApplicationManager.sharedInstance.pushNotificationViewArray.last  {
            notificationView.frame = CGRectMake(notificationView.frame.origin.x, notificationView.frame.origin.y, notificationView.frame.size.width, topNotificationview!.frame.size.height + 8)
        }
        
        //Add Animation and Move Table Down
        let lastPushView = TRApplicationManager.sharedInstance.pushNotificationViewArray.first
        if let _ = lastPushView {
            self.addPushAnimationAndResetTableViewOffSet(lastPushView!, parentView: pushNotificationView.parentView!, isExistingPushView: true)
        }
    }
    
    func refreshPushViewForParent (parentView: TRBaseViewController) {
        
    }
    
    // Called when event detail is closed.
    func deleteAllNotificationsWithEventID (eventID: String) {
        
        let eventListView = TRApplicationManager.sharedInstance.slideMenuController.mainViewController! as? TREventListViewController
        
        // Delete array which stores push views for Event Detail
        self.eventDetailPushViews.removeAll()
        
        var tempPushViewArray:[TRPushNotificationView] = []
        for (_, pushView) in TRApplicationManager.sharedInstance.pushNotificationViewArray.enumerate(){
                let pushEventID = (pushView.pushInfo?.eventID!)! as String
                let eventID = eventID as String
            
                if pushEventID == eventID {
                    if pushView.pushInfo?.isMessageNotification == true {
                        pushView.parentView = eventListView
                        tempPushViewArray.append(pushView)
                    } else {
                        pushView.closeErrorViewInBackground()
                        pushView.removeFromSuperview()
                    }
                } else {
                    pushView.parentView = eventListView
                    tempPushViewArray.append(pushView)
            }
        }
        
        TRApplicationManager.sharedInstance.pushNotificationViewArray.removeAll()
        TRApplicationManager.sharedInstance.pushNotificationViewArray = tempPushViewArray
        
        
        for pushViews in TRApplicationManager.sharedInstance.pushNotificationViewArray {
            eventListView?.view.addSubview(pushViews)
            
            pushViews.frame = CGRectMake(pushViews.frame.origin.x, 107, pushViews.frame.size.width, pushViews.frame.size.height)
            self.showActiveNotificationView(pushViews.pushInfo!, isExistingPushView: true)
        }
        
        if TRApplicationManager.sharedInstance.pushNotificationViewArray.count == 0 {
            eventListView!.activeNotificationViewClosed()
        }
    }
    
    func showAllNotificationsWithEventID (eventID: String, parentView: UIViewController) {
        
        self.eventDetailPushViews = TRApplicationManager.sharedInstance.pushNotificationViewArray
        for (_, pushView) in self.eventDetailPushViews.enumerate(){
            let pushEventID = (pushView.pushInfo?.eventID!)! as String
            let eventID = eventID as String
            
            if pushEventID == eventID && pushView.pushInfo?.isMessageNotification == true {
                
                let pushNotiView = self.addActiveNotificationViewWithParentView(pushView.pushInfo!, parentViewController: parentView as! TRBaseViewController, isExistingPushView: true)
                
                pushView.frame = pushNotiView.frame
                self.addPushAnimationAndResetTableViewOffSet(pushNotiView, parentView: parentView, isExistingPushView: true)
                pushView.eventStatusDescription.text = pushView.pushInfo?.alertString
                pushView.parentView = parentView as? TRBaseViewController
                parentView.view.addSubview(pushView)
            }
        }
    }
}
