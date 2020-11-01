//
//  StorageManager.swift
//  ChuckNorrisJokes
//
//  Created by Vanina Fileva on 25.10.20.
//

import Foundation

// This class is used to save objects from memory to disk
class StorageManager {
    
    // Object of this class to be shared throughout the app. Static members are of the class, do not require an object
    static var shared = StorageManager()
    
    // This array of jokes will be initialized lazily - the first time it is needed (when the second tab is opened)
    lazy var jokes: [String] = [] {
        didSet {
            saveJokes()
        }
    }
    
    // Saves the value of the property persistently (defaults' database)
    func saveJokes() {
        // UserDefaults - one of several API (CoreData, Keychain) that saves data to disk (persistently)
        UserDefaults.standard.set(jokes, forKey: "jokes")
    }
    
    // Loads the value
    func loadJokes() {
        jokes = UserDefaults.standard.value(forKey: "jokes") as? [String] ?? []
    }
}
