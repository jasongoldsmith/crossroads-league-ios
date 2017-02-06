//
//  TRSignInCheckUserViewController.swift
//  LOL
//
//  Created by Ashutosh on 1/16/17.
//  Copyright © 2017 Catalyst Foundry LLC. All rights reserved.
//

import Foundation
import SwiftyJSON


class TRSignInCheckUserViewController: TRBaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    var regionDictionary: [String: JSON]?
    var regionalArray: [String] = []
    var selectedRegionCode: String?
    var selectedRegion: String?
    
    private let REGION_CELL = "regionCell"
    
    @IBOutlet weak var regionTableView: UITableView!
    @IBOutlet weak var userNameTxtField: UITextField!
    @IBOutlet weak var regionButton: UIButton!
    @IBOutlet weak var userNameTextView: UIView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var sendButtonBottomConst: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.regionTableView?.registerNib(UINib(nibName: "TRRegionCell", bundle: nil), forCellReuseIdentifier: REGION_CELL)
        self.userNameTxtField.attributedPlaceholder = NSAttributedString(string:"Enter summoners name", attributes: [NSForegroundColorAttributeName: UIColor(red: 189/255, green: 179/255, blue: 126/255, alpha: 1)])
        self.regionButton?.layer.cornerRadius = 2.0
        self.userNameTextView?.layer.cornerRadius = 2.0
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TRSignInCheckUserViewController.keyboardWillShow(_:)), name:UIKeyboardWillShowNotification, object: self.view.window)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TRSignInCheckUserViewController.keyboardWillHide(_:)), name:UIKeyboardWillHideNotification, object: self.view.window)
        
        //Display array for Regions
        self.createDisplayArray()
    }
 
    func createDisplayArray () {
        self.regionDictionary = (TRApplicationManager.sharedInstance.appConfiguration?.regionDict)!
        
        if let _ = self.selectedRegionCode {
        } else {
            self.selectedRegionCode = self.regionDictionary!.first?.0
            self.selectedRegion = self.regionDictionary![self.selectedRegionCode!]?.description
        }
        
        guard let _ = self.selectedRegionCode else {
            return
        }
        
        self.regionButton.setTitle(self.selectedRegion, forState: .Normal)
        
        if let _ = self.regionDictionary {
            for (key, _) in self.regionDictionary! {
                if key != self.selectedRegionCode {
                    self.regionalArray.append("\(key)")
                }
            }
        }
    }
    
    @IBAction func showRegionTable (sender: UIButton) {
        self.changeRegionalTableVisibility()
    }
    
    func changeRegionalTableVisibility () {
        self.regionTableView.hidden = !self.regionTableView.hidden
        
        if userNameTxtField.isFirstResponder() == true {
            self.userNameTxtField?.resignFirstResponder()
        }
    }
    
    @IBAction func joinCrossroadButton (sender: UIButton) {
        
        guard let _ = self.selectedRegionCode else {
            return
        }
        
        _ = TRValidateUserRequest().validateUser(self.userNameTxtField.text!, region: self.selectedRegionCode!, viewWillHandleError: true, completion: { (error, responseObject) in
            
            if let _ = error {
                let storyboard : UIStoryboard = UIStoryboard(name: K.StoryBoard.StoryBoard_Main, bundle: nil)
                let vc : TRSignInErrorViewController = storyboard.instantiateViewControllerWithIdentifier(K.VIEWCONTROLLER_IDENTIFIERS.VIEW_CONTROLLER_SIGNIN_ERROR) as! TRSignInErrorViewController
                vc.signInError = error
                
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                self.dismissViewController(true, dismissed: { (didDismiss) in
                    
                })
            }
        })
    }
    
    @IBAction func popViewController () {
        
        if self.navigationController?.viewControllers.count > 1 {
            self.navigationController?.popViewControllerAnimated(true)
        } else {
            TRUserInfo.removeUserData()
            self.dismissViewController(true, dismissed: { (didDismiss) in
                
            })
        }
    }
    
    //MARK:- Table Delegate Methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clearColor()
        
        return headerView
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 3.0
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return regionalArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(REGION_CELL) as! TRRegionCell
        cell.regionNameLabel.text = regionalArray[indexPath.section]
        cell.imageWithRadius?.layer.cornerRadius = 2.0
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.changeRegionalTableVisibility()
        
        let cell = self.regionTableView.cellForRowAtIndexPath(indexPath) as? TRRegionCell
        self.regionTableView?.deselectRowAtIndexPath(indexPath, animated: false)
        let cellText = cell!.regionNameLabel.text!
        
        self.selectedRegionCode = self.regionDictionary![cellText]?.description
        self.selectedRegion = cellText
        self.createDisplayArray()
    }
    
    
    //MARK:- KEYBOARD
    func keyboardWillShow(sender: NSNotification) {
        
        let userInfo: [NSObject : AnyObject] = sender.userInfo!
        
        let keyboardSize: CGSize = userInfo[UIKeyboardFrameEndUserInfoKey]!.CGRectValue.size
        let offset: CGSize = userInfo[UIKeyboardFrameEndUserInfoKey]!.CGRectValue.size
        
        if keyboardSize.height == offset.height {
            if self.view.frame.origin.y == 0 {
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    self.sendButtonBottomConst?.constant += keyboardSize.height
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
            self.sendButtonBottomConst?.constant = 0
        }
    }

}