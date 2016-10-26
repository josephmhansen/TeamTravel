//
//  TESTSearchResultTableViewController.swift
//  TeamTravel
//
//  Created by Austin Blaser on 10/26/16.
//  Copyright © 2016 Joseph Hansen. All rights reserved.
//

import UIKit

class TESTSearchResultTableViewController: UITableViewController {

    @IBAction func refreshButtonTapped(_ sender: AnyObject) {
        
        startSearch()
        //allLocationsReturned
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(startSearch), name: Notification.Name(rawValue: "currentLocationUpdated"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateSearchResults), name: Notification.Name(rawValue: "allLocationsReturned"), object: nil)
     
    }

    func startSearch(){
         MockData.shared.setUpTraveler()
        if let location = CoreLocationController.shared.currentTravelerLocation {
            SearchLocationController.shared.queryForLocations(location: location)
        }
    }
    
    func updateSearchResults(){
        self.tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return SearchLocationController.shared.allVisibleLocations.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "resultCell", for: indexPath)
        let location = SearchLocationController.shared.allVisibleLocations[indexPath.row]
        // Configure the cell...
        cell.textLabel?.text = location.locationName
        cell.detailTextLabel?.text = "\(location.type.rawValue) + \(location.coordinate)"

        return cell
    }
}
