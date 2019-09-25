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
//
//        dbHelper = DatabaseHelper()
//
//        userObject = dbHelper.checkLoggedIn()
//        practicesArray = dbHelper.getPractices(user: userObject)!
//
//        currentPractice = practicesArray[myIndex]
//
//
//        practiceName.setUnderLineWithColor(color: UIColor.lightGray, alpha: 0.5)
//
//        createPickerView()
//        createToolBar()
//
//         let barButton = UIBarButtonItem(title: "Graph", style: .done, target: self, action: #selector(self.graphButtonTapped))
//        navigationItem.rightBarButtonItem = barButton
//        NotificationCenter.default.addObserver(self , selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
//
//        self.setData()
//
//
//        let chartConfig = BarsChartConfig(valsAxisConfig: ChartAxisConfig(from: 0, to: 100, by: 20)
//
//        )
//
//        let frame = CGRect(x: 0, y:270, width: self.view.frame.width, height: 450)
//        practice = dbHelper.getPractices(user: userObject!)!
//        for practiceObject in practice{
//            let startedDate = ((practiceObject.startedday! as Date).originalFormate())
//            let days = Date().days(from: startedDate) + 1
//            //            let percentage: Int = Int((Float(practicedDays) / Float(days)) * 100)
//            let percentage = Int(Float(practiceObject.practiseddays  * 100) / Float(days))
//            let name: String = practiceObject.practice!
//            print("name is \(name) and percentage is \(percentage)")
//            let chart = BarsChart(frame: frame, chartConfig: chartConfig, xTitle: "Practice", yTitle: "Percentage", bars: [(name,Double(percentage))
//                ], color: UIColor.darkGray, barWidth: 15)
//
//            self.view.addSubview(chart.view)
//            self.chartView = chart
//        }
        //            let chart = BarsChart(frame: frame, chartConfig: chartConfig, xTitle: "Month", yTitle: "Percentage", bars: [(name,Double(percentage))], color: UIColor.darkGray, barWidth: 15)
       
        
        
    
