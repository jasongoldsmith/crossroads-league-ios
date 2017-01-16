//
//  Utility.swift
//  OnCueSwift
//
//  Created by Goldsmith, Jason on 6/25/15.
//

import Foundation

// Nice helper function for dispatch_after
func dispatch_after_delay(delay: NSTimeInterval, queue: dispatch_queue_t, block: dispatch_block_t) {
    let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC)))
    dispatch_after(time, queue, block)
}

func delay(delay:Double, closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
}

func isTimeDifferenceMoreThenAnHour(dateString: String) -> Bool {
  
    let formatter = NSDateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    
    if let eventDate = formatter.dateFromString(dateString) {
        eventDate.dateBySubtractingHours(1)
        
        if eventDate.isInFuture() {
            return true
        }
    }
    
    return false
}

func isTimeDifferenceMoreThenGivenMinutes(selectedDate: NSDate, minutes: Int) -> Bool {
    
    let dateByAddingMinutes = selectedDate.dateBySubtractingMinutes(minutes)
    if dateByAddingMinutes.isInFuture() {
        return true
    }

    return false
}

func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
    
    return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
}

func secondsToHoursMinutesSeconds (seconds : Int) -> String {
    
    let (h, m, s) = secondsToHoursMinutesSeconds(seconds)
    
    let formatter = NSNumberFormatter()
    formatter.minimumIntegerDigits = 2
    
    let hours = formatter.stringFromNumber(h) //"00"
    let minutes = formatter.stringFromNumber(m) //"01"
    let seconds = formatter.stringFromNumber(s) //"10"
    
    if (hours != "00"){
        return "\(hours!):\(minutes!):\(seconds!)"
    } else{
        return "\(minutes!):\(seconds!)"
    }
}

func trDateFormat () -> String {
    return "MMM d 'at' h:mm a"
}

func weekDayDateFormat () -> String {
    return "EEEE 'at' h:mm a"
}

