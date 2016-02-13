//
//  SelectList.swift
//  IBRemainder
//
//  Created by Miguel Pires on 1/13/16.
//  Copyright © 2016 Miguel. All rights reserved.
//

import UIKit
import EventKit

/**
 * Select List View Controller Class.
 * Select the Calendar in All Calendars List
 * Result is "selectedCalendar" variable in AppDelegate Class
 */
class SelectList: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tblCalendarList: UITableView!
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        rmdManager.getReminderData(self.tblCalendarList)
        //tblCalendarList.reloadData()
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
        self.navigationController?.popViewControllerAnimated(true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        printlog()
        
        if( rmdManager.allCalendars == nil) {
            return 0
        }else{
            return rmdManager.allCalendars.count;
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        printlog()
        
        let cell:UITableViewCell! = tableView.dequeueReusableCellWithIdentifier("cellSelectList", forIndexPath: indexPath)
        let calendar:EKCalendar! = rmdManager.allCalendars[indexPath.row] 
        
        let lbl = cell?.viewWithTag(101) as! UILabel
        lbl.text = calendar.title
        lbl.textColor = UIColor(CGColor: calendar.CGColor)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let calendar:EKCalendar! = rmdManager.allCalendars[indexPath.row]
        let delegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        delegate.selectedCalendar = calendar
        self.navigationController?.popViewControllerAnimated(true)
    }
    
}
