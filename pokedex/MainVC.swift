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
            audioPlayer = try AVAudioPlayer(contentsOf: URL(string: path)!)
            audioPlayer.prepareToPlay()
            audioPlayer.numberOfLoops = -1
            audioPlayer.setVolume(0.2, fadeDuration: 0)
            btnSoundToggle.alpha = 0.6
        } catch let err as NSError{
            print(err.debugDescription)
        }
    }
    
    func parsePokemonCSV(){
        //Set the file containing our pokemon list
        let path = Bundle.main.path(forResource: "pokemon", ofType: "csv")!
        
        do{
            let csv = try CSV(contentsOfURL: path)
            let rows = csv.rows
            print(rows)
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
            print(err.debugDescription)
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokeCell", for: indexPath) as? PokeCell{
            
            let poke: Pokemon!
            if inSearchMode{
                poke = filteredPokemon[indexPath.row]
                cell.configureCell(pokemon: poke)
            }else{
                poke = pokemon[indexPath.row]
                cell.configureCell(pokemon: poke)
            }
            return cell
        }else{
            return UICollectionViewCell()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var myPokemon: Pokemon!
        if inSearchMode{
            myPokemon = filteredPokemon[indexPath.row]
        }else{
            myPokemon = pokemon[indexPath.row]
        }
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
            //Apply the filter to the pokemon list
            filteredPokemon = pokemon.filter({$0.name.hasPrefix(lower)})
            //Finally rebind the filtered pokemon list to the collectionview
            controlview.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? DetailVC{
            if let pokemon = sender as? Pokemon{
                destination.pokemon = pokemon
            }
        }
    }
    
    
}

