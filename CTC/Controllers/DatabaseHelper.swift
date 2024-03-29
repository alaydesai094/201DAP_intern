//
//  DatabaseHelper.swift
//  CTC
//
//  Created by Nirav Bavishi on 2019-02-06.
//  Copyright © 2019 Nirav Bavishi. All rights reserved.
//

// The App Uses Core Data for storing All the data and following is DbHelper for the same.1


import Foundation
import CoreData
import UIKit



class DatabaseHelper{
    
    let context: NSManagedObjectContext?
    var view: UIView!
    
    init() {
        
        context = (UIApplication.shared.delegate  as? AppDelegate)?.persistentContainer.viewContext
        
    }
    
    
  // Getting Practice Final Date and Weekly progress data from the Core Database
    
    func getPracRecordTemp(user: User) -> [Date: [AnyObject]]? {
        
        let practices = getPractices(user: user)
        let weeklyPracticedData = getPracticeWeeklyData()!
        
        
        var finalData: [Date: [AnyObject]] = [:]
        
        for prac in practices!{
            let practiceData = getPracticebyName(practice: prac)
            let practiceDateArray = (prac.startedday! as Date).getDates(date: Date())
            for pracData in practiceData!{
                
                for dateObj in practiceDateArray{
                    
                    let pracDate = pracData.date! as Date
                    
                    if(dateObj == pracDate){
                        
                        if(finalData[dateObj] != nil){
                        
                        finalData[dateObj]?.append(pracData)
                        
                    }else{
                        
                            finalData[dateObj] = [pracData]
                        
                    }
                    }
                    
                }
                
            }
            
            // Weekly Data
            
            let weeklyData = getPracticeWeeklyData(practiceName: prac.practice!)
            
            for weekData in weeklyData!{
                
                let weekDataDate = weekData.start_date! as Date
                for dateObj in practiceDateArray{
                    
                    if(dateObj == weekDataDate){
                        
                        if(finalData[dateObj] != nil){
                            
                            finalData[dateObj]?.append(weekData)
                            
                        }else{
                            
                            finalData[dateObj] = [weekData]
                            
                        }
                        
                        
                    }
                    
                }
                
                
                
            }
            
        }
        
        return finalData
        
    }
    
    //Adding Practice Final Date and Weekly progress data into Buffer
    
    func getPracticeRecords(user: User) ->  [String: [ [String: String?] ] ]? {
        
        getPracRecordTemp(user: user)
        
        var finalDateArray = [String:[[String:String?]]]()
        
        let practices = getPractices(user: user)
        finalDateArray = [String: [ [String:String?] ] ]()

        let weeklyPracticedData = getPracticeWeeklyData()!
        
        for practice in practices!{
            
            
            let practiceData = getPracticebyName(practice: practice)
            let practiceDateArray = (practice.startedday! as Date).getDates(date: Date())
            var bufferData = [[String: String?]]()
            var bufferWeeklyData = [[String: String?]]()
            
            for practiceDataObject in practiceData!{
                
                for dateObject in practiceDateArray{
                    
                    let dateOfObject = dateObject.dateFormateToString()
                    let dateOfData = (practiceDataObject.date! as Date).dateFormateToString()
                    
                    if(dateOfObject == dateOfData){
                        
                        if(finalDateArray[dateOfData!]?.count != nil){
                            bufferData = finalDateArray[dateOfData!]!
                            
                            bufferData.append( ["Practice" : practice.practice,"Note" : practiceDataObject.note, "TrackingDay" : String(practiceDataObject.tracking_days), "Practiced" : String(practiceDataObject.practised),
                                                "CellType" : "1"
                                ])
                   
                            finalDateArray[dateOfData!] = (bufferData)
                       
                        }else{
                            
                            bufferData = [( ["Practice" : practice.practice,"Note" : practiceDataObject.note, "TrackingDay" : String(describing: practiceDataObject.tracking_days), "Practiced" : String(practiceDataObject.practised),
                                             "CellType" : "1"
                                ])]
                     
                            finalDateArray[dateOfData!] = (bufferData)
                            
                        }
                    }
                    
                }
                
            }
            
        
        }


        // practice Buffer Dict
        
        for (key, val) in finalDateArray{
            
            print("Key = \(key)")
            for valu in val{
                
                print("\(valu)")
            }
            
        }
        return finalDateArray
        
    }
    

// -------------------------------------------------------------------------------------
// MARK: User class
//--------------------------------------------------------------------------------------
    
    
    // Adding User to the core Database
    
