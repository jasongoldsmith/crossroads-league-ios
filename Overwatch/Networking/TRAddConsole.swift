//
//  TRAddConsole.swift
//  Traveler
//
//  Created by Ashutosh on 8/1/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation

class TRAddConsole: TRRequest {
    func addUpdateConsole (consoleId: String, consoleType: String, completion: TRValueCallBack) {
        let addConsoleURL = K.TRUrls.TR_BaseUrl + K.TRUrls.TR_ADD_CONSOLE
        
        let request = TRRequest()
        var params = [String: AnyObject]()
        
        params["consoleId"] = consoleId
        params["consoleType"] = consoleType
        request.params = params
        request.requestURL = addConsoleURL
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