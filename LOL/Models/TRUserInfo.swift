//
//  TRUserInfo.swift
//  Traveler
//
//  Created by Rangarajan, Srivatsan on 2/21/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation
import SwiftyJSON

class TRUserInfo: NSObject {
    
    var verifyStatus    :String?
    var userName        :String?
    var password        :String?
    var userID          :String?
    var userImageURL    :String?
    var userClanID      :String?
    var psnID           :String?
    var legalInfo       :TRLegalInfo?
    var consoles        :[TRConsoles] = []
    var bungieMemberShipID: String?
    var userVerified  : String?
    var commentsReported: Int?
    var hasReachedMaxReportedComments: Bool?
    var isInvited : Bool?
    
    
    func parseUserResponse (responseObject: JSON) {
        self.userName       = responseObject["value"]["userName"].stringValue
        self.userID         = responseObject["value"]["_id"].stringValue
        self.userImageURL   = responseObject["value"]["imageUrl"].stringValue
        self.userClanID     = responseObject["value"]["clanId"].stringValue
        self.bungieMemberShipID = responseObject["value"]["bungieMemberShipId"].stringValue
        self.userVerified     = responseObject["value"]["verifyStatus"].stringValue
        self.commentsReported = responseObject["value"]["commentsReported"].intValue
        self.hasReachedMaxReportedComments = responseObject["value"]["hasReachedMaxReportedComments"].boolValue
        self.isInvited    = responseObject["value"]["isInvited"].boolValue
        
        // Legal Info
        if let legalDict = responseObject["value"]["legal"].dictionary {
            let legalObject = TRLegalInfo()
            legalObject.parseLegalObjectDictionary(JSON(legalDict))
            self.legalInfo = legalObject
        }
        
        //Console Info
        let consoles = responseObject["value"]["consoles"].arrayValue
        for consoleObj in consoles {
            let console = TRConsoles()
            console.consoleId = consoleObj["consoleId"].stringValue
            console.consoleType = consoleObj["consoleType"].stringValue
            console.verifyStatus = consoleObj["verifyStatus"].stringValue
            console.isPrimary    = consoleObj["isPrimary"].bool
            console.unverDisplayClanTag = consoleObj["clanTag"].stringValue
            console.clanTag = consoleObj["clanTag"].stringValue
            console.region = consoleObj["region"].stringValue
            console.gamePlayerLevel = consoleObj["gamePlayerLevel"].intValue
            
            //Save user console in NSUserDefaults if this is the current console
            if console.isPrimary == true && self.userID == TRUserInfo.getUserID() {
                TRUserInfo.saveConsolesObject(console)
            }
            
            self.consoles.append(console)
        }
    }
    
    //Some lagacy code... :(
    func parseUserResponseWithOutValueKey (responseObject: JSON) {
        self.userName       = responseObject["userName"].stringValue
        self.userID         = responseObject["_id"].stringValue
        self.userImageURL   = responseObject["imageUrl"].stringValue
        self.userClanID     = responseObject["clanId"].stringValue
        self.bungieMemberShipID = responseObject["bungieMemberShipId"].stringValue
        self.userVerified     = responseObject["verifyStatus"].stringValue
        self.commentsReported = responseObject["commentsReported"].intValue
        self.hasReachedMaxReportedComments = responseObject["value"]["hasReachedMaxReportedComments"].boolValue
        self.isInvited    = responseObject["isInvited"].boolValue
        
        // Legal Info
        if let legalDict = responseObject["legal"].dictionary {
            let legalObject = TRLegalInfo()
            legalObject.parseLegalObjectDictionary(JSON(legalDict))
            self.legalInfo = legalObject
        }
        
        //Console Info
        let consoles = responseObject["consoles"].arrayValue
        for consoleObj in consoles {
            let console = TRConsoles()
            console.consoleId = consoleObj["consoleId"].stringValue
            console.consoleType = consoleObj["consoleType"].stringValue
            console.verifyStatus = consoleObj["verifyStatus"].stringValue
            console.isPrimary    = consoleObj["isPrimary"].bool
            console.clanTag      = consoleObj["clanTag"].stringValue
            console.unverDisplayClanTag = consoleObj["clanTag"].stringValue
            console.clanTag = consoleObj["clanTag"].stringValue
            console.region = consoleObj["region"].stringValue
            console.gamePlayerLevel = consoleObj["gamePlayerLevel"].intValue

            
            //Save user console in NSUserDefaults if this is the current console
            if console.isPrimary == true && self.userID == TRUserInfo.getUserID() {
                TRUserInfo.saveConsolesObject(console)
            }
            
            self.consoles.append(console)
        }
    }
    
