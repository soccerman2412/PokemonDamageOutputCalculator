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
    
    @IBAction func TextEditingDidEnd(_ sender: UITextField) {
        // parse the text for pokemon types and apply these to the sort equation
    }
    
    @IBAction func CloseSelected(_ sender: UIButton) {
        dismiss(animated: true) {
            // anything needed here?
        }
    }
}
