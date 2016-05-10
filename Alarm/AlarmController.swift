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
    weak var delegate: AlarmControllerDelegate? {
        didSet {
            guard let delegate = delegate,
                alarm = delegate.alarm else {return}
            observeAlarm(alarm)
        }
    }
    
    func observeAlarm(alarm: Alarm) {
        guard let delegate = delegate else {return}
        delegate.alarmSecondTick()
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(NSEC_PER_SEC*1)), dispatch_get_main_queue()) {
            self.observeAlarm(alarm)
        }
    }
}

protocol AlarmControllerDelegate: class {
    var alarm: Alarm? {get set}
    func alarmSecondTick()
}