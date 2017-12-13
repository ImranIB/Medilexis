//
//  VoiceToTextCell.swift
//  Medilexis
//
//  Created by iOS Developer on 28/07/2017.
//  Copyright © 2017 NX3. All rights reserved.
//

import UIKit

class VoiceToTextCell: UITableViewCell {

    @IBOutlet var noOfEncounters: UILabel!
    @IBOutlet var amount: UILabel!
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
