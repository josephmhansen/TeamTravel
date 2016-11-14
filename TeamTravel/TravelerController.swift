//
//  TravelerController.swift
//  TeamTravel
//
//  Created by Jairo Eli de Leon on 10/26/16.
//  Copyright © 2016 Joseph Hansen. All rights reserved.
//

import UIKit
import CloudKit
import CoreLocation

class TravelerController {
  
  var masterTraveler: Traveler?
  
  static let shared = TravelerController()
    
    // MARK: - Add visitied based on LocationProximityManager
    
    /// Adds a visited location and returns a bool whether a notification should be fired
    func addVisited(location: Location) -> Bool {
        guard let traveler = self.masterTraveler else { return false }
        var append = false
        var fireNotification = true
        for visitedLocation in traveler.locationsVisited {
            if location.locationName.lowercased() == visitedLocation.locationName.lowercased() {
                if visitedLocation.hasVisitedToday == false {
                    // go ahead and append the date
                    visitedLocation.datesVisited.append(Date())
                    // CloudKit Save
                    CloudKitSync.shared.modifyLocationVisited(location: visitedLocation)
                } else {
                    // don't append the date
                    fireNotification = false
                }
                
                append = true
            }
        }
        
        if !append {
            location.datesVisited.append(Date())
            traveler.locationsVisited.append(location)
            // CloudKit Save
            CloudKitSync.shared.createLocationVisited(location: location)
        }
        
        AwardController.shared.awardBadges()
        return fireNotification
    }
    
    // MARK: - Add visited based on region monitoring
  
    func addVisited(region: CLRegion) {
        guard let circularRegion = region as? CLCircularRegion else { return }
        // Convert region to a location:
        let location = SearchLocationController.shared.locationFromRegion(identifier: circularRegion.identifier)
        guard let locationToAppend = location else {    // here we would search for the location, or cache the region info to then create a CKRecord when the app launches again
            // let coordinate = circularRegion.center
            return
        }
        guard let traveler = self.masterTraveler else { return }
        var append = false
        for visitedLocation in traveler.locationsVisited {
            if locationToAppend == visitedLocation {
                visitedLocation.datesVisited.append(Date())
                append = true
                // CloudKit Save
                CloudKitSync.shared.modifyLocationVisited(location: visitedLocation)
            }
        }
        if !append {
            locationToAppend.datesVisited.append(Date())
            traveler.locationsVisited.append(locationToAppend)
            // CloudKit Save
            CloudKitSync.shared.createLocationVisited(location: locationToAppend)
        }

        AwardController.shared.awardBadges()
  }
  
  func addToMasterTravelerList(location: Location) {
    guard let traveler = self.masterTraveler else { return }
    var append = true
    for questListItem in traveler.locationsWishList {
        if questListItem.locationName.lowercased() == location.locationName.lowercased() {
            append = false
            print("item already exists in list")
        }
    }
    if append {
        self.masterTraveler?.locationsWishList.append(location)
        CloudKitSync.shared.createQuestItem(location: location)
        let notification = Notification(name: Notification.Name(rawValue: "wishlistUpdated"))
        NotificationCenter.default.post(notification)
    }
  }
  
    func deleteFromMasterTravelerList(location: Location) {
    guard let index = self.masterTraveler?.locationsWishList.index(of: location) else { return }
    self.masterTraveler?.locationsWishList.remove(at: index)
        CloudKitSync.shared.deleteQuestItem(location: location)
  }
  
}
