//
//  Joke.swift
//  ChuckNorrisJokes
//
//  Created by Vanina Fileva on 25.10.20.
//

import Foundation

class Joke: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case value = "value"
    }
    
    var text: String
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        text =  try values.decode(String.self, forKey: .value)
    }
}

