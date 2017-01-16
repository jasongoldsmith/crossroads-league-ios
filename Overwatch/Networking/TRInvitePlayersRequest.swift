//
//  TRInvitePlayersRequest.swift
//  Traveler
//
//  Created by Ashutosh on 10/13/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation


class TRInvitePlayersRequest: TRRequest {
    func invitePlayers (eventID: String, invitedPlayers: [String], invitationLink: String, completion: TRResponseCallBack) {
        let reportURL = K.TRUrls.TR_BaseUrl + K.TRUrls.TR_INVITE_PLAYER
        
        let request = TRRequest()
        request.requestURL = reportURL
        
        var params = [String: AnyObject]()
        params["eId"] = eventID
        params["invitees"] = invitedPlayers
        params["invitationLink"] = invitationLink
        request.params = params
        
        request.sendRequestWithCompletion { (error, swiftyJsonVar) -> () in
            
            if let _ = error {
                completion(error: error, responseObject: nil)
                return
            }
            
            
            completion(error: nil, responseObject: (swiftyJsonVar))
        }
    }
}