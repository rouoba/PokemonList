//
//  DetailsViewController.swift
//  Rene_sPokemon
//
//  Created by Rene Ouoba on 10/31/20.
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet weak var spriteImageView: UIImageView!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var typesLabel: UILabel!
    @IBOutlet weak var movesLabel: UILabel!
    @IBOutlet weak var abilitiesLabel: UILabel!
    
    var spriteImage: UIImage?
    var number: String?
    var name: String?
    var types: String?
    var moves: String?
    var abilities: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        spriteImageView.image = spriteImage
        numberLabel.text = number
        nameLabel.text = name
        typesLabel.text = types
        movesLabel.text = moves
        abilitiesLabel.text = abilities
    }


}
