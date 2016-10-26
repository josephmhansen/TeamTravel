//
//  AwardController.swift
//  TeamTravel
//
//  Created by Justin Carver on 10/25/16.
//  Copyright © 2016 Joseph Hansen. All rights reserved.
//

import Foundation

struct AwardController {
    
    
    //first place visited
    var babySteps: Badge
    //100 pts earned
    var seriousAdventurer: Badge
    //5 parks visited
    var notJustAnUrbanExplorer: Badge
    //5 landmarks visited
    var historicalSignificance: Badge
    //5 museums visited
    var oldBones: Badge
    //visit where it all started (DevMountain)
    var homewardBound: Badge
    //visit a non local location
    var oneSmallStep: Badge
    //visit a location twice
    var repeatOffender: Badge
    //use app for 3 months
    var loyalTraveler: Badge
    
    
    var staticBadges: [Badge]
    
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
