//
//  AlarmDetailTableViewController.swift
//  Alarm
//
//  Created by James Pacheco on 5/6/16.
//  Copyright © 2016 DevMountain. All rights reserved.
//

import UIKit

class AlarmDetailTableViewController: UITableViewController {

    @IBOutlet weak var alarmDatePicker: UIDatePicker!
    @IBOutlet weak var alarmTitleTextField: UITextField!
    @IBOutlet weak var enableButton: UIButton!
    
    var alarm: Alarm?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let alarm = alarm {
            updateWithAlarm(alarm)
        }
        setView()
    }

    func setView() {
        if alarm == nil {
            enableButton.hidden = true
        } else {
            enableButton.hidden = false
            if alarm?.enabled == true {
                enableButton.setTitle("Disable", forState: .Normal)
                enableButton.setTitleColor(.whiteColor(), forState: .Normal)
                enableButton.backgroundColor = .redColor()
            } else {
                enableButton.setTitle("Enable", forState: .Normal)
                enableButton.setTitleColor(.blueColor(), forState: .Normal)
                enableButton.backgroundColor = .grayColor()
            }
        }
    }
    
    func updateWithAlarm(alarm: Alarm) {
        guard let thisMorningAtMidnight = DateHelper.thisMorningAtMidnight else {return}
        alarmDatePicker.setDate(NSDate(timeInterval: alarm.fireTimeFromMidnight, sinceDate: thisMorningAtMidnight), animated: false)
        alarmTitleTextField.text = alarm.name
    }

    @IBAction func saveButtonTapped(sender: AnyObject) {
        guard let title = alarmTitleTextField.text,
            thisMorningAtMidnight = DateHelper.thisMorningAtMidnight else {return}
        let timeIntervalSinceMidnight = alarmDatePicker.date.timeIntervalSinceDate(thisMorningAtMidnight)
        if let alarm = alarm {
            AlarmController.sharedInstance.updateAlarm(alarm, fireTimeFromMidnight: timeIntervalSinceMidnight, name: title)
        } else {
            let alarm = AlarmController.sharedInstance.addAlarm(timeIntervalSinceMidnight, name: title)
            self.alarm = alarm
            scheduleLocalNotification(alarm)
        }
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func enableButtonTapped(sender: AnyObject) {
        guard let alarm = alarm else {return}
        if alarm.enabled {
            cancelLocalNotification(alarm)
        } else {
            scheduleLocalNotification(alarm)
        }
        AlarmController.sharedInstance.alarmEnabledValueShouldChange(alarm)
        setView()
    }
    
    func scheduleLocalNotification(alarm: Alarm) {
        let localNotification = UILocalNotification()
        localNotification.userInfo = ["alarm": alarm.dictionaryCopy]
        localNotification.alertBody = "Time's up!"
        localNotification.alertTitle = "Time's up!"
        localNotification.fireDate = alarm.fireDate
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
    }
    
    func cancelLocalNotification(alarm: Alarm) {
        guard let localNotifications = UIApplication.sharedApplication().scheduledLocalNotifications else {return}
        let localNotificationsForThisAlarm = localNotifications.filter { (notification) -> Bool in
            guard let userInfo = notification.userInfo,
                alarmDictionary = userInfo["alarm"] as? [String: AnyObject],
                thisAlarm = Alarm(dictionary: alarmDictionary) else {return false}
            return alarm == thisAlarm
        }
        for notification in localNotificationsForThisAlarm {
            UIApplication.sharedApplication().cancelLocalNotification(notification)
        }
    }

}