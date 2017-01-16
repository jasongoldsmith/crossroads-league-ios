//
//  TRPlayerInfo.swift
//  Traveler
//
//  Created by Ashutosh on 2/26/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation


class TRPlayerInfo: NSObject {

    var playerID            : String?
    var playerUserName      : String?
    var playerV             : String?
    var playerDate          : String?
    var playerPsnID         : String?
    var playerUdate         : String?
    var playerImageUrl      : String?
    var playerConsoles      : [TRConsoles] = []
    var userVerified        : String?
    var commentsReported    : Int?
    var invitedBy           : String?
    var isPlayerActive      : Bool?
    var hasReachedMaxReportedComments: Bool?
    var verifyStatus    :String?
    var isInvited       :Bool?
    
    
    func getDefaultConsole () -> TRConsoles? {
        let currentConsole = self.playerConsoles.filter{$0.isPrimary == true}
        
        if let _ = currentConsole.first {
            return currentConsole.first!
        }
        
        return nil
    }
}

