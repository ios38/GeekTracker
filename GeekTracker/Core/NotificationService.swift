//
//  NotificationService.swift
//  GeekTracker
//
//  Created by Maksim Romanov on 21.09.2020.
//  Copyright © 2020 Maksim Romanov. All rights reserved.
//

import Foundation
import UserNotifications

class NotificationService {
    static let shared = NotificationService()
    let center = UNUserNotificationCenter.current()

    init() {
        self.authorize()
    }
    
    private func authorize() {
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { (settings) in
            switch settings.authorizationStatus {
            case .authorized:
                print("Notifications Allowed")
            default:
                center.requestAuthorization(options: [.alert, .sound, .badge]) { (state, error) in
                    if state {
                        print("Notifications Allowed")
                    } else {
                        print("Notifications not allowed")
                    }
                }
            }
        }

    }
    
    func sendNotificationRequest() {
        sendNotificationRequest(content: makeNotificationContent(), trigger: makeNotificationTrigger())
    }
    
    func makeNotificationContent() -> UNNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = "GeekApp"
        content.body = "The app needs your attention!"
        content.badge = 1
        return content
    }
    
    func makeNotificationTrigger() -> UNNotificationTrigger {
        return UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        //var date = DateComponents()
        //date.hour = 12
        //date.minute = 48
        //return UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
    }
    
    func sendNotificationRequest(content: UNNotificationContent, trigger: UNNotificationTrigger) {
        let request = UNNotificationRequest(identifier: "alarm", content: content, trigger: trigger)
        
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }

    //func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    //    completionHandler([.alert,.badge,.sound])
    //}
    
}
