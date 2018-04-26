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
    
    @IBOutlet weak var PokemonImageView: UIImageView!
    @IBOutlet weak var PokemonNumberLabel: UILabel!
    @IBOutlet weak var PokemonNameLabel: UILabel!
    
    func UpdateContent(PokemonModel model:PokemonModel) {
        
    }
    
}
