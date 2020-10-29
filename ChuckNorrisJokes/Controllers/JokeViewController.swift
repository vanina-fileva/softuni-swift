//
//  JokeViewController.swift
//  ChuckNorrisJokes
//
//  Created by Vanina Fileva on 25.10.20.
//

import UIKit

class JokeViewController: UIViewController {
    
    @IBOutlet weak var textLabel: UILabel!
    
    var category: String?
    var joke: Joke? {
        didSet {
            DispatchQueue.main.async {
                self.textLabel.text = self.joke?.text
            }
        }
    }
    var networkManager: NetworkManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        networkManager?.delegate = self
        networkManager?.getRandomJoke(in: category)
    }
    
    @IBAction func tapped(_ save: Any) {
        let alert = UIAlertController(title: nil, message: "Save joke as:", preferredStyle: .alert)
        var jokeTextField: UITextField?
        alert.addTextField(configurationHandler: { textField in
            textField.text = self.joke?.text
            jokeTextField = textField
        })
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { action in
            if let text = jokeTextField?.text {
                StorageManager.shared.jokes.append(text)
            }
        })
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }

}

extension JokeViewController: NetworkManagerDelegate {
    func didGet(joke: Joke) {
        self.joke = joke
    }
}
