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
    
    private(set) public var fastMoves = Array<PokemonFastMoveModel>()
    private(set) public var chargeMoves = Array<PokemonChargeMoveModel>()
    
    // private
    // NOTE: STAB = Same Type Attack Bonus
    private var fastMovesInfo = Array<PokemonMoveSimpleModel>()
    private var chargeMovesInfo = Array<PokemonMoveSimpleModel>()
    
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
    
    init(Name n:String, Types t:Array<PokemonType>, PokemonNumber pn:Int, Atack a:Int, Defense d:Int, Stamina s:Int,
         FastMoves fm:Array<PokemonMoveSimpleModel>, ChargeMoves cm:Array<PokemonMoveSimpleModel>, Generation g:Int, Legendary l:Bool) {
        name = n
        types = t
        pokemonNumber = pn
        attack = a
        defense = d
        stamina = s
        generation = g
        legendary = l
        fastMovesInfo = fm
        chargeMovesInfo = cm
    }
    
    convenience init(Name n:String, Types t:Array<String>, PokemonNumber pn:Int, Atack a:Int, Defense d:Int, Stamina s:Int,
         FastMoves fm:Array<PokemonMoveSimpleModel>, ChargeMoves cm:Array<PokemonMoveSimpleModel>, Generation g:Int, Legendary l:Bool) {
        // convert the string array of types 
        var initTypes = Array<PokemonType>()
        for currT in t {
            if let currType = PokemonType(rawValue: currT) {
                initTypes.append(currType)
            }
        }
        
        self.init(Name: n, Types: initTypes, PokemonNumber: pn, Atack: a, Defense: d, Stamina: s,
                  FastMoves: fm, ChargeMoves: cm, Generation: g, Legendary: l)
    }
    
    func BestAttackingFastMove(_ isSTAB:Bool = false) -> String {
        if (isSTAB) {
            return bestAttackingFastMoveSTAB
        }
        
        return bestAttackingFastMove
    }
    
//    func fastMoveAttackingDPS( _ isSTAB:Bool = false) -> Double {
//        
//    }
    
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
    
    func FindMoves() {
        for currFastMoveInfo in fastMovesInfo {
            if let move = AppServices.FastMoves[currFastMoveInfo.name] {
                let moveModel = PokemonFastMoveModel(FastMove: move, Active: currFastMoveInfo.active)
                fastMoves.append(moveModel)
            }
        }
        
        for currChargeMoveInfo in chargeMovesInfo {
            if let move = AppServices.ChargeMoves[currChargeMoveInfo.name] {
                let moveModel = PokemonChargeMoveModel(ChargeMove: move, Active: currChargeMoveInfo.active)
                chargeMoves.append(moveModel)
            }
        }
        
        calculate()
    }
    
    private func calculate() {
        //=ARRAYFORMULA((J2:J*ROUNDDOWN(100/H2:H))/((100/G2:G)+(ROUNDDOWN(100/H2:H)*I2:I)))
        //(cDamage * floor(100/cEnergyCost)) / ((100/fEPS) + (floor(100/cEnergyCost) * cDuration))
        
        // TODO: defending calculations
        // TODO: active
        
        for currFastMove in fastMoves {
            let eps = Double(currFastMove.EnergyGain())/currFastMove.Duration()
            let fastMoveIsSTAB = moveIsSTAB(currFastMove.moveModel)
            for currChargeMove in chargeMoves {
                let chargeMoveIsSTAB = moveIsSTAB(currChargeMove.moveModel)
                let chargeMovesPer100Energy = Int(floor(100/Double(currChargeMove.EnergyCost())))
                let totalDamagePer100Energy = (currChargeMove.Damage() + Int(chargeMoveIsSTAB ? Double(currChargeMove.Damage())*0.2 : 0)) * chargeMovesPer100Energy
                let secondsToGain100Energy = 100/eps
                let totalChargeMoveDurationPer100Energy = (Double(chargeMovesPer100Energy)*currChargeMove.Duration())
                let totalDurationToEarnAndUse100Energy = secondsToGain100Energy + totalChargeMoveDurationPer100Energy
                let currEPDS = Double(totalDamagePer100Energy) / totalDurationToEarnAndUse100Energy
                
                if (currEPDS > eDPSAttacking) {
                    bestAttackingFastMove = currFastMove.Name()
                    bestAttackingChargeMove = currChargeMove.Name()
                    
                    eDPSAttacking = currEPDS
                }
                
                if (fastMoveIsSTAB && chargeMoveIsSTAB && currEPDS > eDPSAttackingSTAB) {
                    bestAttackingFastMoveSTAB = currFastMove.Name()
                    bestAttackingChargeMoveSTAB = currChargeMove.Name()
                    
                    eDPSAttackingSTAB = currEPDS
                }
            }
        }
    }
    
    private func moveIsSTAB(_ move:PokemonMoveModel) -> Bool {
        for currType in types {
            if (currType == move.type) {
                return true
            }
        }
        
        return false
    }
}

struct PokemonMoveSimpleModel {
    private(set) public var name:String
    private(set) public var active:Bool
    
    init(Name n:String, Active a:Bool) {
        name = n
        active = a
    }
}

struct PokemonMoveModel {
    private(set) public var name:String
    private(set) public var type:PokemonType
    private(set) public var damage:Int
    private(set) public var duration:Double
    private(set) public var energy:Int
    
    init(Name n:String, Type t:PokemonType, Damage d:Int, Duration dur:Double, Energy e:Int) {
        name = n
        type = t
        damage = d
        duration = dur
        energy = e
    }
}

struct PokemonFastMoveModel {
    private(set) public var moveModel:PokemonMoveModel
    private(set) public var active:Bool
    
    init(FastMove fm:PokemonMoveModel, Active a:Bool) {
        moveModel = fm
        active = a
    }
    
    init(Name n:String, Type t:PokemonType, Damage d:Int, Duration dur:Double, EnergyGain e:Int, Active a:Bool) {
        self.init(FastMove: PokemonMoveModel(Name: n, Type: t, Damage: d, Duration: dur, Energy: e), Active: a)
    }
    
    func Name() -> String {
        return moveModel.name
    }
    
    func Type() -> PokemonType {
        return moveModel.type
    }
    
    func Damage() -> Int {
        return moveModel.damage
    }
    
    func Duration() -> Double {
        return moveModel.duration
    }
    
    func EnergyGain() -> Int {
        return moveModel.energy
    }
}

struct PokemonChargeMoveModel {
    private(set) public var moveModel:PokemonMoveModel
    private(set) public var active:Bool
    
    init(ChargeMove cm:PokemonMoveModel, Active a:Bool) {
        moveModel = cm
        active = a
    }
    
    init(Name n:String, Type t:PokemonType, Damage d:Int, Duration dur:Double, EnergyCost e:Int, Active a:Bool) {
        self.init(ChargeMove: PokemonMoveModel(Name: n, Type: t, Damage: d, Duration: dur, Energy: e), Active: a)
    }
    
    func Name() -> String {
        return moveModel.name
    }
    
    func Type() -> PokemonType {
        return moveModel.type
    }
    
    func Damage() -> Int {
        return moveModel.damage
    }
    
    func Duration() -> Double {
        return moveModel.duration
    }
    
    func EnergyCost() -> Int {
        return moveModel.energy
    }
}
