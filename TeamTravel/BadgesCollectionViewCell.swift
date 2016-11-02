//
//  BadgesCollectionViewCell.swift
//  TeamTravel
//
//  Created by Joseph Hansen on 11/1/16.
//  Copyright © 2016 Joseph Hansen. All rights reserved.
//

import UIKit

class BadgesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var badgeImageView: UIImageView!
    
    func updateCellWith(_ badge: Badge) {
        badgeImageView.image = badge.image
    }
    
}
