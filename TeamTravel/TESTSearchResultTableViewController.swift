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
     
    }

    func startSearch(){
        if let location = CoreLocationController.shared.currentTravelerLocation {
            SearchLocationController.shared.queryForLocations(locations: location)
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
        return 3
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "resultCell", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = "PLACE NAME"
        cell.detailTextLabel?.text = "Address"

        return cell
    }
}
