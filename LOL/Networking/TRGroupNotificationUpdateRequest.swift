//
//  TRGroupNotificationUpdateRequest.swift
//  Traveler
//
//  Created by Ashutosh on 6/22/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation


class TRGroupNotificationUpdateRequest: TRRequest {
    
    func updateUserGroupNotification (groupID: String, muteNoti: Bool, completion: TRValueCallBack) {
        let updateGroupNoti = K.TRUrls.TR_BaseUrl + K.TRUrls.TR_GROUP_NOTI_VALUE
        var params = [String: AnyObject]()
        params["groupId"] = groupID
        params["muteNotification"] = muteNoti == true ? "true" : "false"
        
        
        
        let request = TRRequest()
        request.params = params
        request.requestURL = updateGroupNoti
        request.sendRequestWithCompletion { (error, swiftyJsonVar) -> () in
            
            if let _ = error {
                TRApplicationManager.sharedInstance.addErrorSubViewWithMessage("response error")
                completion(didSucceed: false)
                
                return
            }

            //Update the Noti Value for the group whose ID matches with the existing Bungie Group List
            let hasGroupID = swiftyJsonVar["groupId"].stringValue
            let notiValue = swiftyJsonVar["muteNotification"].boolValue
            let bungieGroup = TRBungieGroupInfo()
            bungieGroup.updateNotificationMuteValueForGroupWithID(hasGroupID, notiValue: notiValue)
            
            completion(didSucceed: true )
        }
    }
}