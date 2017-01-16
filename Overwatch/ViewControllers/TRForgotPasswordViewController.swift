//
//  TRForgotPasswordViewController.swift
//  Traveler
//
//  Created by Ashutosh on 5/11/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import UIKit
import TTTAttributedLabel

private let PICKER_COMPONET_COUNT = 1

class TRForgotPasswordViewController: TRBaseViewController, TTTAttributedLabelDelegate {
    
    var selectedConsole: String?
    
    @IBOutlet weak var userNameTxtField: UITextField!
    @IBOutlet weak var playStationButton: UIButton!
    @IBOutlet weak var xBoxStationButton: UIButton!
    @IBOutlet weak var playStationImage: UIImageView!
    @IBOutlet weak var xBoxStationImage: UIImageView!
    @IBOutlet weak var resetPasswordButton: UIButton!
    @IBOutlet weak var resetPasswordButtonBottom: NSLayoutConstraint!
    @IBOutlet weak var userNameView: UIView!
    @IBOutlet weak var instructionLabel: UILabel!
    @IBOutlet weak var resetPasswordLabel: UILabel!
    
    @IBOutlet weak var successView: UIView!
    @IBOutlet weak var resetLabel: TTTAttributedLabel!
    @IBOutlet weak var goToBungieButton: UIButton!
    @IBOutlet weak var resetPasswordLabelTop: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TRForgotPasswordViewController.keyboardWillShow(_:)), name:UIKeyboardWillShowNotification, object: self.view.window)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TRForgotPasswordViewController.keyboardWillHide(_:)), name:UIKeyboardWillHideNotification, object: self.view.window)
        
        self.userNameTxtField.attributedPlaceholder = NSAttributedString(string:"Enter PlayStation Gamertag", attributes: [NSForegroundColorAttributeName: UIColor.grayColor()])
        self.playStationSelected()
        
        //Attributed Label
        let messageString = "Check your messages on Bungie.net for a reset password link (also viewable in the Destiny companion app)."
        let bungieLinkName = "Bungie.net"
        self.resetLabel?.text = messageString
        
        // Add HyperLink to Bungie
        let nsString = messageString as NSString
        let range = nsString.rangeOfString(bungieLinkName)
        let url = NSURL(string: "https://www.bungie.net/")!
        let subscriptionNoticeLinkAttributes = [
            NSForegroundColorAttributeName: UIColor(red: 0/255, green: 182/255, blue: 231/255, alpha: 1),
            NSUnderlineStyleAttributeName: NSNumber(bool:true),
            ]
        self.resetLabel?.linkAttributes = subscriptionNoticeLinkAttributes
        self.resetLabel?.addLinkToURL(url, withRange: range)
        self.resetLabel?.delegate = self
        
        self.goToBungieButton?.layer.cornerRadius = 2.0
        
        self.userNameTxtField?.becomeFirstResponder()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.userNameTxtField?.isFirstResponder() == true {
            self.userNameTxtField?.resignFirstResponder()
        }
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: self.view.window)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: self.view.window)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func playStationSelected () {
        self.selectedConsole = ConsoleTypes.PS4
        self.playStationButton?.backgroundColor = UIColor(red: 0/255, green: 134/255, blue: 208/255, alpha: 1)
        self.playStationButton?.layer.cornerRadius = 2.0
        self.playStationButton?.alpha = 1
        self.playStationImage?.alpha = 1
        self.userNameTxtField.attributedPlaceholder = NSAttributedString(string:"Enter PlayStation Gamertag", attributes: [NSForegroundColorAttributeName: UIColor.grayColor()])
        
        self.xBoxStationButton?.backgroundColor = UIColor.blackColor()
        self.xBoxStationImage?.alpha = 0.5
        self.xBoxStationButton?.alpha = 0.5
    }
    
    @IBAction func xBoxSelected () {
        self.selectedConsole = ConsoleTypes.XBOXONE
        self.xBoxStationButton?.backgroundColor = UIColor(red: 0/255, green: 134/255, blue: 208/255, alpha: 1)
        self.xBoxStationButton?.layer.cornerRadius = 2.0
        self.xBoxStationButton?.alpha = 1
        self.xBoxStationImage?.alpha = 1
        self.userNameTxtField.attributedPlaceholder = NSAttributedString(string:"Enter Xbox Gamertag", attributes: [NSForegroundColorAttributeName: UIColor.grayColor()])
        
        self.playStationButton?.backgroundColor = UIColor.blackColor()
        self.playStationImage?.alpha = 0.5
        self.playStationButton?.alpha = 0.5
    }
    
    @IBAction func backButton () {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func keyboardWillShow(sender: NSNotification) {
        
        let userInfo: [NSObject : AnyObject] = sender.userInfo!
        
        let keyboardSize: CGSize = userInfo[UIKeyboardFrameBeginUserInfoKey]!.CGRectValue.size
        let offset: CGSize = userInfo[UIKeyboardFrameEndUserInfoKey]!.CGRectValue.size
        
        if keyboardSize.height == offset.height {
            if self.view.frame.origin.y == 0 {
                UIView.animateWithDuration(0.1, animations: { () -> Void in
                    self.resetPasswordButtonBottom.constant = keyboardSize.height
                    if DeviceType.IS_IPHONE_5 {
                        self.resetPasswordLabelTop.constant = self.resetPasswordLabelTop.constant - 60
                    }
                    self.view.layoutIfNeeded()
                })
            }
        } else {
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                self.view.frame.origin.y += keyboardSize.height - offset.height
            })
        }
    }
    
    func keyboardWillHide(sender: NSNotification) {
        let userInfo: [NSObject : AnyObject] = sender.userInfo!
        let keyboardSize: CGSize = userInfo[UIKeyboardFrameBeginUserInfoKey]!.CGRectValue.size
        
        if self.view.frame.origin.y == self.view.frame.origin.y - keyboardSize.height {
            self.view.frame.origin.y += keyboardSize.height
        }
        else {
            self.resetPasswordButtonBottom.constant = 0
            if DeviceType.IS_IPHONE_5 {
                self.resetPasswordLabelTop.constant = self.resetPasswordLabelTop.constant + 60
            }

            self.view.layoutIfNeeded()
        }
    }
    
    func resignKeyBoardResponders () {
        if userNameTxtField.isFirstResponder() {
            userNameTxtField.resignFirstResponder()
        }
    }
    
    
    @IBAction func forgotPassword () {
        
        let userName = self.userNameTxtField?.text
        let consoleType = self.selectedConsole
        
        let displatString: String?
        if self.selectedConsole == ConsoleTypes.PS4 {
            displatString = "PlayStation Gamertag"
        } else {
            displatString = "Xbox Gamertag"
        }
        
        if self.userNameTxtField?.text?.isEmpty == true {
           TRApplicationManager.sharedInstance.addErrorSubViewWithMessage("Please enter \(displatString!)")
            
            return
        }
        
        _ = TRForgotPasswordRequest().resetUserPassword(userName!, consoleType: consoleType!, completion: { (didSucceed) in
            if (didSucceed == true) {
                
                self.userNameView.hidden = true
                self.xBoxStationButton.hidden = true
                self.playStationButton.hidden = true
                self.xBoxStationImage.hidden = true
                self.playStationImage.hidden = true
                self.resetPasswordButton.hidden = true
                self.instructionLabel.hidden = true
                
                self.resetPasswordLabel?.text = "PASSWORD RESET"
                self.goToBungieButton?.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
                self.successView.hidden = false
                self.resignKeyBoardResponders()
                
                if DeviceType.IS_IPHONE_5 {
                    self.resetPasswordLabelTop.constant = self.resetPasswordLabelTop.constant - 80
                } else {
                    self.resetPasswordLabelTop.constant = self.resetPasswordLabelTop.constant + 10
                }
            } else {
                
            }
        })
    }
    
    func attributedLabel(label: TTTAttributedLabel!, didSelectLinkWithURL url: NSURL!) {
        UIApplication.sharedApplication().openURL(url)
    }
    
    func goToBungie () {
        let url = NSURL(string: "https://www.bungie.net/")!
        UIApplication.sharedApplication().openURL(url)
    }
    
    @IBAction func bungieButtonAction () {
        self.goToBungie()
    }
    
    deinit {
        
    }
}
