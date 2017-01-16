//
//  TREventActivityCardCell.swift
//  Traveler
//
//  Created by Ashutosh on 7/26/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation

class TREventActivityCardCell: UITableViewCell {
    
    var activityInfo: TRActivityInfo?
    
    @IBOutlet weak var cellBackgroundImageView: UIImageView!
    @IBOutlet weak var cellActivityIconImageView: UIImageView!
    @IBOutlet weak var cellActivityNameLabel: UILabel!
    @IBOutlet weak var cellActivityCheckPointLabel: UILabel!
    @IBOutlet weak var cellActivityAddButton: EventButton!
    
    override func prepareForReuse() {
        
        super.prepareForReuse()
        
        self.cellBackgroundImageView.image = nil
        self.cellActivityIconImageView.image = nil
        self.cellActivityNameLabel.text = nil
        self.cellActivityCheckPointLabel.text = nil
        self.cellActivityAddButton?.buttonActivityInfo = nil
    }
    
    func loadCellView () {
        
        guard let _ = self.activityInfo else {
            return
        }
        
        if let hasBGImage = self.activityInfo?.activityAdCard?.adCardImageURL where activityInfo?.activityAdCard?.adCardBaseUrl != "" {
            let imageString = (self.activityInfo?.activityAdCard?.adCardBaseUrl!)! + hasBGImage
            let imageURL = NSURL(string: imageString)
            self.cellBackgroundImageView.sd_setImageWithURL(imageURL, placeholderImage: UIImage(named: "addCardDefault"))
        }

        if let iconImageString = self.activityInfo?.activityIconImage {
            let imageURL = NSURL(string: iconImageString)
            self.cellActivityIconImageView.sd_setImageWithURL(imageURL, placeholderImage: UIImage(named: "iconGhostDefault"))
        }
        
        self.cellActivityNameLabel.text = self.activityInfo?.activityAdCard?.adCardCardHeader
        self.cellActivityCheckPointLabel.text = self.activityInfo?.activityAdCard?.adCardSubHeader
    }
}
