//
//  BadgesCollectionViewCell.swift
//  TeamTravel
//
//  Created by Joseph Hansen on 11/1/16.
//  Copyright © 2016 Joseph Hansen. All rights reserved.
//

import UIKit

class BadgesCollectionViewCell: UICollectionViewCell {
    
    let badgeImageView = UIImageView()
    
    func updateCellWith(_ badge: Badge) {
        self.contentView.addSubview(badgeImageView)
        badgeImageView.translatesAutoresizingMaskIntoConstraints = false
        badgeImageView.contentMode = .scaleAspectFit
        let leftConstraint = NSLayoutConstraint(item: badgeImageView, attribute: .left, relatedBy: .equal, toItem: self.contentView, attribute: .left, multiplier: 1, constant: 10)
        let rightConstraint = NSLayoutConstraint(item: badgeImageView, attribute: .right, relatedBy: .equal, toItem: self.contentView, attribute: .right, multiplier: 1, constant: -10)
        let topConstraint = NSLayoutConstraint(item: badgeImageView, attribute: .top, relatedBy: .equal, toItem: self.contentView, attribute: .top, multiplier: 1, constant: 5)
        let bottomConstraint = NSLayoutConstraint(item: badgeImageView, attribute: .bottom, relatedBy: .equal, toItem: self.contentView, attribute: .bottom, multiplier: 1, constant: 5)
        self.contentView.addConstraints([leftConstraint, rightConstraint, topConstraint, bottomConstraint])
        self.badgeImageView.image = badge.image
    }
}
