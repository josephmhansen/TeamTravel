//
//  MockData.swift
//  TeamTravel
//
//  Created by Austin Blaser on 10/26/16.
//  Copyright © 2016 Joseph Hansen. All rights reserved.
//

import Foundation
class MockData {
    
    static var badges: [Badge]{
        return []
    }
    
    static var locationsVisited:[Location]{
      return []
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
