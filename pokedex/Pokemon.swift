//
//  Pokemon.swift
//  pokedex
//
//  Created by Brian McAulay on 07/06/2017.
//  Copyright © 2017 Brian McAulay. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon{
    private var _name: String!
    private var _pokedexId: Int!
    private var _description: String!
    private var _type: String!
    private var _defense: String!
    private var _height: String!
    private var _weight: String!
    private var _attack: String!
    private var _nextEvolutionText: String!
    private var _nextEvolutionName: String!
    private var _nextEvolutionId: String!
    private var _nextEvolutionLevel: String!
    private var _pokemonURL: String!
    
    
    var name: String{
        if _name == nil{
            _name = ""
        }
        return _name
    }
    
    var pokedexId: Int{
        if _pokedexId == nil{
            _pokedexId = 0
        }
        return _pokedexId
    }
    
    var description: String{
        if _description == nil{
            _description = ""
        }
        return _description
    }
    
    var type: String{
        if _type == nil{
            _type = ""
        }
        return _type
    }
    
    var defense: String{
        if _defense == nil{
            _defense = ""
        }
        return _defense
    }
    
    var height: String{
        if _height == nil{
            _height = ""
        }
        return _height
    }
    
    var weight: String{
        if _weight == nil{
            _weight = ""
        }
        return _weight
    }
    
    var attack: String{
        if _attack == nil{
            _attack = ""
        }
        return _attack
    }
    
    var nextEvolutionText: String{
        if _nextEvolutionText == nil{
            _nextEvolutionText = ""
        }
        return _nextEvolutionText
    }
    
    var nextEvolutionName: String{
        if _nextEvolutionName == nil{
            _nextEvolutionName = ""
        }
        return _nextEvolutionName
    }
    
    var nextEvolutionId: String{
        if _nextEvolutionId == nil{
            _nextEvolutionId = ""
        }
        return _nextEvolutionId
    }
    
    var nextEvolutionLevel: String{
        if _nextEvolutionLevel == nil{
            _nextEvolutionLevel = ""
        }
        return _nextEvolutionLevel
    }
    
    init(name: String, pokedexId: Int){
        //Set the basic pokemon details up and then generate the URL for the API
        self._name = name
        self._pokedexId = pokedexId
        self._pokemonURL = "\(BASE_URL)\(POKEMON_URL)\(self.pokedexId)/"
    }
    
    func downloadPokemonDetail(completed: @escaping DownloadComplete){
        //Go and get our pokedemon details
        Alamofire.request(_pokemonURL).responseJSON { (response) in
            //Did we get the proper JSON result back from our request
            if let dict = response.result.value as? Dictionary<String, Any>{
                //Is the weight detail a string
                if let weight = dict["weight"] as? String{
                    //Weight is a string so update the pokemon object
                    self._weight = weight
                }
                //Is the height detail a string
                if let height = dict["height"] as? String{
                    //Height is a string so update the pokemon object
                    self._height = height
                }
                //Is the defense detail an integer
                if let defense = dict["defense"] as? Int{
                    //Defense is an integer so update the pokemon object
                    self._defense = "\(defense)"
                }
                //Is attack detail an integer
                if let attack = dict["attack"] as? Int{
                    //Attack is an integer so update the pokemon object
                    self._attack = "\(attack)"
                }
                //Did we get any types
                if let types = dict["types"] as? [Dictionary<String, String>], types.count > 0{
                    //We got at leats 1 type so add the first one to our pokemon object
                    if let name = types[0]["name"]{
                        self._type = name.capitalized
                    }
                    //Did we get more than 1 type returned
                    if types.count > 1{
                        //Iterate through the other types
                        for x in 1..<types.count{
                            if let name = types[x]["name"]{
                                //Append the tpe to the pokemon object preceded by a "/" char
                                self._type! += "/\(name.capitalized)"
                            }
                        }
                    }
                    
                }else{
                    //No types for this pokemon were found
                    self._type = "No Type"
                }
                
                if let descArray = dict["descriptions"] as? [Dictionary<String, String>], descArray.count > 0{
                    if let uri = descArray[0]["resource_uri"]{
                        let url = BASE_URL + uri
                        Alamofire.request(url).responseJSON { (response) in
                            if let descDict = response.result.value as? Dictionary<String, Any>{
                                if let description = descDict["description"] as? String{
                                    let newDescription = description.replacingOccurrences(of: "POKMON", with: "Pokemon")
                                    print(newDescription)
                                    self._description = newDescription
                                }
                            }
                            //Sub request has now completed
                            completed()
                        }
                        
                    }
                } //End of sub request
                
                //Now check our evolutions
                if let evolutions = dict["evolutions"] as? [Dictionary<String, Any>], evolutions.count > 0{
                    if let nextEvo = evolutions[0]["to"] as? String{
                        if nextEvo.range(of: "mega") == nil{
                            self._nextEvolutionName = nextEvo
                            if let uri = evolutions[0]["resource_uri"] as? String{
                                let newStr = uri.replacingOccurrences(of: "/api/v1/pokemon/", with: "")
                                let nextEvoId = newStr.replacingOccurrences(of: "/", with: "")
                                self._nextEvolutionId = nextEvoId
                                if let lvlExist = evolutions[0]["level"] {
                                    if let lvl = lvlExist as? Int{
                                        self._nextEvolutionLevel = "\(lvl)"
                                    }
                                }else{
                                    self._nextEvolutionLevel = "0"
                                }
                            }
                            
                        }
                    }
                }
                
            } //End of main request
            else{
                //TODO: No pokemon dictionary available so handle this
            }
            //Main request has completed
            completed()
        }
    }
}
