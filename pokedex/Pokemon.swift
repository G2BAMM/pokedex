//
//  Pokemon.swift
//  pokedex
//
//  Created by Brian McAulay on 07/06/2017.
//  Copyright © 2017 Brian McAulay. All rights reserved.
//

import Foundation

struct Pokemon{
    private var _name: String!
    private var _pokedexId: Int!
    
    var name: String{
        return _name
    }
    
    var pokedexId: Int{
        return _pokedexId
    }
    
    init(name: String, pokedexId: Int){
        self._name = name
        self._pokedexId = pokedexId
    }
}
