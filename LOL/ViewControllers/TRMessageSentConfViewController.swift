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
    var message: String?
    var titleMessage: String?
    var hyperLink: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let _ = self.titleMessage {
            self.titleLabel.text = self.titleMessage
        }
        
        if let _ = self.message {
            self.bodyLabel.text = self.message
            self.bodyLabel?.activeLinkAttributes
            let subscriptionNoticeLinkAttributes = [
                NSForegroundColorAttributeName: UIColor(red: 198/255, green: 127/255, blue: 6/255, alpha: 1),
                NSUnderlineStyleAttributeName: NSNumber(bool:true),
                ]
            
            let nsString = self.message! as NSString
            var emailID = ""
            if let _ = self.hyperLink {
                emailID = self.hyperLink!
            }
            
            let emailIDRange = nsString.rangeOfString(emailID)
            self.bodyLabel?.linkAttributes = subscriptionNoticeLinkAttributes
            self.bodyLabel?.addLinkToURL(NSURL(string:""), withRange: emailIDRange)
        }
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