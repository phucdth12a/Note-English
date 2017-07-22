//
//  ListEnglishCell.swift
//  1542257-1542258
//
//  Created by Phu on 5/28/17.
//  Copyright © 2017 Phu. All rights reserved.
//

import UIKit

class ListEnglishCell: UITableViewCell {
    
    // MARK: *** UI Element
    @IBOutlet weak var labelEnglish: UILabel!
    @IBOutlet weak var labelVietnamese: UILabel!
    @IBOutlet weak var imageViewRemember: UIImageView!
    
    // MARK: *** Data model
    var language: String?
    var id: Int64?
    var status: Bool?
    var cat_id: Int64?
    var tableView: UITableView!
    var vocabylarys = [[Vocabulary]]()
    var section: Int?
    var row: Int?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateMenu() {
        language = UserDefaults.standard.value(forKey: "App_Language") as? String
        
        let menu = UIMenuController.shared
        
        if language == "vi" {
            let forgetItem = UIMenuItem(title: "Quên từ", action: #selector(forget(_:)))
            let learnedItem = UIMenuItem(title: "Đã thuộc", action: #selector(remembered(_:)))
            menu.menuItems = [forgetItem, learnedItem]
        } else {
            let forgetItem = UIMenuItem(title: "Forget", action: #selector(forget(_:)))
            let learnedItem = UIMenuItem(title: "Remembered", action: #selector(remembered(_:)))
            menu.menuItems = [forgetItem, learnedItem]
        }
        
        menu.update()
        menu.setMenuVisible(true, animated: true)
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func becomeFirstResponder() -> Bool {
        return true
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if status == false {
            return action == #selector(remembered(_:))
        } else {
            return action == #selector(forget(_:))
        }
    }
    
    
    
    func forget(_ sender: Any?) {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "YYYY-MM-dd"
        
        let dateCreated = dateFormatter.string(from: date)
        
        if DatabaseManagement.shared.updateVocabularyLearn(id: self.id!, status: false) {
            
            if self.cat_id == 1 { // word
                // cap nhat vao report
                _ = DatabaseManagement.shared.addOrUpdateReport(total_word_true: 0, total_word: 0, total_add_word: 0, total_learned_word: -1, total_phrase_true: 0, total_phrase: 0, total_add_phrase: 0, total_learned_phrase: 0, total_idioms_true: 0, total_idioms: 0, total_add_idioms: 0, total_learned_idioms: 0, created: dateCreated)
            } else if self.cat_id == 2 { // phrase
                // cap nhat vao report
                _ = DatabaseManagement.shared.addOrUpdateReport(total_word_true: 0, total_word: 0, total_add_word: 0, total_learned_word: 0, total_phrase_true: 0, total_phrase: 0, total_add_phrase: 0, total_learned_phrase: -1, total_idioms_true: 0, total_idioms: 0, total_add_idioms: 0, total_learned_idioms: 0, created: dateCreated)
            } else if self.cat_id == 3 { //idioms
                // cap nhat vao report
                _ = DatabaseManagement.shared.addOrUpdateReport(total_word_true: 0, total_word: 0, total_add_word: 0, total_learned_word: 0, total_phrase_true: 0, total_phrase: 0, total_add_phrase: 0, total_learned_phrase: 0, total_idioms_true: 0, total_idioms: 0, total_add_idioms: 0, total_learned_idioms: -1, created: dateCreated)
            }
            vocabylarys[self.section!][self.row!].status = false
            self.tableView.reloadData()
        } else {
            print("update fail")
        }
        
    }
    
    func remembered(_ sender: Any?) {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "YYYY-MM-dd"
        
        let dateCreated = dateFormatter.string(from: date)
        
        if DatabaseManagement.shared.updateVocabularyLearn(id: self.id!, status: true) {
            
            if self.cat_id == 1 { // word
                // cap nhat vao report
                _ = DatabaseManagement.shared.addOrUpdateReport(total_word_true: 0, total_word: 0, total_add_word: 0, total_learned_word: 1, total_phrase_true: 0, total_phrase: 0, total_add_phrase: 0, total_learned_phrase: 0, total_idioms_true: 0, total_idioms: 0, total_add_idioms: 0, total_learned_idioms: 0, created: dateCreated)
            } else if self.cat_id == 2 { // phrase
                // cap nhat vao report
                _ = DatabaseManagement.shared.addOrUpdateReport(total_word_true: 0, total_word: 0, total_add_word: 0, total_learned_word: 0, total_phrase_true: 0, total_phrase: 0, total_add_phrase: 0, total_learned_phrase: 1, total_idioms_true: 0, total_idioms: 0, total_add_idioms: 0, total_learned_idioms: 0, created: dateCreated)
            } else if self.cat_id == 3 { //idioms
                // cap nhat vao report
                _ = DatabaseManagement.shared.addOrUpdateReport(total_word_true: 0, total_word: 0, total_add_word: 0, total_learned_word: 0, total_phrase_true: 0, total_phrase: 0, total_add_phrase: 0, total_learned_phrase: 0, total_idioms_true: 0, total_idioms: 0, total_add_idioms: 0, total_learned_idioms: 1, created: dateCreated)
            }
            vocabylarys[self.section!][self.row!].status = true
            self.tableView.reloadData()
        } else {
            print("update fail")
        }
    }

}
