//
//  TRCreateEventFinalView.swift
//  Traveler
//
//  Created by Ashutosh on 8/8/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation
import SlideMenuControllerSwift

class TRCreateEventFinalView: TRBaseViewController, TRDatePickerProtocol, UITableViewDataSource, UITableViewDelegate  {
    
    
    @IBOutlet weak var activityBGImageView: UIImageView!
    @IBOutlet weak var activityIconView: UIImageView!
    @IBOutlet weak var activityNameLabel: UILabel!
    @IBOutlet weak var activityLevelLabel: UILabel!
    @IBOutlet weak var checkPointDropDownTriangle: UIImageView!
    @IBOutlet weak var tagDropDownTriangle: UIImageView!
    
    // SubViews
    @IBOutlet weak var activitNameView: UIView!
    @IBOutlet weak var activitCheckPointView: UIView!
    @IBOutlet weak var activitStartTimeView: UIView!
    @IBOutlet weak var activitDetailsView: UIView!
    @IBOutlet weak var activityNameViewsIcon: UIImageView!
    
    // View Button
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var activityNameButton: UIButton!
    @IBOutlet weak var activityCheckPointButton: UIButton!
    @IBOutlet weak var activityStartTimeButton: UIButton!
    @IBOutlet weak var activityDetailButton: UIButton!
    @IBOutlet weak var addActivityButton: UIButton!
    
    //Constaint outlets
    @IBOutlet weak var activityCheckPointHeightConst: NSLayoutConstraint!
    @IBOutlet weak var activityCheckPointTopConst: NSLayoutConstraint!
    @IBOutlet weak var addButtonTopTopConst: NSLayoutConstraint!
    
    //Activities of same sub-typeJ
    var selectedActivity: TRActivityInfo?
    lazy var activityInfo: [TRActivityInfo] = []
    
    // Contains Unique Activities Based on SubType/ Difficulty
    var filteredActivitiesOfSubTypeAndDifficulty: [TRActivityInfo] = []
    
    // Contains Unique Activities Based on SubType/ Difficulty
    var filteredCheckPoints: [TRActivityInfo] = []

    // Filtered Tags
    var filteredTags: [TRActivityInfo] = []
    
    var showGropName: Bool = false
    var showCheckPoint: Bool = false
    var showDetail: Bool = false
    
    //Table View
    @IBOutlet weak var dropDownTableView: UITableView!
    var dataArray: [TRActivityInfo] = []
    
    //Date Picker
    var datePickerView: TRDatePicker?
    
    var keys:[String] = []
    @IBOutlet weak var searchScrollView: UIScrollView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.addModifiersView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //Hide Navigation
        self.hideNavigationBar()
        
        // Adding Corner Radius to Views
        self.activitNameView.layer.cornerRadius = 2.0
        self.activitDetailsView.layer.cornerRadius = 2.0
        self.activitStartTimeView.layer.cornerRadius = 2.0
        self.activitCheckPointView.layer.cornerRadius = 2.0
        
        
        //Add Date Picker
        self.datePickerView = NSBundle.mainBundle().loadNibNamed("TRDatePicker", owner: self, options: nil)[0] as? TRDatePicker
        self.datePickerView?.frame = self.view.bounds
        self.datePickerView?.delegate = self
        
        
        //Filtered Arrays
        self.filteredActivitiesOfSubTypeAndDifficulty = self.getFiletreObjOfSubTypeAndDifficulty()!

        //DropDownTable
        self.dropDownTableView.hidden = true
        self.dropDownTableView.layer.borderWidth = 3.0
        self.dropDownTableView.layer.cornerRadius = 2.0
        self.dropDownTableView.layer.borderColor = UIColor(red: 189/255, green: 178/255, blue: 129/255, alpha: 1).CGColor
        
        self.activityDetailButton.setTitle("Details (Optional)", forState: .Normal)
        
