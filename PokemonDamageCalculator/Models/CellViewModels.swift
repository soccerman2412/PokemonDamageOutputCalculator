//
//  CellViewModels.swift
//  PokemonDamageCalculator
//
//  Created by Taylor Plimpton on 3/28/18.
//  Copyright © 2018 SmallPlanetDigital. All rights reserved.
//

import Foundation

class PokemonCellViewModel {
    // required
    private(set) public var pokemonModel:PokemonModel
    
    init(PokemonModel pm:PokemonModel) {
        pokemonModel = pm
    }
    
    func Name() -> String {
        return pokemonModel.name
    }
    
    func PokemonNumber() -> String {
        return String(pokemonModel.pokemonNumber)
    }
    
    func ImageUrl() -> String? {
        return pokemonModel.imageUrl
    }
    
    func IsLegendary() -> Bool {
        return pokemonModel.legendary
    }
    
    func CurrentStat() -> String {
        switch(AppServices.SortingType) {
        case .DamageOutput:
            return String(format: "%.2f", pokemonModel.GetDamageOutputForCurrentSort())
        case .DefendingTank:
            return String(format: "%.2f", pokemonModel.CalculateDefending())
        case .DefendingDuel:
            return String(format: "%.2f", pokemonModel.CalculateDefending(true))
        default:
            break
        }
        
        return String(format: "%.2f", pokemonModel.eDPSAttacking(Active: AppServices.MoveSet_IsActive, STAB: AppServices.MoveSet_STAB))
    }
}

class ExpandableTableCellViewModel {
    // required
//    private(set) public var cellModel:PokemonModel
//    
//    init(PokemonModel pm:PokemonModel) {
//        cellModel = pm
//    }
}
