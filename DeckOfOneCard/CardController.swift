//
//  CardController.swift
//  DeckOfOneCard
//
//  Created by Britton Baird on 7/31/17.
//  Copyright © 2017 Britton Baird. All rights reserved.
//

import Foundation

class CardController {

    // Create baseURL
    static let baseURL = URL(string: "https://deckofcardsapi.com/api/deck/new/")
    
    static func drawCard(numberOfCards: Int, completion: @escaping ((_ card: [Card]) -> Void)) {
        // Append any additional paths to the URL
        guard let url = self.baseURL?.appendingPathComponent("draw") else { fatalError("URL optional is nil") }
        
        // Create our components so we can append any URL Parameters
        // URL parameters are distinguished by a ? and eeach parameter is separated by an &
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        
        // Create our QueryItems and these are just a key value paire to represent a URL Query parameter.
        let cardCountQueryItem = URLQueryItem(name: "count", value: "\(numberOfCards)")
        // Your could have a second QueryItem like so
        // let cardDeckQueryItem = URLQueryItem(name: "deck_id", value: "def%7h")
        
        // Set the queryItems here vased on what was created above
        components?.queryItems = [cardCountQueryItem]
        
        // If we had multiple query items we would append them here
        // components?.queryItems = [cardCountQueryItem, cardDeckQueryItem]
        
        // We are just getting the new URL back, because we added the query parameters to it.
        guard let requestURL = components?.url else { return }
        
        // Create a request to the URLSession. We want a URLRequest because we are hitting an API and an API may us "GET" "PUT" "POST" "PATCH" "DELETE"
        var request = URLRequest(url: requestURL)
        request.httpMethod = "GET"
        
        // If we had a body to send we would set that on the request.
        // request.httpBody = SomeData
        
        // Create a dataTask. The dataTask uses URLSession.shared.dataTask along with the URLRequest to know which remote server to hit along with which parameters to use.
        // The dataTask will respond with Data?, URLResponse?, Error?
        // dataTask gives this information to use through its completionHandler
        let dataTask = URLSession.shared.dataTask(with: requestURL) { (data, _, _) in
            // Since we now have access to data we can do something with it. But remember it's an optional so we have to unwrap it.
            guard let data = data,
                // We create a responseDataString so that we can log information to the console
                // We use .utf8 encoding, because that's a standard format for the web and how the data should be presented to us.
                let responseDataString = String(data: data, encoding: .utf8) else  {
                    // if Data or responseDataString is nil, log to the console
                    NSLog("No data returned from the network request")
                    // Before returning we must alert the caller of this method that it has completed
                    completion([])
                    return
            }
            
            // Now that we know there is correct data, we need to get the response  (which should be JSON) and convert it into a dictionary
            guard let responseDictionary = (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)) as? [String: Any],
                // If we are able to convert the JSON to a dictionary, then we know we have a correct responsed and we need to access the calue for the "cards" key.
                // According to the API THE "cards" key has a value of an Array and this Array  holds a dictionary of [String: Any]
                let cardDictionaries = responseDictionary["cards"] as? [[String: Any]] else {
                    // If the JSON is bad, log to the console
                    NSLog("Unable to serilaize JSON. \nResponse: \(responseDataString)")
                    // Alert the called that we have completed
                    completion([])
                    return
            }
            
            // If we are able to access the key "cards" and get a value back to Array of Dicgtionary(String: Any)
            // Loop over the cardDictionaries and use that dictionary to create our Card Objects
            let cards = cardDictionaries.flatMap { Card(dictionary: $0) }
            
            // Exectue our completion uses the cards
            completion(cards)
        }
        
        dataTask.resume()
    }
    
    
}
