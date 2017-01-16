//
//  TRChangeConsoleRequest.swift
//  Traveler
//
//  Created by Ashutosh on 8/2/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation


class TRChangeConsoleRequest: TRRequest {
    
    func changeConsole (consoleType: String, completion: TRValueCallBack) {
        let changeConsoleURL = K.TRUrls.TR_BaseUrl + K.TRUrls.TR_CHANGE_CONSOLE
        
        let request = TRRequest()
        var params = [String: AnyObject]()
        
        params["consoleType"] = consoleType
        request.params = params
        request.requestURL = changeConsoleURL
        request.sendRequestWithCompletion { (error, swiftyJsonVar) -> () in
            
            if let _ = error {
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