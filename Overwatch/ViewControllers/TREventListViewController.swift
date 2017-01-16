//
//  TREventListViewController.swift
//  Traveler
//
//  Created by Rangarajan, Srivatsan on 2/20/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import UIKit
import Foundation
import SwiftyJSON
import SlideMenuControllerSwift
import AFDateHelper

private let CURRENT_EVENT_WITH_CHECK_POINT_CELL     = "currentEventCellWithCheckPoint"
private let CURRENT_EVENT_NO_CHECK_POINT_CELL       = "currentEventCellNoCheckPoint"
private let UPCOMING_EVENT_WITH_CHECK_POINT_CELL    = "upcomingEventCellWithCheckPoint"
private let UPCOMING_EVENT_NO_CHECK_POINT_CELL      = "upcomingEventCellNoCheckPoint"
private let EVENT_ACTIVITY_CARD_CELL                = "eventActivityCard"

private let EVENT_TABLE_HEADER_HEIGHT:CGFloat = 10.0

private let EVENT_CURRENT_WITH_CHECK_POINT_CELL_HEIGHT: CGFloat  = 137.0
private let EVENT_CURRENT_NO_CHECK_POINT_CELL_HEIGHT:CGFloat     = 119.0
private let EVENT_UPCOMING_WITH_CHECK_POINT_CELL_HEIGHT:CGFloat  = 150.0
private let EVENT_UPCOMING_NO_CHECK_POINT_CELL_HEIGHT:CGFloat    = 137.0
private let EVENT_ACTIVITY_CELL_HEIGHT:CGFloat                   = 156.0

class TREventListViewController: TRBaseViewController, UITableViewDataSource, UITableViewDelegate, ErrorViewProtocol, VerificationPopUpProtocol {
    
    @IBOutlet var segmentControl: UISegmentedControl?
    @IBOutlet var eventsTableView: UITableView?
    @IBOutlet var segmentOneUnderLine: UIImageView?
    @IBOutlet var segmentTwoUnderLine: UIImageView?
    @IBOutlet var currentPlayerAvatorIcon: UIImageView?
    @IBOutlet var emptyTableBackGround: UIImageView?
    @IBOutlet var playerGroupsIcon: UIImageView?
    @IBOutlet var eventTableTopConstraint: NSLayoutConstraint?
    @IBOutlet weak var leftSectionUnderLineRightConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightSectionUnderLineLeftConstraint: NSLayoutConstraint!

    
    //Events Information
    var eventsInfo: [TREventInfo] = []
    
    //Activity Cards
    var activityCardsInfo: [TRActivityInfo] = []
    
    // Future Events Information
    var futureEventsInfo: [TREventInfo] = [] 
    
    // Pull to Refresh
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(TREventListViewController.handleRefresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.segmentControl?.removeBorders()
      
        let boldFont = UIFont(name: "Helvetica-Bold", size: 16.0)
        let normalTextAttributes: [NSObject : AnyObject] = [
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : boldFont!,
        ]
        
        self.segmentControl!.setTitleTextAttributes(normalTextAttributes, forState: .Normal)
        self.segmentControl!.setTitleTextAttributes(normalTextAttributes, forState: .Selected)
        
        self.eventsTableView?.registerNib(UINib(nibName: "TREventCurrentWithCheckPointCell", bundle: nil), forCellReuseIdentifier: CURRENT_EVENT_WITH_CHECK_POINT_CELL)
        self.eventsTableView?.registerNib(UINib(nibName: "TREventCurrentNoCheckPointCell", bundle: nil), forCellReuseIdentifier: CURRENT_EVENT_NO_CHECK_POINT_CELL)
        self.eventsTableView?.registerNib(UINib(nibName: "TREventUpcomingWithCheckPointCell", bundle: nil), forCellReuseIdentifier: UPCOMING_EVENT_WITH_CHECK_POINT_CELL)
        self.eventsTableView?.registerNib(UINib(nibName: "TREventUpcomingNoCheckPointCell", bundle: nil), forCellReuseIdentifier: UPCOMING_EVENT_NO_CHECK_POINT_CELL)
        self.eventsTableView?.registerNib(UINib(nibName: "TREventActivityCardCell", bundle: nil), forCellReuseIdentifier: EVENT_ACTIVITY_CARD_CELL)

        self.eventsTableView?.tableFooterView = UIView(frame: CGRectZero)
        self.eventsTableView?.addSubview(self.refreshControl)
        
        //Adding Radius to the Current Player Avator
        self.currentPlayerAvatorIcon?.layer.cornerRadius = (self.currentPlayerAvatorIcon?.frame.width)!/2

        //Load table
        self.reloadEventTable()
        
        //Add User Avator Image
        self.updateUserAvatorImage()
        
        //Add Group Icon Image
        self.updateGroupImage()
        
        //Add Gestures to Images
        self.addLogOutEventToAvatorImageView()

        // Hide Navigation Bar
        self.hideNavigationBar()
        
        // Show No Events View if Events Table is Empty
        self.emptyTableBackGround?.hidden = self.eventsInfo.count > 0 ? true : false

        //Add Notification Permission
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.addNotificationsPermission()
        
        //Constraints
        if DeviceType.IS_IPHONE_6P == true {
            self.leftSectionUnderLineRightConstraint?.constant = 8
            self.rightSectionUnderLineLeftConstraint?.constant = 5
        } else {
            self.leftSectionUnderLineRightConstraint?.constant = 2
            self.rightSectionUnderLineLeftConstraint?.constant = 0
        }
        
        //Is User Verified
        if TRUserInfo.isUserVerified()! != ACCOUNT_VERIFICATION.USER_VERIFIED.rawValue {
            TRApplicationManager.sharedInstance.addUnVerifiedUserPromptWithDelegate(self)
        }
    }

