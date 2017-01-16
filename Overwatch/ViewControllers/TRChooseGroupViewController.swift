//
//  TRChooseGroupViewController.swift
//  Traveler
//
//  Created by Ashutosh on 5/19/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import UIKit
import TTTAttributedLabel
import SlideMenuControllerSwift

private let GROUP_CELLS_IDENTIFIER = "groupCells"
private let MIN_DEFAULT_GROUPS = 0

class TRChooseGroupViewController: TRBaseViewController, UITableViewDataSource, UITableViewDelegate, TTTAttributedLabelDelegate {

    private var bungieGroups: [TRBungieGroupInfo] = []
    private var selectedGroup: TRBungieGroupInfo?
    private var highlightedCell: TRBungieGroupCell?
    
    var delegate: AnyObject?
    
    //To be hidden if there are no groups
    @IBOutlet weak var appIcon: UIImageView!
    @IBOutlet weak var lableOne: UILabel!
    @IBOutlet weak var lableThree: TTTAttributedLabel!
    @IBOutlet weak var groupsTableView: UITableView!
    @IBOutlet weak var saveButton: UIButton!

    //Selected Group View
    @IBOutlet weak var selectedGroupView: UIView!
    @IBOutlet weak var selectedGroupViewGroupImage: UIImageView!
    @IBOutlet weak var selectedGroupViewGroupName: UILabel!
    @IBOutlet weak var selectedGroupViewMemberCount: UILabel!
    @IBOutlet weak var selectedGroupViewEventCount: UILabel!
    @IBOutlet weak var selectedGroupViewNotificationButton: EventButton!
    
    //UnVerified User's View
    @IBOutlet weak var unVerifiedUserView: UIView!
    @IBOutlet weak var unVerifiedUserLabel: TTTAttributedLabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.groupsTableView?.registerNib(UINib(nibName: "TRBungieGroupCell", bundle: nil), forCellReuseIdentifier: GROUP_CELLS_IDENTIFIER)
        
        self.lableOne?.text = "Which group would you\nlike to play with?"
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //Fetch Groups
        self.bungieGroups.removeAll()
        self.bungieGroups = TRApplicationManager.sharedInstance.bungieGroups
        
        if TRApplicationManager.sharedInstance.bungieGroups.count <=  1 {
            //self.addNoneGroupCountUI()
            self.lableThree.hidden = false
        } else {
            self.saveButton.setTitle(nil, forState: .Normal)
            self.lableThree.hidden = true
            //Add bottom border to GroupList Table

            self.changeSaveButtonVisuals()
        }
        
        if let userGroup = TRUserInfo.getUserClanID() {
            let selectedGroup = self.bungieGroups.filter{$0.groupId! == userGroup}
            self.selectedGroup = selectedGroup.first
            let groupIndex = self.bungieGroups.indexOf({$0.groupId == self.selectedGroup?.groupId})
            if let _ = groupIndex {
                self.bungieGroups.removeAtIndex(groupIndex!)
            }
            
            //Add selected Group UI
            dispatch_async(dispatch_get_main_queue()) {
                if let _ = self.selectedGroup {
                    self.addSelectedGroupUI()
                }
            }
        }
        
