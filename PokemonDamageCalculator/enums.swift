//
//  enums.swift
//  PokemonDamageCalculator
//
//  Created by Taylor Plimpton on 4/13/18.
//  Copyright © 2018 SmallPlanetDigital. All rights reserved.
//

import Foundation

// MARK: SortType

enum SortType:Int {
    case BestOverallAttacking // DEFAULT
    case BestOverallActiveAttacking
    case BestAttackingSTAB
    case BestActiveAttackingSTAB
    case BestOverallDefending
    case BestOverallActiveDefending
    case BestDefendingSTAB
    case BestActiveDefendingSTAB
    case BestCounterToTypes
}



// MARK: SortType

enum FilterType:Int {
    case Generation1
    case Generation2
    case Generation3
    case Legendary
    case Types
    case Weather
}



// MARK: - PokemonType

enum PokemonType:String {
    case none
    case normal
    case fighting
    case flying
    case poison
    case ground
    case rock
    case bug
    case ghost
    case steel
    case fire
    case water
    case grass
    case electric
    case psychic
    case ice
    case dragon
    case dark
    case fairy
    
    // chart for the following: https://pokeassistant.com/typechart?locale=en
    func ModifierAgainstType(Type otherType:PokemonType) -> Double {
        let superIneffective = 0.51
        let ineffective = 0.714
        let superEffective = 1.4
        
        var returnVal = 1.0 // effective/normal
        
        switch self {
        case .normal:
            switch otherType {
            case .ghost:
                returnVal = superIneffective
            case .rock, .steel:
                returnVal = ineffective
            default:
                break
            }
            
        case .fighting:
            switch otherType {
            case .ghost:
                returnVal = superIneffective
            case .flying, .poison, .bug, .psychic, .fairy:
                returnVal = ineffective
            case .normal, .rock, .steel, .ice, .dark:
                returnVal = superEffective
            default:
                break
            }
            
        case .flying:
            switch otherType {
            case .rock, .steel, .electric:
                returnVal = ineffective
            case .fighting, .bug, .grass:
                returnVal = superEffective
            default:
                break
            }
            
        case .poison:
            switch otherType {
            case .steel:
                returnVal = superIneffective
            case .poison, .ground, .rock, .ghost:
                returnVal = ineffective
            case .grass, .fairy:
                returnVal = superEffective
            default:
                break
            }
            
        case .ground:
            switch otherType {
            case .flying:
                returnVal = superIneffective
            case .bug, .grass:
                returnVal = ineffective
            case .poison, .rock, .steel, .fire, .electric:
                returnVal = superEffective
            default:
                break
            }
            
        case .rock:
            switch otherType {
            case .fighting, .ground, .steel:
                returnVal = ineffective
            case .flying, .bug, .fire, .ice:
                returnVal = superEffective
            default:
                break
            }
            
        case .bug:
            switch otherType {
            case .fighting, .flying, .poison, .ghost, .steel, .fire, .fairy:
                returnVal = ineffective
            case .grass, .psychic, .dark:
                returnVal = superEffective
            default:
                break
            }
            
        case .ghost:
            switch otherType {
            case .normal:
                returnVal = superIneffective
            case .dark:
                returnVal = ineffective
            case .ghost, .psychic:
                returnVal = superEffective
            default:
                break
            }
            
        case .steel:
            switch otherType {
            case .steel, .fire, .water, .electric:
                returnVal = ineffective
            case .rock, .ice, .fairy:
                returnVal = superEffective
            default:
                break
            }
            
        case .fire:
            switch otherType {
            case .rock, .fire, .water, .dragon:
                returnVal = ineffective
            case .bug, .steel, .grass, .ice:
                returnVal = superEffective
            default:
                break
            }
            
        case .water:
            switch otherType {
            case .water, .grass, .dragon:
                returnVal = ineffective
            case .ground, .rock, .fire:
                returnVal = superEffective
            default:
                break
            }
            
        case .grass:
            switch otherType {
            case .flying, .poison, .bug, .steel, .fire, .grass, .dragon:
                returnVal = ineffective
            case .ground, .rock, .water:
                returnVal = superEffective
            default:
                break
            }
            
        case .electric:
            switch otherType {
            case .ground:
                returnVal = superIneffective
            case .grass, .electric, .dragon:
                returnVal = ineffective
            case .flying, .water:
                returnVal = superEffective
            default:
                break
            }
            
        case .psychic:
            switch otherType {
            case .dark:
                returnVal = superIneffective
            case .steel, .psychic:
                returnVal = ineffective
            case .fighting, .poison:
                returnVal = superEffective
            default:
                break
            }
            
        case .ice:
            switch otherType {
            case .steel, .fire, .water, .ice:
                returnVal = ineffective
            case .flying, .ground, .grass, .dragon:
                returnVal = superEffective
            default:
                break
            }
            
        case .dragon:
            switch otherType {
            case .fairy:
                returnVal = superIneffective
            case .steel:
                returnVal = ineffective
            case .dragon:
                returnVal = superEffective
            default:
                break
            }
            
        case .dark:
            switch otherType {
            case .fighting, .dark, .fairy:
                returnVal = ineffective
            case .ghost, .psychic:
                returnVal = superEffective
            default:
                break
            }
            
        case .fairy:
            switch otherType {
            case .poison, .steel, .fire:
                returnVal = ineffective
            case .fighting, .dragon, .dark:
                returnVal = superEffective
            default:
                break
            }
            
        default:
            break
        }
        
        return returnVal
    }
}
