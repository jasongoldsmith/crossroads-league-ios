//
//  TRInvitationInfo.swift
//  Traveler
//
//  Created by Ashutosh on 10/18/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation

class TRInvitationInfo: NSObject {
    var eventID: String?
    var invitedPlayers: String?
    
    func createSignInInvitationPayLoad () -> NSDictionary {
        
        var invi = [String: AnyObject]()
        let playersArray : [String] = invitedPlayers!.componentsSeparatedByString(",")
        
        invi["eId"] = self.eventID
        invi["invitees"] = playersArray
        
        return invi
    }
}