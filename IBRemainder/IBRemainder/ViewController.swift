//
//  ViewController.swift
//  IBRemainder
//
//  Created by Miguel Pires on 1/11/16.
//  Copyright (c) 2016 Miguel. All rights reserved.
//

import UIKit
import EventKit

func printlog(logMessage: String = "", functionName: String = __FUNCTION__) {
    print("\(functionName): \(logMessage)")
}

// main view Controller
class ViewController: UIViewController, UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate {

// the conrols in main VC
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var viewlastItem: UIView!
    @IBOutlet weak var btnAddNewItem: UIButton!
    @IBOutlet weak var segUpon: UISegmentedControl!
    
    @IBOutlet weak var btnAddUpon: UIButton!
    @IBOutlet weak var reminderTable: UITableView!
    @IBOutlet weak var viewConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        let delegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        //itemList = delegate.itemList
        loadDatas()
        pageControl.numberOfPages = delegate.itemList.count+1;
        pageControl.currentPage = 0;
    }
    
    override func viewWillAppear(animated: Bool) {
        let delegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        rmdManager.getReminderData() // load Reminder Data
        
        // add reminder in Arrival or Exit Notification once selected Reminder
        if( delegate.selectedReminder != nil) {
            addUponList(delegate.selectedReminder )
            delegate.selectedReminder = nil
        }
        // add New Beacon in Beacon List once create new Beacon
        if( delegate.newBeaconData != nil) {
            delegate.itemList.addObject(delegate.newBeaconData)
            delegate.newBeaconData = nil
            pageControl.currentPage = delegate.itemList.count-1
        }
        
        saveDatas() //Save the Beacon Info Data in local on device.
        refreshItems()
        disableItemOnLastPage()
        reminderTable.reloadData() //Upon Arrival/Exit Table list refresh
    }
    
    override func viewDidAppear(animated: Bool) {
        //let rt: CGRect = UIScreen.mainScreen().bounds
        //viewConstraint.constant = rt.height
        refreshItems()
        disableItemOnLastPage()
        reminderTable.reloadData()
        registerNotificationAll()
    }
    
    override func viewDidDisappear(animated: Bool) {
        saveDatas()
    }
    
    func addUponList( reminder: EKReminder) -> Bool{
        let delegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        if( pageControl.currentPage < pageControl.numberOfPages-1 ){
            let index = self.pageControl.currentPage
            if( index >= self.pageControl.numberOfPages-1) { //if current page is last
                return false
            }
            if( index > delegate.itemList.count-1){
                return false
            }
            
            let currentItem = delegate.itemList[index] as! ItemData
            switch(self.segUpon.selectedSegmentIndex)
            {
            case 0:
                if( isExistingCurrentList(reminder.calendarItemIdentifier, currentList:currentItem.arrivalList) == true){
                    return false
                }
                currentItem.arrivalList.addObject(reminder.calendarItemIdentifier)
                return true
            case 1:
                if( isExistingCurrentList(reminder.calendarItemIdentifier, currentList:currentItem.exitList) == true){
                    return false
                }
                currentItem.exitList.addObject(reminder.calendarItemIdentifier)
                return true
            default:
                break
            }
        }
        return false
    }
    
    func isExistingCurrentList( reminderID:String, currentList:NSMutableArray ) -> Bool{
        for item in currentList {
            let itemString:String = item as! String
            if( itemString.compare(reminderID) == NSComparisonResult.OrderedSame)
            {
                return true
            }
        }
        return false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if( scrollView == self.scrollView){
            let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
            pageControl.currentPage = Int(pageNumber)
            disableItemOnLastPage()
            refreshReminderList()
        }    
    }
    
    func disableItemOnLastPage()
    {
        if( pageControl.currentPage == pageControl.numberOfPages-1){
            btnAddUpon.enabled = false
            segUpon.enabled = false
            reminderTable.hidden = true
        }else{
            btnAddUpon.enabled = true
            segUpon.enabled = true
            reminderTable.hidden = false
        }
    }
    
    @IBAction func addReminder(sender: AnyObject) {
    }
    
    @IBAction func changedUpon(sender: AnyObject) {
        reminderTable.reloadData()
    }
    
    @IBAction func addNewBeaconbtnClick(sender: AnyObject) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("sbBeaconInfoVC") as! BeaconInfoVC
        self.presentViewController(vc, animated: true, completion: nil)
        vc.btnDelete.hidden = true
    }
    func refreshItems(){
        let delegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        for v in scrollView.subviews
        {
            v.removeFromSuperview()
        }
        
        let rt: CGRect = UIScreen.mainScreen().bounds
        var x = 0 as CGFloat
        for var i = 0 ; i < delegate.itemList.count; i++ {
            let data :ItemData = delegate.itemList[i] as! ItemData
            let item : ItemBeacon = ItemBeacon(s: data)
            item.frame = CGRect(x: x, y: 0, width: rt.width, height: rt.height/2)
            item.parentVC = self
            scrollView.addSubview(item)
            x += rt.width
        }
        
        viewlastItem.frame = CGRect(x: x, y: 0, width: rt.width, height: rt.height/2)
        scrollView.addSubview(viewlastItem)
        btnAddNewItem.layer.borderWidth = 1.0
        btnAddNewItem.layer.borderColor = UIColor.whiteColor().CGColor
        btnAddNewItem.layer.cornerRadius = 5.0
        btnAddNewItem.layer.masksToBounds = true
        x += rt.width
        scrollView.contentSize = CGSize(width: x, height: 1)
        pageControl.numberOfPages = delegate.itemList.count+1
    }
    
    func refreshReminderList() {
        
        reminderTable.reloadData()
        
    }
    
    func saveDatas()
    {
        let delegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        let dictionaryExample : [String:AnyObject] = ["IBRAppdata":delegate.itemList] // image should be either NSData or empty
        let dataExample : NSData = NSKeyedArchiver.archivedDataWithRootObject(dictionaryExample)
        
        defaults.setValue(dataExample, forKey: "localData")
        defaults.synchronize()
    }
    
    func loadDatas()
    {
        let delegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let data: AnyObject? = defaults.valueForKey("localData")
        if(data != nil){
            let dictionary:NSDictionary = NSKeyedUnarchiver.unarchiveObjectWithData(data as! NSData)! as! NSDictionary
            delegate.itemList = dictionary.objectForKey("IBRAppdata") as! NSMutableArray
        }else{
            delegate.itemList = NSMutableArray()
            initApp()
        }
        
    }
    
    func initApp(){
        let itemdata1:ItemData = ItemData(), itemdata2:ItemData = ItemData()
        
        itemdata1.txtBeaconID = NSUUID().UUIDString
        itemdata1.txtBeaconName = "Estimote Beacons"
        itemdata1.txtBeaconUuid = "B9407F30-F5F8-466E-AFF9-25556B57FE6D"
        itemdata1.nMajor = 55
        itemdata1.nMinor = 55
        itemdata1.bBeaconOn = 1
        itemdata1.bNSound = 1
        
        itemdata2.txtBeaconID = NSUUID().UUIDString
        itemdata2.txtBeaconName = "Blank Beacons"
        itemdata2.txtBeaconUuid = "B9407F30-F5F8-466E-AFF9-25556B57FE6D"
        itemdata2.nMajor = 0
        itemdata2.nMinor = 0
        itemdata2.bBeaconOn = 1
        itemdata2.bNSound = 1
        
        let delegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        delegate.itemList.addObject(itemdata1)
        delegate.itemList.addObject(itemdata2)
    }
    
    @IBAction func pageControlChanged(sender: AnyObject) {
        let i = pageControl.currentPage
        var rt: CGRect = UIScreen.mainScreen().bounds
        rt = CGRect(x: rt.width * CGFloat(i), y: 0, width: rt.width, height: rt.height/2)
        scrollView.scrollRectToVisible(rt, animated: true)
        disableItemOnLastPage()
    }
    

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let delegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        if(tableView == reminderTable){
            let index = self.pageControl.currentPage
            if( index >= self.pageControl.numberOfPages-1) { //if current page is last
                return 0
            }
            if( index > delegate.itemList.count-1){
                return 0
            }
            let currentItem = delegate.itemList[index] as! ItemData
            
            switch(self.segUpon.selectedSegmentIndex)
            {
            case 0:
                printlog("VC section:" + String(section)+", rows Num:" + String(currentItem.arrivalList.count))
                return currentItem.arrivalList.count
            case 1:
                printlog("VC section:" + String(section)+", rows Num:" + String(currentItem.exitList.count))
                return currentItem.exitList.count
            default:
                break
            }
        }
        
        return 0
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44.0
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let delegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        if( tableView == reminderTable){
            
            let index = self.pageControl.currentPage
            if( index >= self.pageControl.numberOfPages-1) { //if current page is last
                return UITableViewCell()
            }
            if( index > delegate.itemList.count-1){
                return UITableViewCell()
            }
            
            let currentItem = delegate.itemList[index] as! ItemData
            let cell:UITableViewCell = reminderTable.dequeueReusableCellWithIdentifier("ItemCell", forIndexPath: indexPath)
            let lblSymbol = cell.viewWithTag(101) as! UILabel
            let lblTitle = cell.viewWithTag(102) as! UILabel
            cell.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
            switch(self.segUpon.selectedSegmentIndex)
            {
            case 0:
                let reminderItem:EKReminder! = getReminderWithID(currentItem.arrivalList[indexPath.row] as! String)
                if(reminderItem == nil){
                    currentItem.arrivalList.removeObjectAtIndex(indexPath.row)
                    lblTitle.text = ""
                    lblSymbol.backgroundColor = UIColor.clearColor()
                    reminderTable.reloadData()
                    break
                }
                lblTitle.text = reminderItem.title
                lblSymbol.backgroundColor = UIColor(CGColor:reminderItem.calendar.CGColor)
                return cell
            case 1:
                let reminderItem:EKReminder! = getReminderWithID(currentItem.exitList[indexPath.row] as! String)
                if(reminderItem == nil){
                    currentItem.exitList.removeObjectAtIndex(indexPath.row)
                    lblTitle.text = ""
                    lblSymbol.backgroundColor = UIColor.clearColor()
                    reminderTable.reloadData()
                    break
                }
                lblTitle.text = reminderItem.title
                lblSymbol.backgroundColor = UIColor(CGColor:reminderItem.calendar.CGColor)
                return cell
            default:
                break
            }
        }
        return UITableViewCell();
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        let delegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        if(editingStyle == .Delete){
            let index = self.pageControl.currentPage
            if( index >= self.pageControl.numberOfPages-1) { //if current page is last
                return
            }
            if( index > delegate.itemList.count-1){
                return
            }
            let currentItem = delegate.itemList[index] as! ItemData
            
            switch(self.segUpon.selectedSegmentIndex)
            {
            case 0:
                currentItem.arrivalList.removeObjectAtIndex(indexPath.row)
            case 1:
                currentItem.exitList.removeObjectAtIndex(indexPath.row)
            default:
                break
            }
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
            let beaconID = BeaconID(UUIDString: currentItem.txtBeaconUuid, major: CLBeaconMajorValue(currentItem.nMajor), minor: CLBeaconMinorValue(currentItem.nMinor))
            delegate.beaconNotificationsManager.setNotificationsForBeaconID(beaconID, enterMessages: getMessages(currentItem.arrivalList), exitMessages: getMessages(currentItem.exitList))
        }
    }
    
    func getReminderWithID(reminderID : NSString) -> EKReminder!{
        for reminder in rmdManager.allReminders {
            let rmd:EKReminder = reminder as EKReminder
            if( rmd.calendarItemIdentifier == reminderID) {
                return rmd;
            }
        }
        return nil
    }
    
    func registerNotificationAll() {
        let delegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        for item in delegate.itemList {
            let itemData = item as! ItemData
            let beaconID = BeaconID(UUIDString: itemData.txtBeaconUuid, major: CLBeaconMajorValue(itemData.nMajor), minor: CLBeaconMinorValue(itemData.nMinor))
            delegate.beaconNotificationsManager.enableNotificationsForBeaconID(beaconID, enterMessages: getMessages(itemData.arrivalList), exitMessages: getMessages(itemData.exitList), enableNotification: itemData.bBeaconOn==1 ? true: false)
        }
    }
    
    func getMessages(rmdIDArray:NSMutableArray) -> NSMutableArray{
        
        let messageArray = NSMutableArray()
        
        for a in rmdIDArray {
            let rmdID = a as! String
            for b in rmdManager.allReminders{
                if( b.calendarItemIdentifier == rmdID){
                    messageArray.addObject(b.title)
                    break
                }
            }
        }
        return messageArray
    }
}

