//
//  UpdateCptCell.swift
//  Medilexis
//
//  Created by iOS Developer on 31/05/2017.
//  Copyright © 2017 NX3. All rights reserved.
//

import UIKit

class UpdateCptCell: UITableViewCell {
    
    @IBOutlet weak var cptCardView: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var codeLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
       self.updateUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateUI(){
        
        cptCardView.backgroundColor = UIColor.white
        self.contentView.backgroundColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
        self.cptCardView.layer.cornerRadius = 3.0
        cptCardView.layer.masksToBounds = false
        cptCardView.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        cptCardView.layer.shadowOffset = CGSize(width: 0, height: 0)
        cptCardView.layer.shadowOpacity = 0.8
    }

}
