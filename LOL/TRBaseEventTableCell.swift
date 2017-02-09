//
//  TRBaseEventTableCell.swift
//  Traveler
//
//  Created by Ashutosh on 4/21/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation
import UIKit

class TRBaseEventTableCell: UITableViewCell {
    
    override func prepareForReuse() {
        
        super.prepareForReuse()
        
        self.playerImageOne.image = nil
        self.playerImageTwo.image = nil
        self.playerCountLabel.text = nil
        self.playerCountImage.image = nil
        self.playerImageOne.hidden = true
        self.playerImageTwo.hidden = true
        self.playerCountLabel.hidden = true
        self.playerCountImage.hidden = true
        self.eventTimeLabel?.hidden = true
        self.activityCheckPointLabel?.text = nil
        self.activityCheckPointLabel?.hidden = true
        self.eventTagLabel?.text = nil
        self.activityLight?.hidden = true
    }
    
    @IBOutlet weak var eventIcon            :UIImageView?
    @IBOutlet weak var eventTitle           :UILabel?
    @IBOutlet weak var activityLight        :UILabel?
    @IBOutlet weak var eventPlayersName     :UILabel!
    @IBOutlet weak var playerImageOne       :UIImageView!
    @IBOutlet weak var playerImageTwo       :UIImageView!
    @IBOutlet weak var playerCountImage     :UIImageView!
    @IBOutlet weak var playerCountLabel     :UILabel!
    @IBOutlet weak var joinEventButton      :EventButton!
    @IBOutlet weak var leaveEventButton     :EventButton!
    @IBOutlet weak var activityCheckPointLabel : UILabel?
    @IBOutlet weak var eventTimeLabel       :UILabel?
    @IBOutlet weak var eventTagLabel        :TRInsertLabel?
    
