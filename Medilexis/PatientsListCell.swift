//
//  PatientsListCell.swift
//  Medilexis
//
//  Created by iOS Developer on 07/07/2017.
//  Copyright © 2017 NX3. All rights reserved.
//

import UIKit

protocol ImagePressedDelegate{
    func imageTapped(at index:IndexPath, value: String)
}

protocol IDCardPressedDelegate{
    func idTapped(at index:IndexPath, value: String)
}

class PatientsListCell: UITableViewCell {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var dobLabel: UILabel!
    @IBOutlet var phoneLabel: UILabel!
    @IBOutlet var cardView: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileIDImage: UIImageView!
    @IBOutlet var medicalNoLabel: UILabel!
    
    var imageDelegate:ImagePressedDelegate!
    var idcardDelegate:IDCardPressedDelegate!
    var indexPath:IndexPath!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.updateUI()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(PatientsListCell.imageTapped(gesture:)))
        profileImage.addGestureRecognizer(tapGesture)
        profileImage.isUserInteractionEnabled = true
        
        let idTapGesture = UITapGestureRecognizer(target: self, action: #selector(PatientsListCell.idImageTapped(gesture:)))
        profileIDImage.addGestureRecognizer(idTapGesture)
        profileIDImage.isUserInteractionEnabled = true
     
    }
    
    @objc func imageTapped(gesture: UIGestureRecognizer) {
        
        let image = "Profile"
    
       self.imageDelegate?.imageTapped(at: indexPath, value: image)
        
    }
    
    @objc func idImageTapped(gesture: UIGestureRecognizer) {
        
        let image = "IDCard"
        
        self.idcardDelegate?.idTapped(at: indexPath, value: image)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateUI(){
        
        cardView.backgroundColor = UIColor.white
        self.contentView.backgroundColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
        self.cardView.layer.cornerRadius = 3.0
        cardView.layer.masksToBounds = false
        cardView.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        cardView.layer.shadowOffset = CGSize(width: 0, height: 0)
        cardView.layer.shadowOpacity = 0.8
    }
    
    
    

}
