//
//  TRNavInteractionAnimator.swift
//  Traveler
//
//  Created by Ashutosh on 5/5/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation
import UIKit

class TRNavInteractionAnimator: UIPercentDrivenInteractiveTransition {

    
    // MARK: - Variables
    var navigationController: UINavigationController!
    var shouldCompleteTransition = false
    var transitionInProgress = false
    var completionSeed: CGFloat {
        return 1 - percentComplete
    }
    
    // MARK: - Helper Methods
    func attachToViewController(viewController: UIViewController) {
        navigationController = viewController.navigationController
        setupGestureRecognizer(viewController.view)
    }
    
    private func setupGestureRecognizer(view: UIView) {
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(TRNavInteractionAnimator.handlePanGesture(_:))))
    }
    
    // MARK: - Gesture
    func handlePanGesture(gestureRecognizer: UIPanGestureRecognizer) {
        let viewTranslation = gestureRecognizer.translationInView(gestureRecognizer.view!.superview!)
        switch gestureRecognizer.state {
        case .Began:
            transitionInProgress = true
            navigationController.popViewControllerAnimated(true)
        case .Changed:
            let const = CGFloat(fminf(fmaxf(Float(viewTranslation.y / 200.0), 0.0), 1.0))
            shouldCompleteTransition = const > 0.5
            updateInteractiveTransition(const)
        case .Cancelled, .Ended:
            transitionInProgress = false
            if !shouldCompleteTransition || gestureRecognizer.state == .Cancelled {
                cancelInteractiveTransition()
            } else {
                finishInteractiveTransition()
            }
        default:
            break
        }
    }

}