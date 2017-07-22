//
//  AddPhraseController.swift
//  1542257-1542258
//
//  Created by Phu on 5/12/17.
//  Copyright © 2017 Phu. All rights reserved.
//

import UIKit

class AddPhraseController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: *** UI Element
    @IBOutlet weak var labelEnglish: UILabel!
    @IBOutlet weak var textFieldEnglish: UITextField!
    @IBOutlet weak var labelVietnamese: UILabel!
    @IBOutlet weak var textFieldVietnamese: UITextField!
    @IBOutlet weak var labelExample: UILabel!
    @IBOutlet weak var textViewExample: UITextView!
    @IBOutlet weak var labelImage: UILabel!
    @IBOutlet weak var imageViewImage: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    let pickerImage = UIImagePickerController()
    
    // MARK: *** Data model
    var language: String?
    var imageDirectoryPath: String?
    
    // MARK: *** UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()

        addDoneButton(tos: [textFieldEnglish, textFieldVietnamese])
        addDoneButton(textViewExample)
        textViewExample.text = ""
        textViewExample.layer.borderWidth = 1
        textViewExample.layer.borderColor = UIColor(colorLiteralRed: 230/255, green: 229/255, blue: 230/255, alpha: 1).cgColor
        textViewExample.layer.cornerRadius = 6
        textViewExample.layer.masksToBounds = false
        textViewExample.clipsToBounds = true
        
        pickerImage.delegate = self
        
        // nhan 2 lan de chon anh
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(loadImg(_:)))
        imageTap.numberOfTapsRequired = 2
        imageViewImage.isUserInteractionEnabled = true
        imageViewImage.addGestureRecognizer(imageTap)
        
        // Dang ky xu ly su kien lien quan den ban phim
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
        
        
        //let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(buttonAdd_clicked))
        let addButton = UIBarButtonItem(image: UIImage(named: "Save-50-29.png"), style: .done, target: self, action: #selector(buttonAdd_clicked))
        self.navigationItem.setRightBarButton(addButton, animated: true)
        
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        imageDirectoryPath = path.appending("/Image")
        
        let isExist = FileManager.default.fileExists(atPath: imageDirectoryPath!)
        
        if isExist == false {
            do {
                try FileManager.default.createDirectory(atPath: imageDirectoryPath!, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("Something went wrong while creating a new folder")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        language = UserDefaults.standard.value(forKey: "App_Language") as? String
        
        if language == "vi" {
            labelEnglish.text = "Tiếng anh"
            labelVietnamese.text = "Tiếng việt"
            labelExample.text = "Ví dụ"
            labelImage.text = "Hình ảnh"
            
            self.navigationItem.title = "Thêm Cụm Từ"
        } else {
            labelEnglish.text = "English"
            labelVietnamese.text = "Vietnamese"
            labelExample.text = "Example"
            labelImage.text = "Image"
            
            self.navigationItem.title = "New Phrase"
        }

    }
    
    // hien thi picker de chon hinh anh
    func loadImg(_ recognizer: UITapGestureRecognizer) {
        
        var titleCamera = "Use Camera"
        var titleLibrary = "Use Photo Library"
        var titleCancel = "Cancel"
        
        if language == "vi" {
            titleCamera = "Dùng Camera"
            titleLibrary = "Dùng Thư Viện Ảnh"
            titleCancel = "Hủy Bỏ"
        }
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: titleCamera, style: .default) { (action) in
            self.pickerImage.mediaTypes = UIImagePickerController.availableMediaTypes(for: .camera)!
            self.pickerImage.sourceType = .camera
            self.pickerImage.allowsEditing = false
            
            self.present(self.pickerImage, animated: true, completion: nil)
        }
        
        let photoLibraryAction = UIAlertAction(title: titleLibrary, style: .default) { (action) in
            self.pickerImage.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
            self.pickerImage.sourceType = .photoLibrary
            self.pickerImage.allowsEditing = false
            
            self.present(self.pickerImage, animated: true, completion: nil)
        }
        
        let cancelAction = UIAlertAction(title: titleCancel, style: .cancel, handler: nil)
        
        alertController.addAction(cameraAction)
        alertController.addAction(photoLibraryAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    var pickedImage: UIImage?
    var imagePath: String?
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            var path = NSDate().description
            path = path.replacingOccurrences(of: " ", with: "")
            path = path.replacingOccurrences(of: ":", with: "")
            path = path.replacingOccurrences(of: "-", with: "")
            path = path.replacingOccurrences(of: ".", with: "")
            path = path.replacingOccurrences(of: "/", with: "")
            path = path.replacingOccurrences(of: "\"", with: "")
            path = path.replacingOccurrences(of: "+", with: "")
            
            self.imagePath = path
            
            pickedImage = image
            self.imageViewImage.image = image
        }
        
        self.dismiss(animated: true, completion: nil)
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

    
    func buttonAdd_clicked() {
        
        if textFieldEnglish.isEmpty() {
            var titleError = "Error"
            var messageError = "English cannot be empty!"
            if language == "vi" {
                titleError = "Lỗi"
                messageError = "Tiếng anh không được để trống!"
            }
            alert(title: titleError, message: messageError)
        } else if textFieldVietnamese.isEmpty() {
            var titleError = "Error"
            var messageError = "Vietnamese cannot be empty!"
            if language == "vi" {
                titleError = "Lỗi"
                messageError = "Tiếng việt không được để trống!"
            }
            alert(title: titleError, message: messageError)
        } else {
            
            // di chuyen file den thu muc Image
            var image: String?
            if pickedImage != nil {
                image = "\(imagePath!).png"
                
                
                imagePath = imageDirectoryPath?.appending("/\(imagePath!).png")
                let data = UIImagePNGRepresentation(pickedImage!)
                _ = FileManager.default.createFile(atPath: imagePath!, contents: data, attributes: nil)
            }
            
            let date = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale.current
            dateFormatter.dateFormat = "YYYY-MM-dd"
            
            let dateCreated = dateFormatter.string(from: date)
            
            let id = DatabaseManagement.shared.addVocabulary(cat_id: 2, type_id: nil, name_en: textFieldEnglish.text!, name_vn: textFieldVietnamese.text!, pronunciation: nil, example: textViewExample.text, image: image, status: false, created: dateCreated)
            
            
            if id != nil {
                var titleSuccess = "Success"
                var mesageSuccess = "Add Phrase Success"
                if language == "vi" {
                    titleSuccess = "Thành công"
                    mesageSuccess = "Thêm cụm từ thành công"
                }
                
                // luu vao bang report
                _ = DatabaseManagement.shared.addOrUpdateReport(total_word_true: 0, total_word: 0, total_add_word: 0, total_learned_word: 0, total_phrase_true: 0, total_phrase: 0, total_add_phrase: 1, total_learned_phrase: 0, total_idioms_true: 0, total_idioms: 0, total_add_idioms: 0, total_learned_idioms: 0, created: dateCreated)
                
                
                alert(title: titleSuccess, message: mesageSuccess, handler: { (UIAlertAction) in
                    _ = self.navigationController?.popViewController(animated: true)
                })
            } else {
                var titleError = "Error"
                var messageError = "Add Word faild! Please try again later!"
                if language == "vi" {
                    titleError = "Lỗi"
                    messageError = "Thêm từ vựng thất bại! Vui lòng thử lại sau!"
                }
                
                alert(title: titleError, message: messageError, handler: { (UIAlertAction) in
                    _ = self.navigationController?.popViewController(animated: true)
                })
            }
            
        }
    }


}