    // Close Verification Prompt and Show Groups
    func showGroups () {
        TRApplicationManager.sharedInstance.fetchBungieGroups(true, completion: { (didSucceed) in
        })
    }
    
    func showLegalAlert () {
        
        var legalMessage = ""
        var buttonOneTitle: String?
        var buttonTwoTitle: String?
        let buttonOkTitle  = "OK"
        
        if TRApplicationManager.sharedInstance.currentUser?.legalInfo?.privacyNeedsUpdate == true && TRApplicationManager.sharedInstance.currentUser?.legalInfo?.termsNeedsUpdate == true {
            legalMessage = "Our Terms of Service and Privacy Policy have changed. \n\n By tapping the “OK” button, you agree to the updated Terms of Service and Privacy Policy."
            buttonOneTitle = "Privacy Policy"
            buttonTwoTitle = "Terms of Service"
        } else if (TRApplicationManager.sharedInstance.currentUser?.legalInfo?.privacyNeedsUpdate == true) {
            legalMessage = "Our Privacy Policy has changed. \n\n By tapping the “OK” button, you agree to the updated Privacy Policy."
            buttonOneTitle = "   Privacy Policy   "
        } else if (TRApplicationManager.sharedInstance.currentUser?.legalInfo?.termsNeedsUpdate == true) {
            legalMessage = "Our Terms of Service have changed. \n\n By tapping the “OK” button, you agree to the updated Terms of Service."
            buttonTwoTitle = "Terms of Service"
        } else {
            return
        }
        
        self.displayAlertWithActionHandler("Update", message: legalMessage, buttonOneTitle: buttonOneTitle ,buttonTwoTitle: buttonTwoTitle, buttonThreeTitle: buttonOkTitle, completionHandler: {complete in
            
            let storyboard = UIStoryboard(name: K.StoryBoard.StoryBoard_Main, bundle: nil)
            switch complete! {
            case K.Legal.TOS:
                let legalViewController = storyboard.instantiateViewControllerWithIdentifier(K.VIEWCONTROLLER_IDENTIFIERS.VIEW_CONTROLLER_WEB_VIEW) as! TRLegalViewController
                legalViewController.linkToOpen = NSURL(string: "https://www.crossroadsapp.co/terms")!
                self.presentViewController(legalViewController, animated: true, completion: {
                })
                
                break
            case K.Legal.PP:
                let legalViewController = storyboard.instantiateViewControllerWithIdentifier(K.VIEWCONTROLLER_IDENTIFIERS.VIEW_CONTROLLER_WEB_VIEW) as! TRLegalViewController
                legalViewController.linkToOpen = NSURL(string: "https://www.crossroadsapp.co/privacy")!
                self.presentViewController(legalViewController, animated: true, completion: {
                })
                break
            case K.Legal.OK:
                _ = TRRequestUpdateLegalRequest().updateLegalAcceptance({ (didSucceed) in
                })
                break
            default:
                break
            }
        })
    }
    
