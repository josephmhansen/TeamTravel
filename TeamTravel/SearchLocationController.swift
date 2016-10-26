//
//  SearchLocationController.swift
//  TeamTravel
//
//  Created by Joseph Hansen on 10/26/16.
//  Copyright © 2016 Joseph Hansen. All rights reserved.
//

import Foundation
import MapKit

class SearchLocationController  {
    
    static let shared = SearchLocationController()
    var allReturnedLocations: [Location] = [] {
        didSet {
            let notification = Notification(name: Notification.Name(rawValue: "allLocationsReturned"))
        }
    }
    
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
    
    func queryForLocations(location: CLLocation) {
       
        SearchLocationController.shared.allReturnedLocations = []
        let locationsTypes: [LocationType] = [LocationType.Landmarks, LocationType.Museums, LocationType.Parks]
        for type in locationsTypes {
            
            queryForLocation(ofType: type, location: location)
        }
    }
    
    func queryForLocation(ofType: LocationType, location: CLLocation) {
        
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegionMake(location.coordinate, span)
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = ofType.rawValue
        request.region = region
        let search = MKLocalSearch(request: request)
        
        search.start { (searchResponses, error) in
            DispatchQueue.main.async {
                if error != nil {
                    NSLog("error searching :\(error?.localizedDescription)")
                }
                
                if let responses = searchResponses {
                    let mapItems = responses.mapItems
                    for item in mapItems {
                        guard let name = item.name,
                            let location = item.placemark.location else { return }
                        
                        let newLocation = Location(locationName: name, location: location, type: ofType)
                        SearchLocationController.shared.allReturnedLocations.append(newLocation)
                    }
                }
            }
        }
    }
    
    
}
