//
//  Joke.swift
//  ChuckNorrisJokes
//
//  Created by Vanina Fileva on 25.10.20.
//

import Foundation

// The custom class that implements the Decodable protocol so that it can be initialized from downloaded JSON
class Joke: Decodable {
    
    // An enum that corresponds to the JSON's dictionary key string value whose data we need to set as the object's text property
    enum CodingKeys: String, CodingKey {
        case value = "value"
    }
    
    var text: String
    
    // Initialize with JSON data
    required init(from decoder: Decoder) throws {
        // We get the values from the JSON dictionary by passing the decoder the set of keys (just one - for the joke's text in this case)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        // The decoding can throw an error so we do it with a try keyword
        text =  try values.decode(String.self, forKey: .value)
    }
}