    //MARK:- Swipe Gestures Begins
    @IBAction func userSwipedRight (sender: UISwipeGestureRecognizer) {
        self.segmentControl?.selectedSegmentIndex = 0
        self.segmentControlSelection(self.segmentControl!)
    }

    @IBAction func userSwipedLeft (sender: UISwipeGestureRecognizer) {
        self.segmentControl?.selectedSegmentIndex = 1
        self.segmentControlSelection(self.segmentControl!)
    }
    
    //MARK:- Swipe Gestures Ends
    
    func updateUserAvatorImage () {
        
        //Avator for Current PlayerJ
        if TRUserInfo.isUserVerified()! != ACCOUNT_VERIFICATION.USER_VERIFIED.rawValue {
            self.currentPlayerAvatorIcon?.image = UIImage(named:"default_helmet")
        } else {
            if self.currentPlayerAvatorIcon?.image == nil {
                if let imageUrl = TRUserInfo.getUserImageString() {
                    let imageUrl = NSURL(string: imageUrl)
                    self.currentPlayerAvatorIcon?.sd_setImageWithURL(imageUrl)
                }
            }
        }

        if TRApplicationManager.sharedInstance.currentUser?.consoles.count > 1 {
            if let console = TRApplicationManager.sharedInstance.currentUser?.getDefaultConsole() {
                switch console.consoleType! {
                case ConsoleTypes.XBOXONE, ConsoleTypes.XBOX360:
                    self.currentPlayerAvatorIcon?.roundRectView(1.0, borderColor: UIColor(red: 77/255, green: 194/255, blue: 34/255, alpha: 1))
                    break
                case ConsoleTypes.PS4, ConsoleTypes.PS3:
                    self.currentPlayerAvatorIcon?.roundRectView(1.0, borderColor: UIColor(red: 1/255, green: 59/255, blue: 152/255, alpha: 1))
                    break
                default:
                    break
                }
            }
        } else {
            self.currentPlayerAvatorIcon?.roundRectView(1.0, borderColor: UIColor.whiteColor())
        }
    }
    
    func updateGroupImage () {
        
        self.playerGroupsIcon?.layer.borderColor = UIColor.whiteColor().CGColor
        self.playerGroupsIcon?.layer.borderWidth     = 1.0
        self.playerGroupsIcon?.layer.borderColor     = UIColor.whiteColor().CGColor
        self.playerGroupsIcon?.layer.masksToBounds   = true

        if let currentGroupID = TRUserInfo.getUserClanID() {
            if let hasCurrentGroup = TRApplicationManager.sharedInstance.getCurrentGroup(currentGroupID) {
                if let imageUrl = hasCurrentGroup.avatarPath {
                    let imageUrl = NSURL(string: imageUrl)
                    self.playerGroupsIcon?.sd_setImageWithURL(imageUrl)
                }
            }
        }
        
        if self.playerGroupsIcon?.image == nil {
            self.playerGroupsIcon?.image = UIImage(named: "iconGroupCrossroadsFreelance")
        }
        
        //Remove Observer running on previous clan and add it again on current clan
        TRApplicationManager.sharedInstance.fireBaseManager?.removeEventListObserver()
        TRApplicationManager.sharedInstance.fireBaseManager?.addEventsObserversWithParentView(self)
    }
    
    func addLogOutEventToAvatorImageView () {
        let openLeftGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(TREventListViewController.avatorBtnTapped(_:)))
        self.currentPlayerAvatorIcon?.userInteractionEnabled = true
        self.currentPlayerAvatorIcon?.addGestureRecognizer(openLeftGestureRecognizer)
        
