//
//  DetailViewController.swift
//  PokemonDamageCalculator
//
//  Created by Taylor Plimpton on 3/28/18.
//  Copyright © 2018 SmallPlanetDigital. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var detailNavItem: UINavigationItem!
    @IBOutlet weak var pokemonImageView: UIImageView!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var fast: UILabel!
    @IBOutlet weak var fastDPS: UILabel!
    @IBOutlet weak var charge: UILabel!
    @IBOutlet weak var chargeEDPS: UILabel!
    
    @IBOutlet weak var activeFast: UILabel!
    @IBOutlet weak var activeFastDPS: UILabel!
    @IBOutlet weak var activeCharge: UILabel!
    @IBOutlet weak var activeChargeEDPS: UILabel!
    
    @IBOutlet weak var fast_STAB: UILabel!
    @IBOutlet weak var fastDPS_STAB: UILabel!
    @IBOutlet weak var charge_STAB: UILabel!
    @IBOutlet weak var chargeEDPS_STAB: UILabel!
    
    @IBOutlet weak var activeFast_STAB: UILabel!
    @IBOutlet weak var activeFastDPS_STAB: UILabel!
    @IBOutlet weak var activeCharge_STAB: UILabel!
    @IBOutlet weak var activeChargeEDPS_STAB: UILabel!
    
    

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

    func configureView() {
        // Update the user interface for the detail item.
        if let detail = detailItem {
            detailNavItem.title = detail.Name()
            
            if let imageView = pokemonImageView, let imageUrl = detail.pokemonModel.imageUrl {
                imageView.contentMode = .scaleAspectFit
                imageView.GetImageForURL(ImageURL: imageUrl)
            }
            
            // best overall
            if let attackingFM = detail.BestAttackingFastMove() {
                if let label = fast {
                    label.text = attackingFM.Name()
                }
                if let label = fastDPS {
                    label.text = String(format: "%.2f", attackingFM.dps)
                }
            }
            if let attackingCM = detail.BestAttackingChargeMove() {
                if let label = charge {
                    label.text = attackingCM.Name()
                }
                if let attackingFM = detail.BestAttackingFastMove() {
                    if let label = chargeEDPS {
                        label.text = String(format: "%.2f", attackingCM.eDPS(FastMove: attackingFM))
                    }
                }
            }
            
            // best overall active
            if let attackingFM = detail.BestAttackingFastMove(Active: true) {
                if let label = activeFast {
                    label.text = attackingFM.Name()
                }
                if let label = activeFastDPS {
                    label.text = String(format: "%.2f", attackingFM.dps)
                }
            }
            if let attackingCM = detail.BestAttackingChargeMove(Active: true) {
                if let label = activeCharge {
                    label.text = attackingCM.Name()
                }
                if let attackingFM = detail.BestAttackingFastMove(Active: true) {
                    if let label = activeChargeEDPS {
                        label.text = String(format: "%.2f", attackingCM.eDPS(FastMove: attackingFM))
                    }
                }
            }
            
            // best stab
            if let attackingFM = detail.BestAttackingFastMove(Active: false, STAB: true) {
                if let label = fast_STAB {
                    label.text = attackingFM.Name()
                }
                if let label = fastDPS_STAB {
                    label.text = String(format: "%.2f", attackingFM.dps)
                }
            }
            if let attackingCM = detail.BestAttackingChargeMove(Active: false, STAB: true) {
                if let label = charge_STAB {
                    label.text = attackingCM.Name()
                }
                if let attackingFM = detail.BestAttackingFastMove(Active: false, STAB: true) {
                    if let label = chargeEDPS_STAB {
                        label.text = String(format: "%.2f", attackingCM.eDPS(FastMove: attackingFM))
                    }
                }
            }
            
            // best stab active
            if let attackingFM = detail.BestAttackingFastMove(Active: true, STAB: true) {
                if let label = activeFast_STAB {
                    label.text = attackingFM.Name()
                }
                if let label = activeFastDPS_STAB {
                    label.text = String(format: "%.2f", attackingFM.dps)
                }
            }
            if let attackingCM = detail.BestAttackingChargeMove(Active: true, STAB: true) {
                if let label = activeCharge_STAB {
                    label.text = attackingCM.Name()
                }
                if let attackingFM = detail.BestAttackingFastMove(Active: true, STAB: true) {
                    if let label = activeChargeEDPS_STAB {
                        label.text = String(format: "%.2f", attackingCM.eDPS(FastMove: attackingFM))
                    }
                }
            }
        }
    }
    
    @IBAction func SegmentedControlValueChanged(_ sender: UISegmentedControl, forEvent event: UIEvent) {
        // TODO: change info to reflect attacking or defending
    }
    
}

