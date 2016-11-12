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
    
    
    static let kLocationVisitedRecordType = "locationVisited"
    static let kLocationQuestRecordType = "locationQuestItem"
    
    static let kCLLocation = "location"
    static let KCategoryType = "category"
    static let kLocationName = "locationName"
    
    static let kHasBeenVisited = "hasBeenVisited"
    static let kDatesVisited = "datesVisited"
    static let kHasVisitedToday = "hasVisitedToday"
    
    var locationName: String
    var coordinate: CLLocationCoordinate2D
    var title: String? {
        return locationName
    }
    var subtitle: String? {
        switch self.type {
        case .Landmarks:
            return "Landmark"
        case .Museums:
            return "Museum"
        case .Parks:
            return "Park"
        }
    }
    var cloudKitRecordID: String?
    var location: CLLocation
    var type: LocationType
    var hasBeenVisited: Bool = false
    var datesVisited: [Date] = []
    var numberOfVisits: Int {
        return self.datesVisited.count
    }
    var calendar: Calendar = Calendar(identifier: .gregorian)
    var hasVisitedToday: Bool {
        if datesVisited.count != 0 {
            let filteredDates = datesVisited.sorted { $0.0 > $0.1}
            if calendar.isDateInToday(filteredDates[0]) {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }

    var isVisible: Bool = true
// geo fence radius to change for different locationtypes
    var geoRadiusSize: CLLocationDistance {
        switch type {
        case .Landmarks:
            return 18
        case .Parks:
            return 33
        case .Museums:
            return 18
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

extension CKRecord {
    convenience init(locationVisited: Location) {
        self.init(recordType: Location.kLocationVisitedRecordType)
        self[Location.kLocationName] = locationVisited.locationName as CKRecordValue?
        self[Location.kCLLocation] = locationVisited.location as CKRecordValue?
        self[Location.KCategoryType] = locationVisited.type.rawValue as CKRecordValue?
        self[Location.kDatesVisited] = locationVisited.datesVisited as CKRecordValue?
    }
    
    convenience init(updateVisitedLocationWithRecordID: Location) {
        let recordID = CKRecordID(recordName: updateVisitedLocationWithRecordID.cloudKitRecordID!)
        self.init(recordType: Location.kLocationVisitedRecordType, recordID: recordID)
        self[Location.kLocationName] = updateVisitedLocationWithRecordID.locationName as CKRecordValue?
        self[Location.kCLLocation] = updateVisitedLocationWithRecordID.location as CKRecordValue?
        self[Location.KCategoryType] = updateVisitedLocationWithRecordID.type.rawValue as CKRecordValue?
        self[Location.kDatesVisited] = updateVisitedLocationWithRecordID.datesVisited as CKRecordValue?
    }
    
}

extension CKRecord {
    convenience init(locationQuestItem: Location) {
        self.init(recordType: Location.kLocationQuestRecordType)
        self[Location.kLocationName] = locationQuestItem.locationName as CKRecordValue?
        self[Location.kCLLocation] = locationQuestItem.location as CKRecordValue?
        self[Location.KCategoryType] = locationQuestItem.type.rawValue as CKRecordValue?
        
    }
}

extension Location {
    convenience init?(locationVisitedCKRecord: CKRecord) {
        if locationVisitedCKRecord.recordType != Location.kLocationVisitedRecordType {
            return nil
        } else {
            guard let visitedLocationName = locationVisitedCKRecord[Location.kLocationName] as? String,
                let visitedLocation = locationVisitedCKRecord[Location.kCLLocation] as? CLLocation,
                let visitedLocationTypeString = locationVisitedCKRecord[Location.KCategoryType] as? String,
                let visitedLocationType = LocationType(rawValue: visitedLocationTypeString),
                let visitedLocationDatesVisited = locationVisitedCKRecord[Location.kDatesVisited] as? [Date] else {
                    return nil
            }
            self.init(locationName: visitedLocationName, location: visitedLocation, type: visitedLocationType)
            self.datesVisited = visitedLocationDatesVisited
            self.cloudKitRecordID = locationVisitedCKRecord.recordID.recordName
        }
    }
    
    convenience init?(locationQuestItemCKRecord: CKRecord) {
        if locationQuestItemCKRecord.recordType != Location.kLocationQuestRecordType {
            return nil
        } else {
            guard let questItemName = locationQuestItemCKRecord[Location.kLocationName] as? String,
            let questItemLocation = locationQuestItemCKRecord[Location.kCLLocation] as? CLLocation,
            let questItemTypeString = locationQuestItemCKRecord[Location.KCategoryType] as? String,
                let questItemType = LocationType(rawValue: questItemTypeString) else {
                    return nil
            }
            self.init(locationName: questItemName, location: questItemLocation, type: questItemType)
            self.cloudKitRecordID = locationQuestItemCKRecord.recordID.recordName
        }
    }
}
