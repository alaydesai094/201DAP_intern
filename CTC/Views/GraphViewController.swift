//
//  GraphViewController.swift
//  CTC
//
//  Created by Aesha Patel on 2019-07-09.
//  Copyright © 2019 Nirav Bavishi. All rights reserved.
//

import Foundation
import UIKit
import EventKit
import Charts
import SwiftCharts

class GraphViewController: UIViewController, ChartViewDelegate {
    
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
    
    
    @IBOutlet weak var pieChart: PieChartView!
    @IBOutlet weak var resolutionPickerView: UIPickerView!
   
    @IBOutlet weak var practiceName: UITextField!
    
    
    var isTableViewVisible = false
    
    var startValue: Double = 0
    var endValue: Double = 70
    var animationDuration: Double = 2.0
    let animationStartDate = Date()
    
    var picker: UIDatePicker = UIDatePicker()
    var popUpDatePicker: UIDatePicker = UIDatePicker()
    
        override func viewDidLoad() {
            
            dbHelper = DatabaseHelper()
            
            userObject = dbHelper.checkLoggedIn()
            practicesArray = dbHelper.getPractices(user: userObject)!
            
            if practicesArray.isEmpty == true {
                setupPieChart()
            }
            
            else {
                currentPractice = practicesArray[myIndex]
                
                
                practiceName.setUnderLineWithColor(color: UIColor.lightGray, alpha: 0.5)
                
                createPickerView()
                createToolBar()
                
                
                NotificationCenter.default.addObserver(self , selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
                
                self.setData()
                
                setupPieChart()
            }
           
                
          
    }
   
    func setupPieChart(){
        
        if (practiceName.text!.isEmpty == true){
            let alert = UIAlertController(title: "Alert", message: "You have not started any practice yet. Come back later.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Okay!", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
        else {
        
        let startedDate = ((practicesArray[myIndex].startedday)! as Date).originalFormate()
        let days = Date().days(from: startedDate) + 1
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let s = startedDate.dateFormateToString()!
        let formatedStartDate = dateFormatter.date(from: s)
        let currentDate = Date()
        let components = Set<Calendar.Component>([.day, .month, .year])
        let differenceOfDate = Calendar.current.dateComponents(components, from: formatedStartDate!, to: currentDate)
        let practicedDays = Int(practicesArray[myIndex].practiseddays)
        let practicename = String(practicesArray[myIndex].practice!)
       
        let percentage: Int = Int((Float(practicedDays) / Float(days)) * 100)
        let notDone = 100 - percentage
        

        var entries: [PieChartDataEntry] = Array()
        
        entries.append(PieChartDataEntry(value: Double(percentage), label: "practised \(percentage)%"))
        entries.append(PieChartDataEntry(value: Double(notDone),label: "remaining \(notDone)%"))
            
            let dataSet = PieChartDataSet(entries: entries, label: "")
            let c1 =  #colorLiteral(red: 0.2484704256, green: 0.8797343373, blue: 0.820797801, alpha: 1)
            let c2 =  #colorLiteral(red: 0.5027292371, green: 0.4978299737, blue: 0.5022076368, alpha: 1)
            
            dataSet.colors = [c1,c2]
            dataSet.drawValuesEnabled = false
            
            pieChart.data = PieChartData(dataSet: dataSet)
        
       
        pieChart.chartDescription?.enabled = false
        pieChart.drawHoleEnabled = false
        pieChart.rotationAngle = 0
            
        }
        
    }
    
    func createPickerView(){
        
        let resolutionPicker = UIPickerView()
        resolutionPicker.delegate = self as! UIPickerViewDelegate
        
        resolutionPicker.backgroundColor = .white
        print(myIndex)
        
        practiceName.inputView = resolutionPicker
        
    }
    
    func createToolBar(){
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(GraphViewController.dismissPickerView))
        
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        practiceName.inputAccessoryView = toolBar
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! HomeViewController
        
        destination.userObject = userObject
        
    }
    
    @objc func dismissPickerView() {
        self.setData()
        self.setupPieChart()
        view.endEditing(true)
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
        
       // self.imageName = self.practices[myIndex].image_name!
        practiceName.text = practicesArray[myIndex].practice
       
        let practicedDays = Int(practicesArray[myIndex].practiseddays)
        let practicename = String(practicesArray[myIndex].practice!)
        print("name: \(practicename)")
        
     
        let percentage: Int = Int((Float(practicedDays) / Float(days)) * 100)
       
    }
    
    
    deinit {
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
    }
    
    @objc func keyboardWillChange(notification: Notification){
        
        print("Keyboard Will Show : \(notification.name.rawValue)")
       
        
        if(!practiceName.isEditing){
            
            let keyboardRectangle:CGRect?
            if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                keyboardRectangle = keyboardFrame.cgRectValue
                
                if (notification.name == UIResponder.keyboardWillShowNotification || notification.name == UIResponder.keyboardWillChangeFrameNotification){
                    
                    self.view.frame.origin.y = (-keyboardRectangle!.height+50)
                    
                }
                else{
                    
                    self.view.frame.origin.y = 0
                    
                }
                
            }
            
        }
        
    }
}

extension GraphViewController : UIPickerViewDataSource, UIPickerViewDelegate{
    
    
    // Picker View
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return practicesArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return practicesArray[row].practice
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        myIndex = row
        practiceName.text = "\(String(describing: practicesArray[row].practice!))"
        
    }
}

extension GraphViewController : UITextViewDelegate{
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView.textColor == UIColor.lightGray {
            if textView.text == "Write Your Notes Here. . . "{
                textView.text = nil
                
            }
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Write Your Notes Here. . . "
            textView.textColor = UIColor.lightGray
        }
    }
    
}
