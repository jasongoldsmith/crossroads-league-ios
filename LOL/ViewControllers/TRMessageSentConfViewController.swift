//
//  TRMessageSentConfViewController.swift
//  Traveler
//
//  Created by Ashutosh on 9/15/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation
import TTTAttributedLabel


class TRMessageSentConfViewController: TRBaseViewController {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: TTTAttributedLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let messageText = "Thank you! Your message has been sent to support@crossroadsapp.co and we will email you if we need additional details."
        self.titleLabel.text = "MESSAGE SENT"
        self.bodyLabel.text = messageText
        self.bodyLabel?.activeLinkAttributes
        let subscriptionNoticeLinkAttributes = [
            NSForegroundColorAttributeName: UIColor(red: 198/255, green: 127/255, blue: 6/255, alpha: 1),
            NSUnderlineStyleAttributeName: NSNumber(bool:true),
            ]
        
        let nsString = messageText as NSString
        let emailID = "support@crossroadsapp.co"
        let emailIDRange = nsString.rangeOfString(emailID)
        self.bodyLabel?.linkAttributes = subscriptionNoticeLinkAttributes
        self.bodyLabel?.addLinkToURL(NSURL(string:""), withRange: emailIDRange)
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