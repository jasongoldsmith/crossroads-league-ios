//
//  TREventInfoPlayerCell.swift
//  Traveler
//
//  Created by Ashutosh on 3/29/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation
import UIKit

class TREventInfoPlayerCell: UITableViewCell {
    
    @IBOutlet weak var playerAvatorImageView: UIImageView?
    @IBOutlet weak var playerNameLable: UILabel?
    @IBOutlet weak var chatButton: EventButton?
    
    override func prepareForReuse() {
        
        super.prepareForReuse()
        
        self.playerAvatorImageView?.layer.borderWidth = 0.0
        self.playerAvatorImageView?.image = nil
        self.playerNameLable?.text = nil
        self.chatButton?.hidden = false
        self.chatButton?.buttonPlayerInfo = nil
    }
    
    func updateCellViewWithEvent (playerInfo: TRPlayerInfo, eventInfo: TREventInfo) {
        
        self.playerNameLable?.text = playerInfo.playerPsnID
        self.chatButton?.buttonPlayerInfo = playerInfo
        
        //Adding Image and Radius to Avatar
        let imageURL = NSURL(string: playerInfo.playerImageUrl!)
        if let _ = imageURL {
            self.playerAvatorImageView?.sd_setImageWithURL(imageURL)
            self.playerAvatorImageView?.roundRectView(1, borderColor: UIColor.grayColor())
        }
        
        // If the user is not in the event set the chat button hidden and return
        if !TRApplicationManager.sharedInstance.isCurrentPlayerInAnEvent(eventInfo) {
            self.chatButton?.hidden = true
            return
        }
        
        if TRApplicationManager.sharedInstance.isCurrentPlayerCreatorOfTheEvent(eventInfo) {
            if playerInfo.playerID == eventInfo.eventCreator?.playerID {
                self.chatButton?.hidden = true
            } else {
                self.chatButton?.hidden = false
            }
        } else {
            if playerInfo.playerID == eventInfo.eventCreator?.playerID {
                self.chatButton?.hidden = false
            } else {
                self.chatButton?.hidden = true
            }
        }
    }
}

