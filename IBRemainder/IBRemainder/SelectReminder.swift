//
//  SelectReminder.swift
//  IBRemainder
//
//  Created by Migue Pires on 1/13/16.
//  Copyright © 2016 Miguel. All rights reserved.
//

import UIKit
import EventKit

//Gobal variable. Reminders Manager Instance.
var rmdManager:RemindersManager = RemindersManager()

/**
 * Select Reminder View Controller Class.
 * Select the Reminder in All Reminders List or Create new reminder
 * Result is "selectedReminder" variable in AppDelegate Class
 */
class SelectReminder: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tblSelRmd: UITableView!
    
    
    override func viewWillAppear(animated: Bool) {
        printlog()
        // Fetch all reminders
        // Connect to the Event Store
        super.viewWillAppear(animated)
        rmdManager.getReminderData(self.tblSelRmd)
        //tblSelRmd.reloadData()
    }
    
    override func viewDidLoad() {
        printlog()
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tblSelRmd.dataSource = self
        self.tblSelRmd.delegate = self
        
    }
    
    override func viewDidAppear(animated: Bool) {
        let delegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        if ( delegate.bCreatedReminder == true) {
            delegate.bCreatedReminder = false
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        printlog()
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelClick(sender: AnyObject) {
        let delegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        delegate.selectedReminder = nil
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        printlog(String(rmdManager.allCalendars))
        if(tableView == tblSelRmd){
            if(rmdManager.allCalendars == nil){
                return 0
            }
//            printlog(String(rmdManager.allCalendars.count))
            return rmdManager.allCalendars.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        printlog()
        if(tableView == tblSelRmd){
            
            let view:UIView = UIView()
            view.backgroundColor = UIColor.groupTableViewBackgroundColor()
            let rt: CGRect = UIScreen.mainScreen().bounds
            let titleHeader:UILabel = UILabel()
            titleHeader.textColor = UIColor(CGColor: rmdManager.allCalendars[section].CGColor)
            titleHeader.text = rmdManager.allCalendars[section].title;
            titleHeader.font =  UIFont.boldSystemFontOfSize(14)
            titleHeader.frame = CGRect(x: 10, y: 0, width: rt.width-10, height: 28)
            view.addSubview(titleHeader)
            return view
        }
        return UIView()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        printlog("section:" + String(section)+", rows Num:" + String(rmdManager.remindersPerCal[section].count))
        
        if(tableView == tblSelRmd){
            if( section > rmdManager.allCalendars.count ) {
                return 0;
            }
            return rmdManager.remindersPerCal[section].count;
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        printlog()
        if(tableView == tblSelRmd){
            
            let cell:UITableViewCell! = tableView.dequeueReusableCellWithIdentifier("selReminder", forIndexPath: indexPath)
            let reminder:EKReminder! = rmdManager.remindersPerCal[indexPath.section].objectAtIndex(indexPath.row) as! EKReminder
            
            let lbl = cell?.viewWithTag(101) as! UILabel
            lbl.text = reminder.title
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(tableView == tblSelRmd){            
            let reminder:EKReminder! = rmdManager.remindersPerCal[indexPath.section].objectAtIndex(indexPath.row) as! EKReminder
            let delegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            delegate.selectedReminder = reminder
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
}
