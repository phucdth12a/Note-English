//
//  ReportAllController.swift
//  1542257-1542258
//
//  Created by Phu on 5/14/17.
//  Copyright © 2017 Phu. All rights reserved.
//

import UIKit
import Charts

class ReportAllController: UIViewController {

    // MARL: *** UI Element
    @IBOutlet weak var labelDateReport: UILabel!
    @IBOutlet weak var barChart: BarChartView!
    @IBOutlet weak var pieChartWord: PieChartView!
    @IBOutlet weak var pieChartPhrase: PieChartView!
    @IBOutlet weak var pieChartIdioms: PieChartView!
    
    // MARK: *** Data model
    var startDate: String?
    var endDate: String?
    var language: String?
    var reports = [Report]()
    
    var dataPieChart_Word = Array<Double>()
    var dataPieChart_Phrase = Array<Double>()
    var dataPieChart_Idioms = Array<Double>()
    
    var dataBarChart_Add = Array<Double>()
    var dataBarChart_Learned = Array<Double>()
    
    // MARK: *** UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        language = UserDefaults.standard.value(forKey: "App_Language") as? String
        
        let arrStartDate = startDate?.components(separatedBy: "/")
        let stringStartDate = "\((arrStartDate?[2])!)-\((arrStartDate?[1])!)-\((arrStartDate?[0])!)"
        
        let arrEndDate = endDate?.components(separatedBy: "/")
        let stringEndDate = "\((arrEndDate?[2])!)-\((arrEndDate?[1])!)-\((arrEndDate?[0])!)"
        
        reports = DatabaseManagement.shared.getReportByTime(startDate: stringStartDate, endDate: stringEndDate)
        
        labelDateReport.text = "\(startDate!) - \(endDate!)"
        
