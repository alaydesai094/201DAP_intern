//
//  ShowRecordViewController.swift
//  CTC
//
//  Created by Nirav Bavishi on 2019-01-10.
//  Copyright © 2019 Nirav Bavishi. All rights reserved.
//

import UIKit
import UIKit
import EventKit
import Charts
import SwiftCharts


class ShowRecordViewController: UIViewController, ChartViewDelegate{
    
    lazy var barChartView: BarChartView = {
        let barChartView = BarChartView()
        barChartView.frame = view.frame
        return barChartView
    }()

    var chartView: BarsChart!
    var selectedDate: Date!
    
    var firstDayOfYear : Date! = DateComponents(calendar: .current, year: 2019, month: 1, day: 1).date!
    
    var isOn : Bool!
    var dbHelper: DatabaseHelper!
    var userObject: User!
    var myIndex: Int = 0
    var practicesArray: [Practice]!
    var currentPractice : Practice!
    var practices:[Practice]!
    var practice = [Practice]()
    
    var imageName: String = ""
   
    var isTableViewVisible = false
    
    var startValue: Double = 0
    var endValue: Double = 70
    var animationDuration: Double = 2.0
    let animationStartDate = Date()
   
    override func viewDidLoad() {
        dbHelper = DatabaseHelper()
        
        userObject = dbHelper.checkLoggedIn()
        practicesArray = dbHelper.getPractices(user: userObject)!
        
        currentPractice = practicesArray[myIndex]
      
        let startedDate = ((practicesArray[myIndex].startedday)! as Date).originalFormate()
        let days = Date().days(from: startedDate) + 1
        
        let practicedDays = Int(practicesArray[myIndex].practiseddays)
        
     
        let percentage: Int = Int((Float(practicedDays) / Float(days)) * 100)
        
        var entries: [BarEntry] = Array()
      
        var percentageArray:[Int] = []
        percentageArray.append(percentage)
        
            var practiceNameArray:[String] = []
            practiceNameArray.append(practicesArray[myIndex].practice!)
            for k in 0 ..< practicesArray.count{
                print("name is \(practicesArray[k].practice!)")
               // entries.append(practicesArray[k].practice, percentage)

                print("percentage is \(Int((Float(Int(practicesArray[k].practiseddays)) / Float(Date().days(from: ((practicesArray[k].startedday)! as Date).originalFormate()) + 1)) * 100))")
               
            }
        
        barChartView.dataEntries =
            [BarEntry(percentage:  Int((Float(Int(practicesArray[myIndex].practiseddays)) / Float(Date().days(from: ((practicesArray[myIndex].startedday)! as Date).originalFormate()) + 1)) * 100), practice: practicesArray[myIndex].practice!)]
        view.addSubview(barChartView)
            myIndex += 1

       
      
        let barButton = UIBarButtonItem(title: "Graph", style: .done, target: self, action: #selector(self.graphButtonTapped))
                navigationItem.rightBarButtonItem = barButton
        
    }
    
    
    
    
    @objc func graphButtonTapped(){
        
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "graphView") as! GraphViewController
            self.present(nextViewController, animated:true, completion:nil)
    }
    
   
    
    func setData() {
        
        
        print((practicesArray[myIndex].startedday)! as Date)
        let startedDate = ((practicesArray[myIndex].startedday)! as Date).originalFormate()
        let days = Date().days(from: startedDate) + 1
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let s = startedDate.dateFormateToString()!
        let formatedStartDate = dateFormatter.date(from: s)
        let currentDate = Date()
        let components = Set<Calendar.Component>([.day, .month, .year])
        let differenceOfDate = Calendar.current.dateComponents(components, from: formatedStartDate!, to: currentDate)
        
        print (differenceOfDate)
        print(startedDate)
        
        
        let practicedDays = Int(practicesArray[myIndex].practiseddays)
        let practicename = String(practicesArray[myIndex].practice!)
        
        print("name: \(practicename)")
        
        
        let percentage: Int = Int((Float(practicedDays) / Float(days)) * 100)
        print("percentage: \(percentage)")
        
    }
}
