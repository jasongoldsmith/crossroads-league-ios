//
//  TRDeepLinkObject.swift
//  Traveler
//
//  Created by Ashutosh on 8/26/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation
import SwiftyJSON


class TRDeepLinkObject: NSObject {
    
    var deepLinkString: String?
    var deepLinkKey: String?
    
    init(link: NSString) {
        
        super.init()
        
        let finalString = link.stringByReplacingOccurrencesOfString("dlcsrd://", withString: "")
        let trimmedString = finalString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        let parsedKeys = trimmedString.componentsSeparatedByString("/")
        
        if let _ = parsedKeys.first {
            self.deepLinkKey = parsedKeys.first
            self.deepLinkString = trimmedString.stringByReplacingOccurrencesOfString(self.deepLinkKey!, withString:"")
        }
    }

    
    func createLinkInfoAndPassToBackEnd () -> Dictionary <String, String>? {

        if let _ = self.deepLinkKey {
            let paramDict: [String: String] = [self.deepLinkKey! : self.deepLinkString!]
            return paramDict
        }
        
        return nil
    }
}