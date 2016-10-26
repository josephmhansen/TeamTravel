//
//  AwardController.swift
//  TeamTravel
//
//  Created by Justin Carver on 10/25/16.
//  Copyright © 2016 Joseph Hansen. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit
import CloudKit

struct AwardController {
    
    
    
//    func checkIfShouldEarnBadge(location: Location?, type: BadgeType) -> Bool {
//        
//        var bool = false
//        
//        if let traveler = TravelerController.shared.masterTraveler, let location = location, let datesVisitedLocation = location.datesVisited?.count {
//            
//            if type == BadgeType.Numbered {
//                
//                let parksVisited: [Location] = traveler.locationsVisited.filter { $0.type == LocationType.Parks }
//                let landmarksVisited: [Location] = traveler.locationsVisited.filter { $0.type == LocationType.Landmarks }
//                let museumsVisited: [Location] = traveler.locationsVisited.filter { $0.type == LocationType.Museums }
//                
//                if parksVisited.count >= 5 {
//                    bool = true
//                } else if landmarksVisited.count >= 5 {
//                    bool = true
//                } else if museumsVisited.count >= 5 {
//                    bool = true
//                }
//            }
//            
//            if type == BadgeType.FirstTime {
//                
//                if location.locationName == "Dev Mountain" {
//                    bool = true
//                } else if traveler.locationsVisited.count == 1 {
//                    bool = true
//                } else if traveler.points < 100 {
//                    bool = true
//                } else if datesVisitedLocation >= 2 {
//                    return true
//                }
//            }
//            
//            // need to change baged type to "Timed" not "Time"
//            // also need to figure out the non local location and the 3 months badges
//            
//            if type == BadgeType.Time {
//                
//            }
//        }
//        return bool
//    }
//    
//    
//    
//    
//    static var staticBadges: [Badge] {
//        //first place visited
//        var babySteps: Badge = Badge(hasEarned: true, image: <#T##UIImage?#>, name: <#T##String#>, type: <#T##BadgeType#>, shouldEarn: <#T##Bool#>, description: <#T##String#>, travelerReference: <#T##CKReference?#>, cloudKitRecordID: <#T##String?#>)
//        //100 pts earned
//        var seriousAdventurer: Badge
//        //5 parks visited
//        var notJustAnUrbanExplorer: Badge
//        //5 landmarks visited
//        var historicalSignificance: Badge
//        //5 museums visited
//        var oldBones: Badge
//        //visit where it all started (DevMountain)
//        var homewardBound: Badge
//        //visit a non local location
//        var oneSmallStep: Badge
//        //visit a location twice, limit to one badge per location, cap at two visits
//        var repeatOffender: Badge
//        //use app for 3 months
//        var loyalTraveler: Badge
//        
    
//        self.init(babySteps: babySteps, seriousAdventurer: seriousAdventurer, notJustAnUrbanExplorer: notJustAnUrbanExplorer, historicalSignificance: historicalSignificance, oldBones: oldBones, homewardBound: homewardBound, oneSmallStep: oneSmallStep, repeatOffender: repeatOffender, loyalTraveler: loyalTraveler)
        
//        return [babySteps, seriousAdventurer, notJustAnUrbanExplorer, historicalSignificance, oldBones, homewardBound, oneSmallStep, repeatOffender, loyalTraveler]
//    }
    
    
    
    
    
    static func updateTravelerPoints() -> Int {
        var points = 0
        guard let traveler = TravelerController.shared.masterTraveler else { return points }
        for location in traveler.locationsVisited {
            if location.type == LocationType.Landmarks {
                points += 2
            }
            if location.type == LocationType.Museums {
                points += 4
            }
            if location.type == LocationType.Parks {
                points += 5
            } else {
                points += 0
            }
        }
        return points
    }
}