        // Reload Data
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            UIView.transitionWithView(self.groupsTableView,
                                      duration: 0.5,
                                      options: .TransitionCrossDissolve,
                                      animations:
                { () -> Void in
                    self.groupsTableView.reloadData()
                    self.groupsTableView.setContentOffset(CGPointZero, animated:true)
                },
            completion: nil);
        }
        
        if TRUserInfo.isUserVerified()! != ACCOUNT_VERIFICATION.USER_VERIFIED.rawValue {
            self.addNonVerifiedUserUI()
        } else {
            self.removeNonVerifiedUserUI()
        }
    }

    func changeSaveButtonVisuals () {
        self.saveButton?.enabled = false
        self.saveButton?.titleLabel?.text = nil
        self.saveButton?.backgroundColor = UIColor(red: 35/255, green: 58/255, blue: 62/255, alpha: 1)
        
        self.saveButton.layer.shadowColor = UIColor.blackColor().CGColor;
        self.saveButton.layer.shadowOffset = CGSizeMake(3, 3);
        self.saveButton.layer.shadowRadius = 5;
        self.saveButton.layer.shadowOpacity = 1;
    }
    
    func addSelectedGroupUI () {
        
        //Add rounder corner radius to the view
        self.selectedGroupView.round([.AllCorners], radius: 2.0)
        
        if let hasImage = self.selectedGroup?.avatarPath {
            let imageUrl = NSURL(string: hasImage)
            self.selectedGroupViewGroupImage?.sd_setImageWithURL(imageUrl)
        }
        
        self.selectedGroupViewGroupName.text = self.selectedGroup?.groupName
        self.selectedGroupViewMemberCount.text = (self.selectedGroup?.memberCount?.description)! + " in Orbit"
        self.selectedGroupViewNotificationButton.selected = self.selectedGroup?.groupNotification?.boolValue == true ? true: false
        self.selectedGroupViewNotificationButton.addTarget(self, action: #selector(updateNotificationPreference), forControlEvents: .TouchUpInside)
        self.selectedGroupViewNotificationButton.buttonGroupInfo = self.selectedGroup
        
        if let eventCount = self.selectedGroup?.eventCount {
            self.selectedGroupViewEventCount.textColor = eventCount <= 0 ? UIColor.lightGrayColor() : UIColor(red: 255/255, green: 198/255, blue: 0/255, alpha: 1)
            let activity = eventCount == 1 ? " Activity" : " Activities"
            self.selectedGroupViewEventCount.text = eventCount.description + activity
        } else {
            self.selectedGroupViewEventCount.hidden = true
        }
        
        if let eventMembers = self.selectedGroup?.memberCount {
            self.selectedGroupViewMemberCount.text = eventMembers.description + " in Orbit"
        } else {
            self.selectedGroupViewMemberCount.hidden = true
        }
        
        
        self.selectedGroupView.backgroundColor = self.selectedGroup?.groupId == "clan_id_not_set" ? UIColor(red: 3/255, green: 81/255, blue: 102/255, alpha: 1) : UIColor(red: 19/255, green: 31/255, blue: 35/255, alpha: 1)
    }
    
    
    //MARK- Scroll Methods
    // Help to disable/ enable scroll in down-right direction. Disabling helps to let table view scroll and to let swipe gesture be disabled
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        print("Scroll")
        TRApplicationManager.sharedInstance.slideMenuController.rightPanGesture?.enabled = false
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        TRApplicationManager.sharedInstance.slideMenuController.rightPanGesture?.enabled = true
    }
    
    func addNonVerifiedUserUI () {
        self.unVerifiedUserView.hidden = false
        
        let messageString = "To play with other groups and update your profile, please verify your account. \n\n Check your messages on Bungie.net for a verification link from Crossroads."
        let bungieLinkName = "Bungie.net"
        self.unVerifiedUserLabel?.text = messageString
        
        // Add HyperLink to Bungie
        let nsString = messageString as NSString
        let range = nsString.rangeOfString(bungieLinkName)
        let url = NSURL(string: "https://www.bungie.net/")!
        let subscriptionNoticeLinkAttributes = [
            NSForegroundColorAttributeName: UIColor(red: 0/255, green: 182/255, blue: 231/255, alpha: 1),
            NSUnderlineStyleAttributeName: NSNumber(bool:true),
            ]
        self.unVerifiedUserLabel?.linkAttributes = subscriptionNoticeLinkAttributes
        self.unVerifiedUserLabel?.addLinkToURL(url, withRange: range)
        self.unVerifiedUserLabel?.delegate = self
        
        self.saveButton.enabled = true
        self.saveButton?.hidden = false
        self.saveButton.setTitle("VERIFY ON BUNGIE.NET", forState: .Normal)
        self.saveButton?.backgroundColor = UIColor(red: 0/255, green: 134/255, blue: 208/255, alpha: 1)
    }
    
    func removeNonVerifiedUserUI () {
        self.unVerifiedUserView.removeFromSuperview()
    }
    
    func addNoneGroupCountUI () {
        self.lableThree.hidden = false
        
        let messageString = "It looks like you are not a member of any groups. Feel free to Freelance with us or head to Bungie.net to join a group and fully experience the Crossroads for Destiny app."
        let bungieLinkName = "Bungie.net"
        self.lableThree?.text = messageString
        
        // Add HyperLink to Bungie
        let nsString = messageString as NSString
        let range = nsString.rangeOfString(bungieLinkName)
        let url = NSURL(string: "https://www.bungie.net/")!
        let subscriptionNoticeLinkAttributes = [
            NSForegroundColorAttributeName: UIColor(red: 0/255, green: 182/255, blue: 231/255, alpha: 1),
            NSUnderlineStyleAttributeName: NSNumber(bool:true),
            ]
        self.lableThree?.linkAttributes = subscriptionNoticeLinkAttributes
        self.lableThree?.addLinkToURL(url, withRange: range)
        self.lableThree?.delegate = self
    }
    
    //MARK:- Table Delegate Methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        if bungieGroups.count <= 0 {
            return 1
        }
        
        return bungieGroups.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clearColor()
        
        return headerView
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 6
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(GROUP_CELLS_IDENTIFIER) as! TRBungieGroupCell
        if indexPath.section < self.bungieGroups.count {
            let groupInfo = self.bungieGroups[indexPath.section]
            cell.selectionStyle = .None
            cell.updateCellViewWithGroup(groupInfo)
            cell.userInteractionEnabled = true
            cell.notificationButton.buttonGroupInfo = groupInfo
            cell.notificationButton.addTarget(self, action: #selector(updateNotificationPreference), forControlEvents: .TouchUpInside)
            cell.notificationButton.selected = groupInfo.groupNotification?.boolValue == true ? true: false
        } else {
            cell.userInteractionEnabled = false
            cell.addNoGroupCellUI()
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.selectedGroup = self.bungieGroups[indexPath.section]
        
        let cell = tableView.cellForRowAtIndexPath(indexPath) as? TRBungieGroupCell
        self.highlightedCell = cell
       
        if let group = self.selectedGroup {
            _ = TRUpdateGroupRequest().updateUserGroup(group.groupId!, groupName:(self.selectedGroup?.groupName)!, groupImage: (self.selectedGroup?.avatarPath)! ,completion: { (didSucceed) in
                _ = TRGetEventsList().getEventsListWithClearActivityBackGround(true, clearBG: false, indicatorTopConstraint: nil, completion: { (didSucceed) -> () in
                    if(didSucceed == true) {
                        if let del = self.delegate as? TREventListViewController {
                            del.reloadEventTable()
                            del.updateGroupImage ()
                        }
                        
                        TRApplicationManager.sharedInstance.slideMenuController.closeRight()
                    }
                })
            })
        }
    }

    //MARK:- UpdateNotification Request
    func updateNotificationPreference(sender: EventButton) {
        
        if let hasGroupId = sender.buttonGroupInfo?.groupId {
            if let notificationValue = sender.buttonGroupInfo?.groupNotification {
                _ = TRGroupNotificationUpdateRequest().updateUserGroupNotification(hasGroupId, muteNoti: !notificationValue, completion: { (didSucceed) in
                    if didSucceed == true {
                        dispatch_async(dispatch_get_main_queue(), {
                            if hasGroupId == self.selectedGroup?.groupId {
                                self.selectedGroupViewNotificationButton.selected = self.selectedGroup?.groupNotification?.boolValue == true ? true: false
                            } else {
                                self.groupsTableView.reloadData()
                            }
                        })
                    }
                })
            }
        }
    }

    func attributedLabel(label: TTTAttributedLabel!, didSelectLinkWithURL url: NSURL!) {
        UIApplication.sharedApplication().openURL(url)
    }

    
    @IBAction func goToBungieWebSite (sender: UIButton) {
        let url = NSURL(string: "https://www.bungie.net/")!
        UIApplication.sharedApplication().openURL(url)
    }
    
    @IBAction func showUnVerifiedView (sender: UITapGestureRecognizer) {
        TRApplicationManager.sharedInstance.addUnVerifiedUserPromptWithDelegate(nil)
    }
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    deinit {
        
    }
}
