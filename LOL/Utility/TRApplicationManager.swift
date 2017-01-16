//
//  TRApplicationManager.swift
//  Traveler
//
//  Created by Ashutosh on 2/25/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation
import UIKit
import XCGLogger
import Alamofire
import SlideMenuControllerSwift
import SwiftyJSON
import pop


class TRApplicationManager: NSObject {
    
    // MARK:- Instances
    
    private let REQUEST_TIME_OUT = 30.0
    private let UPCOMING_EVENT_TIME_THREASHOLD = 1
    
    // Shared Instance
    static let sharedInstance = TRApplicationManager()
    
    //XCGLogger Instance
    let log = XCGLogger.defaultInstance()
    
    //StoryBoard Manager Instance
    let stroryBoardManager = TRStoryBoardManager()
    
    //Event Info Objet
    lazy var eventsList: [TREventInfo] = []

    //Event Info Objet
    lazy var eventsListActivity: [TRActivityInfo] = []

    //My Future Events
    lazy var myFutureEvents: [TRActivityInfo] = []
    
    //My Current Events
    lazy var myCurrentEvents: [TRActivityInfo] = []
    
    //Activity List
    lazy var activityList: [TRActivityInfo] = []
    
    // Activity Indicator
    var activityIndicator = TRActivityIndicatorView()
    
    // Error Notification View 
    var errorNotificationView = TRErrorNotificationView()
    
    //AlamoreFire Manager
    var alamoFireManager : Alamofire.Manager?
    
    //NSURL Session Config
    var configuration: NSURLSessionConfiguration?
    
    // SlideMenu Controller
    var slideMenuController = SlideMenuController()
    
    //Bungie Groups
    lazy var bungieGroups: [TRBungieGroupInfo] = []
    
    // FireBase Manager
    var fireBaseManager: TRFireBaseManager?

    //Push Notification View Array
    var pushNotificationViewArray: [TRPushNotificationView] = []
    
    //Current View Controller
    var currentViewController: TRBaseViewController?
    
    //Push Notification Controller (Active State)
    var pushNotiController: TRPushNotiController?
    
    //Branch Manager
    var branchManager: TRBranchManager?
    
    //Current User
    var currentUser: TRUserInfo?
    
    //Total Users
    var totalUsers: Int?
    
    // unVerified Prompt
    var verificationPrompt = TRVerificationPromptView()

    // Invitation Info
    var invitation: TRInvitationInfo?
    
    //Bungie Login Validation
    var bungieVarificationHelper: TRBungieLoginValidation = TRBungieLoginValidation()
    
    //APP Configuration
    var appConfiguration: TRConfigInfo?
    
    //Bungie Alamofire Request
    var bungieAlamoFireManager : Alamofire.Manager?
    
    
    // MARK:- Initializer
    private override init() {
        super.init()
        
        // Network Configuration
        self.configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        self.configuration!.timeoutIntervalForRequest = REQUEST_TIME_OUT
        self.configuration!.timeoutIntervalForResource = REQUEST_TIME_OUT
        self.configuration!.HTTPAdditionalHeaders = TRFunnelData.getData(nil)
        self.alamoFireManager = Alamofire.Manager(configuration: self.configuration!)

        
        #if DEBUG
            self.log.setup(.Debug, showLogLevel: true, showFileNames: true, showLineNumbers: true, writeToFile: nil)
            self.log.xcodeColorsEnabled = true
        #else
            self.log.setup(.Debug, showLogLevel: true, showFileNames: true, showLineNumbers: true, writeToFile: nil)
        #endif
        
        // Init Activity Indicator with nib
        self.activityIndicator = NSBundle.mainBundle().loadNibNamed("TRActivityIndicatorView", owner: self, options: nil)[0] as! TRActivityIndicatorView
        
        // Init Error Notification View with nib
        self.errorNotificationView = NSBundle.mainBundle().loadNibNamed("TRErrorNotificationView", owner: self, options: nil)[0] as! TRErrorNotificationView
        
        //Init Push Notification Controller (Active State)
        self.pushNotiController = TRPushNotiController()
        
        
        // Notification Observer
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(TRApplicationManager.didReceiveRemoteNotificationInActiveSesion(_:)),
                                                         name: K.NOTIFICATION_TYPE.REMOTE_NOTIFICATION_WITH_ACTIVE_SESSION,
                                                         object: nil)
        
        //Init FireBase Manager
        self.fireBaseManager = TRFireBaseManager()
        
