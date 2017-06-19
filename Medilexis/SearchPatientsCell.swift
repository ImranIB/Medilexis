//
//  SearchPatientsCell.swift
//  Medilexis
//
//  Created by iOS Developer on 05/04/2017.
//  Copyright © 2017 NX3. All rights reserved.
//

import UIKit

class SearchPatientsCell: UITableViewCell {
    
    
    @IBOutlet weak var patientName: UILabel!
    @IBOutlet weak var patientSchedule: UILabel!
    @IBOutlet weak var recordingIcon: UIImageView!
    @IBOutlet weak var transcriptionIcon: UIImageView!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var upload: UIButton!
    @IBOutlet weak var uploadStatus: UILabel!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
       self.updateSearchUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateSearchUI(){
        
        cardView.backgroundColor = UIColor.white
        self.contentView.backgroundColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
        self.cardView.layer.cornerRadius = 3.0
        cardView.layer.masksToBounds = false
        cardView.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        cardView.layer.shadowOffset = CGSize(width: 0, height: 0)
        cardView.layer.shadowOpacity = 0.8
    }

}
