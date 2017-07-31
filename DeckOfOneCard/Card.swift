//
//  Card.swift
//  DeckOfOneCard
//
//  Created by Britton Baird on 7/31/17.
//  Copyright © 2017 Britton Baird. All rights reserved.
//

import Foundation

struct Card {
    
    let value: String
    let suit: String
    let imageEndpoint: String
    
}

extension Card {
    
    fileprivate static var valueKey: String { return "value" }
    fileprivate static var suitKey: String { return "suit" }
    fileprivate static var imageEndpointKey: String { return "image" }
    
    init?(dictionary: [String: Any]) {
        guard let value = dictionary[Card.valueKey] as? String,
            let suit = dictionary[Card.suitKey] as? String,
            let imageEndpoint = dictionary[Card.imageEndpointKey] as? String else { return nil }
        
        self.init(value: value, suit: suit, imageEndpoint: imageEndpoint)
    }
    
}
