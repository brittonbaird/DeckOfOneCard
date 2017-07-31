//
//  CardViewController.swift
//  DeckOfOneCard
//
//  Created by Britton Baird on 7/31/17.
//  Copyright © 2017 Britton Baird. All rights reserved.
//

import UIKit

class CardViewController: UIViewController {

    @IBOutlet weak var cardImageView: UIImageView!
    
    @IBAction func drawButtonTapped(_ sender: Any) {
        CardController.drawCard(numberOfCards: 1) { (cards) in
            guard let card = cards.first else { return }
            CardController.image(forURL: card.imageEndpoint, completion: { (image) in
                guard let image = image else { return }
                self.cardImageView.image = image
            })
            
        }
    }
    
    
}
