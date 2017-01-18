//
//  TRCreateAccountViewController.swift
//  Traveler
//
//  Created by Rangarajan, Srivatsan on 2/19/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import UIKit
import TTTAttributedLabel

class TRCreateAccountViewController: TRBaseViewController, UITextFieldDelegate, TTTAttributedLabelDelegate, UIGestureRecognizerDelegate {
    
    private let xAxis: CGFloat = 0.0
    private let yAxisWithOpenKeyBoard: CGFloat = 235.0
    private let yAxisWithClosedKeyBoard: CGFloat = 20.0
    
    @IBOutlet weak var userNameTxtField: UITextField!
    @IBOutlet weak var userPwdTxtField: UITextField!
    @IBOutlet weak var userConsoleIDTxtField: UITextField!
    @IBOutlet weak var enterConsoleTypeText: UILabel!
    
    var errorView: TRErrorNotificationView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TRCreateAccountViewController.keyboardWillShow(_:)), name:UIKeyboardWillShowNotification, object: self.view.window)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TRCreateAccountViewController.keyboardWillHide(_:)), name:UIKeyboardWillHideNotification, object: self.view.window)
        
        
        self.userNameTxtField.attributedPlaceholder = NSAttributedString(string:"Enter Crossroads username", attributes: [NSForegroundColorAttributeName: UIColor.grayColor()])
        self.userPwdTxtField.attributedPlaceholder = NSAttributedString(string:"Enter password", attributes: [NSForegroundColorAttributeName: UIColor.grayColor()])
        
        self.userConsoleIDTxtField.delegate = self
        self.userConsoleIDTxtField.text = TRUserInfo.getConsoleID()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: self.view.window)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: self.view.window)
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
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if (textField == self.userNameTxtField) {
            self.userPwdTxtField.becomeFirstResponder()
        } else if (textField == self.userPwdTxtField) {
            self.userConsoleIDTxtField.becomeFirstResponder()
        } else {
            self.userConsoleIDTxtField.resignFirstResponder()
        }
        
        return true
    }
    
    @IBAction func handleSwipeRight(sender: AnyObject) {
        
        //Clear saved Bungie ID
        TRUserInfo.removeUserData()
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func createAccountBtnTapped(sender: AnyObject) {
        
        //Close KeyBoard
        self.resignKeyBoardResponders()
        
        if userNameTxtField.text?.isEmpty  == true {
            TRApplicationManager.sharedInstance.addErrorSubViewWithMessage("Please enter a username")
            
            return
        } else {
            let textcount = userNameTxtField.text?.characters.count
            if textcount < 3 || textcount > 50 {
                TRApplicationManager.sharedInstance.addErrorSubViewWithMessage("Your username must have at least 3 characters.")
                
                return
            }
        }
        
        if userPwdTxtField.text?.isEmpty == true {
            TRApplicationManager.sharedInstance.addErrorSubViewWithMessage("Please enter a password.")
            
            return
        }
        
        if userConsoleIDTxtField.text?.isEmpty == true {
            TRApplicationManager.sharedInstance.addErrorSubViewWithMessage("Please enter a PSN ID.")
            
            return
        }
        
        let userInfo = TRUserInfo()
        userInfo.userName = userNameTxtField.text
        userInfo.password = userPwdTxtField.text
        userInfo.psnID = userConsoleIDTxtField.text
        
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setValue(userPwdTxtField.text, forKey: K.UserDefaultKey.UserAccountInfo.TR_UserPwd)
        defaults.synchronize()
        
        
        let createRequest = TRAuthenticationRequest()
//        createRequest.registerTRUserWith(userInfo) { (value ) in  //, errorData) in
//            
//            if value == true {
//                self.createAccountSuccess()
//            } else {
//                
//                //Delete the saved Password if sign-in was not successful
//                defaults.setValue(nil, forKey: K.UserDefaultKey.UserAccountInfo.TR_UserPwd)
//                defaults.synchronize()
//                
//                TRApplicationManager.sharedInstance.addErrorSubViewWithMessage("Account creation failed.")
//            }
//        }
    }
    
    func createAccountSuccess() {
        self.navigationController?.dismissViewControllerAnimated(true, completion: {
            
        })
    }
    
    
    @IBAction func dismissKeyboard(recognizer : UITapGestureRecognizer) {
        
        self.errorView?.frame = CGRectMake(xAxis, yAxisWithClosedKeyBoard, self.errorView!.frame.size.width, self.errorView!.frame.size.height)
        self.resignKeyBoardResponders()
    }
    
    
    @IBAction func backButtonPressed(sender: UIButton) {
        
        //Clear saved Bungie ID
        TRUserInfo.removeUserData()
        
        self.dismissViewControllerAnimated(true) {
            
        }
    }
    
    func keyboardWillShow(sender: NSNotification) {
        
        let userInfo: [NSObject : AnyObject] = sender.userInfo!
        let keyboardSize: CGSize = userInfo[UIKeyboardFrameBeginUserInfoKey]!.CGRectValue.size
        let offset: CGSize = userInfo[UIKeyboardFrameEndUserInfoKey]!.CGRectValue.size
        
        if keyboardSize.height == offset.height {
            if self.view.frame.origin.y == 0 {
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    self.view.frame.origin.y -= keyboardSize.height
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
        else
        {
            self.view.frame.origin.y = 0
        }
    }
    
    func resignKeyBoardResponders () {
        if userNameTxtField.isFirstResponder() {
            userNameTxtField.resignFirstResponder()
        }
        if userPwdTxtField.isFirstResponder() {
            userPwdTxtField.resignFirstResponder()
        }
        if userConsoleIDTxtField.isFirstResponder() {
            userConsoleIDTxtField.resignFirstResponder()
        }
    }
}
