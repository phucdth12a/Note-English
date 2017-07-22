//
//  MainController.swift
//  1542257-1542258
//
//  Created by Phu on 5/12/17.
//  Copyright © 2017 Phu. All rights reserved.
//

import UIKit

class MainController: UITabBarController, UINavigationControllerDelegate {
    
    // MARK: *** Data
    let tabBar_vi = ["Danh sách", "Thêm", "Học", "Kiểm tra", "Thêm"]
    let tabBar_en = ["List", "Add", "Learn", "Test", "More"]
    
    var number = 3
    var time = 20

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setting tabBar
        self.tabBar.tintColor = .red
        
        
        
        self.customizableViewControllers = nil
        
        
        // kiem tra neu lan dau load app thi lay ngon ngu mac dinh trong may lam ngon ngu app
        let language = UserDefaults.standard.value(forKey: "App_Language")
        
        if language == nil {
            // chua co thi tao key "App_Language" va gan la ngon ngu hien tai cua may
            let pre = Locale.current.languageCode!
            // ngon ngu la tieng viet
            if pre == "vi" {
                UserDefaults.standard.set("vi", forKey: "App_Language")
                
                for i in 0..<5 {
                    self.tabBar.items?[i].title = tabBar_vi[i]
                }
            } else {
                // neu khong phai chon ngu ngu la English
                UserDefaults.standard.set("en", forKey: "App_Language")
                
                for i in 0..<5 {
                    self.tabBar.items?[i].title = tabBar_en[i]
                }
            }
        } else {
            // neu da chon ngon ngu 
            if language as! String == "vi" {
                
                for i in 0..<5 {
                    self.tabBar.items?[i].title = tabBar_vi[i]
                }
            } else {
                
                for i in 0..<5 {
                    self.tabBar.items?[i].title = tabBar_en[i]
                }
            }
        }
        
        let pathImage = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let imageDirectoryPath = pathImage.appending("/Image")
        
        let isExist = FileManager.default.fileExists(atPath: imageDirectoryPath)
        
        if isExist == false {
            do {
                try FileManager.default.createDirectory(atPath: imageDirectoryPath, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("Something went wrong while creating a new folder")
            }
        }

        
        
        // chọn số lượng từ hiển thị ngoài day extension 3,4,5 radio
        let number_word_display = UserDefaults.standard.value(forKey: "App_Number_Word_Display")
        if number_word_display == nil {
            UserDefaults.standard.set(3, forKey: "App_Number_Word_Display")
        } else {
            number = UserDefaults.standard.value(forKey: "App_Number_Word_Display") as! Int
        }
        // Chọn loại từ hiển thị radio
        let type_word_display = UserDefaults.standard.value(forKey: "App_Type_Word_Display")
        if type_word_display == nil {
            UserDefaults.standard.set(1, forKey: "App_Type_Word_Display")
        }
        // Chọn khoản thời gian để reset danh sách từ day extension radio 20 40 60
        let time_change_display = UserDefaults.standard.value(forKey: "App_Time_Change_Display")
        if time_change_display == nil {
            UserDefaults.standard.set(20, forKey: "App_Time_Change_Display")
        } else {
            time = UserDefaults.standard.value(forKey: "App_Time_Change_Display") as! Int
        }
        
        let defaults = UserDefaults(suiteName: "group.phu.it.TodayExtensionSharingDefaults")
        defaults?.set(number, forKey: "Today_Number")
        defaults?.set(time, forKey: "Today_Time")
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        defaults?.set(path, forKey: "Today_Data")
        
        defaults?.synchronize()
    }

}
