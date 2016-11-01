//
//  StatsViewController.swift
//  TeamTravel
//
//  Created by Joseph Hansen on 11/1/16.
//  Copyright © 2016 Joseph Hansen. All rights reserved.
//

import UIKit

class StatsViewController: UIViewController {
    
    @IBOutlet var stackView: UIStackView!
    @IBOutlet var pointsView: UIView!
    @IBOutlet var badgesView: UIView!
    @IBOutlet var locationsView: UIView!
    
    @IBAction func pointsButtonTapped() {
        if pointsView.isHidden == true {
            pointsView.isHidden = false
            badgesView.isHidden = true
            locationsView.isHidden = true
        } else {
            return
        }
    }
    
    @IBAction func badgesButtonTapped() {
        if badgesView.isHidden == true {
            pointsView.isHidden = true
            badgesView.isHidden = false
            locationsView.isHidden = true
        } else {
            return
        }
    }
    
    @IBAction func locationsButtonTapped() {
        if locationsView.isHidden == true {
            pointsView.isHidden = true
            badgesView.isHidden = true
            locationsView.isHidden = false
        } else {
            return
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pointsView.isHidden = true
        badgesView.isHidden = false
        locationsView.isHidden = true
    }
}
