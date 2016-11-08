//
//  LocationListDrawerContentViewController.swift
//  TeamTravelMapViewTest
//
//  Created by Joseph Hansen on 10/29/16.
//  Copyright © 2016 Joseph Hansen. All rights reserved.
//

import UIKit

private let kLivelyGreenColor = UIColor(red: 8 / 255, green: 132 / 255, blue: 67 / 255, alpha: 1)

class LocationListDrawerContentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, PulleyDrawerViewControllerDelegate, ShowFenceAlertDelegate, UISearchBarDelegate {
//use this outlet to alter custom segmented controller
    @IBOutlet weak var segmentedControl: SegmentedControl!
    
//
    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var gripperView: UIView!
    
    @IBOutlet var seperatorHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Do any additional setup after loading the view.
        //self.tableView.backgroundColor = .clear
        //self.tableView.alpha = 0.9
        
        CoreLocationController.shared.alertDelegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(startSearch), name: Notification.Name(rawValue: "currentSearchLocationUpdated"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateSearchResults), name: Notification.Name(rawValue: "currentDistanceLocationUpdated"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateSearchResults), name: Notification.Name(rawValue: "allLocationsReturned"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateSearchResults), name: Notification.Name(rawValue: "wishlistUpdated"), object: nil)

        gripperView.layer.cornerRadius = 2.5
        seperatorHeightConstraint.constant = 1.0 / UIScreen.main.scale
        setupUI()
    }
    
    fileprivate func setupUI() {
        configureSegmentedControl2()
    }
    
    fileprivate func configureSegmentedControl2() {
        //Set Titles
        /*
        let titleStrings = ["Nearby", "QuestList"]
        let titles: [NSAttributedString] = {
            let attributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 17), NSForegroundColorAttributeName: UIColor.white]
            var titles = [NSAttributedString]()
            for titleString in titleStrings {
                let title = NSAttributedString(string: titleString, attributes: attributes)
                titles.append(title)
            }
            return titles

        }()
        let selectedTitles: [NSAttributedString] = {
            let attributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 17), NSForegroundColorAttributeName: UIColor(white: 0.1, alpha: 1)]
            var selectedTitles = [NSAttributedString]()
            for titleString in titleStrings {
                let selectedTitle = NSAttributedString(string: titleString, attributes: attributes)
                selectedTitles.append(selectedTitle)
            }
            return selectedTitles
        }()
        
        segmentedControl.setTitles(titles, selectedTitles: selectedTitles)
        */
        
        //Set Images
        let images = [#imageLiteral(resourceName: "Nearby"), #imageLiteral(resourceName: "QuestList")]
        let selectedImages = [#imageLiteral(resourceName: "Nearby"), #imageLiteral(resourceName: "QuestList")]
        segmentedControl.setImages(images, selectedImages: selectedImages)
        segmentedControl.delegate = self
        segmentedControl.selectionIndicatorStyle = .bottom
        segmentedControl.selectionIndicatorColor = kLivelyGreenColor
        segmentedControl.selectionIndicatorHeight = 3
        segmentedControl.selectionIndicatorEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
    
    // MARK: - Show Fence Alert Delegate
    func presentAlert(alert: UIAlertController) {
        self.present(alert, animated: true, completion: nil)
    }
    
    //extra functions, hooked up to mock data
    func startSearch() {
        if TravelerController.shared.masterTraveler == nil {
            MockData.shared.setUpTraveler()
        }
        
        if let location = CoreLocationController.shared.currentTravelerLocationForSearch {
            SearchLocationController.shared.queryForLocations(location: location, completion: { (_) in
                SearchLocationController.shared.isSearching = false
                self.locationsToShow = SearchLocationController.shared.allVisibleLocations
                self.tableView.reloadData()
            })
        }
    }
    
    func updateSearchResults(){
        locationsToShow = SearchLocationController.shared.allVisibleLocations
        guard let currentLocation = CoreLocationController.shared.currentTravelerLocationForDistance else { return }
        TravelerController.shared.masterTraveler?.locationsWishList = (TravelerController.shared.masterTraveler?.locationsWishList.sorted { $0.0.location.distance(from: currentLocation) < $0.1.location.distance(from: currentLocation) })!
        self.tableView.reloadData()
    }

    // MARK: Tableview data source & delegate
    
    var locationsToShow: [Location] = []
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationsToShow.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath) as? LocalLocationTableViewCell else { return UITableViewCell() }
        let currentLocation = CoreLocationController.shared.currentTravelerLocationForDistance
        
        let location = locationsToShow[indexPath.row]
        let distance = Int((currentLocation?.distance(from: location.location))!)
        
        cell.updateCellWithLocation(location: location, and: distance)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if segmentedControl.selectedIndex == 0 {
        let selectedLocation = self.locationsToShow[indexPath.row]
        let pinItemActionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let add = UIAlertAction(title: "Add to QuestList", style: .default, handler: { (_) in
            TravelerController.shared.addToMasterTravelerList(location: selectedLocation)
        })
        pinItemActionSheet.addAction(add)
        pinItemActionSheet.addAction(cancel)
        self.present(pinItemActionSheet, animated: true, completion: nil)
        }
    
        //if let drawer = self.parent as? LocationMapViewController
       // {
        //    let primaryContent = UIStoryboard(name: "MainMapView", bundle: nil).instantiateViewController(withIdentifier: "PrimaryTransitionTargetViewController")
            
        //   drawer.setDrawerPosition(position: .collapsed, animated: true)

        //    drawer.setPrimaryContentViewController(controller: primaryContent, animated: false)
        //}
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //cell.backgroundColor = tableView.backgroundColor
        //cell.contentView.backgroundColor = tableView.backgroundColor
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let location = locationsToShow[indexPath.row]
            TravelerController.shared.deleteFromMasterTravelerList(location: location)
            locationsToShow.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if segmentedControl.selectedIndex == 1 {
            return true
        } else {
            return false
        }
    }
    

    // MARK: Drawer Content View Controller Delegate 
    
    func collapsedDrawerHeight() -> CGFloat
    {
        return 68.0
    }
    
    func partialRevealDrawerHeight() -> CGFloat
    {
        return 380.0
    }
    
    func supportedDrawerPositions() -> [PulleyPosition] {
        return PulleyPosition.all // You can specify the drawer positions you support. This is the same as: [.open, .partiallyRevealed, .collapsed, .closed]
    }

    func drawerPositionDidChange(drawer: LocationMapViewController)
    {
        tableView.isScrollEnabled = drawer.drawerPosition == .open
        
        if drawer.drawerPosition != .open
        {
            searchBar.resignFirstResponder()
        }
    }
    
    // MARK: Search Bar delegate
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        if let locationSearchTVC = self.parent as? LocationMapViewController
        {
            locationSearchTVC.setDrawerPosition(position: .open, animated: true)
        }
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "\n" {
            searchBar.resignFirstResponder()
        } else if searchText == "" {
            //MARK: -Needs work!
            searchBar.resignFirstResponder()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

extension LocationListDrawerContentViewController: SegmentedControlDelegate {
    func segmentedControl(_ segmentedControl: SegmentedControl, didSelectIndex selectedIndex: Int) {
        print("Did select index \(selectedIndex)")
        
        if selectedIndex == 0 {
            locationsToShow = SearchLocationController.shared.allVisibleLocations
            tableView.reloadData()
        } else if selectedIndex == 1 {
            guard let traveler = TravelerController.shared.masterTraveler else { print("No Traveler"); return }
            locationsToShow = traveler.locationsWishList
            tableView.reloadData()
        } else {
            print("Error: Out of index")
        }
        
        switch segmentedControl.style {
        case .text:
            print("The title is “\(segmentedControl.titles[selectedIndex].string)”\n")
        case .image:
            print("The image is “\(segmentedControl.images[selectedIndex])”\n")
        }
    }
    
    func segmentedControl(_ segmentedControl: SegmentedControl, didLongPressIndex longPressIndex: Int) {
        print("Did long press index \(longPressIndex)")
        if UIDevice.current.userInterfaceIdiom == .pad {
            let viewController = UIViewController()
            viewController.modalPresentationStyle = .popover
            viewController.preferredContentSize = CGSize(width: 200, height: 300)
            if let popoverController = viewController.popoverPresentationController {
                popoverController.sourceView = view
                let yOffset: CGFloat = 10
                popoverController.sourceRect = view.convert(CGRect(origin: CGPoint(x: 70 * CGFloat(longPressIndex), y: yOffset), size: CGSize(width: 70, height: 30)), from: navigationItem.titleView)
                popoverController.permittedArrowDirections = .any
                present(viewController, animated: true, completion: nil)
            }
        } else {
            let message = segmentedControl.style == .text ? "Long press title “\(segmentedControl.titles[longPressIndex].string)”" : "Long press image “\(segmentedControl.images[longPressIndex])”"
            let alert = UIAlertController(title: nil, message: message, preferredStyle: .actionSheet)
            let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(cancelAction)
            present(alert, animated: true, completion: nil)
        }
    }
}


