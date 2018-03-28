//
//  TableCellViewModel.swift
//  PokemonDamageCalculator
//
//  Created by Taylor Plimpton on 3/28/18.
//  Copyright © 2018 SmallPlanetDigital. All rights reserved.
//

import Foundation

class TableCellViewModel {
    // required
    private(set) public var pokemonModel:PokemonModel
    
    init(PokemonModel pm:PokemonModel) {
        pokemonModel = pm
    }
    
    func Name() -> String {
        return PokemonModel.name
    }
    
    func ImageUrl() -> String? {
        return PokemonModel.imageUrl
    }
}
