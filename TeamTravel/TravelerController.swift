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
            }
        }
        if !append {
            locationToAppend.datesVisited.append(Date())
            traveler.locationsVisited.append(locationToAppend)
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
