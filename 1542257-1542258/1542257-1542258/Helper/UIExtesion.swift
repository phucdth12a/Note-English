//
//  UIExtesion.swift
//  InspiringQuotes
//
//  Created by dev7 on 12/16/16.
//  Copyright © 2016 dev7lab. All rights reserved.
//

import UIKit

extension UIViewController {
    
    // Hiển thị thông báo đơn giản
    func alert(title: String, message: String) {
        var titleOk = "Ok"
        let language = UserDefaults.standard.value(forKey: "App_Language") as! String
        if language == "vi" {
            titleOk = "Đồng ý"
        }
        
        let okAction = UIAlertAction(title: titleOk, style: .default, handler: nil)
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    // Hiện thông báo xong làm gì đó
    func alert(title: String, message: String, handler: @escaping (UIAlertAction) -> Void ) {
        var titleOk = "Ok"
        let language = UserDefaults.standard.value(forKey: "App_Language") as! String
        if language == "vi" {
            titleOk = "Đồng ý"
        }
        
        let okAction = UIAlertAction(title: titleOk, style: .default, handler: handler)
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    // Thêm nút Done để ẩn đi bàn phím
    func addDoneButton(to control: UITextField){
        var titleDone = "Done"
        let language = UserDefaults.standard.value(forKey: "App_Language") as! String
        if language == "vi" {
            titleDone = "Hoàn tất"
        }
        
        let toolbar = UIToolbar()
        toolbar.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: titleDone, style: .done, target: control,
                            action: #selector(UITextField.resignFirstResponder))
        ]
        
        toolbar.sizeToFit()
        control.inputAccessoryView = toolbar
    }
    
    func addDoneButton(_ textview: UITextView){
        var titleDone = "Done"
        let language = UserDefaults.standard.value(forKey: "App_Language") as! String
        if language == "vi" {
            titleDone = "Hoàn tất"
        }
        
        let toolbar = UIToolbar()
        toolbar.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: titleDone, style: .done, target: textview,
                            action: #selector(UITextField.resignFirstResponder))
        ]
        
        toolbar.sizeToFit()
        textview.inputAccessoryView = toolbar
    }
    
    func addDoneButton(tos controls: [UITextField]){
        var titleDone = "Done"
        let language = UserDefaults.standard.value(forKey: "App_Language") as! String
        if language == "vi" {
            titleDone = "Hoàn tất"
        }
        
        for control in controls {
            let toolbar = UIToolbar()
            toolbar.items = [
                UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
                UIBarButtonItem(title: titleDone, style: .done, target: control,
                                action: #selector(UITextField.resignFirstResponder))
            ]
            
            toolbar.sizeToFit()
            control.inputAccessoryView = toolbar
        }
    }
}

extension UITextField {
    func isEmpty() -> Bool {
        return self.text?.characters.count == 0
    }
}

extension UITextView {
    func isEmpty() -> Bool {
        return self.text?.characters.count == 0
    }
}
