//
//  TRChangeEmailViewController.swift
//  LOL
//
//  Created by Ashutosh on 2/8/17.
//  Copyright © 2017 Catalyst Foundry LLC. All rights reserved.
//

import Foundation

class TRChangeEmailViewController: TRBaseViewController, UIGestureRecognizerDelegate {
 
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var newEmailText: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var oldPasswordView: UIView!
    @IBOutlet weak var passwordUpdatedLabel: UILabel!
    @IBOutlet weak var sendButtonBottonConst: NSLayoutConstraint!
    @IBOutlet weak var changeEmailTextLabel: UILabel!
    @IBOutlet weak var currentEmailTextLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TRChangeEmailViewController.keyboardWillShow(_:)), name:UIKeyboardWillShowNotification, object: self.view.window)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TRChangeEmailViewController.keyboardWillHide(_:)), name:UIKeyboardWillHideNotification, object: self.view.window)
        
        // Placeholder Strings
        let textColor = UIColor(red: 189/255, green: 179/255, blue: 126/255, alpha: 1)
        self.newEmailText.attributedPlaceholder = NSAttributedString(string:"Enter new email address", attributes: [NSForegroundColorAttributeName: textColor])
        self.password.attributedPlaceholder = NSAttributedString(string:"Enter current password", attributes: [NSForegroundColorAttributeName: textColor])
        
        if let userName = TRUserInfo.getUserName() {
            self.currentEmailTextLabel?.text = userName
        }
        
        self.newEmailText?.becomeFirstResponder()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func backButtonPressed(sender: UIButton) {
        
        if self.newEmailText?.isFirstResponder() == true {
            self.newEmailText?.resignFirstResponder()
        } else {
            self.password?.resignFirstResponder()
        }
        
        self.dismissViewController(true) { (didDismiss) in
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if (textField == self.newEmailText) {
            self.password.becomeFirstResponder()
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
        
        if self.newEmailText.text?.isEmpty == false && self.password.text?.isEmpty == false {
            // Change Password
            let _ = TRUpdateUser().updateUserEmail(self.password?.text, newEmail: self.newEmailText?.text) { (didSucceed) in
                
                if didSucceed == true {
                    
                    let defaults = NSUserDefaults.standardUserDefaults()
                    defaults.setValue(self.newEmailText?.text, forKey: K.UserDefaultKey.UserAccountInfo.TR_UserName)
                    defaults.synchronize()
                    
                    self.saveButton.backgroundColor = UIColor(red: 54/255, green: 93/255, blue: 101/255, alpha: 1)
                    self.passwordUpdatedLabel?.hidden = false
                    
                    self.resignKeyBoard()
                }
            }
        }
    }
    
    @IBAction func showPasswordClicked () {
        if let _ = self.password.text where self.password.text?.isEmpty != true {
            let tmpString = self.password?.text
            self.password.secureTextEntry = !self.password.secureTextEntry
            self.password?.text = ""
            self.password?.text = tmpString
        }
    }
    
    @IBAction func dismissKeyboard(recognizer : UITapGestureRecognizer) {
        self.resignKeyBoard()
    }
    
    func resignKeyBoard () {
        if self.password?.isFirstResponder() == true {
            self.password?.resignFirstResponder()
        } else if self.newEmailText?.isFirstResponder() == true{
            self.newEmailText?.resignFirstResponder()
        }
    }
    
    deinit {
        
    }
}