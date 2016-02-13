//
//  NewReminder.swift
//  IBRemainder
//
//  Created by Migue Pires on 1/13/16.
//  Copyright © 2016 Miguel. All rights reserved.
//

import UIKit
import EventKit

/**
 * Create New Reminder View Controller Class.
 * Select the Calendar in All Calendars List
 * Result is "selectedCalendar" variable in AppDelegate Class
 */

class NewReminder: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tblSelectList: UITableView!
    @IBOutlet weak var tfReminderTitle: UITextField!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tblSelectList.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismiss(sender: AnyObject) {
        let delegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        delegate.selectedCalendar = nil
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func doneClick(sender: AnyObject) {
        self.view.endEditing(true);
        let delegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        if( tfReminderTitle.text?.characters.count == 0){
            let alert = UIAlertController(title: "Invalid Reminder Title", message: "The reminder title cannot be empty. Please input a title and try again.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return;
        }
        if( delegate.selectedCalendar == nil){
            let alert = UIAlertController(title: "No Calendar Selected", message: "Please select a calendar and try again.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return;
        }
        
        delegate.selectedReminder = self.saveNewReminder(tfReminderTitle.text!, calendarID: delegate.selectedCalendar!.calendarIdentifier)
        if( delegate.selectedReminder != nil )  {
            delegate.bCreatedReminder = true;            
        }
        delegate.selectedCalendar = nil
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func fieldRTEnd(sender: AnyObject) {
        self.view.endEditing(true)
    }
    
    func saveNewReminder(reminderTitle:NSString, calendarID:NSString) -> EKReminder!{
        //New Reminder Register Function 
        //return Success : New Reminder, Fail : nil
        let reminder = EKReminder(eventStore: rmdManager.eventStore)
        reminder.title = reminderTitle as String
        reminder.calendar = rmdManager.getCalendarWithID(calendarID)
        // 2
        do {
            try rmdManager.eventStore.saveReminder(reminder, commit: true)
            return reminder
        }catch{
            print("Error creating and saving new reminder : \(error)")
        }
        
        //not yet
        return nil
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        printlog("")
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //printlog()
        
        let cell:UITableViewCell! = tableView.dequeueReusableCellWithIdentifier("idSelectList", forIndexPath: indexPath)
        let lblSelectList = cell?.viewWithTag(102) as! UILabel
        let delegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        if(delegate.selectedCalendar == nil){
            lblSelectList.textColor = UIColor.groupTableViewBackgroundColor()
            lblSelectList.text = "Select List"
        }else if(rmdManager.isExistingCalendar(delegate.selectedCalendar!) == true){
            lblSelectList.textColor = UIColor(CGColor: delegate.selectedCalendar!.CGColor)
            lblSelectList.text = delegate.selectedCalendar!.title
        }else{
            lblSelectList.textColor = UIColor.groupTableViewBackgroundColor()
            lblSelectList.text = "Select List"
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("sbSelectList")
        self.navigationController?.pushViewController(vc, animated: true)
        //self.presentViewController(vc, animated: true, completion: nil)
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    

}
