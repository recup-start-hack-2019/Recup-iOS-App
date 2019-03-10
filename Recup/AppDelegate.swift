//
//  AppDelegate.swift
//  Recup
//
//  Created by Daniel Montano on 08.03.19.
//  Copyright © 2019 Daniel Montano. All rights reserved.
//

import UIKit
import UserNotifications

enum Identifiers {
    static let viewAction = "VIEW_IDENTIFIER"
    static let newsCategory = "NEWS_CATEGORY"
}


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        registerForPushNotifications()
        
        // Check if launched from notification
        let notificationOption = launchOptions?[.remoteNotification]
        
        if let notification = notificationOption as? [String: AnyObject],
            let aps = notification["aps"] as? [String: AnyObject] {
            
//            NewsItem.makeNewsItem(aps)
            
            (window?.rootViewController as? UITabBarController)?.selectedIndex = 1
        }

        return true
    }
    
    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
        ) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        print("Device Token: \(token)")
    }
    
    func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        
        guard let aps = userInfo["aps"] as? [String: AnyObject] else {
            print("Failed")
            completionHandler(.failed)
            return
        }
        
        // 1
        if let data = userInfo["acceptTX"] as? [String: AnyObject] {
            if let cupTX = CupTransaction.parseCupTransaction(data) {
                print("received accept TX notification: \(userInfo)")
                CupsManager.sharedInstance.handleAcceptTX(cupTX: cupTX)
                completionHandler(.newData)
            }else{
                completionHandler(.noData)
            }
            
            return
        } else if let data = userInfo["returnTX"] as? [String: AnyObject]  {
            if let cupTX = CupTransaction.parseCupTransaction(data) {
                print("received return TX notification: \(userInfo)")
                CupsManager.sharedInstance.handleReturnTX(cupTX: cupTX)
                completionHandler(.newData)
            }else{
                completionHandler(.noData)
            }
            return
        }
        return completionHandler(.noData)
    }

    func registerForPushNotifications() {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound, .badge]) {
                [weak self] granted, error in
                guard let self = self else { return }
                print("Permission granted: \(granted)")
                
                guard granted else { return }
                
                // 1
                let viewAction = UNNotificationAction(
                    identifier: Identifiers.viewAction, title: "View",
                    options: [.foreground])
                
                // 2
                let newsCategory = UNNotificationCategory(
                    identifier: Identifiers.newsCategory, actions: [viewAction],
                    intentIdentifiers: [], options: [])
                
                // 3
                UNUserNotificationCenter.current()
                    .setNotificationCategories([newsCategory])
                
                self.getNotificationSettings()
        }
    }
    
    func getNotificationSettings() {
        
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            print("Notification settings: \(settings)")
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }

}
