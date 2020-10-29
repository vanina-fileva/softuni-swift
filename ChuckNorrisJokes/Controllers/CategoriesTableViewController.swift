//
//  CategoriesTableViewController.swift
//  ChuckNorrisJokes
//
//  Created by Vanina Fileva on 25.10.20.
//

import UIKit

class CategoriesTableViewController: UITableViewController {
    
    private lazy var networkManager = NetworkManager()
    private var categories: [String]? {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        networkManager.getCategories { [weak self] (categories) in
            self?.categories = categories
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? JokeTableViewCell,
           let indexPath = tableView.indexPath(for: cell),
           let category = categories?[indexPath.row],
           let destination = segue.destination as? JokeViewController {
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
