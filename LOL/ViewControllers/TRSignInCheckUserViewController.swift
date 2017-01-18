//
//  TRSignInCheckUserViewController.swift
//  LOL
//
//  Created by Ashutosh on 1/16/17.
//  Copyright © 2017 Catalyst Foundry LLC. All rights reserved.
//

import Foundation


class TRSignInCheckUserViewController: TRBaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var regionDictionary: [String:String] = [
        "Brazil": "BR",
        "EU Nordic & East": "EUNE",
        "EU West": "EUW",
        "Japan": "JP",
        "Korea": "KR",
        "Latin America North": "LAN",
        "Latin America South": "LAS",
        "North America": "NA",
        "Oceania": "OCE",
        "Russia": "RU",
        "Turkey": "TR"
    ]

    var regionalArray: [String] = ["Brazil",
                                   "EU Nordic & East",
                                   "EU West",
                                   "Japan",
                                   "Korea",
                                   "Latin America North",
                                   "Latin America South",
                                   "North America",
                                   "Oceania",
                                   "Russia",
                                   "Turkey"]
    
    private let REGION_CELL       = "regionCell"
    var selectedRegionCode: String?
    
    @IBOutlet weak var regionTableView: UITableView!
    @IBOutlet weak var userConsoleIdTextView: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.regionTableView?.registerNib(UINib(nibName: "TRRegionCell", bundle: nil), forCellReuseIdentifier: REGION_CELL)
    }
 
    @IBAction func showRegionTable (sender: UIButton) {
        self.changeRegionalTableVisibility()
    }
    
    func changeRegionalTableVisibility () {
        self.regionTableView.hidden = !self.regionTableView.hidden
    }
    
    @IBAction func joinCrossroadButton (sender: UIButton) {
        _ = TRValidateUserRequest().validateUser(self.userConsoleIdTextView.text!, region: self.selectedRegionCode!, completion: { (didSucceed) in
            if didSucceed == true {
                
                let storyboard : UIStoryboard = UIStoryboard(name: K.StoryBoard.StoryBoard_Main, bundle: nil)
                let vc : TRCreateAccountViewController = storyboard.instantiateViewControllerWithIdentifier(K.VIEWCONTROLLER_IDENTIFIERS.VIEWCONTROLLER_SIGNUP) as! TRCreateAccountViewController
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                
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
        self.selectedRegionCode = self.regionDictionary[cell!.regionNameLabel.text!]
    }
}