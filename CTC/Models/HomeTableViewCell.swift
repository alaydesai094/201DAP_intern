//
//  HomeTableViewCell.swift
//  CTC
//
//  Created by Nirav Bavishi on 2019-01-18.
//  Copyright © 2019 Nirav Bavishi. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var practiceTextLabel: UILabel!
    @IBOutlet weak var practiceIconImage: UIImageView!
    
    @IBOutlet weak var yesNoSwitch: UISwitch!
    
    @IBOutlet weak var starButton: UIButton!
    
    
    
    
    // variables
    
    var dbHelper: DatabaseHelper!
    var resultFlag: Int!
    var practice: Practice!
    var selectedDate: Date!
    var view: UIView!
    var isOn: Bool = false
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.white
        
        dbHelper = DatabaseHelper()
        
    }
   

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func yesNoSwitchTapped(_ sender: Any) {
        
        if(yesNoSwitch.isOn == true){
            resultFlag = dbHelper.addPracticeData(practised: true, practice: practice, date: selectedDate)
            

        }
        else {
             resultFlag = dbHelper.addPracticeData(practised: false, practice: practice, date: selectedDate)
            
            yesNoSwitch.tintColor = UIColor.red
            yesNoSwitch.layer.cornerRadius = yesNoSwitch.frame.height / 2
            yesNoSwitch.backgroundColor = UIColor.red
        }
        
        if resultFlag == 0{
            
           showToast(message: "Data Saved", duration: 3,view: view)
            print("Data Saved")
            
        }else if resultFlag == 1{
            print("error in Cell Data Saving")
           showAlert(title: "Error", message: "Data saving error please try againm", buttonTitle: "Try Again")
            
        }
        
    }
    
    
    
    @IBAction func starButtonTapped(_ sender: Any) {
        
        self.activeButton(flag: !isOn)
         resultFlag = dbHelper.addPracticeData(practised: isOn, practice: practice, date: selectedDate)
        if resultFlag == 0{
            
           // showToast(message: "Data Saved", duration: 3,view: view)
            print("Data Saved")
            
        }else if resultFlag == 1{
            //print("error in Cell Data Saving")
            //showAlert(title: "Error", message: "Data saving error please try againm", buttonTitle: "Try Again")
            
        }

    }
    
    func activeButton(flag: Bool){
        
        isOn = flag
        if(isOn){
            starButton.setImage(UIImage(named: "Star-Selected"), for: .normal)
       
         
        }else{
            
            starButton.setImage(UIImage(named: "Star"), for: .normal)
         
        }
    }
    
   
    
    
    
}
