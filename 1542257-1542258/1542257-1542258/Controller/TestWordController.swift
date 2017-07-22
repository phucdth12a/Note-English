//
//  TestWordController.swift
//  1542257-1542258
//
//  Created by Phu on 5/13/17.
//  Copyright © 2017 Phu. All rights reserved.
//

import UIKit
import AVFoundation
import Canvas

class TestWordController: UIViewController {

    // MARK: *** UI Element
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelQuestion: UILabel!
    @IBOutlet weak var textFieldAnswer: UITextField!
    @IBOutlet weak var buttonCheck: UIButton!
    @IBOutlet weak var imageViewFailed1: UIImageView!
    @IBOutlet weak var imageViewFailed2: UIImageView!
    @IBOutlet weak var buttonSuggest: UIButton!
    @IBOutlet weak var labelSuggestPronunciation: UILabel!
    @IBOutlet weak var labelSuggestWExample: UILabel!
    @IBOutlet weak var labelCorrect: UILabel!
    @IBOutlet weak var labelTotal: UILabel!
    @IBOutlet weak var labelAnswered: UILabel!
    @IBOutlet weak var animationView: CSAnimationView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var buttonPreViewImage: UIButton!
    
    
    // MARK: *** UI Event
    @IBAction func buttonCheck_Clicked(_ sender: Any) {
        
        if mode == 1 { // english
            
            if textFieldAnswer.text?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() == vocabularys[selectedIndex].name_vn.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() {
                
                // play sound successfully
                let urlVoice = Bundle.main.url(forResource: "chinh_xac", withExtension: "m4a")!
                player = AVPlayer(url: urlVoice)
                player?.play()
                
                selectedIndex += 1
                answerdCorrect += 1
                answered += 1
                
                if selectedIndex == vocabularys.count { // da het cau hoi
                    
                    var title = "Notification"
                    var titleOK = "OK"
                    var message = "You have answered correctly \(answerdCorrect) out of \(vocabularys.count) words"
                    if language == "vi" {
                        title = "Thông báo"
                        message = "Bạn đã trả lời đúng \(answerdCorrect) trên \(vocabularys.count) từ"
                        titleOK = "Đồng ý"
                    }
                    
                    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                    
                    let okAction = UIAlertAction(title: titleOK, style: .default, handler: { (UIAlertAction) in
                        
                        _ = self.navigationController?.popViewController(animated: true)
                    })
                    
                    alertController.addAction(okAction)
                    
                    _ = DatabaseManagement.shared.addOrUpdateReport(total_word_true: answerdCorrect, total_word: vocabularys.count, total_add_word: 0, total_learned_word: 0, total_phrase_true: 0, total_phrase: 0, total_add_phrase: 0, total_learned_phrase: 0, total_idioms_true: 0, total_idioms: 0, total_add_idioms: 0, total_learned_idioms: 0, created: dateCreated!)
                    
                    present(alertController, animated: true, completion: nil)
                } else {
                    testWord(index: selectedIndex)
                }
                
            } else {
                if numberfailed == 2 { // da sai 3 lan
                    
                    
                    // play soud fail
                    let urlVoice = Bundle.main.url(forResource: "sai", withExtension: "m4a")!
                    player = AVPlayer(url: urlVoice)
                    player?.play()
                    
                    selectedIndex += 1
                    answered += 1
                    
                    if selectedIndex == vocabularys.count { // da het cau hoi
                        
                        var title = "Notification"
                        var titleOK = "OK"
                        var message = "You have answered correctly \(answerdCorrect) out of \(vocabularys.count) words"
                        if language == "vi" {
                            title = "Thông báo"
                            message = "Bạn đã trả lời đúng \(answerdCorrect) trên \(vocabularys.count) từ"
                            titleOK = "Đồng ý"
                        }
                        
                        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                        
                        let okAction = UIAlertAction(title: titleOK, style: .default, handler: { (UIAlertAction) in
                            
                            _ = self.navigationController?.popViewController(animated: true)
                        })
                        
                        alertController.addAction(okAction)
                        
                        _ = DatabaseManagement.shared.addOrUpdateReport(total_word_true: answerdCorrect, total_word: vocabularys.count, total_add_word: 0, total_learned_word: 0, total_phrase_true: 0, total_phrase: 0, total_add_phrase: 0, total_learned_phrase: 0, total_idioms_true: 0, total_idioms: 0, total_add_idioms: 0, total_learned_idioms: 0, created: dateCreated!)
                        
                        present(alertController, animated: true, completion: nil)
                    } else {
                        testWord(index: selectedIndex)
                    }
                    
                } else {
                    switch numberfailed {
                    case 0:
                        
                        // play sound fail
                        let urlVoice = Bundle.main.url(forResource: "sai", withExtension: "m4a")!
                        player = AVPlayer(url: urlVoice)
                        player?.play()

                        numberfailed += 1
                        imageViewFailed1.image = UIImage(named: "failed-29.png")
                        
                        break
                    case 1:
                        
                        // play sound fail
                        let urlVoice = Bundle.main.url(forResource: "sai", withExtension: "m4a")!
                        player = AVPlayer(url: urlVoice)
                        player?.play()
                        
                        numberfailed += 1
                        imageViewFailed2.image = UIImage(named: "failed-29.png")
                        
                        break
                    default:
                        print("error")
                        break
                    }
                }
            }
            
        } else if mode == 2 { // vietnamese
            if textFieldAnswer.text?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() == vocabularys[selectedIndex].name_en.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() {
                
                // play sound successfully
                let urlVoice = Bundle.main.url(forResource: "chinh_xac", withExtension: "m4a")!
                player = AVPlayer(url: urlVoice)
                player?.play()
                
                selectedIndex += 1
                answerdCorrect += 1
                answered += 1
                
                if selectedIndex == vocabularys.count { // da het cau hoi
                    
                    var title = "Notification"
                    var titleOK = "OK"
                    var message = "You have answered correctly \(answerdCorrect) out of \(vocabularys.count) words"
                    if language == "vi" {
                        title = "Thông báo"
                        message = "Bạn đã trả lời đúng \(answerdCorrect) trên \(vocabularys.count) từ"
                        titleOK = "Đồng ý"
                    }
                    
                    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                    
                    let okAction = UIAlertAction(title: titleOK, style: .default, handler: { (UIAlertAction) in
                        
                        _ = self.navigationController?.popViewController(animated: true)
                    })
                    
                    alertController.addAction(okAction)
                    
                    _ = DatabaseManagement.shared.addOrUpdateReport(total_word_true: answerdCorrect, total_word: vocabularys.count, total_add_word: 0, total_learned_word: 0, total_phrase_true: 0, total_phrase: 0, total_add_phrase: 0, total_learned_phrase: 0, total_idioms_true: 0, total_idioms: 0, total_add_idioms: 0, total_learned_idioms: 0, created: dateCreated!)
                    
                    present(alertController, animated: true, completion: nil)
                } else {
                    testWord(index: selectedIndex)
                }
                
            } else {
                if numberfailed == 2 { // da sai 3 lan
                    
                    // play soud fail
                    let urlVoice = Bundle.main.url(forResource: "sai", withExtension: "m4a")!
                    player = AVPlayer(url: urlVoice)
                    player?.play()

                    
                    selectedIndex += 1
                    answered += 1
                    
                    if selectedIndex == vocabularys.count { // da het cau hoi
                        
                        var title = "Notification"
                        var titleOK = "OK"
                        var message = "You have answered correctly \(answerdCorrect) out of \(vocabularys.count) words"
                        if language == "vi" {
                            title = "Thông báo"
                            message = "Bạn đã trả lời đúng \(answerdCorrect) trên \(vocabularys.count) từ"
                            titleOK = "Đồng ý"
                        }
                        
                        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                        
                        let okAction = UIAlertAction(title: titleOK, style: .default, handler: { (UIAlertAction) in
                            
                            _ = self.navigationController?.popViewController(animated: true)
                        })
                        
                        alertController.addAction(okAction)
                        
                        _ = DatabaseManagement.shared.addOrUpdateReport(total_word_true: answerdCorrect, total_word: vocabularys.count, total_add_word: 0, total_learned_word: 0, total_phrase_true: 0, total_phrase: 0, total_add_phrase: 0, total_learned_phrase: 0, total_idioms_true: 0, total_idioms: 0, total_add_idioms: 0, total_learned_idioms: 0, created: dateCreated!)
                        
                        present(alertController, animated: true, completion: nil)
                    } else {
                        testWord(index: selectedIndex)
                    }
                    
                } else {
                    switch numberfailed {
                    case 0:
                        
                        // play sound fail
                        let urlVoice = Bundle.main.url(forResource: "sai", withExtension: "m4a")!
                        player = AVPlayer(url: urlVoice)
                        player?.play()

                        numberfailed += 1
                        imageViewFailed1.image = UIImage(named: "failed-29.png")
                        
                        break
                    case 1:
                        
                        // play sound fail
                        let urlVoice = Bundle.main.url(forResource: "sai", withExtension: "m4a")!
                        player = AVPlayer(url: urlVoice)
                        player?.play()
                        
                        numberfailed += 1
                        imageViewFailed2.image = UIImage(named: "failed-29.png")
                        
                        break
                    default:
                        print("error")
                        break
                    }
                }
            }
        }
        
    }
    
