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
        case .BestOverallActiveAttacking:
            return String(format: "%.2f", pokemonModel.eDPSAttacking(Active: true))
        case .BestAttackingSTAB:
            return String(format: "%.2f", pokemonModel.eDPSAttacking(Active: false, STAB: true))
        case .BestActiveAttackingSTAB:
            return String(format: "%.2f", pokemonModel.eDPSAttacking(Active: true, STAB: true))
        case .BestDamageOutputAttacking:
            return String(format: "%.2f", pokemonModel.GetDamageOutputForCurrentSort())
        default:
            return String(format: "%.2f", pokemonModel.eDPSAttacking())
        }
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
