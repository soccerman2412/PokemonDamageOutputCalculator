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
            if let attackingFM = detail.BestAttackingFastMove() {
                if let fastAttacking_Label = fastAttacking {
                    fastAttacking_Label.text = attackingFM.Name()
                }
                if let fastAttackingDPS_Label = fastAttackingDPS {
                    fastAttackingDPS_Label.text = String(format: "%.2f", attackingFM.dps)
                }
            }
            
            if let attackingCM = detail.BestAttackingChargeMove() {
                if let chargeAttacking_Label = chargeAttacking {
                    chargeAttacking_Label.text = attackingCM.Name()
                }
                if let attackingFM = detail.BestAttackingFastMove() {
                    if let chargeAttackingEDPS_Label = chargeAttackingEDPS {
                        chargeAttackingEDPS_Label.text = String(format: "%.2f", attackingCM.eDPS(FastMove: attackingFM))
                    }
                }
            }
            
            if let attackingFM = detail.BestAttackingFastMove(Active: false, STAB: true) {
                if let fastAttacking_Label = fastAttacking_STAB {
                    fastAttacking_Label.text = attackingFM.Name()
                }
                if let fastAttackingDPS_Label = fastAttackingDPS_STAB {
                    fastAttackingDPS_Label.text = String(format: "%.2f", attackingFM.dps)
                }
            }
            
            if let attackingCM = detail.BestAttackingChargeMove(Active: false, STAB: true) {
                if let chargeAttacking_Label = chargeAttacking_STAB {
                    chargeAttacking_Label.text = attackingCM.Name()
                }
                if let attackingFM = detail.BestAttackingFastMove(Active: false, STAB: true) {
                    if let chargeAttackingEDPS_Label = chargeAttackingEDPS_STAB {
                        chargeAttackingEDPS_Label.text = String(format: "%.2f", attackingCM.eDPS(FastMove: attackingFM))
                    }
                }
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