    func addUser(name: String, email: String, password: String) -> Int{
        
        // Check if the user is already exists in the Database
        
        let users = getUser()
        var userNotExist: Bool = true
        
        for user in users{
            
            if(user.email == email){
                userNotExist = false
                
            }
            
        }
        
       
        // Add User to the Database
        
        if(userNotExist){
            
            
            let newUser = NSEntityDescription.insertNewObject(forEntityName: "User", into: context!) as! User
            
            newUser.name = name
            newUser.email = email
            newUser.password = password
            
            do {
                try context?.save()
            } catch let err {
                print(err)
                return 2
            }
            print("User \(name) added")
            return 0
        }else {
            
            print("User Exist")
            return 1
            
        }
        
    }
    
     //--------------------
    // Check Password
    //--------------------
    
    func passwordCheck(email: String, password: String) -> Bool {
        
        var users:[User]?
        
        let featchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        featchRequest.predicate = NSPredicate(format: "email = %@ && password =%@", argumentArray: [email,password])
        
        do {
            users = try (context?.fetch(featchRequest) as? [User])!
            if users?.count == 0{
                return false
            }else{
                return true
            }
            
        } catch let err {
            print(err)
        }
        
        return false
        
    }
    
    // --------------
    // Update User
    //---------------
    
    func updateUser(oldEmail: String,newEmail: String, name: String, dob: String, password: String) -> Int {
        
        let userObject = getUser(email: oldEmail)
        
        userObject.name = name
        userObject.email = newEmail
        userObject.dob = dob
        userObject.password = password
        
        do {
            try context?.save()
        } catch let err {
            print(err)
            return 1
        }
        print("User \(name) Updated. . .")
        return 0
        
    }
    
    // ---------------------
    // Update User Password
    //----------------------
    
    func updatePassword(oldEmail: String,newEmail: String, password: String) -> Int {
        
        let userObject = getUser(email: oldEmail)
        
        userObject.email = newEmail
        userObject.password = password
        
        do {
            try context?.save()
        } catch let err {
            print(err)
            return 1
        }
        print("Password changed. . .")
        return 0
        
    }
    
    // MARK: User Functions
    
    // Get User Data
    
    func getUser() -> [User]{
        
        var users = [User]()
        
        
        let featchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        
        do {
            users = try (context?.fetch(featchRequest) as? [User])!
            
        } catch let err {
            print(err)
        }
        
        return users
    }
    
        // Get User Email
    
    func getUser(email: String) -> User{
        
        var users: [User]!
        
        
        let featchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        featchRequest.predicate = NSPredicate(format: "email = %@", argumentArray: [email])
        
        do {
            users = try (context?.fetch(featchRequest) as? [User])!
            
        } catch let err {
            print(err)
        }
        
        return users[0]
    }
    
        // Check if User already Logged in
    
    func checkLoggedIn() -> User!{
        
        let users = getUser()
        
        for user in users{
            
            if user.isloggedin == true{
                return user
            }
            
        }
        return nil
    }
         // Forget Password validation
    
    func forgotPassword(email: String) -> Bool{
        let users = getUser()
        var fp: Bool = true
        
            for user in users{
                
                if user.email == email{
                    
                    fp = true
                }
                else {
                    
                    fp = false
                }
            }
        
        return fp
    }
    
    // Check Login Status
    
