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
    
    var isSearching: Bool?
    
    var allReturnedLocations: [Location] = [] {
        didSet {
            let notification = Notification(name: Notification.Name(rawValue: "allLocationsReturned"))
            NotificationCenter.default.post(notification)
        }
    }
    
    var allVisibleLocations: [Location] {
        guard let location = CoreLocationController.shared.currentTravelerLocation else { return [] }
        let array = allReturnedLocations.filter{$0.isVisible}
        return array.sorted { $0.0.location.distance(from: location) < $0.1.location.distance(from: location)}
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
    
    func queryForLocations(location: CLLocation, completion: ((_ completion: Bool) -> Void)?) {
        if isSearching == true { print("Already Searching"); return }
        isSearching = true
        SearchLocationController.shared.allReturnedLocations = []
        let locationsTypes: [LocationType] = [LocationType.Landmarks, LocationType.Museums, LocationType.Parks]
        self.queryForLocation(ofType: locationsTypes[0], location: location, completion: { (_) in
            self.queryForLocation(ofType: locationsTypes[1], location: location, completion: { (_) in
                self.queryForLocation(ofType: locationsTypes[2], location: location, completion: { (_) in
                    self.isSearching = false
                })
            })
        })
    }
    
    func queryForLocation(ofType: LocationType, location: CLLocation, completion: @escaping (_ completion: Bool) -> Void) {
        
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
                let notification = Notification(name: Notification.Name(rawValue:"searchCategoryCompleted"))
                NotificationCenter.default.post(notification)
                completion(true)
            }
            // end dispatch
        }
    }
    
    
}
