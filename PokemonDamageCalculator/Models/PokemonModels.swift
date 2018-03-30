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

class PokemonModel {
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
    
    // private
    // NOTE: STAB = Same Type Attack Bonus
    private var bestAttackingFastMove = "N/A"
    private var bestAttackingChargeMove = "N/A"
    private var bestAttackingFastMoveSTAB = "N/A"
    private var bestAttackingChargeMoveSTAB = "N/A"
    private var bestDefendingFastMove = "N/A"
    private var bestDefendingChargeMove = "N/A"
    private var bestDefendingFastMoveSTAB = "N/A"
    private var bestDefendingChargeMoveSTAB = "N/A"
    private var eDPSAttacking = 0.0
    private var eDPSAttackingSTAB = 0.0
    private var eDPSDefending = 0.0
    private var eDPSDefendingSTAB = 0.0
    
    convenience init(Name n:String, Types t:Array<String>, PokemonNumber pn:Int, Atack a:Int, Defense d:Int, Stamina s:Int,
         FastMoves fm:Array<PokemonFastMoveModel>, ChargeMoves cm:Array<PokemonChargeMoveModel>, Generation g:Int, Legendary l:Bool) {
        
        var initTypes = Array<PokemonType>()
        for currT in t {
            if let currType = PokemonType(rawValue: currT) {
                initTypes.append(currType)
            }
        }
        
        self.init(Name: n, Types: initTypes, PokemonNumber: pn, Atack: a, Defense: d, Stamina: s, FastMoves: fm, ChargeMoves: cm, Generation: g, Legendary: l)
    }
    
    init(Name n:String, Types t:Array<PokemonType>, PokemonNumber pn:Int, Atack a:Int, Defense d:Int, Stamina s:Int,
         FastMoves fm:Array<PokemonFastMoveModel>, ChargeMoves cm:Array<PokemonChargeMoveModel>, Generation g:Int, Legendary l:Bool) {
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
        
        calculate()
    }
    
    func BestAttackingFastMove(_ isSTAB:Bool = false) -> String {
        if (isSTAB) {
            return bestAttackingFastMoveSTAB
        }
        
        return bestAttackingFastMove
    }
    
    func BestAttackingChargeMove(_ isSTAB:Bool = false) -> String {
        if (isSTAB) {
            return bestAttackingChargeMoveSTAB
        }
        
        return bestAttackingChargeMove
    }
    
    func BestDefendingFastMove(_ isSTAB:Bool = false) -> String {
        if (isSTAB) {
            return bestDefendingFastMoveSTAB
        }
        
        return bestDefendingFastMove
    }
    
    func BestDefendingChargeMove(_ isSTAB:Bool = false) -> String {
        if (isSTAB) {
            return bestDefendingChargeMoveSTAB
        }
        
        return bestDefendingChargeMove
    }
    
    func eDPSAttacking(_ isSTAB:Bool = false) -> Double {
        if (isSTAB) {
            return eDPSAttackingSTAB
        }
        
        return eDPSAttacking
    }
    
    func eDPSDefending(_ isSTAB:Bool = false) -> Double {
        if (isSTAB) {
            return eDPSDefendingSTAB
        }
        
        return eDPSDefending
    }
    
    private func calculate() {
        //=ARRAYFORMULA((J2:J*ROUNDDOWN(100/H2:H))/((100/G2:G)+(ROUNDDOWN(100/H2:H)*I2:I)))
        //(cDamage * floor(100/cEnergyCost)) / ((100/fEPS) + (floor(100/cEnergyCost) * cDuration))
        
        // TODO: defending calculations
        // TODO: active
        
        for currFastMove in fastMoves {
            let eps = Double(currFastMove.energy)/currFastMove.duration
            let fastMoveIsSTAB = moveIsSTAB(currFastMove)
            for currChargeMove in chargeMoves {
                let chargeMovesPer100Energy = Int(floor(100/Double(currChargeMove.energy)))
                let totalDamagePer100Energy = currChargeMove.damage * chargeMovesPer100Energy
                let secondsToGain100Energy = 100/eps
                let totalChargeMoveDurationPer100Energy = (Double(chargeMovesPer100Energy)*currChargeMove.duration)
                let totalDurationToEarnAndUse100Energy = secondsToGain100Energy + totalChargeMoveDurationPer100Energy
                let currEPDS = Double(totalDamagePer100Energy) / totalDurationToEarnAndUse100Energy
                if (currEPDS > eDPSAttacking) {
                    bestAttackingFastMove = currFastMove.name
                    bestAttackingChargeMove = currChargeMove.name
                    
                    eDPSAttacking = currEPDS
                    
                    if (fastMoveIsSTAB && moveIsSTAB(currChargeMove)) {
                        bestAttackingFastMoveSTAB = currFastMove.name
                        bestAttackingChargeMoveSTAB = currChargeMove.name
                        
                        eDPSAttackingSTAB = currEPDS
                    }
                }
            }
        }
    }
    
    private func moveIsSTAB(_ move:PokemonMoveProtocol) -> Bool {
        for currType in types {
            if (currType == move.type) {
                return true
            }
        }
        
        return false
    }
}

protocol PokemonMoveProtocol {
    // required
    var name:String {get}
    var type:PokemonType {get}
    var damage:Int {get}
    var duration:Double {get}
    var energy:Int {get}
}

struct PokemonFastMoveModel: PokemonMoveProtocol {
    // protocol vars
    private(set) public var name: String
    private(set) public var type: PokemonType
    private(set) public var damage: Int
    private(set) public var duration: Double
    private(set) public  var energy: Int
    
    // model specific vars
    private(set) public var active: Bool
    
    init(Name n:String, Type t:PokemonType, Damage d:Int, Duration dur:Double, EnergyGain e:Int, Active a:Bool) {
        name = n
        type = t
        damage = d
        duration = dur
        energy = e
        active = a
    }
}

struct PokemonChargeMoveModel: PokemonMoveProtocol {
    // protocol vars
    private(set) public var name: String
    private(set) public var type: PokemonType
    private(set) public var damage: Int
    private(set) public var duration: Double
    private(set) public  var energy: Int
    
    // model specific vars
    private(set) public var active: Bool
    
    init(Name n:String, Type t:PokemonType, Damage d:Int, Duration dur:Double, EnergyCost e:Int, Active a:Bool) {
        name = n
        type = t
        damage = d
        duration = dur
        energy = e
        active = a
    }
}
