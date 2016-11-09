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
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    //Do not delete
    var strongReferenceToLocationManager: CLLocationManager?

    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        // Override point for customization after application launch.
        CloudKitSync.shared.fetchAllCKRecordsOnStartup()
        
        let center = UNUserNotificationCenter.current()
        
        let action = UNNotificationAction(identifier: "Awesome", title: "Awesome!", options: .foreground)
        let category = UNNotificationCategory(identifier: "Category", actions: [action], intentIdentifiers: [], options: .customDismissAction)
        center.setNotificationCategories([category])
        
        center.requestAuthorization(options: [.alert, .sound, .badge]) { (_, _) in
            
        }
        
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
         
        CoreLocationController.shared.setupLocationManager()
        self.strongReferenceToLocationManager = CoreLocationController.shared.locationManager
        
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
  
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
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

