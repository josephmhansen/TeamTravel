//
//  BadgeViewController.swift
//  TeamTravel
//
//  Created by Justin Carver on 10/31/16.
//  Copyright © 2016 Joseph Hansen. All rights reserved.
//

import UIKit

class BadgeViewController: UIViewController {
    
    var image = #imageLiteral(resourceName: "silverbadge")
    
    // MARK: - Outlets
    
    @IBOutlet var badgeImage: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    
    // MARK: - Actions
    
    @IBAction func swipeToDismissView(_ sender: Any) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - View

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
