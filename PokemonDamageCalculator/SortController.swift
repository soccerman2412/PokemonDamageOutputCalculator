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
    
    static var pokemonCounterType = Array<PokemonType>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func TextEditingDidEnd(_ sender: UITextField) {
        // parse the text for pokemon types and apply these to the sort equation
        if let sortStr = sender.text {
            let sortStrArr = sortStr.split(separator: ",")
            
            if (sortStrArr.count > 0) {
                SortController.pokemonCounterType.removeAll()
            }
            
            for currStr in sortStrArr {
                switch String(currStr).lowercased() {
                case PokemonType.bug.rawValue:
                    SortController.pokemonCounterType.append(.bug)
                case PokemonType.dark.rawValue:
                    SortController.pokemonCounterType.append(.dark)
                case PokemonType.dragon.rawValue:
                    SortController.pokemonCounterType.append(.dragon)
                case PokemonType.electric.rawValue:
                    SortController.pokemonCounterType.append(.electric)
                case PokemonType.fairy.rawValue:
                    SortController.pokemonCounterType.append(.fairy)
                case PokemonType.fighting.rawValue:
                    SortController.pokemonCounterType.append(.fighting)
                case PokemonType.fire.rawValue:
                    SortController.pokemonCounterType.append(.fire)
                case PokemonType.flying.rawValue:
                    SortController.pokemonCounterType.append(.flying)
                case PokemonType.ghost.rawValue:
                    SortController.pokemonCounterType.append(.ghost)
                case PokemonType.grass.rawValue:
                    SortController.pokemonCounterType.append(.grass)
                case PokemonType.ground.rawValue:
                    SortController.pokemonCounterType.append(.ground)
                case PokemonType.ice.rawValue:
                    SortController.pokemonCounterType.append(.ice)
                case PokemonType.normal.rawValue:
                    SortController.pokemonCounterType.append(.normal)
                case PokemonType.poison.rawValue:
                    SortController.pokemonCounterType.append(.poison)
                case PokemonType.psychic.rawValue:
                    SortController.pokemonCounterType.append(.psychic)
                case PokemonType.rock.rawValue:
                    SortController.pokemonCounterType.append(.rock)
                case PokemonType.steel.rawValue:
                    SortController.pokemonCounterType.append(.steel)
                case PokemonType.water.rawValue:
                    SortController.pokemonCounterType.append(.water)
                default:
                    break
                }
            }
            
            // TODO: recalculate pokemon eDPS based on selected types
            
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
    
    @IBAction func CloseSelected(_ sender: UIButton) {
        dismiss(animated: true) {
            // anything needed here?
        }
    }
}
