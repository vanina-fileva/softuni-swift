//
//  CategoriesTableViewController.swift
//  ChuckNorrisJokes
//
//  Created by Vanina Fileva on 25.10.20.
//

import UIKit

class CategoriesTableViewController: UITableViewController {
    
    // Network manager object that will be initialized the first time it is needed
    private lazy var networkManager = NetworkManager()
    
    // The categories list that we show on the table
    private var categories: [String]? {
        didSet {
            // When they are set we pass the closure that reloads the table with the downloaded categories to the main thread's queue of tasks
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // We tell the network manager we will be its delegate and ask it to download the jokes' categories
        networkManager.delegate = self
        networkManager.getCategories()
    }
    
    // When a category's cell is pressed
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // We cast the object that has started the segue to a JokeTableViewCell
        if let cell = sender as? JokeTableViewCell,
           // We get the index path for this cell from the table itself
           let indexPath = tableView.indexPath(for: cell),
           // We get the category from the array by passing the index from the cell's indexPath
           let category = categories?[indexPath.row],
           // We cast the destination to its specific type so that we can access its custom properties
           let destination = segue.destination as? JokeViewController {
            // We reuse the network manager by passing it to the next screen instead of creating a new network manager object
            destination.networkManager = networkManager
            destination.category = category
        }
    }
}

// MARK: - UITableViewDataSource
extension CategoriesTableViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? JokeTableViewCell,
              let category = categories?[indexPath.row] else {
            return UITableViewCell()
        }
        cell.centerTextLabel.text = category
        return cell
    }
    
}

extension CategoriesTableViewController: NetworkManagerDelegate {
    // Since this is the network manager's delegate, this method will be called when the categories are downloaded
    func didGet(categories: [String]) {
        // We set the downloaded categories to be the value of this object's property which triggers the didSet observer and the reloading of the table
        self.categories = categories
    }
}
