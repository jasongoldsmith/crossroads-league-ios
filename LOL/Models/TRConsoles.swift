//
//  TRConsoles.swift
//  Traveler
//
//  Created by Ashutosh on 6/3/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation

struct ConsoleTypes {
    static let PS4      = "PS4"
    static let PS3      = "PS3"
    static let XBOX360  = "XBOX360"
    static let XBOXONE  = "XBOXONE"
}

class TRConsoles {
    var consoleId: String?
    var consoleType: String?
    var verifyStatus: String?
    var isPrimary: Bool?
    var clanTag: String?
    var unverDisplayClanTag: String?
    

    func saveConsolesObject (consoleObj: TRConsoles) {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setValue(consoleObj.consoleId, forKey: K.UserDefaultKey.UserAccountInfo.TR_USER_CONSOLE_ID)
        userDefaults.setValue(consoleObj.consoleType  , forKeyPath: K.UserDefaultKey.UserAccountInfo.TR_USER_CONSOLE_TYPE)
        userDefaults.setValue(consoleObj.verifyStatus  , forKeyPath: K.UserDefaultKey.UserAccountInfo.TR_CONSOLE_VERIFIED)
    }
    
    class func getConsoleID () -> String? {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if (userDefaults.objectForKey(K.UserDefaultKey.UserAccountInfo.TR_USER_CONSOLE_ID) != nil) {
            return userDefaults.objectForKey(K.UserDefaultKey.UserAccountInfo.TR_USER_CONSOLE_ID) as? String
        }
        
        return nil
    }
    
    class func getConsoleType () -> String? {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if (userDefaults.objectForKey(K.UserDefaultKey.UserAccountInfo.TR_USER_CONSOLE_TYPE) != nil) {
            return userDefaults.objectForKey(K.UserDefaultKey.UserAccountInfo.TR_USER_CONSOLE_TYPE) as? String
        }
        
        return nil
    }

    class func getConsoleVerifyStatus () -> String? {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if (userDefaults.objectForKey(K.UserDefaultKey.UserAccountInfo.TR_CONSOLE_VERIFIED) != nil) {
            return userDefaults.objectForKey(K.UserDefaultKey.UserAccountInfo.TR_CONSOLE_VERIFIED) as? String
        }
        
        return nil
    }
    
    //Is Console Latest
    func isPlayStationConsoleLatest () -> Bool {
        if self.consoleType == ConsoleTypes.PS4 {
            return true
        }
        
        return false
    }
    
    func isXBoxConsoleLatest () -> Bool {
        if self.consoleType == ConsoleTypes.XBOXONE {
            return true
        }
        
        return false
    }
}

