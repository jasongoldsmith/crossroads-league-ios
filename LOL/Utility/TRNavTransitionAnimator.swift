//
//  TRCustomNavTransitionAnimator.swift
//  Traveler
//
//  Created by Ashutosh on 4/26/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation
import UIKit

class TRCustomNavTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let ANIMATION_DURATION = 0.35
    var reverse: Bool = false
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return ANIMATION_DURATION
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        
        transitionContext.containerView()!.addSubview(toViewController.view)
        
        if(reverse) {
            transitionContext.containerView()!.addSubview(fromViewController.view)
            fromViewController.view.frame = CGRectMake(0, 0, fromViewController.view.frame.size.width, fromViewController.view.frame.size.height)
            UIView.animateWithDuration(ANIMATION_DURATION, animations: {
                fromViewController.view.frame = CGRectMake(0, fromViewController.view.frame.size.height, fromViewController.view.frame.size.width, fromViewController.view.frame.size.height)
                }, completion: { (finished) in
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
            })
        } else {
            
            toViewController.view.alpha = 0.0
            UIView.animateWithDuration(ANIMATION_DURATION, animations: {
                toViewController.view.alpha = 1.0
                }, completion: { (finished) in
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
            })
        }
    }
    
}

