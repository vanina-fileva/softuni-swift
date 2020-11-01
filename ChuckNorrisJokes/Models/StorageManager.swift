//
//  StorageManager.swift
//  ChuckNorrisJokes
//
//  Created by Vanina Fileva on 25.10.20.
//

import Foundation

class StorageManager {
    
    static var shared = StorageManager()
    
    lazy var jokes: [String] = [] {
        didSet {
            saveJokes()
        }
    }
    
    func saveJokes() {
        UserDefaults.standard.set(jokes, forKey: "jokes")
    }
    
    func loadJokes() {
        jokes = UserDefaults.standard.value(forKey: "jokes") as? [String] ?? []
    }
}
