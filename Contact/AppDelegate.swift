//
//  AppDelegate.swift
//  Contact
//
//  Created by Đái Phương Bình on 5/29/18.
//  Copyright © 2018 Đái Phương Bình. All rights reserved.
//

import UIKit
import Contacts

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var contactStore = CNContactStore()
    
    //    MARK: Alert Check allow access contacts
    func alertAcccessContact() {
        let alertView = UIAlertController(title: "Enable Access Contact", message: "Dou you have enable access contact for app?", preferredStyle: .alert)
        let accept = UIAlertAction(title: "Accept", style: .default) { (acceptAction) in
            self.openSetting()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertView.addAction(accept)
        alertView.addAction(cancel)
        window?.rootViewController?.present(alertView, animated: true, completion: nil)
    }
    
    func openSetting() {
        let url = URL(string: UIApplicationOpenSettingsURLString)
        print(url!)
        UIApplication.shared.openURL(url!)
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        contactStore.requestAccess(for: .contacts) { (success, error) in
            if !success {
                self.alertAcccessContact()
            }
        }
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
    }


}

