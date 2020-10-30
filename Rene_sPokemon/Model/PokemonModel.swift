//
//  Pokemon.swift
//  Rene_sPokemon
//
//  Created by Rene Ouoba on 10/29/20.
//

import UIKit

var results: Result = Result()
var listOfPokemonNamesAndURLS: [Pokemon] = []
var listOPokemonData: [PokemonData] = []
var listOfPokemonCells: [UIImage?, String, String]

struct Result: Decodable {
    var next: String = ""
    var previous: String? = ""
    var results: [Pokemon] = []
}


struct Pokemon: Decodable {
    var name: String
    var url: String
}


struct PokemonData: Decodable {
    var abilities: [AbilityType]
    var moves: [MoveType]
    var species: SpeciesType
    var sprites: SpriteType
    var types: [Type]
}

struct AbilityType: Decodable {
    var ability: ability
}

struct ability: Decodable {
    var name: String
}

struct MoveType: Decodable {
    var move: move
}

struct move: Decodable {
    var name: String
}

struct SpeciesType: Decodable {
    var name: String
}

struct SpriteType: Decodable {
    var front_default: String
    var other: OtherType
}

struct OtherType:Decodable {
    var dream_world: Dream_worldType
}

struct Dream_worldType: Decodable {
    var front_default: String
}

struct Type: Decodable {
    var type: type
}

struct type: Decodable {
    var name: String
}
