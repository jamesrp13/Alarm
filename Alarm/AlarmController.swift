//
//  AlarmController.swift
//  Alarm
//
//  Created by James Pacheco on 5/9/16.
//  Copyright © 2016 DevMountain. All rights reserved.
//

import Foundation
import UIKit

class AlarmController {
    
    static let sharedInstance = AlarmController()
    private let kAlarms = "alarms"
    var alarms: [Alarm] = []
    
    init() {
        loadFromPersistentStore()
    }
    
    func addAlarm(fireTimeFromMidnight: NSTimeInterval, name: String) -> Alarm {
        let alarm = Alarm(fireTimeFromMidnight: fireTimeFromMidnight, name: name)
        alarms.append(alarm)
        saveToPersistentStore()
        return alarm
    }
    
    func updateAlarm(alarm: Alarm, fireTimeFromMidnight: NSTimeInterval, name: String) {
        alarm.fireTimeFromMidnight = fireTimeFromMidnight
        alarm.name = name
        saveToPersistentStore()
    }
    
    func deleteAlarm(alarm: Alarm) {
        guard let index = alarms.indexOf(alarm) else {return}
        alarms.removeAtIndex(index)
        saveToPersistentStore()
    }
    
    func toggleEnabled(alarm: Alarm) {
        alarm.enabled = !alarm.enabled
        saveToPersistentStore()
    }
    
    func saveToPersistentStore() {
        NSKeyedArchiver.archiveRootObject(alarms, toFile: filePath(kAlarms))
    }
    
    func loadFromPersistentStore() {
        guard let alarms = NSKeyedUnarchiver.unarchiveObjectWithFile(filePath(kAlarms)) as? [Alarm] else {return}
        self.alarms = alarms
    }
    
    func filePath(key: String) -> String {
        let directorySearchResults = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory,NSSearchPathDomainMask.AllDomainsMask, true)
        let documentsPath: AnyObject = directorySearchResults[0]
        let entriesPath = documentsPath.stringByAppendingString("/\(key).plist")
        
        return entriesPath
    }
    
}

protocol AlarmScheduler {
    func scheduleLocalNotification(alarm: Alarm)
    func cancelLocalNotification(alarm: Alarm)
}

extension AlarmScheduler {
    func scheduleLocalNotification(alarm: Alarm) {
        let localNotification = UILocalNotification()
        localNotification.alertBody = "Time's up!"
        localNotification.alertTitle = "Time's up!"
        localNotification.category = alarm.uuid
        localNotification.fireDate = alarm.fireDate
        localNotification.repeatInterval = .Day
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
    }
    
    func cancelLocalNotification(alarm: Alarm) {
        guard let localNotifications = UIApplication.sharedApplication().scheduledLocalNotifications else {return}
        for notification in localNotifications {
            if notification.category == alarm.uuid {
                UIApplication.sharedApplication().cancelLocalNotification(notification)
            }
        }
    }
}
