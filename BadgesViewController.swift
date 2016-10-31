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
    
    @IBOutlet var babyStepsBadge: UIImageView!
    @IBOutlet var historicalSignificanceBadge: UIImageView!
    @IBOutlet var oneSmallStepBadge: UIImageView!
    @IBOutlet var seriousAdventurerBadge: UIImageView!
    @IBOutlet var oldBonesBadge: UIImageView!
    @IBOutlet var repeatOffenderBadge: UIImageView!
    @IBOutlet var notJustAnUrbanBadge: UIImageView!
    @IBOutlet var homewardBoundBadge: UIImageView!
    @IBOutlet var loyalTravelerBadge: UIImageView!
    
    // MARK: - Actions

    @IBAction func babyStepsTapped(_ sender: Any) {
        image = babyStepsBadge.image ?? #imageLiteral(resourceName: "silverbadge")
        badgeTitle = "Baby Steps"
        badgeDescription = "Visit your first location"
        performSegue(withIdentifier: "toBadgeView", sender: nil)
    }
    
    @IBAction func seriousAdventurerTapped(_ sender: Any) {
        image = seriousAdventurerBadge.image ?? #imageLiteral(resourceName: "silverbadge")
        badgeTitle = "Serious Adventurer"
        badgeDescription = "Earn 100 points"
        performSegue(withIdentifier: "toBadgeView", sender: nil)
    }
    
    @IBAction func notJustAnUrbanBadgeTapped(_ sender: Any) {
        image = notJustAnUrbanBadge.image ?? #imageLiteral(resourceName: "silverbadge")
        badgeTitle = "Serious Adventurer"
        badgeDescription = "Visit 5 parks"
        performSegue(withIdentifier: "toBadgeView", sender: nil)
    }
    
    @IBAction func historicalSignificanceBadgeTapped(_ sender: Any) {
        image = historicalSignificanceBadge.image ?? #imageLiteral(resourceName: "silverbadge")
        badgeTitle = "Historical Significance"
        badgeDescription = "Visit 5 landmarks"
        performSegue(withIdentifier: "toBadgeView", sender: nil)
    }
    
    @IBAction func oldBonesTapped(_ sender: Any) {
        image = oldBonesBadge.image ?? #imageLiteral(resourceName: "silverbadge")
        badgeTitle = "Old Bones"
        badgeDescription = "Visit 5 museums"
        performSegue(withIdentifier: "toBadgeView", sender: nil)
    }
    
    @IBAction func homewardBoundTapped(_ sender: Any) {
        image = homewardBoundBadge.image ?? #imageLiteral(resourceName: "silverbadge")
        badgeTitle = "Homeward Bound"
        badgeDescription = "Visit where it all started"
        performSegue(withIdentifier: "toBadgeView", sender: nil)
    }
    
    @IBAction func oneSmallStepTapped(_ sender: Any) {
        image = oneSmallStepBadge.image ?? #imageLiteral(resourceName: "silverbadge")
        badgeTitle = "One Small Step..."
        badgeDescription = "Visit an non-local location"
        performSegue(withIdentifier: "toBadgeView", sender: nil)
    }
    
    @IBAction func repeatOffenderTapped(_ sender: Any) {
        image = repeatOffenderBadge.image ?? #imageLiteral(resourceName: "silverbadge")
        badgeTitle = "Repeat Offender"
        badgeDescription = "Visit a location twice"
        performSegue(withIdentifier: "toBadgeView", sender: nil)
    }
    
    @IBAction func loyalTravelerTapped(_ sender: Any) {
        image = loyalTravelerBadge.image ?? #imageLiteral(resourceName: "silverbadge")
        badgeTitle = "Loyal Traveler"
        badgeDescription = "Be a traveler for 3 months"
        performSegue(withIdentifier: "toBadgeView", sender: nil)
    }
    
    
    // MARK: - View
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Need Badges to complete
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let adventurer = TravelerController.shared.masterTraveler else { return }
        
        if adventurer.badges[1].hasEarned == true {
            
            // silver badge is just a placeholder for now
            
            babyStepsBadge.image = #imageLiteral(resourceName: "silverbadge")
        }
        
        if adventurer.badges[2].hasEarned == true {
            seriousAdventurerBadge.image = #imageLiteral(resourceName: "silverbadge")
        }
        
        if adventurer.badges[3].hasEarned == true {
            notJustAnUrbanBadge.image = #imageLiteral(resourceName: "silverbadge")
        }
        
        if adventurer.badges[4].hasEarned == true {
            historicalSignificanceBadge.image = #imageLiteral(resourceName: "silverbadge")
        }
        
        if adventurer.badges[5].hasEarned == true {
            oldBonesBadge.image = #imageLiteral(resourceName: "silverbadge")
        }
        
        if adventurer.badges[6].hasEarned == true {
            homewardBoundBadge.image = #imageLiteral(resourceName: "silverbadge")
        }
        
        if adventurer.badges[7].hasEarned == true {
            oneSmallStepBadge.image = #imageLiteral(resourceName: "silverbadge")
        }
        
        if adventurer.badges[8].hasEarned == true {
            repeatOffenderBadge.image = #imageLiteral(resourceName: "silverbadge")
        }
        
        if adventurer.badges[9].hasEarned == true {
            loyalTravelerBadge.image = #imageLiteral(resourceName: "silverbadge")
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
