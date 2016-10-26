//
//  TravelerController.swift
//  TeamTravel
//
//  Created by Jairo Eli de Leon on 10/26/16.
//  Copyright © 2016 Joseph Hansen. All rights reserved.
//

import UIKit
import CloudKit

struct TravelerController {
  
  var masterTraveler: Traveler?
  
  static let shared = TravelerController()
  
  mutating func addVisited(location: Location, toTraveler: Traveler) {
    // We might be able to flesh these out to.
    self.masterTraveler?.locationsVisited.append(location)
  }
  
  mutating func addToMasterTravelerList(location: Location) {
    self.masterTraveler?.locationsWishList.append(location)
  }
  
  mutating func deleteFromMasterTravelerList(location: Location) {
    guard let index = self.masterTraveler?.locationsWishList.index(of: location) else { return }
    self.masterTraveler?.locationsVisited.remove(at: index)
  }
  
}
