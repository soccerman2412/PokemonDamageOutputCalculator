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
    
    func BestAttackingFastMove(Active isActive:Bool = false, STAB isSTAB:Bool = false) -> PokemonFastMoveModel? {
        return pokemonModel.BestAttackingFastMove(Active: isActive, STAB: isSTAB)
    }
    
    func BestAttackingChargeMove(Active isActive:Bool = false, STAB isSTAB:Bool = false) -> PokemonChargeMoveModel? {
        return pokemonModel.BestAttackingChargeMove(Active: isActive, STAB: isSTAB)
    }
    
    func eDPSAttacking(Active isActive:Bool = false, STAB isSTAB:Bool = false) -> Double {
        return pokemonModel.eDPSAttacking(Active: isActive, STAB: isSTAB)
    }
    
    func BestDefendingFastMove(Active isActive:Bool = false, STAB isSTAB:Bool = false) -> PokemonFastMoveModel? {
        return pokemonModel.BestDefendingFastMove(Active: isActive, STAB: isSTAB)
    }
    
    func BestDefendingChargeMove(Active isActive:Bool = false, STAB isSTAB:Bool = false) -> PokemonChargeMoveModel? {
        return pokemonModel.BestDefendingChargeMove(Active: isActive, STAB: isSTAB)
    }
    
    func eDPSDefending(Active isActive:Bool = false, STAB isSTAB:Bool = false) -> Double {
        return pokemonModel.eDPSDefending(Active: isActive, STAB: isSTAB)
    }
}
