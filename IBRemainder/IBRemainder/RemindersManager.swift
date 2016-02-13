//
//  RemindersManager.swift
//  IBRemainder
//
//  Created by Miguel Pires on 1/12/16.
//  Copyright © 2016 Miguel. All rights reserved.
//

import Foundation
import EventKit
import UIKit

/**
 * Reminder Management Class.
 * LOCAL VARIABLE :
 * allReminders - ALL reminders in EventStore
 * allCalendars - ALL Calendars in EventStore
 * remindersPerCal - Identifier Arrays of Reminders per each calendar in EventStore
 */

class RemindersManager:NSObject {
//    properties and methods
    var eventStore:EKEventStore!
    var allReminders:[EKReminder]!
    var allCalendars:[EKCalendar]!
    var remindersPerCal:NSMutableArray! //[EKReminder] Array
    
    var selectedCalendarIdentifier:NSString!
    
    var selectedEventIdentifier:NSString!
    
    var eventsAccessGranted:Bool!
    
    var arrCustomCalendarIdentifiers:NSMutableArray = NSMutableArray()
    
    override init(){
        super.init()
        self.eventStore = EKEventStore()
        allReminders = [EKReminder]()
        allCalendars = [EKCalendar]()
        remindersPerCal = NSMutableArray()
        
        let userDefaults:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        // Check if the access granted value for the events exists in the user defaults dictionary.
        if (userDefaults.valueForKey("eventkit_events_access_granted") != nil) {
            // The value exists, so assign it to the property.
            self.eventsAccessGranted = userDefaults.valueForKey("eventkit_events_access_granted")?.intValue == 0 ? false : true //.valueForKey(""))?.intValue
        }
        else{
            // Set the default value.
            self.eventsAccessGranted = false;
        }
        
        
        // Load the selected calendar identifier.
        if (userDefaults.objectForKey("eventkit_selected_calendar") != nil) {
            self.selectedCalendarIdentifier = userDefaults.objectForKey("eventkit_selected_calendar")  as! NSString
        }
        else{
            self.selectedCalendarIdentifier = ""
        }
        
        // Load the custom calendar identifiers (if exist).
        if (userDefaults.objectForKey("eventkit_cal_identifiers") != nil) {
            self.arrCustomCalendarIdentifiers = userDefaults.objectForKey("eventkit_cal_identifiers") as! NSMutableArray
        }
        else{
            self.arrCustomCalendarIdentifiers = NSMutableArray()
        }
    }

    //func getReminderData(completion: ([EKReminder]?) -> Void)
    
    func getReminderData(activity:UITableView? = nil) { //[EKReminder]()
        self.eventStore.requestAccessToEntityType(EKEntityType.Reminder) { (granted: Bool, error: NSError?) -> Void in
            
            if granted{
                let predicate = self.eventStore.predicateForIncompleteRemindersWithDueDateStarting(nil, ending: nil, calendars: nil)
                self.eventStore.fetchRemindersMatchingPredicate(predicate, completion: { (reminders: [EKReminder]?) -> Void in
                    self.allReminders = reminders!
                    
                    self.allCalendars = self.eventStore.calendarsForEntityType(EKEntityType.Reminder)
                    self.remindersPerCal.removeAllObjects()
                    for var i=0; i<self.allCalendars.count; i++ {
                        self.remindersPerCal.addObject(NSMutableArray())
                        for var j=0; j<self.allReminders.count; j++ {
                            if( self.allReminders[j].calendar == self.allCalendars[i] ){
                                self.remindersPerCal[self.remindersPerCal.count-1].addObject(self.allReminders[j])
                            }
                        }
                    }
                    let delegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                    delegate.statusReminder = 1
                    
                    for item in delegate.itemList {
                        let itemData = item as! ItemData
                        for itemArrival in itemData.arrivalList{
                            if(self.isExistingReminderWithID(itemArrival as! String) == false){
                                itemData.arrivalList.removeObject(itemArrival)
                            }
                        }
                        for itemExit in itemData.exitList{
                            if(self.isExistingReminderWithID(itemExit as! String) == false){
                                itemData.arrivalList.removeObject(itemExit)
                            }
                        }
                    }
                    
                    if(activity != nil){
                        dispatch_async(dispatch_get_main_queue()) {
                            activity!.reloadData()
                        }
                    }
                })
            }else{
                let delegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                delegate.statusReminder = 2
                print("The app is not permitted to access reminders, make sure to grant permission in the settings and try again")
            }
        }
    }
    
    func getCalendarWithID(calendarID:NSString) ->EKCalendar!{
        for calendar in self.allCalendars{
            if( calendar.calendarIdentifier == calendarID){
                return calendar
            }
        }
        return nil
    }
    
    func isExistingCalendar(calendar:EKCalendar) -> Bool {
        for var i=0; i<self.allCalendars.count; i++ {
            if(calendar == self.allCalendars[i]){
                return true;
            }
        }
        return false
    }
    
    func isExistingReminder(reminder:EKReminder) -> Bool {
        for var i=0; i<self.allReminders.count; i++ {
            if(reminder == self.allReminders[i]){
                return true;
            }
        }
        return false
    }
    
    func isExistingReminderWithID(reminderID:String) -> Bool {
        for reminder in self.allReminders {
            if( reminder.calendarItemIdentifier.compare(reminderID) == NSComparisonResult.OrderedSame ){
                return true;
            }
        }
        return false
    }
    
    func getLocalEventCalendars() -> NSArray {
        
        let allCalendars:NSArray = eventStore.calendarsForEntityType(EKEntityType.Event)
        let localCalendars:NSMutableArray = NSMutableArray()
        
        for var i=0; i<allCalendars.count; i++ {
            let currentCalendar:EKCalendar = allCalendars.objectAtIndex(i) as! EKCalendar
            if (currentCalendar.type == EKCalendarType.Local) {
                localCalendars.addObject(currentCalendar)
            }
        }
        
        return localCalendars;
    }
    
    func saveCustomCalendarIdentifier(identifier:NSString) {
        arrCustomCalendarIdentifiers.addObject(identifier)
        
        NSUserDefaults.standardUserDefaults().setObject(self.arrCustomCalendarIdentifiers, forKey:"eventkit_cal_identifiers")
    }
    
    func checkIfCalendarIsCustomWithIdentifier(identifier:NSString) -> Bool {
        var isCustomCalendar:Bool = false;
        
        for var i=0; i<self.arrCustomCalendarIdentifiers.count; i++ {
            if ((self.arrCustomCalendarIdentifiers.objectAtIndex(i) as! NSString).isEqualToString(identifier as String) == true) {
                isCustomCalendar = true;
                break;
            }
        }
        
        return isCustomCalendar;
    }
    
    func removeCalendarIdentifier(identifier:NSString){
        self.arrCustomCalendarIdentifiers.removeObject(identifier)
        
        NSUserDefaults.standardUserDefaults().setObject(self.arrCustomCalendarIdentifiers, forKey:"eventkit_cal_identifiers")
    }
    
//    -(NSArray *)getEventsOfSelectedCalendar: (int)upcomingDays;
    
    func deleteEventWithIdentifier(identifier:NSString) {
        // Get the event that's about to be deleted.
        let event:EKEvent = self.eventStore.eventWithIdentifier(identifier as String)!
        
        // Delete it.

        do {
            try self.eventStore.removeEvent(event, span:EKSpan.FutureEvents, commit: true)
        } catch {
            print("Error Removeing Event : \(error)")
        }
    }
}