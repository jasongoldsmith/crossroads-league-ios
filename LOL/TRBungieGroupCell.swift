//
//  TRBungieGroupCell.swift
//  Traveler
//
//  Created by Ashutosh on 5/19/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import UIKit

class TRBungieGroupCell: UITableViewCell {
    
    @IBOutlet weak var groupAvator: UIImageView!
    @IBOutlet weak var groupName: UILabel!
    @IBOutlet weak var memberCount: UILabel!
    @IBOutlet weak var clanEnabled: UILabel!
    @IBOutlet weak var notificationButton: EventButton!
    
    
    override func prepareForReuse() {
        
        super.prepareForReuse()
        
        self.groupName.text = nil
        self.groupAvator?.image = nil
        self.memberCount?.text = nil
        self.clanEnabled?.text = nil
        self.contentView.alpha = 1
        self.contentView.userInteractionEnabled = true
        self.notificationButton?.highlighted = false
        self.memberCount.hidden = true
        self.notificationButton.buttonGroupInfo = nil
        self.notificationButton.highlighted = false
        self.contentView.backgroundColor = UIColor(red: 19/255, green: 31/255, blue: 35/255, alpha: 1)
    }
    
    func addNoGroupCellUI () {
        
        //Adding rounder corner for cell
        self.round([.AllCorners], radius: 2)
        
        self.groupAvator?.image = UIImage(named: "imgNogroups")
        self.notificationButton.selected = true
        self.groupName.text = "Your Bungie Group Here"
        self.memberCount.text = "87 in Orbit"
        self.memberCount.hidden = false
        self.clanEnabled.text = "7 Activities"
        self.contentView.backgroundColor = UIColor(red: 35/255, green: 58/255, blue: 62/255, alpha: 1)
    }
    
    func updateCellViewWithGroup (groupInfo: TRBungieGroupInfo) {
        
        //Adding rounder corner for cell
        self.round([.AllCorners], radius: 2)
        
        if let hasImage = groupInfo.avatarPath {
            let imageUrl = NSURL(string: hasImage)
            self.groupAvator?.sd_setImageWithURL(imageUrl)
        }
        
        self.groupName.text = groupInfo.groupName
        if let hasMembers = groupInfo.memberCount {
            self.memberCount.hidden = false
            self.memberCount.text =  hasMembers.description + " in Orbit"
        } else {
            self.memberCount.hidden = true
        }
        
        if let eventCount = groupInfo.eventCount where eventCount > 0 {
            self.clanEnabled.textColor = UIColor(red: 255/255, green: 198/255, blue: 0/255, alpha: 1)
            
            let activity = eventCount == 1 ? " Activity" : " Activities"
            self.clanEnabled.text = eventCount > 1 ? eventCount.description + activity : eventCount.description + activity
        } else {
            self.clanEnabled.textColor = UIColor.lightGrayColor()
            self.clanEnabled.text = "0 Activities"
        }
     
        //Add Radius
        self.layer.cornerRadius = 3
        self.layer.masksToBounds = true
        
        // Cell Shadow
        self.layer.shadowOffset = CGSizeMake(0, 1)
        self.layer.shadowColor = UIColor.blackColor().CGColor
        self.layer.shadowRadius = 3.0
        self.layer.shadowOpacity = 0.2
        self.clipsToBounds = false
        let shadowFrame: CGRect = (self.bounds)
        let shadowPath: CGPathRef = UIBezierPath(rect: shadowFrame).CGPath
        self.layer.shadowPath = shadowPath
        
        if groupInfo.groupId == "clan_id_not_set" {
            self.contentView.backgroundColor = UIColor(red: 3/255, green: 81/255, blue: 102/255, alpha: 1)
        }
    }
}

