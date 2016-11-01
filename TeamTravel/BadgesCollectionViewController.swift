//
//  BadgesCollectionViewController.swift
//  TeamTravel
//
//  Created by Joseph Hansen on 11/1/16.
//  Copyright © 2016 Joseph Hansen. All rights reserved.
//

import UIKit

private let reuseIdentifier = "badgeCell"

class BadgesCollectionViewController: UICollectionViewController {
    
    var image = #imageLiteral(resourceName: "silverbadge")
    var badgeTitle = ""
    var badgeDescription = ""
    
    let badges = TravelerController.shared.masterTraveler?.badges

    override func viewDidLoad() {
        super.viewDidLoad()
        let layout = UICollectionViewLayout()
    
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return badges?.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? BadgesCollectionViewCell, let badges = badges else { return UICollectionViewCell() }
        
        let badge = badges[indexPath.item]
        
        cell.updateCellWith(badge)
        
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let badges = badges else { return }
        let badge = badges[indexPath.item]
        self.badgeDescription = badge.description
        self.image = badge.image!
        
        performSegue(withIdentifier: "toBadgeDesctiption", sender: nil)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toBadgeDesctiption" {
            let viewController = segue.destination as? BadgeDetailViewController
            viewController?.badgeImage.image = self.image
            viewController?.badgeTitle = self.badgeTitle
            viewController?.badgeDescription = self.badgeDescription
        }
    }
}
