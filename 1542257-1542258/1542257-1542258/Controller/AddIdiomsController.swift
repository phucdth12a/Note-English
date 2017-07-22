//
//  AddIdiomsController.swift
//  1542257-1542258
//
//  Created by Phu on 5/12/17.
//  Copyright © 2017 Phu. All rights reserved.
//

import UIKit

class AddIdiomsController: UIViewController {
    
    // MARK: *** UI Element
    @IBOutlet weak var labelIdioms: UILabel!
    @IBOutlet weak var textViewEnglish: UITextView!
    @IBOutlet weak var labelVietnamese: UILabel!
    @IBOutlet weak var textViewVietnamese: UITextView!
    
    // MARK: *** Data model
    var language: String?
    
    // MARK: *** UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addDoneButton(textViewEnglish)
        addDoneButton(textViewVietnamese)
        
        let addButton = UIBarButtonItem(image: UIImage(named: "Save-50-29.png"), style: .done, target: self, action: #selector(buttonAdd_Clicked))
        self.navigationItem.setRightBarButton(addButton, animated: true)

        textViewEnglish.text = ""
        textViewEnglish.layer.borderWidth = 1
        textViewEnglish.layer.borderColor = UIColor(colorLiteralRed: 230/255, green: 229/255, blue: 230/255, alpha: 1).cgColor
        textViewEnglish.layer.cornerRadius = 6
        textViewEnglish.layer.masksToBounds = false
        textViewEnglish.clipsToBounds = true
        
        textViewVietnamese.text = ""
        textViewVietnamese.layer.borderWidth = 1
        textViewVietnamese.layer.borderColor = UIColor(colorLiteralRed: 230/255, green: 229/255, blue: 230/255, alpha: 1).cgColor
        textViewVietnamese.layer.cornerRadius = 6
        textViewVietnamese.layer.masksToBounds = false
        textViewVietnamese.clipsToBounds = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        language = UserDefaults.standard.value(forKey: "App_Language") as? String
        
        if language == "vi" {
            labelIdioms.text = "Tiếng anh"
            labelVietnamese.text = "Tiếng việt"
            
            self.navigationItem.title = "Thêm thành ngữ"
        } else {
            labelIdioms.text = "English"
            labelVietnamese.text = "Vietnamese"
            
            self.navigationItem.title = "Add idioms"
        }

    }
    
    func buttonAdd_Clicked() {
        if textViewEnglish.isEmpty() {
            var titleError = "Error"
            var messageError = "English cannot be empty!"
            if language == "vi" {
                titleError = "Lỗi"
                messageError = "Tiếng anh không được để trống!"
            }
            alert(title: titleError, message: messageError)
        } else if textViewVietnamese.isEmpty() {
            var titleError = "Error"
            var messageError = "Vietnamese cannot be empty!"
            if language == "vi" {
                titleError = "Lỗi"
                messageError = "Tiếng việt không được để trống!"
            }
            alert(title: titleError, message: messageError)
        } else {
            
            let date = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale.current
            dateFormatter.dateFormat = "YYYY-MM-dd"
            
            let dateCreated = dateFormatter.string(from: date)
            
            let id = DatabaseManagement.shared.addVocabulary(cat_id: 3, type_id: nil, name_en: textViewEnglish.text!, name_vn: textViewVietnamese.text!, pronunciation: nil, example: nil, image: nil, status: false, created: dateCreated)
            
            if id != nil {
                var titleSuccess = "Success"
                var mesageSuccess = "Add Idioms Success"
                if language == "vi" {
                    titleSuccess = "Thành công"
                    mesageSuccess = "Thêm thành ngữ thành công"
                }
                //luu vao bang report
                
                 _ = DatabaseManagement.shared.addOrUpdateReport(total_word_true: 0, total_word: 0, total_add_word: 0, total_learned_word: 0, total_phrase_true: 0, total_phrase: 0, total_add_phrase: 0, total_learned_phrase: 0, total_idioms_true: 0, total_idioms: 0, total_add_idioms: 1, total_learned_idioms: 0, created: dateCreated)
                
                
                alert(title: titleSuccess, message: mesageSuccess, handler: { (UIAlertAction) in
                    _ = self.navigationController?.popViewController(animated: true)
                })
            } else {
                var titleError = "Error"
                var messageError = "Add Idioms faild! Please try again later!"
                if language == "vi" {
                    titleError = "Lỗi"
                    messageError = "Thêm Thành ngữ thất bại! Vui lòng thử lại sau!"
                }
                
                alert(title: titleError, message: messageError, handler: { (UIAlertAction) in
                    _ = self.navigationController?.popViewController(animated: true)
                })
            }

        }
    }

}
