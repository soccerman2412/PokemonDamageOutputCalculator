//
//  PokemonCollectionViewController.swift
//  PokemonDamageCalculator
//
//  Created by Taylor Plimpton on 4/26/18.
//  Copyright © 2018 SmallPlanetDigital. All rights reserved.
//

import Foundation
import UIKit

class PokemonCollectionViewController: UICollectionViewController {
    
    var objects = [CollectionCellViewModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return objects.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokemonCollectionCell", for: indexPath) as! PokemonCollectionViewCell
        
        let object = objects[indexPath.row] //TODO: row?
        
        cell.PokemonImageView?.GetImageForURL(ImageURL: object.ImageUrl())
        
        cell.PokemonNameLabel?.text = object.Name()
        cell.PokemonNameLabel?.textColor = .black
        if (object.pokemonModel.legendary) {
            cell.PokemonNameLabel?.textColor = UIColor(named: "legendaryColor")
        }
        
        cell.PokemonNumberLabel?.text = "#" + object.PokemonNumber()
        cell.PokemonNumberLabel?.textColor = .black
        
//        switch(AppServices.SortingType) {
//        case .BestOverallActiveAttacking:
//            cell.detailTextLabel?.text = String(format: "%.2f", object.pokemonModel.eDPSAttacking(Active: true))
//        case .BestAttackingSTAB:
//            cell.detailTextLabel?.text = String(format: "%.2f", object.pokemonModel.eDPSAttacking(Active: false, STAB: true))
//        case .BestActiveAttackingSTAB:
//            cell.detailTextLabel?.text = String(format: "%.2f", object.pokemonModel.eDPSAttacking(Active: true, STAB: true))
//        case .BestDamageOutputAttacking:
//            cell.detailTextLabel?.text = String(format: "%.2f", object.pokemonModel.GetDamageOutputForCurrentSort())
//        default:
//            cell.detailTextLabel?.text = String(format: "%.2f", object.pokemonModel.eDPSAttacking())
//        }
//
//        cell.detailTextLabel?.textColor = .black
//        if (object.pokemonModel.legendary) {
//            cell.detailTextLabel?.textColor = UIColor(named: "legendaryColor")
//        }
        
        return cell
    }
    
    
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if (collectionView?.indexPathsForSelectedItems != nil) {
                let indexPath = collectionView!.indexPathsForSelectedItems![0]
                let object = objects[indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = DetailViewModel(PokemonModel: object.pokemonModel)
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
    
    
    
    func InsertNewObject(_ model:CollectionCellViewModel) {
        objects.insert(model, at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        collectionView?.insertItems(at: [indexPath])
    }
    
    func SortObjects() {
        objects.sort { (modelA, modelB) -> Bool in
            // TODO: sort based on ALL sorttype
            var active = false
            var stab = false
            switch(AppServices.SortingType) {
            case .BestOverallActiveAttacking:
                active = true
            case .BestAttackingSTAB:
                stab = true
            case .BestActiveAttackingSTAB:
                active = true
                stab = true
            case .BestDamageOutputAttacking:
                return modelA.pokemonModel.GetDamageOutputForCurrentSort() > modelB.pokemonModel.GetDamageOutputForCurrentSort()
            default:
                break
            }
            
            return modelA.pokemonModel.eDPSAttacking(Active: active, STAB: stab) > modelB.pokemonModel.eDPSAttacking(Active: active, STAB: stab)
        }
        
        var indexPathsToReload = [IndexPath]()
        var itemsToReload = 30
        if (collectionView != nil) {
            itemsToReload = collectionView!.visibleCells.count
        }
        for i in 0..<itemsToReload {
            indexPathsToReload.append(IndexPath(row: i, section: 0))
        }
        collectionView?.reloadItems(at: indexPathsToReload)
    }
}
