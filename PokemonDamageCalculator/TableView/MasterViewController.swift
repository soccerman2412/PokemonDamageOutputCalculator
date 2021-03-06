//
//  MasterViewController.swift
//  PokemonDamageCalculator
//
//  Created by Taylor Plimpton on 3/28/18.
//  Copyright © 2018 SmallPlanetDigital. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController, UIPopoverPresentationControllerDelegate {

    @IBOutlet weak var pokemonTableView: UITableView!
    
    var detailViewController: DetailViewController? = nil
    var objects = [PokemonCellViewModel]()


    override func viewDidLoad() {
        super.viewDidLoad()

        // button for sorting
        let sortButton = UIBarButtonItem(image: #imageLiteral(resourceName: "sort"), style: .plain, target: self, action: #selector(showSortOptions(Sender:)))
        navigationItem.leftBarButtonItem = sortButton
        
        // button for filtering
        let filterButton = UIBarButtonItem(image: #imageLiteral(resourceName: "funnel"), style: .plain, target: self, action: #selector(showFilterOptions(Sender:)))
        navigationItem.rightBarButtonItem = filterButton
        
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func InsertNewObject(_ model:PokemonCellViewModel) {
        objects.insert(model, at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    func SortObjects() {
        objects.sort { (modelA, modelB) -> Bool in
            switch(AppServices.SortingType) {
            case .DamageOutput:
                return modelA.pokemonModel.GetDamageOutputForCurrentSort() > modelB.pokemonModel.GetDamageOutputForCurrentSort()
            case .DefendingTank:
                return modelA.pokemonModel.CalculateDefending() > modelB.pokemonModel.CalculateDefending()
            case .DefendingDuel:
                return modelA.pokemonModel.CalculateDefending(true) > modelB.pokemonModel.CalculateDefending(true)
            default:
                break
            }
            
            return modelA.pokemonModel.eDPSAttacking(Active: AppServices.MoveSet_IsActive, STAB: AppServices.MoveSet_STAB) > modelB.pokemonModel.eDPSAttacking(Active: AppServices.MoveSet_IsActive, STAB: AppServices.MoveSet_STAB)
        }
        
        // update the current top stat
        switch(AppServices.SortingType) {
        case .DamageOutput:
            AppServices.CurrentTopStat = objects[0].pokemonModel.GetDamageOutputForCurrentSort()
        case .DefendingTank:
            AppServices.CurrentTopStat = objects[0].pokemonModel.CalculateDefending()
        case .DefendingDuel:
            AppServices.CurrentTopStat = objects[0].pokemonModel.CalculateDefending(true)
        default:
            break
        }
        
        pokemonTableView.reloadData()
    }
    
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

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let object = objects[indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = DetailViewModel(PokemonModel: object.pokemonModel)
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let object = objects[indexPath.row]
        cell.textLabel?.text = object.Name()
        cell.textLabel?.textColor = .black
        if (object.pokemonModel.legendary) {
            cell.textLabel?.textColor = UIColor(named: "legendaryColor")
        }
        
        cell.detailTextLabel?.text = String(format: "%.2f", object.pokemonModel.eDPSAttacking(Active: AppServices.MoveSet_IsActive, STAB: AppServices.MoveSet_STAB))
        
        switch(AppServices.SortingType) {
        case .DamageOutput:
            cell.detailTextLabel?.text = String(format: "%.2f", object.pokemonModel.GetDamageOutputForCurrentSort())
        case .DefendingTank:
            cell.detailTextLabel?.text = String(format: "%.2f", object.pokemonModel.CalculateDefending())
        case .DefendingDuel:
            cell.detailTextLabel?.text = String(format: "%.2f", object.pokemonModel.CalculateDefending(true))
        default:
            break
        }
        
        cell.detailTextLabel?.textColor = .black
        if (object.pokemonModel.legendary) {
            cell.detailTextLabel?.textColor = UIColor(named: "legendaryColor")
        }
        
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            objects.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }


}

