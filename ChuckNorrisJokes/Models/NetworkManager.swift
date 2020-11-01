//
//  NetworkManager.swift
//  ChuckNorrisJokes
//
//  Created by Vanina Fileva on 25.10.20.
//

import Foundation

// The objects which would require to download jokes' info will need to implement this protocol and set themselves as the network manager's object's delegate
protocol NetworkManagerDelegate {
    func didGet(categories: [String])
    func didGet(joke: Joke)
}

// Default implementation (does nothing) for the protocol's members above so that they do not need to be implemented if not needed - first screen requires only the categories, the second screen requires only the joke itself
extension NetworkManagerDelegate {
    func didGet(categories: [String]) {
    }
    func didGet(joke: Joke) {
    }
}

// Internal API for downloading jokes' info
class NetworkManager {
    
    // The URL is set as a property so that it can be reused and not typed every time
    private var baseURLString: String {
        return "https://api.chucknorris.io/jokes/"
    }
    // The object that has implemented the delegate protocol, whose methods will be called and the downloaded data will be passed as a parameter
    var delegate: NetworkManagerDelegate?
    
    
    func getCategories() {
        // We use the base URL and add the path component for categories
        // https://rapidapi.com/matchilling/api/chuck-norris
        guard let url = URL(string: baseURLString + "categories") else {
            return
        }
        // We create a networking request with the URL
        let request = URLRequest(url: url)
        // We pass the request to the networking session (that coordinates data-transfer tasks) as a parameter, and receive a task for it, which can be resumed when necessary
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            // This is called when the request's response is received. If it is OK (code 200), the data paramater inside the closure will not be nil
            guard let data = data,
                  // The JSON data is cast as an array of strings
                  let categories = try? JSONSerialization
                    .jsonObject(with: data, options: .allowFragments) as? [String] else {
                return
            }
            // We tell the delegate the requested categories were downloaded
            self.delegate?.didGet(categories: categories)
        })
        // We start the request's task because it doesn't do it automatically
        task.resume()
    }
    
    func getRandomJoke(in category: String?) {
        guard let category = category,
              let url = URL(string: baseURLString + "random?category=\(category)") else {
            return
        }
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            guard let data = data,
                  let joke = try? JSONDecoder().decode(Joke.self, from: data) else {
                return
            }
            self.delegate?.didGet(joke: joke)
        })
        task.resume()
    }
}
