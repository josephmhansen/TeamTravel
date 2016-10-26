//
//  SearchLocationController.swift
//  TeamTravel
//
//  Created by Joseph Hansen on 10/26/16.
//  Copyright © 2016 Joseph Hansen. All rights reserved.
//

import Foundation
import CoreLocation

class SearchLocationController {
    
    static let shared = SearchLocationController()
    var allReturnedLocations: [Location] = []
    var allVisibleLocations: [Location] {
      return allReturnedLocations.filter{$0.isVisible}
    }
    
    
    func boxChecked(ofType: LocationType) {
      let newVisibleLocations =  allReturnedLocations.filter{$0.type == ofType}
        for location in newVisibleLocations {
            location.isVisible = true
        }
    }
    
    func boxUnchecked(ofType: LocationType) {
        let newVisibleLocations =  allReturnedLocations.filter{$0.type == ofType}
        for location in newVisibleLocations {
            location.isVisible = false
        }
    }
    
    
}
