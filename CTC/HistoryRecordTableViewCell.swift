//
//  HistoryRecordTableViewCell.swift
//  CTC
//
//  Created by Nirav Bavishi on 2019-03-08.
//  Copyright © 2019 Nirav Bavishi. All rights reserved.
//

import UIKit
import CoreData

class HistoryRecordTableViewCell: UITableViewCell,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    let no = [1,2,3,4]
    var noOfPages: Int!
    var historyData: [PracticeHistory]?
    var historyCell = HistoryCardCollectionViewCell()
    
    var dbHelper: DatabaseHelper!
    var selectedDate: Date!
  
    var userObject: User!
    var practices:[Practice]!
    var practicesData: [PracticeData]!
   
    
    @IBOutlet weak var CardPageControl: UIPageControl!
    
    @IBOutlet weak var HistoryCollectionView: HistoryCardCollectionView!
    
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        HistoryCollectionView.delegate = self
        HistoryCollectionView.dataSource = self
        
        
    }
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
   
    
    @IBAction func nextPageButtonTapped(_ sender: Any) {
        
        let nextIndex = min(CardPageControl.currentPage + 1, noOfPages-1)
        print("Next index : \(nextIndex)")
        let indexPath = IndexPath(item: nextIndex, section: 0)
        print("index Path:  \(indexPath)")
        CardPageControl.currentPage = nextIndex
        HistoryCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        
    }
    
    @IBAction func prevPageButtonTapped(_ sender: Any) {
        
        let prevIndex = max(CardPageControl.currentPage - 1, 0)
        let indexPath = IndexPath(item: prevIndex, section: 0)
        CardPageControl.currentPage = prevIndex
        HistoryCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        
    }
    
    @IBAction func restoreButton(_ sender: Any) {
        let section = (sender as AnyObject).tag / 100
        let item = (sender as AnyObject).tag % 100
        let indexPath = IndexPath(item: item, section: section)
        
        let cell = HistoryCollectionView.cellForItem(at: indexPath) as! HistoryCardCollectionViewCell
        let practiceName = cell.PracticeNameLabel.text!
       
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PracticeHistory")
        
        do{
            let result = try managedContext.fetch(fetchRequest)
            
            for data in result as! [NSManagedObject] {
                
                print("data: \(data)")
                print("Data is \(practiceName)")
                let value = data.value(forKey: "practice_name") as! String
                if value.isEqual(practiceName){
                    print("Restore this data.")
                
                    let pracData = data as! PracticeHistory
                    self.delPractice(prac: pracData)
                   
                }
               
            }
        }
        catch{
            print("Failed")
        }

    }
    
    func delPractice(prac: PracticeHistory){
        
        let pracName = prac.practice_name
       
        let date = Date().dateFormate()!
      
            try dbHelper.restorePracticeHistory(practiceHistory: prac)
       
        let resultFlag = dbHelper.restorePracticeHistory(practice: pracName!, image_name: "", date: date, user: userObject)
        
        if(resultFlag == 0){
            print("deleted")
            //showToast(message: "\(pracName!) Deleted", duration: 3, view: <#UIView#>)
        }else{
            print("error")
            //showToast(message: "Deletion Error", duration: 3, view: <#UIView#>)
        }
        
        self.refreshTableview(date: selectedDate)
        
    }
    
    func refreshTableview(date: Date) {
        
        practices = dbHelper.getPractices(date: date, user: userObject)
        practicesData = self.getPracticesData(date: selectedDate)
       
        self.HistoryCollectionView.reloadData()
        
    }
    
    private func getPracticesData(date: Date) -> [PracticeData]?{
        
        return dbHelper.getPracticeDataByDate(date: date.dateFormate()!)
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return historyData!.count
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCollectionCell", for: indexPath) as! HistoryCardCollectionViewCell
        cell.backgroundColor = .gray

        print("index path in function : \(indexPath)")
       
        let history = historyData![indexPath.item]
        
        
        var statusString = history.com_del_flag == true ? "Completed On : " : "Deleted On : "
        statusString = statusString + "\(((history.date!) as Date).dateFormateToString()!)"
        let trackingDays = history.td
        let daySinceStarted = history.dss

        let percentage = (Float(trackingDays) / Float(daySinceStarted == 0 ? 1 : daySinceStarted)) * 100
        
      

        cell.PracticeNameLabel.text = history.practice_name
        cell.statusLabel.text = statusString
        cell.percentageLabel.text = "Your Score : \(Int(percentage))"
        cell.percentageProgressView.progress = percentage / 100
        cell.totalDaysLabel.text = "\(daySinceStarted)"
        cell.trackingDaysLabel.text = "\(trackingDays)"
        
        return cell
        
    }
 
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let x = targetContentOffset.pointee.x
        
        CardPageControl.currentPage = Int(x / HistoryCollectionView.frame.width)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
}
