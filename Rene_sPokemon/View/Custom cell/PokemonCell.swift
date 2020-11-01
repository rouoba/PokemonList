//
//  PokemonCell.swift
//  Rene_sPokemon
//
//  Created by Rene Ouoba on 10/29/20.
//

import UIKit

class PokemonCell: UITableViewCell {

    @IBOutlet weak var sprite: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var element: UILabel!
    @IBOutlet weak var cellContentArea: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cellContentArea.layer.cornerRadius = 20
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
