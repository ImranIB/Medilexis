//
//  EditImage.swift
//  Medilexis
//
//  Created by mac on 21/12/2017.
//  Copyright © 2017 NX3. All rights reserved.
//

import UIKit
import CoreData
import AlamofireImage
import XLActionController

class EditImage: UIViewController, UIScrollViewDelegate  {
    
    @IBOutlet weak var editImageView: UIView!
    
    
    var type: String!
    var id: String!
    var image: String!
    var fileURL: URL!
    let userDefaults = Foundation.UserDefaults.standard
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var editImage: UIImageView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var imageScroll: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        editImageView.layer.borderWidth = 1.0
        editImageView.layer.borderColor = UIColor.darkGray.cgColor

        closeButton.layer.cornerRadius = 15
        
        imageScroll.delegate = self
        imageScroll.minimumZoomScale = 1.0
        imageScroll.maximumZoomScale = 10.0
        
        if image != "N/A" {
            
            if type == "Profile" {
                
                let fileManager = FileManager.default
                let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
                let documentsDirectoryURL: URL = urls.first!
                fileURL = documentsDirectoryURL.appendingPathComponent("ProfileImages/" + image)
               // let imageData = UIImage(contentsOfFile: (fileURL?.path)!)
               // self.editImage.image = imageData
                self.editImage.af_setImage(withURL: fileURL as URL, placeholderImage: UIImage(named: "placeHolder"), filter: nil, imageTransition: .crossDissolve(0.2))
                
            } else {
                
                let fileManager = FileManager.default
                let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
                let documentsDirectoryURL: URL = urls.first!
                fileURL = documentsDirectoryURL.appendingPathComponent("IDCardImages/" + image)
               // let imageData = UIImage(contentsOfFile: (fileURL?.path)!)
               // self.editImage.image = imageData
                self.editImage.af_setImage(withURL: fileURL as URL, placeholderImage: UIImage(named: "placeHolder"), filter: nil, imageTransition: .crossDissolve(0.2))
                
            }
      
        } else {
            
            self.editImage.image = UIImage(named: "thumb_image_not_available")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        
        return editImage
    }
    
    @IBAction func dismissView(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
    }
    

}
