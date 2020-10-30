//
//  NetworkManager.swift
//  Rene_sPokemon
//
//  Created by Rene Ouoba on 10/29/20.
//

import Foundation

final class NetworkManager {
    static var shared: NetworkManager = NetworkManager()
    let myUrl = "https://pokeapi.co/api/v2/pokemon?offset=0&limit=30"
    
    let session: URLSession
    private init(session: URLSession = URLSession.shared) {
        self.session = session
    }
}

extension NetworkManager {
    
    func fetchPokemonNamesAndURLs(storeIn: inout Result, and: inout [Pokemon]) {
        guard let url = URL(string: myUrl) else {return}
        do {
            let data = try Data(contentsOf: url)
            print(data)
            let jsonResults = try JSONDecoder().decode(Result.self, from: data)

            storeIn.next = jsonResults.next
            storeIn.previous = jsonResults.previous
            storeIn.results = jsonResults.results
            for index in 0...jsonResults.results.count-1 {
                and.append(jsonResults.results[index])
            }
        } catch let error {
            //Display alert on screen
            print(error)
        }
    }
    
    
    func fetchPokemonData(first: Int, last: Int) {
        // fetch pokemon data from listOfPokemonNamesAndURLS[index].url and store in listOPokemonData[index]
        
        for index in first...last {
            let urlString = listOfPokemonNamesAndURLS[index].url
            guard let url = URL(string: urlString) else {return}
            do {
                let data = try Data(contentsOf: url)
                let jsonResults = try JSONDecoder().decode(PokemonData.self, from: data)

                listOPokemonData.append(jsonResults)
            } catch let error {
                //Display alert on screen
                print(error)
            }
        }
        
    }
}
