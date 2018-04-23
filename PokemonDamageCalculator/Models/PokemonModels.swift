//
//  PokemonModels.swift
//  PokemonDamageCalculator
//
//  Created by Taylor Plimpton on 3/28/18.
//  Copyright © 2018 SmallPlanetDigital. All rights reserved.
//

import Foundation

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
    
    // ATTACKING
    // overall
    private var bestAttackingFastMove:PokemonFastMoveModel?
    private var bestAttackingChargeMove:PokemonChargeMoveModel?
    private var bestAttackingFastMoveSTAB:PokemonFastMoveModel?
    private var bestAttackingChargeMoveSTAB:PokemonChargeMoveModel?
    // active
    private var bestActiveAttackingFastMove:PokemonFastMoveModel?
    private var bestActiveAttackingChargeMove:PokemonChargeMoveModel?
    private var bestActiveAttackingFastMoveSTAB:PokemonFastMoveModel?
    private var bestActiveAttackingChargeMoveSTAB:PokemonChargeMoveModel?
    
    // DEFENDING
    // overall
    private var bestDefendingFastMove:PokemonFastMoveModel?
    private var bestDefendingChargeMove:PokemonChargeMoveModel?
    private var bestDefendingFastMoveSTAB:PokemonFastMoveModel?
    private var bestDefendingChargeMoveSTAB:PokemonChargeMoveModel?
    // active
    private var bestActiveDefendingFastMove:PokemonFastMoveModel?
    private var bestActiveDefendingChargeMove:PokemonChargeMoveModel?
    private var bestActiveDefendingFastMoveSTAB:PokemonFastMoveModel?
    private var bestActiveDefendingChargeMoveSTAB:PokemonChargeMoveModel?
    
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
    
    func BestAttackingFastMove(Active isActive:Bool = false,STAB isSTAB:Bool = false) -> PokemonFastMoveModel? {
        if (isActive) {
            if (isSTAB) {
                return bestActiveAttackingFastMoveSTAB
            }
            
            return bestActiveAttackingFastMove
        }
        
        if (isSTAB) {
            return bestAttackingFastMoveSTAB
        }
        
        return bestAttackingFastMove
    }
    
    func BestAttackingChargeMove(Active isActive:Bool = false,STAB isSTAB:Bool = false) -> PokemonChargeMoveModel? {
        if (isActive) {
            if (isSTAB) {
                return bestActiveAttackingChargeMoveSTAB
            }
            
            return bestActiveAttackingChargeMove
        }
        
        if (isSTAB) {
            return bestAttackingChargeMoveSTAB
        }
        
        return bestAttackingChargeMove
    }
    
    func BestDefendingFastMove(Active isActive:Bool = false,STAB isSTAB:Bool = false) -> PokemonFastMoveModel? {
        if (isActive) {
            if (isSTAB) {
                return bestActiveDefendingFastMoveSTAB
            }
            
            return bestActiveDefendingFastMove
        }
        
        if (isSTAB) {
            return bestDefendingFastMoveSTAB
        }
        
        return bestDefendingFastMove
    }
    
    func BestDefendingChargeMove(Active isActive:Bool = false,STAB isSTAB:Bool = false) -> PokemonChargeMoveModel? {
        if (isActive) {
            if (isSTAB) {
                return bestActiveDefendingChargeMoveSTAB
            }
            
            return bestActiveDefendingChargeMove
        }
        
        if (isSTAB) {
            return bestDefendingChargeMoveSTAB
        }
        
        return bestDefendingChargeMove
    }
    
    func eDPSAttacking(Active isActive:Bool = false, STAB isSTAB:Bool = false) -> Double {
        var returnVal = 0.0
        
        if (isActive) {
            if (isSTAB) {
                if (bestActiveAttackingChargeMoveSTAB != nil && bestActiveAttackingFastMoveSTAB != nil) {
                    returnVal = bestActiveAttackingChargeMoveSTAB!.eDPS(FastMove: bestActiveAttackingFastMoveSTAB!) + bestActiveAttackingFastMoveSTAB!.DPS()
                }
            } else {
                if (bestActiveAttackingChargeMove != nil && bestActiveAttackingFastMove != nil) {
                    returnVal = bestActiveAttackingChargeMove!.eDPS(FastMove: bestActiveAttackingFastMove!) + bestActiveAttackingFastMove!.DPS()
                }
            }
        } else {
            if (isSTAB) {
                if (bestAttackingChargeMoveSTAB != nil && bestAttackingFastMoveSTAB != nil) {
                    returnVal = bestAttackingChargeMoveSTAB!.eDPS(FastMove: bestAttackingFastMoveSTAB!) + bestAttackingFastMoveSTAB!.DPS()
                }
            } else {
                if (bestAttackingChargeMove != nil && bestAttackingFastMove != nil) {
                    returnVal = bestAttackingChargeMove!.eDPS(FastMove: bestAttackingFastMove!) + bestAttackingFastMove!.DPS()
                }
            }
        }
        
        return returnVal
    }
    
    func eDPSDefending(Active isActive:Bool = false, STAB isSTAB:Bool = false) -> Double {
        // TODO
        
        return 0.0
    }
    
    func FindMoves() {
        for currFastMoveInfo in fastMovesInfo {
            if let move = AppServices.FastMoves[currFastMoveInfo.name] {
                let moveModel = PokemonFastMoveModel(FastMove: move, Active: currFastMoveInfo.active, IsSTAB: moveIsSTAB(move))
                fastMoves.append(moveModel)
            }
        }
        
        for currChargeMoveInfo in chargeMovesInfo {
            if let move = AppServices.ChargeMoves[currChargeMoveInfo.name] {
                let moveModel = PokemonChargeMoveModel(ChargeMove: move, Active: currChargeMoveInfo.active, IsSTAB: moveIsSTAB(move))
                chargeMoves.append(moveModel)
            }
        }
        
        CalculateDamage()
    }
    
    private let CpM_Lvl40 = 0.79030001
    func GetDamageOutputForCurrentSort(_ opponentDefense:Int = 100) -> Double {
        var returnVal = 0.0
        
        if (bestAttackingChargeMove != nil && bestAttackingFastMove != nil) {
            let matchup = (Double(attack+15)*CpM_Lvl40)/(Double(opponentDefense+15))*CpM_Lvl40
            
            let fastMovesToGet100Energy = 100/Double(bestAttackingFastMove!.EnergyGain())
            let fastMoveDamageToGet100Energy = bestAttackingFastMove!.Damage(true) * fastMovesToGet100Energy
            let fastMoveDamageOutput = floor(0.5 * matchup * fastMoveDamageToGet100Energy) + 1
            
            let chargeMovesPer100Energy = floor(100/Double(bestAttackingChargeMove!.EnergyCost()))
            let boostedDamageFor100Energy = bestAttackingChargeMove!.Damage(true) * chargeMovesPer100Energy
            let chargeMoveDamageOutput = floor(0.5 * matchup * boostedDamageFor100Energy) + 1
            
            returnVal = fastMoveDamageOutput + chargeMoveDamageOutput
        }
        
        return returnVal
    }
    
    func CalculateDamage() {
        // TODO: defending calculations
        // TODO: should we allow for DPS in addition to eDPS calculations?
        
        var bestEDPS_Attacking = 0.0
        var bestEDPS_AttackingSTAB = 0.0
        var bestActiveEDPS_Attacking = 0.0
        var bestActiveEDPS_AttackingSTAB = 0.0
        
        for currFastMove in fastMoves {
            let currFastMoveDPS = currFastMove.DPS()
            
            for currChargeMove in chargeMoves {
                let currEDPS = currChargeMove.eDPS(FastMove: currFastMove) // For regular dps use: currChargeMove.DPS()
                let total = currEDPS + currFastMoveDPS
                
                if (total > bestEDPS_Attacking) {
                    bestAttackingFastMove = currFastMove
                    bestAttackingChargeMove = currChargeMove
                    
                    bestEDPS_Attacking = total
                }
                
                if (currFastMove.active && currChargeMove.active && total > bestActiveEDPS_Attacking) {
                    bestActiveAttackingFastMove = currFastMove
                    bestActiveAttackingChargeMove = currChargeMove
                    
                    bestActiveEDPS_Attacking = total
                }
                
                if (currFastMove.isSTAB && currChargeMove.isSTAB) {
                    if (total > bestEDPS_AttackingSTAB) {
                        bestAttackingFastMoveSTAB = currFastMove
                        bestAttackingChargeMoveSTAB = currChargeMove
                        
                        bestEDPS_AttackingSTAB = total
                    }
                    
                    if (currFastMove.active && currChargeMove.active && total > bestActiveEDPS_AttackingSTAB) {
                        bestActiveAttackingFastMoveSTAB = currFastMove
                        bestActiveAttackingChargeMoveSTAB = currChargeMove
                        
                        bestActiveEDPS_AttackingSTAB = total
                    }
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
    
    // dps = Damage Per Second
    private var dps = 0.0
    
    init(Name n:String, Type t:PokemonType, Damage d:Int, Duration dur:Double, Energy e:Int) {
        name = n
        type = t
        damage = d
        duration = dur
        energy = e
        
        if (duration > 0) {
            dps = Double(damage)/duration
        }
    }
    
    func Damage(_ includeModifiers:Bool = false) -> Double {
        if (includeModifiers) {
            return AdjustForBoosts(Double(damage))
        }
        
        return Double(damage)
    }
    
    func DPS(_ includeModifiers:Bool = false) -> Double {
        if (includeModifiers) {
            return AdjustForBoosts(dps)
        }
        
        return dps
    }
    
    func AdjustForBoosts(_ value:Double) -> Double {
        var newValue = value
        
        // apply any counter in/effectiveness
        for currCounterType in AppServices.PokemonCounterType {
            newValue *= type.ModifierAgainstType(Type: currCounterType)
        }
        
        // apply any weather boost
        for currWeatherBoostType in AppServices.ActiveWeather.BoostedTypes() {
            if (currWeatherBoostType == type) {
                newValue *= 1.2
                break
            }
        }
        
        return newValue
    }
}

struct PokemonFastMoveModel {
    private(set) public var moveModel:PokemonMoveModel
    private(set) public var active:Bool
    private(set) public var isSTAB:Bool
    // eps = Energy Per Second
    private(set) public var EPS = 0.0
    
    init(FastMove fm:PokemonMoveModel, Active a:Bool, IsSTAB stab:Bool) {
        moveModel = fm
        active = a
        isSTAB = stab
        
        if (moveModel.duration > 0) {
            EPS = Double(moveModel.energy)/moveModel.duration
        }
    }
    
    init(Name n:String, Type t:PokemonType, Damage d:Int, Duration dur:Double, EnergyGain e:Int, Active a:Bool, IsSTAB stab:Bool) {
        self.init(FastMove: PokemonMoveModel(Name: n, Type: t, Damage: d, Duration: dur, Energy: e), Active: a, IsSTAB: stab)
    }
    
    func Name() -> String {
        return moveModel.name
    }
    
    func Type() -> PokemonType {
        return moveModel.type
    }
    
    func Duration() -> Double {
        return moveModel.duration
    }
    
    func EnergyGain() -> Int {
        return moveModel.energy
    }
    
    func Damage(_ includeModifiers:Bool = true) -> Double {
        let adjustedDamage = moveModel.Damage(includeModifiers)
        return (isSTAB ? adjustedDamage*1.2 : adjustedDamage)
    }
    
    func DPS(_ includeModifiers:Bool = true) -> Double {
        let adjustedDPS = moveModel.DPS(includeModifiers)
        return (isSTAB ? adjustedDPS*1.2 : adjustedDPS)
    }
}

struct PokemonChargeMoveModel {
    private(set) public var moveModel:PokemonMoveModel
    private(set) public var active:Bool
    private(set) public var isSTAB:Bool
    
    init(ChargeMove cm:PokemonMoveModel, Active a:Bool, IsSTAB stab:Bool) {
        moveModel = cm
        active = a
        isSTAB = stab
    }
    
    init(Name n:String, Type t:PokemonType, Damage d:Int, Duration dur:Double, EnergyCost e:Int, Active a:Bool, IsSTAB stab:Bool) {
        self.init(ChargeMove: PokemonMoveModel(Name: n, Type: t, Damage: d, Duration: dur, Energy: e), Active: a, IsSTAB: stab)
    }
    
    func Name() -> String {
        return moveModel.name
    }
    
    func Type() -> PokemonType {
        return moveModel.type
    }
    
    func Damage(_ includeModifiers:Bool = true) -> Double {
        let adjustedDamage = moveModel.Damage(includeModifiers)
        return (isSTAB ? adjustedDamage*1.2 : adjustedDamage)
    }
    
    func DPS(_ includeModifiers:Bool = true) -> Double {
        let adjustedDPS = moveModel.DPS(includeModifiers)
        return (isSTAB ? adjustedDPS*1.2 : adjustedDPS)
    }
    
    func Duration() -> Double {
        return moveModel.duration
    }
    
    func EnergyCost() -> Int {
        return moveModel.energy
    }
    
    // eDps = Energy dependant Damage Per Second
    func eDPS(FastMove fMove:PokemonFastMoveModel) -> Double {
        //(chargeDamage * floor(100/chargeEnergyCost)) / ((100/fastEPS) + (floor(100/chargeEnergyCost) * chargeDuration))
        
        let chargeMovesPer100Energy = floor(100/Double(EnergyCost()))
        let totalDamagePer100Energy = Damage() * chargeMovesPer100Energy
        let secondsToGain100Energy = 100/fMove.EPS
        let totalChargeMoveDurationPer100Energy = Double(chargeMovesPer100Energy)*Duration()
        let totalDurationToEarnAndUse100Energy = secondsToGain100Energy + totalChargeMoveDurationPer100Energy
        /*var eDps =*/ return Double(totalDamagePer100Energy) / totalDurationToEarnAndUse100Energy
        
//        // apply any counter in/effectiveness
//        for currCounterType in AppServices.PokemonCounterType {
//            eDps *= Type().ModifierAgainstType(Type: currCounterType)
//        }
//
//        // apply any weather boost
//        for currWeatherBoostType in AppServices.ActiveWeather.BoostedTypes() {
//            if (currWeatherBoostType == Type()) {
//                eDps *= 1.2
//                break
//            }
//        }
//
//        return (isSTAB ? eDps*1.2 : eDps)
    }
}
