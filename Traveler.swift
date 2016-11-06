//
//  Traveler.swift
//  TeamTravel
//
//  Created by Jairo Eli de Leon on 10/26/16.
//  Copyright © 2016 Joseph Hansen. All rights reserved.
//

import UIKit
import CloudKit

class Traveler {
  
    var badges: [Badge] = AwardController.staticBadges
  
    var points: Int {
        return AwardController.updateTravelerPoints().points
    }
  
    var locationsVisited: [Location] = [] {
        didSet {
            DispatchQueue.main.async {
                let notification = Notification(name: Notification.Name(rawValue: "locationsVisitedUpdated"))
                NotificationCenter.default.post(notification)
                
            }
        }
    }
    
    var locationsWishList: [Location] = []
    var homeLocation: CLLocation?
    var name: String
  
    // CloudKit related
    var cloudKitRecordID: String?
    static let recordType = "Traveler"
    static let kName = "name"
    static let kHomeLocation = "homeLocation"
    
    
    init(homeLocation: CLLocation? = nil, name: String = "", locationsVisited: [Location] = [], locationWishList: [Location] = [], cloudKitRecordID: String? = nil) {
        self.homeLocation = homeLocation
        self.name = name
        self.locationsVisited = locationsVisited
        self.locationsWishList = locationWishList
        self.cloudKitRecordID = cloudKitRecordID
    }
  
}

extension CKRecord {
    convenience init(_ traveler: Traveler) {
        self.init(recordType: Traveler.recordType)
        
        
        
    }
    
    convenience init(updatedTravelerWithRecordID: Traveler) {
        let recordID = CKRecordID(recordName: updatedTravelerWithRecordID.cloudKitRecordID!)
        self.init(recordType: Traveler.recordType, recordID: recordID)
        
        
        
    }
}

extension Traveler {
    convenience init?(record: CKRecord) {
        if record.recordType != Traveler.recordType {
            return nil
        } else {
            self.init(cloudKitRecordID: record.recordID.recordName)
            
        }
    }
    
}

