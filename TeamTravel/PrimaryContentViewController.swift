//
//  PrimaryContentViewController.swift
//  TeamTravelMapViewTest
//
//  Created by Joseph Hansen on 10/29/16.
//  Copyright © 2016 Joseph Hansen. All rights reserved.
//

import UIKit
import MapKit

private let kLivelyGreenColor = UIColor(red: 8 / 255, green: 132 / 255, blue: 67 / 255, alpha: 1)

class PrimaryContentViewController: UIViewController, PulleyPrimaryContentControllerDelegate {
    
    @IBOutlet var mapView: MKMapView!

    @IBOutlet var temperatureLabel: UILabel!
    
    @IBOutlet var temperatureLabelBottomConstraint: NSLayoutConstraint!
    
    private let temperatureLabelBottomDistance: CGFloat = 8.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(zoomToUserLocation), name: Notification.Name(rawValue: "currentSearchLocationUpdated"), object: nil)
        mapView.showsUserLocation = true
        
        temperatureLabel.layer.cornerRadius = 7.0
        
        NotificationCenter.default.addObserver(self, selector: #selector(drawMapAnnotations), name: Notification.Name(rawValue: "searchCategoryCompleted"), object: nil)
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
        if let location = CoreLocationController.shared.currentTravelerLocationForSearch {
            let span = MKCoordinateSpanMake(0.025, 0.025)
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

extension PrimaryContentViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation { // Return a blue dot for the user's location
            return nil
        }
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
        annotationView.canShowCallout = true
        
        
        let button = UIButton(type: .contactAdd)
        button.tintColor = kLivelyGreenColor
        annotationView.rightCalloutAccessoryView = button
        
        //
        guard let castAnnotation = annotation as? Location else { return nil }
        var toSizeImage: UIImage?
        
        switch castAnnotation.type {
        case .Parks: toSizeImage = #imageLiteral(resourceName: "ParksSmall")
        case .Landmarks: toSizeImage = #imageLiteral(resourceName: "LandmarksSmall")
        case .Museums: toSizeImage = #imageLiteral(resourceName: "MuseumsSmall")
        }
        
//        let typeSize = CGSize(width: 30, height: 30)
//        UIGraphicsBeginImageContext(typeSize)
//        toSizeImage?.draw(in: CGRect(x: 0, y: 0, width: typeSize.width, height: typeSize.height))
//        let resizedTypeImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        
//        
//        
//        let test = #imageLiteral(resourceName: "doubleMuseum")
        
        
        
        let imgView = UIImageView(image: toSizeImage)
        imgView.layer.contentsScale = UIScreen.main.scale
        imgView.contentMode = .scaleAspectFill
        annotationView.leftCalloutAccessoryView = imgView
        
        // Move pin up
        annotationView.centerOffset = CGPoint(x: 0, y: -20)
        annotationView.layer.contentsScale = UIScreen.main.scale
        
        annotationView.image = #imageLiteral(resourceName: "pinAnnotation")
        annotationView.contentMode = .scaleAspectFit
        return annotationView
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        guard let annotation = view.annotation, let castAnnotation = annotation as? Location else { return }
        
        let pinItemActionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let add = UIAlertAction(title: "Add to QuestList", style: .default, handler: { (_) in
            TravelerController.shared.addToMasterTravelerList(location: castAnnotation)
        })
        pinItemActionSheet.addAction(add)
        pinItemActionSheet.addAction(cancel)
        self.present(pinItemActionSheet, animated: true, completion: nil)
    }
}



