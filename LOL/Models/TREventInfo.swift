//
//  TREventInfo.swift
//  Traveler
//
//  Created by Ashutosh on 2/26/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation
import SwiftyJSON

class TREventInfo: NSObject {

    var eventID                 : String?
    var eventStatus             : String?
    var eventUpdatedDate        : String?
    var eventV                  : String?
    var eventMaxPlayers         : NSNumber?
    var eventMinPlayer          : NSNumber?
    var eventCreatedDate        : String?
    var eventLaunchDate         : String?
    var eventActivity           : TRActivityInfo?
    var eventCreator            : TRCreatorInfo?
    var eventPlayersArray       : [TRPlayerInfo] = []
    var isFutureEvent           : Bool = false
    var eventClanID             : String?
    var eventConsoleType        : String?
    var clanName                : String?
    var eventComments           : [TRCommentInfo] = []
    
    
    func parseCreateEventInfoObject (swiftyJason: JSON) -> TREventInfo {
        
        // Creating Event Objects from Events List
        self.eventID           = swiftyJason["_id"].stringValue
        self.eventStatus       = swiftyJason["status"].stringValue
        self.eventUpdatedDate  = swiftyJason["updated"].stringValue
        self.eventMaxPlayers   = swiftyJason["maxPlayers"].numberValue
        self.eventMinPlayer    = swiftyJason["minPlayers"].numberValue
        self.eventCreatedDate  = swiftyJason["created"].stringValue
        self.eventLaunchDate   = swiftyJason["launchDate"].stringValue
        self.eventClanID       = swiftyJason["clanId"].stringValue
        self.eventConsoleType  = swiftyJason["consoleType"].stringValue
        self.clanName          = swiftyJason["clanName"].stringValue
        
        if (swiftyJason["launchStatus"].string == EVENT_TIME_STATUS.UP_COMING.rawValue) {
            self.isFutureEvent = true
        }
        
        // Dictionary of Activities in an Event
        let activityDictionary = swiftyJason["eType"].dictionary
        if let activity = activityDictionary {
            let activityInfo = TRActivityInfo().parseAndCreateActivityObject(JSON(activity))
            
            //Event Activity added
            self.eventActivity = activityInfo
        }
        
        //Event Comments
        self.eventComments.removeAll()
        
        let comments = swiftyJason["comments"].arrayValue
        for commentInfo in comments {
            let commentObj = TRCommentInfo()
            commentObj.parseCommentInfo(commentInfo)
            
            self.eventComments.append(commentObj)
        }

        
        // Creating Creator Object from Events List
        let creatorDictionary = swiftyJason["creator"].dictionary
        if let creator = creatorDictionary {
            let creatorInfo = TRCreatorInfo()
            
            creatorInfo.playerID        = creator["_id"]?.stringValue
            creatorInfo.playerUserName  = creator["userName"]?.stringValue
            creatorInfo.playerDate      = creator["date"]?.stringValue
            creatorInfo.playerUdate     = creator["uDate"]?.stringValue
            creatorInfo.userVerified    = creator["verifyStatus"]?.stringValue
            creatorInfo.userVerified    = ACCOUNT_VERIFICATION.USER_VERIFIED.rawValue
            
            for consoles in creator["consoles"]!.arrayValue {
                let creatorConsole = TRConsoles()
                creatorConsole.consoleId = consoles["consoleId"].stringValue
                creatorConsole.consoleType = consoles["consoleType"].stringValue
                creatorConsole.verifyStatus = consoles["verifyStatus"].stringValue
                creatorConsole.isPrimary    = consoles["isPrimary"].bool
                creatorConsole.clanTag = consoles["clanTag"].stringValue
                
                
                if creatorConsole.isPrimary == true {
                    creatorInfo.playerPsnID = creatorConsole.consoleId
                }
                
                creatorInfo.playerConsoles.append(creatorConsole)
            }
            
            
            // Event Creator Added
            self.eventCreator = creatorInfo
        }
        
        // Delete players Array
        self.eventPlayersArray.removeAll()
        
        let playersArray = swiftyJason["players"].arrayValue
        for playerInfoObject in playersArray {
            let playerInfo = TRPlayerInfo()
            
            playerInfo.playerID         = playerInfoObject["_id"].stringValue
            playerInfo.playerUserName   = playerInfoObject["userName"].stringValue
            playerInfo.playerDate       = playerInfoObject["date"].stringValue
            playerInfo.playerUdate      = playerInfoObject["uDate"].stringValue
            playerInfo.playerImageUrl   = playerInfoObject["imageUrl"].stringValue
            playerInfo.commentsReported = playerInfoObject["commentsReported"].intValue
            playerInfo.invitedBy        = playerInfoObject["invitedBy"].stringValue
            playerInfo.isPlayerActive   = playerInfoObject["isActive"].boolValue
            playerInfo.verifyStatus     = playerInfoObject["verifyStatus"].stringValue
            playerInfo.isInvited     = playerInfoObject["isInvited"].boolValue
            playerInfo.hasReachedMaxReportedComments = playerInfoObject["hasReachedMaxReportedComments"].boolValue
            playerInfo.userVerified     = playerInfoObject["verifyStatus"].stringValue
            playerInfo.userVerified    = ACCOUNT_VERIFICATION.USER_VERIFIED.rawValue

            
            for consoles in playerInfoObject["consoles"].arrayValue {
                let playerConsole = TRConsoles()
                playerConsole.consoleId = consoles["consoleId"].stringValue
                playerConsole.consoleType = consoles["consoleType"].stringValue
                playerConsole.verifyStatus = consoles["verifyStatus"].stringValue
                playerConsole.isPrimary    = consoles["isPrimary"].bool
                playerConsole.clanTag = consoles["clanTag"].stringValue
                
                if playerConsole.isPrimary == true {
                    playerInfo.playerPsnID = playerConsole.consoleId
                }
                
                playerInfo.playerConsoles.append(playerConsole)
            }
            
            
            // Players of an Event Added
            self.eventPlayersArray.append(playerInfo)
        }
        
        return self
    }
 
    func eventFull () -> Bool {
        
        if self.eventPlayersArray.count < self.eventMaxPlayers?.integerValue {
            return false
        }
        
        return true
    }
    
    func isEventFull () throws -> Bool {
        
        if self.eventPlayersArray.count < self.eventMaxPlayers?.integerValue {
            return false
        }
        
        throw Branch_Error.MAXIMUM_PLAYERS_REACHED
    }
    
    func isEventGroupPartOfUsersGroups () throws -> Bool {
        
        let userHasGroup = TRApplicationManager.sharedInstance.bungieGroups.filter{$0.groupId == self.eventClanID}
        if let _ = userHasGroup.first {
            return false
        }
        
        throw Branch_Error.JOIN_BUNGIE_GROUP
    }
    
    func isEventConsoleMatchesUserConsole() throws -> Bool {
        
        if self.eventConsoleType == TRApplicationManager.sharedInstance.currentUser?.getDefaultConsole()?.consoleType {
            return false
        }
        
        throw Branch_Error.NEEDS_CONSOLE
    }
    
    func isUserPartOfEvent (userID: String) -> Bool {
     
        let playerExits = self.eventPlayersArray.filter{$0.playerID == userID}
        if playerExits.count > 0 {
            return true
        }
        
        return false
    }
}


