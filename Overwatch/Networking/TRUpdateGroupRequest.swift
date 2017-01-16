//
//  TRUpdateGroupRequest.swift
//  Traveler
//
//  Created by Ashutosh on 5/19/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation

class TRUpdateGroupRequest: TRRequest {
    
    func updateUserGroup (groupID: String, groupName: String, groupImage: String, completion: TRValueCallBack) {
        let updateGroupUrl = K.TRUrls.TR_BaseUrl + K.TRUrls.TR_UPDATE_GROUPS
        var params = [String: AnyObject]()
        params["id"] = TRUserInfo.getUserID()
        params["clanId"] = groupID
        params["clanName"] = groupName
        params["clanImageUrl"] = groupImage
        
        let request = TRRequest()
        request.params = params
        request.requestURL = updateGroupUrl
        request.sendRequestWithCompletion { (error, swiftyJsonVar) -> () in
            
            if let _ = error {
                TRApplicationManager.sharedInstance.addErrorSubViewWithMessage("response error")
                completion(didSucceed: false)
                
                return
            }
            
            let userData = TRUserInfo()
            userData.parseUserResponse(swiftyJsonVar)
            
            for console in userData.consoles {
                if console.isPrimary == true {
                    TRUserInfo.saveConsolesObject(console)
                }
            }
            
            TRUserInfo.saveUserData(userData)

            completion(didSucceed: true )
        }
    }
}
