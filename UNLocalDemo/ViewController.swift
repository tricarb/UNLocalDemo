//
//  ViewController.swift
//  UNLocalDemo
//
//  Created by Al Malin (tricarb) on 6/17/20.
//  Copyright © 2020 Albert A. Malin. All rights reserved.
//

import UIKit
import UserNotifications

/*
       ************************************************
       *   Don't understand why the action button     *
       *   on the local notification isn't showing?   *
       ************************************************
 */

enum Notify: String {
    case categoryId = "CATEGORYID"
    case actionID = "ACTIONID"
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Local Notification Demo"
        
        registerCategories()
        askPermission()
        UNUserNotificationCenter.current().delegate = self
    }
    
    @IBAction func fireButtonTapped(_ sender: UIButton) {
        fireNotification()
    }
    
    func askPermission() {
        
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("Authorization granted is", granted)
            }
        }
    }
    
    func registerCategories() {
        
        let center = UNUserNotificationCenter.current()
        
        let actionID = Notify.actionID.rawValue
        let categoryID = Notify.categoryId.rawValue
        
        let action = UNNotificationAction(identifier: actionID, title: "Action Title", options: .foreground)
        let category = UNNotificationCategory(identifier: categoryID, actions: [action], intentIdentifiers: [])
        center.setNotificationCategories([category])
        
        print("Category", category.identifier, "registered with action", action.identifier)
    }
    
    func fireNotification() {
        
        let content = UNMutableNotificationContent()
        content.title = "Content Title"
        content.body = "This is the content body"
        content.categoryIdentifier = Notify.categoryId.rawValue
        
        let timeInterval = TimeInterval(7)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        let center = UNUserNotificationCenter.current()
        
        center.add(request) { (error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("Notification will fire in", timeInterval, "seconds")
            }
        }
    }
}

extension ViewController: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        
        switch response.actionIdentifier {
            
        case Notify.actionID.rawValue:
            print(Notify.actionID.rawValue, "selected")
            
        case UNNotificationDefaultActionIdentifier:
            print("App was opened from the notification interface")
            
        case UNNotificationDismissActionIdentifier:
            print("Notification was explicitly dismissed")
            
        default:
            break
        }
        
        completionHandler()
    }
}

