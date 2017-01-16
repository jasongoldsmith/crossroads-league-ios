//
//  TRCommentInfo.swift
//  Traveler
//
//  Created by Ashutosh on 8/17/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation
import SwiftyJSON

class TRCommentInfo: NSObject {
    
    var commentUserInfo: TRUserInfo?
    var commentText: String?
    var commentId: String?
    var commentCreated: String?
    var commentReported: Bool?
    
    
    func parseCommentInfo (commentInfo: JSON) {

        if let hasUserInfo = commentInfo["user"].dictionary {
            self.commentUserInfo = TRUserInfo()
            self.commentUserInfo!.parseUserResponseWithOutValueKey(JSON(hasUserInfo))
        }
        
        self.commentText = commentInfo["text"].stringValue
        self.commentId = commentInfo["_id"].stringValue
        self.commentCreated = commentInfo["created"].stringValue
        self.commentReported = commentInfo["isReported"].boolValue
    }
}