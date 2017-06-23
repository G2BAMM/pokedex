//
//  ViewController.swift
//  pokedex
//
//  Created by Brian McAulay on 06/06/2017.
//  Copyright © 2017 Brian McAulay. All rights reserved.
//

import UIKit
import AVFoundation

class MainVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, UISearchBarDelegate {

    @IBOutlet weak var controlview: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var btnSoundToggle: UIButton!
    
    var pokemon = [Pokemon]()
    var filteredPokemon = [Pokemon]()
    var audioPlayer: AVAudioPlayer!
    var inSearchMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Set up our delegates
        controlview.dataSource = self
        controlview.delegate = self
        searchBar.delegate = self
        //Extract our global pokemon list
        parsePokemonCSV()
        //Create our media player object
        initAudio()
        //Configure our searchbar keyboard
        searchBar.returnKeyType = UIReturnKeyType.done
        searchBar.enablesReturnKeyAutomatically = false
        //sleep(10)
        
    }
    
    func initAudio(){
        //Set the music file
        let path = Bundle.main.path(forResource: "music", ofType: "mp3")!
        //Configure the media player object
        do{
            //No errors so we can continue to set up our audio player
            audioPlayer = try AVAudioPlayer(contentsOf: URL(string: path)!)
            audioPlayer.prepareToPlay()
            audioPlayer.numberOfLoops = -1
            audioPlayer.setVolume(0.2, fadeDuration: 0)
            btnSoundToggle.alpha = 0.6
        } catch let err as NSError{
            //There was an error crearting the audio player, so advise and continue
            print(err.debugDescription)
        }
    }
    
    func parsePokemonCSV(){
        //Set the file containing our pokemon list
        let path = Bundle.main.path(forResource: "pokemon", ofType: "csv")!
        //Pick up the csv containing the pokemons
        do{
            //No errors, so we can continue to build our pokeomon list
            let csv = try CSV(contentsOfURL: path)
            let rows = csv.rows
            //print(rows)
            //Generate a pokemon list from the CSV
            for row in rows{
                let pokeId = Int(row["id"]!)!
                let name = row["identifier"]!
                let myPokemon = Pokemon(name: name, pokedexId: pokeId)
                pokemon.append(myPokemon)
            }
            //Order the list into alpha order A-Z(a-z)
            pokemon.sort { ($0.name) < ($1.name) }
        } catch let err as NSError{
            //An error occurred during the pokemon CSV read so advise and continue
            print(err.debugDescription)
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //Check we're setting up a cell on our collectionview
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokeCell", for: indexPath) as? PokeCell{
            //This is a cell we need to reuse so populat our pokemon object from the indexpath
            let poke: Pokemon!
            if inSearchMode{
                //Search mode active, so bind from the filtered list
                poke = filteredPokemon[indexPath.row]
                //Populate the cell details
                cell.configureCell(pokemon: poke)
            }else{
                //Search mode not active, so bind from unflitered list
                poke = pokemon[indexPath.row]
                //Populate the cell details
                cell.configureCell(pokemon: poke)
            }
            //Add our cell to the stack
            return cell
        }else{
            //Return an empty cell
            return UICollectionViewCell()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //Set up our pokemon object
        var myPokemon: Pokemon!
        //Are we in search mode
        if inSearchMode{
            //Search mode active, so filter the list of pokemon
            myPokemon = filteredPokemon[indexPath.row]
        }else{
            //Search mode not active, so bind the whole list of pokemon
            myPokemon = pokemon[indexPath.row]
        }
        //Move to the detail view screen
        performSegue(withIdentifier: "DetailVC", sender: myPokemon)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if inSearchMode{
            //Search mode is activated so return a filtered pokemon list count
            return filteredPokemon.count
        }else{
            //No search mode applied so return complete pokemon list count
            return pokemon.count
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //Set the size of the pokeomon image in the collectionview
        return CGSize(width: 105, height: 105)
    }

    @IBAction func btnSoundTogglePressed(_ sender: UIButton) {
        if audioPlayer.isPlaying{
            //Audio is currently playing so switch it off
            audioPlayer.pause()
            sender.alpha = 0.6
        }else{
            //Audio is not currently playing so switch it on
            audioPlayer.play()
            sender.alpha = 1.0
        }
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //Hide the keyboard when ending the search entry
        view.endEditing(true)
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == ""{
            //Search mode is being disabled so reload the newly unfiltered data
            inSearchMode = false
            controlview.reloadData()
            view.endEditing(true)
        }else{
            //Search mode is being enabled, so prepare to filter the list
            inSearchMode = true
            let lower = searchBar.text!.lowercased()
            //Apply the filter to the pokemon list and filter using prefix
            filteredPokemon = pokemon.filter({$0.name.hasPrefix(lower)})
            //Finally rebind the filtered pokemon list to the collectionview
            controlview.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //We're ready to go to the next screen, so prepare for this by checking which screen we're going to
        if let destination = segue.destination as? DetailVC{
            //Going to the pokemon detail screen so prepare to move there with a pokemon object
            if let pokemon = sender as? Pokemon{
                //Pass the pokemon object into the destination controller
                destination.pokemon = pokemon
            }
        }
    }
    
    
}