        if reports.count > 0 {
            
            var totalWordCorrect: Double = 0.0
            var totalWordWrong: Double = 0.0
            var totalPhraseCorrect: Double = 0.0
            var totalPhraseWrong: Double = 0.0
            var totalIdiomsCorrect: Double = 0.0
            var totaLIdiomsWrong: Double = 0.0
            
            var totalWordAdd: Double = 0.0
            var totalWordLearned: Double = 0.0
            var totalPhraseAdd: Double = 0.0
            var totalPhraseLearned: Double = 0.0
            var totalIdiomsAdd: Double = 0.0
            var totalIdiomsLeared: Double = 0.0
            
            
            for report in reports {
                
                totalWordCorrect += Double(report.totalwordtrue)
                totalWordWrong += Double(report.totalword - report.totalwordtrue)
                totalPhraseCorrect += Double(report.totalphrasetrue)
                totalPhraseWrong += Double(report.totalphrase - report.totalphrasetrue)
                totalIdiomsCorrect += Double(report.totalidiomstrue)
                totaLIdiomsWrong += Double(report.totalidioms - report.totalidiomstrue)
                
                totalWordAdd += Double(report.totaladdword)
                totalWordLearned += Double(report.totallearnedword)
                totalPhraseAdd += Double(report.totaladdphrase)
                totalPhraseLearned += Double(report.totallearnedphrase)
                totalIdiomsAdd += Double(report.totaladdidioms)
                totalIdiomsLeared += Double(report.totallearnedidioms)
                
            }
            
            dataPieChart_Word = [totalWordCorrect, totalWordWrong]
            dataPieChart_Phrase = [totalPhraseCorrect, totalPhraseWrong]
            dataPieChart_Idioms = [totalIdiomsCorrect, totaLIdiomsWrong]
            
            dataBarChart_Add = [totalWordAdd, totalPhraseAdd, totalIdiomsAdd]
            dataBarChart_Learned = [totalWordLearned, totalPhraseLearned, totalIdiomsLeared]
            
            
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
        
        if language == "vi" {
            self.navigationItem.title = "Tất Cả"
        } else {
            self.navigationItem.title = "All"
        }
        
        let pieChartName_vn = ["Đúng", "Sai"]
        let pieChartName_en = ["Correct", "Wrong"]
        
        let barChartName_vn = ["Từ", "Cụm từ", "Thành ngữ"]
        let barChartName_en = ["Word", "Phrase", "Idioms"]
        
        if language == "vi" {
            updatePieChartData(dataPoint: dataPieChart_Word, name: pieChartName_vn, pieChart: pieChartWord)
            updatePieChartData(dataPoint: dataPieChart_Phrase, name: pieChartName_vn, pieChart: pieChartPhrase)
            updatePieChartData(dataPoint: dataPieChart_Idioms, name: pieChartName_vn, pieChart: pieChartIdioms)
            
            updateBarChartData(name: barChartName_vn, added: dataBarChart_Add, learned: dataBarChart_Learned, barChart: barChart)
            
        } else {
            updatePieChartData(dataPoint: dataPieChart_Word, name: pieChartName_en, pieChart: pieChartWord)
            updatePieChartData(dataPoint: dataPieChart_Phrase, name: pieChartName_en, pieChart: pieChartPhrase)
            updatePieChartData(dataPoint: dataPieChart_Idioms, name: pieChartName_en, pieChart: pieChartIdioms)
            
            updateBarChartData(name: barChartName_en, added: dataBarChart_Add, learned: dataBarChart_Learned, barChart: barChart)
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
                if pieChart == pieChartWord {
                    d.text = "\(str) chính xác từ"
                } else if pieChart == pieChartPhrase {
                    d.text = "\(str) chính xác cụm từ"
                } else if pieChart == pieChartIdioms {
                    d.text = "\(str) chính xác thành ngữ"
                }
            } else {
                if pieChart == pieChartWord {
                    d.text = "\(str) accurate word"
                } else if pieChart == pieChartPhrase {
                    d.text = "\(str) accurate phrase"
                } else if pieChart == pieChartIdioms {
                    d.text = "\(str) accurate idioms"
                }
            }
            
            pieChart.chartDescription = d
            pieChart.chartDescription?.xOffset = 2.0
            pieChart.drawHoleEnabled = false
            pieChart.legend.enabled = false
            pieChart.animate(yAxisDuration: 2.0, easingOption: .easeInOutBack)
        }
    }
    
    func updateBarChartData(name: [String], added: [Double], learned: [Double], barChart: BarChartView) {
        
        barChart.noDataText = "You need to provide data for the chart."
        barChart.doubleTapToZoomEnabled = false
        barChart.chartDescription?.enabled = false
        
        
        //legend
        let legend = barChart.legend
        legend.enabled = true
        legend.horizontalAlignment = .right
        legend.verticalAlignment = .top
        legend.orientation = .vertical
        legend.drawInside = true
        legend.yOffset = 10.0;
        legend.xOffset = 10.0;
        legend.yEntrySpace = 0.0;
        
        
        let xaxis = barChart.xAxis
        xaxis.drawGridLinesEnabled = true
        xaxis.labelPosition = .bottom
        xaxis.centerAxisLabelsEnabled = true
        xaxis.valueFormatter = IndexAxisValueFormatter(values: name)
        xaxis.granularity = 1
        
        
        let leftAxisFormatter = NumberFormatter()
        leftAxisFormatter.maximumFractionDigits = 1
        
        let yaxis = barChart.leftAxis
        yaxis.spaceTop = 0.35
        yaxis.axisMinimum = 0
        yaxis.drawGridLinesEnabled = false
        
        barChart.rightAxis.enabled = false
        
        
        var dataEntries: [BarChartDataEntry] = []
        var dataEntries1: [BarChartDataEntry] = []
        
        for i in 0..<name.count {
            
            let dataEntry = BarChartDataEntry(x: Double(i) , y: added[i])
            dataEntries.append(dataEntry)
            
            let dataEntry1 = BarChartDataEntry(x: Double(i) , y: learned[i])
            dataEntries1.append(dataEntry1)
            
        }
        
        var labelAdded = "Added"
        var labelLearned = "Remembered"
        if language == "vi" {
            labelAdded = "Đã thêm"
            labelLearned = "Đã thuộc"
        }
        
        let chartDataSet = BarChartDataSet(values: dataEntries, label: labelAdded)
        let chartDataSet1 = BarChartDataSet(values: dataEntries1, label: labelLearned)
        
        let dataSets: [BarChartDataSet] = [chartDataSet,chartDataSet1]
        chartDataSet.colors = [UIColor(red: 230/255, green: 126/255, blue: 34/255, alpha: 1)]
        
        let chartData = BarChartData(dataSets: dataSets)
        
        
        let groupSpace = 0.3
        let barSpace = 0.05
        let barWidth = 0.3
        // (0.3 + 0.05) * 2 + 0.3 = 1.00 -> interval per "group"
        
        let groupCount = name.count
        let startYear = 0
        
        
        chartData.barWidth = barWidth;
        barChart.xAxis.axisMinimum = Double(startYear)
        let gg = chartData.groupWidth(groupSpace: groupSpace, barSpace: barSpace)
        
        barChart.xAxis.axisMaximum = Double(startYear) + gg * Double(groupCount)
        
        chartData.groupBars(fromX: Double(startYear), groupSpace: groupSpace, barSpace: barSpace)
        barChart.notifyDataSetChanged()
        
        let format = NumberFormatter()
        format.numberStyle = .none
        let formatter = DefaultValueFormatter(formatter: format)
        
        chartData.setValueFormatter(formatter)
        
        barChart.data = chartData
        barChart.animate(xAxisDuration: 1.5, yAxisDuration: 1.5, easingOption: .linear)
        
        
    }



}