    func updateLoginStatus(status: Bool, email: String) -> Int{
        
        let users = getUser()
        for user in users {
            
            if user.email == email{
                
                user.isloggedin = status
                do {
                    try context?.save()
                    return 0
                } catch let err {
                    print(err)
                    return 1
                }
            }
            
        }
        return 0
    }
    
    

  
   //------------- //User Ends here //--------------------------------
    
    
    
    
    //---------------------------------------------------------------------------------
    //MARK: Practice Functions
    //----------------------------------------------------------------------------------
    
    //------------------
    // Add Practice
    //------------------
    
    func addPractices(practice: String, image_name: String,date: Date, user: User) -> Int {
        
       // Check if the practice Exists or not
        
        let practices = getPractices(user: user)!
        var practiceNotExist = true
        
        for practiceData in practices{
           
            if(practiceData.practice == practice){
                
                practiceNotExist = false
            }
        }
        
        // Add practice if not found
        
        if(practiceNotExist){
            
            
            let newPractice = NSEntityDescription.insertNewObject(forEntityName: "Practice", into: context!) as! Practice
            
            newPractice.practice = practice
            newPractice.image_name = image_name
            newPractice.percentage = 0
            newPractice.startedday = date as NSDate
            newPractice.practiseddays = 0
            newPractice.user = user
            
            do {
                try context?.save()
            } catch let err {
                print(err)
                return 2
            }
            print("User \(practice) added")
            return 0
        }else {
            
            print("Practice Exist")
            return 1
            
        }
    }
    
    //----------------------------
    // Restore Deleted Practice
    //---------------------------
    
    
    func restorePracticeHistory(practice: String, image_name: String,date: Date, user: User) -> Int {
        
        // Check if the practice Exists or not
        
        let practices = getPractices(user: user)!
        var practiceNotExist = true
        
        for practiceData in practices{
            
            if(practiceData.practice == practice){
                
                practiceNotExist = false
            }
        }
        
        // Add practice back
        
        if(practiceNotExist){
            
            
            let newPractice = NSEntityDescription.insertNewObject(forEntityName: "Practice", into: context!) as! Practice
            
            newPractice.practice = practice
            newPractice.image_name = image_name
            newPractice.percentage = 0
            //            let date5 = DateComponents(calendar: .current, year: 2019, month: 2, day: 27).date!
            newPractice.startedday = date as NSDate
            newPractice.practiseddays = 0
            newPractice.user = user
            
            do {
                try context?.save()
            } catch let err {
                print(err)
                return 2
            }
            print("User \(practice) added")
            return 0
        }else {
            
            print("Practice Exist")
            return 1
            
        }
    }
    
    //-------------------
    // Edit Practice
    //-------------------
    
    func updatePractice(oldPractice: String, newPractice: String,image_name: String,date: Date, user: User) -> Int {
        
        let practiceObject = getPractices(practiceName: oldPractice, user: user)
        
        practiceObject.practice = newPractice
        practiceObject.image_name = image_name
        practiceObject.startedday = date as NSDate
        practiceObject.user = user
        
        do {
            try context?.save()
        } catch let err {
            print(err)
            return 2
        }
        print("User \(newPractice) Updated")
        return 0
    }
    
    //---------------------------------------------
    // Fetch Practice from the Database
    //-------------------------------------------
    
    func getPractices(user: User) -> [Practice]? {

        var practices = [Practice]()

        // fetch data code

        let featchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Practice")
        featchRequest.predicate = NSPredicate(format: "user.email = %@ && is_deleted = %@ && is_completed = %@", argumentArray: [user.email!,false,false])
        featchRequest.sortDescriptors = [NSSortDescriptor(key: "startedday", ascending: true)]

        do {
            practices = try (context?.fetch(featchRequest) as? [Practice])!

            return practices


        } catch let err {
            print(err)
        }

        return practices

    }
//
    func getPractices(date: Date, user: User) -> [Practice]? {

        var practices : [Practice] = []


        let featchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Practice")
        featchRequest.predicate = NSPredicate(format: "user.email = %@ && is_deleted = %@ && is_completed = %@", argumentArray: [user.email!,false,false])
        featchRequest.sortDescriptors = [NSSortDescriptor(key: "startedday", ascending: true)]

        do {
           let practicesobjects = try (context?.fetch(featchRequest) as? [Practice])!

            for prac in practicesobjects{
                let pracDate = prac.startedday! as Date
                if(pracDate <= date){

                    practices.append(prac)

                }

            }

            return practices


        } catch let err {
            print(err)
        }

        return practices

    }