        let openRightGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(TREventListViewController.showChangeGroupsVc(_:)))
        self.playerGroupsIcon?.userInteractionEnabled = true
        self.playerGroupsIcon?.addGestureRecognizer(openRightGestureRecognizer)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //Reload Table
        self.reloadEventTable()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        //Check if Legal statement has been updated
        self.showLegalAlert()
        
        //Add FireBase Observer
        TRApplicationManager.sharedInstance.fireBaseManager?.addEventsObserversWithParentView(self)
        
        if TRApplicationManager.sharedInstance.pushNotificationViewArray.count == 0 {
            UIView.animateWithDuration(0.3) {
                self.eventTableTopConstraint?.constant = 11.0
                self.view.layoutIfNeeded()
            }
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        //Remove FireBase Observer
        TRApplicationManager.sharedInstance.fireBaseManager?.removeEventListObserver()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override  func applicationWillEnterForeground() {
        
        //Add FireBase Observer
        if self.currentViewController?.isKindOfClass(TREventListViewController) == true {
            TRApplicationManager.sharedInstance.fireBaseManager?.removeEventListObserver()
            TRApplicationManager.sharedInstance.fireBaseManager?.addEventsObserversWithParentView(self)
        }
    }

    
    //MARK:- Table Delegate Methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard self.eventsInfo.count > 0 || self.futureEventsInfo.count > 0 || self.activityCardsInfo.count > 0 else {
            return 0
        }
        return 1
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clearColor()
        
        return headerView
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0.0
        }
        
        return EVENT_TABLE_HEADER_HEIGHT
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {

        if self.segmentControl?.selectedSegmentIndex == 0 {
            return self.eventsInfo.count + self.activityCardsInfo.count
        }
        
        return self.futureEventsInfo.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell: TRBaseEventTableCell?
        if segmentControl?.selectedSegmentIndex == 0 {
            
            if indexPath.section < self.eventsInfo.count {
                
                if self.eventsInfo[indexPath.section].eventActivity?.activityCheckPoint != "" && self.eventsInfo[indexPath.section].eventActivity?.activityCheckPoint != nil{
                    cell = tableView.dequeueReusableCellWithIdentifier(CURRENT_EVENT_WITH_CHECK_POINT_CELL) as! TREventCurrentWithCheckPointCell
                    if let hasTag = self.eventsInfo[indexPath.section].eventActivity?.activityTag where hasTag != ""{
                        self.eventsTableView?.rowHeight = 166.0
                    } else {
                        self.eventsTableView?.rowHeight = EVENT_CURRENT_WITH_CHECK_POINT_CELL_HEIGHT
                    }
                } else {
                    cell = tableView.dequeueReusableCellWithIdentifier(CURRENT_EVENT_NO_CHECK_POINT_CELL) as! TREventCurrentNoCheckPointCell
                    
                    if let hasTag = self.eventsInfo[indexPath.section].eventActivity?.activityTag where hasTag != ""{
                        self.eventsTableView?.rowHeight = 153.0
                    } else {
                        self.eventsTableView?.rowHeight = EVENT_CURRENT_NO_CHECK_POINT_CELL_HEIGHT
                    }
                }
                
                cell?.updateCellViewWithEvent(self.eventsInfo[indexPath.section])
                cell?.joinEventButton?.buttonEventInfo = eventsInfo[indexPath.section]
                cell?.leaveEventButton.buttonEventInfo = eventsInfo[indexPath.section]
                cell?.eventTimeLabel?.hidden = true
            } else {
                
                let index = indexPath.section - self.eventsInfo.count
                let cell = tableView.dequeueReusableCellWithIdentifier(EVENT_ACTIVITY_CARD_CELL) as! TREventActivityCardCell
                cell.activityInfo = self.activityCardsInfo[index]
                cell.cellActivityAddButton?.buttonActivityInfo = self.activityCardsInfo[index]
                cell.cellActivityAddButton?.addTarget(self, action: #selector(TREventListViewController.createActivityWithActivity(_:)), forControlEvents: .TouchUpInside)
                self.eventsTableView?.rowHeight = EVENT_ACTIVITY_CELL_HEIGHT
                cell.loadCellView()
                
                return cell
            }

        } else {
            
            if self.futureEventsInfo[indexPath.section].eventActivity?.activityCheckPoint != "" && self.futureEventsInfo[indexPath.section].eventActivity?.activityCheckPoint != nil{
                cell = tableView.dequeueReusableCellWithIdentifier(UPCOMING_EVENT_WITH_CHECK_POINT_CELL) as! TREventUpcomingWithCheckPointCell
                
                if let hasTag = self.futureEventsInfo[indexPath.section].eventActivity?.activityTag where hasTag != ""{
                    self.eventsTableView?.rowHeight = 180.0
                } else {
                    self.eventsTableView?.rowHeight = EVENT_UPCOMING_WITH_CHECK_POINT_CELL_HEIGHT
                }
            } else {
                cell = tableView.dequeueReusableCellWithIdentifier(UPCOMING_EVENT_NO_CHECK_POINT_CELL) as! TREventUpcomingNoCheckPointCell
                
                if let hasTag = self.futureEventsInfo[indexPath.section].eventActivity?.activityTag where hasTag != ""{
                    self.eventsTableView?.rowHeight = 166
                } else {
                    self.eventsTableView?.rowHeight = EVENT_UPCOMING_NO_CHECK_POINT_CELL_HEIGHT
                }
            }

            
            cell?.updateCellViewWithEvent(self.futureEventsInfo[indexPath.section])
            cell?.joinEventButton?.buttonEventInfo = futureEventsInfo[indexPath.section]
            cell?.leaveEventButton.buttonEventInfo = futureEventsInfo[indexPath.section]
            cell?.eventTimeLabel?.hidden = false
        }

        cell?.joinEventButton?.addTarget(self, action: #selector(TREventListViewController.joinAnEvent(_:)), forControlEvents: .TouchUpInside)
        cell?.leaveEventButton?.addTarget(self, action: #selector(TREventListViewController.leaveAnEvent(_:)), forControlEvents: .TouchUpInside)
        cell?.layoutSubviews()
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
      
        self.eventsTableView?.deselectRowAtIndexPath(indexPath, animated: false)
        
        let eventInfo: TREventInfo!
        if self.segmentControl?.selectedSegmentIndex == 0 {
            if indexPath.section < self.eventsInfo.count {
                eventInfo = self.eventsInfo[indexPath.section]
                self.showEventInfoViewController(eventInfo, fromPushNoti: false)
            } else {
                
                if let cell = self.eventsTableView?.cellForRowAtIndexPath(indexPath) as? TREventActivityCardCell {
                    if let _ = cell.cellActivityAddButton.buttonActivityInfo {
                        
                        // Tracking Open Source
                        var mySourceDict = [String: AnyObject]()
                        mySourceDict["activityId"] = cell.cellActivityAddButton.buttonActivityInfo?.activityID
                        
                        //TRACKING
                        _ = TRAppTrackingRequest().sendApplicationPushNotiTracking(mySourceDict, trackingType: APP_TRACKING_DATA_TYPE.TRACKING_ADD_CARD_CLICKED, completion: {didSucceed in
                            if didSucceed == true {
                                
                            }
                        })
                        
                        self.createActivityWithActivity(cell.cellActivityAddButton)
                    }
                }
            }
        } else {
            eventInfo = self.futureEventsInfo[indexPath.section]
            self.showEventInfoViewController(eventInfo, fromPushNoti: false)
        }
    }
    
    func showEventInfoViewController(eventInfo: TREventInfo?, fromPushNoti: Bool?) {

        _ = TRGetEventRequest().getEventByID((eventInfo?.eventID!)!, completion: { (error, event) in
            let storyboard : UIStoryboard = UIStoryboard(name: K.StoryBoard.StoryBoard_Main, bundle: nil)
            let vc : TREventDetailViewController = storyboard.instantiateViewControllerWithIdentifier(K.VIEWCONTROLLER_IDENTIFIERS.VIEW_CONTROLLER_EVENT_DESCRIPTION) as! TREventDetailViewController
            vc.eventInfo = event
            
            self.presentViewController(vc, animated: true, completion: {
            })
        })
    }
    
    func fetchEventDetailForDeepLink (eventID: String, activityName: String) {
        let eventInfo = TRApplicationManager.sharedInstance.getEventById(eventID)
        if let _ = eventInfo {
            do {
                let _ = try self.getBranchError(eventInfo!)
            } catch let errorType as Branch_Error {
                self.showBranchErrorViewWithError(errorType, eventInfo: eventInfo, activityName: activityName)
                return
            } catch {
            }
            
            //Deep Link
            self.changeConsoleToClickActivePushNoti((eventInfo?.eventConsoleType)!)
            self.changeGroupToClickedActivePushNoti((eventInfo?.eventClanID)!)
            self.showEventInfoViewController(eventInfo, fromPushNoti: false)
        } else {
            _ = TRGetEventRequest().getEventByID(eventID, viewHandlesError: true, completion: { (error, event) in
                if let _ = event {
                    do {
                        let _ = try self.getBranchError(event!)
                    } catch let errorType as Branch_Error {
                        self.showBranchErrorViewWithError(errorType, eventInfo: event, activityName: activityName)
                        return
                    } catch {
                    }
                    
                    //Deep Link
                    self.changeConsoleToClickActivePushNoti((event?.eventConsoleType)!)
                    self.changeGroupToClickedActivePushNoti((event?.eventClanID)!)
                    self.showEventInfoViewController(event, fromPushNoti: false)
                } else {
                    if let _ = error {
                        self.showBranchErrorViewWithError(Branch_Error.ACTIVITY_NOT_AVAILABLE, eventInfo: nil, activityName: activityName)
                    }
                }
            })
        }
    }
    
    func getBranchError (eventInfo: TREventInfo) throws {
        //TEST THESE CONDITIONS
        do {
            let _ = try eventInfo.isEventFull()
        } catch _ {
            throw Branch_Error.MAXIMUM_PLAYERS_REACHED
        }
        
        do {
            let _ = try eventInfo.isEventGroupPartOfUsersGroups()
        } catch _ {
            throw Branch_Error.JOIN_BUNGIE_GROUP
        }
        
        do {
            let _ = try eventInfo.isEventConsoleMatchesUserConsole()
        } catch _ {
            throw Branch_Error.NEEDS_CONSOLE
        }
    }
    
    func showBranchErrorViewWithError (errorType: Branch_Error, eventInfo: TREventInfo?, activityName: String?) {
        dispatch_async(dispatch_get_main_queue(), {
            let errorView = NSBundle.mainBundle().loadNibNamed("TRErrorView", owner: self, options: nil)[0] as! TRErrorView
            errorView.frame = self.view.frame
            errorView.errorType = errorType
            errorView.delegate = self
            if let _ = eventInfo {
                errorView.eventInfo = eventInfo!
            }
            if let _ = activityName {
                errorView.activityName = activityName
            }
            
            self.view.addSubview(errorView)
        })
    }
    
    //Called when app is in background state
    override func didReceiveRemoteNotificationInBackGroundSession(sender: NSNotification) {
        
        // If Event Info is open, If Navigations are open, close them too
        if let topController = UIApplication.topViewController() {
            if topController.isKindOfClass(TREventDetailViewController) {
                topController.dismissViewControllerAnimated(false, completion: {
                    topController.didMoveToParentViewController(nil)
                    topController.removeFromParentViewController()
                })
            } else if (topController.navigationController != nil) {
                topController.dismissViewControllerAnimated(false, completion: {
                })
            }
        }
        
        
        if let payload = sender.userInfo!["payload"] as? NSDictionary {
            let _ = TRPushNotification().fetchEventFromPushNotification(payload, complete: { (event) in
                if let _ = event {
                    self.showEventInfoViewController(event, fromPushNoti: true)
                }
            })
        }
    }
    
    //MARK:- Event Methods
    func joinAnEvent (sender: EventButton) {
      if let eventInfo = sender.buttonEventInfo {
            _ = TRJoinEventRequest().joinEventWithUserForEvent(TRUserInfo.getUserID()!, eventInfo: eventInfo, completion: { (event) in
                if let _ = event {
                    dispatch_async(dispatch_get_main_queue(), {
                        //self.reloadEventTable()
                    })
                }
            })
        }
    }
    
    func leaveAnEvent (sender: EventButton) {
        _  = TRLeaveEventRequest().leaveAnEvent(sender.buttonEventInfo!,completion: {(event) in
            if let _ = event {
                dispatch_async(dispatch_get_main_queue(), {
                    //self.reloadEventTable()
                })
            }
        })
    }
    
    @IBAction func createAnEvent () {

        //TRACKING
        _ = TRAppTrackingRequest().sendApplicationPushNotiTracking(nil, trackingType: APP_TRACKING_DATA_TYPE.TRACKING_ADD_ACTIVITY_CLICKED, completion: {didSucceed in
            if didSucceed == true {
            }
        })
        
        let storyboard : UIStoryboard = UIStoryboard(name: K.StoryBoard.StoryBoard_Main, bundle: nil)
        let vc : TRCreateEventViewController = storyboard.instantiateViewControllerWithIdentifier(K.VIEWCONTROLLER_IDENTIFIERS.VIEWCONTROLLER_CREATE_EVENT) as! TRCreateEventViewController
        let navigationController = UINavigationController(rootViewController: vc)
        self.presentViewController(navigationController, animated: true, completion: nil)
    }
    
    //MARK:- Table Refresh
    func handleRefresh(refreshControl: UIRefreshControl) {

        _ = TRGetEventsList().getEventsListWithClearActivityBackGround(true, clearBG: false, indicatorTopConstraint: nil, completion: { (didSucceed) -> () in
            if(didSucceed == true) {
                refreshControl.endRefreshing()
                delay(0.5, closure: {
                    dispatch_async(dispatch_get_main_queue(), { 
                        self.reloadEventTable()
                    })
                })
            } else {
                self.appManager.log.debug("Failed")
            }
        })
    }
    
    
    
    override func reloadEventTable () {
        
        //Reload Table
        self.eventsInfo       = TRApplicationManager.sharedInstance.getCurrentEvents()
        self.futureEventsInfo = TRApplicationManager.sharedInstance.getFutureEvents()
        self.activityCardsInfo = TRApplicationManager.sharedInstance.eventsListActivity
        
        let contentOffset = self.eventsTableView?.contentOffset
        self.eventsTableView?.reloadData()
        self.eventsTableView?.contentOffset = contentOffset!
    }
    
    @IBAction func segmentControlSelection (sender: UISegmentedControl) {

        switch sender.selectedSegmentIndex {
        case 0:
            self.segmentOneUnderLine?.hidden = false
            self.segmentTwoUnderLine?.hidden = true
            self.emptyTableBackGround?.hidden = self.eventsInfo.count > 0 ? true : false
            
            //TRACKING
            _ = TRAppTrackingRequest().sendApplicationPushNotiTracking(nil, trackingType: APP_TRACKING_DATA_TYPE.TRACKING_SEG_CURRENT_CLICKED, completion: {didSucceed in
                if didSucceed == true {
                }
            })

            
            break;
        case 1:
            self.segmentOneUnderLine?.hidden = true
            self.segmentTwoUnderLine?.hidden = false
            self.emptyTableBackGround?.hidden = self.futureEventsInfo.count > 0 ? true : false

            //TRACKING
            _ = TRAppTrackingRequest().sendApplicationPushNotiTracking(nil, trackingType: APP_TRACKING_DATA_TYPE.TRACKING_SEG_UPCOMING_CLICKED, completion: {didSucceed in
                if didSucceed == true {
                }
            })

            break;
        default:
            break;
        }
        
        //Reload Data
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.reloadEventTable()
        }
    }
    
    
    //MARK:- OTHER VIEW-CONTROLLERS
    func avatorBtnTapped(sender: AnyObject) {
        TRApplicationManager.sharedInstance.slideMenuController.openLeft()
    }
    
    @IBAction func showChangeGroupsVc (sender: AnyObject) {
        TRApplicationManager.sharedInstance.fetchBungieGroups(true, completion: { (didSucceed) in
        })
    }
    
    func createActivityWithActivity (sender: EventButton) {
        self.createActivityFromEvent(sender.buttonActivityInfo!)
    }
    
    func createActivityFromEvent (sender: TRActivityInfo) {
        if let activityType =  sender.activityType {
            _ = TRgetActivityList().getActivityListofType(activityType, completion: { (didSucceed) in
                if didSucceed == true {
                    let vc = TRApplicationManager.sharedInstance.stroryBoardManager.getViewControllerWithID(K.VIEWCONTROLLER_IDENTIFIERS.VIEW_CONTROLLER_CREATE_EVENT_FINAL, storyBoardID: K.StoryBoard.StoryBoard_Main) as! TRCreateEventFinalView
                    vc.activityInfo = TRApplicationManager.sharedInstance.activityList
                    vc.selectedActivity = sender
                    
                    let navigationController = UINavigationController(rootViewController: vc)
                    self.presentViewController(navigationController, animated: true, completion: {
                        vc.backButton?.hidden = true
                    })
                }
            })
        }
    }
    
    func tableViewScrollToBottom(animated: Bool) {
        
        let delay = 0.1 * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        
        dispatch_after(time, dispatch_get_main_queue(), {
            
            let numberOfSections = self.eventsTableView!.numberOfSections
            let numberOfRows = self.eventsTableView!.numberOfRowsInSection(numberOfSections-1)
            
            if numberOfRows > 0 {
                let indexPath = NSIndexPath(forRow: numberOfRows-1, inSection: (numberOfSections-1))
                self.eventsTableView!.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: animated)
            }
            
        })
    }
    
    
    //MARK:- NOTIFICATION VIEW PROTOCOL
    func notificationShowMoveTableDown (yOffSet: CGFloat) {
        
        UIView.animateWithDuration(0.3) {
            self.eventTableTopConstraint?.constant = yOffSet
            self.view.layoutIfNeeded()
        }
    }
    
    override func activeNotificationViewClosed () {
        
        if TRApplicationManager.sharedInstance.pushNotificationViewArray.count == 0 {
            UIView.animateWithDuration(0.3) {
                self.eventTableTopConstraint?.constant = 11.0
                self.view.layoutIfNeeded()
            }
        }
    }
    
    override func showEventDetailView (eventID: String) {
        
        let eventInfo = TRApplicationManager.sharedInstance.getEventById(eventID)
        if let _ = eventInfo {
            self.changeGroupToClickedActivePushNoti((eventInfo?.eventClanID)!)
            self.changeConsoleToClickActivePushNoti((eventInfo?.eventConsoleType)!)
            self.showEventInfoViewController(eventInfo, fromPushNoti: false)
        } else {
            _ = TRGetEventRequest().getEventByID(eventID, viewHandlesError: false, completion: { (error, event) in
                if let _ = event {
                    self.changeConsoleToClickActivePushNoti((event?.eventConsoleType)!)
                    self.changeGroupToClickedActivePushNoti((event?.eventClanID)!)
                    self.showEventInfoViewController(event, fromPushNoti: false)
                }
            })
        }
    }
    
    func changeGroupToClickedActivePushNoti (groupId: String) {
        
        if let selectedGroup = TRApplicationManager.sharedInstance.getGroupByGroupId(groupId) {
            _ = TRUpdateGroupRequest().updateUserGroup(selectedGroup.groupId!, groupName:(selectedGroup.groupName)!, groupImage: (selectedGroup.avatarPath)! ,completion: { (didSucceed) in
                _ = TRGetEventsList().getEventsListWithClearActivityBackGround(true, clearBG: false, indicatorTopConstraint: nil, completion: { (didSucceed) -> () in
                    if(didSucceed == true) {
                        self.reloadEventTable()
                        self.updateGroupImage ()
                    }
                })
            })
        }
    }
    
    func changeConsoleToClickActivePushNoti (eventConsole: String) {
        
        if let console = TRApplicationManager.sharedInstance.currentUser?.getDefaultConsole() {
            if console.consoleType == eventConsole {
                return
            } else {
                let consoleArray = TRApplicationManager.sharedInstance.currentUser?.consoles.filter{$0.consoleType == eventConsole}
                if let existingConsole = consoleArray?.first {
                    _ = TRChangeConsoleRequest().changeConsole(existingConsole.consoleType!, completion: { (didSucceed) in
                        if didSucceed == true {
                            _ = TRGetEventsList().getEventsListWithClearActivityBackGround(true, clearBG: false, indicatorTopConstraint: nil, completion: { (didSucceed) -> () in
                                if didSucceed == true {
                                    self.reloadEventTable()
                                    self.updateUserAvatorImage()
                                }
                            })
                        }
                    })
                } else {
                    return
                }
            }
        }
    }
    
    //MARK:- Error Message View Handling actions
    func addActivity (eventInfo: TREventInfo?) {
        if let _ = eventInfo?.eventActivity {
            self.createActivityFromEvent((eventInfo?.eventActivity)!)
        }
    }
    
    func addConsole () {
        
    }
    
    func goToBungie(eventID: String?) {
        
        var url = NSURL(string: "https://www.bungie.net")
        if let _ = eventID {
            let urlString = "https://www.bungie.net/en/clan/" + eventID!
           url = NSURL(string: urlString)
        }
        
        UIApplication.sharedApplication().openURL(url!)
    }
    
    func closeEventListView () {
        self.dismissViewController(true) { (didDismiss) in
            
        }
    }
    
    //MARK:- deinit
    deinit {
        self.eventsInfo.removeAll()
        self.futureEventsInfo.removeAll()
        self.activityCardsInfo.removeAll()
        
        //Remove Observer
        NSNotificationCenter.defaultCenter().removeObserver(self)
        
        self.appManager.log.debug("de-init")
    }
}

