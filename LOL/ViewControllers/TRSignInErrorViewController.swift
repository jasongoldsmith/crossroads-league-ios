//
//  TRSignInErrorViewController.swift
//  Traveler
//
//  Created by Ashutosh on 9/14/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation
import MessageUI
import TTTAttributedLabel


class TRSignInErrorViewController: TRBaseViewController, TTTAttributedLabelDelegate, MFMailComposeViewControllerDelegate {
    
    var userName: String?
    var signInError: String?
    
    @IBOutlet weak var supportText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideNavigationBar()
        
        if let _ = self.signInError {
            self.supportText?.text = self.signInError
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }

    @IBAction func openContactUs () {
        let storyboard : UIStoryboard = UIStoryboard(name: K.StoryBoard.StoryBoard_Main, bundle: nil)
        let vc : TRSendReportViewController = storyboard.instantiateViewControllerWithIdentifier(K.VIEWCONTROLLER_IDENTIFIERS.VIEW_CONTROLLER_SEND_REPORT) as! TRSendReportViewController

        self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func closeView () {
        self.navigationController?.popViewControllerAnimated(true)
    }

    deinit {
        
    }
}