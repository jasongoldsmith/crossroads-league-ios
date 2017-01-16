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
    
    //Console Buttons/ Image
    @IBOutlet weak var consoleButton: UIButton!
    @IBOutlet weak var consoleButtonImageView: UIImageView!
    @IBOutlet weak var changePasswordButton: UIButton!
    @IBOutlet weak var contactUsButton: UIButton!
    @IBOutlet weak var logOutButton: UIButton!
    @IBOutlet weak var consoleDropDownArrow: UIImageView!
    
    
    var consoleTwoButton: UIButton?
    var consoleAddButton: UIButton?
    var currentUser: TRPlayerInfo?
    var isConsoleMenuOpen: Bool = false
    var consoleAddButtonImageView: UIImageView?
    var consoleTwoButtonImageView: UIImageView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Update build number
        self.addVersionAndLegalAttributedLabel()
        
        //Add Radius to buttons
        self.changePasswordButton.layer.cornerRadius = 2.0
        self.contactUsButton.layer.cornerRadius = 2.0
        self.logOutButton.layer.cornerRadius = 2.0
        
        if TRApplicationManager.sharedInstance.currentUser?.consoles.count == 1 {
            self.consoleDropDownArrow?.hidden = true
        }
}
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.updateView()
        self.backGroundImageView?.clipsToBounds = true
        self.consoleButton.round([.TopLeft, .TopRight], radius: 2.0)
        self.consoleButton?.round([.BottomRight, .BottomLeft], radius: 2.0)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.removeConsoleDropDown()
        self.isConsoleMenuOpen = false
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
        
        if let console = TRApplicationManager.sharedInstance.currentUser?.getDefaultConsole() {
            switch console.consoleType! {
            case ConsoleTypes.XBOX360:
                self.consoleButton.setTitle("Xbox 360", forState: .Normal)
                self.consoleButtonImageView.image = UIImage(named: "iconXboxoneConsole")
                self.avatorImageView?.roundRectView(3.0, borderColor: UIColor(red: 77/255, green: 194/255, blue: 34/255, alpha: 1))
                break
            case ConsoleTypes.XBOXONE:
                self.consoleButton.setTitle("Xbox One", forState: .Normal)
                self.consoleButtonImageView.image = UIImage(named: "iconXboxoneConsole")
                self.avatorImageView?.roundRectView(3.0, borderColor: UIColor(red: 77/255, green: 194/255, blue: 34/255, alpha: 1))
                break
            case ConsoleTypes.PS3:
                self.consoleButton.setTitle("PlayStation 3", forState: .Normal)
                self.consoleButtonImageView.image = UIImage(named: "iconPsnConsole")
                self.avatorImageView?.roundRectView(3.0, borderColor: UIColor(red: 1/255, green: 59/255, blue: 152/255, alpha: 1))
                break
            case ConsoleTypes.PS4:
                self.consoleButton.setTitle("PlayStation 4", forState: .Normal)
                self.consoleButtonImageView.image = UIImage(named: "iconPsnConsole")
                self.avatorImageView?.roundRectView(3.0, borderColor: UIColor(red: 1/255, green: 59/255, blue: 152/255, alpha: 1))
                break
            default:
                break
            }
            
            if TRApplicationManager.sharedInstance.currentUser?.consoles.count < 2 {
                self.avatorImageView?.roundRectView(3.0, borderColor: UIColor(red: 55/255, green: 100/255, blue: 109/255, alpha: 1))
            }
        }
        
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
                        TRUserInfo.removeUserData()
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
    
    //MARK:- ADD CONSOLE VIEW
    
    
    @IBAction func consoleButtonPressed (sender: UIButton) {
        
        if self.isConsoleMenuOpen == true {
            self.removeConsoleDropDown()
            self.consoleButton?.round([.BottomRight, .BottomLeft], radius: 2.0)
        } else {
            self.currentConsoleButtonPressed()
            self.consoleButton?.round([.BottomRight, .BottomLeft], radius: 0.0)
        }
        
        self.isConsoleMenuOpen = !self.isConsoleMenuOpen
    }
    
    func removeConsoleDropDown () {
        self.consoleAddButton?.removeFromSuperview()
        self.consoleTwoButton?.removeFromSuperview()
        self.consoleAddButtonImageView?.removeFromSuperview()
        self.consoleTwoButtonImageView?.removeFromSuperview()
    }
    
    func currentConsoleButtonPressed () {
        for console in (TRApplicationManager.sharedInstance.currentUser?.consoles)! {
            if console.isPrimary == false {
                self.addConsoleButtonFOrType(self.consoleButton, console: console)
            }
        }
    }
    
    func addConsoleButtonFOrType (sender: UIButton, console: TRConsoles) {
        self.consoleTwoButton = UIButton(type: .Custom)
        self.consoleTwoButton?.backgroundColor = UIColor(red: 0/255, green: 56/255, blue: 71/255, alpha: 1)
        self.consoleTwoButton?.frame = CGRectMake(sender.frame.origin.x, sender.frame.origin.y + sender.frame.size.height, sender.frame.size.width, sender.frame.size.height)
        self.consoleTwoButton?.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 14)
        self.consoleTwoButton?.addTarget(self, action: #selector(TRProfileViewController.changePrimaryConsole), forControlEvents: .TouchUpInside)
        self.consoleTwoButton?.layer.borderColor = UIColor(red: 3/255, green: 81/255, blue: 102/255, alpha: 1).CGColor
        self.consoleTwoButton?.layer.borderWidth = 2.0
        
        self.consoleTwoButtonImageView = UIImageView.init(image: UIImage(named: "iconAddConsole"))
        self.consoleTwoButtonImageView!.frame = CGRectMake((self.consoleTwoButton?.frame.origin.x)! + 10, (self.consoleTwoButton?.frame.origin.y)! + 10, self.consoleTwoButtonImageView!.frame.size.width, self.consoleTwoButtonImageView!.frame.size.height)

        switch console.consoleType! {
        case ConsoleTypes.XBOX360:
            self.consoleTwoButton?.setTitle("Xbox 360", forState: .Normal)
            self.consoleTwoButtonImageView!.image = UIImage(named: "iconXboxoneConsole")
            break
        case ConsoleTypes.XBOXONE:
            self.consoleTwoButton?.setTitle("Xbox One", forState: .Normal)
            self.consoleTwoButtonImageView!.image = UIImage(named: "iconXboxoneConsole")
            break
        case ConsoleTypes.PS3:
            self.consoleTwoButton?.setTitle("PlayStation 3", forState: .Normal)
            self.consoleTwoButtonImageView!.image = UIImage(named: "iconPsnConsole")
            break
        case ConsoleTypes.PS4:
            self.consoleTwoButton?.setTitle("PlayStation 4", forState: .Normal)
            self.consoleTwoButtonImageView!.image = UIImage(named: "iconPsnConsole")
            break
        default:
            break
        }
        
        
        self.view.addSubview(self.consoleTwoButton!)
        self.view.addSubview(self.consoleTwoButtonImageView!)
    }
    
