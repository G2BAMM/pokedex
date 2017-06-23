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
    
    @IBOutlet weak var imgNextPokemon: UIImageView!
    @IBOutlet weak var imgCurrentPokemon: UIImageView!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var imgPokemon: UIImageView!
    @IBOutlet weak var lblNextEvolution: UILabel!
    @IBOutlet weak var lblBaseAttack: UILabel!
    @IBOutlet weak var lblWeight: UILabel!
    @IBOutlet weak var lblPokedexId: UILabel!
    @IBOutlet weak var lblHeight: UILabel!
    @IBOutlet weak var lblDefense: UILabel!
    @IBOutlet var lblType: UILabel!
    @IBOutlet weak var lblPokeName: UILabel!
    @IBOutlet weak var btnBack: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        pokemon.downloadPokemonDetail {
            //This will try to parse the JSON call
            self.updateUI()
        }
     }
    
    func updateUI(){
        lblPokeName.text = pokemon.name.capitalized
        let img = UIImage(named: "\(pokemon.pokedexId)")
        imgPokemon.image = img
        imgCurrentPokemon.image = img
        lblType.text = pokemon.type
        lblWeight.text = pokemon.weight
        lblHeight.text = pokemon.height
        lblBaseAttack.text = pokemon.attack
        lblDefense.text = pokemon.defense
        lblPokedexId.text  = "\(pokemon.pokedexId)"
        lblDescription.text = pokemon.description
        if pokemon.nextEvolutionId == "" {
            //No next evolution so hide the next image and set the evolution text to none
            lblNextEvolution.text = "No Evolutions"
            imgNextPokemon.isHidden = true
        }else{
            //This pokemon has an evolution step so show it now
            imgNextPokemon.image = UIImage(named: pokemon.nextEvolutionId)
            imgNextPokemon.isHidden = false
            lblNextEvolution.text = ("Next Evolution: \(pokemon.nextEvolutionName) LVL \(pokemon.nextEvolutionLevel)")
        }
        
    }

    @IBAction func btnBackClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
