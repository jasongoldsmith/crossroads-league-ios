//
//  TRMessageSentConfViewController.swift
//  Traveler
//
//  Created by Ashutosh on 9/15/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation

class TRMessageSentConfViewController: TRBaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func closeMessageSentConfirmation () {
        self.dismissViewController(true) { (didDismiss) in
            
        }
    }
    
    deinit {
        
    }
}