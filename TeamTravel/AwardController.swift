//
//  AwardController.swift
//  TeamTravel
//
//  Created by Justin Carver on 10/25/16.
//  Copyright © 2016 Joseph Hansen. All rights reserved.
//

import Foundation

struct AwardController {
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
