//
//  TRWebView.swift
//  Traveler
//
//  Created by Ashutosh on 5/19/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation
import UIKit


protocol TRWebViewProtocol {
    func backButtonPressed(sender: UIButton)
}

class TRWebView: UIView, UIWebViewDelegate {
    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var backButton: UIButton!
    var delegate: TRWebViewProtocol?
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    @IBAction func backButtonPressed (sender: UIButton) {
        delegate?.backButtonPressed(sender)
    }
    
    func loadUrl (url: NSURL) {
        self.webView.loadRequest(NSURLRequest.init(URL: url))
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
     
        print("shouldStartLoadWithRequest: \(request)")
        return true
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        print("webViewDidStartLoad: \(webView.request)")
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        
    }
}
