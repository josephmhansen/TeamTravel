//
//  CloudKitSync.swift
//  TeamTravel
//
//  Created by Joseph Hansen on 11/6/16.
//  Copyright © 2016 Joseph Hansen. All rights reserved.
//

import Foundation
import CloudKit

class CloudKitSync {
    static let shared = CloudKitSync()
    
    func createLocationVisited(location: Location) {
        let newRecord = CKRecord(locationVisited: location)
        CloudKitManager.shared.saveRecord(newRecord) {
            (record, error) in
            DispatchQueue.main.async {
                if error != nil {
                    print("Error creating location visited \(error?.localizedDescription)")
                }
                if let record = record {
                    print("record created successfully")
                    location.cloudKitRecordID = record.recordID.recordName
                    
                    
                }
            }
        }
    }
}
