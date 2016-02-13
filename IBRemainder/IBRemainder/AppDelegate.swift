//
//  AppDelegate.swift
//  IBRemainder
//
//  Created by Miguel Pires on 1/11/16.
//  Copyright (c) 2016 Miguel. All rights reserved.
//

import UIKit
import EventKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, ESTBeaconManagerDelegate {

    var window: UIWindow?
    
//the status of Accessings Reminders - 0: loading, 1: access, 2: denied
    var statusReminder:Int8 = 0
//SelectReminder View
    var selectedReminder: EKReminder! = nil
// NewReminder View
    var selectedCalendar: EKCalendar?
//flag created new reminder
    var bCreatedReminder:Bool?
//new Beacon Item
    var newBeaconData:ItemData! = nil
//Beacon Item List
    var itemList:NSMutableArray = []
    
    let beaconNotificationsManager = BeaconNotificationsManager()
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        statusReminder = 0
        bCreatedReminder = false
        // Override point for customization after application launch.
        
        // You can get them by adding your app on https://cloud.estimote.com/#/apps
        ESTConfig.setupAppID("App ID", andAppToken: "App Token")
        
//        self.beaconNotificationsManager.enableNotificationsForBeaconID(
//            //BeaconID(UUIDString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D", major: 2, minor: 3),
//            BeaconID(UUIDString: "D21ED022-14BC-58BD-ADBA-ABC5F5C9199A", major: 1, minor: 5),
//            enterMessages: ["Hello, world.", "asdf"],
//            exitMessages: ["Goodbye, world.", "asdf"]
//        )
        
        // NOTE: "exit" event has a built-in delay of 30 seconds, to make sure that the user has really exited the beacon's range. The delay is imposed by iOS and is non-adjustable.
        NSThread.sleepForTimeInterval(2.0)
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        statusReminder = 0
        rmdManager.getReminderData()
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

