//
//  AddController.swift
//  1542257-1542258
//
//  Created by Phu on 5/12/17.
//  Copyright © 2017 Phu. All rights reserved.
//

import UIKit

class AddController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: *** UI ELement
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lableChoise: UILabel!
    
    // MARK: *** Data
    let list_vi = ["Từ", "Cụm từ", "Thành ngữ"]
    let list_en = ["Word", "Phrase", "Idioms"]
    let list_icon = ["vocabulary-29.png", "phrase-29.png", "idoms-29.png"]
    var language: String?
    
    // MARK: UI ViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        language = UserDefaults.standard.value(forKey: "App_Language") as? String
        
        if language == "vi" {
            self.navigationItem.title = ""
            self.lableChoise.text = "Chọn Loại Thêm"
        } else {
            self.navigationItem.title = ""
            self.lableChoise.text = "Choise Type Add"
        }

        
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
        tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: *** UI TableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return list_en.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddCellID", for: indexPath) as! AddCell
        
        language = UserDefaults.standard.value(forKey: "App_Language") as? String
        
        if language == "vi" {
            cell.textField.text = list_vi[indexPath.row]
            cell.icon.image = UIImage(named: list_icon[indexPath.row])
        } else {
            cell.textField.text = list_en[indexPath.row]
            cell.icon.image = UIImage(named: list_icon[indexPath.row])

        }
        cell.contentView.backgroundColor = UIColor.white
        //cell.textField.textColor = UIColor.red
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedCell = tableView.cellForRow(at: indexPath)!
        selectedCell.contentView.backgroundColor = UIColor(red: 216/255, green: 216/255, blue: 216/255, alpha: 1)
        //selectedCell.textField.textColor = UIColor.white
        
        
        if indexPath.row == 0 {
            performSegue(withIdentifier: "SegueAddWordID", sender: nil)
        } else if indexPath.row == 1 {
            performSegue(withIdentifier: "SegueAddPhraseID", sender: nil)
        } else if indexPath.row == 2 {
            performSegue(withIdentifier: "SegueAddIdiomsID", sender: nil)
        }

    }
    
}
