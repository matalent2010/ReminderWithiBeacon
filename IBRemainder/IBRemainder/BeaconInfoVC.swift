//
//  BeaconInfoVC.swift
//  IBRemainder
//
//  Created by Miguel Pires on 1/18/16.
//  Copyright © 2016 Miguel. All rights reserved.
//

import UIKit
import EventKit

/**
 * Create or modify Beacon Info ViewController
 *
 */
class BeaconInfoVC: UIViewController, UITableViewDataSource, UITableViewDelegate  {

    @IBOutlet weak var tblAddItem: UITableView!
    @IBOutlet weak var btnDelete: UIButton!
    
    var beaconData:ItemData! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if( beaconData != nil){
            var lbl = tblAddItem.viewWithTag(101) as! UITextField
            lbl.text = beaconData.txtBeaconName
            
            let strUuidArr = beaconData.txtBeaconUuid.componentsSeparatedByString("-")
            lbl = tblAddItem.viewWithTag(102) as! UITextField
            lbl.text = strUuidArr[0]
            lbl = tblAddItem.viewWithTag(103) as! UITextField
            lbl.text = strUuidArr[1]
            lbl = tblAddItem.viewWithTag(104) as! UITextField
            lbl.text = strUuidArr[2]
            lbl = tblAddItem.viewWithTag(105) as! UITextField
            lbl.text = strUuidArr[3]
            lbl = tblAddItem.viewWithTag(106) as! UITextField
            lbl.text = strUuidArr[4]
            
            lbl = tblAddItem.viewWithTag(107) as! UITextField
            lbl.text = String(beaconData.nMajor)
            lbl = tblAddItem.viewWithTag(108) as! UITextField
            lbl.text = String(beaconData.nMinor)
            
            var swt = tblAddItem.viewWithTag(110) as! UISwitch
            swt.on = beaconData.bBeaconOn == 1 ? true : false
            
            swt = tblAddItem.viewWithTag(111) as! UISwitch
            swt.on = beaconData.bNSound == 1 ? true : false
        }
    }
    @IBAction func EndEdit(sender: AnyObject) {
        self.view.endEditing(true);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initBeaconInfo(s:ItemData) {
        beaconData = s
    }
    
    @IBAction func deleteBtnClick(sender: AnyObject) {
        self.view.endEditing(true)
        
        
        let delegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        delegate.itemList.removeObject(beaconData)
        let beaconID = BeaconID(UUIDString: beaconData.txtBeaconUuid, major: CLBeaconMajorValue(beaconData.nMajor), minor: CLBeaconMinorValue(beaconData.nMinor))
        delegate.beaconNotificationsManager.removeBeaconID(beaconID)
        saveDatas()
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func cancelBtnClick(sender: AnyObject) {
        
        printlog()
        self.view.endEditing(true)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func saveBtnClick(sender: AnyObject) {
        printlog()
        self.view.endEditing(true)
        
        
        if( correctBeaconData() == false){
            return
        }
        
        if( beaconData == nil ){
            let beaconData1:ItemData = ItemData()
            
            for ;; {
                beaconData1.txtBeaconID = NSUUID().UUIDString
                if( isExistingBeaconID(beaconData1.txtBeaconID) == false){
                    break
                }
            }
            
            //let cell = tblAddItem.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0))
            var lbl = tblAddItem.viewWithTag(101) as! UITextField
            beaconData1.txtBeaconName = lbl.text
            
            lbl = tblAddItem.viewWithTag(102) as! UITextField
            beaconData1.txtBeaconUuid = lbl.text?.uppercaseString
            lbl = tblAddItem.viewWithTag(103) as! UITextField
            beaconData1.txtBeaconUuid = beaconData1.txtBeaconUuid + "-" + (lbl.text?.uppercaseString)!
            lbl = tblAddItem.viewWithTag(104) as! UITextField
            beaconData1.txtBeaconUuid = beaconData1.txtBeaconUuid + "-" + (lbl.text?.uppercaseString)!
            lbl = tblAddItem.viewWithTag(105) as! UITextField
            beaconData1.txtBeaconUuid = beaconData1.txtBeaconUuid + "-" + (lbl.text?.uppercaseString)!
            lbl = tblAddItem.viewWithTag(106) as! UITextField
            beaconData1.txtBeaconUuid = beaconData1.txtBeaconUuid + "-" + (lbl.text?.uppercaseString)!
            
            lbl = tblAddItem.viewWithTag(107) as! UITextField
            beaconData1.nMajor = Int(lbl.text!)
            lbl = tblAddItem.viewWithTag(108) as! UITextField
            beaconData1.nMinor = Int(lbl.text!)
            
            var swt = tblAddItem.viewWithTag(110) as! UISwitch
            beaconData1.bBeaconOn = swt.on == true ? 1 : 0
            
            swt = tblAddItem.viewWithTag(111) as! UISwitch
            beaconData1.bNSound = swt.on == true ? 1 : 0
            let delegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            delegate.newBeaconData = beaconData1
        }else{
            var lbl = tblAddItem.viewWithTag(101) as! UITextField
            beaconData.txtBeaconName = lbl.text
            
            lbl = tblAddItem.viewWithTag(102) as! UITextField
            beaconData.txtBeaconUuid = lbl.text?.uppercaseString
            lbl = tblAddItem.viewWithTag(103) as! UITextField
            beaconData.txtBeaconUuid = beaconData.txtBeaconUuid + "-" + (lbl.text?.uppercaseString)!
            lbl = tblAddItem.viewWithTag(104) as! UITextField
            beaconData.txtBeaconUuid = beaconData.txtBeaconUuid + "-" + (lbl.text?.uppercaseString)!
            lbl = tblAddItem.viewWithTag(105) as! UITextField
            beaconData.txtBeaconUuid = beaconData.txtBeaconUuid + "-" + (lbl.text?.uppercaseString)!
            lbl = tblAddItem.viewWithTag(106) as! UITextField
            beaconData.txtBeaconUuid = beaconData.txtBeaconUuid + "-" + (lbl.text?.uppercaseString)!
            
            lbl = tblAddItem.viewWithTag(107) as! UITextField
            beaconData.nMajor = Int(lbl.text!)
            lbl = tblAddItem.viewWithTag(108) as! UITextField
            beaconData.nMinor = Int(lbl.text!)
            
            var swt = tblAddItem.viewWithTag(110) as! UISwitch
            beaconData.bBeaconOn = swt.on == true ? 1 : 0
            
            swt = tblAddItem.viewWithTag(111) as! UISwitch
            beaconData.bNSound = swt.on == true ? 1 : 0
        }
        saveDatas()
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if(tableView == tblAddItem){
            return 4
        }
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tableView == tblAddItem){
            if(section == 0 || section == 1 || section == 2){
                return 1
            }else if(section == 3){
                return 2
            }
        }
        
        return 0
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if(tableView == tblAddItem){
            return 50.0
        }
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if(tableView == tblAddItem){
            return 40.0
        }
        return 40.0
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(tableView == tblAddItem){
            switch(section){
            case 0:
                return "NAME"
            case 1:
                return "UUID"
            case 2:
                return "MAJOR/MINOR"
            case 3:
                return "OPTIONS"
            default:
                return ""
            }
        }
        return ""
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if(tableView == tblAddItem){
            switch(indexPath.section){
            case 0:
                let cell:UITableViewCell = tblAddItem.dequeueReusableCellWithIdentifier("itemcell1", forIndexPath: indexPath)
                return cell
            case 1:
                let cell:UITableViewCell = tblAddItem.dequeueReusableCellWithIdentifier("itemcell2", forIndexPath: indexPath)
                return cell
            case 2:
                let cell:UITableViewCell = tblAddItem.dequeueReusableCellWithIdentifier("itemcell3", forIndexPath: indexPath)
                return cell
            case 3:
                if(indexPath.row == 0){
                    let cell:UITableViewCell = tblAddItem.dequeueReusableCellWithIdentifier("itemcell4", forIndexPath: indexPath)
                    return cell
                }else if(indexPath.row == 1){
                    let cell:UITableViewCell = tblAddItem.dequeueReusableCellWithIdentifier("itemcell5", forIndexPath: indexPath)
                    return cell
                }
                break
            default:
                break
            }
        }
        return UITableViewCell();
    }

    func correctBeaconData() -> Bool {
        let alert: UIAlertController
        var lbl = tblAddItem.viewWithTag(101) as! UITextField
        if(lbl.text?.isEmpty == true){
            alert = UIAlertController(title: "Invalid Beacon Name", message: "Please give your Beacon a name.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return false
        }
        
        let lbl1 = tblAddItem.viewWithTag(102) as! UITextField
        let lbl2 = tblAddItem.viewWithTag(103) as! UITextField
        let lbl3 = tblAddItem.viewWithTag(104) as! UITextField
        let lbl4 = tblAddItem.viewWithTag(105) as! UITextField
        let lbl5 = tblAddItem.viewWithTag(106) as! UITextField
        if( lbl1.text?.characters.count != 8 || lbl2.text?.characters.count != 4 || lbl3.text?.characters.count != 4 || lbl4.text?.characters.count != 4 || lbl5.text?.characters.count != 12 || isHexaCharacters(lbl1.text!)==false ||  isHexaCharacters(lbl2.text!)==false ||  isHexaCharacters(lbl3.text!)==false ||  isHexaCharacters(lbl4.text!)==false ||  isHexaCharacters(lbl5.text!)==false ){
            alert = UIAlertController(title: "Invalid UUID", message: "The UUID value can only contain hexadecimal characters (0-9,A-F) in the form \"01234567-89AB-CDEF-0123-456789ABCDEF\". Please check it and try again.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return false
        }
        
        lbl = tblAddItem.viewWithTag(107) as! UITextField
        if( Int(lbl.text!)<0 || Int(lbl.text!)>65535  ){
            alert = UIAlertController(title: "Invalid Major", message: "The Major value can only be either blank or a number between 0 and 65535. Please check it and try again.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return false
        }
        lbl = tblAddItem.viewWithTag(108) as! UITextField
        if( Int(lbl.text!)<0 || Int(lbl.text!)>65535  ){
            alert = UIAlertController(title: "Invalid Minor", message: "The Minor value can only be either blank or a number between 0 and 65535. Please check it and try again.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return false
        }
        return true
    }
    
    func isExistingBeaconID(newBeaconID: String) -> Bool{
        let delegate:AppDelegate = UIApplication.sharedApplication().delegate as!AppDelegate
        var item:ItemData
        for var i=0; i<delegate.itemList.count; i++ {
            item = delegate.itemList[i] as! ItemData
            if(item.txtBeaconID.compare(newBeaconID) == NSComparisonResult.OrderedSame ){
                return true
            }
        }
        return false
    }
    
    func isHexaCharacters(string:String) -> Bool{
        
        let hexCharacters:String = "0123456789ABCDEF"
        let upperString = string.uppercaseString
        for var i=0; i<upperString.characters.count; i++ {
            if( hexCharacters.characters.indexOf(upperString[upperString.startIndex.advancedBy(i)]) == nil) {
                return false
            }
        }
        return true
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
    
}
