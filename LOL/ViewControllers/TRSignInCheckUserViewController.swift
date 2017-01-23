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
    
    private let REGION_CELL = "regionCell"
    
    @IBOutlet weak var regionTableView: UITableView!
    @IBOutlet weak var userConsoleIdTextView: UITextField!
    @IBOutlet weak var userNameTxtField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.regionTableView?.registerNib(UINib(nibName: "TRRegionCell", bundle: nil), forCellReuseIdentifier: REGION_CELL)
        
        self.regionDictionary = (TRApplicationManager.sharedInstance.appConfiguration?.regionDict)!
        if let _ = self.regionDictionary {
            for (key, _) in self.regionDictionary! {
                self.regionalArray.append("\(key)")
            }
        }
        
        self.selectedRegionCode = self.regionDictionary![self.regionalArray.first!]?.description
        self.userNameTxtField.attributedPlaceholder = NSAttributedString(string:"Enter summoners name", attributes: [NSForegroundColorAttributeName: UIColor(red: 189/255, green: 179/255, blue: 126/255, alpha: 1)])
    }
 
    @IBAction func showRegionTable (sender: UIButton) {
        self.changeRegionalTableVisibility()
    }
    
    func changeRegionalTableVisibility () {
        self.regionTableView.hidden = !self.regionTableView.hidden
    }
    
    @IBAction func joinCrossroadButton (sender: UIButton) {
        
        guard let _ = self.selectedRegionCode else {
            return
        }
        
        _ = TRValidateUserRequest().validateUser(self.userConsoleIdTextView.text!, region: self.selectedRegionCode!, viewWillHandleError: true, completion: { (error, responseObject) in
            
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
        self.navigationController?.popViewControllerAnimated(true)
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
        return 0.0
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return regionalArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(REGION_CELL) as! TRRegionCell
        cell.regionNameLabel.text = regionalArray[indexPath.section]
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.changeRegionalTableVisibility()
        
        let cell = self.regionTableView.cellForRowAtIndexPath(indexPath) as? TRRegionCell
        self.regionTableView?.deselectRowAtIndexPath(indexPath, animated: false)
        let cellText = cell!.regionNameLabel.text!
        self.selectedRegionCode = self.regionDictionary![cellText]?.description
    }
}