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
    @IBOutlet weak var resetPasswordButton: UIButton!
    @IBOutlet weak var resetPasswordButtonBottom: NSLayoutConstraint!
    @IBOutlet weak var userNameView: UIView!
    @IBOutlet weak var instructionLabel: TTTAttributedLabel!
    @IBOutlet weak var resetPasswordLabel: UILabel!
    @IBOutlet weak var resetPasswordLabelTop: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TRForgotPasswordViewController.keyboardWillShow(_:)), name:UIKeyboardWillShowNotification, object: self.view.window)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TRForgotPasswordViewController.keyboardWillHide(_:)), name:UIKeyboardWillHideNotification, object: self.view.window)
        
        self.userNameTxtField.attributedPlaceholder = NSAttributedString(string:"Enter email address", attributes: [NSForegroundColorAttributeName: UIColor(red: 189/255, green: 179/255, blue: 126/255, alpha: 1)])
        
        self.userNameTxtField?.becomeFirstResponder()
        
        let textMessage = "We will send a reset password link to your email address. If you forgot the email address you signed up with, please contact us at support@crossroadsapp.co"
        
        
        self.instructionLabel.text = textMessage
        self.instructionLabel?.activeLinkAttributes
        let subscriptionNoticeLinkAttributes = [
            NSForegroundColorAttributeName: UIColor(red: 198/255, green: 127/255, blue: 6/255, alpha: 1),
            NSUnderlineStyleAttributeName: NSNumber(bool:true),
            ]
        let nsString = textMessage as NSString
        let emailID =  "support@crossroadsapp.co"
        let emailIDRange = nsString.rangeOfString(emailID)
        self.instructionLabel?.linkAttributes = subscriptionNoticeLinkAttributes
        self.instructionLabel?.addLinkToURL(NSURL(string:""), withRange: emailIDRange)
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
    
    
    @IBAction func backButton () {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func keyboardWillShow(sender: NSNotification) {
        
        let userInfo: [NSObject : AnyObject] = sender.userInfo!
        
        let keyboardSize: CGSize = userInfo[UIKeyboardFrameEndUserInfoKey]!.CGRectValue.size
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
        let keyboardSize: CGSize = userInfo[UIKeyboardFrameEndUserInfoKey]!.CGRectValue.size
        
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
        
        if self.userNameTxtField?.text?.isEmpty == true {
           TRApplicationManager.sharedInstance.addErrorSubViewWithMessage("Please enter email address")
            
            return
        }
        
        _ = TRForgotPasswordRequest().resetUserPassword(userName!, completion: { (didSucceed) in
            if (didSucceed == true) {

                let storyboard = UIStoryboard(name: K.StoryBoard.StoryBoard_Main, bundle: nil)
                let vc = storyboard.instantiateViewControllerWithIdentifier(K.VIEWCONTROLLER_IDENTIFIERS.VIEW_CONTROLLER_CONTACT_MESSAGE_SENT) as! TRMessageSentConfViewController
                self.navigationController?.pushViewController(vc, animated: true)
                
                if let emailText = self.userNameTxtField?.text {
                    vc.message = "Check your email address at:\n\(emailText)\nfor a password link."
                    vc.titleMessage = "EMAIL SENT"
                    vc.hyperLink = emailText
                }
                
//                self.userNameView.hidden = true
//                self.resetPasswordButton.hidden = true
//                self.instructionLabel.hidden = true
//                self.resetPasswordLabel?.text = "EMAIL SENT"
//                self.resignKeyBoardResponders()
//                
//                if DeviceType.IS_IPHONE_5 {
//                    self.resetPasswordLabelTop.constant = self.resetPasswordLabelTop.constant - 80
//                } else {
//                    self.resetPasswordLabelTop.constant = self.resetPasswordLabelTop.constant + 10
//                }
            } else {
                
            }
        })
    }
    
    func attributedLabel(label: TTTAttributedLabel!, didSelectLinkWithURL url: NSURL!) {
        UIApplication.sharedApplication().openURL(url)
    }

    
    deinit {
        
    }
}