    func updateCellViewWithEvent (eventInfo: TREventInfo) {

        if DeviceType.IS_IPHONE_4_OR_LESS || DeviceType.IS_IPHONE_5 {
            eventTitle?.font = UIFont(name:"HelveticaNeue", size: 17)
        }

        //Adding Radius to
        self.addRadiusToPlayerIconsForPlayersArray(eventInfo)
        
        
        //Activity Name
        if let activityType = eventInfo.eventActivity?.activityType {
            let activityNameArray = componentsSeparatedByString(activityType)
            if let _ = activityNameArray where activityNameArray?.count > 1 {
                self.eventTitle?.text = activityNameArray![1]
            } else {
                self.eventTitle?.text = activityType
            }
        }
        
        //Event Tag
        if let hasTag = eventInfo.eventActivity?.activityTag where hasTag != "" {
            self.eventTagLabel?.hidden = false
            self.eventTagLabel?.text = eventInfo.eventActivity?.activityTag
        } else {
            self.eventTagLabel?.hidden = true
        }
        
        //Add corner radius
        self.eventTagLabel?.layer.cornerRadius = 2.0
        self.eventTagLabel?.layer.masksToBounds = true
        
        if let eventType = eventInfo.eventActivity?.activityType {
            self.activityLight?.hidden = false
            
            switch eventType {
            case K.ActivityType.RAIDS:
                let difficultyCount = eventInfo.eventActivity?.activityDificulty == "Hard" ? "HARD" : "NORMAL"
                self.activityLight?.text = difficultyCount
                break
            case K.ActivityType.CRUCIBLE:
                let vCount = eventInfo.eventActivity?.activityMaxPlayers?.intValue > 3 ? "6v6" : "3v3"
                self.activityLight?.text = vCount
                break
            default:
                self.activityLight?.hidden = true
            }
        }
        
        // Set  Event Player Names
        if (eventInfo.eventPlayersArray.count < eventInfo.eventActivity?.activityMaxPlayers?.integerValue) {
            let stringColorAttribute = [NSForegroundColorAttributeName: UIColor(red: 189/255, green: 179/255, blue: 126/255, alpha: 1)]
            let extraPlayersRequiredCount = ((eventInfo.eventActivity?.activityMaxPlayers?.integerValue)! - eventInfo.eventPlayersArray.count)
            let extraPlayersRequiredCountString = String(extraPlayersRequiredCount)
            let extraPlayersRequiredCountStringNew = " LF" + "\(extraPlayersRequiredCountString)M"
            
            // Attributed Strings
            let extraPlayersRequiredCountStringNewAttributed = NSAttributedString(string: extraPlayersRequiredCountStringNew, attributes: stringColorAttribute)
            if let _ = eventInfo.eventCreator?.playerPsnID {
                
                let finalString = NSMutableAttributedString(string: (eventInfo.eventCreator?.playerPsnID!)!)
                if var clanTag = eventInfo.eventCreator?.getDefaultConsole()?.clanTag where clanTag != "" {
                    clanTag = " " + "[" + clanTag + "]"
                    let clanAttributedStr = NSAttributedString(string: clanTag)
                    if eventInfo.eventCreator!.playerID != TRApplicationManager.sharedInstance.currentUser?.userID {
                        finalString.appendAttributedString(clanAttributedStr)
                    } else if (TRUserInfo.isUserVerified()! == ACCOUNT_VERIFICATION.USER_VERIFIED.rawValue) {
                        finalString.appendAttributedString(clanAttributedStr)
                    }
                }
                
                finalString.appendAttributedString(extraPlayersRequiredCountStringNewAttributed)
                self.eventPlayersName.attributedText = finalString
            }
        } else {
            var playersNameString = (eventInfo.eventCreator?.playerPsnID!)!
            if var clanTag = eventInfo.eventCreator?.getDefaultConsole()?.clanTag where clanTag != "" {
                clanTag = " " + "[" + clanTag + "]"
                if eventInfo.eventCreator!.playerID != TRApplicationManager.sharedInstance.currentUser?.userID {
                    playersNameString = playersNameString + clanTag
                } else if (TRUserInfo.isUserVerified()! == ACCOUNT_VERIFICATION.USER_VERIFIED.rawValue) {
                    playersNameString = playersNameString + clanTag
                }
            }
            
            self.eventPlayersName.text = playersNameString
        }
        
        // Set Event Icon Image
        if let imageURLString = eventInfo.eventActivity?.activityIconImage {
            let url = NSURL(string: imageURLString)
            self.eventIcon!.sd_setImageWithURL(url, placeholderImage: UIImage(named: "iconGhostDefault"))
        }
        
        // Set Event Button Status
        self.eventButtonStatusForCurrentPlayer(eventInfo, button: self.joinEventButton)
        
        if let hasLaunchDate = eventInfo.eventLaunchDate {
            let formatter = NSDateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            if let eventDate = formatter.dateFromString(hasLaunchDate) {
                if eventDate.isThisWeek() == true {
                    let time = eventDate.toString(format: .Custom(weekDayDateFormat()))
                    self.eventTimeLabel?.text = "\(time)"
                } else {
                    self.eventTimeLabel?.text = eventDate.toString(format: .Custom(trDateFormat()))
                }
            }
        }
        
        if eventInfo.eventActivity?.activitySubType != "" &&  eventInfo.eventActivity?.activitySubType != nil{
            self.activityCheckPointLabel?.hidden = false
            self.activityCheckPointLabel?.text = eventInfo.eventActivity?.activitySubType
        }
    }
    
    func addRadiusToPlayerIconsForPlayersArray (eventInfo: TREventInfo) {
        
        let playerArray = eventInfo.eventPlayersArray
        
        for (index, player) in playerArray.enumerate() {
            switch index {
            case 0:
                
                self.playerImageOne.hidden = false
                self.playerImageOne?.roundRectView(1, borderColor: UIColor.grayColor())
                
                if player.userVerified != ACCOUNT_VERIFICATION.USER_VERIFIED.rawValue {
                    self.playerImageOne?.image = UIImage(named: "default_helmet")
                } else {
                    if let imageURLString = player.playerImageUrl {
                        let url = NSURL(string: imageURLString)
                        self.playerImageOne!.sd_setImageWithURL(url, placeholderImage: UIImage(named: "default_helmet"))
                    }
                }
                
                break;
            case 1:
                
                self.playerImageTwo.hidden = false
                self.playerImageTwo?.roundRectView(1, borderColor: UIColor.grayColor())
                
                if player.userVerified != ACCOUNT_VERIFICATION.USER_VERIFIED.rawValue {
                    self.playerImageTwo?.image = UIImage(named: "default_helmet")
                } else {
                    if let imageURLString = player.playerImageUrl {
                        let url = NSURL(string: imageURLString)
                        self.playerImageTwo!.sd_setImageWithURL(url, placeholderImage: UIImage(named: "default_helmet"))
                    }
                }
                
                break;
                
            case 2:
                
                self.playerCountImage.hidden = false
                if(eventInfo.eventMaxPlayers?.integerValue > 3 && eventInfo.eventPlayersArray.count > 3) {
                    self.playerCountImage.image = nil
                    self.playerCountLabel.hidden = false
                    self.playerCountLabel?.text = "+" + String((playerArray.count - 2))
                    self.playerCountImage?.roundRectView(1, borderColor: UIColor.grayColor())
                    
                } else {
                    self.playerCountLabel.hidden = true
                    self.playerCountImage?.roundRectView(1, borderColor: UIColor.grayColor())

                    if player.userVerified != ACCOUNT_VERIFICATION.USER_VERIFIED.rawValue {
                        self.playerCountImage?.image = UIImage(named: "default_helmet")
                    } else {
                        if let imageURLString = player.playerImageUrl {
                            let url = NSURL(string: imageURLString)
                            self.playerCountImage!.sd_setImageWithURL(url, placeholderImage: UIImage(named: "default_helmet"))
                        }
                    }
                }
                
                break;
                
            default:
                break;
            }
        }
    }
    
