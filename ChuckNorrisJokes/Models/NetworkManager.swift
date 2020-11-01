//
//  NetworkManager.swift
//  ChuckNorrisJokes
//
//  Created by Vanina Fileva on 25.10.20.
//

import Foundation

protocol NetworkManagerDelegate {
    func didGet(categories: [String])
    func didGet(joke: Joke)
}

extension NetworkManagerDelegate {
    func didGet(categories: [String]) {
    }
    func didGet(joke: Joke) {
    }
}

class NetworkManager {
    
    private var baseURLString: String {
        return "https://api.chucknorris.io/jokes/"
    }
    var delegate: NetworkManagerDelegate?
    
    
    func getCategories() {
        guard let url = URL(string: baseURLString + "categories") else {
            return
        }
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            guard let data = data,
                  let categories = try? JSONSerialization
                    .jsonObject(with: data, options: .allowFragments) as? [String] else {
                return
            }
            self.delegate?.didGet(categories: categories)
        
        })
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
