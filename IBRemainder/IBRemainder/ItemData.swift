//
//  ItemData.swift
//  IBRemainder
//
//  Created by Miguel Pires on 1/11/16.
//  Copyright (c) 2016 Miguel. All rights reserved.
//

import UIKit

/**
 * Beacon Item Data Class.
 * LOCAL VARIABLE :
 *  txtBeaconID - Unique Identifier to indentify the Beacon. When create Beacon Info, make it uniquely
 *  txtBeaconName - Beacon Name
 *  txtBeaconUuid - Beacon UUID
 *  nMajor   - Major Number of Beacon
 *  nMinor   - Minor Number of Beacon
 *  bBeaconOn  - Beacon ON/OFF status
 *  bNSound  - sounds of Beacon notification ON/OFF status( not working now)
 *  arrivalList  - Entering the range of Beacon, notificated messages
 *  exitList  - Outting the range of Beacon, notificated messages
 */
class ItemData: NSObject, NSCoding {
    var txtBeaconID:String!
    var txtBeaconName:String!
    var txtBeaconUuid:String!
    var nMajor:Int!
    var nMinor:Int!
    var bBeaconOn:Int!
    var bNSound:Int!
    var arrivalList:NSMutableArray!
    var exitList:NSMutableArray!
    
    override init() {
        txtBeaconID = ""
        txtBeaconName = ""
        txtBeaconUuid = "00000000-0000-0000-0000-000000000000"
        nMajor = 0
        nMinor = 0
        bBeaconOn = 1
        bNSound = 1
        arrivalList = NSMutableArray()
        exitList = NSMutableArray()
    }
    
    required init?(coder aDecoder: NSCoder) {
        txtBeaconID = aDecoder.decodeObjectForKey("BeaconID") as! String
        txtBeaconName = aDecoder.decodeObjectForKey("BeaconName") as! String
        txtBeaconUuid = aDecoder.decodeObjectForKey("BeaconUUID") as! String
        nMajor = aDecoder.decodeIntegerForKey("Major") as Int
        nMinor = aDecoder.decodeIntegerForKey("Minor") as Int
        bBeaconOn = aDecoder.decodeIntegerForKey("BeaconOn") as Int
        bNSound = aDecoder.decodeIntegerForKey("NotificationSound") as Int
        arrivalList = aDecoder.decodeObjectForKey("ArrivalList") as! NSMutableArray
        exitList = aDecoder.decodeObjectForKey("ExitList") as! NSMutableArray
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(txtBeaconID, forKey: "BeaconID")
        aCoder.encodeObject(txtBeaconName, forKey: "BeaconName")
        aCoder.encodeObject(txtBeaconUuid, forKey: "BeaconUUID")
        aCoder.encodeInteger(nMajor, forKey: "Major")
        aCoder.encodeInteger(nMinor, forKey: "Minor")
        aCoder.encodeInteger(bBeaconOn, forKey: "BeaconOn")
        aCoder.encodeInteger(bNSound, forKey: "NotificationSound")
        aCoder.encodeObject(arrivalList, forKey: "ArrivalList")
        aCoder.encodeObject(exitList, forKey: "ExitList")
        
    }
}