    func getPractices(practiceName: String, user: User) -> Practice {

        var practiceData : Practice!


        let featchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Practice")
        featchRequest.predicate = NSPredicate(format: "user.email = %@ && practice = %@ && is_deleted = %@ && is_completed = %@", argumentArray: [user.email!, practiceName, false, false])
        featchRequest.sortDescriptors = [NSSortDescriptor(key: "startedday", ascending: true)]

        do {
            let bufferArray = try (context?.fetch(featchRequest) as? [Practice])!

            for data in bufferArray{

                practiceData = data

            }

            //            print(practiceData)

        } catch let err {
            print(err)
        }

        return practiceData

    }
    //----------------------------------
    
    
    
    
    //--------------------------
    // Update Practice
    //-------------------------
    
    func updatePracticedDay(noOfDays: Int, practiceName: String, user: User){
        
        let practices = getPractices(practiceName: practiceName, user: user)
        
        
        practices.practiseddays = Int32(noOfDays)
        
        do {
            try context?.save()
            print("Practice \(practiceName) Updated")
            
        } catch let err {
            print(err)
            
        }
        
    }
    
    //--------------------------
    // Delete Practice
    //-------------------------
    
    func deletePractice(practiceName: String, user: User) -> Int {
        
        let practice = getPractices(practiceName: practiceName, user: user)
        
        practice.is_deleted = true
        do {
            try context?.save()
            print("Practice \(practiceName) Updated")
            
        } catch let err {
            print(err)
            return 1
            
        }
        return 0
        
    }
    
    
    func deletePractice(practice: Practice) {
        
        context?.delete(practice)
        
    }
    
    //------------------------------
     // Restore Practice History
     //-----------------------------
    
    func restorePracticeHistory(practiceHistory: PracticeHistory) {
        
        context?.delete(practiceHistory)
        do{
           try context?.save()
            print("deleted")
        }
        catch let err{
            print(err)
           
        }
        
    }
    
    //---------------------------
    // oldestPracticeDate
    //----------------------------
    
    func oldestPracticeDate(user: User) -> Date {
        
        let practicesData = getPractices(user: user)
        var oldestDate : Date = Date()
        for pracData in practicesData!{
            let pracDate = pracData.startedday! as Date
            if(pracDate < oldestDate){
                oldestDate = pracDate
            }
            
        }
        return oldestDate
    }
    
//------------- // Practices class Ends //--------------------------------
    
    
    
    //------------------------------------------------------------------
    //MARK: Daily Practice Data
    //-----------------------------------------------------------------
    
    
    
    //---------------------------
    // Add Daily Practice Data
    //---------------------------
    
