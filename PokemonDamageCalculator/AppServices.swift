//
//  AppServices.swift
//  PokemonDamageCalculator
//
//  Created by Taylor Plimpton on 3/28/18.
//  Copyright © 2018 SmallPlanetDigital. All rights reserved.
//

import Foundation
import Firebase



// MARK: - UIImageView Extension
extension UIImageView {
    func GetImageForURL(ImageURL imgURL:String!) {
        // set the default image while we wait
        image = #imageLiteral(resourceName: "placeholderImage")
        
        _ = AppServices.GetImageForURL(ImageURL: imgURL, Completion: { [weak self] (img)  in
            self?.image = img
        })
    }
}



class AppServices {
    // Firebase
    private static var db = Firestore.firestore()
    private static var storage = Storage.storage()
    
    // Simple Image Cached
    private static var imageCache:Dictionary<String,Data> = Dictionary<String,Data>()
    
    // Pokemon Data
    static var Pokemon = Array<PokemonModel>()
    static var FastMoves = Dictionary<String,PokemonMoveModel>()
    static var ChargeMoves = Dictionary<String,PokemonMoveModel>()
    
    static func GetPokemonData (Completion completion:@escaping(Array<PokemonModel>) -> Void) {
        // TODO: add logic to check if there's any reason to update this info
        // and if not then restore (which also means storing this info)
        
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        db.collection("pokemon").getDocuments { (querySnapshot, error) in
            if (error == nil) {
                Pokemon = mapPokemonData(Documents: (querySnapshot?.documents)!)
            } else {
                print("Pokemon retreival error: \(error?.localizedDescription ?? "N/A")")
            }
            
            completion(Pokemon)
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        db.collection("fastMoves").getDocuments { (querySnapshot, error) in
            if (error == nil) {
                FastMoves = mapMovesData(Documents: (querySnapshot?.documents)!)
            } else {
                print("Pokemon fast move retreival error: \(error?.localizedDescription ?? "N/A")")
            }
            
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        db.collection("chargeMoves").getDocuments { (querySnapshot, error) in
            if (error == nil) {
                ChargeMoves = mapMovesData(Documents: (querySnapshot?.documents)!)
            } else {
                print("Pokemon charge move retreival error: \(error?.localizedDescription ?? "N/A")")
            }
            
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
            // update all pokemon with the moves
            for currPokemon in Pokemon {
                currPokemon.FindMoves()
            }
            
            // tell the tableview to update
        }
    }
    
    private static func mapPokemonData(Documents docs:Array<DocumentSnapshot>) -> Array<PokemonModel> {
        var pokemon = Array<PokemonModel>()
        
        if (docs.count > 0) {
            let pokemonDoc = docs[0]
            if let pokemonData:Dictionary<String,Any> = pokemonDoc.data() {
                for key in pokemonData.keys {
                    if let currPokemonData = pokemonData[key] as? Dictionary<String,Any> {
                        
                        var fastMoves = Array<PokemonMoveSimpleModel>()
                        if let fastMovesData = currPokemonData["fastMoves"] as? Array<Dictionary<String,Any>> {
                            for moveData in fastMovesData {
                                if let moveName = moveData["move"] as? String, let active = moveData["active"] as? Bool {
                                    let move = PokemonMoveSimpleModel(Name: moveName, Active: active)
                                    fastMoves.append(move)
                                }
                            }
                        }
                        
                        var chargeMoves = Array<PokemonMoveSimpleModel>()
                        if let chargeMovesData = currPokemonData["chargeMoves"] as? Array<Dictionary<String,Any>> {
                            for moveData in chargeMovesData {
                                if let moveName = moveData["move"] as? String, let active = moveData["active"] as? Bool {
                                    let move = PokemonMoveSimpleModel(Name: moveName, Active: active)
                                    chargeMoves.append(move)
                                }
                            }
                        }
                        
                        if let name = currPokemonData["name"] as? String, let types = currPokemonData["types"] as? Array<String>,
                            let pokemonNumber = currPokemonData["pokemonNumber"] as? Int, let attack = currPokemonData["attack"] as? Int,
                            let defense = currPokemonData["defense"] as? Int, let stamina = currPokemonData["stamina"] as? Int,
                            let generation = currPokemonData["generation"] as? Int, let legendary = currPokemonData["legendary"] as? Bool {
                            let currPokemon = PokemonModel(Name: name, Types: types, PokemonNumber: pokemonNumber, Atack: attack, Defense: defense, Stamina: stamina,
                                                           FastMoves: fastMoves, ChargeMoves: chargeMoves, Generation: generation, Legendary: legendary)
                            pokemon.append(currPokemon)
                        }
                    }
                }
            }
        }
        
        return pokemon
    }
    
    private static func mapMovesData(Documents docs:Array<DocumentSnapshot>) -> Dictionary<String,PokemonMoveModel> {
        var mappedMoves = Dictionary<String,PokemonMoveModel>()
        
        for currDoc in docs {
            if let moveData:Dictionary<String,Any> = currDoc.data() {
                let move = mapMove(moveData)
                mappedMoves[currDoc.documentID] = move
            }
        }
        
        return mappedMoves
    }
    
    private static func mapMove(_ moveData:Dictionary<String,Any>) -> PokemonMoveModel? {
        var move:PokemonMoveModel? = nil
        
        if let name = moveData["name"] as? String, let typeStr = moveData["type"] as? String,
            let damage = moveData["damage"] as? Int, let duration = moveData["duration"] as? Double {
            if let type = PokemonType(rawValue: typeStr) {
                if let energyGain = moveData["energyGain"] as? Int {
                    move = PokemonMoveModel(Name: name, Type: type, Damage: damage, Duration: duration, Energy: energyGain)
                } else if let energyCost = moveData["energyCost"] as? Int {
                    move = PokemonMoveModel(Name: name, Type: type, Damage: damage, Duration: duration, Energy: energyCost)
                }
            }
        }
        
        return move
    }
    
    
    
    // MARK: - Image Related Methods
    
    static func GetImageForURL(ImageURL imgURL:String!, Completion completion:@escaping(UIImage?) -> Void) {
        // check if the image data already exists in the cache
        if let imgCacheData = imageCache[imgURL] {
            let img = UIImage(data: imgCacheData)
            
            completion(img)
        } else {
            // Create a reference with an initial file path and name
            let imagePathRefef = storage.reference(withPath: imgURL)
            
            // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
            imagePathRefef.getData(maxSize: 1 * 1024 * 1024) { data, error in
                var img:UIImage? = nil
                
                if let error = error {
                    // error occurred!
                    // TODO: handle
                    print("GetImageForURL error: \(error)")
                } else {
                    // image data was returned
                    img = UIImage(data: data!)
                    
                    // add the data to our cache
                    imageCache[imgURL] = data!
                }
                
                completion(img)
            }
        }
    }
    
    static func EmptyImageCache() {
        // TODO: add logic to handle the option only clearing image data that hasn't been used in a while
        
        imageCache.removeAll()
    }
}
