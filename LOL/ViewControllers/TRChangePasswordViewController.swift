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
    @IBOutlet weak var sendButtonBottonConst: NSLayoutConstraint!
    @IBOutlet weak var changepasswordTextLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TRChangePasswordViewController.keyboardWillShow(_:)), name:UIKeyboardWillShowNotification, object: self.view.window)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TRChangePasswordViewController.keyboardWillHide(_:)), name:UIKeyboardWillHideNotification, object: self.view.window)

        // Placeholder Strings
        let textColor = UIColor(red: 189/255, green: 179/255, blue: 126/255, alpha: 1)
        self.oldPassword.attributedPlaceholder = NSAttributedString(string:"Enter current password", attributes: [NSForegroundColorAttributeName: textColor])
        self.newPassword.attributedPlaceholder = NSAttributedString(string:"Enter new password", attributes: [NSForegroundColorAttributeName: textColor])
        
        self.oldPassword?.becomeFirstResponder()
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
    
    @IBAction func textFieldDidBecomeActive (sender: UITextField) {
        
    }
    
    @IBAction func textFieldDidDidUpdate (textField: UITextField) {
        if textField.text?.characters.count >= 4 {
            self.saveButton.enabled = true
            self.saveButton.backgroundColor = UIColor(red: 148/255, green: 123/255, blue: 67/255, alpha: 1)
        } else {
            self.saveButton.enabled = false
            self.saveButton.backgroundColor = UIColor(red: 54/255, green: 93/255, blue: 101/255, alpha: 1)
        }
    }
    

    func keyboardWillShow(sender: NSNotification) {
        let userInfo: [NSObject : AnyObject] = sender.userInfo!
        let keyboardSize: CGSize = userInfo[UIKeyboardFrameEndUserInfoKey]!.CGRectValue.size
        let keyBoardHeight = keyboardSize.height
        let animationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey]!.doubleValue
        self.sendButtonBottonConst?.constant = -keyBoardHeight
        UIView.animateWithDuration(animationDuration, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
    }
    
    func keyboardWillHide(sender: NSNotification) {
        let userInfo: [String : AnyObject] = sender.userInfo! as! [String : AnyObject]
        let animationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey]!.doubleValue
        self.sendButtonBottonConst?.constant = 0.0
        UIView.animateWithDuration(animationDuration, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
    }

    @IBAction func saveButtonPressed () {
        
        if self.oldPassword.text?.isEmpty == false && self.newPassword.text?.isEmpty == false {
            let _ = TRUpdateUser().updateUserPassoword(self.newPassword?.text, oldPassword: self.oldPassword?.text) { (didSucceed) in
                
                if didSucceed == true {
                    
                    let defaults = NSUserDefaults.standardUserDefaults()
                    defaults.setValue(self.newPassword?.text, forKey: K.UserDefaultKey.UserAccountInfo.TR_UserPwd)
                    defaults.synchronize()
                    
                    self.saveButton.backgroundColor = UIColor(red: 54/255, green: 93/255, blue: 101/255, alpha: 1)
                    self.passwordUpdatedLabel?.hidden = false
                    
                    self.resignKeyBoard()
                }
            }
        }
    }
    
    @IBAction func showNewPasswordClicked () {
        if let _ = self.newPassword.text where self.newPassword.text?.isEmpty != true {
            let tmpString = self.newPassword?.text
            self.newPassword.secureTextEntry = !self.newPassword.secureTextEntry
            self.newPassword?.text = ""
            self.newPassword?.text = tmpString
        }
    }

    @IBAction func showOldPasswordClicked () {
        if let _ = self.oldPassword.text where self.oldPassword.text?.isEmpty != true {
            let tmpString = self.oldPassword?.text
            self.oldPassword.secureTextEntry = !self.oldPassword.secureTextEntry
            self.oldPassword?.text = ""
            self.oldPassword?.text = tmpString
        }
    }

    
    @IBAction func dismissKeyboard(recognizer : UITapGestureRecognizer) {
        self.resignKeyBoard()
    }
    
    func resignKeyBoard () {
        if self.newPassword?.isFirstResponder() == true {
            self.newPassword?.resignFirstResponder()
        } else if self.oldPassword?.isFirstResponder() == true{
            self.oldPassword?.resignFirstResponder()
        }
    }
    
    deinit {
        
    }
}
