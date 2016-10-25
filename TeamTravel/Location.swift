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

enum LocationType {
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
    var location: CLLocation
    var type: LocationType
    var hasBeenVisited: Bool = false
    var datesVisited: [Date]?
    var numberOfVisits: Int {
        return self.datesVisited?.count ?? 0
    }
    var hasVisitedToday: Bool = false
    
    var isVisible: Bool = true
    
//    let travelerReference: CKReference?
//    let cloudKitRecordID: String?
    
    init(locationName: String, coordinate: CLLocationCoordinate2D, location: CLLocation, type: LocationType) {
        self.locationName = locationName
        self.coordinate = coordinate
        self.location = location
        self.type = type
    }
}
