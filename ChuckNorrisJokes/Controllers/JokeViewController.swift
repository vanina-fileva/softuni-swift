//
//  JokeViewController.swift
//  ChuckNorrisJokes
//
//  Created by Vanina Fileva on 25.10.20.
//

import UIKit

class JokeViewController: UIViewController {
    
    @IBOutlet weak var textLabel: UILabel!
    
    // Used to get a random joke from this category. This is an optional because it will be set after the object from this class is initialized (can be nil at the beginning)
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
        // We set the objet from this class as the new delegate so that the implemented protocol's methods can be called when the data is downloaded
        networkManager?.delegate = self
        networkManager?.getRandomJoke(in: category)
    }
    
    @IBAction func tapped(_ save: Any) {
        // We present an alert with a textfield which the user can edit and save the joke persistently (to disk)
        let alert = UIAlertController(title: nil, message: "Save joke as:", preferredStyle: .alert)
        // We create a reference to the textfield which will be used when saving the edited joke's text
        var jokeTextField: UITextField?
        alert.addTextField(configurationHandler: { textField in
            // When the textfield is shown we set its text property to be equal to the joke's text
            textField.text = self.joke?.text
            // We set the reference so that it can be used outside of this closure's scope
            jokeTextField = textField
        })
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { action in
            // When the user taps OK the edited text is added to the list of jokes of the StorageManager shared object
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
