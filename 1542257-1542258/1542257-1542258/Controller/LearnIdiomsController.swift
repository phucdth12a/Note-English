
//
//  LearnIdiomsController.swift
//  1542257-1542258
//
//  Created by Phu on 5/13/17.
//  Copyright © 2017 Phu. All rights reserved.
//

import UIKit
import Canvas

protocol protocolEditIdiomsController {
    func editDone(newVocabulary: Vocabulary)
}


class LearnIdiomsController: UIViewController, protocolEditIdiomsController {

    // MARK: *** UI Element
    @IBOutlet weak var buttonNext: UIButton!
    @IBOutlet weak var buttonRemembered: UIButton!
    
    @IBOutlet weak var buttonPre: UIButton!
    
    @IBOutlet weak var labelEnglish: UILabel!
    @IBOutlet weak var labelVietNamese: UILabel!
    @IBOutlet var animationView: CSAnimationView!
    
    
    // MARK: *** Data model
    var language: String?
    var vocabularys = [Vocabulary]()
    var selectedIndex = 0
    
    // MARK: *** UI Event
    
    @IBAction func buttonNext_Click(_ sender: Any) {
        selectedIndex += 1
        animationView.type = "fadeInLeft"
        animationView.duration = 0.5
        animationView.delay = 0
        animationView.startCanvasAnimation()
        loadData(index: selectedIndex)
    }
    
    @IBAction func buttonPre_Click(_ sender: Any) {
        selectedIndex -= 1
        animationView.type = "fadeInRight"
        animationView.duration = 0.5
        animationView.delay = 0
        animationView.startCanvasAnimation()
        loadData(index: selectedIndex)
    }
    
    @IBAction func buttonRemembered_Click(_ sender: Any) {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "YYYY-MM-dd"
        
        let dateCreated = dateFormatter.string(from: date)
        
        if vocabularys[selectedIndex].status == true {
            vocabularys[selectedIndex].status = false
            if DatabaseManagement.shared.updateVocabularybyID(newVocabulary: vocabularys[selectedIndex]) {
                
                // cap nhat vao report
                _ = DatabaseManagement.shared.addOrUpdateReport(total_word_true: 0, total_word: 0, total_add_word: 0, total_learned_word: 0, total_phrase_true: 0, total_phrase: 0, total_add_phrase: 0, total_learned_phrase: 0, total_idioms_true: 0, total_idioms: 0, total_add_idioms: 0, total_learned_idioms: -1, created: dateCreated)
                
                buttonRemembered.setImage(UIImage(named: "dislike.png"), for: .normal)
            }
        } else {
            vocabularys[selectedIndex].status = true
            if DatabaseManagement.shared.updateVocabularybyID(newVocabulary: vocabularys[selectedIndex]) {
                
                // cap nhat vao report
                _ = DatabaseManagement.shared.addOrUpdateReport(total_word_true: 0, total_word: 0, total_add_word: 0, total_learned_word: 0, total_phrase_true: 0, total_phrase: 0,total_add_phrase: 0, total_learned_phrase: 0, total_idioms_true: 0, total_idioms: 0, total_add_idioms: 0, total_learned_idioms: 1, created: dateCreated)
                
                buttonRemembered.setImage(UIImage(named: "add_like.png"), for: .normal)
            }
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        language = UserDefaults.standard.value(forKey: "App_Language") as? String
        
        vocabularys = DatabaseManagement.shared.getAllVocabulary_Word(cat_id: 3)
        
        if vocabularys.count > 0 {
            loadData(index: selectedIndex)
        } else {
            var title = "Notification"
            var message = "No Idiom! Please add new idiom"
            
            if language == "vi" {
                title = "Thông báo"
                message = "Không có thành ngữ! Vui lòng thêm"
                
            }
            
            alert(title: title, message: message, handler: { (UIAlertAction) in
                _ = self.navigationController?.popViewController(animated: true)
            })
            
        }
        
        let editButton = UIBarButtonItem(image: UIImage(named: "Edit-50-29.png"), style: .done, target: self, action: #selector(buttonEdit_Clicked))
        let deleteButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(buttonDelete_Clicked))
        self.navigationItem.rightBarButtonItems = [editButton, deleteButton]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        language = UserDefaults.standard.value(forKey: "App_Language") as? String
        
        self.navigationItem.title = "Idioms"
        if language == "vi" {
            self.navigationItem.title = "Thành Ngữ"
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier=="SegueEditIdiomsID"{
            let dest = segue.destination as! EditIdiomsController
            dest.vocabulary = vocabularys[selectedIndex]
            dest.delegate = self
        }
    }
    
    func buttonEdit_Clicked() {
        performSegue(withIdentifier: "SegueEditIdiomsID", sender: nil)
    }
    
    func buttonDelete_Clicked() {
        var title = "Notification"
        var message = "Are you sure you want to delete?"
        var titleOk = "OK"
        var titleCancel = "Cancel"
        
        if self.language == "vi" {
            title = "Thông báo"
            message = "Bạn có chắc chắn muốn xoá?"
            titleOk = "Đồng ý"
            titleCancel = "Hủy bỏ"
        }
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: titleOk, style: .default) { (UIAlertAction) in
            if DatabaseManagement.shared.deleteVocabulary(id: self.vocabularys[self.selectedIndex].id) {
                
                self.vocabularys.remove(at: self.selectedIndex)
                if self.selectedIndex != 0 {
                    self.selectedIndex -= 1
                }
                
                if self.vocabularys.count > 0 {
                    self.loadData(index: self.selectedIndex)
                } else {
                    var title = "Notification"
                    var message = "No Idiom! Please add new idiom"
                    
                    if self.language == "vi" {
                        title = "Thông báo"
                        message = "Không có thành ngữ! Vui lòng thêm"
                        
                    }
                    
                    self.alert(title: title, message: message, handler: { (UIAlertAction) in
                        _ = self.navigationController?.popViewController(animated: true)
                    })

                }
            }
        }
        
        let cancelAction = UIAlertAction(title: titleCancel, style: .cancel, handler: nil)
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func loadData(index: Int) {
        
        buttonPre.isHidden = false
        buttonNext.isHidden = false
        
        labelEnglish.text = vocabularys[index].name_en
        labelVietNamese.text = vocabularys[index].name_vn
        
        
        if vocabularys[index].status == true {
            buttonRemembered.setImage(UIImage(named: "add_like.png"), for: .normal)
        } else {
            buttonRemembered.setImage(UIImage(named: "dislike.png"), for: .normal)
        }
        
        if index == 0 {
            buttonPre.isHidden = true
        }
        
        if index == vocabularys.count - 1 {
            buttonNext.isHidden = true
        }
    }
    
    // MARK: *** protocolEditIdiomController
    func editDone(newVocabulary: Vocabulary) {
        vocabularys[selectedIndex] = newVocabulary
        
        loadData(index: selectedIndex)
        
        
    }
    
//    func loadEditIdiomsController() {
//        performSegue(withIdentifier: "SegueEditIdiomsID", sender: nil)
//    }

}
