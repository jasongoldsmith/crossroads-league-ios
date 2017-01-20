//
//  TRCreateEventViewController.swift
//  Traveler
//
//  Created by Ashutosh on 3/4/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage


class TRCreateEventViewController: TRBaseViewController {
 
    @IBOutlet var buttonOne     : EventButton?
    @IBOutlet var buttonTwo     : EventButton?
    @IBOutlet var buttonThree   : EventButton?
    @IBOutlet var buttonFour    : EventButton?
    @IBOutlet var buttonFive    : EventButton?
    @IBOutlet var buttonSix     : EventButton?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideNavigationBar()
        
        self.buttonOne?.activityTypeString = Activity_Type.PVP_RIFT
        self.buttonTwo?.activityTypeString = Activity_Type.PVP_TREELINE
        self.buttonThree?.activityTypeString = Activity_Type.PVP_ARAM
        self.buttonFour?.activityTypeString = Activity_Type.PVP_CUSTOM
        
        self.buttonFive?.activityTypeString = Activity_Type.AI_RIFT
        self.buttonSix?.activityTypeString = Activity_Type.AI_TREELINE
        
        self.addButtonShadows(self.buttonOne!)
        self.addButtonShadows(self.buttonTwo!)
        self.addButtonShadows(self.buttonThree!)
        self.addButtonShadows(self.buttonFour!)
        self.addButtonShadows(self.buttonFive!)
        self.addButtonShadows(self.buttonSix!)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func addButtonShadows (sender: EventButton) {
        sender.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).CGColor
        sender.layer.shadowOffset = CGSizeMake(0.0, 2.0)
        sender.layer.shadowOpacity = 1.0
        sender.layer.masksToBounds = false
        sender.layer.cornerRadius = 2.0
    }
    
    @IBAction func activityButtonPressed (sender: EventButton) {
        
        _ = TRgetActivityList().getActivityListofType((sender.activityTypeString?.rawValue)!, completion: { (didSucceed) in
            if didSucceed == true {
                let vc = TRApplicationManager.sharedInstance.stroryBoardManager.getViewControllerWithID(K.VIEWCONTROLLER_IDENTIFIERS.VIEW_CONTROLLER_CREATE_EVENT_FINAL, storyBoardID: K.StoryBoard.StoryBoard_Main) as! TRCreateEventFinalView
                vc.activityInfo = TRApplicationManager.sharedInstance.activityList
                
                self.navigationController?.pushViewController(vc, animated: true)
            }
        })
    }
    
    
    @IBAction func cancelButtonPressed (sender: UIButton) {
        self.dismissViewController(true) { (didDismiss) in
            
        }
    }
    
    deinit {
    
    }
}

