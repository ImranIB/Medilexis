//
//  SubscriptionCell.swift
//  Medilexis
//
//  Created by iOS Developer on 26/07/2017.
//  Copyright © 2017 NX3. All rights reserved.
//

import UIKit

class SubscriptionCell: UITableViewCell {
    
    @IBOutlet var subscriptionText: UILabel!
    @IBOutlet var subscriptionDetail: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
