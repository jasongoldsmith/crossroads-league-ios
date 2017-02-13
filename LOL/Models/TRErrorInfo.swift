//
//  TRErrorInfo.swift
//  LOL
//
//  Created by Ashutosh on 2/13/17.
//  Copyright © 2017 Catalyst Foundry LLC. All rights reserved.
//

import Foundation
import SwiftyJSON

class TRErrorInfo: NSObject {
    
    var errorType    :String?
    var errorTitle   :String?
    var errorDescription: String?
    
    func parseErrorResponse (responseObject: JSON) -> TRErrorInfo {
        
        self.errorType = responseObject["type"].string
        
        if let descriptionDict = responseObject["details"].dictionary {
            self.errorTitle = descriptionDict["title"]?.string
            self.errorDescription = descriptionDict["message"]?.string
        }
        
        return self
    }
}