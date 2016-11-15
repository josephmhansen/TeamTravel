//
//  AppDelegate.swift
//  TeamTravel
//
//  Created by Joseph Hansen on 10/25/16.
//  Copyright © 2016 Joseph Hansen. All rights reserved.
//

import UIKit
import CoreLocation
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
    //Do not delete
    var strongReferenceToLocationManager: CLLocationManager?
    
    var notification: UIAlertController?
    
    func presentIcloudAlert() {
        let alertController = UIAlertController(title: "Error Saving", message: "Confirm that you are signed into iCloud", preferredStyle: .alert)
        let actionItem = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        
        alertController.addAction(actionItem)
        self.window?.rootViewController?.present(alertController, animated: true, completion: nil)
    }

    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.presentNotification(notification:)), name: NSNotification.Name(rawValue: postAlertNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.presentIcloudAlert), name: NSNotification.Name(rawValue: "iCloudNotification"), object: nil)
        
        
        
        // Override point for customization after application launch.
        CloudKitSync.shared.fetchAllCKRecordsOnStartup()
        CloudKitSync.shared.fetchTravelerRecord()
        
        // Setup region monitoring
        let _ = LocationProximityManager.shared.locationsWithinProximity.count
        
        /*
        MockData.setUpCloudKitTraveler()
        
        guard let traveler = TravelerController.shared.masterTraveler else { return true }
        
        for location in traveler.locationsVisited {
                location.datesVisited.append(Date())
            
            CloudKitSync.shared.createLocationVisited(location: location)
        }
        
        for quest in traveler.locationsWishList {
            CloudKitSync.shared.createQuestItem(location: quest)
        }
         */
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        // To create from a Storyboard
        window?.rootViewController = UIStoryboard(name: "MainMapView", bundle: nil).instantiateInitialViewController()!
        
        // To create in code (uncomment this block)
        /*
         let mainContentVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PrimaryContentViewController")
         let drawerContentVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DrawerContentViewController")
         let pulleyDrawerVC = PulleyViewController(contentViewController: mainContentVC, drawerViewController: drawerContentVC)
         
         // Uncomment this next line to give the drawer a starting position, in this case: closed.
         // pulleyDrawerVC.initialDrawerPosition = .closed
         
         window?.rootViewController = pulleyDrawerVC
         */
        
        window?.makeKeyAndVisible()
        
        return true
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("Notification received")
    }
  
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        CoreLocationController.shared.setupLocationManager()
        self.strongReferenceToLocationManager = CoreLocationController.shared.locationManager
        
       /* UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        UINavigationBar.appearance().isTranslucent = true */
      
      // MARK: UserDefaults
      
      let userDefaults = UserDefaults.standard
      let launchedBefore = userDefaults.bool(forKey: "firstLaunch")
      
      if launchedBefore {
        showHomeScreen()
      } else {
        print("AppDelegate says First Launch!")
        showTutorial()
      }
      
      userDefaults.synchronize()
      
      return true
      
    }
    
    // MARK: - Cloudkit saving upon termination
    
    func applicationWillTerminate(_ application: UIApplication) {
        CloudKitSync.shared.attemptToSaveUnsavedRecords()
         print("terminating")
    }
    // MARK: - Other functions
    
    func presentNotification(notification: Notification) {
        let alertController = notification.object as? UIAlertController
        self.window?.rootViewController?.present(alertController!, animated: true, completion: nil)
    }
  
    func showHomeScreen() {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "MainMapView", bundle: nil)
    
        // navigation
        let homeVC = mainStoryboard.instantiateViewController(withIdentifier: "navigation") as! UINavigationController
        window?.rootViewController = homeVC
        window?.makeKeyAndVisible()
    }

    func showTutorial() {
        window = UIWindow(frame: UIScreen.main.bounds)
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Onboarding", bundle: nil)
        let tutVC = mainStoryboard.instantiateViewController(withIdentifier: "TutorialViewController") as! TutorialPageViewController
        window?.rootViewController = tutVC
        window?.makeKeyAndVisible()
  }
}

