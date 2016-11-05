//
//  Location.swift
//  TeamTravel
//
//  Created by Justin Carver on 10/25/16.
//  Copyright © 2016 Joseph Hansen. All rights reserved.
//

import Foundation
import MapKit
import CloudKit

enum LocationType: String {
    case Landmarks
    case Museums
    case Parks
}

class Location: NSObject, MKAnnotation {
    
    static let recordType = "Location"
    static let kCoordinate = "coordinate"
    static let KCategoryType = "category"
    static let kHasBeenVisited = "hasBeenVisited"
    static let kDatesVisited = "datesVisited"
    static let kHasVisitedToday = "hasVisitedToday"
    
    var locationName: String
    var coordinate: CLLocationCoordinate2D
    var title: String? {
        return locationName
    }
    var location: CLLocation
    var type: LocationType
    var hasBeenVisited: Bool = false
    var datesVisited: [Date]?
    var numberOfVisits: Int {
        return self.datesVisited?.count ?? 0
    }
    var hasVisitedToday: Bool = false
    
    var isVisible: Bool = true
// geo fence radius to change for different locationtypes
    var geoRadiusSize: CLLocationDistance {
        switch type {
        case .Landmarks:
            return 50
        case .Parks:
            return 150
        case .Museums:
            return 100
        }
    } // in meters
    
    
    
//    let travelerReference: CKReference?
//    let cloudKitRecordID: String?
    
    init(locationName: String, location: CLLocation, type: LocationType) {
        self.locationName = locationName
        self.coordinate = location.coordinate
        self.location = location
        self.type = type
    }
    
    
    
    func createRegion() -> CLCircularRegion {
        let region = CLCircularRegion(center: self.coordinate, radius: self.geoRadiusSize, identifier: self.locationName)
        
        region.notifyOnEntry = true
        //region.notifyOnExit = true
        return region
    }
    
}


