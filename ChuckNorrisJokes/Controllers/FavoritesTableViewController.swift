//
//  FavoritesTableViewController.swift
//  ChuckNorrisJokes
//
//  Created by Vanina Fileva on 25.10.20.
//

import UIKit

class FavoritesTableViewController: UITableViewController {
    
    var jokes: [String]? {
        didSet {
            tableView.reloadData()
        }
    }

    // We use this method so that the table can be realoded with the latest saved jokes each time it is shown
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // This will trigger the didSet observer and thus the reloding of the table
        jokes = StorageManager.shared.jokes
    }
}

// MARK: - UITableViewDataSource

extension FavoritesTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jokes?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = jokes?[indexPath.row]
        return cell
    }
    
}
