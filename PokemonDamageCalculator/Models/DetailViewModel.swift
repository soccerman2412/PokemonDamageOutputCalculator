//
//  DetailViewModel.swift
//  PokemonDamageCalculator
//
//  Created by Taylor Plimpton on 3/28/18.
//  Copyright © 2018 SmallPlanetDigital. All rights reserved.
//

import Foundation

class DetailViewModel {
    // required
    private(set) public var pokemonModel:PokemonModel
    
    init(PokemonModel pm:PokemonModel) {
        pokemonModel = pm
        
        // TODO: calculations
    }
    
    func ImageUrl() -> String? {
        return PokemonModel.imageUrl
    }
    
    func Name() -> String {
        return PokemonModel.name
    }
    
    func Types() -> Array<PokemonType> {
        return PokemonModel.types
    }
    
    func Attack() -> Int {
        return PokemonModel.attack
    }
    
    func Defense() -> Int {
        return PokemonModel.defense
    }
    
    func Stamina() -> Int {
        return PokemonModel.stamina
    }
    
    func BestAttackingFastMove(_ isSTAB:Bool = false) -> String {
        // TODO
        
        return "N/A"
    }
    
    func BestAttackingChargeMove(_ isSTAB:Bool = false) -> String {
        // TODO
        
        return "N/A"
    }
    
    func BestDefendingFastMove(_ isSTAB:Bool = false) -> String {
        // TODO
        
        return "N/A"
    }
    
    func BestDefendingChargeMove(_ isSTAB:Bool = false) -> String {
        // TODO
        
        return "N/A"
    }
}
