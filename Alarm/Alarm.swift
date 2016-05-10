//
//  Alarm.swift
//  Alarm
//
//  Created by James Pacheco on 5/6/16.
//  Copyright © 2016 DevMountain. All rights reserved.
//

import Foundation

class Alarm: NSObject, NSCoding {
    private let kFireTimeFromMidnight = "fireTimeFromMidnight"
    private let kName = "name"
    private let kEnabled = "enabled"
    
    var fireTimeFromMidnight: NSTimeInterval
    var name: String
    var enabled: Bool
    var dictionaryCopy: [String: AnyObject] {
        return [kFireTimeFromMidnight: fireTimeFromMidnight, kName: name, kEnabled: enabled]
    }
    
    var fireDate: NSDate? {
        guard let thisMorningAtMidnight = DateHelper.thisMorningAtMidnight,
            tomorrowMorningAtMidnight = DateHelper.tomorrowMorningAtMidnight else {return nil}
        let fireDateFromThisMorning = NSDate(timeInterval: fireTimeFromMidnight, sinceDate: thisMorningAtMidnight)
        let fireDateFromTomorrowMorning = NSDate(timeInterval: fireTimeFromMidnight, sinceDate: tomorrowMorningAtMidnight)
        if fireDateFromThisMorning.compare(NSDate()) == .OrderedAscending {
            return fireDateFromTomorrowMorning
        } else {
            return fireDateFromThisMorning
        }
    }
    
    var fireTimeAsString: String {
        let fireTimeFromMidnight = Int(self.fireTimeFromMidnight)
        let hours = fireTimeFromMidnight/60/60
        let minutes = (fireTimeFromMidnight - (hours*60*60))/60
        if hours >= 13 {
            return String(format: "%02d:%02d PM", arguments: [hours - 12, minutes])
        } else if hours >= 12 {
            return String(format: "%02d:%02d PM", arguments: [hours, minutes])
        } else {
            return String(format: "%02d:%02d AM", arguments: [hours, minutes])
        }
    }
    
    init(fireTimeFromMidnight: NSTimeInterval, name: String, enabled: Bool = true) {
        self.fireTimeFromMidnight = fireTimeFromMidnight
        self.name = name
        self.enabled = enabled
    }
    
    init?(dictionary: [String: AnyObject]) {
        guard let fireTimeFromMidnight = dictionary[kFireTimeFromMidnight] as? NSTimeInterval,
            name = dictionary[kName] as? String,
            enabled = dictionary[kEnabled] as? Bool else {return nil}
        self.fireTimeFromMidnight = fireTimeFromMidnight
        self.name = name
        self.enabled = enabled
    }
    
    required init?(coder aDecoder: NSCoder) {
        guard let fireTimeFromMidnight = aDecoder.decodeObjectForKey(kFireTimeFromMidnight) as? NSTimeInterval,
            name = aDecoder.decodeObjectForKey(kName) as? String,
            enabled = aDecoder.decodeObjectForKey(kEnabled) as? Bool else {return nil}
        self.fireTimeFromMidnight = fireTimeFromMidnight
        self.name = name
        self.enabled = enabled
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(fireTimeFromMidnight, forKey: kFireTimeFromMidnight)
        aCoder.encodeObject(name, forKey: kName)
        aCoder.encodeObject(enabled, forKey: kEnabled)
    }

}

func ==(lhs: Alarm, rhs: Alarm) -> Bool {
    return lhs.fireTimeFromMidnight == rhs.fireTimeFromMidnight
}