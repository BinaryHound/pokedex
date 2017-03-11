//
//  MainVC.swift
//  Pokedex
//
//  Created by Lennard Neuwirth on 3/10/17.
//  Copyright © 2017 Lionsreach Studios, LLC. All rights reserved.
//

import UIKit
import AVFoundation

class MainVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {

	@IBOutlet weak var collection: UICollectionView!
	@IBOutlet weak var searchBar: UISearchBar!
	
	
	//create an array of pokemon
	var inSearchMode = false
	var pokemon = [Pokemon]()
	var filteredPokemon = [Pokemon]()
	var musicPlayer = AVAudioPlayer()
	
	override func viewDidLoad() {
		super.viewDidLoad()

		collection.delegate = self
		collection.dataSource = self
		
		searchBar.delegate = self
		
		searchBar.returnKeyType = UIReturnKeyType.done
		
		parsePokemonCSV()
		initAudio()
		
	}
	
	func initAudio() {
		
		let path = Bundle.main.path(forResource: "music", ofType: "mp3")!
		
		do {
			
			musicPlayer = try AVAudioPlayer(contentsOf: URL(string: path)!)
			musicPlayer.prepareToPlay()
			musicPlayer.numberOfLoops = -1
			musicPlayer.play()
			
			
		} catch let err as NSError{
			print(err)
			
		}
		
	}
	
	func parsePokemonCSV() {
		let path = Bundle.main.path(forResource: "pokemon", ofType: "csv")!
		
		do {
			
			let csv = try CSV(contentsOfURL: path)
			let rows = csv.rows
			for row in rows {
				
				let pokeId = Int(row["id"]!)!
				let name = row["identifier"]!
				
				let poke = Pokemon(name: name, pokedexId: pokeId)
				pokemon.append(poke)
			}
		} catch let err as NSError{
			print(err)
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokeCell", for: indexPath) as? PokeCell {
			
			let poke: Pokemon!
			if inSearchMode {
				poke = filteredPokemon[indexPath.row]
				cell.configureCell(poke)
			} else {
				poke = pokemon[indexPath.row]
				cell.configureCell(poke)
			}
			
			return cell
		} else {
			return UICollectionViewCell()
		}
		
		
	}
	
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
	
		var poke: Pokemon!
		
		if inSearchMode {
			poke = filteredPokemon[indexPath.row]
		}
		else {
			poke = pokemon[indexPath.row]
		}
		
		performSegue(withIdentifier: "PokemonDetailVC", sender: poke)
		
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		if inSearchMode {
			return filteredPokemon.count
		}
		else {
			return pokemon.count
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		
		//defines the size of the cells. we want this height and width
		
		return CGSize(width: 105, height: 105)
	}
	
	
	@IBAction func musicBtnPressed(_ sender: UIButton) {
		if musicPlayer.isPlaying {
			musicPlayer.pause()
			sender.alpha = 0.2
		} else {
			musicPlayer.play()
			sender.alpha = 1.0
		}
	}
	
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		view.endEditing(true)
	}
	
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		
		if searchBar.text == nil || searchBar.text == ""{
			inSearchMode = false
			collection.reloadData()
			view.endEditing(true)
		} else {
			inSearchMode = true
			
			let lowercaseSearch = searchBar.text!.lowercased()
			// $0 is a placeholder for objects in pokemon then we take the name value and then is what we put in the search bar contained in that name
			// if it is then put that into the pokemon list.
			filteredPokemon = pokemon.filter({$0.name.range(of: lowercaseSearch) != nil})
			collection.reloadData()
			
		}
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		
		if segue.identifier == "PokemonDetailVC" {
			
			if let detailsVC = segue.destination as? PokemonDetailVC {
				
				if let poke = sender as? Pokemon {
					
					detailsVC.pokemon = poke
				}
			}
		}
		
	}


}

