//
//  ViewController.swift
//  Rene_sPokemon
//
//  Created by Rene Ouoba on 10/29/20.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var myTableView: UITableView!
    
    var dispatchGroup1 = DispatchGroup()
    
    var indexToPrefetchFrom = 25
    var  currentMaxNoOfPokemon = 30
    let increment = 30
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.register(UINib(nibName: "PokemonCell", bundle: .main), forCellReuseIdentifier: "cell")
        
        downloadData(from: 0, to: currentMaxNoOfPokemon-1, using: NetworkManager.shared.myUrl)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = sender as? IndexPath else {return}
        
        guard let vc = segue.destination as? DetailsViewController else { return }
        guard let pokemonSelected = listOfPokemonData[indexPath.row] else { return }
        var types = "Type(s): "
        var moves = "Moves: "
        var abilities = "Abilities: "
        
        vc.spriteImage = listOfPokemonSprites[indexPath.row]
        vc.number = "No \(indexPath.row+1)"
        vc.name = pokemonSelected.name

        types += pokemonSelected.types[0].type.name
        if pokemonSelected.types.count > 1 {
            for index in 1...pokemonSelected.types.count-1 {
                types += ", " + pokemonSelected.types[index].type.name
            }
        }
        vc.types = types

        moves += pokemonSelected.moves[0].move.name
        for index in 1...pokemonSelected.moves.count-1 {
            moves += ", " + pokemonSelected.moves[index].move.name
        }
        vc.moves = moves

        abilities += pokemonSelected.abilities[0].ability.name
        for index in 1...pokemonSelected.abilities.count-1 {
            abilities += ", " + pokemonSelected.abilities[index].ability.name
        }
        vc.abilities = abilities
    }
    
    
    
    //Mark:- Helpers
    func downloadData(from: Int, to: Int, using aUrl: String) {
        dispatchGroup1.enter()
        NetworkManager.shared.fetchPokemonNamesAndURLs(with: aUrl) { [weak self] dataDownloaded in
            guard let self = self else {return}
            guard let safeDataDownloaded = dataDownloaded else { return }
            myResults.next = safeDataDownloaded.next
            myResults.previous = safeDataDownloaded.previous
           
            for index in 0...safeDataDownloaded.results.count - 1 {
                myResults.results.append(safeDataDownloaded.results[index])
            }
            self.dispatchGroup1.leave()
            
//            DispatchQueue.main.async {
//                self.myTableView.reloadData()
//            }

        }

        dispatchGroup1.notify(queue: .main) {
            for index in from...to {
                NetworkManager.shared.fetchPokemonData(atPosition: index) { [weak self] pokemonDataDownloaded in
                    guard let self = self else { return }
                    guard let safePokemonDataDownloaded = pokemonDataDownloaded else { return }
                    listOfPokemonData[index] = safePokemonDataDownloaded
                    NetworkManager.shared.fetchSprites(atPosition: index) { [weak self] data in
                        guard let self = self else { return }
                        listOfPokemonSprites[index] = data
                        DispatchQueue.main.async {
                            self.myTableView.reloadData()
                        }
                    }
                    
//                    DispatchQueue.main.async {
//                        self.myTableView.reloadData()
//                    }
                }
            }
        }
    }
    
    
    func displayAlert(messageTitle: String, messageContent: String) {
        let alertController = UIAlertController(title: messageTitle, message: messageContent, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "Close", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }
}



//Mark: - Extension
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myResults.results.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = myTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? PokemonCell else {return UITableViewCell()}
        
        if listOfPokemonData.count > indexPath.row {
            cell.name.text = listOfPokemonData[indexPath.row]?.name
            cell.element.text = listOfPokemonData[indexPath.row]?.types[0].type.name ?? ""
        }
        if listOfPokemonSprites.count > indexPath.row {
            cell.sprite.image = listOfPokemonSprites[indexPath.row]
        }
        return cell
    }

    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //Initially, indexToPrefetchFrom=25 and currentMaxNoOfPokemon=30
        if currentMaxNoOfPokemon < maximumNumberOfPokemon && indexPath.row == indexToPrefetchFrom && myResults.results.count < currentMaxNoOfPokemon+increment {
            downloadData(from: currentMaxNoOfPokemon, to: currentMaxNoOfPokemon+increment-1, using: myResults.next!)
            indexToPrefetchFrom += increment
            currentMaxNoOfPokemon += increment
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "towardsDetailsView", sender: indexPath)
    }
    
}


