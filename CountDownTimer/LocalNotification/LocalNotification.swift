//
//  LocalNotification.swift
//  mohotiOSAPP
//
//  Created by 張哲豪 on 2018/5/16.
//  Copyright © 2018年 Ziv. All rights reserved.
//

import UIKit
import UserNotifications

class LocalNotification: NSObject, UNUserNotificationCenterDelegate {
    
    class func registerForLocalNotification(on application:UIApplication) {
        if (UIApplication.instancesRespond(to: #selector(UIApplication.registerUserNotificationSettings(_:)))) {
            let notificationCategory:UIMutableUserNotificationCategory = UIMutableUserNotificationCategory()
            notificationCategory.identifier = "NOTIFICATION_CATEGORY"
            
            //registerting for the notification.
            application.registerUserNotificationSettings(UIUserNotificationSettings(types:[.sound, .alert, .badge], categories: nil))
        }
    }
    
    class func dispatchlocalNotification(with title: String, body: String, userInfo: [AnyHashable: Any]? = nil, at date:Date) {
        
        if #available(iOS 10.0, *) {
            
            let center = UNUserNotificationCenter.current()
            let content = UNMutableNotificationContent()
            content.title = title
            content.body = body
            content.categoryIdentifier = "Fechou"
            content.badge = 0

            if let info = userInfo {
                content.userInfo = info
            }
            
            content.sound = UNNotificationSound.default()
            
//            let comp = Calendar.current.dateComponents([.hour, .minute, .second], from: date)
//            let trigger = UNCalendarNotificationTrigger(dateMatching: comp, repeats: false)

            let seconds = date.timeIntervalSince1970 - Date().timeIntervalSince1970
            var trigger: UNTimeIntervalNotificationTrigger? = nil
            if seconds < 1 {
                trigger = nil
            }else{
                trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(seconds), repeats: false)
            }
            
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            
            center.add(request)
            
        } else {
            
            let notification = UILocalNotification()
            notification.fireDate = date
//            notification.fireDate = Date(timeIntervalSinceNow: 10)
            notification.timeZone = NSTimeZone.default

            notification.alertTitle = title
            notification.alertBody = body
//            notification.badge = 0

            if let info = userInfo {
                notification.userInfo = info
            }
            notification.soundName = UILocalNotificationDefaultSoundName
            UIApplication.shared.scheduleLocalNotification(notification)
        }
        
        print("WILL DISPATCH LOCAL NOTIFICATION AT ", date)
    }
    class func removeNotification() {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().removeAllDeliveredNotifications()
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()

        } else {
            // Fallback on earlier versions
            UIApplication.shared.cancelAllLocalNotifications()
        }
    }
}
extension Date {
    func addedBy(minutes:Int) -> Date {
        return Calendar.current.date(byAdding: .minute, value: minutes, to: self)!
    }
    func addedBy(second:Int) -> Date {
        return Calendar.current.date(byAdding: .second, value: second, to: self)!
    }
}

