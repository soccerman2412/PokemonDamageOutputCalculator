//
//  Sort_OpponentTypesController.swift
//  PokemonDamageCalculator
//
//  Created by Taylor Plimpton on 6/6/18.
//  Copyright © 2018 SmallPlanetDigital. All rights reserved.
//

import Foundation
import UIKit

class Sort_OpponentTypesController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var pickerView_A: UIPickerView!
    @IBOutlet weak var pickerView_B: UIPickerView!
    
    private let pokemonTypes = [PokemonType.None, PokemonType.Bug, PokemonType.Dark, PokemonType.Dragon, PokemonType.Electric, PokemonType.Fairy,
                                PokemonType.Fighting, PokemonType.Fire, PokemonType.Flying, PokemonType.Ghost, PokemonType.Grass, PokemonType.Ground,
                                PokemonType.Ice, PokemonType.Normal, PokemonType.Poison, PokemonType.Psychic, PokemonType.Rock, PokemonType.Steel, PokemonType.Water]
    
    private var previousSelection_A = PokemonType.None
    private var previousSelection_B = PokemonType.None
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // default to the last selected opponent types
        for i in 0..<pokemonTypes.count {
            if (pickerView_A != nil && AppServices.OpponentPokemonTypes[0] == pokemonTypes[i]) {
                pickerView_A.selectRow(i, inComponent: 0, animated: false)
            }
            if (pickerView_B != nil && AppServices.OpponentPokemonTypes[1] == pokemonTypes[i]) {
                pickerView_B.selectRow(i, inComponent: 0, animated: false)
            }
        }
    }
    
    
    
    // MARK: - UIPickerViewDataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pokemonTypes.count
    }
    
    
    
    // MARK: - UIPickerViewDelegate
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let pTypeStr = pokemonTypes[row].rawValue
        let pTypeStr_Attributed = NSMutableAttributedString(string: pTypeStr)
        
        // indicate that the user can not select the same type for both pickers
        if (pokemonTypes[row] != .None) {
            if (pickerView == pickerView_A) {
                if (AppServices.OpponentPokemonTypes[1] == pokemonTypes[row]) {
                    // add strikethrough attribute to the whole string
                    //NSUnderlineStyle.styleSingle
                    pTypeStr_Attributed.addAttribute(.strikethroughStyle, value: 2, range: NSMakeRange(0, pTypeStr_Attributed.length))
                }
            } else if (pickerView == pickerView_B) {
                if (AppServices.OpponentPokemonTypes[0] == pokemonTypes[row]) {
                    // add strikethrough attribute to the whole string
                    pTypeStr_Attributed.addAttribute(.strikethroughStyle, value: 2, range: NSMakeRange(0, pTypeStr_Attributed.length))
                }
            }
        }
        
        return pTypeStr_Attributed
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (pickerView == pickerView_A) {
            previousSelection_A = AppServices.OpponentPokemonTypes[0]
            
            // make sure we don't end up with both types being the same
            if (AppServices.OpponentPokemonTypes[1] == pokemonTypes[row]) {
                AppServices.OpponentPokemonTypes[0] = .None
            } else {
                AppServices.OpponentPokemonTypes[0] = pokemonTypes[row]
            }
        } else if (pickerView == pickerView_B) {
            previousSelection_B = AppServices.OpponentPokemonTypes[1]
            
            // make sure we don't end up with both types being the same
            if (AppServices.OpponentPokemonTypes[0] == pokemonTypes[row]) {
                AppServices.OpponentPokemonTypes[1] = .None
            } else {
                AppServices.OpponentPokemonTypes[1] = pokemonTypes[row]
            }
            
        }
    }
}
