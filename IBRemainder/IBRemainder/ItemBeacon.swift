//
//  ItemBeacon.swift
//  IBRemainder
//
//  Created by Miguel Pires on 1/11/16.
//  Copyright (c) 2016 Miguel. All rights reserved.
//

import UIKit


/**
 * Beacon View class of Scroll View in main View controller
 * Beacon Name, ON/OFF status Viewing each Beacon
 */
class ItemBeacon: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    var titleImage:UIButton!
    var lblBeaconName:UILabel!
    var itemSwitch:UISwitch!
    var txtBeaconName:NSString!
    var parentVC : UIViewController!
    var selfData : ItemData!
    
    init(s: ItemData) {
        selfData = s
        txtBeaconName = s.txtBeaconName;
        let rt: CGRect = UIScreen.mainScreen().bounds
        titleImage = UIButton()
        if( s.bBeaconOn==1 ){
            titleImage.setBackgroundImage(UIImage(named: "imgBeacon.png"), forState: UIControlState.Normal)
        }else{
            titleImage.setBackgroundImage(UIImage(named: "imgBeacon2.png"), forState: UIControlState.Normal)
        }
        lblBeaconName = UILabel()
        lblBeaconName.textAlignment = NSTextAlignment.Center
        lblBeaconName.textColor = UIColor.whiteColor()
        itemSwitch = UISwitch()
        itemSwitch.onTintColor = UIColor.whiteColor()
        
        lblBeaconName.text = txtBeaconName as String
        itemSwitch.on = s.bBeaconOn==1 ? true: false
        
        super.init(frame: CGRect(x: 0, y: 0, width: rt.width, height: rt.height/2))
        
        addSubview(titleImage)
        addSubview(lblBeaconName)
        addSubview(itemSwitch)
        
        titleImage.frame = CGRect(x: (rt.width-rt.height*0.33*0.75)/2, y: 20, width: rt.height*0.33*0.75, height: rt.height*0.33-20)
        lblBeaconName.frame = CGRect(x: 10, y: rt.height*0.33, width: rt.width-20, height: rt.height*0.08)
        itemSwitch.frame = CGRect(x: (rt.width-51)/2, y: lblBeaconName.frame.height+lblBeaconName.frame.origin.y, width: 51, height: 31)
        itemSwitch.addTarget(self, action: "beaconDetectOnChanged:", forControlEvents: UIControlEvents.ValueChanged)
        titleImage.addTarget(self, action: "beaconInfoEdit:", forControlEvents: UIControlEvents.TouchUpInside)
        
        parentVC = nil
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func beaconDetectOnChanged(sender:UISwitch) {
        selfData.bBeaconOn = sender.on ? 1 : 0
        if( sender.on == true){
            titleImage.setBackgroundImage(UIImage(named: "imgBeacon.png"), forState: UIControlState.Normal)
        }else{
            titleImage.setBackgroundImage(UIImage(named: "imgBeacon2.png"), forState: UIControlState.Normal)
        }
        let delegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let beaconID = BeaconID(UUIDString: selfData.txtBeaconUuid, major: CLBeaconMajorValue(selfData.nMajor), minor: CLBeaconMinorValue(selfData.nMinor))
        delegate.beaconNotificationsManager.setEnableFlagForBeaconID(beaconID, enableNotification: sender.on)
    }
    
    @IBAction func beaconInfoEdit(sender:UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("sbBeaconInfoVC") as! BeaconInfoVC
        if(parentVC != nil){
            vc.initBeaconInfo(selfData)
            parentVC.presentViewController(vc, animated: true, completion: nil)
            vc.btnDelete.hidden = false
        }        
    }
}
