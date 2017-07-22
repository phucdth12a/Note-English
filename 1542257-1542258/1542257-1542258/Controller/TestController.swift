//
//  TestController.swift
//  1542257-1542258
//
//  Created by Phu on 5/12/17.
//  Copyright © 2017 Phu. All rights reserved.
//

import UIKit

class TestController: UIViewController {
    
    
    // MARK: *** UI ELement
    @IBOutlet weak var labelTitle: InsetLabel!
    @IBOutlet weak var labelChoiseType: UILabel!
    @IBOutlet var radioButtons: [AKRadioButton]!
    @IBOutlet weak var labelChoiseAddCreate: UILabel!
    @IBOutlet weak var labelFromDate: UILabel!
    @IBOutlet weak var labelToDate: UILabel!
    @IBOutlet weak var textFieldFromDate: UITextField!
    @IBOutlet weak var textFieldToDate: UITextField!
    @IBOutlet weak var buttonTest: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    let pickerStartDate = UIDatePicker()
    let pickerEndDate = UIDatePicker()
    
    // MARK: *** Data
    var language: String?
    var radioButtonController: AKRadioButtonsController!
    var dateFormatter = DateFormatter()
    var mode = 0
    
    // MARK: *** UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "dd/MM/yyyy"

        buttonTest.layer.borderWidth = 1
        buttonTest.layer.cornerRadius = 6
        buttonTest.layer.borderColor = UIColor(colorLiteralRed: 230/255, green: 229/255, blue: 230/255, alpha: 1).cgColor
        
        
        textFieldFromDate.text = dateFormatter.string(from: Date())
        textFieldToDate.text = dateFormatter.string(from: Date())
        
        createDatePicker(picker: pickerStartDate, textField: textFieldFromDate)
        createDatePicker(picker: pickerEndDate, textField: textFieldToDate)
        
        self.radioButtonController = AKRadioButtonsController(radioButtons: self.radioButtons)
        
        // Dang ky xu ly su kien lien quan den ban phim
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
        
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SegueTestWordID" {
            let dest = segue.destination as! TestWordController
            dest.startDate = textFieldFromDate.text
            dest.endDate = textFieldToDate.text
            dest.mode = self.mode
        } else if segue.identifier == "SegueTestPhraseID" {
            let dest = segue.destination as! TestPhraseController
            dest.startDate = textFieldFromDate.text
            dest.endDate = textFieldToDate.text
            dest.mode = self.mode
        } else if segue.identifier == "SegueTestIdiomsID" {
            let dest = segue.destination as! TestIdiomsController
            dest.startDate = textFieldFromDate.text
            dest.endDate = textFieldToDate.text
            dest.mode = self.mode
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        language = UserDefaults.standard.value(forKey: "App_Language") as? String
        
        if language == "vi" {
            self.navigationItem.title = ""
            
            // set title cho radio
            radioButtons[0].setTitle("Từ", for: .normal)
            radioButtons[1].setTitle("Cụm từ", for: .normal)
            radioButtons[2].setTitle("Thành ngữ", for: .normal)
            
            labelChoiseType.text = "Chọn loại"
            labelChoiseAddCreate.text = "Chọn thời gian nạp"
            labelFromDate.text = "Từ ngày"
            labelToDate.text = "Đến ngày"
            
            labelTitle.text = "Chọn Loại Kiểm Tra"
            buttonTest.setTitle("Kiểm tra", for: .normal)
            
        } else {
            self.navigationItem.title = ""
            
            // set title cho radio
            radioButtons[0].setTitle("Word", for: .normal)
            radioButtons[1].setTitle("Phrase", for: .normal)
            radioButtons[2].setTitle("Idioms", for: .normal)
            
            labelChoiseType.text = "Choise type"
            labelChoiseAddCreate.text = "Select date of loading"
            labelFromDate.text = "Start date"
            labelToDate.text = "End date"
            
            labelTitle.text = "Choise Type Test"
            buttonTest.setTitle("Test", for: .normal)
        }
        
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    @IBAction func buttonTest_clicked(_ sender: Any) {
        
        let alerController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let E_VAction = UIAlertAction(title: "English", style: .default) { (UIAlertAction) in
            self.mode = 1
            
            if self.radioButtonController.selectedIndex == 0 {
                self.performSegue(withIdentifier: "SegueTestWordID", sender: nil)
            } else if self.radioButtonController.selectedIndex == 1 {
                self.performSegue(withIdentifier: "SegueTestPhraseID", sender: nil)
            } else if self.radioButtonController.selectedIndex == 2 {
                self.performSegue(withIdentifier: "SegueTestIdiomsID", sender: nil)
            }
        }
        
        let V_EAction = UIAlertAction(title: "Vietnamese", style: .default) { (UIAlertAction) in
            self.mode = 2
            
            if self.radioButtonController.selectedIndex == 0 {
                self.performSegue(withIdentifier: "SegueTestWordID", sender: nil)
            } else if self.radioButtonController.selectedIndex == 1 {
                self.performSegue(withIdentifier: "SegueTestPhraseID", sender: nil)
            } else if self.radioButtonController.selectedIndex == 2 {
                self.performSegue(withIdentifier: "SegueTestIdiomsID", sender: nil)
            }
        }
        
        var titleCancel = "Cancel"
        
        if language == "vi" {
            titleCancel = "Hủy Bỏ"
        }

        let cancelAcion = UIAlertAction(title: titleCancel, style: .cancel, handler: nil)
        
        alerController.addAction(E_VAction)
        alerController.addAction(V_EAction)
        alerController.addAction(cancelAcion)
        
        present(alerController, animated: true, completion: nil)
        
    }
    
    // Tao DatePicker
    func createDatePicker(picker: UIDatePicker, textField: UITextField) {
        
        var title = "Done"
        if language == "vi" {
            title = "Hoàn tất"
        }
        
        picker.datePickerMode = .date
        
        let toolbar = UIToolbar()
        toolbar.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: title, style: .done, target: nil, action: #selector(donePressed))
        ]
        
        toolbar.sizeToFit()
        textField.inputAccessoryView = toolbar
        textField.inputView = picker
    }
    
    func donePressed() {
        textFieldFromDate.text = dateFormatter.string(from: pickerStartDate.date)
        textFieldToDate.text = dateFormatter.string(from: pickerEndDate.date)
        self.view.endEditing(true)
    }
}