//
//    }
//
//
//
//    func createPickerView(){
//
//        let resolutionPicker = UIPickerView()
//        resolutionPicker.delegate = self as! UIPickerViewDelegate
//
//        resolutionPicker.backgroundColor = .white
//        print(myIndex)
//
//        practiceName.inputView = resolutionPicker
//
//    }
//
//    func createToolBar(){
//
//        let toolBar = UIToolbar()
//        toolBar.sizeToFit()
//        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(GraphViewController.dismissPickerView))
//
//        toolBar.setItems([doneButton], animated: false)
//        toolBar.isUserInteractionEnabled = true
//
//        practiceName.inputAccessoryView = toolBar
//
//    }
//
//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let destination = segue.destination as! HomeViewController
//
//        destination.userObject = userObject
//
//    }
//
//    @objc func dismissPickerView() {
//        self.setData()
//        view.endEditing(true)
//    }
//
//    @objc func graphButtonTapped(){
//
//    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//
//    let nextViewController = storyBoard.instantiateViewController(withIdentifier: "graphView") as! GraphViewController
//    self.present(nextViewController, animated:true, completion:nil)
//    }
//
//    func setData() {
//        print((practicesArray[myIndex].startedday)! as Date)
//        let startedDate = ((practicesArray[myIndex].startedday)! as Date).originalFormate()
//        let days = Date().days(from: startedDate) + 1
//
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "dd-MM-yyyy"
//        let s = startedDate.dateFormateToString()!
//        let formatedStartDate = dateFormatter.date(from: s)
//        let currentDate = Date()
//        let components = Set<Calendar.Component>([.day, .month, .year])
//        let differenceOfDate = Calendar.current.dateComponents(components, from: formatedStartDate!, to: currentDate)
//
//        print (differenceOfDate)
//        print(startedDate)
//
//        // self.imageName = self.practices[myIndex].image_name!
//        practiceName.text = practicesArray[myIndex].practice
//
//        let practicedDays = Int(practicesArray[myIndex].practiseddays)
//        let practicename = String(practicesArray[myIndex].practice!)
//        print("name: \(practicename)")
//
//
//        let percentage: Int = Int((Float(practicedDays) / Float(days)) * 100)
//
//    }
//
//
//    deinit {
//
//        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
//        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
//
//    }
//
//    @objc func keyboardWillChange(notification: Notification){
//
//        print("Keyboard Will Show : \(notification.name.rawValue)")
//
//
//        if(!practiceName.isEditing){
//
//            let keyboardRectangle:CGRect?
//            if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
//                keyboardRectangle = keyboardFrame.cgRectValue
//
//                if (notification.name == UIResponder.keyboardWillShowNotification || notification.name == UIResponder.keyboardWillChangeFrameNotification){
//
//                    self.view.frame.origin.y = (-keyboardRectangle!.height+50)
//
//                }
//                else{
//
//                    self.view.frame.origin.y = 0
//
//                }
//
//            }
//
//        }
//
//    }
//}
//
//extension ShowRecordViewController : UIPickerViewDataSource, UIPickerViewDelegate{
//
//
//    // Picker View
//
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return 1
//    }
//
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        return practicesArray.count
//    }
//
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        return practicesArray[row].practice
//    }
//
//
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//
//        myIndex = row
//        practiceName.text = "\(String(describing: practicesArray[row].practice!))"
//
//    }
//}
//
//extension ShowRecordViewController : UITextViewDelegate{
//
//    func textViewDidBeginEditing(_ textView: UITextView) {
//
//        if textView.textColor == UIColor.lightGray {
//            if textView.text == "Write Your Notes Here. . . "{
//                textView.text = nil
//
//            }
//            textView.textColor = UIColor.black
//        }
//    }
//
//    func textViewDidEndEditing(_ textView: UITextView) {
//        if textView.text.isEmpty {
//            textView.text = "Write Your Notes Here. . . "
//            textView.textColor = UIColor.lightGray
//        }
//    }
//
//}

