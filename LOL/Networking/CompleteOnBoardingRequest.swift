//
//  CompleteOnBoardingRequest.swift
//  LOL
//
//  Created by Marin, Jonathan on 4/3/17.
//  Copyright © 2017 Catalyst Foundry LLC. All rights reserved.
//

import Foundation

class CompleteOnBoardingRequest: TRRequest {
    
    class func updateCompleteOnBoarding() {
        let completeOnBoarding = K.TRUrls.TR_BaseUrl + K.TRUrls.TR_ONBOARDING_COMPLETE
        let request = TRRequest()
        request.requestURL = completeOnBoarding
        request.URLMethod = .POST
        request.sendRequestWithCompletion { (error, swiftyJsonVar) -> () in
            if let theError = error {
                print(theError)
            } else {
                print("Onboarding Cool")
            }
        }
    }

}
