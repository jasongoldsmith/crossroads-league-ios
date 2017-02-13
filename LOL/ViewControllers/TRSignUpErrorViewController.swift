//
//  TRSignUpErrorViewController.swift
//  LOL
//
//  Created by Ashutosh on 2/10/17.
//  Copyright © 2017 Catalyst Foundry LLC. All rights reserved.
//

import Foundation

class TRSignUpErrorViewController: TRBaseViewController {
 
    var userNameString: String?
    var descriptionString: String?
    var errorTitleString: String?
    
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var descriptionLabel: TRInsertLabel!
    @IBOutlet weak var errorTitleLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideNavigationBar()
        
        self.overlayView?.layer.cornerRadius = 2.0
        
        if let _ = self.userNameString {
            self.userNameLabel?.text = userNameString
        }
        
        if let _ = self.errorTitleString {
            self.errorTitleLabel?.text = self.errorTitleString
        }
        
        if let _ = self.descriptionString {
            self.descriptionLabel?.text = self.descriptionString
            self.descriptionLabel?.topInset = -100.0
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