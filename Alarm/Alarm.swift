//
//  Alarm.swift
//  Alarm
//
//  Created by James Pacheco on 5/6/16.
//  Copyright © 2016 DevMountain. All rights reserved.
//

import Foundation

class Alarm {
    var fireTimeFromMidnight: NSTimeInterval
    var name: String
    var enabled: Bool
    
    private var calendar: NSCalendar {
        return NSCalendar.currentCalendar()
    }
    
    private var thisMorningAtMidnight: NSDate? {
        let components = calendar.components([.Month, .Day, .Year], fromDate: NSDate())
        components.second = 0
        components.minute = 0
        components.hour = 0
        components.nanosecond = 0
        return calendar.dateFromComponents(components)
    }
    
    private var tomorrowMorningAtMidnight: NSDate? {
        let components = calendar.components([.Month, .Day, .Year], fromDate: NSDate())
        components.second = 0
        components.minute = 0
        components.hour = 0
        components.nanosecond = 0
        return NSDate(timeInterval: 24*60*60, sinceDate: calendar.dateFromComponents(components) ?? NSDate())
    }
    
    var fireDate: NSDate? {
        guard let thisMorningAtMidnight = thisMorningAtMidnight,
            tomorrowMorningAtMidnight = tomorrowMorningAtMidnight where enabled else {return nil}
        let fireDateFromThisMorning = NSDate(timeInterval: fireTimeFromMidnight, sinceDate: thisMorningAtMidnight)
        let fireDateFromTomorrowMorning = NSDate(timeInterval: fireTimeFromMidnight, sinceDate: tomorrowMorningAtMidnight)
        if fireDateFromThisMorning.compare(NSDate()) == .OrderedAscending {
            return fireDateFromTomorrowMorning
        } else {
            return fireDateFromTomorrowMorning
        }
    }
    
    init(fireTimeFromMidnight: NSTimeInterval, name: String, enabled: Bool = false) {
        self.fireTimeFromMidnight = fireTimeFromMidnight
        self.name = name
        self.enabled = enabled
    }
}