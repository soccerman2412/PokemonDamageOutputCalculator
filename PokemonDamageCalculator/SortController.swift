//
//  SortController.swift
//  PokemonDamageCalculator
//
//  Created by Taylor Plimpton on 4/13/18.
//  Copyright © 2018 SmallPlanetDigital. All rights reserved.
//

import Foundation
import UIKit

class SortController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var weatherPicker: UIPickerView!
    
    private let weatherTypes = [WeatherType.None, WeatherType.Clear, WeatherType.Sunny, WeatherType.Cloudy,
                                WeatherType.PartlyCloudy, WeatherType.Windy, WeatherType.Fog, WeatherType.Rainy, WeatherType.Snow]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // default to the last selected weather type
        if (weatherPicker != nil) {
            for i in 0..<weatherTypes.count {
                if (AppServices.ActiveWeather == weatherTypes[i]) {
                    weatherPicker.selectRow(i, inComponent: 0, animated: false)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    // MARK: - UIPickerViewDataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return weatherTypes.count
    }
    
    
    
    // MARK: - UIPickerViewDelegate
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return weatherTypes[row].rawValue
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        AppServices.ActiveWeather = weatherTypes[row]
        
        // recalculate pokemon eDPS based on selected types
        for currPokemon in AppServices.Pokemon {
            currPokemon.CalculateDamage()
        }
        
        UpdateSort()
    }
    
    
    
    // MARK: - Helpers
    private func UpdateSort(DmgOutput dmg:Bool = false, Def def:Bool = false) {
        if let splitVC = presentingViewController as? UISplitViewController {
            let masterNavController = splitVC.viewControllers[0] as! UINavigationController
            if let masterVC = masterNavController.viewControllers[0] as? MasterViewController {
                masterVC.SortObjects()
            } else if let masterVC = masterNavController.viewControllers[0] as? PokemonCollectionViewController {
                masterVC.SortObjects(DmgOutput: dmg, Def: def)
            }
        }
    }
    
    
    
    // MARK: - IBActions
    @IBAction func CounterToTypes_TextEditingDidEnd(_ sender: UITextField) {
        // parse the text for pokemon types and apply these to the sort equation
        if let sortStr = sender.text {
            // first remove all whitespace
            let adjustedSortStr = sortStr.replacingOccurrences(of: " ", with: "")
            
            // then we'll split on ','
            let sortStrArr = adjustedSortStr.split(separator: ",")
            
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
            
            UpdateSort()
        }
    }
    
    @IBAction func STAB_ValueChanged(_ sender: UISwitch, forEvent event: UIEvent) {
    }
    
    @IBAction func ShowLegacy_ValueChanged(_ sender: UISwitch, forEvent event: UIEvent) {
    }
    
    @IBAction func SortOnAttacking_eDPS(_ sender: UIButton) {
        AppServices.SortingType = .BestOverallAttacking
        
        UpdateSort()
    }
    
    @IBAction func SortOnActiveAttacking_eDPS(_ sender: UIButton) {
        AppServices.SortingType = .BestOverallActiveAttacking
        
        UpdateSort()
    }
    
    @IBAction func SortOnAttackingSTAB_eDPS(_ sender: UIButton) {
        AppServices.SortingType = .BestAttackingSTAB
        
        UpdateSort()
    }
    
    @IBAction func SortOnActiveAttackingSTAB_eDPS(_ sender: UIButton) {
        AppServices.SortingType = .BestActiveAttackingSTAB
        
        UpdateSort()
    }
    
    @IBAction func DamageOutputAttacking(_ sender: UIButton) {
        //AppServices.SortingType = .BestDamageOutputAttacking
        
        UpdateSort(DmgOutput: true)
    }
    
    @IBAction func Defending(_ sender: UIButton) {
        UpdateSort(DmgOutput: false, Def: true)
    }
    
    @IBAction func CloseSelected(_ sender: UIButton) {
        dismiss(animated: true) {
            // anything needed here?
        }
    }
}
