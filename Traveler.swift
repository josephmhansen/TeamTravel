//
//  Traveler.swift
//  TeamTravel
//
//  Created by Jairo Eli de Leon on 10/26/16.
//  Copyright © 2016 Joseph Hansen. All rights reserved.
//

import UIKit
import CloudKit

struct Traveler {
  
  var badges: [Badge]
  
  var points: Int {
    return AwardController.updateTravelerPoints()
  }
  
  var locationsVisited: [Location]
  var locationsWishList: [Location]
  var homeLocation: CLLocation
  var name: String
  
  // CloudKit related
  var cloudKitRecordID: String?
  static let recordType = "Traveler"
  static let kName = "name"
  
}

