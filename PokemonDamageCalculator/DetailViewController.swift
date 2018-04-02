//
//  DetailViewController.swift
//  PokemonDamageCalculator
//
//  Created by Taylor Plimpton on 3/28/18.
//  Copyright © 2018 SmallPlanetDigital. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var fastAttacking: UILabel!
    @IBOutlet weak var fastAttackingDPS: UILabel!
    @IBOutlet weak var chargeAttacking: UILabel!
    @IBOutlet weak var chargeAttackingEDPS: UILabel!
    
    @IBOutlet weak var fastAttacking_STAB: UILabel!
    @IBOutlet weak var fastAttackingDPS_STAB: UILabel!
    @IBOutlet weak var chargeAttacking_STAB: UILabel!
    @IBOutlet weak var chargeAttackingEDPS_STAB: UILabel!
    

    func configureView() {
        // Update the user interface for the detail item.
        if let detail = detailItem {
            if let fastAttacking_Label = fastAttacking {
                fastAttacking_Label.text = detail.BestAttackingFastMove()
            }
//            if let fastAttackingDPS_Label = fastAttackingDPS {
//                fastAttackingDPS_Label.text = detail.
//            }
            
            if let chargeAttacking_Label = chargeAttacking {
                chargeAttacking_Label.text = detail.BestAttackingChargeMove()
            }
            if let chargeAttackingEDPS_Label = chargeAttackingEDPS {
                chargeAttackingEDPS_Label.text = String(format: "%.2f", detail.eDPSAttacking())
            }
            
            if let fastAttacking_STAB_Label = fastAttacking_STAB {
                fastAttacking_STAB_Label.text = detail.BestAttackingFastMove(true)
            }
            
            if let chargeAttacking_STAB_Label = chargeAttacking_STAB {
                chargeAttacking_STAB_Label.text = detail.BestAttackingChargeMove(true)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var detailItem: DetailViewModel? {
        didSet {
            // Update the view.
            configureView()
        }
    }


}

