//
//  PrimaryTransitionTargetViewController.swift
//  TeamTravelMapViewTest
//
//  Created by Joseph Hansen on 10/29/16.
//  Copyright © 2016 Joseph Hansen. All rights reserved.
//

import UIKit

class PrimaryTransitionTargetViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func goBackButtonPressed(sender: AnyObject) {
        
        if let drawer = self.parent as? LocationMapViewController
        {
            let primaryContent = UIStoryboard(name: "MainMapView", bundle: nil).instantiateViewController(withIdentifier: "PrimaryContentViewController")
            
            drawer.setPrimaryContentViewController(controller: primaryContent, animated: true)
        }
    }
}
