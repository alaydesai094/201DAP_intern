//
//  HomeViewController.swift
//  CTC
//
//  Created by Nirav Bavishi on 2019-01-23.
//  Copyright © 2019 Nirav Bavishi. All rights reserved.
//

import UIKit
import UserNotifications

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,ReceiveData{
    
    // variables
    var dbHelper: DatabaseHelper!
    var selectedDate: Date!
    var datePicker : UIDatePicker!
    var popUpDatePicker : UIDatePicker!
    var myIndex: Int!
    var isUpdating: Bool! = false
    var oldPractice: String?
    var window: UIWindow!
    
    
    
    var userObject: User!
    let moreOptionIconList = ["book", "dairy", "money management","excercise","flour","communication","language","meditation","music","salad","sleep","relaxation","self reflection","walking","abstinence","yoga","tidy up","vegetable","writing","hobby","board game","sport","electronics","worship","entertainment","coffee-tea","Other"]
    var imageName: String = ""
    
    var lastCellNumber : Int!
    
    var practices:[Practice]!
    var practicesData: [PracticeData]!
    
    
    //// variables
    
    @IBOutlet weak var addResolutionButton: UIButton!
    @IBOutlet weak var imageIconButton: UIButton!
    @IBOutlet weak var homeTableView: UITableView!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var titleTextLabel: UILabel!
    @IBOutlet weak var practiceTextfield: UITextField!
    @IBOutlet weak var popUpFregroundView: UIView!
    @IBOutlet var popUpView: UIView!
    @IBOutlet weak var practiceStartedDate: UITextField!
    
    
    
    override func viewDidLoad() {
        
       
       // MARK: Testing
        
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        popUpView.frame = frame
        
        
        // MARK: Testing
        
        super.viewDidLoad()
        selectedDate = Date().dateFormate()!

        dateTextField.text = "Date : \(Date().dateFormatemmmdd()!)"
        
        dbHelper = DatabaseHelper()
        
        userObject = dbHelper.checkLoggedIn()
        
        let oldestDate = dbHelper.oldestPracticeDate(user: userObject)
        
        //MARK: ViewController Date Picker
        datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(self.DatePickerValueChanged(datePicker:)), for: .valueChanged)
        dateTextField.inputView = datePicker
        datePicker.maximumDate = Date()
        datePicker.minimumDate = oldestDate
        
        
        //MARK: Popup Date Picker
        popUpDatePicker = UIDatePicker()
        popUpDatePicker.datePickerMode = .date
        popUpDatePicker.addTarget(self, action: #selector(self.PopUpDatePickerValueChanged(datePicker:)), for: .valueChanged)
        practiceStartedDate.inputView = popUpDatePicker
        popUpDatePicker.maximumDate = Date()
        
        //MARK: Custome Done Tool bar
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.dateSelected))
        
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        dateTextField.inputAccessoryView = toolBar
        
        //MARK: Custome Done Tool bar
        
        //MARK: Custome Done Tool bar for Popup
        
        let popUpToolBar = UIToolbar()
        popUpToolBar.sizeToFit()
        let popUpDoneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.popUpDateSelected))
        
        popUpToolBar.setItems([popUpDoneButton], animated: true)
        popUpToolBar.isUserInteractionEnabled = true
        practiceStartedDate.inputAccessoryView = popUpToolBar
        
        //MARK: Custome Done Tool bar for Popup
    
        
        addResolutionButton.backgroundColor = Theme.secondaryColor
        addResolutionButton.layer.cornerRadius = addResolutionButton.frame.height/2
        addResolutionButton.layer.shadowColor = UIColor.black.cgColor
        addResolutionButton.layer.shadowOffset = CGSize(width: 0, height: 10)
        addResolutionButton.layer.shadowRadius = 5
        addResolutionButton.layer.shadowOpacity = 0.25
        
        
        
       practices = self.getPractices()
        practicesData = self.getPracticesData(date: selectedDate)
        
        
        // for popup view
        popUpFregroundView.setPopupView()
        titleTextLabel.setPopUpTitle()
        addButton.setPopUpButton()
        cancelButton.setPopUpButton()
        
        //// popup view
        createDoneToolBar(textField: practiceTextfield)
        
        
        
        // MARK: Gradiat Color Sewt for naviagation Bar
        
        if let navigationBar = self.navigationController?.navigationBar {
            let gradient = CAGradientLayer()
            var bounds = navigationBar.bounds
            bounds.size.height += UIApplication.shared.statusBarFrame.size.height
            gradient.frame = bounds
            gradient.colors = [UIColor.red.cgColor, UIColor.blue.cgColor]
            gradient.startPoint = CGPoint(x: 0, y: 0)
            gradient.endPoint = CGPoint(x: 1, y: 0)
        }
        
        // MARL: Gradient over
        
        dbHelper.maintainPracticeDataWeekly(user: userObject)
       
    }
    
    
    
    @objc func DatePickerValueChanged(datePicker: UIDatePicker){
        
        let finalDate = "Date: \(datePicker.date.dateFormatemmmdd()!)"
        dateTextField.text = finalDate
        
    }
    @objc func PopUpDatePickerValueChanged(datePicker: UIDatePicker){
        
        practiceStartedDate.text = popUpDatePicker.date.dateFormatemmmdd()!
        
    }
    
    
    private func getPractices() -> [Practice]{
        
        
        return dbHelper.getPractices(user: userObject)!
        
    }
    private func getPracticesData(date: Date) -> [PracticeData]?{
        
        
        return dbHelper.getPracticeDataByDate(date: date.dateFormate()!)
        
    }
    

    override func viewDidAppear(_ animated: Bool) {
        selectedDate = datePicker.date.dateFormate()!
        self.refreshTableview(date: selectedDate)
    }
