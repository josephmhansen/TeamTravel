//
//  PrimaryContentViewController.swift
//  TeamTravelMapViewTest
//
//  Created by Joseph Hansen on 10/29/16.
//  Copyright © 2016 Joseph Hansen. All rights reserved.
//

import UIKit
import MapKit

class PrimaryContentViewController: UIViewController, PulleyPrimaryContentControllerDelegate {
    
    @IBOutlet var mapView: MKMapView!

    @IBOutlet var temperatureLabel: UILabel!
    
    @IBOutlet var temperatureLabelBottomConstraint: NSLayoutConstraint!
    
    private let temperatureLabelBottomDistance: CGFloat = 8.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CoreLocationController.shared.getCurrentLocation()
        
        NotificationCenter.default.addObserver(self, selector: #selector(zoomToUserLocation), name: Notification.Name(rawValue: "currentLocationUpdated"), object: nil)
        
        
        temperatureLabel.layer.cornerRadius = 7.0
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        Uncomment if you want to change the visual effect style to dark. Note: The rest of the sample app's UI isn't made for dark theme. This just shows you how to do it.
//        if let drawer = self.parent as? PulleyViewController
//        {
//            drawer.drawerBackgroundVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func zoomToUserLocation() {
        if let location = CoreLocationController.shared.currentTravelerLocation {
            let span = MKCoordinateSpanMake(0.05, 0.05)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            self.mapView.setRegion(region, animated: true)
        }
    }
    
    func makeUIAdjustmentsForFullscreen(progress: CGFloat)
    {
        //
    }
    
    func drawerChangedDistanceFromBottom(drawer: LocationMapViewController, distance: CGFloat)
    {
        if distance <= 360.0
        {
            temperatureLabelBottomConstraint.constant = distance + temperatureLabelBottomDistance
        }
        else
        {
            temperatureLabelBottomConstraint.constant = 360.0 + temperatureLabelBottomDistance
        }
    }
    
    @IBAction func runPrimaryContentTransitionWithoutAnimation(sender: AnyObject) {
        
        if let drawer = self.parent as? LocationMapViewController
        {
            let primaryContent = UIStoryboard(name: "MainMapView", bundle: nil).instantiateViewController(withIdentifier: "PrimaryTransitionTargetViewController")
            
            drawer.setPrimaryContentViewController(controller: primaryContent, animated: false)
        }
    }
    
    @IBAction func runPrimaryContentTransition(sender: AnyObject) {
        
        if let drawer = self.parent as? LocationMapViewController
        {
            let primaryContent = UIStoryboard(name: "MainMapView", bundle: nil).instantiateViewController(withIdentifier: "PrimaryTransitionTargetViewController")
            
            drawer.setPrimaryContentViewController(controller: primaryContent, animated: true)
        }
    }
}

