//
//  EditWordController.swift
//  1542257-1542258
//
//  Created by Phu on 5/15/17.
//  Copyright © 2017 Phu. All rights reserved.
//

import UIKit

class EditWordController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    // MARK: *** UI Element
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var labelEnglish: UILabel!
    @IBOutlet weak var textFieldEnglish: UITextField!
    @IBOutlet weak var labelPronunciation: UILabel!
    @IBOutlet weak var textFiledPronunciation: UITextField!
    @IBOutlet weak var labelTypeOfWord: UILabel!
    @IBOutlet weak var textFieldTypeOfWord: UITextField!
    @IBOutlet weak var labelVietNamese: UILabel!
    @IBOutlet weak var textFieldVietNamese: UITextField!
    @IBOutlet weak var labelExample: UILabel!
    @IBOutlet weak var textViewExample: UITextView!
    @IBOutlet weak var labelImage: UILabel!
    @IBOutlet weak var imageViewImage: UIImageView!
    
    let pickerViewTypeofWord = UIPickerView()
    let pickerImage = UIImagePickerController()
    
    // MARK: *** Data model
    var vocabulary: Vocabulary?
    var language: String?
    var imageDirectoryPath: String?
    var typeofWords = [TypeofWord]()
    
    var delegate: protocolEditWordController?
    
    // MARK: *** UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()

        language = UserDefaults.standard.value(forKey: "App_Language") as? String
        
        typeofWords = DatabaseManagement.shared.getAllTypeofWord()
        
        addDoneButton(tos: [textFieldEnglish, textFiledPronunciation, textFieldTypeOfWord, textFieldVietNamese])
        addDoneButton(textViewExample)
        textViewExample.text = ""
        textViewExample.layer.borderWidth = 1
        textViewExample.layer.borderColor = UIColor(colorLiteralRed: 230/255, green: 229/255, blue: 230/255, alpha: 1).cgColor
        textViewExample.layer.cornerRadius = 6
        textViewExample.layer.masksToBounds = false
        textViewExample.clipsToBounds = true
        
        pickerViewTypeofWord.delegate = self
        pickerViewTypeofWord.dataSource = self
        textFieldTypeOfWord.inputView = pickerViewTypeofWord
        
        pickerImage.delegate = self
        
        // nhan 2 lan de chon anh
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(loadImg(_:)))
        imageTap.numberOfTapsRequired = 2
        imageViewImage.isUserInteractionEnabled = true
        imageViewImage.addGestureRecognizer(imageTap)
        
        // Dang ky xu ly su kien lien quan den ban phim
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
        
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        imageDirectoryPath = path.appending("/Image")
        
        //let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(buttonSave_Clicked))
        let saveButton = UIBarButtonItem(image: UIImage(named: "Save-50-29.png"), style: .done, target: self, action: #selector(buttonSave_Clicked))
        self.navigationItem.rightBarButtonItem = saveButton
        
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
            labelPronunciation.text = "Phát âm"
            labelTypeOfWord.text = "Loại từ"
            labelVietNamese.text = "Tiếng việt"
            labelExample.text = "Ví dụ"
            labelImage.text = "Hình ảnh"
            
            self.navigationItem.title = "Sửa Từ Vựng"
            
        } else {
            labelEnglish.text = "English"
            labelPronunciation.text = "Pronunciation"
            labelTypeOfWord.text = "Type of Word"
            labelVietNamese.text = "Vietnamese"
            labelExample.text = "Example"
            labelImage.text = "Image"
            
            self.navigationItem.title = "Edit Word"
            
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
        contentInset.bottom = keyboardFrame.size.height + (self.tabBarController?.tabBar.frame.size.height)!
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
        if textFieldEnglish.isEmpty() {
            var titleError = "Error"
            var messageError = "English cannot be empty!"
            if language == "vi" {
                titleError = "Lỗi"
                messageError = "Tiếng anh không được để trống!"
            }
            alert(title: titleError, message: messageError)
        } else if textFieldVietNamese.isEmpty() {
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
            
            // hinh cu
            let oldimage = vocabulary?.image
            if pickedImage != nil {
                image = "\(imagePath!).png"
                
                
                imagePath = imageDirectoryPath?.appending("/\(imagePath!).png")
                let data = UIImagePNGRepresentation(pickedImage!)
                _ = FileManager.default.createFile(atPath: imagePath!, contents: data, attributes: nil)
                
                // hinh moi
                vocabulary?.image = image
                
            }
            
            vocabulary?.name_en = textFieldEnglish.text!
            vocabulary?.pronunciation = textFiledPronunciation.text
            vocabulary?.type_id = selectedTypeofWord?.id
            vocabulary?.name_vn = textFieldVietNamese.text!
            vocabulary?.example = textViewExample.text
            
            if DatabaseManagement.shared.updateVocabularybyID(newVocabulary: vocabulary!) {
                var titleSuccess = "Success"
                var mesageSuccess = "Edit Word Success"
                if language == "vi" {
                    titleSuccess = "Thành công"
                    mesageSuccess = "Sửa từ vựng thành công"
                }
                
                // xoa file hinh cu
                if oldimage != nil && pickedImage != nil {
                    do {
                        try FileManager.default.removeItem(atPath: (imageDirectoryPath?.appending("/\(String(describing: oldimage!))"))!)
                        vocabulary?.image = image
                    } catch {
                        print("Delete file fail. Error: \(error)")
                    }
                }
                
                delegate?.editDone(newVocabulary: vocabulary!)
                
                alert(title: titleSuccess, message: mesageSuccess, handler: { (UIAlertAction) in
                    _ = self.navigationController?.popViewController(animated: true)
                })

            } else {
                var titleError = "Error"
                var messageError = "Eidt Word faild! Please try again later!"
                if language == "vi" {
                    titleError = "Lỗi"
                    messageError = "Sửa từ vựng thất bại! Vui lòng thử lại sau!"
                }
                
                // xoa file hinh moi
                if pickedImage != nil {
                    do {
                        try FileManager.default.removeItem(atPath: (imageDirectoryPath?.appending("/\(String(describing: image!)))"))!)
                        vocabulary?.image = image
                    } catch {
                        print("Delete file fail. Erro: \(error)")
                    }

                }
               
                alert(title: titleError, message: messageError, handler: { (UIAlertAction) in
                    _ = self.navigationController?.popViewController(animated: true)
                })

            }
        }
    }
    
    func loadData() {
        
        let selected = typeofWords.filter({ (type) -> Bool in
            if type.id == vocabulary?.type_id {
                return true
            } else {
                return false
            }
        })
        
        selectedTypeofWord = selected[0]
        
        if language == "vi" {
            textFieldTypeOfWord.text = selectedTypeofWord?.name_vn
        } else {
            textFieldTypeOfWord.text = selectedTypeofWord?.name_en
        }
        
        if vocabulary?.image != nil {
            let imagePath = imageDirectoryPath?.appending("/\((vocabulary?.image)!)")
            self.imageViewImage.image = UIImage(contentsOfFile: imagePath!)
        } else {
            self.imageViewImage.image = UIImage(named: "default.jpg")
        }
        
        textFieldEnglish.text = vocabulary?.name_en
        if vocabulary?.pronunciation != nil {
            textFiledPronunciation.text = vocabulary?.pronunciation
        } else {
            textFiledPronunciation.text = ""
        }
        
        textFieldVietNamese.text = vocabulary?.name_vn
        
        if vocabulary?.example != nil {
            textViewExample.text = vocabulary?.example
        } else {
            textViewExample.text = ""
        }
    }
    
    // MARK: *** UIPickerView
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return typeofWords.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if language == "vi" {
            return typeofWords[row].name_vn
        } else {
            return typeofWords[row].name_en
        }
    }
    
    var selectedTypeofWord: TypeofWord?
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if language == "vi" {
            textFieldTypeOfWord.text = typeofWords[row].name_vn
            selectedTypeofWord = typeofWords[row]
        } else {
            textFieldTypeOfWord.text = typeofWords[row].name_en
            selectedTypeofWord = typeofWords[row]
        }
        
        self.view.endEditing(true)
    }

}
