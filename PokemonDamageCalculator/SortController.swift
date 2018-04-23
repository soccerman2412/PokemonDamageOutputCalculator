//
//  SortController.swift
//  PokemonDamageCalculator
//
//  Created by Taylor Plimpton on 4/13/18.
//  Copyright © 2018 SmallPlanetDigital. All rights reserved.
//

import Foundation
import UIKit

class SortController: UIViewController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func CounterToTypes_TextEditingDidEnd(_ sender: UITextField) {
        // parse the text for pokemon types and apply these to the sort equation
        if let sortStr = sender.text {
            let sortStrArr = sortStr.split(separator: ",")
            
            if (sortStrArr.count > 0) {
                AppServices.PokemonCounterType.removeAll()
            }
            
            for currStr in sortStrArr {
                switch String(currStr).lowercased() {
                case PokemonType.bug.rawValue:
                    AppServices.PokemonCounterType.append(.bug)
                case PokemonType.dark.rawValue:
                    AppServices.PokemonCounterType.append(.dark)
                case PokemonType.dragon.rawValue:
                    AppServices.PokemonCounterType.append(.dragon)
                case PokemonType.electric.rawValue:
                    AppServices.PokemonCounterType.append(.electric)
                case PokemonType.fairy.rawValue:
                    AppServices.PokemonCounterType.append(.fairy)
                case PokemonType.fighting.rawValue:
                    AppServices.PokemonCounterType.append(.fighting)
                case PokemonType.fire.rawValue:
                    AppServices.PokemonCounterType.append(.fire)
                case PokemonType.flying.rawValue:
                    AppServices.PokemonCounterType.append(.flying)
                case PokemonType.ghost.rawValue:
                    AppServices.PokemonCounterType.append(.ghost)
                case PokemonType.grass.rawValue:
                    AppServices.PokemonCounterType.append(.grass)
                case PokemonType.ground.rawValue:
                    AppServices.PokemonCounterType.append(.ground)
                case PokemonType.ice.rawValue:
                    AppServices.PokemonCounterType.append(.ice)
                case PokemonType.normal.rawValue:
                    AppServices.PokemonCounterType.append(.normal)
                case PokemonType.poison.rawValue:
                    AppServices.PokemonCounterType.append(.poison)
                case PokemonType.psychic.rawValue:
                    AppServices.PokemonCounterType.append(.psychic)
                case PokemonType.rock.rawValue:
                    AppServices.PokemonCounterType.append(.rock)
                case PokemonType.steel.rawValue:
                    AppServices.PokemonCounterType.append(.steel)
                case PokemonType.water.rawValue:
                    AppServices.PokemonCounterType.append(.water)
                default:
                    break
                }
            }
            
            // recalculate pokemon eDPS based on selected types
            for currPokemon in AppServices.Pokemon {
                currPokemon.CalculateDamage()
            }
            
            if let masterVC = presentingViewController as? MasterViewController {
                masterVC.SortObjects()
            } else if let splitVC = presentingViewController as? UISplitViewController {
                let masterNavController = splitVC.viewControllers[0] as! UINavigationController
                let masterVC = masterNavController.viewControllers[0] as! MasterViewController
                masterVC.SortObjects()
            }
        }
    }
    
    @IBAction func CurrentWeather_TextEditingDidEnd(_ sender: UITextField) {
        if let sortStr = sender.text {
            let adjustedSortStr = sortStr.replacingOccurrences(of: " ", with: "")
            
            switch String(adjustedSortStr).lowercased() {
            case WeatherType.Clear.rawValue.lowercased():
                AppServices.ActiveWeather = .Clear
            case WeatherType.Cloudy.rawValue.lowercased():
                AppServices.ActiveWeather = .Cloudy
            case WeatherType.Fog.rawValue.lowercased():
                AppServices.ActiveWeather = .Fog
            case WeatherType.PartlyCloudy.rawValue.lowercased():
                AppServices.ActiveWeather = .PartlyCloudy
            case WeatherType.Rainy.rawValue.lowercased():
                AppServices.ActiveWeather = .Rainy
            case WeatherType.Snow.rawValue.lowercased():
                AppServices.ActiveWeather = .Snow
            case WeatherType.Sunny.rawValue.lowercased():
                AppServices.ActiveWeather = .Sunny
            case WeatherType.Windy.rawValue.lowercased():
                AppServices.ActiveWeather = .Windy
            default:
                break
            }
            
            // recalculate pokemon eDPS based on selected types
            for currPokemon in AppServices.Pokemon {
                currPokemon.CalculateDamage()
            }
            
            if let masterVC = presentingViewController as? MasterViewController {
                masterVC.SortObjects()
            } else if let splitVC = presentingViewController as? UISplitViewController {
                let masterNavController = splitVC.viewControllers[0] as! UINavigationController
                let masterVC = masterNavController.viewControllers[0] as! MasterViewController
                masterVC.SortObjects()
            }
        }
    }
    
    @IBAction func SortOnAttacking_eDPS(_ sender: UIButton) {
        AppServices.SortingType = .BestOverallAttacking
        
        if let masterVC = presentingViewController as? MasterViewController {
            masterVC.SortObjects()
        } else if let splitVC = presentingViewController as? UISplitViewController {
            let masterNavController = splitVC.viewControllers[0] as! UINavigationController
            let masterVC = masterNavController.viewControllers[0] as! MasterViewController
            masterVC.SortObjects()
        }
    }
    
    @IBAction func SortOnActiveAttacking_eDPS(_ sender: UIButton) {
        AppServices.SortingType = .BestOverallActiveAttacking
        
        if let masterVC = presentingViewController as? MasterViewController {
            masterVC.SortObjects()
        } else if let splitVC = presentingViewController as? UISplitViewController {
            let masterNavController = splitVC.viewControllers[0] as! UINavigationController
            let masterVC = masterNavController.viewControllers[0] as! MasterViewController
            masterVC.SortObjects()
        }
    }
    
    @IBAction func SortOnAttackingSTAB_eDPS(_ sender: UIButton) {
        AppServices.SortingType = .BestAttackingSTAB
        
        if let masterVC = presentingViewController as? MasterViewController {
            masterVC.SortObjects()
        } else if let splitVC = presentingViewController as? UISplitViewController {
            let masterNavController = splitVC.viewControllers[0] as! UINavigationController
            let masterVC = masterNavController.viewControllers[0] as! MasterViewController
            masterVC.SortObjects()
        }
    }
    
    @IBAction func SortOnActiveAttackingSTAB_eDPS(_ sender: UIButton) {
        AppServices.SortingType = .BestActiveAttackingSTAB
        
        if let masterVC = presentingViewController as? MasterViewController {
            masterVC.SortObjects()
        } else if let splitVC = presentingViewController as? UISplitViewController {
            let masterNavController = splitVC.viewControllers[0] as! UINavigationController
            let masterVC = masterNavController.viewControllers[0] as! MasterViewController
            masterVC.SortObjects()
        }
    }
    
    @IBAction func DamageOutputAttacking(_ sender: UIButton) {
        AppServices.SortingType = .BestDamageOutputAttacking
        
        if let masterVC = presentingViewController as? MasterViewController {
            masterVC.SortObjects()
        } else if let splitVC = presentingViewController as? UISplitViewController {
            let masterNavController = splitVC.viewControllers[0] as! UINavigationController
            let masterVC = masterNavController.viewControllers[0] as! MasterViewController
            masterVC.SortObjects()
        }
    }
    
    @IBAction func CloseSelected(_ sender: UIButton) {
        dismiss(animated: true) {
            // anything needed here?
        }
    }
}
