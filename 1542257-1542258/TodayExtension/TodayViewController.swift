 			//
//  TodayViewController.swift
//  TodayExtension
//
//  Created by Phu on 5/14/17.
//  Copyright © 2017 Phu. All rights reserved.
//

import UIKit
import NotificationCenter
import SQLite

class TodayViewController: UIViewController, NCWidgetProviding, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: *** UI Element
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: *** Data model
    var number = 3
    var time = 20
    var timer = Timer()
    var vocabularys = [DataTodayExtension]()
    var data = [DataTodayExtension]()
    var dem = 0
    var pathmain:String?
        
    override func viewDidLoad() {
        super.viewDidLoad()

        
        NotificationCenter.default.addObserver(self, selector: #selector(self.changeData), name: UserDefaults.didChangeNotification, object: nil)
        
        self.extensionContext?.widgetLargestAvailableDisplayMode = NCWidgetDisplayMode.expanded
        
        updateChange()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        
        completionHandler(NCUpdateResult.newData)
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        if activeDisplayMode == NCWidgetDisplayMode.compact {
            self.preferredContentSize = CGSize(width: maxSize.width, height: 66)
        } else {
            if number == 3 {
                self.preferredContentSize = CGSize(width: maxSize.width, height: 198)
            } else if number == 4 {
                self.preferredContentSize = CGSize(width: maxSize.width, height: 264)
            } else if number == 5 {
                self.preferredContentSize = CGSize(width: maxSize.width, height: 330)
            }
        }
    }
    
    
    // MARK: *** UITbableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vocabularys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodayCellID", for: indexPath) as! TodayCell
        cell.labelEnglish.text = vocabularys[indexPath.row].name_en
        cell.labelVietnamese.text = vocabularys[indexPath.row].name_vn
        
        return cell
    }
    
    
    func changeData() {
        
        updateChange()
        
    }
    
    func updateChange() {
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
            let defaults = UserDefaults(suiteName: "group.phu.it.TodayExtensionSharingDefaults")
            self.number = defaults?.value(forKey: "Today_Number") as! Int
            self.time = defaults?.value(forKey: "Today_Time") as! Int
            self.pathmain = defaults?.value(forKey: "Today_Data") as? String
            
            self.data = self.getAllVocabulary(path: self.pathmain!)
            
            DispatchQueue.main.sync {
                self.timer = Timer.scheduledTimer(timeInterval: TimeInterval(self.time * 60), target: self, selector: #selector(self.updateData), userInfo: nil, repeats: true)
                RunLoop.main.add(self.timer, forMode: .commonModes)
                
                self.vocabularys.removeAll()
                for _ in 0..<self.number {
                    if self.dem < self.data.count {
                        self.vocabularys.append(self.data[self.dem])
                        self.dem += 1
                    } else {
                        self.dem = 0
                        self.vocabularys.append(self.data[self.dem])
                    }
                }
                self.tableView.reloadData()
            }
        }
    }
    
    func updateData() {
        vocabularys.removeAll()
        for _ in 0..<number {
            if dem < data.count {
                vocabularys.append(data[dem])
                dem += 1
            } else {
                dem = 0
                vocabularys.append(data[dem])
            }
        }
    }
    
    func getAllVocabulary(path: String) -> [DataTodayExtension]{
        let db: Connection?
        var data = [DataTodayExtension]()
        do {
            db = try Connection("\(path)/data.sqlite")
            
        } catch {
            db = nil
            print("Unable to open database. Error: \(error)")
        }
        
        do {
            for vo in try db!.prepare("SELECT * FROM vocabulary WHERE status == 0") {
                let newdata = DataTodayExtension(name_en: vo[3] as! String, name_vn: vo[4] as! String)
                data.append(newdata)
            }
        } catch {
            print("errro")
        }
        return data
    }
}
