//
//  TestIdiomsController.swift
//  1542257-1542258
//
//  Created by Phu on 5/14/17.
//  Copyright © 2017 Phu. All rights reserved.
//

import UIKit
import AVFoundation
import Canvas

class TestIdiomsController: UIViewController {

    // MARK: *** UI Element
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelQuestion: UILabel!
    @IBOutlet weak var textViewAnswer: UITextView!
    @IBOutlet weak var buttonCheck: UIButton!
    @IBOutlet weak var imageViewFail1: UIImageView!
    @IBOutlet weak var imageViewFail2: UIImageView!
    @IBOutlet weak var labelCorrect: UILabel!
    @IBOutlet weak var labelTotal: UILabel!
    @IBOutlet weak var labelAnswered: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var animationView: CSAnimationView!
    
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
    
    // MARK: *** UI Event
    
    @IBAction func buttonCheck_Click(_ sender: Any) {
        
        if mode == 1 { // english
            
            if textViewAnswer.text?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() == vocabularys[selectedIndex].name_vn.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() {
                
                // play sound successfully
                let urlVoice = Bundle.main.url(forResource: "chinh_xac", withExtension: "m4a")!
                player = AVPlayer(url: urlVoice)
                player?.play()
                
                selectedIndex += 1
                answerdCorrect += 1
                answered += 1
                
                if selectedIndex == vocabularys.count {
                    // da het cau hoi
                    
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
                    
                    _ = DatabaseManagement.shared.addOrUpdateReport(total_word_true: 0, total_word: 0, total_add_word: 0, total_learned_word: 0, total_phrase_true: 0, total_phrase: 0, total_add_phrase: 0, total_learned_phrase: 0, total_idioms_true: answerdCorrect, total_idioms: vocabularys.count, total_add_idioms: 0, total_learned_idioms: 0, created: dateCreated!)
                    
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
                        
                        _ = DatabaseManagement.shared.addOrUpdateReport(total_word_true: 0, total_word: 0, total_add_word: 0, total_learned_word: 0, total_phrase_true: 0, total_phrase: 0, total_add_phrase: 0, total_learned_phrase: 0, total_idioms_true: answerdCorrect, total_idioms: vocabularys.count, total_add_idioms: 0, total_learned_idioms: 0, created: dateCreated!)
                        
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
                        imageViewFail1.image = UIImage(named: "failed-29.png")
                        
                        break
                    case 1:
                        
                        // play sound fail
                        let urlVoice = Bundle.main.url(forResource: "sai", withExtension: "m4a")!
                        player = AVPlayer(url: urlVoice)
                        player?.play()
                        
                        numberfailed += 1
                        imageViewFail2.image = UIImage(named: "failed-29.png")
                        
                        break
                    default:
                        print("error")
                        break
                    }
                }
            }
            
        } else if mode == 2 { // vietnamese
            if textViewAnswer.text?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() == vocabularys[selectedIndex].name_en.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() {
                
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
                    
                    _ = DatabaseManagement.shared.addOrUpdateReport(total_word_true: 0, total_word: 0, total_add_word: 0, total_learned_word: 0, total_phrase_true: 0, total_phrase: 0, total_add_phrase: 0, total_learned_phrase: 0, total_idioms_true: answerdCorrect, total_idioms: vocabularys.count, total_add_idioms: 0, total_learned_idioms: 0, created: dateCreated!)
                    
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
                        
                        _ = DatabaseManagement.shared.addOrUpdateReport(total_word_true: 0, total_word: 0, total_add_word: 0, total_learned_word: 0, total_phrase_true: 0, total_phrase: 0, total_add_phrase: 0, total_learned_phrase: 0, total_idioms_true: answerdCorrect, total_idioms: vocabularys.count, total_add_idioms: 0, total_learned_idioms: 0, created: dateCreated!)
                        
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
                        imageViewFail1.image = UIImage(named: "failed-29.png")
                        
                        break
                    case 1:
                        
                        // play sound fail
                        let urlVoice = Bundle.main.url(forResource: "sai", withExtension: "m4a")!
                        player = AVPlayer(url: urlVoice)
                        player?.play()
                        
                        numberfailed += 1
                        imageViewFail2.image = UIImage(named: "failed-29.png")
                        
                        break
                    default:
                        print("error")
                        break
                    }
                }
            }
        }
        
        
        
    }
    
    
    // MARK: *** UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        language = UserDefaults.standard.value(forKey: "App_Language") as? String
        
        addDoneButton(textViewAnswer)
        
        labelDate.text = "\(startDate!) - \(endDate!)"
        
        let arrStartDate = startDate?.components(separatedBy: "/")
        let stringStartDate = "\((arrStartDate?[2])!)-\((arrStartDate?[1])!)-\((arrStartDate?[0])!)"
        
        let arrEndDate = endDate?.components(separatedBy: "/")
        let stringEndDate = "\((arrEndDate?[2])!)-\((arrEndDate?[1])!)-\((arrEndDate?[0])!)"
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "YYYY-MM-dd"
        
        dateCreated = dateFormatter.string(from: date)
        
        
        vocabularys = DatabaseManagement.shared.getVocabularyfoTest(startDate: stringStartDate, endDate: stringEndDate, status: false, cat_id: 3)
        
        textViewAnswer.layer.borderWidth = 1
        textViewAnswer.layer.cornerRadius = 6
        textViewAnswer.layer.borderColor = UIColor(colorLiteralRed: 230/255, green: 229/255, blue: 230/255, alpha: 1).cgColor
        
        buttonCheck.layer.borderWidth = 1
        buttonCheck.layer.cornerRadius = 6
        buttonCheck.layer.borderColor = UIColor(colorLiteralRed: 230/255, green: 229/255, blue: 230/255, alpha: 1).cgColor
        
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
            var message = "No Idiom! Please add new word"
            if language == "vi" {
                title = "Thông báo"
                message = "Không có thành ngữ! Vui lòng thêm"
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
            self.navigationItem.title = "Thành ngữ"
            labelAnswered.text = "Đã trả lời: \(answered)"
            labelCorrect.text = "Đúng: \(answerdCorrect)"
            labelTotal.text = "Tổng: \(vocabularys.count)"
        } else {
            buttonCheck.setTitle("Check", for: .normal)
            self.navigationItem.title = "Idioms"
            labelAnswered.text = "Answered: \(answered)"
            labelCorrect.text = "Correct: \(answerdCorrect)"
            labelTotal.text = "Total: \(vocabularys.count)"
        }
    }

    func testWord(index: Int) {
        
        animationView.type = "fadeInLeft"
        animationView.duration = 0.5
        animationView.delay = 0
        animationView.startCanvasAnimation()
        
        imageViewFail1.image = nil
        imageViewFail2.image = nil
        
        numberfailed = 0
        
        textViewAnswer.text = ""
        
        if language == "vi" {
            labelAnswered.text = "Đã trả lời: \(answered)"
            labelCorrect.text = "Đúng: \(answerdCorrect)"
        } else {
            labelAnswered.text = "Answered: \(answered)"
            labelCorrect.text = "Correct: \(answerdCorrect)"
        }
        if mode == 1 { // english
            labelQuestion.text = vocabularys[index].name_en
        } else if mode == 2 {
            labelQuestion.text = vocabularys[index].name_vn
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
