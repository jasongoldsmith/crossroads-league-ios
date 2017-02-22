//
//  TRBranchManager.swift
//  Traveler
//
//  Created by Ashutosh on 7/13/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation
import Branch
import SwiftyJSON

//typealias ErrorTypeCallBack = (errorType: Branch_Error?) -> ()

class TRBranchManager {
    
    let canonicalIdentifier = "canonicalIdentifier"
    var branchUniversalObject = BranchUniversalObject()
    let canonicalUrl = "https://dev.branch.io/getting-started/deep-link-routing/guide/ios/"
    let contentTitle = "contentTitle"
    let contentDescription = "My Content Description"
    let imageUrl = "https://pbs.twimg.com/profile_images/658759610220703744/IO1HUADP.png"
    let feature = "Sharing Feature"
    let channel = "Distribution Channel"
    let desktop_url = "http://branch.io"
    let ios_url = "https://lpqx.app.link/dChAh0OdqA"
    let shareText = "Super amazing thing I want to share"
    let user_id1 = "abe@emailaddress.io"
    let user_id2 = "ben@emailaddress.io"
    let live_key = "key_live_aewf85hEEfgHtJtKby8xRhpoAClJir2W"
    let test_key = "key_test_boEa60lxzlpPqICMmw4yFjpnArdQkr9K"
    
    func createLinkWithBranch (eventInfo: TREventInfo, deepLinkType: String, callback: callbackWithUrl) {
        
        var extraPlayersRequiredCount: Int = 0
        guard let eventID = eventInfo.eventID else {
            return
        }

        guard let maxPlayers = eventInfo.eventActivity?.activityMaxPlayers?.integerValue else {
            return
        }
        
        extraPlayersRequiredCount = maxPlayers - eventInfo.eventPlayersArray.count
        var playerCount: String = ""
        if extraPlayersRequiredCount > 0 {
            playerCount = String(extraPlayersRequiredCount)
        }
        
        var activityName = ""
        var groupName = ""
        var checkPoint = ""
        
        //Formatted Date
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let eventDate = formatter.dateFromString(eventInfo.eventLaunchDate!)
        let formatedDate = eventDate!.toString(format: .Custom(trDateFormat()))

        if let currentGroupID = TRUserInfo.getUserClanID() {
            if let hasCurrentGroup = TRApplicationManager.sharedInstance.getCurrentGroup(currentGroupID) {
                groupName = hasCurrentGroup.groupName!
            }
        }
        
        //Activity Name
        if let aName = eventInfo.eventActivity?.activityType {
            activityName = aName
        }
        
        //Checkpoint 
        if let chPoint = eventInfo.eventActivity?.activityCheckPoint {
            checkPoint =  ", " + chPoint
        }
        
        // Create Branch Object
        branchUniversalObject = BranchUniversalObject.init(canonicalIdentifier: canonicalIdentifier)
        var messageString = "\(groupName): I need \(playerCount) more for \(activityName)\(checkPoint)"
        
        if !TRApplicationManager.sharedInstance.isCurrentPlayerInAnEvent(eventInfo) {
            branchUniversalObject.title = "Join My Team"
            if eventInfo.eventPlayersArray.count == eventInfo.eventMaxPlayers!.integerValue {
                branchUniversalObject.title = eventInfo.eventActivity?.activitySubType
            }
            
            messageString = "\(groupName): I need \(playerCount) more for \(activityName)\(checkPoint)"
        } else {
            branchUniversalObject.title = "Searching for Summoners"
            if eventInfo.eventPlayersArray.count == eventInfo.eventMaxPlayers!.integerValue {
                branchUniversalObject.title = eventInfo.eventActivity?.activitySubType
            }
            
            messageString = "\(groupName): I need \(extraPlayersRequiredCount) more for \(activityName)\(checkPoint)"
            
            if eventInfo.isFutureEvent == true {
                messageString = "\(groupName): I need \(playerCount) more for \(activityName)\(checkPoint) on \(formatedDate)"
            }
        }
        
        if extraPlayersRequiredCount == 0 {
            branchUniversalObject.title = eventInfo.eventActivity?.activitySubType
            if eventInfo.isFutureEvent == true {
                messageString = "\(groupName): Check out this \(activityName)\(checkPoint), on \(formatedDate)"
            } else {
                messageString = "\(groupName): Check out this \(activityName)\(checkPoint)"
            }
        }
        
        branchUniversalObject.contentDescription = messageString
        
        if let hasActivityCard = eventInfo.eventActivity?.activityID {
            let imageString = "http://w3.crossroadsapp.co.s3-website-us-west-1.amazonaws.com/lol/share/branch/v1/\(hasActivityCard)"
            branchUniversalObject.imageUrl  = imageString
        } else {
            branchUniversalObject.imageUrl  = "http://w3.crossroadsapp.co.s3-website-us-west-1.amazonaws.com/lol/share/branch/v1/default.png"
        }

        branchUniversalObject.addMetadataKey("eventId", value: eventID)
        branchUniversalObject.addMetadataKey("deepLinkType", value: deepLinkType)
        branchUniversalObject.addMetadataKey("activityName", value: (eventInfo.eventActivity?.activityType)!)
        
        // Create Link
        let linkProperties = BranchLinkProperties()
        branchUniversalObject.getShortUrlWithLinkProperties(linkProperties) { (url, error) in
            if (error == nil) {
                print(url)
                callback(url, nil)
                
            } else {
                print(String(format: "Branch TestBed: %@", error!))
            }
        }
    }
    
    
    func createInvitationLinkWithBranch (eventInfo: TREventInfo, playerArray: [String], deepLinkType: String, callback: callbackWithUrl) {
        
        guard let eventID = eventInfo.eventID else {
            return
        }

        let arrayString = playerArray.joinWithSeparator(",")
        branchUniversalObject = BranchUniversalObject.init(canonicalIdentifier: canonicalIdentifier)
        branchUniversalObject.addMetadataKey("eventId", value: eventID)
        branchUniversalObject.addMetadataKey("deepLinkType", value: deepLinkType)
        branchUniversalObject.addMetadataKey("invitees", value: arrayString)
        branchUniversalObject.addMetadataKey("activityName", value: (eventInfo.eventActivity?.activitySubType)!)
        
        
        // Create Link
        let linkProperties = BranchLinkProperties()
        branchUniversalObject.getShortUrlWithLinkProperties(linkProperties) { (url, error) in
            if (error == nil) {
                print(url)
                callback(url, nil)
                
            } else {
                print(String(format: "Branch TestBed: %@", error!))
            }
        }
    }
}

