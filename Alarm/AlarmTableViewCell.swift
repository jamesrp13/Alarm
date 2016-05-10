//
//  AlarmTableViewCell.swift
//  Alarm
//
//  Created by James Pacheco on 5/6/16.
//  Copyright © 2016 DevMountain. All rights reserved.
//

import UIKit

class AlarmTableViewCell: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var alarmSwitch: UISwitch!
    
    weak var delegate: AlarmTableViewCellDelegate?
    
    @IBAction func switchValueChanged(sender: AnyObject) {
        delegate?.alarmCellSwitchValueChanged(self)
    }
    
    func updateWithAlarm(alarm: Alarm) {
        timeLabel.text = alarm.fireTimeAsString
        nameLabel.text = alarm.name
        alarmSwitch.on = alarm.enabled
    }

}

protocol AlarmTableViewCellDelegate: class {
    func alarmCellSwitchValueChanged(cell: AlarmTableViewCell)
}