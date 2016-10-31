//
//  PointsGraphViewController.swift
//  TeamTravel
//
//  Created by Justin Carver on 10/28/16.
//  Copyright © 2016 Joseph Hansen. All rights reserved.
//

import UIKit

class PointsGraphViewController: UIViewController {
    let graphViewBox = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(setupUser), name: Notification.Name(rawValue: "currentLocationUpdated"), object: nil)
        
        configureGraphViewBox()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        configurePointsGraph()
    }
    
    func setupUser(){
        if TravelerController.shared.masterTraveler == nil {
        MockData.shared.setUpTraveler()
        }
    }
    
    func configureGraphViewBox(){
        graphViewBox.translatesAutoresizingMaskIntoConstraints = false
        graphViewBox.backgroundColor = UIColor.green
        self.view.addSubview(graphViewBox)
        
        let viewTop = NSLayoutConstraint(item: graphViewBox, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .topMargin, multiplier: 1.0, constant: 8)
        let viewLeading = NSLayoutConstraint(item: graphViewBox, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leadingMargin, multiplier: 1.0, constant: 0)
        let viewTrailing = NSLayoutConstraint(item: graphViewBox, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailingMargin, multiplier: 1.0, constant: 0)
        let viewBottom = NSLayoutConstraint(item: graphViewBox, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottomMargin, multiplier: 1.0, constant: -8)
        self.view.addConstraints([viewTop, viewLeading, viewTrailing, viewBottom])
    }
    
    func configurePointsGraph(){
        
    }
    
    
    
}
