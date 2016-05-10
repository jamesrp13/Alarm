//
//  AlarmListTableViewController.swift
//  Alarm
//
//  Created by James Pacheco on 5/6/16.
//  Copyright © 2016 DevMountain. All rights reserved.
//

import UIKit

class AlarmListTableViewController: UITableViewController, AlarmTableViewCellDelegate, AlarmScheduler {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AlarmController.sharedInstance.alarms.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("alarmCell", forIndexPath: indexPath) as? AlarmTableViewCell ?? AlarmTableViewCell()
        
        let alarm = AlarmController.sharedInstance.alarms[indexPath.row]
        cell.updateWithAlarm(alarm)
        cell.delegate = self
        
        return cell
    }
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let alarm = AlarmController.sharedInstance.alarms[indexPath.row]
            cancelLocalNotification(alarm)
            AlarmController.sharedInstance.deleteAlarm(alarm)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    
    func alarmCellSwitchValueChanged(cell: AlarmTableViewCell) {
        guard let indexPath = tableView.indexPathForCell(cell) else {return}
        let alarm = AlarmController.sharedInstance.alarms[indexPath.row]
        if alarm.enabled {
            cancelLocalNotification(alarm)
        } else {
            scheduleLocalNotification(alarm)
        }
        AlarmController.sharedInstance.toggleEnabled(alarm)
        tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let detailVC = segue.destinationViewController as? AlarmDetailTableViewController
        if segue.identifier == "toAlarmDetail" {
            guard let indexPath = tableView.indexPathForSelectedRow else {return}
            let alarm = AlarmController.sharedInstance.alarms[indexPath.row]
            detailVC?.alarm = alarm
        }
    }
    
}
