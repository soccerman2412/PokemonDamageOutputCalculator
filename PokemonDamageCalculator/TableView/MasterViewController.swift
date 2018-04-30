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
    var objects = [CellViewModel]()


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

    func InsertNewObject(_ model:CellViewModel) {
        objects.insert(model, at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
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
        
        switch(AppServices.SortingType) {
        case .BestOverallActiveAttacking:
            cell.detailTextLabel?.text = String(format: "%.2f", object.pokemonModel.eDPSAttacking(Active: true))
        case .BestAttackingSTAB:
            cell.detailTextLabel?.text = String(format: "%.2f", object.pokemonModel.eDPSAttacking(Active: false, STAB: true))
        case .BestActiveAttackingSTAB:
            cell.detailTextLabel?.text = String(format: "%.2f", object.pokemonModel.eDPSAttacking(Active: true, STAB: true))
        case .BestDamageOutputAttacking:
            cell.detailTextLabel?.text = String(format: "%.2f", object.pokemonModel.GetDamageOutputForCurrentSort())
        default:
            cell.detailTextLabel?.text = String(format: "%.2f", object.pokemonModel.eDPSAttacking())
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

