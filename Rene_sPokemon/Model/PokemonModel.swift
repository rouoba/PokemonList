//
//  Pokemon.swift
//  Rene_sPokemon
//
//  Created by Rene Ouoba on 10/29/20.
//

import UIKit

var maximumNumberOfPokemon = 150
var myResults: Result = Result()
var listOfPokemonData: [PokemonData?] = [PokemonData?](repeating: nil, count: maximumNumberOfPokemon)
var listOfPokemonSprites = [UIImage?](repeating: nil, count: maximumNumberOfPokemon)

struct Result: Decodable {
    var next: String?
    var previous: String?  //not necessary. only needs next when prefetching
    var results: [Pokemon] = []
}


struct Pokemon: Decodable {
    var name: String
    var url: String
}


struct PokemonData: Decodable {
    var abilities: [AbilityType]
    var moves: [MoveType]
    var name: String
    var species: Name
    var sprites: SpriteType
    var types: [Type]
}



struct Name: Decodable { 
    var name: String
}

struct AbilityType: Decodable {
    var ability: Name
}

struct MoveType: Decodable {
    var move: Name
}

struct SpriteType: Decodable {
    var front_default: String
}

struct Type: Decodable {
    var type: Name
}
