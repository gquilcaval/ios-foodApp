//
//  PedidosTableViewCell.swift
//  FoodApp
//
//  Created by Anonymus on 4/12/21.
//

import UIKit

class PedidosTableViewCell: UITableViewCell {
   
    @IBOutlet weak var lblNombre: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if selected {
                 contentView.backgroundColor = UIColor.red
             } 
    }

}