//
    
    @objc func dateSelected() {
        
        selectedDate = datePicker.date.dateFormate()!
        
        let selectedData : [PracticeData] = dbHelper.getPracticeDataByDate(date: selectedDate)!


        practices = dbHelper.getPractices(date: selectedDate, user: userObject)
        practicesData = selectedData
        self.homeTableView.reloadData()

        self.view.endEditing(true)
        
    }
    
    @objc func popUpDateSelected() {

        
        self.view.endEditing(true)
        
    }
    
    @objc func reloadHomeTableView(){
        
        self.homeTableView.reloadData()
        
    }
    
    func passUserObject(user: User) {
        userObject = user
    }
    
    @IBAction func addResolutionButtonTapped(_ sender: Any) {
        
        self.view.addSubview(popUpView)
        self.titleTextLabel.text = "Add Practice"
        self.addButton.setTitle("Add", for: .normal)
        practiceStartedDate.text = Date().dateFormatemmmdd()
        popUpView.center = self.view.center
        
    }
    
    
    
    // Table View Code
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        lastCellNumber = practices!.count+1
        return lastCellNumber
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if(editingStyle == .delete){
            
            let prac = self.practices[indexPath.section + indexPath.row]
            
            let alert = UIAlertController(title: "Warning", message: "Are you sure you want to delete this \(prac.practice!) permanently?", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (action:UIAlertAction) -> Void in
                self.delPractice(prac: prac)
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
            
        }
    }
    
    func delPractice(prac: Practice){
        
        let pracName = prac.practice
        let td = prac.practiseddays
        let dss = (Date().dateFormate()!).days(from: (prac.startedday! as Date).dateFormate()!) + 1
        let flag = false
        let date = Date().dateFormate()!
        
        dbHelper.deletePractice(practice: prac)
        let resultFlag = dbHelper.addPracticeHistory(practiceName: pracName!, comDelFlag: flag, date: date, dss: dss, td: Int(td))
        
        if(resultFlag == 0){
            showToast(message: "\(pracName!) Deleted", duration: 3)
        }else{
            showToast(message: "Deletion Error", duration: 3)
        }
        
        self.refreshTableview(date: selectedDate)
        
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Edit") { (action, view, handler) in
            print("Add Action Tapped")
            self.practiceTextfield.text = self.practices[indexPath.section + indexPath.row].practice
            self.oldPractice = self.practices[indexPath.section + indexPath.row].practice
            
            self.imageIconButton.setImage(UIImage(named: self.practices[indexPath.section + indexPath.row].image_name!), for: .normal)
            
            self.imageName = self.practices[indexPath.section + indexPath.row].image_name!
            
            self.popUpDatePicker.date = (self.practices[indexPath.section + indexPath.row].startedday)! as Date
            
            self.practiceStartedDate.text = ((self.practices[indexPath.section + indexPath.row].startedday)! as Date).dateFormatemmmdd()
            self.titleTextLabel.text = "Edit Practice"
            self.addButton.setTitle("Confirm", for: .normal)
            self.view.addSubview(self.popUpView)
            self.popUpView.center = self.view.center
            self.isUpdating = true
        }
        deleteAction.backgroundColor = .lightGray
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0{
            
            return 0
            
        }
        else{
            
            return 10
            
        }
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "spaceCell")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.section == lastCellNumber-1){
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "blankCell")
            return cell!
            
        }
        else{

        let cell = tableView.dequeueReusableCell(withIdentifier: "ResolutionCell") as! HomeTableViewCell

        cell.practiceTextLabel.text = practices[indexPath.row + indexPath.section].practice
            cell.layer.borderWidth = 0.5
            cell.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.4).cgColor
            cell.practiceIconImage.image = UIImage(named:practices[indexPath.row + indexPath.section].image_name!)
            let switchFlag = self.isSwitchOn(practice: practices[indexPath.row + indexPath.section], practicesData: practicesData)
            if (switchFlag != nil){
                
                cell.isOn = switchFlag!
                cell.activeButton(flag: switchFlag!)
                
            }else {
                cell.activeButton(flag: false)
            }
                
            cell.practice = practices[indexPath.row + indexPath.section]
            cell.selectedDate = datePicker.date.dateFormate()!

            return cell
            
        }
        
        
        
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        myIndex = indexPath.section
        performSegue(withIdentifier: "HomeToAddDataSague", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! addTodayViewController
        
        destination.userObject = userObject
        destination.myIndex = myIndex
        destination.selectedDate = datePicker.date.dateFormate()!
        destination.delegate = self
        
    }
    
    @IBAction func popUpCancelBtnTapped(_ sender: Any) {
        self.practiceTextfield.text = ""
        self.imageName = ""
        self.popUpDatePicker.date = Date()
        self.imageIconButton.setImage(UIImage(named: "Image-gallery"), for: .normal)
        self.popUpView.removeFromSuperview()
    }
    
    @IBAction func popUpAddButtonTapped(_ sender: Any) {
        
        
        let practice = practiceTextfield.text
        let image_Name = imageName
        
        if (practice == ""){
            
           showToast(message: "Please Enter Your Practice", duration: 3)
            
        }
        else if(image_Name == ""){
            
            showToast(message: "Please Select Icon For Practice", duration: 3)
            
        }
        else if(practiceStartedDate.text == ""){
            showToast(message: "Please Select Practice Starting Date", duration: 3)
        }
        else{
            var practiceFlag: Int!
            //////
            
            if(isUpdating){
                practiceFlag = dbHelper.updatePractice(oldPractice: oldPractice!, newPractice: practice!, image_name: image_Name, date: popUpDatePicker.date.dateFormate()!, user: userObject)
                isUpdating = false}
            else{
                practiceFlag = dbHelper.addPractices(practice: practice!, image_name: image_Name, date: popUpDatePicker.date.dateFormate()!, user: userObject)
                isUpdating = false
            }
            
        
        if(practiceFlag == 1){
            
            showAlert(title: "Warning", message: "Practice Already Exist. . . ", buttonTitle: "Try Again")
            
        }
        else if(practiceFlag == 2){
            
            showAlert(title: "Error", message: "Please Report an Error . . .", buttonTitle: "Try Again")
            
        }else if (practiceFlag == 0 ){
            self.refreshTableview(date: selectedDate)
            self.practiceTextfield.text = ""
            self.imageName = ""
            self.popUpDatePicker.date = Date()
            self.imageIconButton.setImage(UIImage(named: "Image-gallery"), for: .normal)
            self.popUpView.removeFromSuperview()
             
            showToast(message: "Data Add", duration: 3)
            
            }
            
        }
        
    }
    
    @IBAction func iconImageButtonTapped(_ sender: Any) {
        
        let actionSheet = UIAlertController(title: "Practice Icons", message: "Choose an Icon to Categories Your Practice", preferredStyle: .actionSheet)
        var no: Int = 0
        for icon in moreOptionIconList{
            
            
            let image = UIImage(named: icon)

            let action = UIAlertAction(title: icon, style: .default){action in self.changeResolutionIcon(imageName: icon)}
            action.setValue(image, forKey: "image")
             actionSheet.addAction(action)
        }

        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        if let popoverController = actionSheet.popoverPresentationController {
            popoverController.sourceView = self.view //to set the source of your alert
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0) // you can set this as per your requirement.
            popoverController.permittedArrowDirections = [] //to hide the arrow of any particular direction
        }
        
        present(actionSheet,animated: true)
        
    }
    
    func changeResolutionIcon(imageName: String){
        
        
        self.imageName = imageName
        imageIconButton.setImage(UIImage(named: imageName), for: .normal)
        
    }
    func refreshTableview(date: Date) {
        
        practices = dbHelper.getPractices(date: date, user: userObject)
        practicesData = self.getPracticesData(date: selectedDate)
        let oldestDate = dbHelper.oldestPracticeDate(user: userObject)
        self.datePicker.minimumDate = oldestDate
        self.homeTableView.reloadData()
        
        
        //showToast(message: "Data Saved Succefully", duration: 3)
                 
       

       
    }
    
    func isSwitchOn(practice: Practice, practicesData: [PracticeData]?) -> Bool? {

        if(practicesData != nil){
            for data in practicesData!{
                
                if data.practiceDataToPractice == practice{
                    
                    return data.practised
                    
                }
                
            }
        }
        return nil
    }
    
    

}



