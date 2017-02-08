//
//  TRSignInViewController.swift
//  Traveler
//
//  Created by Rangarajan, Srivatsan on 2/19/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import UIKit
import TTTAttributedLabel

class TRSignInViewController: TRBaseViewController, UITextFieldDelegate, UIGestureRecognizerDelegate, TTTAttributedLabelDelegate {
    
    
    private let xAxis: CGFloat = 0.0
    private let yAxisWithOpenKeyBoard: CGFloat = 235.0
    private let yAxisWithClosedKeyBoard: CGFloat = 20.0
    
    @IBOutlet weak var legalLabel: TTTAttributedLabel!
    @IBOutlet weak var userNameTxtField: UITextField!
    @IBOutlet weak var userPwdTxtField: UITextField!
    @IBOutlet weak var viewInfoLabel: UILabel!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var sendButtonBottomConst: NSLayoutConstraint!
    @IBOutlet weak var forgotLoginButton: UIButton!
    
    
    var errorView: TRErrorNotificationView?
    var selectedConsole: String?
    var isUserRegistering: Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TRSignInViewController.keyboardWillShow(_:)), name:UIKeyboardWillShowNotification, object: self.view.window)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TRSignInViewController.keyboardWillHide(_:)), name:UIKeyboardWillHideNotification, object: self.view.window)
        
        let textColor = UIColor(red: 189/255, green: 179/255, blue: 126/255, alpha: 1)
        self.userPwdTxtField.attributedPlaceholder = NSAttributedString(string:"Enter password", attributes: [NSForegroundColorAttributeName: textColor])
        self.userNameTxtField.attributedPlaceholder = NSAttributedString(string:"Enter email address", attributes: [NSForegroundColorAttributeName: textColor])
        
        //Legal Statement
        self.addLegalStatmentText()
        
        if self.isUserRegistering == true {
            self.sendButton.setTitle("NEXT", forState: .Normal)
            self.viewInfoLabel?.text = "SIGN UP FOR CROSSROADS"
            self.forgotLoginButton?.hidden = true
            self.legalLabel?.hidden = false
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.userNameTxtField?.isFirstResponder() == true {
            self.userNameTxtField?.resignFirstResponder()
        } else if self.userPwdTxtField?.isFirstResponder() == true {
            self.userPwdTxtField?.resignFirstResponder()
        }
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: self.view.window)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: self.view.window)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.userNameTxtField?.becomeFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func attributedLabel(label: TTTAttributedLabel!, didSelectLinkWithURL url: NSURL!) {
        let storyboard = UIStoryboard(name: K.StoryBoard.StoryBoard_Main, bundle: nil)
        let legalViewController = storyboard.instantiateViewControllerWithIdentifier(K.VIEWCONTROLLER_IDENTIFIERS.VIEW_CONTROLLER_WEB_VIEW) as! TRLegalViewController
        legalViewController.linkToOpen = url
        self.presentViewController(legalViewController, animated: true, completion: {
            
        })
    }
    
    func addLegalStatmentText () {
        let legalString = "By signing in, I have read and agree to the Crossroads Terms of Service and Privacy Policy."
        
        let customerAgreement = "Terms of Service"
        let privacyPolicy = "Privacy Policy"
        
        self.legalLabel?.text = legalString
        
        // Add HyperLink to Bungie
        let nsString = legalString as NSString
        
        let rangeCustomerAgreement = nsString.rangeOfString(customerAgreement)
        let rangePrivacyPolicy = nsString.rangeOfString(privacyPolicy)
        let urlCustomerAgreement = NSURL(string: "http://w3.crossroadsapp.co/lol_conditions.html")!
        let urlPrivacyPolicy = NSURL(string: "http://w3.crossroadsapp.co/lol_policy.html")!
        
        let subscriptionNoticeLinkAttributes = [
            NSForegroundColorAttributeName: UIColor(red: 189/255, green: 179/255, blue: 126/255, alpha: 1),
            NSUnderlineStyleAttributeName: NSNumber(bool:true),
            ]
        self.legalLabel?.linkAttributes = subscriptionNoticeLinkAttributes
        self.legalLabel?.addLinkToURL(urlCustomerAgreement, withRange: rangeCustomerAgreement)
        self.legalLabel?.addLinkToURL(urlPrivacyPolicy, withRange: rangePrivacyPolicy)
        self.legalLabel?.delegate = self
    }
    
    @IBAction func handleSwipeRight(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func popViewController () {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if (textField == self.userNameTxtField) {
            self.userPwdTxtField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            self.signInBtnTapped(self.userPwdTxtField)
        }
        
        return true
    }
    
    @IBAction func signInBtnTapped(sender: AnyObject) {
        
        // Close KeyBoards
        //self.resignKeyBoardResponders()
        
        if userNameTxtField.text?.isEmpty  == true {
            let displatString: String?
            displatString = "email address"
            
            TRApplicationManager.sharedInstance.addErrorSubViewWithMessage("Please enter \(displatString!)")
            
            return
        }
        if userPwdTxtField.text?.isEmpty == true {
            TRApplicationManager.sharedInstance.addErrorSubViewWithMessage("Enter your password")
            
            return
        }
        
        let userInfo = TRUserInfo()
        userInfo.userName = userNameTxtField.text
        userInfo.password = userPwdTxtField.text
        
        //Saving Password here, since the backend won't be sending PW back and the current login flow is checking for UserName and PW
        //to let user login to home page.
        //Setting to "nil" if sign-in is not success
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setValue(userPwdTxtField.text, forKey: K.UserDefaultKey.UserAccountInfo.TR_UserPwd)
        defaults.synchronize()
        
        var console = [String: AnyObject]()
        console["userName"] = userNameTxtField.text
        console["passWord"] = userPwdTxtField.text
        let createRequest = TRAuthenticationRequest()
        
        var invitationDict = NSDictionary()
        if let invi = TRApplicationManager.sharedInstance.invitation {
            invitationDict = invi.createSignInInvitationPayLoad()
        }
        
        
        if isUserRegistering == false {
            createRequest.loginTRUserWith(console, password: userPwdTxtField.text, invitationDict: invitationDict as? Dictionary<String, AnyObject>) { (error, responseObject) in
                if let _ = error {
                    //Delete the saved Password if sign-in was not successful
                    defaults.setValue(nil, forKey: K.UserDefaultKey.UserAccountInfo.TR_UserPwd)
                    defaults.synchronize()
                    
                    // Add Error View
                    let storyboard : UIStoryboard = UIStoryboard(name: K.StoryBoard.StoryBoard_Main, bundle: nil)
                    let vc : TRSignInErrorViewController = storyboard.instantiateViewControllerWithIdentifier(K.VIEWCONTROLLER_IDENTIFIERS.VIEW_CONTROLLER_SIGNIN_ERROR) as! TRSignInErrorViewController
                    vc.userName = self.userNameTxtField.text
                    vc.signInError = error
                    
                    self.navigationController?.pushViewController(vc, animated: true)
                } else {
                    if let _ = TRUserInfo.getConsoleID() {
                        self.performSegueWithIdentifier("TRSignInUnwindAction", sender: nil)
                    } else {
                        self.registerSuccess()
                    }
                }
            }
        } else {
            createRequest.registerTRUserWith(console, password: userPwdTxtField.text, invitationDict: invitationDict as? Dictionary<String, AnyObject>) { (error, responseObject) in
                if let _ = error {
                        //Delete the saved Password if sign-in was not successful
                        defaults.setValue(nil, forKey: K.UserDefaultKey.UserAccountInfo.TR_UserPwd)
                        defaults.synchronize()
                        
                        // Add Error View
                        let storyboard : UIStoryboard = UIStoryboard(name: K.StoryBoard.StoryBoard_Main, bundle: nil)
                        let vc : TRSignInErrorViewController = storyboard.instantiateViewControllerWithIdentifier(K.VIEWCONTROLLER_IDENTIFIERS.VIEW_CONTROLLER_SIGNIN_ERROR) as! TRSignInErrorViewController
                        vc.userName = self.userNameTxtField.text
                        vc.signInError = error
                        
                        self.navigationController?.pushViewController(vc, animated: true)
                } else {
                    self.registerSuccess()
                }
            }
        }
    }
    
    @IBAction func forgotLogin (sender: AnyObject) {
        let storyboard : UIStoryboard = UIStoryboard(name: K.StoryBoard.StoryBoard_Main, bundle: nil)
        let vc : TRForgotPasswordViewController = storyboard.instantiateViewControllerWithIdentifier(K.VIEWCONTROLLER_IDENTIFIERS.VIEW_CONTROLLER_FORGOT_PASSWORD) as! TRForgotPasswordViewController
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func registerSuccess() {
        
        let storyboard : UIStoryboard = UIStoryboard(name: K.StoryBoard.StoryBoard_Main, bundle: nil)
        let vc : TRSignInCheckUserViewController = storyboard.instantiateViewControllerWithIdentifier(K.VIEWCONTROLLER_IDENTIFIERS.VIEW_CONTROLLER_VERIFY_USER) as! TRSignInCheckUserViewController
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func dismissKeyboard(recognizer : UITapGestureRecognizer) {
        
        self.errorView?.frame = CGRectMake(xAxis, yAxisWithClosedKeyBoard, self.errorView!.frame.size.width, self.errorView!.frame.size.height)
        //self.resignKeyBoardResponders()
    }
    
    @IBAction func showPasswordClicked () {
        
        _ = TRAppTrackingRequest().sendApplicationPushNotiTracking(nil, trackingType: APP_TRACKING_DATA_TYPE.TRACKING_SHOW_PASSWORD, completion: {didSucceed in
            if didSucceed == true {
            }
        })
        
        if let _ = self.userPwdTxtField.text where self.userPwdTxtField.text?.isEmpty != true {
            let tmpString = self.userPwdTxtField?.text
            self.userPwdTxtField.secureTextEntry = !self.userPwdTxtField.secureTextEntry
            self.userPwdTxtField?.text = ""
            self.userPwdTxtField?.text = tmpString
        }
    }
    
    //MARK:-KEY-BOARD
    func keyboardWillShow(sender: NSNotification) {
        let userInfo: [NSObject : AnyObject] = sender.userInfo!
        let keyboardSize: CGSize = userInfo[UIKeyboardFrameEndUserInfoKey]!.CGRectValue.size
        let keyBoardHeight = keyboardSize.height
        let animationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey]!.doubleValue
        self.sendButtonBottomConst?.constant = -keyBoardHeight
        UIView.animateWithDuration(animationDuration, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
    }
    
    func keyboardWillHide(sender: NSNotification) {
        let userInfo: [String : AnyObject] = sender.userInfo! as! [String : AnyObject]
        let animationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey]!.doubleValue
        self.sendButtonBottomConst?.constant = 0.0
        UIView.animateWithDuration(animationDuration, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
    }
    
    func resignKeyBoardResponders () {
        if userNameTxtField.isFirstResponder() {
            userNameTxtField.resignFirstResponder()
        }
        if userPwdTxtField.isFirstResponder() {
            userPwdTxtField.resignFirstResponder()
        }
    }
}
