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

struct Badge {
    
    static let recordType = "Badge"
    static let kImageEndPointUrl = "imageUrl"
    static let kName = "name"
    static let kHasEarned = "hasEarned"
    static let kCategory = "category"
    
    var hasEarned: Bool
    let image: UIImage
    let name: String
    let type: BadgeType
    
    let travelerReference: CKReference?
    let cloudKitRecordID: String?
}
