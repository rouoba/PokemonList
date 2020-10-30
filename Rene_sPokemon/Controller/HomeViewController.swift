//
//  ViewController.swift
//  Rene_sPokemon
//
//  Created by Rene Ouoba on 10/29/20.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var myTableView: UITableView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        myTableView.register(UINib(nibName: "PokemonCell", bundle: .main), forCellReuseIdentifier: "cell")
        
        NetworkManager.shared.fetchPokemonNamesAndURLs(storeIn: &results, and: &listOfPokemonNamesAndURLS)
        NetworkManager.shared.fetchPokemonData(first: 0, last: 29)
    }


}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOPokemonData.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = myTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? PokemonCell else {return UITableViewCell()}
        cell.name.text = results.results[indexPath.row].name
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        myTableView.deselectRow(at: indexPath, animated: true)
    }
}

