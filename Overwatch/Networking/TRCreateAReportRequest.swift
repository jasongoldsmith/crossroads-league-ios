//
//  TRCreateAReportRequest.swift
//  Traveler
//
//  Created by Ashutosh on 3/31/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//


class TRCreateAReportRequest: TRRequest {
    
    func sendCreatedReport (reporterEmail: String, reportDetail: String, reportType: String, reporterID: String?, completion: TRValueCallBack) {
        
        let pushMessage = K.TRUrls.TR_BaseUrl + K.TRUrls.TR_SEND_REPORT
        var params = [String: AnyObject]()
        params["reportDetails"] = reportDetail
        params["reportType"] = reportType
        params["reporterEmail"] = reporterEmail
        if let _ = reporterID { params["reporter"] = reporterID }
        
        
        let request = TRRequest()
        request.params = params
        request.requestURL = pushMessage
        request.sendRequestWithCompletion { (error, swiftyJsonVar) -> () in
            
            if let _ = error {
                TRApplicationManager.sharedInstance.addErrorSubViewWithMessage("response error")
                completion(didSucceed: false)
                
                return
            }
            
            completion(didSucceed: true )
        }
    }
}