    @IBAction func buttonSuggest_Clicked(_ sender: Any) {
        UIView.animate(withDuration: 0.5, animations: {
            self.labelSuggestPronunciation.isHidden = false
            self.labelSuggestWExample.isHidden = false
            
            if self.vocabularys[self.selectedIndex].image != nil && self.vocabularys[self.selectedIndex].image != "" {
                self.buttonPreViewImage.isHidden = false
            }
        })
    }
    
    @IBAction func buttonPreviewImage_Clicked(_ sender: Any) {
        performSegue(withIdentifier: "SeguePreviewImage", sender: nil)
    }
    
    // MARK: *** Data model
    var vocabularys = [Vocabulary]()
    var startDate: String?
    var endDate: String?
    var language: String?
    var answered = 0
    var answerdCorrect = 0
    var selectedIndex = 0
    var numberfailed = 0
    var mode = 0 // 1: english - vietnamese, 2: vietnam - english
    var player: AVPlayer?
    var dateCreated:String?
    
    // MARK: UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        language = UserDefaults.standard.value(forKey: "App_Language") as? String
        
        let arrStartDate = startDate?.components(separatedBy: "/")
        let stringStartDate = "\((arrStartDate?[2])!)-\((arrStartDate?[1])!)-\((arrStartDate?[0])!)"
        
