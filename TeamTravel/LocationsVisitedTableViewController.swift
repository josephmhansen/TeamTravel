//
//  LocationsVisitedTableViewController.swift
//  TeamTravel
//
//  Created by Justin Carver on 10/28/16.
//  Copyright © 2016 Joseph Hansen. All rights reserved.
//

import UIKit

class LocationsVisitedTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)


        
        return cell
    }
}
