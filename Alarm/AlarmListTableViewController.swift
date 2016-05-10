//
//  AlarmListTableViewController.swift
//  Alarm
//
//  Created by James Pacheco on 5/6/16.
//  Copyright © 2016 DevMountain. All rights reserved.
//

import UIKit

class AlarmListTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AlarmController.sharedInstance.alarms.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("alarmCell", forIndexPath: indexPath) as? AlarmTableViewCell ?? AlarmTableViewCell()
        
        let alarm = AlarmController.sharedInstance.alarms[indexPath.row]
        cell.updateWithAlarm(alarm)
        
        return cell
    }
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let alarm = AlarmController.sharedInstance.alarms[indexPath.row]
            AlarmController.sharedInstance.deleteAlarm(alarm)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let detailVC = segue.destinationViewController as? AlarmDetailTableViewController
        switch segue.identifier ?? "" {
        case "toAlarmDetail":
            guard let indexPath = tableView.indexPathForSelectedRow else {return}
            let alarm = AlarmController.sharedInstance.alarms[indexPath.row]
            detailVC?.alarm = alarm
        case "toNewAlarm":
            break
        default:
            break
        }
    }
    
}
