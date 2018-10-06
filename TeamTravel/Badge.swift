//
//  Badge.swift
//  TeamTravel
//
//  Created by Justin Carver on 10/25/16.
//  Copyright © 2016 Joseph Hansen. All rights reserved.
//

import Foundation
import UIKit
import CloudKit

enum BadgeType {
    case FirstTime
    case Numbered
    case Time
}

class Badge {
    
    static let recordType = "Badge"
    static let kImageEndPointUrl = "imageUrl"
    static let kName = "name"
    static let kHasEarned = "hasEarned"
    static let kCategory = "category"
    
    var image: UIImage
    let name: String
    let description: String
    var hasEarned: Bool
    
    let travelerReference: CKRecord.Reference?
    let cloudKitRecordID: String?
    
    init(image: UIImage, name: String, description: String, hasEarned: Bool, travelerReference: CKRecord.Reference? = nil, cloudKitRecordID: String? = nil) {
        self.image = image
        self.name = name
        self.description = description
        self.hasEarned = hasEarned
        self.cloudKitRecordID = cloudKitRecordID
        self.travelerReference = travelerReference
    }
}
