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
                    returnVal = bestActiveAttackingChargeMoveSTAB!.eDPS(FastMove: bestActiveAttackingFastMoveSTAB!) + bestActiveAttackingFastMoveSTAB!.dps
                }
            } else {
                if (bestActiveAttackingChargeMove != nil && bestActiveAttackingFastMove != nil) {
                    returnVal = bestActiveAttackingChargeMove!.eDPS(FastMove: bestActiveAttackingFastMove!) + bestActiveAttackingFastMove!.dps
                }
            }
        } else {
            if (isSTAB) {
                if (bestAttackingChargeMoveSTAB != nil && bestAttackingFastMoveSTAB != nil) {
                    returnVal = bestAttackingChargeMoveSTAB!.eDPS(FastMove: bestAttackingFastMoveSTAB!) + bestAttackingFastMoveSTAB!.dps
                }
            } else {
                if (bestAttackingChargeMove != nil && bestAttackingFastMove != nil) {
                    returnVal = bestAttackingChargeMove!.eDPS(FastMove: bestAttackingFastMove!) + bestAttackingFastMove!.dps
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
        
        calculate()
    }
    
    private func calculate() {
        // TODO: defending calculations
        // TODO: calculations with weather
        // TODO: calculations with opponent type bonus
        
        var bestEDPS_Attacking = 0.0
        var bestEDPS_AttackingSTAB = 0.0
        var bestActiveEDPS_Attacking = 0.0
        var bestActiveEDPS_AttackingSTAB = 0.0
        
        for currFastMove in fastMoves {
            for currChargeMove in chargeMoves {
                let currEPDS = currChargeMove.eDPS(FastMove: currFastMove)
                let total = currEPDS + currFastMove.dps
                
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
    private(set) public var isSTAB:Bool
    
    // dps = Damage Per Second
    private(set) public var dps = 0.0
    // eps = Energy Per Second
    private(set) public var eps = 0.0
    
    init(FastMove fm:PokemonMoveModel, Active a:Bool, IsSTAB stab:Bool) {
        moveModel = fm
        active = a
        isSTAB = stab
        
        if (moveModel.duration > 0) {
            let adjustedDamage = (stab ? Double(moveModel.damage)*1.2 : Double(moveModel.damage))
            dps = adjustedDamage/moveModel.duration
            eps = Double(moveModel.energy)/moveModel.duration
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
    
    func Damage() -> Int {
        return moveModel.damage
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
        
        let chargeMovesPer100Energy = Int(floor(100/Double(EnergyCost())))
        let totalDamagePer100Energy = Damage() * chargeMovesPer100Energy
        let secondsToGain100Energy = 100/fMove.eps
        let totalChargeMoveDurationPer100Energy = Double(chargeMovesPer100Energy)*Duration()
        let totalDurationToEarnAndUse100Energy = secondsToGain100Energy + totalChargeMoveDurationPer100Energy
        let eDps = Double(totalDamagePer100Energy) / totalDurationToEarnAndUse100Energy
        
        return (isSTAB ? eDps*1.2 : eDps)
    }
}
