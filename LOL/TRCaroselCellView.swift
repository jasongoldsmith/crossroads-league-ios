//
//  TRCaroselCellView.swift
//  Traveler
//
//  Created by Ashutosh on 9/13/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation

class TRCaroselCellView: UIView {
    
    
    @IBOutlet weak var eventIcon: UIImageView!
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var eventCheckPoint: UILabel!
    @IBOutlet weak var eventCreator: UILabel!
    @IBOutlet weak var eventDifficulty: UILabel!
    @IBOutlet weak var joinButton: UIButton!
    @IBOutlet weak var playerOneIcon: UIImageView!
    @IBOutlet weak var playerTwoIcon: UIImageView!
    @IBOutlet weak var playerThreeIcon: UIImageView!
    @IBOutlet weak var playerCountLabelIcon: UILabel!
    @IBOutlet weak var checkPointHeightCont: NSLayoutConstraint!
    
    
    func updateViewWithActivity (eventInfo: TREventInfo) {
        
        //Event Icon
        if let imageURLString = eventInfo.eventActivity?.activityIconImage {
            let url = NSURL(string: imageURLString)
            self.eventIcon!.sd_setImageWithURL(url, placeholderImage: UIImage(named: "iconGhostDefault"))
        }
        
        //EventName
        if let activityType = eventInfo.eventActivity?.activityType {
            let activityNameArray = componentsSeparatedByString(activityType)
            if let _ = activityNameArray where activityNameArray?.count > 1 {
                self.eventName?.text = activityNameArray![1]
            } else {
                self.eventName?.text = activityType
            }
        }
        
        
        //CheckPoint
        if eventInfo.eventActivity?.activitySubType != "" &&  eventInfo.eventActivity?.activitySubType != nil{
            self.eventCheckPoint?.hidden = false
            self.eventCheckPoint?.text = eventInfo.eventActivity?.activitySubType
            self.checkPointHeightCont.constant = 14
        } else {
            self.eventCheckPoint?.hidden = true
            self.checkPointHeightCont.constant = 0
        }
        
        if let eventType = eventInfo.eventActivity?.activityType {
            self.eventDifficulty?.hidden = false
            
            switch eventType {
            case K.ActivityType.RAIDS:
                let difficultyCount = eventInfo.eventActivity?.activityDificulty == "Hard" ? "HARD" : "NORMAL"
                self.eventDifficulty?.text = difficultyCount
                break
            case K.ActivityType.CRUCIBLE:
                let vCount = eventInfo.eventActivity?.activityMaxPlayers?.intValue > 3 ? "6v6" : "3v3"
                self.eventDifficulty?.text = vCount
                break
            default:
                self.eventDifficulty?.hidden = true
            }
        }
        
        // Creator Name
        if let _ = eventInfo.eventCreator?.playerPsnID {
            let finalString = NSMutableAttributedString(string: (eventInfo.eventCreator?.playerPsnID!)!)
            if var clanTag = eventInfo.eventCreator?.getDefaultConsole()?.clanTag where clanTag != "" {
                clanTag = " " + "[" + clanTag + "]"
                let clanAttributedStr = NSAttributedString(string: clanTag)
                finalString.appendAttributedString(clanAttributedStr)
            }
            
            self.eventCreator.attributedText = finalString
        }
        
        //Players Icon
        self.addRadiusToPlayerIconsForPlayersArray(eventInfo)
        
        // Button
        self.joinButton.layer.cornerRadius = 2.0
        
        if (eventInfo.eventStatus == EVENT_STATUS.FULL.rawValue) {
            self.joinButton?.setTitle("FULL", forState: .Normal)
            self.joinButton?.backgroundColor = UIColor(red: 99/255, green: 182/255, blue: 32/255, alpha: 1)
        } else {
            self.joinButton?.setTitle("JOIN", forState: .Normal)
            self.joinButton?.backgroundColor = UIColor(red: 29/255, green: 43/255, blue: 51/255, alpha: 1)
        }
        
        self.playerOneIcon?.roundRectView(1, borderColor: UIColor.grayColor())
        self.playerTwoIcon?.roundRectView(1, borderColor: UIColor.grayColor())
    }
    
    func addRadiusToPlayerIconsForPlayersArray (eventInfo: TREventInfo) {
        
        let playerArray = eventInfo.eventPlayersArray
        
        for (index, player) in playerArray.enumerate() {
            switch index {
            case 0:
                
                self.playerOneIcon.hidden = false
                
                if let imageURLString = player.playerImageUrl {
                    let url = NSURL(string: imageURLString)
                    self.playerOneIcon!.sd_setImageWithURL(url, placeholderImage: UIImage(named: "default_helmet"))
                }
                
                self.playerOneIcon?.roundRectView(1, borderColor: UIColor.grayColor())
                break;
            case 1:
                
                self.playerTwoIcon.hidden = false
                
                if let imageURLString = player.playerImageUrl {
                    let url = NSURL(string: imageURLString)
                    self.playerTwoIcon!.sd_setImageWithURL(url, placeholderImage: UIImage(named: "default_helmet"))
                }
                
                self.playerTwoIcon?.roundRectView(1, borderColor: UIColor.grayColor())
                break;
                
            case 2:
                
                self.playerThreeIcon.hidden = false
                if(eventInfo.eventMaxPlayers?.integerValue > 3 && eventInfo.eventPlayersArray.count > 3) {
                    self.playerThreeIcon.image = nil
                    self.playerCountLabelIcon.hidden = false
                    self.playerCountLabelIcon?.text = "+" + String((playerArray.count - 2))
                    self.playerThreeIcon?.roundRectView(1, borderColor: UIColor.grayColor())
                    
                } else {
                    self.playerThreeIcon.hidden = false
                    self.playerCountLabelIcon.hidden = true
                    
                    if let imageURLString = player.playerImageUrl {
                        let url = NSURL(string: imageURLString)
                        self.playerThreeIcon!.sd_setImageWithURL(url, placeholderImage: UIImage(named: "default_helmet"))
                    } else {
                        self.playerThreeIcon?.image = UIImage(named: "default_helmet")
                    }
                    
                    self.playerThreeIcon?.roundRectView(1, borderColor: UIColor.grayColor())
                }
                
                break;
                
            default:
                break;
            }
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
}