//    func addNewConsole () {
//        
//        var consoleOptions :[String] = []
//        let existingConsoles = TRApplicationManager.sharedInstance.currentUser?.consoles
//        for console in existingConsoles! {
//            
//            switch console.consoleType! {
//            case ConsoleTypes.PS4:
//                if existingConsoles?.count == 1 {
//                    consoleOptions.append("Xbox One")
//                    consoleOptions.append("Xbox 360")
//                }
//                break
//            case ConsoleTypes.PS3:
//                if existingConsoles?.count == 1 {
//                    consoleOptions.append("PlayStation 4")
//                    consoleOptions.append("Xbox One")
//                    consoleOptions.append("Xbox 360")
//                } else {
//                    consoleOptions.append("PlayStation 4")
//                    let console = TRApplicationManager.sharedInstance.currentUser?.consoles.filter{$0.consoleType == ConsoleTypes.XBOX360}
//                    if let hasEvent = console?.count where hasEvent > 0 {
//                        consoleOptions.append("Xbox One")
//                    }
//                }
//                break
//            case ConsoleTypes.XBOX360:
//                if existingConsoles?.count == 1 {
//                    consoleOptions.append("Xbox One")
//                    consoleOptions.append("PlayStation 4")
//                    consoleOptions.append("PlayStation 3")
//                } else {
//                    consoleOptions.append("Xbox One")
//                    let console = TRApplicationManager.sharedInstance.currentUser?.consoles.filter{$0.consoleType == ConsoleTypes.PS3}
//                    if let hasEvent = console?.count where hasEvent > 0 {
//                        consoleOptions.append("PlayStation 4")
//                    }
//                }
//                break
//            case ConsoleTypes.XBOXONE:
//                if existingConsoles?.count == 1 {
//                    consoleOptions.append("PlayStation 4")
//                    consoleOptions.append("PlayStation 3")
//                }
//                break
//            default:
//                break
//            }
//        }
//    
//        //Unique Elements in Array
//        consoleOptions = consoleOptions.unique
//        
//        let storyboard = UIStoryboard(name: K.StoryBoard.StoryBoard_Main, bundle: nil)
//        let addConsoleViewCont = storyboard.instantiateViewControllerWithIdentifier(K.VIEWCONTROLLER_IDENTIFIERS.VIEW_CONTROLLER_BUNGIE_VERIFICATION) as! TRAddConsoleViewController
//        addConsoleViewCont.openedFromProfile = true
//        addConsoleViewCont.consoleNameArray = consoleOptions
//        
//        self.presentViewController(addConsoleViewCont, animated: true) { 
//            
//        }
//    }
    
    
    func changePrimaryConsole () {
        
        self.removeConsoleDropDown()
        self.isConsoleMenuOpen = false
        
        var consoleType = ""
        let buttonText = self.consoleTwoButton?.titleLabel?.text
        
        guard let _ = buttonText else {
            return
        }
        
        switch buttonText! as String {
        case "PlayStation 4":
            consoleType = ConsoleTypes.PS4
            break
        case "PlayStation 3":
            consoleType = ConsoleTypes.PS3
            break
        case "Xbox One":
            consoleType = ConsoleTypes.XBOXONE
            break
        case "Xbox 360":
            consoleType = ConsoleTypes.XBOX360
            break
        default:
            break
        }
        
        _ = TRChangeConsoleRequest().changeConsole(consoleType, completion: { (didSucceed) in
            if didSucceed == true {
                _ = TRGetEventsList().getEventsListWithClearActivityBackGround(false, clearBG: false, indicatorTopConstraint: nil, completion: { (didSucceed) -> () in
                    if didSucceed == true {
                        let sliderView = TRApplicationManager.sharedInstance.slideMenuController as SlideMenuController
                        let eventView = sliderView.mainViewController! as? TREventListViewController
                        
                        if let _ = eventView {
                            eventView!.reloadEventTable()
                            eventView!.updateUserAvatorImage()
                            self.updateView()
                        }
                    }
                })
            }
        })
    }
    
    deinit {
        
    }
}

