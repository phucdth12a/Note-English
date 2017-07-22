//
//  ListEditPhraseController.swift
//  1542257-1542258
//
//  Created by Phu on 5/29/17.
//  Copyright © 2017 Phu. All rights reserved.
//

import UIKit

class ListEditPhraseController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

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
    var vocabulary: Vocabulary?
    var language: String?
    var imageDirectoryPath: String?
    var typeofWords = [TypeofWord]()
    
    var delegate: protocolListEditController?
    
    // MARK: *** UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        language = UserDefaults.standard.value(forKey: "App_Language") as? String
        
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
        
        let deleteButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(buttonDelete_Clicked))
        let saveButton = UIBarButtonItem(image: UIImage(named: "Save-50-29.png"), style: .done, target: self, action: #selector(buttonSave_Clicked))
        self.navigationItem.rightBarButtonItems = [saveButton, deleteButton]
        
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        imageDirectoryPath = path.appending("/Image")
        
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
            labelExample.text = "Ví dụ"
            labelImage.text = "Hình ảnh"
            
            self.navigationItem.title = "Sửa Cụm Từ"
        } else {
            labelEnglish.text = "English"
            labelVietnamese.text = "Vietnamese"
            labelExample.text = "Example"
            labelImage.text = "Image"
            
            self.navigationItem.title = "Edit Phrase"
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
            if DatabaseManagement.shared.deleteVocabulary(id: (self.vocabulary?.id)!) {
                
                // xoa image
                if self.vocabulary?.image != nil{
                    do {
                        try FileManager.default.removeItem(atPath: (self.imageDirectoryPath?.appending("/\(String(describing: (self.vocabulary?.image)!))"))!)
                    } catch {
                        print("Delete file fail. Error: \(error)")
                    }
                }
                
                self.delegate?.doneEdit()
                
                _ = self.navigationController?.popViewController(animated: true)
            }
        }
        
        let cancelAction = UIAlertAction(title: titleCancel, style: .cancel, handler: nil)
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
        
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
            vocabulary?.name_vn = textFieldVietnamese.text!
            vocabulary?.example = textViewExample.text
            
            if DatabaseManagement.shared.updateVocabularybyID(newVocabulary: vocabulary!) {
                var titleSuccess = "Success"
                var mesageSuccess = "Edit Phrase Success"
                if language == "vi" {
                    titleSuccess = "Thành công"
                    mesageSuccess = "Sửa cụm từ vựng thành công"
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
                
                delegate?.doneEdit()
                
                alert(title: titleSuccess, message: mesageSuccess, handler: { (UIAlertAction) in
                    _ = self.navigationController?.popViewController(animated: true)
                })
                
            } else {
                var titleError = "Error"
                var messageError = "Eidt Phrase faild! Please try again later!"
                if language == "vi" {
                    titleError = "Lỗi"
                    messageError = "Sửa cụm từ thất bại! Vui lòng thử lại sau!"
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
        if vocabulary?.image != nil {
            let imagePath = imageDirectoryPath?.appending("/\((vocabulary?.image)!)")
            self.imageViewImage.image = UIImage(contentsOfFile: imagePath!)
        } else {
            self.imageViewImage.image = UIImage(named: "default.jpg")
        }
        
        textFieldEnglish.text = vocabulary?.name_en
        textFieldVietnamese.text = vocabulary?.name_vn
        if vocabulary?.example != nil {
            textViewExample.text = vocabulary?.example
        } else {
            textViewExample.text = ""
        }
    }

}
