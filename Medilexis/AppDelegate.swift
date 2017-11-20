//
//  AppDelegate.swift
//  Medilexis
//
//  Created by iOS Developer on 13/03/2017.
//  Copyright © 2017 NX3. All rights reserved.
//

import UIKit
import CoreData
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
        if statusBar.responds(to: #selector(setter: UIView.backgroundColor)) {
            statusBar.backgroundColor = UIColor.gray
        }
        
        let userDefaults = Foundation.UserDefaults.standard
        let walkthrough  = userDefaults.string(forKey: "hasViewedWalkthrough")
        let value  = userDefaults.string(forKey: "login")
        
        if walkthrough == nil || walkthrough == "" {
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "WalkthroughScreens", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "WalkthroughController") as! WalkthroughPageView
            window!.rootViewController = nextViewController
            
        } else if value == nil || value == "" {
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let loginViewController = storyBoard.instantiateViewController(withIdentifier: "selection") as! Selection
            window!.rootViewController = loginViewController
            
        } else {
            
            userDefaults.set(false, forKey: "qaTranscription")
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Menu") as! SWRevealViewController
             window!.rootViewController = nextViewController
        }
        
        UIApplication.shared.statusBarStyle = .lightContent
        
         UITabBarItem.appearance().setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Lato", size: 14)!], for: .normal)
        
          UITabBarItem.appearance().setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Lato", size: 14)!], for: .selected)
        
          UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor(red: 0/255.0, green: 172/255.0, blue: 233/255.0, alpha: 1.0)], for: .selected)
        
         UITabBar.appearance().tintColor = UIColor(red: 0/255.0, green: 172/255.0, blue: 233/255.0, alpha: 1.0)
        
         UITabBar.appearance().selectionIndicatorImage = getImageWithColorPosition(color: UIColor(red: 0/255.0, green: 172/255.0, blue: 233/255.0, alpha: 1.0), size: CGSize(width:(self.window?.frame.size.width)!/4,height: 49), lineSize: CGSize(width:(self.window?.frame.size.width)!/4, height:3))
        
         UITabBar.appearance().barTintColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1.0)

        IQKeyboardManager.sharedManager().enable = true
       /* let hasLaunchedKey = "HasLaunched"
        let defaults = UserDefaults.standard
        let hasLaunched = defaults.bool(forKey: hasLaunchedKey)
        
        if !hasLaunched {
            defaults.set(true, forKey: hasLaunchedKey)
            print("run")
        }*/
        
        return true
    }

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
        let container = NSPersistentContainer(name: "Medilexis")
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
    
    func getImageWithColorPosition(color: UIColor, size: CGSize, lineSize: CGSize) -> UIImage {
        let rect = CGRect(x:0, y: 0, width: size.width, height: size.height)
        let rectLine = CGRect(x:0, y:0,width: lineSize.width,height: lineSize.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        UIColor.clear.setFill()
        UIRectFill(rect)
        color.setFill()
        UIRectFill(rectLine)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }

}


