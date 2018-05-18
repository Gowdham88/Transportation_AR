//
//  itemCell.swift
//  Ikea
//
//  Created by Rayan Slim on 2017-08-18.
//  Copyright © 2017 Rayan Slim. All rights reserved.
//

import UIKit

class itemCell: UICollectionViewCell {
 
    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var viewLabel: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewLabel.layer.cornerRadius = 10
        
    }
    
}