    func addPracticeData(note: String, practised: Bool, practice: Practice, date: Date) -> Int {
        let resultFlag = maintainTrackingDay(date: date, flag: practised, practice: practice)
        
        print(resultFlag ? "Trakcing Day Maintened Successfully" : "Error in Maintenance Tracking Days")
        
        var practicePracticedDays = practice.practiseddays

        
        var trackingDays = (getTrackingDay(practice: practice, date: date)) ?? 0
        
        let lasrDayData = getPracticeDataByDateAndName(date: date.dateFormate()!, practiceName: practice.practice!)
        
        if lasrDayData != nil{
            
            trackingDays = lasrDayData!.tracking_days
            
            
                
                if (practised == true && lasrDayData?.practised == false){
                    trackingDays = (trackingDays) + 1
                    practicePracticedDays = practicePracticedDays + 1
                }else if (practised == false && lasrDayData?.practised == true){
                    trackingDays = trackingDays - 1
                    practicePracticedDays = practicePracticedDays - 1
                }
                lasrDayData!.practised = practised
                lasrDayData?.note = note
                lasrDayData!.practiceDataToPractice = practice
                lasrDayData!.tracking_days = (trackingDays)
                updatePracticedDay(noOfDays: Int(practicePracticedDays), practiceName: practice.practice!, user: practice.user!)
                do{
                    try context?.save()
                }
                catch let err{
                    print(err)
                    return 1
                }
        }
        else{
            
            let newPracticesData = NSEntityDescription.insertNewObject(forEntityName: "PracticeData", into: context!) as! PracticeData
            
            newPracticesData.date = date.dateFormate()! as NSDate
            newPracticesData.note = note
            newPracticesData.practised = practised
            newPracticesData.practiceDataToPractice = practice
            
            if(practised == true)
            {
                trackingDays = trackingDays + 1
                practicePracticedDays = practicePracticedDays + 1
            }
            newPracticesData.tracking_days = trackingDays
            if (practised){
                updatePracticedDay(noOfDays: Int(practicePracticedDays), practiceName: practice.practice!, user: practice.user!)
            }
            
            do{
                try context?.save()
                return 0
            }
            catch let err{
                print(err)
                return 1
            }
            
        }
        
        return 0
        
    }
    
    func addPracticeData(practised: Bool, practice: Practice, date: Date) -> Int {
        let resultFlag = maintainTrackingDay(date: date, flag: practised, practice: practice)
        var practicePracticedDays = practice.practiseddays
        
        print(resultFlag ? "Trakcing Day Maintened Successfully" : "Error in Maintenance Tracking Days")
        
        var trackingDays = (getTrackingDay(practice: practice, date: date) ?? 0)
        
        let lasrDayData = getPracticeDataByDateAndName(date: date.dateFormate()!, practiceName: practice.practice!)
       
        if lasrDayData != nil{
            
            trackingDays = lasrDayData!.tracking_days

            
                if (practised && lasrDayData?.practised == false){
                    trackingDays += 1
                    practicePracticedDays = practicePracticedDays + 1
                }else if (practised == false && lasrDayData?.practised == true){
                    trackingDays -= 1
                    practicePracticedDays = practicePracticedDays - 1
                }
                lasrDayData!.practised = practised
                lasrDayData!.practiceDataToPractice = practice
                lasrDayData!.tracking_days = Int32(trackingDays)

                do{
                    try context?.save()
                }
                catch let err{
                    print(err)
                    return 1
                }

        }
        else{
            
            let newPracticesData = NSEntityDescription.insertNewObject(forEntityName: "PracticeData", into: context!) as! PracticeData
            

            newPracticesData.date = date.dateFormate()! as NSDate
            newPracticesData.practised = practised
            newPracticesData.practiceDataToPractice = practice
            
            if(practised == true){

                trackingDays = trackingDays + 1
                practicePracticedDays = practicePracticedDays + 1
            }
            
            newPracticesData.tracking_days = trackingDays
            if (practised){
               
            }
            
            do{
                try context?.save()
                
            }
            catch let err{
                print(err)
                return 1
            }
            
        }
        let finalTrackingDay = getTrackingDay(practice: practice)
        updatePracticedDay(noOfDays: Int(practicePracticedDays), practiceName: practice.practice!, user: practice.user!)
        
        
      
        
        return 0
        
    }
    
    func getTrackingDay(practice: Practice,date: Date) -> Int32? {
        
        let startingDate = practice.startedday
     
        var dateArray = (startingDate! as Date).getDates(date: date)
        dateArray =  dateArray.sorted(by: >)
        for eachDate in dateArray{
            let lastDayData = getPracticeDataByDateAndName(date: eachDate.dateFormate()!, practiceName: practice.practice!)
            if(lastDayData != nil){
                return (lastDayData?.tracking_days)
            }
        }
        return 0
    }
    func getTrackingDay(practice: Practice) -> Int32? {
        
        let startingDate = practice.startedday
       
        var dateArray = (startingDate! as Date).getDates(date: Date())
        dateArray =  dateArray.sorted(by: >)
        for eachDate in dateArray{
            let lastDayData = getPracticeDataByDateAndName(date: eachDate.dateFormate()!, practiceName: practice.practice!)
            if(lastDayData != nil){
                return (lastDayData?.tracking_days)
            }
        }
        return 0
    }
    
