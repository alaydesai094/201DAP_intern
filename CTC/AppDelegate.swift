//
//  AppDelegate.swift
//  CTC
//
//  Created by Nirav Bavishi on 2019-01-08.
//  Copyright © 2019 Nirav Bavishi. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
    var count = 0
    
    // Notification
    var center = UNUserNotificationCenter.current()

    
    // Setting to run notification in foreground
       func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
           completionHandler([.alert, .sound])
       }
    
    //handling notification
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
     
        if response.notification.request.identifier == "TestIdentifier" {
            print("handling notifications with the TestIdentifier Identifier")
        }
     
        completionHandler()
     
    }


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Override point for customization after application launch.
        //MARK: for path od coredata
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print(urls[urls.count-1] as URL)
        //// for path of coredata
        
        Thread.sleep(forTimeInterval: 5.0)
        
        //MARK:  to select app launch
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = MainNavigationController()
 

        let dbHelper = DatabaseHelper()
        var userObject: User?

        userObject = dbHelper.checkLoggedIn()

        self.window = UIWindow(frame: UIScreen.main.bounds)

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        var initialViewController:UIViewController?

        if (userObject != nil){

             initialViewController = storyboard.instantiateViewController(withIdentifier: "MainTabbedBar")

        }else{

              initialViewController = storyboard.instantiateViewController(withIdentifier: "newLoginOptions")

        }

        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()

         //MARK: to select app launch over
    
        //Notification Settings
        UNUserNotificationCenter.current().delegate = self
        
        // Permission for Notification
       UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
           print("granted: (\(granted)")
        }
        
        return true
    }
    

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        
        UserDefaults.standard.set(Date(), forKey: "LastOpened")
        
        
      func daysBetweenDates(startDate: Date, endDate: Date) -> Int {
                   let calendar = Calendar.current
                   let components = calendar.dateComponents([Calendar.Component.day], from: startDate, to: endDate)
                   return components.day!
               }

       guard let lastOpened = UserDefaults.standard.object(forKey: "LastOpened") as? Date else {
            return
        }
        
        let diff = daysBetweenDates(startDate: lastOpened, endDate: Date() )
        
        if(diff == 1){
            
           count = count + 1
            print(count)
        }
        else{}
     
        center.removeAllPendingNotificationRequests()
        
        //1. If they track practices 7 days in a row
               if count == 1{
                             
                   let notification = UNMutableNotificationContent()
                   notification.title = "Connect To The core"
                   notification.body = "this is a test"
                   notification.sound = UNNotificationSound.default

                   let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
                                         
                   let request = UNNotificationRequest(identifier: "TestIdentifier", content: notification, trigger: notificationTrigger)
                       center.add(request, withCompletionHandler: nil)
                                 
               }
        
        
    
       //1. If they track practices 7 days in a row
        if count == 7{
                      
            let notification = UNMutableNotificationContent()
            notification.title = "Connect To The core"
            notification.body = "You’re doing amazing!"
            notification.sound = UNNotificationSound.default

            let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
                                  
            let request = UNNotificationRequest(identifier: "TestIdentifier", content: notification, trigger: notificationTrigger)
                center.add(request, withCompletionHandler: nil)
                          
        }
        
       // If they track practices 10 days in a row
        if count == 10 {
            
            let notification = UNMutableNotificationContent()
            notification.title = "Connect To The core"
            notification.body = "You’re doing great! Tracking for 10 days now!"
            notification.sound = UNNotificationSound.default

            let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
                                  
            let request = UNNotificationRequest(identifier: "TestIdentifier", content: notification, trigger: notificationTrigger)
                center.add(request, withCompletionHandler: nil)
                            
        }
        
        //If they track practices 14 days in a row
        if count == 14 {
                      
            let notification = UNMutableNotificationContent()
            notification.title = "Connect To The core"
            notification.body = "Wow! 14 days in a row. Keep it up!"
            notification.sound = UNNotificationSound.default

            let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
                                  
            let request = UNNotificationRequest(identifier: "TestIdentifier", content: notification, trigger: notificationTrigger)
                center.add(request, withCompletionHandler: nil)
                          
        }
        
        //If they track practices 30 days in a row
               if count == 30 {
                             
                   let notification = UNMutableNotificationContent()
                   notification.title = "Connect To The core"
                   notification.body = "30 days done, 171 to go! Great work! "
                   notification.sound = UNNotificationSound.default

                   let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
                                         
                   let request = UNNotificationRequest(identifier: "TestIdentifier", content: notification, trigger: notificationTrigger)
                       center.add(request, withCompletionHandler: nil)
                                 
               }
        
        //If they track practices 171 days in a row
                     if count == 171 {
                                   
                         let notification = UNMutableNotificationContent()
                         notification.title = "Connect To The core"
                         notification.body = "You’re 30 days away from 201! You can do this!"
                         notification.sound = UNNotificationSound.default

                         let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
                                               
                         let request = UNNotificationRequest(identifier: "TestIdentifier", content: notification, trigger: notificationTrigger)
                             center.add(request, withCompletionHandler: nil)
                                       
                     }
        
        
        //If they track practices 201 days in a row
        if count == 201 {
                                          
            let notification = UNMutableNotificationContent()
            notification.title = "Connect To The core"
            notification.body = "You did your 201 days of practice today! Congratulations!"
            notification.sound = UNNotificationSound.default

            let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
                                                      
            let request = UNNotificationRequest(identifier: "TestIdentifier", content: notification, trigger: notificationTrigger)
                                    center.add(request, withCompletionHandler: nil)
                                              
        }
        
        
        
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        guard let lastOpened = UserDefaults.standard.object(forKey: "LastOpened") as? Date else {
               return
           }

       func daysBetweenDates(startDate: Date, endDate: Date) -> Int {
            let calendar = Calendar.current
            let components = calendar.dateComponents([Calendar.Component.day], from: startDate, to: endDate)
            return components.day!
        }
        
        let totaldays = daysBetweenDates(startDate: lastOpened, endDate: Date() )
        
        center.removeAllPendingNotificationRequests()
        
        
        // 1. If they haven’t opened the app in 3 days
        if totaldays >= 3{
            
            let notification = UNMutableNotificationContent()
            notification.title = "Connect To The core"
            notification.body = "We haven’t seen you in a while ☹"
            notification.sound = UNNotificationSound.default

        let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
                    
            let request = UNNotificationRequest(identifier: "TestIdentifier", content: notification, trigger: notificationTrigger)
                     center.add(request, withCompletionHandler: nil)
            
            
        }
       // 2. If they haven’t opened the app in 7 days
        if totaldays >= 7{
                   
                   let notification = UNMutableNotificationContent()
                   notification.title = "Connect To The core"
                   notification.body = "You haven’t tracked your practices. Let’s get back at it."
                   notification.sound = UNNotificationSound.default

               let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
                           
                   let request = UNNotificationRequest(identifier: "TestIdentifier", content: notification, trigger: notificationTrigger)
                            center.add(request, withCompletionHandler: nil)
                    
            }
        
        // 3. If they haven’t opened the app in 14 days
        
        if totaldays >= 14{
                          
            let notification = UNMutableNotificationContent()
            notification.title = "Connect To The core"
            notification.body = "Don’t give up, every step counts!"
            notification.sound = UNNotificationSound.default

            let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
                                  
            let request = UNNotificationRequest(identifier: "TestIdentifier", content: notification, trigger: notificationTrigger)
                                   center.add(request, withCompletionHandler: nil)
                          
                          
        }
        
        
        
        
        
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
    
    func notify(){
        
         // notification on start of the year
        center.removeAllPendingNotificationRequests()
        
            let notification = UNMutableNotificationContent()
            notification.title = "Connect To The core"
            notification.body = "It’s January 1st, did you want to add new practices to your list?"
            notification.sound = UNNotificationSound.default
            
              //add notification on jan 01
                var dateComponents = DateComponents()
                dateComponents.month = 1
                dateComponents.day = 1
                dateComponents.hour = 15
                dateComponents.minute = 30
      
        
                let notificationTrigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

        //let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
                    
            let request = UNNotificationRequest(identifier: "TestIdentifier", content: notification, trigger: notificationTrigger)
                     center.add(request, withCompletionHandler: nil)
        
        
        //------------------------------------------------------------------------
        
        // notification at end of the year
        
        let notification2 = UNMutableNotificationContent()
              notification2.title = "Connect To The core"
              notification2.body = "It’s January 1st, did you want to add new practices to your list?"
              notification.sound = UNNotificationSound.default
              
                //add notification on Dec 1
                  var dateComponents2 = DateComponents()
                  dateComponents2.month = 12
                  dateComponents2.day = 31
                  dateComponents2.hour = 15
                  dateComponents2.minute = 30
        
          
                  let notificationTrigger2 = UNCalendarNotificationTrigger(dateMatching: dateComponents2, repeats: true)

          //let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
                      
              let request2 = UNNotificationRequest(identifier: "TestIdentifier", content: notification2, trigger: notificationTrigger2)
            
                center.add(request2, withCompletionHandler: nil)
        
        
        //-------------------------------------------------------------
        
         // notification every month
        
        let notification3 = UNMutableNotificationContent()
                     notification3.title = "Connect To The core"
                     notification3.body = "Check out the 201 Day Achievement Principle book and journal (with link to Amazon )"
                     notification3.sound = UNNotificationSound.default
                     
                       //add notification every month
                         var dateComponents3 = DateComponents()
                         dateComponents3.day = 1
                         dateComponents3.hour = 15
                         dateComponents3.minute = 30
               
                 
                         let notificationTrigger3 = UNCalendarNotificationTrigger(dateMatching: dateComponents3, repeats: true)

                 //let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
                             
                     let request3 = UNNotificationRequest(identifier: "TestIdentifier", content: notification3, trigger: notificationTrigger3)
                   
                       center.add(request3, withCompletionHandler: nil)
        
        //-------------------------------------------------------------
        
         // notification every month
        
        let notification4 = UNMutableNotificationContent()
                     notification4.title = "Connect To The core"
                     notification4.body = "Join our Facebook community for support (with FB link)"
                     notification4.sound = UNNotificationSound.default
                     
                       //add notification every month
                         var dateComponents4 = DateComponents()
                         dateComponents4.day = 1
                         dateComponents4.hour = 15
                         dateComponents4.minute = 30
               
                 
                         let notificationTrigger4 = UNCalendarNotificationTrigger(dateMatching: dateComponents4, repeats: true)

                 //let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
                             
                     let request4 = UNNotificationRequest(identifier: "TestIdentifier", content: notification4, trigger: notificationTrigger4)
                   
                       center.add(request4, withCompletionHandler: nil)
          
        
    }
    
    
    
  

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "CTC")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

