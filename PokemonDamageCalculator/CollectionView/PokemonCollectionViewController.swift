//
//  PokemonCollectionViewController.swift
//  PokemonDamageCalculator
//
//  Created by Taylor Plimpton on 4/26/18.
//  Copyright © 2018 SmallPlanetDigital. All rights reserved.
//

import Foundation
import UIKit

class PokemonCollectionViewController: UICollectionViewController, UIPopoverPresentationControllerDelegate {
    
    var objects = [PokemonCellViewModel]()
    
    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // button for sorting
        let sortButton = UIBarButtonItem(image: #imageLiteral(resourceName: "sort"), style: .plain, target: self, action: #selector(showSortOptions(Sender:)))
        navigationItem.leftBarButtonItem = sortButton
        
        // button for filtering
        let filterButton = UIBarButtonItem(image: #imageLiteral(resourceName: "funnel"), style: .plain, target: self, action: #selector(showFilterOptions(Sender:)))
        navigationItem.rightBarButtonItem = filterButton
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return objects.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokemonCollectionCell", for: indexPath) as! PokemonCollectionViewCell
        
        let object = objects[indexPath.row]
        cell.UpdateContent(PokemonModel: object)
        
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
    
    
    // MARK: -
    
    @objc private func showSortOptions(Sender sender:UIBarButtonItem) {
        // show sort modal
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let modalController = storyBoard.instantiateViewController(withIdentifier: "SortModal")
        modalController.modalPresentationStyle = .fullScreen
        
        present(modalController, animated: true) {
            // closure for when the modal is visible
        }
    }
    
    @objc private func showFilterOptions(Sender sender:UIBarButtonItem) {
        // show filter popover
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let popoverController = storyBoard.instantiateViewController(withIdentifier: "FilterPopover")
        popoverController.preferredContentSize = CGSize(width: 250, height: 150)
        popoverController.modalPresentationStyle = .popover
        
        if let popoverPresentationController = popoverController.popoverPresentationController {
            popoverPresentationController.delegate = self
            popoverPresentationController.barButtonItem = sender
        }
        
        present(popoverController, animated: true) {
            // closure for when the popover is visible
        }
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    func InsertNewObject(_ model:PokemonCellViewModel) {
        objects.insert(model, at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        collectionView?.insertItems(at: [indexPath])
    }
    
    func SortObjects(DmgOutput dmg:Bool = false, Def def:Bool = false) {
        objects.sort { (modelA, modelB) -> Bool in
            if (dmg) {
                return modelA.pokemonModel.GetDamageOutputForCurrentSort() > modelB.pokemonModel.GetDamageOutputForCurrentSort()
            } else if (def) {
                return modelA.pokemonModel.CalculateDefending() > modelB.pokemonModel.CalculateDefending()
            }
            
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
