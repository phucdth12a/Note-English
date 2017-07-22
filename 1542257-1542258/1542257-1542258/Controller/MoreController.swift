//
//  MoreController.swift
//  1542257-1542258
//
//  Created by Phu on 6/2/17.
//  Copyright © 2017 Phu. All rights reserved.
//

import UIKit

class MoreController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: *** UI Element
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: *** Data model
    var language: String?
    var name_en = ["Report", "Setting", "Data"]
    var name_vn = ["Thống kê", "Cài đặt", "Dữ liệu"]
    var image = ["Bullish-50-29.png", "Settings-50-29.png", "icons8-Database-50-29.png"]

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        super.viewWillAppear(animated)
        
        language = UserDefaults.standard.value(forKey: "App_Language") as? String
        
        if language == "vi" {
            self.navigationItem.title = "Thêm"
        } else {
            self.navigationItem.title = "More"
        }
        
        tableView.reloadData()
    }
    
    // MARK: *** UITableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MoreCellID", for: indexPath) as! MoreCell
        
        if language == "vi" {
            cell.imageViewImage.image = UIImage(named: image[indexPath.row])
            cell.labelTitle.text = name_vn[indexPath.row]
        } else {
            cell.imageViewImage.image = UIImage(named: image[indexPath.row])
            cell.labelTitle.text = name_en[indexPath.row]
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            performSegue(withIdentifier: "SegueMoreReportID", sender: nil)
        } else if indexPath.row == 1 {
            performSegue(withIdentifier: "SegueMoreSettingID", sender: nil)
        } else if indexPath.row == 2 {
            DatabaseManagement.shared.addDataDemo()
            
            if language == "vi" {
                alert(title: "Thông báo", message: "Thêm thành công")
            } else {
                alert(title: "Notification", message: "Inserted successfully")
            }
        }
    }
    
    

}
