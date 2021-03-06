//
//  ViewController.swift
//  Rene_sPokemon
//
//  Created by Rene Ouoba on 10/29/20.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var myTableView: UITableView!
    
    var dispatchGroup = DispatchGroup()
    
    var indexToPrefetchFrom = 25
    var  currentMaxNoOfPokemon = 30
    let increment = 30
    var numberOfPokemonDownloaded = 0
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.register(UINib(nibName: "PokemonCell", bundle: .main), forCellReuseIdentifier: "cell")
        
        downloadData(from: 0, to: currentMaxNoOfPokemon-1, using: NetworkManager.shared.myUrl)
    }
    
    
   
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = sender as? IndexPath else {return}
        guard let vc = segue.destination as? DetailsViewController else { return }
        
        guard let pokemonSelected = listOfPokemonData[indexPath.row] else { return }
        preparePokemonData(for: vc, with: indexPath, and: pokemonSelected)
    }
    
    
    
    //MARK:- Helpers
    fileprivate func preparePokemonData(for vc: DetailsViewController, with indexPath: IndexPath, and pokemonSelected: PokemonData) {
        var types = "Type(s): "
        var moves = "Moves: "
        var abilities = "Abilitie(s): "
        
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
        if pokemonSelected.abilities.count > 1 {
            for index in 1...pokemonSelected.abilities.count-1 {
                abilities += ", " + pokemonSelected.abilities[index].ability.name
            }
        }
        vc.abilities = abilities
    }
    
    
    
    func downloadData(from: Int, to: Int, using aUrl: String) {
        dispatchGroup.enter()
        NetworkManager.shared.fetchPokemonNamesAndURLs(with: aUrl) { [weak self] dataDownloaded in
            guard let self = self else {return}
            guard let safeDataDownloaded = dataDownloaded else { return }
            myResults.next = safeDataDownloaded.next
            myResults.previous = safeDataDownloaded.previous
           
            for index in 0...safeDataDownloaded.results.count - 1 {
                myResults.results.append(safeDataDownloaded.results[index])
            }
            self.dispatchGroup.leave()
        }

        dispatchGroup.notify(queue: .main) {
            for index in from...to {
                NetworkManager.shared.fetchPokemonData(atPosition: index) { [weak self] pokemonDataDownloaded in
                    guard let self = self else { return }
                    guard let safePokemonDataDownloaded = pokemonDataDownloaded else { return }
                    listOfPokemonData[index] = safePokemonDataDownloaded
                    NetworkManager.shared.fetchSprites(atPosition: index) { [weak self] data in
                        guard let self = self else { return }
                        listOfPokemonSprites[index] = data
                        self.numberOfPokemonDownloaded += 1
                        
                        if self.numberOfPokemonDownloaded == 30 {
                            DispatchQueue.main.async {
                                self.myTableView.reloadData()
                                self.numberOfPokemonDownloaded = 0
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    
    @IBAction func displayFavoritePokemon(_ sender: UIButton) {
        //display favorite in a pop up
        if userDefaults.value(forKey: "favorite") != nil {
            displayAlert(messageTitle: "You should not forget that!", messageContent: "\(userDefaults.value(forKey: "favorite") ?? "") is your favorite Pokemon")
        } else {
            displayAlert(messageTitle: "Too bad", messageContent: "You do not have a favorite Pokemon yet.")
        }
    }
    
    
    
    func displayAlert(messageTitle: String, messageContent: String) {
        let alertController = UIAlertController(title: messageTitle, message: messageContent, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "Close", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }
}



//MARK: - Extension
extension HomeViewController: UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myResults.results.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = myTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? PokemonCell else {return UITableViewCell()}
        
        if listOfPokemonData[indexPath.row] != nil {
            cell.name.text = listOfPokemonData[indexPath.row]?.name
            cell.element.text = "Main type: \(listOfPokemonData[indexPath.row]?.types[0].type.name ?? "")"
        }
        if listOfPokemonSprites[indexPath.row] != nil {
            cell.sprite.image = listOfPokemonSprites[indexPath.row]
        }
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        //Initially, indexToPrefetchFrom=25 and currentMaxNoOfPokemon=30
        for indexPath in indexPaths {
            if indexPath.row == indexToPrefetchFrom && currentMaxNoOfPokemon < maximumNumberOfPokemon && myResults.results.count < currentMaxNoOfPokemon+increment {
//                print("prefetching")
                guard let nextPokemonsUrl = myResults.next else {return}
                downloadData(from: currentMaxNoOfPokemon, to: currentMaxNoOfPokemon+increment-1, using: nextPokemonsUrl)
                indexToPrefetchFrom += increment
                currentMaxNoOfPokemon += increment
            }
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "towardsDetailsView", sender: indexPath)
    }
    
}


