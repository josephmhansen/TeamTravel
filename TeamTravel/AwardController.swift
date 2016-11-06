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
let downloadDate: Date = Date()
struct AwardController {
    
    static let shared = AwardController()
    
    let babyStepsBadge = Badge(image: #imageLiteral(resourceName: "silverbadge"), name: "Baby Steps", description: "Visit your first location", hasEarned: false)
    let seriousExplorerBadge = Badge(image: #imageLiteral(resourceName: "silverbadge"), name: "Serious Explorer", description: "Earn 100 points", hasEarned: false)
    let notJustAnUrbanBadge = Badge(image: #imageLiteral(resourceName: "silverbadge"), name: "Not Just an Urban Explorer", description: "Visit 5 parks", hasEarned: false)
    let historicalSignificanceBadge = Badge(image: #imageLiteral(resourceName: "silverbadge"), name: "Historical Significance", description: "Visit 5 landmarks", hasEarned: false)
    let oldBonesBadge = Badge(image: #imageLiteral(resourceName: "silverbadge"), name: "Old Bones", description: "Visit 5 museums", hasEarned: false)
    let homewardBoundBadge = Badge(image: #imageLiteral(resourceName: "silverbadge"), name: "Homeward Bound", description: "Visit the place where it all started", hasEarned: false)
    let oneSmallStepBadge = Badge(image: #imageLiteral(resourceName: "silverbadge"), name: "One Small Step…", description: "Visit a nonlocal location", hasEarned: false)
    let repeatOffenderBadge = Badge(image: #imageLiteral(resourceName: "silverbadge"), name: "Repeat Offender", description: "Visit a location twice", hasEarned: false)
    let loyalTravelerBadge = Badge(image: #imageLiteral(resourceName: "silverbadge"), name: "Loyal Traveler", description: "Be a traveler for 3 months", hasEarned: false)
    
    static func updateTravelerPoints() -> (points: Int, pointsArray: [Int]) {
        var points = 0
        var pointsArray: [Int] = []
        guard let traveler = TravelerController.shared.masterTraveler else { return (points, pointsArray) }
        for location in traveler.locationsVisited {
            if location.type == LocationType.Landmarks {
                points += 2
                pointsArray.append(2)
            }
            else if location.type == LocationType.Museums {
                points += 4
                pointsArray.append(4)
            }
            else if location.type == LocationType.Parks {
                points += 5
                pointsArray.append(5)
            } //else {
            //                points += 0
            //                pointsArray.append(0)
            //            }
        }
        return (points, pointsArray)
    }
    
    func awardBadges() {
        awardBabySteps()
        awardSeriousAdventurer()
        awardNotJustAnUrbanExplorer()
        awardHistoricalSignificance()
        awardOldBones()
        awardHomewardBound()
        awardOneSmallStep()
        awardRepeatOffender()
        awardLoyalTraveler()
    }
    
    func awardBabySteps() {
        guard let traveler = TravelerController.shared.masterTraveler, babyStepsBadge.hasEarned == false else { return }
        if traveler.locationsVisited.count >= 1 {
            babyStepsBadge.hasEarned = true
            babyStepsBadge.image = #imageLiteral(resourceName: "Baby Step")
        }
    }
    
    func awardSeriousAdventurer() {
        guard seriousExplorerBadge.hasEarned == false, let traveler = TravelerController.shared.masterTraveler else { return }
        if traveler.points >= 100 {
            seriousExplorerBadge.hasEarned = true
            seriousExplorerBadge.image = #imageLiteral(resourceName: "Serious Adventurer")
        }
    }
    
    func awardNotJustAnUrbanExplorer() {
        guard let traveler = TravelerController.shared.masterTraveler, notJustAnUrbanBadge.hasEarned == false else { return }
        let parksVisited = traveler.locationsVisited.filter { $0.type == LocationType.Parks }
        if parksVisited.count >= 5 {
            notJustAnUrbanBadge.hasEarned = true
            notJustAnUrbanBadge.image = #imageLiteral(resourceName: "Not just an urban explorer")
        }
    }
    
    func awardHistoricalSignificance() {
        guard let traveler = TravelerController.shared.masterTraveler, historicalSignificanceBadge.hasEarned == false else { return }
        let landmarksVisited = traveler.locationsVisited.filter { $0.type == LocationType.Landmarks }
        if landmarksVisited.count >= 5 {
            historicalSignificanceBadge.hasEarned = true
            historicalSignificanceBadge.image = #imageLiteral(resourceName: "Historical Significance")
        }
    }
    
    func awardOldBones() {
        guard let traveler = TravelerController.shared.masterTraveler, oldBonesBadge.hasEarned == false else { return }
        let museumsVisited = traveler.locationsVisited.filter { $0.type == LocationType.Museums }
        if museumsVisited.count >= 5 {
            oldBonesBadge.hasEarned = true
            oldBonesBadge.image = #imageLiteral(resourceName: "Old Bones")
        }
    }
    
    func awardHomewardBound() {
        guard let traveler = TravelerController.shared.masterTraveler, homewardBoundBadge.hasEarned == false else { return }
        if traveler.locationsVisited.last?.locationName == "Dev Mountain" {
            homewardBoundBadge.hasEarned = true
            homewardBoundBadge.image = #imageLiteral(resourceName: "Homeward Bound")
        }
    }
    
    func awardOneSmallStep() {
        guard let traveler = TravelerController.shared.masterTraveler, oneSmallStepBadge.hasEarned == false else { return }
        let LocationDistance = CLLocationDistance(1000)
        guard let homeLocation = traveler.homeLocation else { return }
        if let distance = traveler.locationsVisited.last?.location.distance(from: homeLocation), distance >= LocationDistance {
            oneSmallStepBadge.hasEarned = true
            homewardBoundBadge.image = #imageLiteral(resourceName: "Homeward Bound")
        }
    }
    
    func awardRepeatOffender() {
        guard let traveler = TravelerController.shared.masterTraveler, repeatOffenderBadge.hasEarned == false, let datesVisited = traveler.locationsVisited.last?.datesVisited else { return }
        if datesVisited.count >= 2 {
            repeatOffenderBadge.hasEarned = true
            repeatOffenderBadge.image = #imageLiteral(resourceName: "Repeat Offender")
        }
    }
    
    func awardLoyalTraveler() {
        
    }
}
extension AwardController {
    
    static let staticBadges: [Badge] = [AwardController.shared.babyStepsBadge, AwardController.shared.seriousExplorerBadge, AwardController.shared.notJustAnUrbanBadge, AwardController.shared.historicalSignificanceBadge, AwardController.shared.oldBonesBadge, AwardController.shared.homewardBoundBadge, AwardController.shared.oneSmallStepBadge, AwardController.shared.repeatOffenderBadge, AwardController.shared.loyalTravelerBadge]
}
