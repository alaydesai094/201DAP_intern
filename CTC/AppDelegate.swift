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
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


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
        
        // MARK: for notification
        
//        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.badge, .sound]) { (granted, error) in
//            print("Granted")
//        }
        
      
//
//        let dateForDateComp = Date().addingTimeInterval(4)
//
//        let dateComp = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: dateForDateComp)

//        custome(dateComponent: dateComp)

//
//        let date = Date().addingTimeInterval(5)
//        let timer = Timer(fireAt: date, interval: 0, target: self, selector: #selector(self.custome(dateComponent:)), userInfo: nil, repeats: false)
//        RunLoop.main.add(timer, forMode: .common)

        //MARK: notification over
        
        return true
    }
    
//    @objc func custome(dateComponent: DateComponents){
//        
//        
//        var dateComp = dateComponent
//        
//        let content = UNMutableNotificationContent()
//        content.body = "Body"
//        content.title = "Title"
//        content.sound = UNNotificationSound.default
//        
//        let trigger2 = UNCalendarNotificationTrigger(dateMatching: dateComp, repeats: true)
//        
//        let request = UNNotificationRequest(identifier: "Test", content: content, trigger: trigger2)
//        
//        UNUserNotificationCenter.current().add(request) { (err) in
//            if err == nil{
//                
//                dateComp.day = dateComp.second! + 3
//                  print("Complete")
////                self.custome(dateComponent: dateComp)
//              
//                
//            }
//        }
//        
//    }
    

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
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
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
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

