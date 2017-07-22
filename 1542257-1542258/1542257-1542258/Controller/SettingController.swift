//
//  SettingController.swift
//  1542257-1542258
//
//  Created by Phu on 5/12/17.
//  Copyright © 2017 Phu. All rights reserved.
//

import UIKit

class SettingController: UIViewController {

    
    // MARK: *** UI Element
    @IBOutlet var radioButtonsLanguage: [AKRadioButton]!
    @IBOutlet var radioButtonsNumber: [AKRadioButton]!
    @IBOutlet var radioButtonsTime: [AKRadioButton]!
    @IBOutlet weak var labelTitle: InsetLabel!
    @IBOutlet weak var labelLanguage: UILabel!
    @IBOutlet weak var labelShowWidget: UILabel!
    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var buttonSave: UIButton!
    
    
    // MARK: *** UI Event
    @IBAction func buttonSave_Clicked(_ sender: Any) {
        
        var number = 3
        var time = 20
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        
        if radioButtonLanguageController.selectedIndex == 1 {
            UserDefaults.standard.set("vi", forKey: "App_Language")
        } else if radioButtonLanguageController.selectedIndex == 0 {
            UserDefaults.standard.set("en", forKey: "App_Language")
        }
        
        if radioButtonNumberController.selectedIndex == 0 {
            UserDefaults.standard.set(3, forKey: "App_Number_Word_Display")
            number = 3
        } else if radioButtonNumberController.selectedIndex == 1 {
            UserDefaults.standard.set(4, forKey: "App_Number_Word_Display")
            number = 4
        } else if radioButtonNumberController.selectedIndex == 2 {
            UserDefaults.standard.set(5, forKey: "App_Number_Word_Display")
            number = 5
        }
        
        if radioButtonTimeController.selectedIndex == 0 {
            UserDefaults.standard.set(20, forKey: "App_Time_Change_Display")
            time = 20
        } else if radioButtonTimeController.selectedIndex == 1 {
            UserDefaults.standard.set(40, forKey: "App_Time_Change_Display")
            time = 40
        } else if radioButtonTimeController.selectedIndex == 2 {
            UserDefaults.standard.set(60, forKey: "App_Time_Change_Display")
            time = 60
        }
        
        let defaults = UserDefaults(suiteName: "group.phu.it.TodayExtensionSharingDefaults")
        defaults?.set(number, forKey: "Today_Number")
        defaults?.set(time, forKey: "Today_Time")
        defaults?.set(path, forKey: "Today_Data")
        
        defaults?.synchronize()
        
        language = UserDefaults.standard.value(forKey: "App_Language") as? String
        
        let tabBar_vi = ["Danh sách", "Thêm", "Học", "Kiểm tra", "Thêm"]
        let tabBar_en = ["List", "Add", "Learn", "Test", "More"]
        
        let menuItem = self.tabBarController?.tabBar.items
        
        for i in 0..<5 {
            if language == "vi" {
                menuItem?[i].title = tabBar_vi[i]
            } else {
                menuItem?[i].title = tabBar_en[i]
            }
        }

        
   
        var title = "Notification"
        var message = "Setting successfully"
        var titleOk = "OK"
        
        if language == "en" {
            title = "Thông báo"
            message = "Cài đặt thành công"
            titleOk = "Đồng ý"
        }
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: titleOk, style: .default) { (UIAlertAction) in
            self.viewDidLoad()
        }
        
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: *** Data model
    var language: String?
    var radioButtonLanguageController: AKRadioButtonsController!
    var radioButtonNumberController: AKRadioButtonsController!
    var radioButtonTimeController: AKRadioButtonsController!
    
    // MẢK: *** UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        language = UserDefaults.standard.value(forKey: "App_Language") as? String
        
        self.radioButtonLanguageController = AKRadioButtonsController(radioButtons: self.radioButtonsLanguage)
        self.radioButtonNumberController = AKRadioButtonsController(radioButtons: self.radioButtonsNumber)
        self.radioButtonTimeController = AKRadioButtonsController(radioButtons: self.radioButtonsTime)
        
        if language == "vi" {
            labelTitle.text = "Cài Đặt"
            labelLanguage.text = "Ngôn ngữ"
            labelShowWidget.text = "Số từ hiển thị ngoài widget"
            labelTime.text = "Thời gian thay đổi (phút)"
            
            buttonSave.setTitle("Lưu", for: .normal)
            radioButtonLanguageController.select(sender: radioButtonsLanguage[1])
        } else {
            labelTitle.text = "Setting"
            labelLanguage.text = "Language"
            labelShowWidget.text = "Words displayed outside the widget"
            labelTime.text = "Time change (minutes)"
            
            buttonSave.setTitle("Save", for: .normal)
            radioButtonLanguageController.select(sender: radioButtonsLanguage[0])
        }
        
        if let number_show = UserDefaults.standard.value(forKey: "App_Number_Word_Display") as? Int {
            if number_show == 3 {
                radioButtonNumberController.select(sender: radioButtonsNumber[0])
            } else if number_show == 4 {
                radioButtonNumberController.select(sender: radioButtonsNumber[1])
            } else if number_show == 5 {
                radioButtonNumberController.select(sender: radioButtonsNumber[2])
            }
        }
        
        if let time_change = UserDefaults.standard.value(forKey: "App_Time_Change_Display") as? Int {
            if time_change == 20 {
                radioButtonTimeController.select(sender: radioButtonsTime[0])
            } else if time_change == 40 {
                radioButtonTimeController.select(sender: radioButtonsTime[1])
            } else if time_change == 60 {
                radioButtonTimeController.select(sender: radioButtonsTime[2])
            }
        }
        
        buttonSave.layer.borderWidth = 1
        buttonSave.layer.cornerRadius = 6
        buttonSave.layer.borderColor = UIColor(colorLiteralRed: 230/255, green: 229/255, blue: 230/255, alpha: 1).cgColor
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }


}
