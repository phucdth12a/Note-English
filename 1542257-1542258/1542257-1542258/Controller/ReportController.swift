//
//  ReportController.swift
//  1542257-1542258
//
//  Created by Phu on 5/12/17.
//  Copyright © 2017 Phu. All rights reserved.
//

import UIKit

class ReportController: UIViewController {

    // MARK: *** UI Element
    @IBOutlet weak var buttonReport: UIButton!
    @IBOutlet var radioButtons: [AKRadioButton]!
    @IBOutlet weak var labelTittle: InsetLabel!
    @IBOutlet weak var labelChoiseType: UILabel!
    @IBOutlet weak var labelChoiseTime: UILabel!
    @IBOutlet weak var textFieldStartDate: UITextField!
    @IBOutlet weak var textFieldEndDate: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    let pickerStartDate = UIDatePicker()
    let pickerEndDate = UIDatePicker()
    
    // MARK: *** Data
    var language: String?
    var radioButtonController: AKRadioButtonsController!
    var dateFormatter = DateFormatter()
    
    // MARK: *** UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()

        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        self.navigationItem.title = ""
        
        buttonReport.layer.borderWidth = 1
        buttonReport.layer.cornerRadius = 6
        buttonReport.layer.borderColor = UIColor(colorLiteralRed: 230/255, green: 229/255, blue: 230/255, alpha: 1).cgColor
        
        self.radioButtonController = AKRadioButtonsController(radioButtons: self.radioButtons)
        
        createDatePicker(picker: pickerStartDate, textField: textFieldStartDate)
        createDatePicker(picker: pickerEndDate, textField: textFieldEndDate)
        
        textFieldStartDate.text = dateFormatter.string(from: Date())
        textFieldEndDate.text = dateFormatter.string(from: Date())
        
        // Dang ky xu ly su kien lien quan den ban phim
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SegueReportAllID" {
            let dest = segue.destination as! ReportAllController
            dest.startDate = textFieldStartDate.text
            dest.endDate = textFieldEndDate.text
        } else if segue.identifier == "SegueReportOneID" {
            let dest = segue.destination as! ReportOneController
            dest.startDate = textFieldStartDate.text
            dest.endDate = textFieldEndDate.text
            dest.cat_id = radioButtonController.selectedIndex
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
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        language = UserDefaults.standard.value(forKey: "App_Language") as? String
        
        if language == "vi" {
            
            // set title cho radio
            radioButtons[0].setTitle("Từ", for: .normal)
            radioButtons[1].setTitle("Cụm từ", for: .normal)
            radioButtons[2].setTitle("Thành ngữ", for: .normal)
            radioButtons[3].setTitle("Tất cả", for: .normal)
            
            labelTittle.text = "Chọn Loại Thống Kê"
            labelChoiseType.text = "Chọn loại"
            labelChoiseTime.text = "Chọn thời gian"
            
            buttonReport.setTitle("Xem thống kê", for: .normal)
            
        } else {
            
            // set title cho radio
            radioButtons[0].setTitle("Word", for: .normal)
            radioButtons[1].setTitle("Phrase", for: .normal)
            radioButtons[2].setTitle("Idioms", for: .normal)
            radioButtons[3].setTitle("All", for: .normal)
            
            labelTittle.text = "Choise Type Report"
            labelChoiseType.text = "Choise type"
            labelChoiseTime.text = "Choise time"
            
            buttonReport.setTitle("View report", for: .normal)
        }

        
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    @IBAction func buttonReport_clicked(_ sender: Any) {
        if radioButtonController.selectedIndex == 0 || radioButtonController.selectedIndex == 1 || radioButtonController.selectedIndex == 2 {
            performSegue(withIdentifier: "SegueReportOneID", sender: nil)
        } else if radioButtonController.selectedIndex == 3 {
            performSegue(withIdentifier: "SegueReportAllID", sender: nil)
        }
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
        textFieldStartDate.text = dateFormatter.string(from: pickerStartDate.date)
        textFieldEndDate.text = dateFormatter.string(from: pickerEndDate.date)
        self.view.endEditing(true)
    }


}
