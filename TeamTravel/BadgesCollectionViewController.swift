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
        
        collectionView?.reloadData()
        guard collectionView != nil else { return }
        
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
        layout.itemSize = CGSize(width: (screenWidth) / 3, height: (screenHeight - 85) / 4)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionView?.collectionViewLayout = layout
        
        self.collectionView?.register(BadgesCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return badges?.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? BadgesCollectionViewCell, let badges = badges else { return BadgesCollectionViewCell() }
        
        let badge = badges[indexPath.item]
        
        cell.updateCellWith(badge)
        
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let badges = badges else { return }
        let badge = badges[indexPath.item]
        self.badgeDescription = badge.description
        self.badgeTitle = badge.name
        self.image = badge.image
        
        performSegue(withIdentifier: "toBadgeDescription", sender: nil)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toBadgeDescription" {
            let viewController = segue.destination as? BadgeDetailViewController
            viewController?.image = self.image
            viewController?.badgeTitle = self.badgeTitle
            viewController?.badgeDescription = self.badgeDescription
        }
    }
}
