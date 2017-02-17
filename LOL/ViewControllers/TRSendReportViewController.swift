//
//  TRSendReportViewController.swift
//  Traveler
//
//  Created by Ashutosh on 3/31/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation
import UIKit


class TRSendReportViewController: TRBaseViewController, UITextViewDelegate, CustomErrorDelegate {
    
    var isModallyPresented: Bool = false
    var eventID: String?
    var commentID: String?
    var placeHolderColor = UIColor(red: 189/255, green: 179/255, blue: 126/255, alpha: 1)
    
    let placeHolderString = "What would you like to tell us?"
    
    @IBOutlet weak var reportTextView: UITextView!
    @IBOutlet weak var emailTextView: UITextField!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var sendButtonBottomConst: NSLayoutConstraint!
    
    @IBOutlet weak var navigationBackButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var viewHeaderLable: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.emailView?.layer.cornerRadius = 2.0
        self.reportTextView?.layer.cornerRadius = 2.0
        self.emailView?.clipsToBounds = true
        self.emailTextView?.attributedPlaceholder = NSAttributedString(string:"Your Email (required)", attributes: [NSForegroundColorAttributeName: placeHolderColor])

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TRSendReportViewController.keyboardWillShow(_:)), name:UIKeyboardWillShowNotification, object: self.view.window)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TRSendReportViewController.keyboardWillHide(_:)), name:UIKeyboardWillHideNotification, object: self.view.window)
        
        self.reportTextView?.text = placeHolderString
        self.reportTextView?.textColor = placeHolderColor
        
        if isModallyPresented == true {
            self.cancelButton?.hidden = false
            self.navigationBackButton?.hidden = true
            self.sendButton.setTitle("SUBMIT", forState: .Normal)
            self.viewHeaderLable?.text = "REPORT ISSUE"
        }
        
        if let userName = TRUserInfo.getUserName() {
            self.emailTextView?.text = userName
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.reportTextView?.becomeFirstResponder()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.emailTextView?.isFirstResponder() == true {
            self.emailTextView?.resignFirstResponder()
        } else {
            self.reportTextView?.resignFirstResponder()
        }
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: self.view.window)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: self.view.window)
    }
    
    
    @IBAction func navBackButtonPressed () {
        
        if self.reportTextView.isFirstResponder() {
            self.reportTextView.resignFirstResponder()
        }

        self.dismissViewController(true, dismissed: { (didDismiss) in
            self.didMoveToParentViewController(nil)
            self.removeFromParentViewController()
        })
    }

    
    func keyboardWillShow(sender: NSNotification) {
        
        let userInfo: [NSObject : AnyObject] = sender.userInfo!
        let keyboardSize: CGSize = userInfo[UIKeyboardFrameEndUserInfoKey]!.CGRectValue.size
        let offset: CGSize = userInfo[UIKeyboardFrameEndUserInfoKey]!.CGRectValue.size
        
        if keyboardSize.height == offset.height {
            if self.view.frame.origin.y == 0 {
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    self.sendButtonBottomConst?.constant = keyboardSize.height
                    self.view.layoutIfNeeded()
                })
            }
        } else {
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                self.view.frame.origin.y += keyboardSize.height - offset.height
            })
        }
        
    }
    
    @IBAction func dismissKeyboard(recognizer : UITapGestureRecognizer) {
        if self.reportTextView.isFirstResponder() {
            self.reportTextView.resignFirstResponder()
        }
    }
    
    
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.textColor == placeHolderColor {
            textView.text = nil
            textView.textColor = UIColor.whiteColor()
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeHolderString
            textView.textColor = placeHolderColor
        }
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            self.reportTextView.resignFirstResponder()
            self.sendReportButtonAdded(self.reportTextView)
        }
        
        return true
    }
    
    func keyboardWillHide(sender: NSNotification) {
        let userInfo: [NSObject : AnyObject] = sender.userInfo!
        let keyboardSize: CGSize = userInfo[UIKeyboardFrameEndUserInfoKey]!.CGRectValue.size
        
        if self.view.frame.origin.y == self.view.frame.origin.y - keyboardSize.height {
            self.view.frame.origin.y += keyboardSize.height
        }
        else {
            self.sendButtonBottomConst?.constant = 0
            self.view.layoutIfNeeded()
        }
    }

    
    @IBAction func sendReportButtonAdded (sender: AnyObject) {
        
        let currentUserID = TRUserInfo.getUserID()
        let textString: String = (self.reportTextView?.text)!
        if (textString.characters.count == 0 || textString == placeHolderString) {
            TRApplicationManager.sharedInstance.addErrorSubViewWithMessage("Please enter a message")
            return
        }
        
        let emailString: String = (self.emailTextView?.text)!
        if self.isValidEmail(emailString) == false {
            TRApplicationManager.sharedInstance.addErrorSubViewWithMessage("Please enter a valid email address")
            return
        }
        
//        if textString == "Yatri" {
//            
//            let storyboard = UIStoryboard(name: K.StoryBoard.StoryBoard_Main, bundle: nil)
//            let yatriViewController = storyboard.instantiateViewControllerWithIdentifier(K.VIEWCONTROLLER_IDENTIFIERS.VIEW_CONTROLLER_YATRI) as! YTGameViewController
//            self.presentViewController(yatriViewController, animated: true, completion: {
//                
//            })
//
//            return
//        }
//        
        if self.isModallyPresented == true {
            if self.reportTextView.isFirstResponder() {
                self.reportTextView.resignFirstResponder()
            } else if (self.emailTextView.isFirstResponder()) {
                self.emailTextView.resignFirstResponder()
            }

            _ = TRReportComment().reportAComment(self.commentID!, eventID: self.eventID!,reportDetail: textString, reportedEmail: emailString, completion: { (didSucceed) in
                if didSucceed == true {
                    let errorView = NSBundle.mainBundle().loadNibNamed("TRCustomError", owner: self, options: nil)[0] as! TRCustomError
                    errorView.errorMessageHeader?.text = "REPORT SUBMITTED"
                    errorView.errorMessageDescription?.text = "We are on the case and will work to address your issue as soon as possible."
                    errorView.frame = self.view.frame
                    errorView.delegate = self
                    
                    self.view.addSubview(errorView)
                }
            })
        } else {
            _ = TRCreateAReportRequest().sendCreatedReport(emailString, reportDetail:(self.reportTextView?.text)!, reportType: "issue", reporterID: currentUserID, completion: { (didSucceed) in
                if (didSucceed == true)  {
                    if self.reportTextView.isFirstResponder() {
                        self.reportTextView.resignFirstResponder()
                    }
                    
                    let storyboard = UIStoryboard(name: K.StoryBoard.StoryBoard_Main, bundle: nil)
                    let vc = storyboard.instantiateViewControllerWithIdentifier(K.VIEWCONTROLLER_IDENTIFIERS.VIEW_CONTROLLER_CONTACT_MESSAGE_SENT) as! TRMessageSentConfViewController
                    vc.message = "Thank you! Your message has been sent to support@crossroadsapp.co and we will email you if we need additional details."
                    vc.titleMessage = "MESSAGE SENT"
                    vc.hyperLink = "support@crossroadsapp.co"

                    self.navigationController?.pushViewController(vc, animated: true)
                } else {}
            })
        }
    }
    
    func okButtonPressed () {
        self.dismissViewController(true) { (didDismiss) in
            
        }
    }
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(testStr)
    }
}
