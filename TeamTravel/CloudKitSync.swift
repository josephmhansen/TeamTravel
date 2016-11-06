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
    
    
    func createTraveler(traveler: Traveler) {
        let newRecord = CKRecord(traveler: traveler)
        CloudKitManager.shared.saveRecord(newRecord) {
            (record, error) in
            DispatchQueue.main.async {
                if error != nil {
                    print("Error creating Traveler \(error?.localizedDescription)")
                }
                if let record = record {
                    print("record created successfully")
                    traveler.cloudKitRecordID = record.recordID.recordName
                }
            }
        }
    }
    
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
    
    func modifyLocationVisited(location: Location) {
        let modifiedRecord = CKRecord(updateVisitedLocationWithRecordID: location)
        CloudKitManager.shared.modifyRecords([modifiedRecord], perRecordCompletion: nil) {
            (records, error) in
            DispatchQueue.main.async {
                if error != nil {
                    print("Error modifying locationVisited Record \(error?.localizedDescription)")
                } else {
                    print("Success modifying record\(records?.first?.recordID.recordName)")
                }
            }
        }
    }
    
    func createQuestItem(location: Location) {
        let newRecord = CKRecord(locationQuestItem: location)
        CloudKitManager.shared.saveRecord(newRecord) {
            (record, error) in
            DispatchQueue.main.async {
                if error != nil {
                    print("Error creating questItem \(error?.localizedDescription)")
                }
                if let record = record {
                    print("record created successfully")
                    location.cloudKitRecordID = record.recordID.recordName
                }
            }
        }
    }
    
    func deleteQuestItem(location: Location) {
        if let recordID = location.cloudKitRecordID {
            let deletedRecordID = CKRecordID(recordName: recordID)
            CloudKitManager.shared.deleteRecordWithID(deletedRecordID) {
                (recordID, error) in
                DispatchQueue.main.async {
                    if error != nil {
                        print("Error, issue deleting questItem \(error?.localizedDescription)")
                        
                    } else {
                        print("success deleting \(deletedRecordID.recordName)")
                    }
                }
            }
        }
        
    }
    
    
}
