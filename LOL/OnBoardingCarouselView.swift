//
//  OnBoardingCarouselView.swift
//  Overwatch
//
//  Created by Marin, Jonathan on 3/8/17.
//  Copyright © 2017 Catalyst Foundry LLC. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

protocol OnBoardingCarouselViewDelegate {
    func showNext()
}

class OnBoardingCarouselView: UIView {
    @IBOutlet weak var backgroundCardImage: UIImageView!
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var imageWidth: NSLayoutConstraint!
    @IBOutlet weak var whiteViewBottom: NSLayoutConstraint!
    @IBOutlet weak var rightSpacing: NSLayoutConstraint!
    @IBOutlet weak var leftSpacing: NSLayoutConstraint!
    @IBOutlet weak var nextButton: UIButton!
    
    //Delegate
    var delegate: OnBoardingCarouselViewDelegate?
    
    func setViewWith(data: OnBoardingCard) {
        backgroundCardImage.image = data.backgroundImage.image
        mainImage.image = data.heroImage.image
        logoImageView.image = data.textImage.image
    }
    
    @IBAction func nextButtonPressed() {
        if let del = delegate {
            del.showNext()
        }
    }
}
