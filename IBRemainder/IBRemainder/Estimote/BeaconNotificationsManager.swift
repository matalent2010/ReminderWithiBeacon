//
//  BeaconNotificationsManager Class
//  
//

import UIKit

class BeaconNotificationsManager: NSObject, ESTBeaconManagerDelegate {
//Beacon Manager instance
    private let beaconManager = ESTBeaconManager()
//When enter into range of beacon, Notificated messages Dictionary. Key String is "BeaconID"
    private var enterMessageSet = [String: NSMutableArray]()    //Arrival Messages Array
//When out range of beacon, Notificated messages Dictionary
    private var exitMessageSet = [String: NSMutableArray]() //Exit Messages Array
//Enable or disable notification Flag Set Dictionary
    private var notificationEnableSet = [String: Bool]()

    override init() {
        super.init()

        self.beaconManager.delegate = self
        self.beaconManager.requestAlwaysAuthorization()

        UIApplication.sharedApplication().registerUserNotificationSettings(UIUserNotificationSettings(forTypes: [.Sound, .Alert], categories: nil))
    }

    func enableNotificationsForBeaconID(beaconID: BeaconID, enterMessages: NSMutableArray?, exitMessages: NSMutableArray?, enableNotification: Bool = true) {
        let beaconRegion = beaconID.asBeaconRegion
        self.enterMessageSet[beaconRegion.identifier] = enterMessages
        self.exitMessageSet[beaconRegion.identifier] = exitMessages
        self.notificationEnableSet[beaconRegion.identifier] = enableNotification
        self.beaconManager.startMonitoringForRegion(beaconRegion)
    }
    
    func setNotificationsForBeaconID(beaconID: BeaconID, enterMessages: NSMutableArray?, exitMessages: NSMutableArray?) {
        let beaconRegion = beaconID.asBeaconRegion
        self.enterMessageSet[beaconRegion.identifier] = enterMessages
        self.exitMessageSet[beaconRegion.identifier] = exitMessages
    }
    
    func setEnableFlagForBeaconID(beaconID: BeaconID, enableNotification: Bool){
        let beaconRegion = beaconID.asBeaconRegion
        self.notificationEnableSet[beaconRegion.identifier] = enableNotification
    }
    
    func removeBeaconID(beaconID:BeaconID){
        let beaconRegion = beaconID.asBeaconRegion
        self.beaconManager.stopMonitoringForRegion(beaconRegion)
//        self.enterMessageSet[beaconRegion.identifier]?.removeAllObjects()
//        self.exitMessageSet[beaconRegion.identifier]?.removeAllObjects()
        self.enterMessageSet.removeValueForKey(beaconRegion.identifier)
        self.exitMessageSet.removeValueForKey(beaconRegion.identifier)
        self.notificationEnableSet.removeValueForKey(beaconRegion.identifier)
    }

    func beaconManager(manager: AnyObject, didEnterRegion region: CLBeaconRegion) {
        let messages = self.enterMessageSet[region.identifier]
        let enable = self.notificationEnableSet[region.identifier]
        if messages != nil && enable == true {
            for message in messages! {
                self.showNotificationWithMessage(message as! String)
            }
        }
    }

    func beaconManager(manager: AnyObject, didExitRegion region: CLBeaconRegion) {
        let messages = self.exitMessageSet[region.identifier]
        let enable = self.notificationEnableSet[region.identifier]
        if messages != nil && enable == true {
            for message in messages! {
                self.showNotificationWithMessage(message as! String)
            }
        }
    }

    private func showNotificationWithMessage(message: String) {
        let notification = UILocalNotification()
        notification.alertBody = message
        notification.soundName = UILocalNotificationDefaultSoundName
        UIApplication.sharedApplication().presentLocalNotificationNow(notification)
    }

    func beaconManager(manager: AnyObject, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .Denied || status == .Restricted {
            NSLog("Location Services are disabled for this app, which means it won't be able to detect beacons.")
        }
    }

    func beaconManager(manager: AnyObject, monitoringDidFailForRegion region: CLBeaconRegion?, withError error: NSError) {
        NSLog("Monitoring failed for region: %@. Make sure that Bluetooth and Location Services are on, and that Location Services are allowed for this app. Beacons require a Bluetooth Low Energy compatible device: <http://www.bluetooth.com/Pages/Bluetooth-Smart-Devices-List.aspx>. Note that the iOS simulator doesn't support Bluetooth at all. The error was: %@", region?.identifier ?? "(unknown)", error);
    }

}
