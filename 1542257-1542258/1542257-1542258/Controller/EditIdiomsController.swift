//
//  EditIdiomsController.swift
//  1542257-1542258
//
//  Created by Phu on 5/15/17.
//  Copyright © 2017 Phu. All rights reserved.
//

import UIKit

class EditIdiomsController: UIViewController, UINavigationControllerDelegate {

    // MARK: *** UI Element
    @IBOutlet weak var labelEnglish: UILabel!
    @IBOutlet weak var textViewEnglish: UITextView!
    @IBOutlet weak var labelVietnamese: UILabel!
    @IBOutlet weak var textViewVietnamese: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    // MARK: *** Data model
    var vocabulary: Vocabulary?
    var language: String?
    var typeofWords = [TypeofWord]()
    var delegate: protocolEditIdiomsController?
    
    // MARK: *** UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()

        language = UserDefaults.standard.value(forKey: "App_Language") as? String
        
        addDoneButton(textViewEnglish)
        addDoneButton(textViewVietnamese)
        
        // Dang ky xu ly su kien lien quan den ban phim
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
        
        let saveButton = UIBarButtonItem(image: UIImage(named: "Save-50-29.png"), style: .done, target: self, action: #selector(buttonSave_Clicked))
        self.navigationItem.rightBarButtonItem = saveButton
        
        textViewEnglish.layer.borderWidth = 1
        textViewEnglish.layer.borderColor = UIColor(colorLiteralRed: 230/255, green: 229/255, blue: 230/255, alpha: 1).cgColor
        textViewEnglish.layer.cornerRadius = 6
        textViewEnglish.layer.masksToBounds = false
        textViewEnglish.clipsToBounds = true
        
        textViewVietnamese.layer.borderWidth = 1
        textViewVietnamese.layer.borderColor = UIColor(colorLiteralRed: 230/255, green: 229/255, blue: 230/255, alpha: 1).cgColor
        textViewVietnamese.layer.cornerRadius = 6
        textViewVietnamese.layer.masksToBounds = false
        textViewVietnamese.clipsToBounds = true

        if vocabulary != nil {
            loadData()
        } else {
            var title = "Error"
            var message = "Some Wrong! Please try again"
            if language == "vi" {
                title = "Lỗi"
                message = "Đã có lỗi! Vui lòng thử lại"
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
            labelEnglish.text = "Tiếng anh"
            labelVietnamese.text = "Tiếng việt"
            
            self.navigationItem.title = "Sửa Thành ngữ"
        } else {
            labelEnglish.text = "English"
            labelVietnamese.text = "Vietnamese"
            
            self.navigationItem.title = "Edit Idioms"
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
    
    func buttonSave_Clicked() {
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
            vocabulary?.name_en = textViewEnglish.text!
            vocabulary?.name_vn = textViewVietnamese.text!
            //vocabulary?.example = textViewExample.text
            
            if DatabaseManagement.shared.updateVocabularybyID(newVocabulary: vocabulary!) {
                var titleSuccess = "Success"
                var mesageSuccess = "Edit Idiom Success"
                if language == "vi" {
                    titleSuccess = "Thành công"
                    mesageSuccess = "Sửa thành ngữ thành công"
                }
                
                delegate?.editDone(newVocabulary: vocabulary!)
                
                alert(title: titleSuccess, message: mesageSuccess, handler: { (UIAlertAction) in
                    _ = self.navigationController?.popViewController(animated: true)
                })
                
            } else {
                var titleError = "Error"
                var messageError = "Eidt Idiom faild! Please try again later!"
                if language == "vi" {
                    titleError = "Lỗi"
                    messageError = "Sửa thành ngữ thất bại! Vui lòng thử lại sau!"
                }
                
                alert(title: titleError, message: messageError, handler: { (UIAlertAction) in
                    _ = self.navigationController?.popViewController(animated: true)
                })
                
            }
        }
    }
    
    func loadData() {
        textViewEnglish.text = vocabulary?.name_en
        textViewVietnamese.text = vocabulary?.name_vn
    }
    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