        // Update View
        if let _ = self.selectedActivity {
            self.updateViewWithActivity(self.selectedActivity!)
        } else {
            if let _ = self.filteredActivitiesOfSubTypeAndDifficulty.first {
                self.updateViewWithActivity(self.filteredActivitiesOfSubTypeAndDifficulty.first!)
            }
        }
    }
    
    //MARK: - Refresh View
    func updateViewWithActivity (activityInfo: TRActivityInfo) {
        
        //Set Selected Activity
        self.selectedActivity = activityInfo
        
        // Update View
        if let activityType = activityInfo.activityType {
            
            let activityNameArray = componentsSeparatedByString(activityType)
            if let _ = activityNameArray where activityNameArray?.count > 1 {
                self.activityNameLabel.text = activityNameArray![1].uppercaseString
            } else {
                self.activityNameLabel.text = activityType.uppercaseString
            }
        }
        
        if let level = activityInfo.activityLevel where level != "0" {
            let activityLavelString: String = "\(level) "
            let stringFontAttribute = [NSFontAttributeName: UIFont(name: "HelveticaNeue", size: 12)!]
            let levelAttributedStr = NSAttributedString(string: activityLavelString, attributes: stringFontAttribute)
            let finalString: NSMutableAttributedString = levelAttributedStr.mutableCopy() as! NSMutableAttributedString
            
            if let activityLight = activityInfo.activityLight  where Int(activityLight) > 0 {
                let activityAttrString = NSMutableAttributedString(string: "Recommended Light: ")
                let activityColorString = NSMutableAttributedString(string: "\u{02726}\(activityLight)")
                activityColorString.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 255/255, green: 198/255, blue: 0/255, alpha: 1) , range: NSMakeRange(0, activityColorString.length))
                
                activityAttrString.appendAttributedString(activityColorString)
                finalString.appendAttributedString(activityAttrString)
            } else {
                if let location = activityInfo.activitylocation?.aSubLocation where location != "" {
                    let locationString = NSAttributedString(string: location, attributes: stringFontAttribute)
                    finalString.appendAttributedString(locationString)
                }
                
            }
            
            self.activityLevelLabel.attributedText = finalString
        } else {
            if let _ = activityInfo.activityDescription {
                self.activityLevelLabel.text = activityInfo.activityDescription!
            }
        }
        
        if let _ = activityInfo.activityIconImage {
            let imageUrl = NSURL(string: activityInfo.activityIconImage!)
            self.activityIconView.sd_setImageWithURL(imageUrl)
        }
        
        if let imageURL = activityInfo.activityImage where imageURL != "" {
            self.activityBGImageView.sd_setImageWithURL(NSURL(string: imageURL), placeholderImage: UIImage(named: "imgBGVaultOfGlass"), completed: {
                (image, error, cacheType, url) in
                
                self.activityBGImageView.alpha = 0
                UIView.animateWithDuration(0.5, animations: {
                    self.activityBGImageView.alpha = 1
                })
            })
        }
        
        if let aType = activityInfo.activityType {
            var nameString = aType
            
            if let aSubType =  activityInfo.activitySubType where aSubType != "" {
                nameString = "\(nameString) - \(aSubType)"
            }
            if let aDifficulty = activityInfo.activityDificulty where aDifficulty != "" {
                nameString = "\(nameString) - \(aDifficulty)"
            }
            
            self.activityNameButton.setTitle(nameString, forState: .Normal)
        }
        
        if let aCheckPoint = activityInfo.activityCheckPoint where aCheckPoint != "" {
            self.activityCheckPointButton.setTitle(aCheckPoint, forState: .Normal)
            self.activityCheckPointHeightConst.constant = 50
            self.activityCheckPointTopConst.constant = 10
            self.addButtonTopTopConst.constant = 49
        } else {
            self.activityCheckPointHeightConst.constant = 0
            self.activityCheckPointTopConst.constant = 0
            self.addButtonTopTopConst.constant = 120
        }
        
        self.filteredTags = self.getActivitiesFilteredSubDifficultyCheckPoint(self.selectedActivity!)!
        if let fTags = self.getActivitiesFilteredSubDifficultyCheckPoint(self.selectedActivity!) where fTags.count > 1 {
            self.tagDropDownTriangle.hidden = false
        } else {
            self.tagDropDownTriangle.hidden = true
        }
        
        if let description = activityInfo.activityTag where description != "" {
            self.activityDetailButton.setTitle(description, forState: .Normal)
        } else {
            self.activityDetailButton.setTitle("Details (Optional)", forState: .Normal)
        }
        
        //ModifierView
        self.addModifiersView()
        self.view.bringSubviewToFront(self.dropDownTableView)
        
        //Show hide CheckPoint dropdown triangle
        let checkPoint = TRApplicationManager.sharedInstance.getActivitiesMatchingSubTypeAndLevel(self.selectedActivity!)
        if let _ = checkPoint where checkPoint?.count > 1 {
            self.checkPointDropDownTriangle.hidden = false
        } else {
            self.checkPointDropDownTriangle.hidden = true
        }
    }
    
    //MARK: - Protocol Methods
    func closeDatePicker() {
        if let selectedTime = self.datePickerView?.datePicker.date {
            self.activityStartTimeButton?.setTitle("Start Time - " + selectedTime.toString(format: .Custom(trDateFormat())), forState: .Normal)
        } else {
            self.activityStartTimeButton?.setTitle("Start Time - Now", forState: .Normal)
        }
    }
    
    //MARK: - Button Actions
    @IBAction func showDatePicker (sender: UIButton) {
        
        guard let _ = self.datePickerView else {
            return
        }
        
        self.datePickerView?.alpha = 0
        UIView.animateWithDuration(0.4) { () -> Void in
            self.datePickerView?.alpha = 1
        }
        
        self.datePickerView?.delegate = self
        self.view.addSubview(self.datePickerView!)
    }
    
    @IBAction func showActivityName (sender: UIButton) {
        
        self.dataArray.removeAll()
        if self.filteredActivitiesOfSubTypeAndDifficulty.count <= 1 {
            return
        }
        
        if self.dropDownTableView?.hidden == false {
            self.closeDropDown()
            self.showGropName = false
            
            return
        }
        
        self.showGropName = true
        self.dataArray = self.filteredActivitiesOfSubTypeAndDifficulty.sort{$0.activitySubType < $1.activitySubType}
        let itemToDelete = self.dataArray.filter{$0.activityDificulty == self.selectedActivity?.activityDificulty && $0.activitySubType == self.selectedActivity?.activitySubType}.first
        if let _ = itemToDelete {
            let index = self.dataArray.indexOf(itemToDelete!)
            self.dataArray.removeAtIndex(index!)
        }
        
        self.dropDownTableView?.hidden = false
        self.dropDownTableView?.reloadData()
        self.updateTableViewFrame(self.activitNameView)
    }
    
    
    @IBAction func showCheckPoints (sender: UIButton) {
        
        self.dataArray.removeAll()
        self.filteredCheckPoints = TRApplicationManager.sharedInstance.getActivitiesMatchingSubTypeAndLevel(self.selectedActivity!)!

        if self.filteredCheckPoints.count <= 1 {
            return
        }
        
        if self.dropDownTableView?.hidden == false {
            
            self.closeDropDown()
            self.showCheckPoint = false
            
            return
        }
        
        self.showCheckPoint = true
        self.dataArray = self.filteredCheckPoints.sort{$0.activityCheckPoint < $1.activityCheckPoint}

        let itemToDelete = self.dataArray.filter{$0.activityCheckPoint == self.selectedActivity?.activityCheckPoint}.first
        if let _ = itemToDelete {
            let index = self.dataArray.indexOf(itemToDelete!)
            self.dataArray.removeAtIndex(index!)
        }


        self.dropDownTableView?.hidden = false
        self.dropDownTableView?.reloadData()
        self.updateTableViewFrame(self.activitCheckPointView)
    }
    
    @IBAction func showDetail (sender: UIButton) {
        self.dataArray.removeAll()
        self.filteredTags = self.getActivitiesFilteredSubDifficultyCheckPoint(self.selectedActivity!)!
        
        if self.filteredTags.count <= 1 {
            return
        }
        
        if self.dropDownTableView?.hidden == false {
            self.closeDropDown()
            self.showDetail = false
            
            return
        }
        
        self.showDetail = true
        self.dataArray = self.filteredTags.sort{$0.activityTag < $1.activityTag}
        
//        let itemToDelete = self.dataArray.filter{$0.activitySubType == self.selectedActivity?.activitySubType && $0.activityDificulty == self.selectedActivity?.activityDificulty && $0.activityCheckPoint == self.selectedActivity?.activityCheckPoint}.first
//        if let _ = itemToDelete {
//            let index = self.dataArray.indexOf(itemToDelete!)
//            self.dataArray.removeAtIndex(index!)
//        }
        
        self.dropDownTableView?.hidden = false
        self.dropDownTableView?.reloadData()
        self.updateTableViewFrame(self.activitDetailsView)
    }
    
    @IBAction func addActivityButtonClicked (sender: UIButton) {
        guard let _ = self.selectedActivity else {
            return
        }
        
        let _ = TRCreateEventRequest().createAnEventWithActivity(self.selectedActivity!, selectedTime: self.datePickerView?.datePicker.date) { (event) -> () in
            
            self.datePickerView?.delegate = nil
            
            if let eventInfo = event {
                
                let storyboard : UIStoryboard = UIStoryboard(name: K.StoryBoard.StoryBoard_Main, bundle: nil)
                
                let vc : TREventDetailViewController = storyboard.instantiateViewControllerWithIdentifier(K.VIEWCONTROLLER_IDENTIFIERS.VIEW_CONTROLLER_EVENT_DESCRIPTION) as! TREventDetailViewController
                vc.eventInfo = eventInfo

                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                self.appManager.log.debug("Create Event Failed")
            }
        }
    }
    
    @IBAction func cancelButtonPressed (sender: UIButton) {
        self.datePickerView?.delegate = nil
        self.dismissViewController(true) { (didDismiss) in
            
        }
    }

    @IBAction func backButtonPressed (sender: UIButton) {
        self.datePickerView?.delegate = nil
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    
    func getFiletreObjOfSubTypeAndDifficulty () -> [TRActivityInfo]? {
        
        var filteredArray: [TRActivityInfo] = []
        for (_, activity) in self.activityInfo.enumerate() {
            if (self.activityInfo.count < 1) {
                filteredArray.append(activity)
            } else {
                let activityArray = filteredArray.filter {$0.activityDificulty == activity.activityDificulty && $0.activitySubType == activity.activitySubType}
                if (activityArray.count == 0) {
                    filteredArray.append(activity)
                }
            }
        }
        
        return filteredArray
    }
    
    //MARK:- Table Delegate Methods
    func updateTableViewFrame (sender: UIView) {
    
        var originY: CGFloat = 0.0
        var maxHeight: CGFloat = 0.0
        
        if sender.frame.origin.y > 420 {
            maxHeight = self.view.frame.size.height + sender.frame.origin.y
        } else {
            maxHeight = self.view.frame.size.height - sender.frame.origin.y + sender.frame.size.height - self.addActivityButton.frame.size.height - 100
        }
        
        var height = CGFloat((self.dropDownTableView?.numberOfSections)! * 47)
        height = height > maxHeight ? maxHeight : height
        
        if sender.frame.origin.y > 420 {
            originY = sender.frame.origin.y - height + 2
        } else {
            originY = sender.frame.origin.y + sender.frame.size.height - 2
        }
        
  
        self.dropDownTableView.frame = CGRectMake(sender.frame.origin.x, originY, sender.frame.size.width,  height)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clearColor()
        
        return headerView
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 3.0
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.dataArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("dropDownCell")
        let activityInfo = self.dataArray[indexPath.section]
       
        if self.showGropName == true {
            if let aType = activityInfo.activityType {
                var nameString = aType
                
                if let aSubType =  activityInfo.activitySubType where aSubType != "" {
                    nameString = "\(aSubType)"
                }
                if let aDifficulty = activityInfo.activityDificulty where aDifficulty != "" {
                    nameString = "\(nameString) - \(aDifficulty)"
                }
                
                cell!.textLabel!.text = nameString
            }
        } else if self.showCheckPoint == true {
            cell!.textLabel!.text = activityInfo.activityCheckPoint!
        } else {
            cell!.textLabel!.text = activityInfo.activityTag!
            if activityInfo.activityTag! == "" {
                cell!.textLabel!.text = "(none)"
            }
        }
        
        return cell!
    }
    
    func closeDropDown () {
        self.dataArray.removeAll()
        self.dropDownTableView.reloadData()
        self.dropDownTableView.hidden = true
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section < self.dataArray.count {
            
            self.showCheckPoint = self.showCheckPoint == true ? false : false
            self.showGropName = self.showGropName == true ? false : false
            self.showDetail = self.showDetail == true ? false : false
            
            self.updateViewWithActivity(self.dataArray[indexPath.section])
            self.closeDropDown()
        }
    }
    
    func getActivitiesFilteredSubDifficultyCheckPoint (activity: TRActivityInfo) -> [TRActivityInfo]? {
        let activityArray = self.activityInfo.filter {$0.activitySubType == activity.activitySubType && $0.activityDificulty == activity.activityDificulty && $0.activityCheckPoint == activity.activityCheckPoint
        }
        return activityArray
    }
    
    //MARK:- Bounded Box Labels
    func addModifiersView () {
        
        var mofifiersArray: [String] = []
        
        if self.selectedActivity?.activityModifiers.count > 0 {
            for modifiers in (self.selectedActivity?.activityModifiers)! {
                mofifiersArray.append(modifiers.aModifierName!)
            }
            
            for bonus in (self.selectedActivity?.activityBonus)! {
                mofifiersArray.append(bonus.aBonusName!)
            }
        } else {
            if let hasCheckPoint = self.selectedActivity?.activityCheckPoint where hasCheckPoint != ""{
                mofifiersArray.append(hasCheckPoint)
            }
        }


        self.keys.removeAll()
        self.keys = mofifiersArray
        self.reloadButtons()
    }
    
    
    
    private func reloadButtons() {
        for button in self.searchScrollView.subviews {
            button.removeFromSuperview()
        }
        var previousRect = CGRectZero
        var initialPointInRow = CGPointZero
        var found = false
        for i in 0 ..< keys.count {
            let key = keys[i]
            let giphyButton = UIButton()
            giphyButton.layer.borderColor = UIColor.whiteColor().CGColor
            giphyButton.layer.borderWidth = 1.0
            giphyButton.titleLabel!.font =  UIFont(name: "HelveticaNeue", size: 10)
            giphyButton.setTitle(key.uppercaseString, forState: .Normal)
            let newRect = calculateNewFrame(previousRect, keyToDisplay: key.uppercaseString)
            if newRect.origin.y != initialPointInRow.y {
                //another row
                let remainingSpace = (self.searchScrollView.frame.size.width - (previousRect.origin.x + previousRect.size.width))/2
                for button in self.searchScrollView.subviews {
                    if button.frame.origin.y == initialPointInRow.y && !found {
                        button.frame = CGRectMake(button.frame.origin.x+remainingSpace, button.frame.origin.y, button.frame.size.width, button.frame.size.height)
                    }
                }
                found = true
                initialPointInRow = newRect.origin
            } else {
                found = false
            }
            previousRect = newRect
            giphyButton.frame = previousRect
            giphyButton.tag = i
            self.searchScrollView.addSubview(giphyButton)
            self.searchScrollView.contentSize = CGSizeMake(self.searchScrollView.frame.size.width, previousRect.origin.y+previousRect.size.height)
            if i == keys.count-1 {
                let remainingSpace = (self.searchScrollView.frame.size.width - (giphyButton.frame.origin.x + giphyButton.frame.size.width))/2
                for button in self.searchScrollView.subviews {
                    if button.frame.origin.y == giphyButton.frame.origin.y {
                        button.frame = CGRectMake(button.frame.origin.x+remainingSpace, button.frame.origin.y, button.frame.size.width, button.frame.size.height)
                    }
                }
            }
        }
    }
    
    private func calculateNewFrame(previousRect:CGRect, keyToDisplay:String) -> CGRect {
        let rect:CGRect = "\(keyToDisplay)".boundingRectWithSize(CGSizeMake(self.searchScrollView.frame.size.width, 0), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: UIFont(name: "HelveticaNeue", size: 10)!], context: nil)
        let requiredSpaceForKey = rect.size.width + 20
        var initialPoint = previousRect.origin.x + previousRect.size.width
        if initialPoint != 0.0 {
            initialPoint += 8.0
        }
        if initialPoint + requiredSpaceForKey < self.searchScrollView.frame.size.width {
            return CGRectMake(initialPoint, previousRect.origin.y, requiredSpaceForKey, 22)
        } else {
            if requiredSpaceForKey < self.searchScrollView.frame.size.width {
                return CGRectMake(0, previousRect.origin.y+previousRect.size.height+8, requiredSpaceForKey, 22)
            } else {
                return CGRectMake(0, previousRect.origin.y+previousRect.size.height+8, self.searchScrollView.frame.size.width, 22)
            }
        }
    }


    deinit {
        
    }
}