        let arrEndDate = endDate?.components(separatedBy: "/")
        let stringEndDate = "\((arrEndDate?[2])!)-\((arrEndDate?[1])!)-\((arrEndDate?[0])!)"
        
        addDoneButton(to: textFieldAnswer)
        labelDate.text = "\(startDate!) - \(endDate!)"
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "YYYY-MM-dd"
        
        dateCreated = dateFormatter.string(from: date)
        
        vocabularys = DatabaseManagement.shared.getVocabularyfoTest(startDate: stringStartDate, endDate: stringEndDate, status: false, cat_id: 1)
        
        
        buttonCheck.layer.borderWidth = 1
        buttonCheck.layer.cornerRadius = 6
        buttonCheck.layer.borderColor = UIColor(colorLiteralRed: 230/255, green: 229/255, blue: 230/255, alpha: 1).cgColor
        
        buttonSuggest.layer.borderWidth = 1
        buttonSuggest.layer.cornerRadius = 6
        buttonSuggest.layer.borderColor = UIColor(colorLiteralRed: 230/255, green: 229/255, blue: 230/255, alpha: 1).cgColor
        
        // Dang ky xu ly su kien lien quan den ban phim
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
        
        if vocabularys.count > 0 {
            
            if language == "vi" {
                labelTotal.text = "Tổng: \(vocabularys.count)"
            } else {
                labelTotal.text = "Total: \(vocabularys.count)"
            }
            
            vocabularys.shuffle()
            
            testWord(index: selectedIndex)
            
            
        } else {
            var title = "Notification"
            var message = "No Word! Please add new word"
            if language == "vi" {
                title = "Thông báo"
                message = "Không có từ vựng! Vui lòng thêm"
            }
            
            alert(title: title, message: message, handler: { (UIAlertAction) in
                _ = self.navigationController?.popViewController(animated: true)
            })

        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        language = UserDefaults.standard.value(forKey: "App_Language") as? String
        
        if language == "vi" {
            buttonCheck.setTitle("Kiểm tra", for: .normal)
            buttonSuggest.setTitle("Hiện gợi ý", for: .normal)
            self.navigationItem.title = "Từ"
            buttonPreViewImage.setTitle("Hình ảnh", for: .normal)
            
            labelAnswered.text = "Đã trả lời: \(answered)"
            labelCorrect.text = "Đúng: \(answerdCorrect)"
            labelTotal.text = "Tổng: \(vocabularys.count)"
        } else {
            buttonCheck.setTitle("Check", for: .normal)
            buttonSuggest.setTitle("Show suggest", for: .normal)
            self.navigationItem.title = "Word"
            buttonPreViewImage.setTitle("Image", for: .normal)
            
            labelAnswered.text = "Answered: \(answered)"
            labelCorrect.text = "Correct: \(answerdCorrect)"
            labelTotal.text = "Total: \(vocabularys.count)"
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SeguePreviewImage" {
            let dest = segue.destination as! PreviewImageController
            dest.image = vocabularys[selectedIndex].image
        }
    }
    
