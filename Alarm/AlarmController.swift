//
//  AlarmController.swift
//  Alarm
//
//  Created by James Pacheco on 5/9/16.
//  Copyright © 2016 DevMountain. All rights reserved.
//

import Foundation

class AlarmController {
    
    static let sharedInstance = AlarmController()
    
    var alarms: [Alarm] = []
    
    func deleteAlarm(alarm: Alarm) {
        guard let index = alarms.indexOf(alarm) else {return}
        alarms.removeAtIndex(index)
    }
    
    func addAlarm(fireTimeFromMidnight: NSTimeInterval, name: String) -> Alarm {
        let alarm = Alarm(fireTimeFromMidnight: fireTimeFromMidnight, name: name)
        alarms.append(alarm)
        return alarm
    }
    
    func updateAlarm(alarm: Alarm, fireTimeFromMidnight: NSTimeInterval, name: String) {
        alarm.fireTimeFromMidnight = fireTimeFromMidnight
        alarm.name = name
    }
    
    func alarmEnabledValueShouldChange(alarm: Alarm) {
        alarm.enabled = !alarm.enabled
    }
}