//
//    @IBOutlet weak var recordTableView: UITableView!
//
//    //MARK: Pop up Outlets
//
//    @IBOutlet var mainPopUpView: UIView!
//
//    @IBOutlet weak var popUpForegroundView: UIView!
//    @IBOutlet weak var popUpTitleLabel: UILabel!
//    @IBOutlet weak var popUpDateLabel: UILabel!
//    @IBOutlet weak var popUpPracticeTextField: UITextField!
//    @IBOutlet weak var popUpPracticedSwitch: UISwitch!
//    @IBOutlet weak var popUpNoteTextArea: UITextView!
//    @IBOutlet weak var popUpUpdateButton: UIButton!
//    @IBOutlet weak var popUpCancelButton: UIButton!
//
//
//    // MARK: Variables
//    var userObject: User?
//    var dbHelper : DatabaseHelper!
//
//    var dataDict = [Date: [AnyObject] ]()
//    var practices = [Practice]()
//    var valueArray: [PracticeData]?
//    var dictKeys : [Date]?
//    var percentageData = [[String:String?]]()
//    var dateIndex: Int!
//    var dataIndex: Int!
//    var firstDayOfYear : Date! = DateComponents(calendar: .current, year: 2019, month: 1, day: 1).date!
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        dbHelper = DatabaseHelper()
//
//        userObject = dbHelper.checkLoggedIn()
//
//
//        // MARK: Popup Setup
//        popUpForegroundView.setPopupView()
//        popUpCancelButton.setPopUpButton()
//        popUpUpdateButton.setPopUpButton()
//        popUpTitleLabel.setPopUpTitle()
//
//
//        let barButton = UIBarButtonItem(title: "Graph", style: .done, target: self, action: #selector(self.graphButtonTapped))
//
//        navigationItem.rightBarButtonItem = barButton
//
//
//        if (userObject != nil){
//
//        }
//
////        dataDict = dbHelper.getPracticeHistory(user: userObject!)!
//        practices = dbHelper.getPractices(user: userObject!)!
//        dataDict = dbHelper.getPracRecordTemp(user: userObject!)!
////        print(practices)
////        print("Printing Data dict . . . .. . . . . . . . . . . . . . . . . . . . ")
////        print(dataDict)
////
//        for practiceObject in practices{
//            let startedDate = ((practiceObject.startedday! as Date).originalFormate())
//            let days = Date().days(from: startedDate) + 1
////            let percentage: Int = Int((Float(practicedDays) / Float(days)) * 100)
//            let percentage = Int(Float(practiceObject.practiseddays  * 100) / Float(days))
//            percentageData.append(["Practice": practiceObject.practice!, "Percentage": "\(percentage)", "TrackingDay": String(practiceObject.practiseddays), "outOfDays":String(days)])
//        }
//
////         var tempDictKeys = Array(dataDict.keys)
////
////        let swiftArray = NSMutableArray.self as AnyObject as! [String]
//
////        dictKeys = swiftArray.sorted { $0.localizedCaseInsensitiveCompare($1) == ComparisonResult.orderedAscending }
//        dictKeys = Array(dataDict.keys)
////        dictKeys = convertToDate(stringDate: tempDictKeys)
//
//        dictKeys =  dictKeys?.sorted(by: <)
////        dictKeys = dictKeys?.reversed()
////        print("Dict keys-------------------------")
////        print(dictKeys)
//
//        let toolBar = UIToolbar()
//        toolBar.sizeToFit()
//        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(addTodayViewController.dismissKeyboard))
//
//        toolBar.setItems([doneButton], animated: false)
//        toolBar.isUserInteractionEnabled = true
//
//        popUpNoteTextArea.inputAccessoryView = toolBar
//
//    }
//    override func viewDidAppear(_ animated: Bool) {
//        self.refreshTableView()
//    }
//
//    @objc func graphButtonTapped(){
//
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//
//        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "graphView") as! GraphViewController
//        self.present(nextViewController, animated:true, completion:nil)
//    }
//
//    func refreshTableView() {
//
//        percentageData = [[String:String?]]()
//
////        dataDict = dbHelper.getPracticeRecords(user: userObject!)!
//        practices = dbHelper.getPractices(user: userObject!)!
//        dataDict = dbHelper.getPracRecordTemp(user: userObject!)!
////        print(practices)
////        print("Printing Data dict . . . .. . . . . . . . . . . . . . . . . . . . ")
////        print(dataDict)
//
//
//        for practiceObject in practices{
//            let startedDate = ((practiceObject.startedday! as Date).originalFormate())
//            let days = Date().days(from: startedDate) + 1
//            //            let percentage: Int = Int((Float(practicedDays) / Float(days)) * 100)
//            let percentage = Int(Float(practiceObject.practiseddays  * 100) / Float(days))
//            percentageData.append(["Practice": practiceObject.practice!, "Percentage": "\(percentage)", "TrackingDay": String(practiceObject.practiseddays), "outOfDays":String(days)])
//
//        }
//
//         dictKeys = Array(dataDict.keys)
//
//        dictKeys =  dictKeys?.sorted(by: >)
//        self.recordTableView.reloadData()
//
//    }
//
//    func convertToDate(stringDate: [String]) -> [Date]?{
//
//        var dateArray : [Date] = []
//
//        for date in stringDate{
//
//            dateArray.append(date.stringToDate())
//
//        }
//
//        return dateArray
//
//    }
//
//    func numberOfSections(in tableView: UITableView) -> Int {
////        return DayWiseData.count + 1
//
//        return 1
//    }
//
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 60
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 80
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//
//        if(section == 0){
//            return percentageData.count
//        }else{
////            print("Count for key = \(dictKeys![section-1]) and count = \(dataDict[dictKeys![section-1].dateFormateToString()!]!.count)")
//
//        return dataDict[dictKeys![section-1]]!.count
//        }
//    }
//
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//
//
//            let Zerocell = tableView.dequeueReusableCell(withIdentifier: "SectionZeroHederCell")
//            Zerocell?.backgroundColor = Theme.secondaryColor
//
//            return Zerocell
//
//
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
////            print("Row = \(indexPath.row)")
////            print("Section = \(indexPath.section)")
//
//            let cell = tableView.dequeueReusableCell(withIdentifier: "SectionZeroDataCell") as! ShowPercentageCell
////            let Percentege = PercentageData[indexPath.row]["Percentage"] as! String
////            let Percentege = practices[indexPath.row].percentage
//            let perString = percentageData[indexPath.row]["Percentage"] as? String
//            let Percentage = Int((perString ?? "0"))
//            cell.PercentageLabel.text = "\(String(describing: Percentage!))%"
////            cell.ResolutionTextLabel.text = PercentageData[indexPath.row]["Resolution"]
//            cell.ResolutionTextLabel.text = percentageData[indexPath.row]["Practice"] as? String
//            cell.PercentageProgressView.setProgress( Float(Float(Percentage!)/100), animated: true)
////            let TrackingDay = PercentageData[indexPath.row]["TrackingDay"] as! String
//            let TrackingDay = percentageData[indexPath.row]["TrackingDay"]
//
//            let outofDays = percentageData[indexPath.row]["outOfDays"]
//            cell.TrackingDayLabel.text = "Day : \(TrackingDay! ?? "0")/\(outofDays! ?? "0")"
//
//            return cell
//
//
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//        dateIndex = indexPath.section-1
//        dataIndex = indexPath.row
//        let tempDataBuffer = dataDict[dictKeys![indexPath.section-1]]![indexPath.row]
//
//
//        if let tempObj = tempDataBuffer as? PracticeData{
//
//    //        print("Selected Data- - - - - - - - - - - - - - - -")
//    //        print(dictKeys![indexPath.section-1])
//    //        print(dataDict[dictKeys![indexPath.section-1]]![indexPath.row])
//    //
//            popUpDateLabel.text = "Date: \(dictKeys![indexPath.section-1])"
//            popUpPracticeTextField.text = tempObj.practiceDataToPractice?.practice
//            popUpNoteTextArea.text = tempObj.note
//            popUpPracticedSwitch.isOn = tempObj.practised
//
//
//            self.view.addSubview(mainPopUpView)
//            mainPopUpView.center = self.view.center
//        }
//        tableView.deselectRow(at: indexPath, animated: true)
//    }
//
//
//
//    @IBAction func popUpdateButtonTapped(_ sender: Any) {
//
//        let practiceName = popUpPracticeTextField.text!
//        let notes = popUpNoteTextArea.text!
//        let practiced = popUpPracticedSwitch.isOn
//        let date = (dictKeys![dateIndex])
//
//
//        let resultFlag = dbHelper.updatePracticeData(practiceName: practiceName, practiceDate: date, note: notes, practiced: practiced)
//
//        if(resultFlag == 0){
//
//            showToast(message: "Data Updated... ", duration: 3)
//
//        }else{
//
//            showToast(message: "error In Data Updation... ", duration: 3)
//
//        }
//        self.popUpPracticeTextField.text = ""
//        self.popUpNoteTextArea.text = ""
//        self.mainPopUpView.removeFromSuperview()
//        self.refreshTableView()
//
//    }
//    @IBAction func popUpCancelButtonTapped(_ sender: Any) {
//
//        self.popUpPracticeTextField.text = ""
//        self.popUpNoteTextArea.text = ""
//        self.mainPopUpView.removeFromSuperview()
//
//    }
//
//
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//    }
//    */
//
//}
