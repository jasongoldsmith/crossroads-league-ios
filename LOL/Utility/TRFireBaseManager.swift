//
//  TRFireBaseManager.swift
//  Traveler
//
//  Created by Ashutosh on 7/7/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation
import Firebase
import SwiftyJSON

class TRFireBaseManager {
    
    var ref: FIRDatabaseReference?
    var userObserverHandler: FIRDatabaseHandle?
    var eventListObserverHandler: FIRDatabaseHandle?
    var eventDescriptionObserverHandler: FIRDatabaseHandle?
    var eventDescriptionCommentObserverHandler: FIRDatabaseHandle?
    
    
    typealias TRFireBaseSuccessCallBack = (didCompelete: Bool?) -> ()
    
    //Initialize FireBase Configuration
    func initFireBaseConfig () {
        FIRApp.configure()
    }
    
    
    //MARK:- ADD FIREBASE OBSERVERS
    func addUserObserverWithCompletion (complete: TRFireBaseSuccessCallBack) {
        if let userID = TRUserInfo.getUserID() {
            let endPointKeyReference = userID
            self.ref = FIRDatabase.database().reference().child("users/").child(endPointKeyReference)
            self.userObserverHandler = self.ref?.observeEventType(.Value, withBlock: { (snapshot) in
               
                if let snap = snapshot.value as? NSDictionary {
                    let userData = TRUserInfo()
                    let snapShotJson = JSON(snap)
                    userData.parseUserResponse(snapShotJson)
                    
                    for console in userData.consoles {
                        if console.isPrimary == true {
                            TRUserInfo.saveConsolesObject(console)
                        }
                    }
                    
                    TRUserInfo.saveUserData(userData)
                    
                    // Check if user is VERIFIED and if it is then remove the observer
                    if (TRUserInfo.isUserVerified() == ACCOUNT_VERIFICATION.USER_VERIFIED.rawValue) {
                        self.removeUserObserver()
                    }
                    
                    complete(didCompelete: true)
                }
            })
        }
    }
    
    func addUserObserverWithView (complete: TRFireBaseSuccessCallBack) {
        if let userID = TRUserInfo.getUserID() {
            let endPointKeyReference = userID
            self.ref = FIRDatabase.database().reference().child("users/").child(endPointKeyReference)
            self.userObserverHandler = self.ref?.observeEventType(.Value, withBlock: { (snapshot) in
                
                if let snap = snapshot.value as? NSDictionary {
                    let userData = TRUserInfo()
                    let snapShotJson = JSON(snap)
                    userData.parseUserResponse(snapShotJson)
                    
                    for console in userData.consoles {
                        if console.isPrimary == true {
                            TRUserInfo.saveConsolesObject(console)
                        }
                    }
                    
                    TRUserInfo.saveUserData(userData)
                    complete(didCompelete: true)
                }
            })
        }
    }
    
    func addEventsObserversWithParentView (parentViewController: TRBaseViewController) {
        
        guard let userClan = TRApplicationManager.sharedInstance.currentUser?.userClanID where userClan != "" else {
            return
        }
        
        let endPointKeyReference = userClan
        self.ref = FIRDatabase.database().reference().child("events/").child(endPointKeyReference)
        self.eventListObserverHandler = self.ref?.observeEventType(.Value, withBlock: { (snapshot) in
            _ = TRGetEventsList().getEventsListWithClearActivityBackGround (false, clearBG: true, indicatorTopConstraint: nil, completion: { (didSucceed) -> () in
                if(didSucceed == true) {
                    dispatch_async(dispatch_get_main_queue(), {
                        parentViewController.reloadEventTable()
                    })
                } else {
                    
                }
            })
        })
    }
    
    func addEventsObserversWithParentViewForDetailView (parentViewController: TREventDetailViewController, withEvent: TREventInfo) {
        
        guard let hasEventClan = withEvent.eventClanID else {
            return
        }
        
        guard let hasEventID = withEvent.eventID else {
            return
        }
        
        
        let endPointKeyReference = hasEventClan + "/" + hasEventID
        self.ref = FIRDatabase.database().reference().child("events/").child(endPointKeyReference)
        self.eventDescriptionObserverHandler = self.ref?.observeEventType(.Value, withBlock: { (snapshot) in
            if snapshot.value is NSNull {
                parentViewController.dismissViewController(true, dismissed: { (didDismiss) in
                    
                })
                return
            }

            // FETCH EVENT OBJECT
            _ = TRGetEventRequest().getEventByID(hasEventID, viewHandlesError: false, showActivityIndicator: false, completion: { (error, event) in
                if let _ = event {
                    parentViewController.eventInfo = event
                    dispatch_async(dispatch_get_main_queue(), {
                        parentViewController.reloadEventTable()
                    })
                }
            })
        })
    }
    
    func addCommentsObserversWithParentViewForDetailView (parentViewController: TREventDetailViewController, withEvent: TREventInfo) {
        
        guard let hasEventID = withEvent.eventID else {
            return
        }
        
        
        let endPointKeyReference = "/" + hasEventID
        self.ref = FIRDatabase.database().reference().child("comments/").child(endPointKeyReference)
        self.eventDescriptionCommentObserverHandler = self.ref?.observeEventType(.Value, withBlock: { (snapshot) in
           
            // FETCH EVENT OBJECT
            _ = TRGetEventRequest().getEventByID(hasEventID, viewHandlesError: false, showActivityIndicator: false, completion: { (error, event) in
                if let _ = event {
                    parentViewController.eventInfo = event
                    dispatch_async(dispatch_get_main_queue(), {
                        parentViewController.reloadEventTable()
                    })
                }
            })
        })
    }
    
    //MARK:- REMOVE FIREBASE OBSERVERS
    func removeUserObserver () {
        if let userID = TRUserInfo.getUserID() {
            if let _ = self.userObserverHandler {
                let endPointKeyReference = userID
                self.ref = FIRDatabase.database().reference().child("users/").child(endPointKeyReference)
                self.ref?.removeObserverWithHandle(self.userObserverHandler!)
            }
        }
    }
    
    func removeEventListObserver () {
        guard let userClan = TRApplicationManager.sharedInstance.currentUser?.userClanID else {
            return
        }
        guard let _ = self.eventListObserverHandler else {
            return
        }
        
        let endPointKeyReference = userClan
        self.ref = FIRDatabase.database().reference().child("events/").child(endPointKeyReference)
        self.ref?.removeObserverWithHandle(self.eventListObserverHandler!)
    }

    func removeDetailObserver (withEvent: TREventInfo) {
        guard let hasEventClan = withEvent.eventClanID else {
            return
        }
        guard let hasEventID = withEvent.eventID else {
            return
        }
        guard let _ = self.eventDescriptionObserverHandler else {
            return
        }
        
        let endPointKeyReference = hasEventClan + "/" + hasEventID
        self.ref = FIRDatabase.database().reference().child("events/").child(endPointKeyReference)
        self.ref?.removeObserverWithHandle(self.eventDescriptionObserverHandler!)
    }

    func removeCommentsObserver (withEvent: TREventInfo) {
        
        guard let hasEventClan = withEvent.eventClanID else {
            return
        }
        
        guard let hasEventID = withEvent.eventID else {
            return
        }

        let endPointKeyReference = hasEventClan + "/" + hasEventID
        self.ref = FIRDatabase.database().reference().child("comments/").child(endPointKeyReference)
        
        if let eventDesHandler = self.eventDescriptionObserverHandler {
            self.ref?.removeObserverWithHandle(eventDesHandler)
        }
    }
    
    func removeObservers () {
        self.ref?.removeAllObservers()
    }
}