    func getDefaultConsole () -> TRConsoles? {
        let currentConsole = self.consoles.filter{$0.isPrimary == true}
        
        if let _ = currentConsole.first {
            return currentConsole.first!
        }
        
        return nil
    }
    
    
    
    
    
    
    
    
    
    
    
    
    // User Defaults
    
    class func saveConsolesObject (consoleObj: TRConsoles) {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setValue(consoleObj.consoleId, forKey: K.UserDefaultKey.UserAccountInfo.TR_USER_CONSOLE_ID)
        userDefaults.setValue(consoleObj.consoleType  , forKeyPath: K.UserDefaultKey.UserAccountInfo.TR_USER_CONSOLE_TYPE)
        userDefaults.setValue(consoleObj.verifyStatus  , forKeyPath: K.UserDefaultKey.UserAccountInfo.TR_CONSOLE_VERIFIED)
    }
    
    class func saveUserData (userData:TRUserInfo?) {
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setValue(userData?.userName, forKey: K.UserDefaultKey.UserAccountInfo.TR_UserName)
        userDefaults.setValue(userData?.userImageURL  , forKeyPath: K.UserDefaultKey.UserAccountInfo.TR_USER_IMAGE)
        userDefaults.setValue(userData?.userClanID  , forKeyPath: K.UserDefaultKey.UserAccountInfo.TR_USER_CLAN_ID)
        userDefaults.setValue(userData?.userID, forKeyPath: K.UserDefaultKey.UserAccountInfo.TR_UserID)
        userDefaults.setValue(userData?.bungieMemberShipID, forKeyPath: K.UserDefaultKey.UserAccountInfo.TR_USER_BUNGIE_MEMBERSHIP_ID)
        
        userDefaults.synchronize()
        
        TRApplicationManager.sharedInstance.currentUser = userData
    }
    
    
    class func isCurrentUserEventCreator (event: TREventInfo) -> Bool {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if (userDefaults.objectForKey(K.UserDefaultKey.UserAccountInfo.TR_UserID)?.string == event.eventCreator?.playerID)  {
            return true
        }
        
        return false
    }
    
    class func isUserLoggedIn () -> Bool {
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if (userDefaults.objectForKey(K.UserDefaultKey.UserAccountInfo.TR_UserPwd) != nil) {
            let userID = userDefaults.objectForKey(K.UserDefaultKey.UserAccountInfo.TR_UserPwd) as? String
            if let _ = userID {
                return true
            }
        }

        return false
    }
    
    class func getUserName() -> String? {
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if (userDefaults.objectForKey(K.UserDefaultKey.UserAccountInfo.TR_UserName) != nil) {
                let userName = userDefaults.objectForKey(K.UserDefaultKey.UserAccountInfo.TR_UserName) as! String
                return userName
        }
        return nil
    }

    class func getUserID() -> String? {
        let userDefaults = NSUserDefaults.standardUserDefaults()
            if (userDefaults.objectForKey(K.UserDefaultKey.UserAccountInfo.TR_UserID) != nil) {
            let userID = userDefaults.objectForKey(K.UserDefaultKey.UserAccountInfo.TR_UserID) as! String
                
            return userID
        }
        
        return nil
    }

    class func getUserImageString() -> String? {
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if (userDefaults.objectForKey(K.UserDefaultKey.UserAccountInfo.TR_USER_IMAGE) != nil) {
            let userImageUrl = userDefaults.objectForKey(K.UserDefaultKey.UserAccountInfo.TR_USER_IMAGE) as! String
            
            return userImageUrl
        }
        
        let currentUser = TRApplicationManager.sharedInstance.getPlayerObjectForCurrentUser()
        guard let currentUserImage = currentUser?.playerImageUrl else {
            return nil
        }
        
        return currentUserImage
    }

    class func setUserImageString (imageURL: String) {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setValue(imageURL  , forKeyPath: K.UserDefaultKey.UserAccountInfo.TR_USER_IMAGE)
        userDefaults.synchronize()
    }
    
    class func getUserClanID () -> String? {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if (userDefaults.objectForKey(K.UserDefaultKey.UserAccountInfo.TR_USER_CLAN_ID) != nil) {
            let userClanID = userDefaults.objectForKey(K.UserDefaultKey.UserAccountInfo.TR_USER_CLAN_ID) as! String
            
            return userClanID
        }
        
        return nil
    }

    // Is Verified
    class func isUserVerified () -> String? {
        
