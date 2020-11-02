//
//  NetworkManager.swift
//  Rene_sPokemon
//
//  Created by Rene Ouoba on 10/29/20.
//

import UIKit

final class NetworkManager {
    static var shared: NetworkManager = NetworkManager()
    let myUrl = "https://pokeapi.co/api/v2/pokemon?offset=0&limit=30"
    
    let session: URLSession
    private init(session: URLSession = URLSession.shared) {
        self.session = session
    }
}



extension NetworkManager {
    
    func fetchPokemonNamesAndURLs(with aUrl: String, completion: @escaping (Result?) -> ()) {
        guard let url = URL(string: aUrl) else {
            completion(nil)
            return}
        
        session.dataTask(with: url) { (data, response, error) in
            if let _ = error {
                completion(nil)
//                self.displayAlert(messageTitle: "Error", messageContent: "List of Pokemon could not be retieved. Check internet connection")
                return
            }
            guard let data = data else {
                completion(nil)
                return
            }
            do {
                let dataDownloaded = try JSONDecoder().decode(Result.self, from: data)
                completion(dataDownloaded)
            } catch let error {
                print(error)
            }
        }.resume()
    }
    
    
    func fetchPokemonData(atPosition position: Int, completion: @escaping (PokemonData?) -> ()) {
        let urlString = myResults.results[position].url
        guard let url = URL(string: urlString) else {return}
        
        session.dataTask(with: url) { (data, response, error) in
            if let _ = error {
                completion(nil)
//                self.displayAlert(messageTitle: "Error", messageContent: "List of Pokemon could not be retieved. Check internet connection")
                return
            }
            
            guard let data = data else {
                completion(nil)
                return
            }
            
            do {
                let pokemonDataDownloaded = try JSONDecoder().decode(PokemonData.self, from: data)
                completion(pokemonDataDownloaded)
            } catch let error {
                print(error) 
            }
        }.resume()
    }
    
    
    func fetchSprites(atPosition position: Int, completion: @escaping (UIImage?) -> ()) {
        guard let urlString = listOfPokemonData[position]?.sprites.front_default else {return}
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        session.dataTask(with: url) { (data, response, error) in
            if let _ = error {
//                self.displayAlert(messageTitle: "Error", messageContent: "List of Pokemon could not be retieved. Check internet connection")
                completion(nil)
                return
            }
            guard let data = data else {
                completion(nil)
                return
            }
            completion(UIImage(data: data))
            return
        }.resume()
    }
    
//    func displayAlert(messageTitle: String, messageContent: String) {
//        let alert = UIAlertController(title: messageTitle, message: messageContent, preferredStyle: .alert)
//
//        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: nil))
//        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
//
//        self.present(alert, animated: true)
//    }
}
