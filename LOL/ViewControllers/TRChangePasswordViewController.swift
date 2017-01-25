//
//  TRChangePasswordViewController.swift
//  Traveler
//
//  Created by Ashutosh on 5/18/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import UIKit

class TRChangePasswordViewController: TRBaseViewController, UIGestureRecognizerDelegate {

    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var oldPassword: UITextField!
    @IBOutlet weak var newPassword: UITextField!
    @IBOutlet weak var oldPasswordView: UIView!
    @IBOutlet weak var newPasswordView: UIView!
    @IBOutlet weak var passwordUpdatedLabel: UILabel!
    @IBOutlet weak var oldEmailView: UIView!
    @IBOutlet weak var newEmailView: UIView!
    @IBOutlet weak var oldEmail: UITextField!
    @IBOutlet weak var newEmail: UITextField!
    @IBOutlet weak var sendButtonBottonConst: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TRChangePasswordViewController.keyboardWillShow(_:)), name:UIKeyboardWillShowNotification, object: self.view.window)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TRChangePasswordViewController.keyboardWillHide(_:)), name:UIKeyboardWillHideNotification, object: self.view.window)

        // Placeholder Strings
        let textColor = UIColor(red: 189/255, green: 179/255, blue: 126/255, alpha: 1)
        self.oldPassword.attributedPlaceholder = NSAttributedString(string:"Enter current password", attributes: [NSForegroundColorAttributeName: textColor])
        self.newPassword.attributedPlaceholder = NSAttributedString(string:"Enter new password", attributes: [NSForegroundColorAttributeName: textColor])
        self.oldEmail.attributedPlaceholder = NSAttributedString(string:"Enter current email address", attributes: [NSForegroundColorAttributeName: textColor])
        self.newEmail.attributedPlaceholder = NSAttributedString(string:"Enter new email address", attributes: [NSForegroundColorAttributeName: textColor])
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func backButtonPressed(sender: UIButton) {
        
        if self.oldPassword?.isFirstResponder() == true {
            self.oldPassword?.resignFirstResponder()
        } else {
            self.newPassword?.resignFirstResponder()
        }
        
        self.dismissViewController(true) { (didDismiss) in
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if (textField == self.oldPassword) {
            self.newPassword.becomeFirstResponder()
        } else {
            self.saveButtonPressed()
        }
        return true
    }
    
    
    @IBAction func textFieldDidDidUpdate (textField: UITextField) {
        if textField.text?.characters.count >= 4 {
            self.saveButton.enabled = true
            self.saveButton.backgroundColor = UIColor(red: 0/255, green: 134/255, blue: 208/255, alpha: 1)
        } else {
            self.saveButton.enabled = false
            self.saveButton.backgroundColor = UIColor(red: 54/255, green: 93/255, blue: 101/255, alpha: 1)
        }
    }

    
    func keyboardWillShow(sender: NSNotification) {
        let userInfo: [NSObject : AnyObject] = sender.userInfo!
        let keyboardSize: CGSize = userInfo[UIKeyboardFrameBeginUserInfoKey]!.CGRectValue.size
        let offset: CGSize = userInfo[UIKeyboardFrameEndUserInfoKey]!.CGRectValue.size
        
        if keyboardSize.height == offset.height {
            
            if self.oldPassword.isFirstResponder() == true || self.newPassword.isFirstResponder() == true {
                if self.sendButtonBottonConst?.constant == 0 {
                    UIView.animateWithDuration(0.4, animations: { () -> Void in
                        self.sendButtonBottonConst?.constant -= keyboardSize.height
                        self.view.frame.origin.y = 0
                    })
                }
            } else {
                self.sendButtonBottonConst?.constant = 0.0
                if self.view.frame.origin.y == 0 {
                    UIView.animateWithDuration(0.4, animations: { () -> Void in
                        self.view.frame.origin.y -= keyboardSize.height
                    })
                }
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
            self.sendButtonBottonConst?.constant = 0
            self.view.frame.origin.y = 0
        }
    }
    
    @IBAction func saveButtonPressed () {
        if self.oldPassword.text?.isEmpty == true && self.oldPassword.text?.isEmpty == false {
            TRApplicationManager.sharedInstance.addErrorSubViewWithMessage("Please enter old password.")
            
            return
        } else if self.newPassword.text?.isEmpty == true && self.oldPassword.text?.isEmpty == false {
            TRApplicationManager.sharedInstance.addErrorSubViewWithMessage("Please enter new password.")
            
            return
        }
    
        let _ = TRUpdateUser().updateUserPassword(self.newPassword?.text, oldPassword: self.oldPassword?.text) { (didSucceed) in
            
            if didSucceed == true {
                
                let defaults = NSUserDefaults.standardUserDefaults()
                defaults.setValue(self.newPassword?.text, forKey: K.UserDefaultKey.UserAccountInfo.TR_UserPwd)
                defaults.synchronize()

                self.oldPasswordView?.hidden = true
                self.newPasswordView?.hidden = true
                self.passwordUpdatedLabel?.hidden = false
                self.saveButton.enabled = false
                self.saveButton.backgroundColor = UIColor(red: 54/255, green: 93/255, blue: 101/255, alpha: 1)

                if self.newPassword?.isFirstResponder() == true {
                    self.newPassword?.resignFirstResponder()
                }
            }
        }
    }
    
    @IBAction func dismissKeyboard(recognizer : UITapGestureRecognizer) {
        if self.newPassword?.isFirstResponder() == true {
            self.newPassword?.resignFirstResponder()
        } else if self.oldPassword?.isFirstResponder() == true{
            self.oldPassword?.resignFirstResponder()
        } else if self.oldEmail?.isFirstResponder() == true{
            self.oldEmail?.resignFirstResponder()
        } else {
            self.newEmail?.resignFirstResponder()
        }
    }
    
    deinit {
        
    }
}