    func getPracticeDataByDateAndName(date: Date, practiceName: String) -> PracticeData? {
        
        var lastDayData : PracticeData!
        
        let dataArray = getPracticeDataByDate(date: date)
        
        if(dataArray != nil){
            for data in dataArray!{
                
                if(data.practiceDataToPractice?.practice == practiceName){
                    
                    lastDayData = data
                   
                }
            }
        }
        return lastDayData
    }
    
    
    func getPracticeDataByDate(date: Date) -> [PracticeData]?{
        
        var arrayReturn: [PracticeData]?
        
        let fearchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PracticeData")
        fearchRequest.returnsObjectsAsFaults = false
        fearchRequest.predicate = NSPredicate(format: "date = %@", argumentArray: [date])
        
        do {
            let arrayData = try (context?.fetch(fearchRequest)) as! [PracticeData]
            //            print(arrayData)
            arrayReturn = arrayData
        } catch let err {
            print(err)
        }
        
        return arrayReturn
    }
    
    func getPracticeData(user: User) -> [PracticeData]?{
        
        var arrayReturn: [PracticeData]?
        
        let fearchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PracticeData")
        fearchRequest.returnsObjectsAsFaults = false
        fearchRequest.predicate = NSPredicate(format: "practiceDataToPractice.user = %@", argumentArray: [user])
        
        do {
            let arrayData = try (context?.fetch(fearchRequest)) as! [PracticeData]
    
            arrayReturn = arrayData
            
        } catch let err {
            print(err)
        }
        
        
        
        return arrayReturn
    }
    
    
    func getPracticebyName(practice: Practice) -> [PracticeData]? {
        
        let featchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PracticeData")
        featchRequest.predicate = NSPredicate(format: "practiceDataToPractice = %@", argumentArray: [practice])
        
        do {
            let dataArray = try (context?.fetch(featchRequest) as? [PracticeData])!
          
            return dataArray
            
        } catch let err {
            print(err)
        }
        
        return nil
        
    }
    
