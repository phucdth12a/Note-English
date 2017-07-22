//
//  PreviewImageController.swift
//  1542257-1542258
//
//  Created by Phu on 5/26/17.
//  Copyright © 2017 Phu. All rights reserved.
//

import UIKit

class PreviewImageController: UIViewController {
    
    // MARK: *** UI Element
    @IBOutlet weak var imageViewImage: UIImageView!
    
    // MARK: *** Data model
    var image: String?
    var language: String?
    
    // MARK: *** UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        language = UserDefaults.standard.value(forKey: "App_Language") as? String
        if  language == "vi" {
            self.navigationItem.title = "Hình Ảnh"
        } else {
            self.navigationItem.title = "Image"
        }
        
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let imageDirectoryPath = path.appending("/Image/\(image!)")

        imageViewImage.image = UIImage(contentsOfFile: imageDirectoryPath)
    }

}
