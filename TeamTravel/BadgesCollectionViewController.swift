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
    
    override func viewDidAppear(_ animated: Bool) {
        checkForNoBadges()
    }
    
    // MARK: - Splash screen for no badges
    func checkForNoBadges() -> Bool {
        guard let badgesToCheck = self.badges else { return false }
        var hasEarnedBadges = false
        for badge in badgesToCheck {
            if badge.hasEarned == true {
                hasEarnedBadges = true
            }
        }
        
        return hasEarnedBadges

    }
    
    func updateBackgroundView(){
        
        let noBadgeView = UIView()
        
        // Image in the background
        let bgImageView = UIImageView()
        let image = #imageLiteral(resourceName: "NoBadge")
        bgImageView.contentMode = .scaleAspectFit
        bgImageView.translatesAutoresizingMaskIntoConstraints = false
        
        bgImageView.image = image
        noBadgeView.addSubview(bgImageView)
        
        let imageTop = NSLayoutConstraint(item: bgImageView, attribute: .top, relatedBy: .equal, toItem: noBadgeView, attribute: .top, multiplier: 1.0, constant: 0.0)
        let imageLeft = NSLayoutConstraint(item: bgImageView, attribute: .left, relatedBy: .equal, toItem: noBadgeView, attribute: .left, multiplier: 1.0, constant: 8)
        let imageRight = NSLayoutConstraint(item: bgImageView, attribute: .right, relatedBy: .equal, toItem: noBadgeView, attribute: .right, multiplier: 1.0, constant: -8)
        let imageBottom = NSLayoutConstraint(item: bgImageView, attribute: .bottom, relatedBy: .equal, toItem: noBadgeView, attribute: .bottom, multiplier: 1.0, constant: 0)
        noBadgeView.addConstraints([imageTop, imageBottom, imageRight, imageLeft])

        
        // Text Label
        let label = UILabel()
        label.text = "You haven't earned any badges yet. Visit some places, start earning tokens, and we'll let you know when you earn your first badge!"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        label.layer.cornerRadius = 3
        noBadgeView.addSubview(label)
        
        let labelLeading = NSLayoutConstraint(item: label, attribute: .leading, relatedBy: .equal, toItem: noBadgeView, attribute: .leadingMargin, multiplier: 1.0, constant: 0)
        let labelTrailing = NSLayoutConstraint(item: label, attribute: .trailing, relatedBy: .equal, toItem: noBadgeView, attribute: .trailingMargin, multiplier: 1.0, constant: 0)
        let labelCenterY = NSLayoutConstraint(item: label, attribute: .centerY, relatedBy: .equal, toItem: noBadgeView, attribute: .centerY, multiplier: 1.0, constant: 0)
        noBadgeView.addConstraints([labelLeading, labelTrailing, labelCenterY])

        if let collectionView = self.collectionView {
            noBadgeView.frame = collectionView.bounds
            noBadgeView.backgroundColor = UIColor.white
            collectionView.backgroundView = noBadgeView
            
        }
        
    }
    
    func removeNoBadgeView(){
        
        if let collectionView = self.collectionView {
            collectionView.backgroundView = nil
        }
    }

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if !checkForNoBadges(){
            updateBackgroundView()
            return 0
        } else {
            removeNoBadgeView()
            return badges?.count ?? 0
        }
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