    func updatePracticeData(practiceName: String, practiceDate: Date, note: String, practiced: Bool ) -> Int {
        
        
        let updateData = getPracticeDataByDateAndName(date: practiceDate, practiceName: practiceName)
        
        var trackingDay = updateData?.tracking_days
        
        if (practiced && updateData?.practised == false){
            trackingDay = trackingDay! + 1
        }else if (practiced == false && updateData?.practised == true){
            trackingDay = trackingDay! - 1
        }
        updateData?.tracking_days = trackingDay!
        updateData?.note = note
        updateData?.practised = practiced
        
        
        do {
            try context?.save()
        } catch let err {
            print(err)
            return 1
        }
        print("User \(practiceName) on \(practiceDate) Updated. . .")
        return 0
        
    }
    
    
    func maintainPracticeDataWeekly(user: User){
        
        let practiceData = getPracticeData(user: user)
        let practice = getPractices(user: user)
        print(practiceData!)
        let oldDate = oldestPracticeDataDate(practiceData: practiceData!)
        let dayOfWeek = Date().getDayOfWeek()
        var dateArray = oldDate.getDates(date: Date())
        dateArray =  dateArray.sorted(by: <)
        var finalEndDate : Date?
        
        
        
        if(dayOfWeek == 6){
            
            let noOfDays = Date().days(from: oldDate)
            let noOfWeeks = Float(noOfDays) / 7.0
            
            var dictTemp : [[String : String]] = []
            var totalNoOfDays : Int = 0
            var totalNoOfDaysPractice : Int = 0
            var weekStartDate : Date!
            var weekEndDate : Date!
            
            if(noOfWeeks >= 4.0){
                
                let restWeeks = noOfWeeks - 4.0
                let restDays = Int(restWeeks * 7.0)
            
            
                for prac in practice!{
                    weekStartDate = prac.startedday as Date?
                    let pracName = prac.practice!
                    totalNoOfDays = 0
                    totalNoOfDaysPractice = 0
                    
                    for i in 0...restDays{

                        let dateObject = dateArray[i]
                
                        for pracData in practiceData! {
                            let pracDataName = pracData.practiceDataToPractice?.practice
                            
                            let pracDate = (pracData.date! as Date)
                            if(pracName == pracDataName){
                                
                                let dayNo = dateObject.getDayOfWeek()
                                if(dayNo == 1){
                                    weekStartDate = dateObject}
                                if(pracDate == dateObject){
                                    totalNoOfDays += 1
                                    
                                    if(pracData.practised){
                                        totalNoOfDaysPractice += 1
                                    }
                                    
                                    
                                    
                                    if(dayNo == 7){
                                        weekEndDate = dateObject
                                        finalEndDate = dateObject
                                        
                                        let result = addPracticeWeeklyData(practiceName: pracName, totalNoOfDaysPracticed: totalNoOfDaysPractice, totalNoOfDays: totalNoOfDays, startDay: weekStartDate, endDate: weekEndDate)
                                        
                                        totalNoOfDaysPractice = 0
                                        totalNoOfDays = 0
                                        
                                       
                                        if(result == 0 ){
                            
                                            
                                        }else{
                                            print("Error in Weekly Data adding")
                                        }
                                        
                                    }
                                    
                                }
                                    
                               
                            }
                            
                          
                            
                           
                        }
                      
                    }
                    
                 
                    
                }
            
            if(finalEndDate != nil){
            
            var delPracArray : [PracticeData]? = []
            for prac in practice!{
                
                let deletedDateArray = (prac.startedday! as Date).getDates(date: finalEndDate!)
                for date in deletedDateArray {
                    
                    for pracData in practiceData!{
                        if(pracData.date! as Date == date && pracData.practiceDataToPractice! == prac){
                            delPracArray?.append(pracData)
                        }
                    }
                    
                }
                
            }
            deletePracticeData(practicesData: delPracArray!)
            }
            }
            
            
        }
        
    }
    
    func deletePracticeData(practicesData: [PracticeData]!) {
        
        for delprac in practicesData{
        context?.delete(delprac)
        }
            
        do {
            try context?.save()
        } catch let err {
            print(err)
            
        }
        
        
    }
    
    func oldestPracticeDataDate(practiceData : [PracticeData]) -> Date {

        let practicesDate = practiceData
        var oldestDate : Date = Date()
        for prac in practicesDate{
            let pracDate = prac.date! as Date
            if(pracDate < oldestDate){
                oldestDate = pracDate
            }

        }
        return oldestDate
    }
    
    
    //MARK: Practice Data class over
    //-------------------------------------------------------------------------------------------------------------------------------
    
    //MARK: Practice History class
    //-------------------------------------------------------------------------------------------------------------------------------
    
    func addPracticeHistory(practiceName: String, comDelFlag: Bool, date: Date, dss: Int, td: Int) -> Int {
        let newHistory = NSEntityDescription.insertNewObject(forEntityName: "PracticeHistory", into: context!) as! PracticeHistory
        
        newHistory.practice_name = practiceName
        newHistory.com_del_flag = comDelFlag
        newHistory.date = date as NSDate
        newHistory.dss = Int32(dss)
        newHistory.td = Int32(td)
        
        
        
        do {
            try context?.save()
        } catch let err {
            print(err)
            return 1
        }
        
        return 0
    }
    
