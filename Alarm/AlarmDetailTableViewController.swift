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
        updateViewForAlarm()
    }

    func updateViewForAlarm() {
        if let alarm = alarm {
            NSDate(
            alarmDatePicker.setDate(, animated: <#T##Bool#>)
        }
    }

    @IBAction func saveButtonTapped(sender: AnyObject) {
    }
    
    @IBAction func enableButtonTapped(sender: AnyObject) {
        
    }

}