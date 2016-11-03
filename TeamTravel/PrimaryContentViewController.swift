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
        
        NotificationCenter.default.addObserver(self, selector: #selector(zoomToUserLocation), name: Notification.Name(rawValue: "currentLocationUpdated"), object: nil)
        mapView.showsUserLocation = true
        
        temperatureLabel.layer.cornerRadius = 7.0
        
        NotificationCenter.default.addObserver(self, selector: #selector(drawMapAnnotations), name: Notification.Name(rawValue: "allLocationsReturned"), object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        CoreLocationController.shared.setupLocationManager()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        Uncomment if you want to change the visual effect style to dark. Note: The rest of the sample app's UI isn't made for dark theme. This just shows you how to do it.
//        if let drawer = self.parent as? PulleyViewController
//        {
//            drawer.drawerBackgroundVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
//        }
    }
    
    func zoomToUserLocation() {
        if let location = CoreLocationController.shared.currentTravelerLocation {
            let span = MKCoordinateSpanMake(0.05, 0.05)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            //fixed issue with zooming too slow, do more research about async after to delay zoom a little bit
            /*
            let deadline = DispatchTime.now() + .seconds(1)
            
            DispatchQueue.main.asyncAfter(deadline: deadline, execute: {
                self.mapView.setRegion(region, animated: true)
            })
            */
            
            DispatchQueue.main.async {
                self.mapView.setRegion(region, animated: true)
            }
            
        }
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
    
    // MARK: - Draw Map Annotations
    /// Removes old annotations and draws new ones returned from the search.
    func drawMapAnnotations(){
        // remove old annotations
        let oldAnnotations = self.mapView.annotations
            self.mapView.removeAnnotations(oldAnnotations)
        
        // add new ones
        for location in SearchLocationController.shared.allVisibleLocations {
            self.mapView.addAnnotation(location)
        }
    }
}

