//
//  PokemonCollectionViewCell.swift
//  PokemonDamageCalculator
//
//  Created by Taylor Plimpton on 4/26/18.
//  Copyright © 2018 SmallPlanetDigital. All rights reserved.
//

import Foundation
import UIKit

class PokemonCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var CardView: UIView!
    @IBOutlet weak var InnerCardMaskView: UIView!
    
    @IBOutlet weak var PokemonImageView: UIImageView!
    @IBOutlet weak var PokemonNumberLabel: UILabel!
    @IBOutlet weak var PokemonNameLabel: UILabel!
    @IBOutlet weak var PokemonCurrentStatLabel: UILabel!
    
    private(set) public var hasBeenReused = false
    
    func UpdateContent(PokemonModel model:CellViewModel) {
        // only need to do this the first time the card is used
        if (!hasBeenReused) {
            // adding a shadow and rounded edges to the card view
            CardView.layer.cornerRadius = 10
            CardView.layer.shadowColor = UIColor.black.cgColor
            CardView.layer.shadowOpacity = 0.6
            CardView.layer.shadowOffset = CGSize(width: 0, height: 1)
            
            // need this inner view to masks the content to the bounds
            // can't be down on the card view because it would mask the shadow
            InnerCardMaskView.layer.masksToBounds = true
            InnerCardMaskView.layer.cornerRadius = 10
        }
        
        if let imageUrl = model.ImageUrl() {
            PokemonImageView?.GetImageForURL(ImageURL: imageUrl)
        }
        
        var textColor = UIColor.black
        if let legendaryColor = UIColor(named: "legendaryColor"), model.IsLegendary() {
            textColor = legendaryColor
        }
        
        PokemonCurrentStatLabel?.text = model.CurrentStat()
        PokemonCurrentStatLabel?.textColor = textColor
        
        PokemonNameLabel?.text = model.Name()
        PokemonNameLabel?.textColor = textColor
        
        PokemonNumberLabel?.text = "#" + model.PokemonNumber()
        PokemonNumberLabel?.textColor = .black
    }
    
}
