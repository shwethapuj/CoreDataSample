//
//  DisplayContactTVC.swift
//  CoreDataTask
//
//  Created by ios1 on 24/10/18.
//  Copyright © 2018 ios. All rights reserved.
//

import UIKit

class DisplayContactTVC: UITableViewCell,ReusableView {

    @IBOutlet weak var imageViewOutlet: UIImageView!
    @IBOutlet weak var contactNumberLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        imageViewOutlet.layer.cornerRadius = imageViewOutlet.layer.frame.width / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