    func eventButtonStatusForCurrentPlayer (event: TREventInfo, button: EventButton) {
        
        button.userInteractionEnabled = true
        var currentPlayer: TRPlayerInfo?
        let currentLoggedInUser = event.eventPlayersArray.filter{$0.playerID == TRApplicationManager.sharedInstance.currentUser?.userID!}
        if let _ = currentLoggedInUser.first {
            currentPlayer = currentLoggedInUser.first
        }
        
        if (event.eventCreator?.playerID == TRUserInfo.getUserID()) {
            button.setImage(UIImage(named: "btnOWNER"), forState: .Normal)
            button.userInteractionEnabled = false
            leaveEventButton.hidden = false
            
            return
        }
        
        if (event.eventStatus == EVENT_STATUS.FULL.rawValue) {
            if(TRApplicationManager.sharedInstance.isCurrentPlayerInAnEvent(event)) {
                button.setImage(UIImage(named: "btnREADY"), forState: .Normal)
                button.userInteractionEnabled = false
                leaveEventButton.hidden = false
                //                completion(value: true)
            } else {
                button.setImage(UIImage(named: "btnFULL"), forState: .Normal)
                button.userInteractionEnabled = false
                leaveEventButton.hidden = true
            }
            
        } else if (event.eventStatus == EVENT_STATUS.NEW.rawValue) {
            if (TRApplicationManager.sharedInstance.isCurrentPlayerCreatorOfTheEvent(event)) {
                
                if currentPlayer?.isInvited == true {
                    button.setImage(UIImage(named: "btnINVITED"), forState: .Normal)
                } else {
                    button.setImage(UIImage(named: "btnGOING"), forState: .Normal)
                }
                
                button.userInteractionEnabled = false
                leaveEventButton.hidden = false
            } else {
                button.setImage(UIImage(named: "btnJOIN"), forState: .Normal)
                leaveEventButton.hidden = true
            }
            
        } else if (event.eventStatus == EVENT_STATUS.OPEN.rawValue) {
            if (TRApplicationManager.sharedInstance.isCurrentPlayerInAnEvent(event)) {
                
                if currentPlayer?.isInvited == true {
                    button.setImage(UIImage(named: "btnINVITED"), forState: .Normal)
                } else {
                    button.setImage(UIImage(named: "btnGOING"), forState: .Normal)
                }

                button.userInteractionEnabled = false
                leaveEventButton.hidden = false
            } else {
                button.setImage(UIImage(named: "btnJOIN"), forState: .Normal)
                leaveEventButton.hidden = true
            }
        } else {
            //CAN_JOIN
            if (TRApplicationManager.sharedInstance.isCurrentPlayerInAnEvent(event)) {
                
                if currentPlayer?.isInvited == true {
                    button.setImage(UIImage(named: "btnINVITED"), forState: .Normal)
                } else {
                    button.setImage(UIImage(named: "btnGOING"), forState: .Normal)
                }

                button.userInteractionEnabled = false
                leaveEventButton.hidden = false
            } else {
                button.setImage(UIImage(named: "btnJOIN"), forState: .Normal)
                leaveEventButton.hidden = true
            }
        }
    }
}