    func getPracticeHistory() -> [PracticeHistory]? {
        
        let featchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PracticeHistory")
        featchRequest.returnsObjectsAsFaults = false
        
        do {
            let dataArray = try (context?.fetch(featchRequest) as? [PracticeHistory])!
            //            print("Get practice data-----------------------------")
            //            print(dataArray)
            return dataArray
            
        } catch let err {
            print(err)
        }
        
        return nil
        
    }
    
    func maintainTrackingDay(date: Date, flag: Bool, practice: Practice) -> Bool {
        
        var dateArray = date.getDates(date: Date())
        dateArray.remove(at: 0)
        
        for tempDate in dateArray{
            
            let pracData = getPracticeDataByDate(date: tempDate)
            if(flag == true){
                
                for pracobject in pracData!{
                    if(practice == pracobject.practiceDataToPractice){
                        pracobject.tracking_days = pracobject.tracking_days + 1
                    }
                }
                
            }else if (flag == false){
                
                for pracobject in pracData!{
                    if(practice == pracobject.practiceDataToPractice){
                        pracobject.tracking_days = pracobject.tracking_days - 1
                    }
                }
                
            }
            
        }
        
        do {
            try context?.save()
        } catch let err {
            print(err)
            return false
        }
        print("Tracking Day Maintainance Completed")
        
        return true
    }
    
    //MAEK: Practice History calss over
    //-------------------------------------------------------------------------------------------------------------------------------
    
    
    //MAEK: Practice Weekly  calss
    //-------------------------------------------------------------------------------------------------------------------------------
    
    func addPracticeWeeklyData(practiceName: String, totalNoOfDaysPracticed: Int, totalNoOfDays: Int, startDay: Date, endDate: Date) -> Int {
        let newWeeklyData = NSEntityDescription.insertNewObject(forEntityName: "WeeklyData", into: context!) as! WeeklyData
        
        newWeeklyData.practice_name = practiceName
        newWeeklyData.no_of_days_practiced = Int32(totalNoOfDaysPracticed)
        newWeeklyData.total_no_of_days = Int32(totalNoOfDays)
        newWeeklyData.start_date = startDay as NSDate
        newWeeklyData.end_date = endDate as NSDate
        
        
        do {
            try context?.save()
        } catch let err {
            print(err)
            return 1
        }
        
        return 0
    }
    
    
    func getPracticeWeeklyData() -> [WeeklyData]? {
        
        let featchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "WeeklyData")
        featchRequest.returnsObjectsAsFaults = false
        
        do {
            let dataArray = try (context?.fetch(featchRequest) as? [WeeklyData])!
            //            print("Get practice data-----------------------------")
            //            print(dataArray)
            return dataArray
            
        } catch let err {
            print(err)
        }
        
        return nil
        
    }
    
    func getPracticeWeeklyData(practiceName: String) -> [WeeklyData]? {
        
        let featchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "WeeklyData")
        featchRequest.returnsObjectsAsFaults = false
        featchRequest.predicate = NSPredicate(format: "practice_name = %@", argumentArray: [practiceName])
        
        do {
            let dataArray = try (context?.fetch(featchRequest) as? [WeeklyData])!
            //            print("Get practice data-----------------------------")
            //            print(dataArray)
            return dataArray
            
        } catch let err {
            print(err)
        }
        
        return nil
        
    }
    
    
    //MAEK: Practice Weekly calss over
    //-------------------------------------------------------------------------------------------------------------------------------
    
    // restore practice
    
    func restorePracticeHistory(practiceName: String, comDelFlag: Bool, date: Date, dss: Int, td: Int) -> Int {
        let restoreHistory = NSEntityDescription.insertNewObject(forEntityName: "RestorePractice", into: context!) as! RestorePractice
        
        restoreHistory.practice_name = practiceName
        restoreHistory.com_del_flag = comDelFlag
        restoreHistory.date = date as NSDate
        restoreHistory.dss = Int32(dss)
        restoreHistory.td = Int32(td)
        
        
        do {
            try context?.save()
        } catch let err {
            print(err)
            return 1
        }
        
        return 0
    }
    
    
}
