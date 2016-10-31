//
//  BadgesViewController.swift
//  TeamTravel
//
//  Created by Justin Carver on 10/31/16.
//  Copyright © 2016 Joseph Hansen. All rights reserved.
//

import UIKit

class BadgesViewController: UIViewController {
    
    var image = #imageLiteral(resourceName: "silverbadge")
    var badgeTitle = ""
    var badgeDescription = ""
    
    // MARK: - Outlets
    
    @IBOutlet var babyStepsBadge: UIButton!
    @IBOutlet var historicalSignificanceBadge: UIButton!
    @IBOutlet var oneSmallStepBadge: UIButton!
    @IBOutlet var seriousAdventurerBadge: UIButton!
    @IBOutlet var oldBonesBadge: UIButton!
    @IBOutlet var repeatOffenderBadge: UIButton!
    @IBOutlet var notJustAnUrbanBadge: UIButton!
    @IBOutlet var homewardBoundBadge: UIButton!
    @IBOutlet var loyalTravelerBadge: UIButton!
    
    // MARK: - Actions

    @IBAction func babyStepsTapped() {
        image = babyStepsBadge.imageView?.image ?? #imageLiteral(resourceName: "silverbadge")
        badgeTitle = "Baby Steps"
        badgeDescription = "Visit your first location"
        performSegue(withIdentifier: "toBadgeView", sender: nil)
    }
    
    @IBAction func seriousAdventurerTapped() {
        image = seriousAdventurerBadge.imageView?.image ?? #imageLiteral(resourceName: "silverbadge")
        badgeTitle = "Serious Adventurer"
        badgeDescription = "Earn 100 points"
        performSegue(withIdentifier: "toBadgeView", sender: nil)
    }
    
    @IBAction func notJustAnUrbanBadgeTapped() {
        image = notJustAnUrbanBadge.imageView?.image ?? #imageLiteral(resourceName: "silverbadge")
        badgeTitle = "Serious Adventurer"
        badgeDescription = "Visit 5 parks"
        performSegue(withIdentifier: "toBadgeView", sender: nil)
    }
    
    @IBAction func historicalSignificanceBadgeTapped() {
        image = historicalSignificanceBadge.imageView?.image ?? #imageLiteral(resourceName: "silverbadge")
        badgeTitle = "Historical Significance"
        badgeDescription = "Visit 5 landmarks"
        performSegue(withIdentifier: "toBadgeView", sender: nil)
    }
    
    @IBAction func oldBonesTapped() {
        image = oldBonesBadge.imageView?.image ?? #imageLiteral(resourceName: "silverbadge")
        badgeTitle = "Old Bones"
        badgeDescription = "Visit 5 museums"
        performSegue(withIdentifier: "toBadgeView", sender: nil)
    }
    
    @IBAction func homewardBoundTapped() {
        image = homewardBoundBadge.imageView?.image ?? #imageLiteral(resourceName: "silverbadge")
        badgeTitle = "Homeward Bound"
        badgeDescription = "Visit where it all started"
        performSegue(withIdentifier: "toBadgeView", sender: nil)
    }
    
    @IBAction func oneSmallStepTapped() {
        image = oneSmallStepBadge.imageView?.image ?? #imageLiteral(resourceName: "silverbadge")
        badgeTitle = "One Small Step..."
        badgeDescription = "Visit an non-local location"
        performSegue(withIdentifier: "toBadgeView", sender: nil)
    }
    
    @IBAction func repeatOffenderTapped() {
        image = repeatOffenderBadge.imageView?.image ?? #imageLiteral(resourceName: "silverbadge")
        badgeTitle = "Repeat Offender"
        badgeDescription = "Visit a location twice"
        performSegue(withIdentifier: "toBadgeView", sender: nil)
    }
    
    @IBAction func loyalTravelerTapped() {
        image = loyalTravelerBadge.imageView?.image ?? #imageLiteral(resourceName: "silverbadge")
        badgeTitle = "Loyal Traveler"
        badgeDescription = "Be a traveler for 3 months"
        performSegue(withIdentifier: "toBadgeView", sender: nil)
    }
    
    // MARK: - View
    // MARK: - Need Badges to complete
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let adventurer = TravelerController.shared.masterTraveler else { return }
        
        if adventurer.badges[0].hasEarned == true {
            
            // silver badge is just a placeholder for now
            
            babyStepsBadge.imageView?.image = #imageLiteral(resourceName: "silverbadge")
        }
        
        if adventurer.badges[1].hasEarned == true {
            seriousAdventurerBadge.imageView?.image = #imageLiteral(resourceName: "silverbadge")
        }
        
        if adventurer.badges[2].hasEarned == true {
            notJustAnUrbanBadge.imageView?.image = #imageLiteral(resourceName: "silverbadge")
        }
        
        if adventurer.badges[3].hasEarned == true {
            historicalSignificanceBadge.imageView?.image = #imageLiteral(resourceName: "silverbadge")
        }
        
        if adventurer.badges[4].hasEarned == true {
            oldBonesBadge.imageView?.image = #imageLiteral(resourceName: "silverbadge")
        }
        
        if adventurer.badges[5].hasEarned == true {
            homewardBoundBadge.imageView?.image = #imageLiteral(resourceName: "silverbadge")
        }
        
        if adventurer.badges[6].hasEarned == true {
            oneSmallStepBadge.imageView?.image = #imageLiteral(resourceName: "silverbadge")
        }
        
        if adventurer.badges[7].hasEarned == true {
            repeatOffenderBadge.imageView?.image = #imageLiteral(resourceName: "silverbadge")
        }
        
        if adventurer.badges[8].hasEarned == true {
            loyalTravelerBadge.imageView?.image = #imageLiteral(resourceName: "silverbadge")
        }
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toBadgeView" {
            let badgeController = segue.destination as? BadgeViewController
            badgeController?.image = image
            badgeController?.badgeTitle = badgeTitle
            badgeController?.badgeDescription = badgeDescription
        }
    }
}
