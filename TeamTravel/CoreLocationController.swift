//
//  CoreLocationController.swift
//  TeamTravel
//
//  Created by Joseph Hansen on 10/25/16.
//  Copyright © 2016 Joseph Hansen. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import UserNotifications

class CoreLocationController: NSObject, CLLocationManagerDelegate {
    
    static let shared = CoreLocationController()
        
    var locationManager: CLLocationManager?
    
    var currentTravelerLocationForDistance: CLLocation? {
        didSet {
            let notification = Notification(name: Notification.Name(rawValue: "currentDistanceLocationUpdated"))
            NotificationCenter.default.post(notification)
        }
    }
    
    var currentTravelerLocationForSearch: CLLocation? {
        didSet{
            let notification = Notification(name: Notification.Name(rawValue: "currentSearchLocationUpdated"))
            NotificationCenter.default.post(notification)
        }
    }
    
    var hasAccess: Bool {
        //        locationManager?.requestAlwaysAuthorization()
        return checkForAuthorizationStatus()
    }
    
    func addObserverToGeofence(){
        NotificationCenter.default.addObserver(self, selector: #selector(configureGeofencesForCurrentLocation), name: Notification.Name(rawValue: "searchCategoryCompleted"), object: nil)
    }
    
    func checkForAuthorizationStatus() -> Bool {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways:
            return true
        case .authorizedWhenInUse:
            return true
        case .denied:
            return false
        case .notDetermined:
            return false
        case .restricted:
            return false
        }
    }
    
    /// sets up locationManager to be delegate, sets accuracy to be within 10 Meters
    func setupLocationManager() {
        let locMan = CLLocationManager()
        locMan.desiredAccuracy = kCLLocationAccuracyBest
        locMan.distanceFilter = 5
        locMan.delegate = self
        self.locationManager = locMan
        getCurrentLocation()
        addObserverToGeofence()
    }
    
    /// checks Authorization status each time
    func getCurrentLocation() {
        
        if hasAccess == true {
            locationManager?.requestLocation()
        } else {
            locationManager?.requestWhenInUseAuthorization()
        }
    }
    
    // MARK: - CLLocationManagerDelegate methods
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        DispatchQueue.main.async {
            NSLog("Got User Location")
            
            if let location = locations.first {
                guard self.currentTravelerLocationForSearch != nil && self.currentTravelerLocationForDistance != nil else { self.currentTravelerLocationForSearch = location; self.currentTravelerLocationForDistance = location; return }
                
                if location.distance(from: self.currentTravelerLocationForDistance!) >= 5 {
                    self.currentTravelerLocationForDistance = location
                }
                if location.distance(from: self.currentTravelerLocationForSearch!) >= 1000 {
                    self.currentTravelerLocationForSearch = location
                }
            }
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        NSLog(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            getCurrentLocation()
        }
    }
    
    // MARK: - Functions to create geofences
    
    func registerOuterMostGeoFence(for region: CLRegion) {
        if CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
            region.notifyOnExit = true
            region.notifyOnEntry = false
            locationManager?.startMonitoring(for: region)
            print("Outermost fence: \(region.identifier)")
            print(locationManager?.monitoredRegions.count ?? "")
        } else {
            print("problem setting up last fence")
        }
    }
    
    func registerGeoFence(for location: Location) {
        let region = location.createRegion()
        if CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
            locationManager?.startMonitoring(for: region)
        } else {
            NSLog("no monitoring available")
        }
        print(region.identifier)
        print(locationManager?.monitoredRegions.count ?? 0)
    }
    
    func unregisterGeoFence(for location: Location) {
        let region = location.createRegion()
        
        locationManager?.stopMonitoring(for: region)
    }
    
    func unregisterAllGeoFences() {
        guard let locationManager = locationManager else { return }
        for region in locationManager.monitoredRegions {
            print("Region: \(region.identifier)")
            locationManager.stopMonitoring(for: region)
            print(locationManager.monitoredRegions.count)
        }
    }
    
    /// calculates 20 closest locations and creates geofences for those
    func configureGeofencesForCurrentLocation() {
        guard let currentLocation = currentTravelerLocationForSearch else { return }
        let distanceFilteredLocations = SearchLocationController.shared.allVisibleLocations.sorted { $0.0.location.distance(from: currentLocation) < $0.1.location.distance(from: currentLocation) }
        var locationsToGeofence: [Location] = []
        
        if distanceFilteredLocations.count <= 19 {
            locationsToGeofence = distanceFilteredLocations
        } else {
            for i in 0...18 {
                locationsToGeofence.append(distanceFilteredLocations[i])
            }
        }
        
        let distanceToLastLocation = locationsToGeofence.last?.location.distance(from: currentLocation)
        
        let outerRegion = CLCircularRegion.init(center: currentLocation.coordinate, radius: distanceToLastLocation!, identifier: "outerRegion")
        
        // Remove old geofences
        CoreLocationController.shared.unregisterAllGeoFences()
        
        // Add new geofences
        for location in locationsToGeofence {
            CoreLocationController.shared.registerGeoFence(for: location)
        }
        
        registerOuterMostGeoFence(for: outerRegion)
    }
    // MARK: - Region monitoring
    
    // delegate:
    
    weak var alertDelegate: ShowFenceAlertDelegate?
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        if region.identifier == "outerRegion" {
            
            guard let currentLocation = currentTravelerLocationForSearch else { return }
            SearchLocationController.shared.queryForLocations(location: currentLocation, completion: { (_) in
                SearchLocationController.shared.isSearching = false
            })
            
            let alertController = UIAlertController(title: "Reloading Geofences", message: nil, preferredStyle: .alert)
            let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
            
            alertController.addAction(dismissAction)
            self.alertDelegate?.presentAlert(alert: alertController)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        
        let regionAlert = UIAlertController(title: "Entered: \(region.identifier)", message: nil, preferredStyle: .alert)
        let dismiss = UIAlertAction(title: "Dismiss", style: .cancel) { (_) in
            
        }
        regionAlert.addAction(dismiss)
        
        self.alertDelegate?.presentAlert(alert: regionAlert)
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0, repeats: false)
        
        Notifications.sendNotification(withTitle: "You entered \(region.identifier)", message: nil, andTrigger: trigger)
    
        // Add location to Master traveler
        TravelerController.shared.addVisited(region: region)
    }
}

