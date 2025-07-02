//
//  NotificationService.swift
//  FitMindAIApp
//
//  Created by Muqeem Ahmad on 01/07/25.
//

import Foundation
import UserNotifications

struct NotificationService {
    
    static func scheduleDailyReminders() {
        let center = UNUserNotificationCenter.current()
        
        // Walk Reminder – 8:00 AM
        let walkContent = UNMutableNotificationContent()
        walkContent.title = "🚶 Time to Move!"
        walkContent.body = "Don’t forget to hit your daily step goal!"
        walkContent.sound = .default

        var walkTime = DateComponents()
        walkTime.hour = 8
        let walkTrigger = UNCalendarNotificationTrigger(dateMatching: walkTime, repeats: true)
        let walkRequest = UNNotificationRequest(identifier: "walkReminder", content: walkContent, trigger: walkTrigger)
        
        // Sleep Check Reminder – 9:00 PM
        let sleepContent = UNMutableNotificationContent()
        sleepContent.title = "🛌 Sleep Check"
        sleepContent.body = "Did you get at least 7 hours of sleep?"
        sleepContent.sound = .default

        var sleepTime = DateComponents()
        sleepTime.hour = 21
        let sleepTrigger = UNCalendarNotificationTrigger(dateMatching: sleepTime, repeats: true)
        let sleepRequest = UNNotificationRequest(identifier: "sleepReminder", content: sleepContent, trigger: sleepTrigger)
        
        // Register notifications
        center.add(walkRequest)
        center.add(sleepRequest)
    }
    
    static func removeAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}
