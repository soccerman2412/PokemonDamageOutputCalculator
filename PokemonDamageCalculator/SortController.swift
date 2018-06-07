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
    
    private var sortingChanged = true // TODO: could be smarter if user sets options back to the previous value
    
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
        
        sortingChanged = true
    }
    
    
    
    // MARK: - Helpers
    private func UpdateSort() {
        // recalculate pokemon eDPS based on selected options
        for currPokemon in AppServices.Pokemon {
            currPokemon.CalculateDamage()
        }
        
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
    
    @IBAction func STAB_ValueChanged(_ sender: UISwitch, forEvent event: UIEvent) {
        AppServices.MoveSet_STAB = sender.isOn
        
        sortingChanged = true
    }
    
    @IBAction func ShowLegacy_ValueChanged(_ sender: UISwitch, forEvent event: UIEvent) {
        AppServices.MoveSet_IsActive = sender.isOn
        
        sortingChanged = true
    }
    
    @IBAction func SortOn_eDPS(_ sender: UIButton, forEvent event: UIEvent) {
        AppServices.SortingType = .eDPS
        
        sortingChanged = true
    }
    
    @IBAction func DamageOutputAttacking(_ sender: UIButton) {
        AppServices.SortingType = .DamageOutput
        
        sortingChanged = true
    }
    
    @IBAction func Defending(_ sender: UIButton) {
        AppServices.SortingType = .DefendingTank
        
        sortingChanged = true
    }
    
    @IBAction func DefendingDuel(_ sender: UIButton) {
        AppServices.SortingType = .DefendingDuel
        
        sortingChanged = true
    }
    
    @IBAction func CloseSelected(_ sender: UIButton) {
        /*if (sortingChanged) {*/
            UpdateSort()
        //}
        
        // perform after delay?
        
        dismiss(animated: true) {
            // anything needed here?
        }
    }
}
