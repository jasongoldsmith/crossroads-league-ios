//
//  TRAuthenticationRequest.swift
//  Traveler
//
//  Created by Rangarajan, Srivatsan on 2/22/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//


class TRAuthenticationRequest: TRRequest {
    
    
    //MARK:- CREATE ACCOUNT
    func registerTRUserWith(userData: TRUserInfo?,completion:TRValueCallBack)  {
        
        let registerUserUrl = K.TRUrls.TR_BaseUrl + K.TRUrls.TR_RegisterUrl
        
        if (userData == nil) {
            completion(didSucceed: false)
           
            return
        }
        
        var params = [String: AnyObject]()
        if userData?.userName?.characters.isEmpty == false {
            params["userName"] = userData?.userName
        }
        if userData?.password?.characters.isEmpty == false {
            params["passWord"] = userData?.password
        }
        if let bungieMembership = TRUserInfo.getBungieMembershipID() {
            params["bungieMemberShipId"] = bungieMembership
        }
        
        if let hasConsoleType = TRUserInfo.getConsoleType() where TRUserInfo.getConsoleID() != nil {

            var myConsoleDictArray: [[String:AnyObject]] = []
            var consoleInfo = [String: AnyObject]()
            consoleInfo["consoleType"] = hasConsoleType
            consoleInfo["consoleId"] = TRUserInfo.getConsoleID()
            
            myConsoleDictArray.append(consoleInfo)
            params["consoles"] = myConsoleDictArray
        }
        
        
        let request = TRRequest()
        request.params = params
        request.requestURL = registerUserUrl
        request.sendRequestWithCompletion { (error, responseObject) in
            
            if let _ = error {
                completion(didSucceed: false)
            }
            
            let userData = TRUserInfo()
            userData.parseUserResponse(responseObject)

            for console in userData.consoles {
                if console.isPrimary == true {
                    TRUserInfo.saveConsolesObject(console)
                }
            }
            
            TRUserInfo.saveUserData(userData)
            completion(didSucceed: true )
        }
    }
    
    //MARK:- LOGIN USER
    func loginTRUserWithSuccess(console: Dictionary<String, AnyObject>?, password: String?, completion:TRValueCallBack)  {
        
        let loginUserUrl = K.TRUrls.TR_BaseUrl + K.TRUrls.TR_LoginUrl
        var params = [String: AnyObject]()
        if let _ = console {
            params["consoles"] = console
        } else { return }
        
        if password?.characters.isEmpty == false {
            params["passWord"] = password
        } else { return }
        
        
        let request = TRRequest()
        request.params = params
        request.viewHandlesError = true
        request.requestURL = loginUserUrl
        request.sendRequestWithCompletion { (error, responseObject) in
            
            if let _ = error {
                completion(didSucceed: false)
                return
            }
            
            let userData = TRUserInfo()
            userData.parseUserResponse(responseObject)
            TRUserInfo.saveUserData(userData)
            
            for console in userData.consoles {
                if console.isPrimary == true {
                    TRUserInfo.saveConsolesObject(console)
                }
            }
            
            completion(didSucceed: true )
        }
    }

    
    func loginTRUserWith(console: Dictionary<String, AnyObject>?, password: String?, invitationDict: Dictionary<String, AnyObject>?, completion:TRResponseCallBack)  {
        
        let loginUserUrl = K.TRUrls.TR_BaseUrl + K.TRUrls.TR_LoginUrl
        var params = [String: AnyObject]()
        params["userName"] = console!["userName"]
        params["passWord"] = console!["passWord"]
        
        let request = TRRequest()
        request.params = params
        request.viewHandlesError = true
        request.requestURL = loginUserUrl
        request.sendRequestWithCompletion { (error, responseObject) in
            
            if let _ = error {
                completion(error: error, responseObject: nil)
                return
            }
            
            let userData = TRUserInfo()
            userData.parseUserResponse(responseObject)
            TRUserInfo.saveUserData(userData)
            
            completion(error: nil, responseObject: (responseObject))
        }
    }
    
    //MARK:- LOGOUT USER
    func logoutTRUser(completion:(Bool?) -> ())  {
        
        if (TRUserInfo.isUserLoggedIn() == false) {
            completion(false )
        }
        
        let logoutUserUrl = K.TRUrls.TR_BaseUrl + K.TRUrls.TR_LogoutUrl
        let request = TRRequest()
        request.requestURL = logoutUserUrl
        request.sendRequestWithCompletion { (error, responseObject) in
            
            if let _ = error {
                completion(false)
            }
            
            //Remove saved user data
            TRUserInfo.removeUserData()
            
            completion(true )
        }
    }
}
