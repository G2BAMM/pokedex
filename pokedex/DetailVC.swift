//
//  DetailVC.swift
//  pokedex
//
//  Created by Brian McAulay on 13/06/2017.
//  Copyright © 2017 Brian McAulay. All rights reserved.
//

import UIKit

class DetailVC: UIViewController {
    var pokemon: Pokemon!
    
    @IBOutlet weak var lblPokeName: UILabel!
    @IBOutlet weak var btnBack: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        lblPokeName.text = pokemon.name.capitalized
    }

    @IBAction func btnBackClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