    func keyboardWillShow(_ notification: NSNotification) {
        
        // Lay thong tin ban phim
        var info = notification.userInfo!
        var keyboardFrame: CGRect = (info[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        // Thay doi content inset de scroll duoc
        var contentInset: UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height - (self.tabBarController?.tabBar.frame.size.height)!
        self.scrollView.contentInset = contentInset
        self.scrollView.scrollIndicatorInsets = contentInset
    }
    
    
    func keyboardWillHide(_ notificatio: NSNotification) {
        
        // Thay doi content inset de scroll duoc
        let contentInset: UIEdgeInsets = UIEdgeInsets.zero
        self.scrollView.contentInset = contentInset
        self.scrollView.scrollIndicatorInsets = contentInset
    }

    
    func testWord(index: Int) {
        
        animationView.type = "fadeInLeft"
        animationView.duration = 0.5
        animationView.delay = 0
        animationView.startCanvasAnimation()
        
        imageViewFailed1.image = nil
        imageViewFailed2.image = nil
        
        numberfailed = 0
        
        textFieldAnswer.text = ""
        labelSuggestPronunciation.text = ""
        labelSuggestWExample.text = ""
        
        labelSuggestPronunciation.isHidden = true
        labelSuggestWExample.isHidden = true
        buttonPreViewImage.isHidden = true
        
        if language == "vi" {
            labelAnswered.text = "Đã trả lời: \(answered)"
            labelCorrect.text = "Đúng: \(answerdCorrect)"
        } else {
            labelAnswered.text = "Answered: \(answered)"
            labelCorrect.text = "Correct: \(answerdCorrect)"
        }
        
        labelSuggestPronunciation.text = vocabularys[index].pronunciation
        labelSuggestWExample.text = vocabularys[index].example
        
        if mode == 1 { // english
            labelQuestion.text = vocabularys[index].name_en
        } else if mode == 2 {
            labelQuestion.text = vocabularys[index].name_vn
        }
    }
}
