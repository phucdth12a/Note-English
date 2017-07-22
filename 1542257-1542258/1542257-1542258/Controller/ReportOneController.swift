//
//  ReportOneController.swift
//  1542257-1542258
//
//  Created by Phu on 5/14/17.
//  Copyright © 2017 Phu. All rights reserved.
//

import UIKit
import Charts

class ReportOneController: UIViewController {
    
    // MARK: *** UI Elemnt
    @IBOutlet weak var labelDateReport: UILabel!
    @IBOutlet weak var labelTotalAdd: UILabel!
    @IBOutlet weak var labelTotalLearned: UILabel!
    @IBOutlet weak var pieChart: PieChartView!
    
    // MARK: *** Data model
    var language: String?
    var startDate: String?
    var endDate: String?
    var reports = [Report]()
    var cat_id: Int?
    var totalAdded = 0.0
    var totalLearned = 0.0
    
    var dataPieChart = Array<Double>()
    
    // MARK: *** UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()

        language = UserDefaults.standard.value(forKey: "App_Language") as? String
        
        let arrStartDate = startDate?.components(separatedBy: "/")
        let stringStartDate = "\((arrStartDate?[2])!)-\((arrStartDate?[1])!)-\((arrStartDate?[0])!)"
        
        let arrEndDate = endDate?.components(separatedBy: "/")
        let stringEndDate = "\((arrEndDate?[2])!)-\((arrEndDate?[1])!)-\((arrEndDate?[0])!)"
        
        labelDateReport.text = "\(startDate!) - \(endDate!)"
        
        reports = DatabaseManagement.shared.getReportByTime(startDate: stringStartDate, endDate: stringEndDate)

        if reports.count > 0 {
            
            var totalCorrect: Double = 0.0
            var totalWrong: Double = 0.0
            
            for report in reports {
                
                if cat_id == 0 { // word
                    totalCorrect += Double(report.totalwordtrue)
                    totalWrong += Double(report.totalword - report.totalwordtrue)
                    
                    totalAdded += Double(report.totaladdword)
                    totalLearned += Double(report.totallearnedword)
                } else if cat_id == 1 { // phrase
                    totalCorrect += Double(report.totalphrasetrue)
                    totalWrong += Double(report.totalphrase - report.totalphrasetrue)
                    
                    totalAdded += Double(report.totaladdphrase)
                    totalLearned += Double(report.totallearnedphrase)
                } else if cat_id == 2 { // idioms
                    totalCorrect += Double(report.totalidiomstrue)
                    totalWrong += Double(report.totalidioms - report.totalidiomstrue)
                    
                    totalAdded += Double(report.totaladdidioms)
                    totalLearned += Double(report.totallearnedidioms)
                }
                
            }
            
            dataPieChart = [totalCorrect, totalWrong]

            
        } else {
            var title = "Notification"
            var message = "No report! Please try again"
            if language == "vi" {
                title = "Thông báo"
                message = "Không có thống kê! Vui lòng thử lại"
            }
            
            alert(title: title, message: message, handler: { (UIAlertAction) in
                _ = self.navigationController?.popViewController(animated: true)
            })
            

        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        language = UserDefaults.standard.value(forKey: "App_Language") as? String
        
        let pieChartName_vn = ["Đúng", "Sai"]
        let pieChartName_en = ["Correct", "Wrong"]
        
        if language == "vi" {
            if cat_id == 0 {
                self.navigationItem.title = "Từ"
                labelTotalAdd.text = "Số từ vựng đã nạp: \(Int(totalAdded))"
                labelTotalLearned.text = "Số từ vựng đã thuộc: \(Int(totalLearned))"
            } else if cat_id == 1 {
                self.navigationItem.title = "Cụm Từ"
                labelTotalAdd.text = "Số cụm từ đã nạp: \(Int(totalAdded))"
                labelTotalLearned.text = "Số cụm từ đã thuộc: \(Int(totalLearned))"
            } else if cat_id == 2 {
                self.navigationItem.title = "Thành Ngữ"
                labelTotalAdd.text = "Số thành ngữ đã nạp: \(Int(totalAdded))"
                labelTotalLearned.text = "Số thành ngữ đã thuộc: \(Int(totalLearned))"
            }
            
            updatePieChartData(dataPoint: dataPieChart, name: pieChartName_vn, pieChart: pieChart)
        } else {
            if cat_id == 0 {
                self.navigationItem.title = "Word"
                labelTotalAdd.text = "Number of words added: \(Int(totalAdded))"
                labelTotalLearned.text = "Number of words learned: \(Int(totalLearned))"
            } else if cat_id == 1 {
                self.navigationItem.title = "Phrase"
                labelTotalAdd.text = "Number of phrase added: \(Int(totalAdded))"
                labelTotalLearned.text = "Number of phrase learned: \(Int(totalLearned))"
            } else if cat_id == 2 {
                self.navigationItem.title = "Idioms"
                labelTotalAdd.text = "Number of idioms added: \(Int(totalAdded))"
                labelTotalLearned.text = "Number of idioms learned: \(Int(totalLearned))"
            }
            
            updatePieChartData(dataPoint: dataPieChart, name: pieChartName_en, pieChart: pieChart)
        }
        
    }
    
    func updatePieChartData(dataPoint: [Double], name: [String], pieChart: PieChartView)  {
        
        var total: Double = 0
        
        var entries = [PieChartDataEntry]()
        for (index, value) in dataPoint.enumerated() {
            total += value
            let entry = PieChartDataEntry()
            entry.y = value
            entry.label = name[index]
            entries.append( entry)
        }
        
        if total == 0.0 {
            if language == "vi"{
                pieChart.noDataText = "Không có dữ liệu"
            } else {
                pieChart.noDataText = "No data available"
            }
        } else {
            // 3. chart setup
            let set = PieChartDataSet( values: entries, label: "")
            set.sliceSpace = 2.0
            
            var colors: [UIColor] = []
            colors.append(UIColor(red: 100/255, green: 255/255, blue: 100/255, alpha: 1))
            colors.append(UIColor(red: 255/255, green: 100/255, blue: 100/255, alpha: 0.8))
            
            set.colors = colors
            set.drawIconsEnabled = false
            set.iconsOffset = CGPoint(x: 0, y: 40)
            
            let data = PieChartData(dataSet: set)
            
            let format = NumberFormatter()
            format.numberStyle = .none
            let formatter = DefaultValueFormatter(formatter: format)
            
            data.setValueFormatter(formatter)
            data.setValueFont(UIFont.systemFont(ofSize: 13.0))
            
            data.setValueTextColor(UIColor.black)
            
            pieChart.data = data
            let d = Description()
            d.font = UIFont.systemFont(ofSize: 13.0)
            
            let percent = (dataPoint[0] / total) * 100
            
            let str = String(format: "%.2f%%", percent)
            
            if self.language == "vi" {
                d.text = "\(str) chính xác"
            } else {
                d.text = "\(str) accurate"
            }
            
            pieChart.chartDescription = d
            pieChart.chartDescription?.xOffset = 2.0
            pieChart.drawHoleEnabled = false
            pieChart.legend.enabled = false
            pieChart.animate(yAxisDuration: 2.0, easingOption: .easeInOutBack)
        }
    }
}
