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
 
    @IBOutlet var activityIcon          : UIImageView?
    @IBOutlet var activityFeaturedButton : EventButton?
    @IBOutlet var activityRaidButton     : EventButton?
    @IBOutlet var activityArenaButton    : EventButton?
    @IBOutlet var activityCrucibleButton : EventButton?
    @IBOutlet var activityStrikeButton   : EventButton?
    @IBOutlet var activityPatrolButton   : EventButton?
    @IBOutlet var activityStroryButton   : EventButton?
    @IBOutlet var activityQuestButton    : EventButton?
    @IBOutlet var activityExoticButton   : EventButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideNavigationBar()
        
        self.activityFeaturedButton?.activityTypeString = Activity_Type.FEATURED
        self.activityRaidButton?.activityTypeString = Activity_Type.RAID
        self.activityArenaButton?.activityTypeString = Activity_Type.ARENA
        self.activityCrucibleButton?.activityTypeString = Activity_Type.CRUCIBLE
        self.activityStrikeButton?.activityTypeString = Activity_Type.STRIKE
        self.activityPatrolButton?.activityTypeString = Activity_Type.PATROL
        self.activityStroryButton?.activityTypeString = Activity_Type.STORY
        self.activityQuestButton?.activityTypeString  = Activity_Type.QUEST
        self.activityExoticButton?.activityTypeString = Activity_Type.EXOTIC

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
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

