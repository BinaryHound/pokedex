//
//  Pokemon.swift
//  Pokedex
//
//  Created by Lennard Neuwirth on 3/10/17.
//  Copyright © 2017 Lionsreach Studios, LLC. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
	
	fileprivate var _name: String!
	fileprivate var _pokedexID: Int!
	fileprivate var _description: String!
	fileprivate var _type: String!
	fileprivate var _defense: String!
	fileprivate var _height: String!
	fileprivate var _weight: String!
	fileprivate var _attack: String!
	fileprivate var _nextEvolutionTxt: String!
	fileprivate var _pokemonURL: String!
	fileprivate var _nextEvolutionName: String!
	fileprivate var _nextEvolutionId: String!
	fileprivate var _nextEvolutionLevel: String!

	
	var nextEvolutionLevel: String {
		if _nextEvolutionLevel == nil {
			_nextEvolutionLevel = ""
		}
		return _nextEvolutionLevel
	}
	
	var nextEvolutionId: String {
		if _nextEvolutionId == nil {
			_nextEvolutionId = ""
		}
		return _nextEvolutionId
	}

	var nextEvolutionName: String {
		if _nextEvolutionName == nil {
			_nextEvolutionName = ""
		}
		return _nextEvolutionName
	}
	
	var description: String {
		if _description == nil {
			_description = ""
		}
		return _description
	}
	
	var type: String {
		if _type == nil {
			_type = ""
		}
		return _type
	}
	
	var defense: String {
		if _defense == nil {
			_defense = ""
		}
		return _defense
	}
	
	var height: String {
		if _height == nil {
			_height = ""
		}
		return _height
	}
	
	var weight: String {
		if _weight == nil {
			_weight = ""
		}
		return _weight
	}

	var attack: String {
		if _attack == nil {
			_attack = ""
		}
		return _attack
	}
	
	var nextEvolutionTxt: String {
		if _nextEvolutionTxt == nil {
			_nextEvolutionTxt = ""
		}
		return _nextEvolutionTxt
	}
	
	var name: String {
		
		if _name == nil {
			_name = ""
		}
		return _name
	}
	
	var pokedexID: Int {
		if _pokedexID == nil {
			_pokedexID = 0
		}
		
		return _pokedexID
	}
	
	init(name: String, pokedexId: Int) {
		self._name = name
		self._pokedexID = pokedexId
		
		self._pokemonURL = "\(URL_BASE)\(URL_POKEMON)\(self.pokedexID)/"
	}
	
	func downloadPokemonDetail(completed: @escaping DownloadComplete) {
		
		Alamofire.request(_pokemonURL).responseJSON { (response) in
			
			
			 if let dict = response.result.value as? Dictionary<String, AnyObject> {
				if let weight = dict["weight"] as? String {
					self._weight = weight
				}
				if let height = dict["height"] as? String {
					self._height = height
				}
				if let attack = dict["attack"] as? Int {
					self._attack = "\(attack)"
				}
				if let defense = dict["defense"] as? Int {
					self._defense = "\(defense)"
				}
				if let types = dict["types"] as? [Dictionary<String, String>] , types.count > 0{
					
					if let name = types[0]["name"]  {
						self._type = name.capitalized
					}
					if types.count > 1 {
						for x in 1..<types.count {
							if let name = types[x]["name"] {
								self._type! += "/\(name.capitalized)"
							}
						}
					}
				}
				else {
					self._type = ""
				}

				if let descArr = dict["descriptions"] as? [Dictionary<String, String>] , descArr.count > 0 {

					if let url = descArr[0]["resource_uri"] {

						let descURL = "\(URL_BASE)\(url)"
						Alamofire.request(descURL).responseJSON{ response in

							//theres a bug here and i'm not sure why it's not showing on the storyboard.
							//
							if let descriptionDict = response.result.value as? Dictionary<String, AnyObject> {

								if let description = descriptionDict["description"] as? String {
									let newDescription = description.replacingOccurrences(of: "POKMON", with: "Pokemon")
										self._description = newDescription
									
								} 
							}
							completed()
						}
					}
				} else {
					self._description = ""
				}
				if let evolutions = dict["evolutions"] as? [Dictionary<String, AnyObject>] , evolutions.count > 0{
					
					if let evolutionPhase = evolutions[0]["to"] as? String  {
						
						if evolutionPhase.range(of: "mega") == nil {
							
							self._nextEvolutionName =  evolutionPhase
							
							if let uri = evolutions[0]["resource_uri"] as? String {
								
								let newString = uri.replacingOccurrences(of: "/api/v1/pokemon/", with: "")
								let nextEvoId = newString.replacingOccurrences(of: "/", with: "")
								
								self._nextEvolutionId = nextEvoId
								
								if let lvlExist = evolutions[0]["level"] {
									if let lvl = lvlExist as? Int {
										self._nextEvolutionLevel = "\(lvl)"
									}
									
								} else {
									self._nextEvolutionLevel = ""
								}
							}
						}
					}
				}
		}
			completed()
	}
  }
}
