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
    
    func fetchAllCKRecordsOnStartup(){
        //get traveler record
        //fetch locationsVisited
        TravelerController.shared.masterTraveler = Traveler()
        guard let masterTraveler = TravelerController.shared.masterTraveler else {return}
        let recordFetchedBlockVisited = {
            (record: CKRecord) in
            guard let locationVisited = Location(locationVisitedCKRecord: record) else {return}
            masterTraveler.locationsVisited.append(locationVisited)
            
        }
        CloudKitManager.shared.fetchRecordsWithType(Location.kLocationVisitedRecordType, recordFetchedBlock: recordFetchedBlockVisited){
            (records, error) in
            if error != nil {
                print("error fetching all records for locationsVisited from cloudKit \(error?.localizedDescription)")
            } else {
                print("success fetching locationsVisited")
            }
        }
        //fetch questList
        let recordFetchedBlockQuest = {
            (record: CKRecord) in
            guard let questItem = Location(locationQuestItemCKRecord: record) else {return}
            masterTraveler.locationsWishList.append(questItem)
        }
        CloudKitManager.shared.fetchRecordsWithType(Location.kLocationQuestRecordType, recordFetchedBlock: recordFetchedBlockQuest) {
            (records, error) in
            if error != nil {
                print("error fetching all records for QuestList from CloudKit \(error?.localizedDescription)")
            } else {
                print("success fetching questList Items")
            }
        }
        
        
    }
    
    
}
