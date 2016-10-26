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
    static let kShouldEarn = "shouldEarn"
    static let kDescription = "description"
    
    var hasEarned: Bool
    var image: UIImage?
    let name: String
    let type: BadgeType
    var shouldEarn: Bool
    let description: String
    
    let travelerReference: CKReference?
    let cloudKitRecordID: String?
    
    //checks if requirements for each badge are met, if all requirements are meet hasEarned = true

}