        //Init Branch Manager
        self.branchManager = TRBranchManager()
    }

    
    func didReceiveRemoteNotificationInActiveSesion(sender: NSNotification) {
        
        let pushInfo = TRActiveStatePushInfo()
        pushInfo.parsePushNotificationPayLoad(sender)
        self.pushNotiController?.showActiveNotificationView(pushInfo, isExistingPushView: false)
    }

    
    func addSlideMenuController(parentViewController: TRBaseViewController, pushData: NSDictionary?, branchData:NSDictionary?, showLandingPage: Bool, showGroups: Bool) {

        let storyboard = UIStoryboard(name: K.StoryBoard.StoryBoard_Main, bundle: nil)
        let profileViewController = storyboard.instantiateViewControllerWithIdentifier(K.VIEWCONTROLLER_IDENTIFIERS.VIEW_CONTROLLER_PROFILE) as! TRProfileViewController
        let eventListViewController = storyboard.instantiateViewControllerWithIdentifier(K.VIEWCONTROLLER_IDENTIFIERS.VIEWCONTROLLER_EVENT_LIST) as! TREventListViewController
        let getGroupsViewController = storyboard.instantiateViewControllerWithIdentifier(K.VIEWCONTROLLER_IDENTIFIERS.VIEW_CONTROLLER_CHOOSE_GROUP) as! TRChooseGroupViewController
        getGroupsViewController.delegate = eventListViewController
        
        self.slideMenuController = SlideMenuController(mainViewController:eventListViewController, leftMenuViewController: profileViewController, rightMenuViewController: getGroupsViewController)
        self.slideMenuController.automaticallyAdjustsScrollViewInsets = true
        self.slideMenuController.closeRight()
        self.slideMenuController.closeLeft()
        self.slideMenuController.rightPanGesture?.enabled = true
        self.slideMenuController.leftPanGesture?.enabled = true
        
        if DeviceType.IS_IPHONE_4_OR_LESS || DeviceType.IS_IPHONE_5 {
            self.slideMenuController.changeLeftViewWidth(290)
            self.slideMenuController.changeRightViewWidth(290)
        } else {
            self.slideMenuController.changeLeftViewWidth(340)
            self.slideMenuController.changeRightViewWidth(340)
        }
        
        SlideMenuOptions.leftBezelWidth = 0.0
        SlideMenuOptions.rightBezelWidth = 0.0

        var animated = false
        if let _ = pushData {
            if let _ = pushData!.objectForKey("payload") as? NSDictionary {
                animated = true
            }
        }
        
        
        self.slideMenuController.view.alpha = 0
        parentViewController.presentViewController(self.slideMenuController, animated: animated, completion: {
            
            if let _ = pushData {
                
                self.slideMenuController.view.alpha = 0.7
                self.fetchBungieGroups(false, completion: { (didSucceed) in
                    self.slideMenuController.view.alpha = 1
                    eventListViewController.updateGroupImage()
                })

                if let payload = pushData!.objectForKey("payload") as? NSDictionary{
                    let _ = TRPushNotification().fetchEventFromPushNotification(payload, complete: { (event) in
                        if let _ = event {
                            eventListViewController.showEventInfoViewController(event, fromPushNoti: true)
                        }
                    })
                }
            } else if ((branchData) != nil) {
                self.slideMenuController.view.alpha = 0.7
                self.fetchBungieGroups(false, completion: { (didSucceed) in
                    self.slideMenuController.view.alpha = 1
                    eventListViewController.updateGroupImage()
                })
                
                let eventID = branchData!["eventId"] as? String
                let activityName = branchData!["activityName"] as? String
                
                eventListViewController.fetchEventDetailForDeepLink(eventID!, activityName: activityName!)
            } else {
                //Fetch Events
                
                self.slideMenuController.view.alpha = 0.6
                self.fetchBungieGroups(false, completion: { (didSucceed) in
                    self.slideMenuController.view.alpha = 1
                    eventListViewController.updateGroupImage()
                })
            }
        })
    }
    
    func addPostActionbranchDeepLink (eventID: String, activityName: String, params: NSDictionary) {
       
        if var currentView = UIApplication.topViewController() {
            
            if currentView.isKindOfClass(TRRootViewController) == true {
                let rootViewController = UIApplication.sharedApplication().delegate?.window!!.rootViewController as! TRRootViewController
                rootViewController.branchLinkData = params
            } else if currentView.isKindOfClass(SlideMenuController) {
                
                currentView = currentView as! SlideMenuController
                let slideVewController = currentView as! SlideMenuController
                let eventListView = slideVewController.mainViewController! as? TREventListViewController
                
                if TRApplicationManager.sharedInstance.slideMenuController.isLeftOpen() {
                    let leftView = TRApplicationManager.sharedInstance.slideMenuController.leftViewController as! TRProfileViewController
                    leftView.dismissViewController(false, dismissed: { (didDismiss) in
                        eventListView!.fetchEventDetailForDeepLink(eventID, activityName: activityName)
                    })
                } else if (TRApplicationManager.sharedInstance.slideMenuController.isRightOpen()) {
                    let rightView = TRApplicationManager.sharedInstance.slideMenuController.rightViewController as! TRChooseGroupViewController
                    rightView.dismissViewController(false, dismissed: { (didDismiss) in
                        eventListView!.fetchEventDetailForDeepLink(eventID, activityName: activityName)
                    })
                } else {
                    eventListView!.fetchEventDetailForDeepLink(eventID, activityName: activityName)
                }
            } else {
                currentView.dismissViewControllerAnimated(false, completion: {
                    if let _ = self.slideMenuController.mainViewController {
                        let eventListView = self.slideMenuController.mainViewController as! TREventListViewController
                        eventListView.fetchEventDetailForDeepLink(eventID, activityName: activityName)
                    }
                })
            }
        }
    }
    
    func fetchBungieGroups (openSliderMenu: Bool, completion: TRValueCallBack) {
        _ = TRGetAllDestinyGroups().getAllGroups({ (didSucceed) in
            if didSucceed == true {
                if openSliderMenu == true {
                    self.slideMenuController.rightViewController!.openRight()
                }
                
                completion(didSucceed: true)
            }
        })
    }

    func addUnVerifiedUserPromptWithDelegate (delegate: VerificationPopUpProtocol?) {
        self.verificationPrompt = NSBundle.mainBundle().loadNibNamed("TRVerificationPromptView", owner: self, options: nil)[0] as! TRVerificationPromptView
        
        self.verificationPrompt.addVerificationPromptViewWithDelegate(delegate)
    }

    func removeUnVerifiedUserPrompt  () {
        self.verificationPrompt.removeVerificationPromptView()
    }
    
    func addErrorSubViewWithMessage(errorString: String) {
        self.errorNotificationView.errorSting = errorString
        self.errorNotificationView.addErrorSubViewWithMessage()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getGroupByGroupId (groupId: String) -> TRBungieGroupInfo? {
        let groupsArray = TRApplicationManager.sharedInstance.bungieGroups.filter{$0.groupId == groupId}
        return groupsArray.first
    }
    
    func getEventById (eventId: String) -> TREventInfo? {

        let eventObjectArray = TRApplicationManager.sharedInstance.eventsList.filter{$0.eventID == eventId}
        return eventObjectArray.first
    }
    
    func isCurrentPlayerInAnEvent (event: TREventInfo) -> Bool {
        
        let found = event.eventPlayersArray.filter {$0.playerID == TRUserInfo.getUserID()}
        if found.count > 0 {
            return true
        }

        return false
    }
    
    func isCurrentPlayerCreatorOfTheEvent (event: TREventInfo) -> Bool {
        if event.eventCreator?.playerID == TRUserInfo.getUserID() {
            return true
        }
        
        return false
    }
    
    // Rewrite this method- User Server Login Response to save userID, psnID, UserImage -- ASHU
    func getPlayerObjectForCurrentUser () -> TRPlayerInfo? {
        for event in self.eventsList {
            for player in event.eventPlayersArray {
                if player.playerID == TRUserInfo.getUserID() {
                    return player
                }
            }
        }
        
        return nil
    }
    
    //Filter Current Events
    func getCurrentEvents () -> [TREventInfo] {
        let currentInfo = self.eventsList.filter{$0.isFutureEvent == false}
        return currentInfo
    }

    //Filter Future Events
    func getFutureEvents () -> [TREventInfo] {
        let futureInfo = self.eventsList.filter{$0.isFutureEvent == true}
        return futureInfo
    }
    
    // Filter Activity Array Based on ActivityType
    func getActivitiesOfType (activityType: String) -> [TRActivityInfo]? {
        let activityArray = self.activityList.filter {$0.activityType == activityType}
        return activityArray
    }
    
    func getActivitiesMatchingSubTypeAndLevel(activity: TRActivityInfo) -> [TRActivityInfo]? {
        let activityArray = self.activityList.filter {$0.activitySubType == activity.activitySubType && $0.activityDificulty == activity.activityDificulty}
        
        var removeDuplicateArray: [TRActivityInfo] = []
        for (_, activity) in activityArray.enumerate() {
            if (removeDuplicateArray.count < 1) {
                removeDuplicateArray.append(activity)
            } else {
                let activityArray = removeDuplicateArray.filter {$0.activityCheckPoint == activity.activityCheckPoint}
                if (activityArray.count == 0) {
                    removeDuplicateArray.append(activity)
                }
            }
        }
        
        return removeDuplicateArray
    }
    
    func getActivitiesMatchingSubTypeAndLevelAndCheckPoint(activity: TRActivityInfo) -> [TRActivityInfo]? {
        let activityArray = self.activityList.filter {$0.activitySubType == activity.activitySubType && $0.activityDificulty == activity.activityDificulty && $0.activityCheckPoint == activity.activityCheckPoint
        }
        
        return activityArray
    }
    
    func getFeaturedActivities () -> [TRActivityInfo]? {
        let activityArray = self.activityList.filter {$0.activityIsFeatured == true}
        return activityArray
    }
    
    func getCurrentGroup (groupID: String) -> TRBungieGroupInfo? {
        let currentGroupArray = self.bungieGroups.filter {$0.groupId == groupID}
        return currentGroupArray.first
    }
    
    func purgeSavedData () {
        self.activityList.removeAll()
        self.eventsList.removeAll()
        self.bungieGroups.removeAll()
        self.eventsListActivity.removeAll()
        self.myFutureEvents.removeAll()
        self.myCurrentEvents.removeAll()
        self.pushNotificationViewArray.removeAll()
    }
}

