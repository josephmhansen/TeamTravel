//
//  Notifications.swift
//  TeamTravel
//
//  Created by Justin Carver on 11/8/16.
//  Copyright © 2016 Joseph Hansen. All rights reserved.
//

import Foundation
import UserNotifications

class Notifications {
    
    static func sendNotification(withTitle: String, andTrigger: UNNotificationTrigger?) {
        
        let content = UNMutableNotificationContent()
        content.title = withTitle
        content.sound = UNNotificationSound.default
        
        let request = UNNotificationRequest(identifier: "notification", content: content, trigger: andTrigger ?? UNTimeIntervalNotificationTrigger(timeInterval: 4, repeats: false))
        
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error) in
            if error != nil {
                print(error!.localizedDescription)
            }
        }
    }
}
