//
//  SettingsViewController.swift
//  BradleyUTour
//
//  Created by Jacob Wilson on 5/1/17.
//  Copyright © 2017 Bradley University. All rights reserved.
//

import UIKit
import UserNotifications
import RealmSwift

class SettingsViewController: UIViewController, UNUserNotificationCenterDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        UNUserNotificationCenter.current().delegate = self
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func finishTourPressed(_ sender: Any) {
        let realm = try! Realm()
        let landmarks = realm.objects(Landmark.self)
        
        for landmark in landmarks {
            try! realm.write {
                landmark.visited = false
            }
        }
        
        performSegue(withIdentifier: "GoToSurvey", sender: self)
        
        /*
        UNUserNotificationCenter.current().getNotificationSettings(completionHandler: { (notificationSettings) in
            switch notificationSettings.authorizationStatus {
            case .notDetermined:
                self.requestAuthorization(completionHandler: { (success) in
                    guard success
                        else {
                            return
                    }
                    print("notDetermined")
                    self.scheduleLocalNotification()
                })
            case .authorized:
                print("authorized")
                self.scheduleLocalNotification()
            case .denied:
                print("Application Not Allowed to Display Notifications")
            }
        })*/
    }
    
    private func requestAuthorization(completionHandler: @escaping (_ success: Bool) -> ()) {
        // Request Authorization
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (success, error) in
            if let error = error {
                print("Request Authorization Failed (\(error), \(error.localizedDescription))")
            }
            
            completionHandler(success)
        }
    }
    
    private func scheduleLocalNotification() {
        // Create Notification Content
        let notificationContent = UNMutableNotificationContent()
        
        // Configure Notification Content
        notificationContent.title = "Bradley UTour"
        notificationContent.subtitle = "You have vistied, *blank*"
        notificationContent.body = "Good job! Keep it up!"
        
        // Add Trigger
        let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.5, repeats: false)
        
        // Create Notification Request
        let notificationRequest = UNNotificationRequest(identifier: "bradley_utour_local_notification", content: notificationContent, trigger: notificationTrigger)
        
        // Add Request to User Notification Center
        UNUserNotificationCenter.current().add(notificationRequest) { (error) in
            print("it was added")
            if let error = error {
                print("Unable to Add Notification Request (\(error), \(error.localizedDescription))")
            }
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert])
        print("here")
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}



/*
extension ViewController: UNUserNotificationCenterDelegate {
    
 
    
}*/
