//
//  MockData.swift
//  TeamTravel
//
//  Created by Austin Blaser on 10/26/16.
//  Copyright © 2016 Joseph Hansen. All rights reserved.
//

import Foundation
import CoreLocation

class MockData {
    
    static var badges: [Badge]{
        return []
    }
    
    static var locationsVisited:[Location]{
        let loc1 = Location(locationName: "Grand Canyon", location: CLLocation(latitude: 36.1128, longitude: 113.9961) , type: .Parks)
        let loc2 = Location(locationName: "Gallavan Plaza", location: CLLocation(latitude: 40.7639, longitude: 111.8911), type: .Landmarks)
        let loc3 = Location(locationName: "Temple Square", location: CLLocation(latitude: 40.7707, longitude: 111.8911), type: .Landmarks)
        let loc4 = Location(locationName: "Houston Museum of Fine Arts", location: CLLocation(latitude: 29.7256, longitude: 95.3905), type: .Museums)
        let loc5 = Location(locationName: "Potato Museum", location: CLLocation(latitude: 43.1896, longitude: 112.3437), type: .Museums)
      return [loc1, loc2, loc3, loc4, loc5]
    }
    
    static var locationsWishList: [Location]{
        return []
    }
    
    static let name = "Doctor Who"
    
    func setUpTraveler(){
        guard let location = CoreLocationController.shared.currentTravelerLocation else { return }
            let traveler = Traveler(badges: MockData.badges, locationsVisited: MockData.locationsVisited, locationsWishList: MockData.locationsWishList, homeLocation: location, name: MockData.name, cloudKitRecordID: nil)
        TravelerController.shared.masterTraveler = traveler
    }
    
    
    
}
