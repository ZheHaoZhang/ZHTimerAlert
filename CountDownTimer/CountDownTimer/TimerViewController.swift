//
//  TimerViewController.swift
//  CountDownTimer
//
//  Created by 張哲豪 on 2018/5/2.
//  Copyright © 2018年 Ziv. All rights reserved.
//

import UIKit
import UserNotifications
import AudioToolbox

class TimerViewController: UIViewController {

    var appMovedToBackgroundDate: Date?
    var seconds = 30{
        didSet{
            timerLabel?.text = timeString(time: TimeInterval(seconds))
            if seconds <= 0 && isTimerRunning{
                self.timeUp()
            }
        }
    }
    var timer = Timer()
    var automaticRun = false
    var isTimerRunning = false{
        didSet{
            if isTimerRunning == false {
                self.timePickerView.isHidden = false
                self.timerLabelView.isHidden = true
                self.removeNotification()
            }else{
                self.timePickerView.isHidden = true
                self.timerLabelView.isHidden = false
                self.createNotification()
            }
        }
    }
    var resumeTapped = false{
        didSet{
            if resumeTapped == false {
                self.pauseButton.setTitle("Pause",for: .normal)
            }else{
                self.removeNotification()
                self.pauseButton.setTitle("Resume",for: .normal)
            }
        }
    }

    
    @IBOutlet weak var timePickerView: UIView!
    @IBOutlet weak var timerLabelView: UIView!
    @IBOutlet weak var myPickerView: TimePickerView!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pauseButton.isEnabled = false
        self.myPickerView.myDelegate = self
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: Notification.Name.UIApplicationWillResignActive, object: nil)
        notificationCenter.addObserver(self, selector: #selector(appMovedToForeground), name: Notification.Name.UIApplicationDidBecomeActive, object: nil)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.timerLabelView.isHidden = true // 預設進入設定
        
        self.myPickerView.setCountDownTimerValue(time: TimeInterval(self.seconds))
        if automaticRun {
            self.runTimer()
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        timer.invalidate()
        self.isTimerRunning = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //開始
    @IBAction func startButtonAction(_ sender: UIButton) {
        if isTimerRunning == false {
            runTimer()
        }
    }
    //暫停
    @IBAction func pauseButtonAction(_ sender: UIButton) {
        self.pauseTimer(pause: !self.resumeTapped)

//        if self.resumeTapped == false {
//            self.timer.invalidate()
//            self.resumeTapped = true
//        } else {
//            self.runTimer()
//            self.resumeTapped = false
//        }
    }
    //重新
    @IBAction func resetButtonAction(_ sender: UIButton) {
        timer.invalidate()
        self.seconds = self.myPickerView.getTimeInterval()
        isTimerRunning = false
        pauseButton.isEnabled = false
        self.resumeTapped = false

    }
    func pauseTimer(pause: Bool)  {
        if pause {
            self.timer.invalidate()
            self.resumeTapped = true
        } else {
            self.runTimer()
            self.resumeTapped = false
        }
    }
    
 // MARK: - Navigation
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
extension TimerViewController: TimePickerViewDelegate {
    func pickerViewDidSelectRow(time:Int) {
        self.seconds = time
    }
}
extension TimerViewController {
    func runTimer(time:TimeInterval)  {
        self.myPickerView.setCountDownTimerValue(time: time)
        self.seconds = Int(time)
        self.runTimer()
    }
    func runTimer() {
        if self.seconds < 1 {
            return
        }
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(self.updateTimer)), userInfo: nil, repeats: true)
        isTimerRunning = true
        pauseButton.isEnabled = true
    }
    @objc func updateTimer() {
        if seconds < 1 {
            timer.invalidate()
            //Send alert to indicate "time's up!"
            //時間到
        } else {
            seconds -= 1
        }
    }
    func timeUp()  {
         AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }
    func timeString(time:TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
}
//離開 app 相關
extension TimerViewController {
    @objc func appMovedToBackground() {
        print("App moved to background!" + "現在時間\(self.seconds)")
        if isTimerRunning {
            self.appMovedToBackgroundDate = Date()
            self.timer.invalidate()
        }
    }
    @objc func appMovedToForeground() {
        print("App moved to Foreground!")
        if isTimerRunning {
            if let appMovedToBackgroundDate = self.appMovedToBackgroundDate {
                let 離開時間差 = Date().timeIntervalSince1970 - appMovedToBackgroundDate.timeIntervalSince1970
                print("離開時間差\(離開時間差)" )
                self.seconds = max(0, seconds - Int(離開時間差.rounded()))
                self.appMovedToBackgroundDate = nil
                self.runTimer()
            }
        }
    }
    
    func createNotification()  {
        LocalNotification.removeNotification()
        LocalNotification.dispatchlocalNotification(with: "Rest timer", body: "Time's up!", at: Date().addedBy(second: seconds))
        return
        
        
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().removeAllDeliveredNotifications()
            //
            let content = UNMutableNotificationContent()
            content.title = "Rest timer"
            //            content.subtitle = "Rest timer"
            content.body = "time up"
            content.badge = 1
            content.sound = UNNotificationSound.default()
            
            var trigger: UNTimeIntervalNotificationTrigger? = nil
            if seconds < 1 {
                trigger = nil
            }else{
                trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(self.seconds), repeats: false)
            }
            
            let request = UNNotificationRequest(identifier: "notification", content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request, withCompletionHandler: {error in
                print("成功建立通知...")
            })
        } else {
            // ios 9
            let notification = UILocalNotification()
            notification.fireDate = NSDate(timeIntervalSinceNow: TimeInterval(self.seconds)) as Date
            notification.alertBody = "Rest timer"
            notification.alertAction = "time up"
            notification.soundName = UILocalNotificationDefaultSoundName
            UIApplication.shared.scheduleLocalNotification(notification)
        }
        
    }
    func removeNotification() {
        LocalNotification.removeNotification()
        return
        
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        } else {
            // Fallback on earlier versions
        }
    }
}

