//
//  UpdateDxCell.swift
//  Medilexis
//
//  Created by iOS Developer on 31/05/2017.
//  Copyright © 2017 NX3. All rights reserved.
//

import UIKit

class UpdateDxCell: UITableViewCell {

    @IBOutlet weak var dxCardView: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var codeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
         self.updateUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       self.updateUI()
    }

    func updateUI(){
        
        dxCardView.backgroundColor = UIColor.white
        self.contentView.backgroundColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
        self.dxCardView.layer.cornerRadius = 3.0
        dxCardView.layer.masksToBounds = false
        dxCardView.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        dxCardView.layer.shadowOffset = CGSize(width: 0, height: 0)
        dxCardView.layer.shadowOpacity = 0.8
    }
}
