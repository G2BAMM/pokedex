//
//  PokeCell.swift
//  pokedex
//
//  Created by Brian McAulay on 08/06/2017.
//  Copyright © 2017 Brian McAulay. All rights reserved.
//

import UIKit

class PokeCell: UICollectionViewCell {
    
    @IBOutlet weak var imgThumb: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    
    var pokemon: Pokemon!
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        //Set a curve on our collectionview cells
        layer.cornerRadius = 5.0
    }
    
    func configureCell(pokemon: Pokemon){
        //Set up our pokemon object
        self.pokemon = pokemon
        //Update the pokemon name
        lblName.text = self.pokemon.name.capitalized
        //Set the pokemon image
        self.imgThumb.image = UIImage(named: "\(self.pokemon.pokedexId)")
        
    }
}
