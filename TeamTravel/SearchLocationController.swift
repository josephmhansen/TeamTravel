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
    
    // MARK: - Properties
    
    static let shared = SearchLocationController()
    
    let locationsTypes: [LocationType] = [LocationType.Landmarks, LocationType.Museums, LocationType.Parks]
    
    var isSearching: Bool?
    
    var allReturnedLocations: [Location] = [] {
        didSet {
            let notification = Notification(name: Notification.Name(rawValue: "allLocationsReturned"))
            NotificationCenter.default.post(notification)
        }
    }
    
    var allVisibleLocations: [Location] {
        guard let location = CoreLocationController.shared.currentTravelerLocationForDistance else { return [] }
        let array = allReturnedLocations.filter{$0.isVisible}
        return array.sorted { $0.location.distance(from: location) < $1.location.distance(from: location)}
    }
    
    // MARK: - Manipulate Visible locations
    func resetAllToVisible(){
        for type in locationsTypes {
            setVisible(ofType: type)
        }
    }
    
    func resetAllToInvisible(){
        for type in locationsTypes{
            setInvisible(ofType: type)
        }
    }
    
    func setVisible(ofType: LocationType) {
        let newVisibleLocations =  allReturnedLocations.filter{$0.type == ofType}
        for location in newVisibleLocations {
            location.isVisible = true
        }
    }
    
    func setInvisible(ofType: LocationType) {
        let newVisibleLocations =  allReturnedLocations.filter{$0.type == ofType}
        for location in newVisibleLocations {
            location.isVisible = false
        }
    }
    
    // MARK: - Search functions
    func queryForLocations(location: CLLocation, completion: ((_ completion: Bool) -> Void)?) {
        if isSearching == true { print("Already Searching"); return }
        isSearching = true
        SearchLocationController.shared.allReturnedLocations = []
        self.queryForLocation(ofType: self.locationsTypes[0], location: location, completion: { (_) in
            self.queryForLocation(ofType: self.locationsTypes[1], location: location, completion: { (_) in
                self.queryForLocation(ofType: self.locationsTypes[2], location: location, completion: { (_) in
                    DispatchQueue.main.async{
//                    self.isSearching = false
//                    
//                    // Make call to listening functions: Geofencing, tableview updates, etc.
//                        completion!(true)
//                        let notification = Notification(name: Notification.Name(rawValue:"searchCategoryCompleted"))
//                        NotificationCenter.default.post(notification)
                    }
                })
            })
        })
    }
    
    func queryForLocation(ofType: LocationType, location: CLLocation, completion: @escaping (_ completion: Bool) -> Void) {
        
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion.init(center: location.coordinate, span: span)
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = ofType.rawValue
        request.region = region
        let search = MKLocalSearch(request: request)
        
        search.start { (searchResponses, error) in
            DispatchQueue.main.async {
                if error != nil {
                    NSLog("error searching :\(error?.localizedDescription ?? "")")
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
                if ofType == self.locationsTypes.last {
                    self.doneSearchingAllCategories()
                }
//                let notification = Notification(name: Notification.Name(rawValue:"searchCategoryCompleted"))
//                NotificationCenter.default.post(notification)
                completion(true)
            }
            // end dispatch
        }
    }
    
    /// Posts notification that draws map annotations and configures the geofences.
    func doneSearchingAllCategories(){
        DispatchQueue.main.async {
            self.isSearching = false
            let notification = Notification(name: Notification.Name(rawValue:"searchCategoryCompleted"))
            NotificationCenter.default.post(notification)
        }
    }
    
    // MARK: - Helper functions for TravelerController
    func locationFromRegion(identifier: String) -> Location? {
        let results = SearchLocationController.shared.allReturnedLocations.filter {
            $0.locationName.lowercased() == identifier.lowercased() }
        guard let location = results.first else { return nil }
        return location
    }
    
}
