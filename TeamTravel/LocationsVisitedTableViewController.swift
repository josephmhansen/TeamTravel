//
//  LocationsVisitedTableViewController.swift
//  TeamTravel
//
//  Created by Joseph Hansen on 11/1/16.
//  Copyright © 2016 Joseph Hansen. All rights reserved.
//

import UIKit

class LocationsVisitedTableViewController: UITableViewController {
    
    let traveler = TravelerController.shared.masterTraveler

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(updateTableView), name: Notification.Name(rawValue: "locationsVisitedUpdated"), object: nil)
    }
    
    // MARK: - Notification selectors
    func updateTableView(){
        self.tableView.reloadData()
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Quests Visited - Times Visited"
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return traveler?.locationsVisited.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "locationVisitedCell", for: indexPath)
        
        guard let traveler = traveler else { return cell }
        let location = traveler.locationsVisited[indexPath.row]
        
        cell.textLabel?.text = location.locationName
        cell.detailTextLabel?.text = "\(location.datesVisited.count)"
        
        return cell
    }
}
