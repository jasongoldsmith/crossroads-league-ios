//
//  TRProfileViewController.swift
//  Traveler
//
//  Created by Ashutosh on 3/29/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation
import TTTAttributedLabel
import UIKit
import SlideMenuControllerSwift

class TRProfileViewController: TRBaseViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, TTTAttributedLabelDelegate {
    
    
    @IBOutlet weak var avatorImageView: UIImageView?
    @IBOutlet weak var avatorUserName: UILabel?
    @IBOutlet weak var backGroundImageView: UIImageView?
    @IBOutlet weak var buildNumberLabel: TTTAttributedLabel!
    @IBOutlet weak var legalLabel: TTTAttributedLabel!
    
    @IBOutlet weak var changePasswordButton: UIButton!
    @IBOutlet weak var contactUsButton: UIButton!
    @IBOutlet weak var logOutButton: UIButton!
    
    
    var currentUser: TRPlayerInfo?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Update build number
        self.addVersionAndLegalAttributedLabel()
        
        //Add Radius to buttons
        self.changePasswordButton.layer.cornerRadius = 2.0
        self.contactUsButton.layer.cornerRadius = 2.0
        self.logOutButton.layer.cornerRadius = 2.0
}
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.updateView()
        self.backGroundImageView?.clipsToBounds = true
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func addVersionAndLegalAttributedLabel () {

        let messageString = "\(NSBundle.mainBundle().releaseVersionNumber!) (\(NSBundle.mainBundle().buildVersionNumber!))"
        self.buildNumberLabel.text = messageString

        
        let legalMessageString = "Terms of Service | Privacy Policy | Licenses"
        self.legalLabel.text = legalMessageString
        
        let tos = "Terms of Service"
        let privatePolicy = "Privacy Policy"
        let licenses = "Licenses"
        
        let nsString = legalMessageString as NSString
        let tosRange = nsString.rangeOfString(tos)
        let privateRange = nsString.rangeOfString(privatePolicy)
        let licenseRange = nsString.rangeOfString(licenses)
        
        let tosUrl = NSURL(string: "https://www.crossroadsapp.co/terms")!
        let privatePolicyUrl = NSURL(string: "https://www.crossroadsapp.co/privacy")!
        let licensesUrl = NSURL(string: "https://www.crossroadsapp.co/license")!
        
        let subscriptionNoticeLinkAttributes = [
            NSForegroundColorAttributeName: UIColor.whiteColor(), 
            NSUnderlineStyleAttributeName: NSNumber(bool:true),
            ]
        
        self.legalLabel?.linkAttributes = subscriptionNoticeLinkAttributes
        self.legalLabel?.addLinkToURL(tosUrl, withRange: tosRange)
        self.legalLabel?.addLinkToURL(privatePolicyUrl, withRange: privateRange)
        self.legalLabel?.addLinkToURL(licensesUrl, withRange: licenseRange)
        self.legalLabel?.delegate = self
    }

    func updateView () {
        self.currentUser = TRApplicationManager.sharedInstance.getPlayerObjectForCurrentUser()
        
        // User Image
        self.updateUserAvatorImage()
            
        // User's psnID
        if let hasUserName = TRApplicationManager.sharedInstance.currentUser?.getDefaultConsole()?.consoleId {
            self.avatorUserName?.text = hasUserName
        } else {
            self.avatorUserName?.text = TRUserInfo.getUserName()
        }
    }
    
    func updateUserAvatorImage () {
        
        //Avator for Current Player
        if TRUserInfo.isUserVerified()! != ACCOUNT_VERIFICATION.USER_VERIFIED.rawValue {
            self.avatorImageView?.image = UIImage(named: "default_helmet.png")
        } else {
            if self.avatorImageView?.image == nil {
                if let imageUrl = TRUserInfo.getUserImageString() {
                    let imageUrl = NSURL(string: imageUrl)
                    self.avatorImageView?.sd_setImageWithURL(imageUrl)
                }
            }
        }
    }
    
    @IBAction func avatorImageViewTapped (sender: UITapGestureRecognizer) {
        
        // UnVerified User Prompt
        if TRUserInfo.isUserVerified()! != ACCOUNT_VERIFICATION.USER_VERIFIED.rawValue {
            TRApplicationManager.sharedInstance.addUnVerifiedUserPromptWithDelegate(nil)
            
            return
        }


        _ = TRHelmetUpdateRequest().updateHelmetForUser({ (imageStringUrl) in
            if let _ = imageStringUrl {
                let imageURL = NSURL(string: imageStringUrl!)
                self.avatorImageView?.sd_setImageWithURL(imageURL)
                
                _ = TRGetEventsList().getEventsListWithClearActivityBackGround(true, clearBG: false, indicatorTopConstraint: nil, completion: { (didSucceed) -> () in
                    if(didSucceed == true) {
                       
                        //Refresh Event List View to reflect the new UserImage
                        if let eventListViewController = TRApplicationManager.sharedInstance.slideMenuController.mainViewController as? TREventListViewController {
                            eventListViewController.reloadEventTable()
                            eventListViewController.currentPlayerAvatorIcon?.sd_setImageWithURL(imageURL)
                        }
                    }
                })
            }
        })
    }
    
    
    @IBAction func chnagePassword (sender: UIButton) {
        let storyboard : UIStoryboard = UIStoryboard(name: K.StoryBoard.StoryBoard_Main, bundle: nil)
        let vc : TRChangePasswordViewController = storyboard.instantiateViewControllerWithIdentifier(K.VIEWCONTROLLER_IDENTIFIERS.VIEW_CONTROLLER_CHANGE_PASSWORD) as! TRChangePasswordViewController
        let navigationController = UINavigationController(rootViewController: vc)
        navigationController.navigationBar.hidden = true
        self.presentViewController(navigationController, animated: true, completion: {
            
        })

    }
    
    
    @IBAction func inviteFriends () {
        
        let url: String = "https://crossrd.app.link/share"
        let groupToShare = [url] as [AnyObject]
                
        let activityViewController = UIActivityViewController(activityItems: groupToShare , applicationActivities: nil)
        self.presentViewController(activityViewController, animated: true, completion: {})
    }
    
    
    @IBAction func logOutUser () {
        self.addLogOutAlert()
    }
    
    @IBAction func backButtonPressed (sender: AnyObject) {
        TRApplicationManager.sharedInstance.slideMenuController.closeRight()
    }
    
    
    @IBAction func sendReport () {
        let storyboard : UIStoryboard = UIStoryboard(name: K.StoryBoard.StoryBoard_Main, bundle: nil)
        let vc : TRSendReportViewController = storyboard.instantiateViewControllerWithIdentifier(K.VIEWCONTROLLER_IDENTIFIERS.VIEW_CONTROLLER_SEND_REPORT) as! TRSendReportViewController
        
        let navigationController = UINavigationController(rootViewController: vc)
        navigationController.navigationBar.hidden = true
        self.presentViewController(navigationController, animated: true, completion: nil)
    }
    
    func attributedLabel(label: TTTAttributedLabel!, didSelectLinkWithURL url: NSURL!) {
        let storyboard = UIStoryboard(name: K.StoryBoard.StoryBoard_Main, bundle: nil)
        let legalViewController = storyboard.instantiateViewControllerWithIdentifier(K.VIEWCONTROLLER_IDENTIFIERS.VIEW_CONTROLLER_WEB_VIEW) as! TRLegalViewController
        legalViewController.linkToOpen = url
        self.presentViewController(legalViewController, animated: true, completion: {
            
        })
    }
    
    
    //MOVE THIS TO ANOTHER CLASS LATER
    func addLogOutAlert () {
        let refreshAlert = UIAlertController(title: "", message: "Are you sure you want to log out?", preferredStyle: UIAlertControllerStyle.Alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
            let createRequest = TRAuthenticationRequest()
            createRequest.logoutTRUser() { (value ) in
                if value == true {
                    
                    self.dismissViewControllerAnimated(false, completion:{
                        TRApplicationManager.sharedInstance.purgeSavedData()

                        self.didMoveToParentViewController(nil)
                        self.removeFromParentViewController()
                    })
                    
                    self.presentingViewController?.dismissViewControllerAnimated(false, completion: {
                        TRUserInfo.removeUserData()
                        TRApplicationManager.sharedInstance.purgeSavedData()
                        
                        self.didMoveToParentViewController(nil)
                        self.removeFromParentViewController()
                    })
                } else {
                    self.displayAlertWithTitle("Logout Failed", complete: { (complete) -> () in
                    })
                }
            }
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here")
        }))
        
        presentViewController(refreshAlert, animated: true, completion: nil)
    }
    
    deinit {
        
    }
}

