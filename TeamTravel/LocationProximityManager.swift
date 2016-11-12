//
//  LocationProximityManager.swift
//  TeamTravel
//
//  Created by Austin Blaser on 11/12/16.
//  Copyright © 2016 Joseph Hansen. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications

class LocationProximityManager {
    
    static let shared = LocationProximityManager()
    
    // MARK: - Properties
    /// Monitored locations are tied those locations returned by the search MKSearch.
    var monitoredLocations: [Location] {
     return  SearchLocationController.shared.allReturnedLocations
    }
    
    var locationsWithinProximity: [Location] = []
    
    // MARK: - Functions
    
    func evaluateProximityForMonitoredLocations(){
        // reset locations before evaluating
        locationsWithinProximity = []
        // Populate locationsWithinProximity array
        
        
        // Handle entered regions
        didEnterLocations()
    }
    
    func didEnterLocations(){
        for location in locationsWithinProximity {
            // Add location to Master traveler
            let fire = TravelerController.shared.addVisited(location: location)
            if fire {
                fireAlertForEnteredRegion(location: location)
            }
        }
    }
    
    func fireAlertForEnteredRegion(location: Location){
        let regionAlert = UIAlertController(title: "Entered: \(location.locationName)", message: nil, preferredStyle: .alert)
        let dismiss = UIAlertAction(title: "Dismiss", style: .cancel)
        regionAlert.addAction(dismiss)
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 4, repeats: false)
        
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: Notification.Name(rawValue: postAlertNotification), object: regionAlert)
        }
        
        Notifications.sendNotification(withTitle: "You entered \(location.locationName)", andTrigger: trigger)
    }
}
