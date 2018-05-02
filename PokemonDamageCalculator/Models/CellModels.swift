//
//  CellModels.swift
//  PokemonDamageCalculator
//
//  Created by Taylor Plimpton on 5/2/18.
//  Copyright © 2018 SmallPlanetDigital. All rights reserved.
//

import Foundation

struct ExpandableTableCellModel {
    var IsOpen = false
    
    private(set) public var cellData = Array<Any>()
    
    init(CellData data:Array<Any>) {
        cellData.append(contentsOf: data)
    }
}
