//
//  TRLegalViewController.swift
//  Traveler
//
//  Created by Ashutosh on 5/20/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation
import UIKit

class TRLegalViewController: TRBaseViewController, TRWebViewProtocol {
    
    var linkToOpen: NSURL?
    var webLegalWebView: TRWebView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.webLegalWebView = NSBundle.mainBundle().loadNibNamed("TRWebView", owner: self, options: nil)[0] as? TRWebView
        self.webLegalWebView!.frame = self.view.frame
        self.view.addSubview(self.webLegalWebView!)

        //Set Delegate
        self.webLegalWebView!.delegate = self
        
        guard let _ = self.linkToOpen else {
            self.dismissViewController(true, dismissed: { (didDismiss) in
                
            })
            
            return
        }
        
        //Add link to open
        self.webLegalWebView!.loadUrl(self.linkToOpen!)
    }

    
    func backButtonPressed(sender: UIButton) {
        
        self.webLegalWebView!.delegate = nil
        self.dismissViewController(true) { (didDismiss) in
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidLoad()
    }
    
    deinit {
        
    }
}