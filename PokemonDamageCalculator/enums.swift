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
    case eDPS // DEFAULT
    case DamageOutput
    case Defending
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



// MARK: WeatherType
enum WeatherType:String {
    case None
    case Sunny
    case Clear
    case Rainy
    case PartlyCloudy
    case Cloudy
    case Windy
    case Snow
    case Fog
    
    func BoostedTypes() -> Array<PokemonType> {
        switch self {
        case .Sunny, .Clear:
            return [.Grass, .Fire, .Ground]
        case .Rainy:
            return [.Water, .Electric,. Bug]
        case .PartlyCloudy:
            return [.Normal, .Rock]
        case .Cloudy:
            return [.Fairy, .Fighting, .Poison]
        case .Windy:
            return [.Flying, .Dragon, .Psychic]
        case .Snow:
            return [.Ice, .Steel]
        case .Fog:
            return [.Dark, .Ghost]
        default:
            break
        }
        
        return Array<PokemonType>()
    }
}



// MARK: - PokemonType
enum PokemonType:String {
    case None
    case Normal
    case Fighting
    case Flying
    case Poison
    case Ground
    case Rock
    case Bug
    case Ghost
    case Steel
    case Fire
    case Water
    case Grass
    case Electric
    case Psychic
    case Ice
    case Dragon
    case Dark
    case Fairy
    
    // chart for the following: https://pokeassistant.com/typechart?locale=en
    func ModifierAgainstType(Type otherType:PokemonType) -> Double {
        let superIneffective = 0.51
        let ineffective = 0.714
        let superEffective = 1.4
        
        var returnVal = 1.0 // effective/normal
        
        switch self {
        case .Normal:
            switch otherType {
            case .Ghost:
                returnVal = superIneffective
            case .Rock, .Steel:
                returnVal = ineffective
            default:
                break
            }
            
        case .Fighting:
            switch otherType {
            case .Ghost:
                returnVal = superIneffective
            case .Flying, .Poison, .Bug, .Psychic, .Fairy:
                returnVal = ineffective
            case .Normal, .Rock, .Steel, .Ice, .Dark:
                returnVal = superEffective
            default:
                break
            }
            
        case .Flying:
            switch otherType {
            case .Rock, .Steel, .Electric:
                returnVal = ineffective
            case .Fighting, .Bug, .Grass:
                returnVal = superEffective
            default:
                break
            }
            
        case .Poison:
            switch otherType {
            case .Steel:
                returnVal = superIneffective
            case .Poison, .Ground, .Rock, .Ghost:
                returnVal = ineffective
            case .Grass, .Fairy:
                returnVal = superEffective
            default:
                break
            }
            
        case .Ground:
            switch otherType {
            case .Flying:
                returnVal = superIneffective
            case .Bug, .Grass:
                returnVal = ineffective
            case .Poison, .Rock, .Steel, .Fire, .Electric:
                returnVal = superEffective
            default:
                break
            }
            
        case .Rock:
            switch otherType {
            case .Fighting, .Ground, .Steel:
                returnVal = ineffective
            case .Flying, .Bug, .Fire, .Ice:
                returnVal = superEffective
            default:
                break
            }
            
        case .Bug:
            switch otherType {
            case .Fighting, .Flying, .Poison, .Ghost, .Steel, .Fire, .Fairy:
                returnVal = ineffective
            case .Grass, .Psychic, .Dark:
                returnVal = superEffective
            default:
                break
            }
            
        case .Ghost:
            switch otherType {
            case .Normal:
                returnVal = superIneffective
            case .Dark:
                returnVal = ineffective
            case .Ghost, .Psychic:
                returnVal = superEffective
            default:
                break
            }
            
        case .Steel:
            switch otherType {
            case .Steel, .Fire, .Water, .Electric:
                returnVal = ineffective
            case .Rock, .Ice, .Fairy:
                returnVal = superEffective
            default:
                break
            }
            
        case .Fire:
            switch otherType {
            case .Rock, .Fire, .Water, .Dragon:
                returnVal = ineffective
            case .Bug, .Steel, .Grass, .Ice:
                returnVal = superEffective
            default:
                break
            }
            
        case .Water:
            switch otherType {
            case .Water, .Grass, .Dragon:
                returnVal = ineffective
            case .Ground, .Rock, .Fire:
                returnVal = superEffective
            default:
                break
            }
            
        case .Grass:
            switch otherType {
            case .Flying, .Poison, .Bug, .Steel, .Fire, .Grass, .Dragon:
                returnVal = ineffective
            case .Ground, .Rock, .Water:
                returnVal = superEffective
            default:
                break
            }
            
        case .Electric:
            switch otherType {
            case .Ground:
                returnVal = superIneffective
            case .Grass, .Electric, .Dragon:
                returnVal = ineffective
            case .Flying, .Water:
                returnVal = superEffective
            default:
                break
            }
            
        case .Psychic:
            switch otherType {
            case .Dark:
                returnVal = superIneffective
            case .Steel, .Psychic:
                returnVal = ineffective
            case .Fighting, .Poison:
                returnVal = superEffective
            default:
                break
            }
            
        case .Ice:
            switch otherType {
            case .Steel, .Fire, .Water, .Ice:
                returnVal = ineffective
            case .Flying, .Ground, .Grass, .Dragon:
                returnVal = superEffective
            default:
                break
            }
            
        case .Dragon:
            switch otherType {
            case .Fairy:
                returnVal = superIneffective
            case .Steel:
                returnVal = ineffective
            case .Dragon:
                returnVal = superEffective
            default:
                break
            }
            
        case .Dark:
            switch otherType {
            case .Fighting, .Dark, .Fairy:
                returnVal = ineffective
            case .Ghost, .Psychic:
                returnVal = superEffective
            default:
                break
            }
            
        case .Fairy:
            switch otherType {
            case .Poison, .Steel, .Fire:
                returnVal = ineffective
            case .Fighting, .Dragon, .Dark:
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
