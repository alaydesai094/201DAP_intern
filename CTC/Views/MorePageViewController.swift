//
//  MorePageViewController.swift
//  CTC
//
//  Created by Nirav Bavishi on 2019-01-21.
//  Copyright © 2019 Nirav Bavishi. All rights reserved.
//

import UIKit

class MorePageViewController: UIViewController {
    
    let moreOptionList = ["Practice History", "FAQ", "About Us", "How To Use The App","Join Our Facebook Community","201 Day Achievement Principle Book and Journal", "Logout", ""]
    let moreOptionIconList = ["History", "FAQ", "Aboutus", "User-Manual", "facebook", "Book-Journal", "Logout", ""]
    
    var dbHelper: DatabaseHelper!
    var userObject: User?
    
    var fbURLWeb: NSURL = NSURL(string: "https://www.facebook.com/groups/375234539714492/")!
    var fbURLID: NSURL = NSURL(string: "fb://profile/719245588122387")!
    
    var bookWebsiteURL = NSURL(string: "https://www.201dayachievementprinciple.com/")!
   

    override func viewDidLoad() {
        super.viewDidLoad()
        dbHelper = DatabaseHelper()
        userObject = dbHelper.checkLoggedIn()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MorePageViewController : UITableViewDelegate, UITableViewDataSource{
    
    
//    //here
//    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//
//        if section == 0{
//
//            return 30
//
//        }
//        else{
//
//            return 10
//
//        }
//    }
//
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        return Resolutions.count
//    }
//
//    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "spaceCell")
//
//
//        return cell
//    }
//    ////here
//
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return moreOptionIconList.count
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            
                        return 30
            
                    }
                    else{
            
                        return 10
            
                    }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "morePageCell") as! MorePageTableViewCell
        
        cell.optionIconImageView.image = UIImage(named: moreOptionIconList[indexPath.row + indexPath.section])
        cell.optionLabel.text = moreOptionList[indexPath.row + indexPath.section]
        
        print(moreOptionList.endIndex)
        print(indexPath.section)
        
        if moreOptionList.endIndex-1 == indexPath.section{
            
            cell.accessoryType = .none
            
        }
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        print("section : \(indexPath.section)")
        print(moreOptionIconList.count-1)
        print(moreOptionList[indexPath.section])
        switch moreOptionList[indexPath.section] {
        case "Practice History":
            performSegue(withIdentifier: "moreToHistorySegue", sender: self)
            break
        case "FAQ":
            performSegue(withIdentifier: "FAQSegue", sender: self)
           break
        case "E-Books":
            break
        
        case "About Us":
            performSegue(withIdentifier: "aboutUsSegue", sender: self)
            break
        case "How To Use The App":
            performSegue(withIdentifier: "welcomePageSegue", sender: self)
            break
        case "Help":
            performSegue(withIdentifier: "helpSegue", sender: self)
            break
            
        case "Join Our Facebook Community":
            if(UIApplication.shared.canOpenURL(fbURLID as URL)){
                // FB installed
                UIApplication.shared.open(fbURLID as URL)
            } else {
                // FB is not installed, open in safari
                UIApplication.shared.open(fbURLWeb as URL)
            }

            break
        
        case "201 Day Achievement Principle Book and Journal":
            UIApplication.shared.open(bookWebsiteURL as URL)
        break
            
        case "Logout":
            if(userObject != nil){
                
                let resultFlag = dbHelper.updateLoginStatus(status: false, email: (userObject?.email)!)
                if (resultFlag == 0){
                    let alert = UIAlertController(title: "Logout", message: "Are you sure you want to Logout?", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action:UIAlertAction) -> Void in
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "newLoginOptions") as! LoginViewController
                        self.present(vc, animated: true, completion: nil)
                    }))
                    
                    alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
                    
                    present(alert, animated: true, completion: nil)
            
                }else{

                    showAlert(title: "Error", message: "Failed to update login status try again.", buttonTitle: "Try Again")

                }
            
            }
        else{

                showAlert(title: "Error", message: "User not found.", buttonTitle: "Try Again")

            }
            break
            
        default:
            break
        }
        
        
        
        if indexPath.section == moreOptionIconList.count-2{
        }
        
    }
    
    
    
    
}
