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
        return pokemonModel.imageUrl
    }
    
    func Name() -> String {
        return pokemonModel.name
    }
    
    func Types() -> Array<PokemonType> {
        return pokemonModel.types
    }
    
    func Attack() -> Int {
        return pokemonModel.attack
    }
    
    func Defense() -> Int {
        return pokemonModel.defense
    }
    
    func Stamina() -> Int {
        return pokemonModel.stamina
    }
    
    func BestAttackingFastMove(_ isSTAB:Bool = false) -> String {
        return pokemonModel.BestAttackingFastMove(isSTAB)
    }
    
    func BestAttackingChargeMove(_ isSTAB:Bool = false) -> String {
        return pokemonModel.BestAttackingChargeMove(isSTAB)
    }
    
    func eDPSAttacking(_ isSTAB:Bool = false) -> Double {
        return pokemonModel.eDPSAttacking(isSTAB)
    }
    
    func BestDefendingFastMove(_ isSTAB:Bool = false) -> String {
        return pokemonModel.BestDefendingFastMove(isSTAB)
    }
    
    func BestDefendingChargeMove(_ isSTAB:Bool = false) -> String {
        return pokemonModel.BestDefendingChargeMove(isSTAB)
    }
    
    func eDPSDefending(_ isSTAB:Bool = false) -> Double {
        return pokemonModel.eDPSDefending(isSTAB)
    }
}
