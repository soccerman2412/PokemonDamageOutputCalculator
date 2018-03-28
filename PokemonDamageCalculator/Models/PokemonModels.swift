//
//  PokemonModels.swift
//  PokemonDamageCalculator
//
//  Created by Taylor Plimpton on 3/28/18.
//  Copyright © 2018 SmallPlanetDigital. All rights reserved.
//

import Foundation

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
}

struct PokemonModel {
    // optional
    var imageUrl:String?
    
    // required
    private(set) public var name:String
    private(set) public var types:Array<PokemonType>
    private(set) public var pokemonNumber:Int
    private(set) public var attack:Int
    private(set) public var defense:Int
    private(set) public var stamina:Int
    private(set) public var generation:Int
    private(set) public var legendary:Bool
    private(set) public var fastMoves:Array<PokemonFastMoveModel>
    private(set) public var chargeMoves:Array<PokemonChargeMoveModel>
    
    init(Name n:String, Types t:Array<PokemonType>, PokemonNumber pn:Int, Atack a:Int, Defense d:Int, Stamina s:Int,
         FastMoves fm:Array<PokemonFastMoveModel>, ChargeMoves cm:Array<PokemonChargeMoveModel>, Generation g:Int, Legendary l:Bool = false) {
        name = n
        types = t
        pokemonNumber = pn
        attack = a
        defense = d
        stamina = s
        fastMoves = fm
        chargeMoves = cm
        generation = g
        legendary = l
    }
    
    func BestAttackingFastMove(_ isSTAB:Bool = false) -> String {
        // TODO
        
        return "N/A"
    }
    
    func BestAttackingChargeMove(_ isSTAB:Bool = false) -> String {
        // TODO
        
        return "N/A"
    }
    
    func BestDefendingFastMove(_ isSTAB:Bool = false) -> String {
        // TODO
        
        return "N/A"
    }
    
    func BestDefendingChargeMove(_ isSTAB:Bool = false) -> String {
        // TODO
        
        return "N/A"
    }
    
    func eDPSAttacking(_ isSTAB:Bool = false) -> Double {
        // TODO
        
        return 0
    }
    
    func eDPSDefending(_ isSTAB:Bool = false) -> Double {
        // TODO
        
        return 0
    }
    
    private func calculate() {
        //=ARRAYFORMULA((J2:J*ROUNDDOWN(100/H2:H))/((100/G2:G)+(ROUNDDOWN(100/H2:H)*I2:I)))
        //(cDamage * floor(100/cEnergyCost)) / ((100/fEPS) + (floor(100/cEnergyCost) * cDuration))
        var eDPS = 0
        for currFastMove in fastMoves {
            let eps = Double(currFastMove.energyGain)/currFastMove.duration
            for currChargeMove in chargeMoves {
                let chargeMovesPer100Energy = Int(floor(100/Double(currChargeMove.energyCost)))
                let totalDamagePer100Energy = currChargeMove.damage * chargeMovesPer100Energy
                let b = 6
            }
        }
    }
}

protocol PokemonMoveProtocol {
    // required
    var name:String {get}
    var type:PokemonType {get}
    var damage:Int {get}
    var duration:Double {get}
    var active:Bool {get}
}

struct PokemonFastMoveModel: PokemonMoveProtocol {
    // protocol vars
    private(set) public var name: String
    private(set) public var type: PokemonType
    private(set) public var damage: Int
    private(set) public var duration: Double
    private(set) public var active: Bool
    
    // model specific vars
    private(set) public var energyGain: Int
    
    init(Name n:String, Type t:PokemonType, Damage d:Int, Duration dur:Double, EnergyGain e:Int, Active a:Bool) {
        name = n
        type = t
        damage = d
        duration = dur
        energyGain = e
        active = a
    }
}

struct PokemonChargeMoveModel: PokemonMoveProtocol {
    // protocol vars
    private(set) public var name: String
    private(set) public var type: PokemonType
    private(set) public var damage: Int
    private(set) public var duration: Double
    private(set) public var active: Bool
    
    // model specific vars
    private(set) public var energyCost: Int
    
    init(Name n:String, Type t:PokemonType, Damage d:Int, Duration dur:Double, EnergyCost e:Int, Active a:Bool) {
        name = n
        type = t
        damage = d
        duration = dur
        energyCost = e
        active = a
    }
}