        return ACCOUNT_VERIFICATION.USER_VERIFIED.rawValue
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        if let verification = userDefaults.objectForKey(K.UserDefaultKey.UserAccountInfo.TR_CONSOLE_VERIFIED) as? String {
            return verification
        }

        return nil
    }

    
    // ************************************//
    // ************************************//
    // ************************************//
    // These are saved from Bungie User Authentication response. Used as params for SignUp flow. Singup response sends an array of Console (Array) Objects
    // whete this data is finally saved. A person can have multiple consoles, hence an array.
    
    
    //CONSOLE ID is the user's xbox gamertag or playstation ID
    class func saveConsoleID (bungieAccount: String) {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setValue(bungieAccount , forKeyPath: K.UserDefaultKey.UserAccountInfo.TR_USER_CONSOLE_ID)
        
        
        //Hardcoding it here, since user verification has begun
        userDefaults.setValue(ACCOUNT_VERIFICATION.USER_VER_INITIATED.rawValue, forKeyPath: K.UserDefaultKey.UserAccountInfo.TR_CONSOLE_VERIFIED)
        
        userDefaults.synchronize()
    }
    
    class func getConsoleID() -> String? {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if (userDefaults.objectForKey(K.UserDefaultKey.UserAccountInfo.TR_USER_CONSOLE_ID) != nil) {
            return userDefaults.objectForKey(K.UserDefaultKey.UserAccountInfo.TR_USER_CONSOLE_ID) as? String
        }
        
        return nil
    }
    
    // BUNGIE MEMBER_SHIP ID
    class func saveBungieMemberShipId (memberShipID: String) {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setValue(memberShipID , forKeyPath: K.UserDefaultKey.UserAccountInfo.TR_USER_BUNGIE_MEMBERSHIP_ID)
        userDefaults.synchronize()
    }
    
    class func getBungieMembershipID () -> String? {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if (userDefaults.objectForKey(K.UserDefaultKey.UserAccountInfo.TR_USER_BUNGIE_MEMBERSHIP_ID) != nil) {
            return userDefaults.objectForKey(K.UserDefaultKey.UserAccountInfo.TR_USER_BUNGIE_MEMBERSHIP_ID) as? String
        }
        
        return nil
    }
    
    // CONSOLE TYPE
    class func saveConsoleType (consoleType: String) {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setValue(consoleType , forKeyPath: K.UserDefaultKey.UserAccountInfo.TR_USER_CONSOLE_TYPE)
        userDefaults.synchronize()
    }
    
    class func getConsoleType () -> String? {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if (userDefaults.objectForKey(K.UserDefaultKey.UserAccountInfo.TR_USER_CONSOLE_TYPE) != nil) {
            return userDefaults.objectForKey(K.UserDefaultKey.UserAccountInfo.TR_USER_CONSOLE_TYPE) as? String
        }
        
        return nil
    }
    
    class func removeUserData () {
        
        NSUserDefaults.standardUserDefaults().removeObjectForKey(K.UserDefaultKey.UserAccountInfo.TR_UserPwd)
        NSUserDefaults.standardUserDefaults().removeObjectForKey(K.UserDefaultKey.UserAccountInfo.TR_USER_CONSOLE_REGION)
        NSUserDefaults.standardUserDefaults().removeObjectForKey(K.UserDefaultKey.UserAccountInfo.TR_USER_CONSOLE_ID)
        NSUserDefaults.standardUserDefaults().removeObjectForKey(K.UserDefaultKey.UserAccountInfo.TR_USER_CONSOLE_TYPE)
        NSUserDefaults.standardUserDefaults().removeObjectForKey(K.UserDefaultKey.UserAccountInfo.TR_CONSOLE_VERIFIED)
        NSUserDefaults.standardUserDefaults().removeObjectForKey(K.UserDefaultKey.UserAccountInfo.TR_UserName)
        NSUserDefaults.standardUserDefaults().removeObjectForKey(K.UserDefaultKey.UserAccountInfo.TR_USER_IMAGE)
        NSUserDefaults.standardUserDefaults().removeObjectForKey(K.UserDefaultKey.UserAccountInfo.TR_USER_CLAN_ID)
        NSUserDefaults.standardUserDefaults().removeObjectForKey(K.UserDefaultKey.UserAccountInfo.TR_UserID)
        NSUserDefaults.standardUserDefaults().removeObjectForKey(K.UserDefaultKey.UserAccountInfo.TR_USER_BUNGIE_MEMBERSHIP_ID)
        
        
        let cookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        guard let cookies = cookieStorage.cookies else {
            //Cookie Not Found
            return
        }
        
        for cookie in cookies {
            cookieStorage.deleteCookie(cookie)
        }
    }
}


