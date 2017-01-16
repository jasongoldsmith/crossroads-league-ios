//
//  TRReportComment.swift
//  Traveler
//
//  Created by Ashutosh on 9/27/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation


class TRReportComment: TRRequest {
    
    func reportAComment (commentID: String, eventID: String, reportDetail: String?, reportedEmail: String?, completion: TRValueCallBack) {
        let reportURL = K.TRUrls.TR_BaseUrl + K.TRUrls.TR_REPORT_COMMENT
        
        let request = TRRequest()
        request.requestURL = reportURL
        
        var params = [String: AnyObject]()
        params["eId"] = eventID
        params["commentId"] = commentID
        
        if let _ = reportDetail, let _ = reportedEmail {
            var issueDict = [String: AnyObject]()
            issueDict["reportDetails"] = reportDetail
            issueDict["reporterEmail"] = reportedEmail
            
            params["formDetails"] = issueDict
        }
        
        request.params = params
        
        request.sendRequestWithCompletion { (error, swiftyJsonVar) -> () in
            
            if let _ = error {
                completion(didSucceed: false)
                
                return
            }
            
            completion(didSucceed: true )
        }
    }
}