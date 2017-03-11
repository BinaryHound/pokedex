//
//  PokemonDetailVC.swift
//  Pokedex
//
//  Created by Lennard Neuwirth on 3/10/17.
//  Copyright © 2017 Lionsreach Studios, LLC. All rights reserved.
//

import UIKit

class PokemonDetailVC: UIViewController {

	var pokemon: Pokemon!

	@IBOutlet weak var nameLbl: UILabel!
	@IBOutlet weak var mainImg: UIImageView!
	@IBOutlet weak var descriptionLbl: UILabel!
	@IBOutlet weak var typeLbl: UILabel!
	@IBOutlet weak var heightLbl: UILabel!
	@IBOutlet weak var weightLbl: UILabel!
	@IBOutlet weak var attackLbl: UILabel!
	@IBOutlet weak var defenseLbl: UILabel!
	@IBOutlet weak var pokdexLbl: UILabel!
	@IBOutlet weak var currentEvoImg: UIImageView!
	@IBOutlet weak var nextEvoImg: UIImageView!
	@IBOutlet weak var evoLbl: UILabel!


	
	
    override func viewDidLoad() {
        super.viewDidLoad()

		nameLbl.text = pokemon.name.capitalized
		
		let img = UIImage(named: "\(pokemon.pokedexID)")
		mainImg.image = img
		
		currentEvoImg.image = img
		pokdexLbl.text = "\(pokemon.pokedexID)"
		
		pokemon.downloadPokemonDetail {
			//whatever we run here will only be called after the network call is complete!  :)
			self.updateUI()
		}
    }
	
	func updateUI() {
		
		weightLbl.text = pokemon.weight
		attackLbl.text = pokemon.attack
		heightLbl.text = "\(pokemon.height)"
		defenseLbl.text = pokemon.defense
		descriptionLbl.text = pokemon.description
		typeLbl.text = pokemon.type
		
		
		
		if pokemon.nextEvolutionId == "" {
			evoLbl.text = "No Evolutions"
			//with stack views automatically centers the next image
			nextEvoImg.isHidden = true
			
		} else {
			nextEvoImg.isHidden = false
			nextEvoImg.image = UIImage(named: pokemon.nextEvolutionId)
			let str = "Next Evolution: \(pokemon.nextEvolutionName) - LVL \(pokemon.nextEvolutionLevel)"
			evoLbl.text = str
		}
		
	}
	
	@IBAction func backButtonPressed(_ sender: Any) {
		dismiss(animated: true, completion: nil)
	}
	

}
