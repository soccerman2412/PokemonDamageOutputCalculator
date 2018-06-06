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
    @IBOutlet weak var moveSetSTAB_Switch: UISwitch!
    @IBOutlet weak var moveSetLegacy_Switch: UISwitch!
    
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
        
        // set the move set toggles
        moveSetSTAB_Switch?.setOn(AppServices.MoveSet_STAB, animated: false)
        moveSetLegacy_Switch?.setOn(AppServices.MoveSet_IsActive, animated: false)
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
    }
    
    
    
    // MARK: - Helpers
    private func UpdateSort() {
        if let splitVC = presentingViewController as? UISplitViewController {
            let masterNavController = splitVC.viewControllers[0] as! UINavigationController
            if let masterVC = masterNavController.viewControllers[0] as? MasterViewController {
                masterVC.SortObjects()
            } else if let masterVC = masterNavController.viewControllers[0] as? PokemonCollectionViewController {
                masterVC.SortObjects()
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
                AppServices.OpponentPokemonTypes.removeAll()
            }
            
            for currStr in sortStrArr {
                switch String(currStr).lowercased() {
                case PokemonType.bug.rawValue:
                    AppServices.OpponentPokemonTypes.append(.bug)
                case PokemonType.dark.rawValue:
                    AppServices.OpponentPokemonTypes.append(.dark)
                case PokemonType.dragon.rawValue:
                    AppServices.OpponentPokemonTypes.append(.dragon)
                case PokemonType.electric.rawValue:
                    AppServices.OpponentPokemonTypes.append(.electric)
                case PokemonType.fairy.rawValue:
                    AppServices.OpponentPokemonTypes.append(.fairy)
                case PokemonType.fighting.rawValue:
                    AppServices.OpponentPokemonTypes.append(.fighting)
                case PokemonType.fire.rawValue:
                    AppServices.OpponentPokemonTypes.append(.fire)
                case PokemonType.flying.rawValue:
                    AppServices.OpponentPokemonTypes.append(.flying)
                case PokemonType.ghost.rawValue:
                    AppServices.OpponentPokemonTypes.append(.ghost)
                case PokemonType.grass.rawValue:
                    AppServices.OpponentPokemonTypes.append(.grass)
                case PokemonType.ground.rawValue:
                    AppServices.OpponentPokemonTypes.append(.ground)
                case PokemonType.ice.rawValue:
                    AppServices.OpponentPokemonTypes.append(.ice)
                case PokemonType.normal.rawValue:
                    AppServices.OpponentPokemonTypes.append(.normal)
                case PokemonType.poison.rawValue:
                    AppServices.OpponentPokemonTypes.append(.poison)
                case PokemonType.psychic.rawValue:
                    AppServices.OpponentPokemonTypes.append(.psychic)
                case PokemonType.rock.rawValue:
                    AppServices.OpponentPokemonTypes.append(.rock)
                case PokemonType.steel.rawValue:
                    AppServices.OpponentPokemonTypes.append(.steel)
                case PokemonType.water.rawValue:
                    AppServices.OpponentPokemonTypes.append(.water)
                default:
                    break
                }
            }
            
            // recalculate pokemon eDPS based on selected types
            for currPokemon in AppServices.Pokemon {
                currPokemon.CalculateDamage()
            }
        }
    }
    
    @IBAction func STAB_ValueChanged(_ sender: UISwitch, forEvent event: UIEvent) {
        AppServices.MoveSet_STAB = sender.isOn
    }
    
    @IBAction func ShowLegacy_ValueChanged(_ sender: UISwitch, forEvent event: UIEvent) {
        AppServices.MoveSet_IsActive = sender.isOn
    }
    
    @IBAction func SortOn_eDPS(_ sender: UIButton, forEvent event: UIEvent) {
        AppServices.SortingType = .eDPS
        
//        AppServices.SortingType = .BestOverallAttacking
//
//        if (stab_moveset) {
//            AppServices.SortingType = .BestAttackingSTAB
//
//            if (!legacy_moveset) {
//                AppServices.SortingType = .BestActiveAttackingSTAB
//            }
//        } else if (!legacy_moveset) {
//            AppServices.SortingType = .BestOverallActiveAttacking
//        }
    }
    
    @IBAction func DamageOutputAttacking(_ sender: UIButton) {
        AppServices.SortingType = .DamageOutput
    }
    
    @IBAction func Defending(_ sender: UIButton) {
        AppServices.SortingType = .Defending
    }
    
    @IBAction func CloseSelected(_ sender: UIButton) {
        UpdateSort()
        
        dismiss(animated: true) {
            // anything needed here?
        }
    }
}
