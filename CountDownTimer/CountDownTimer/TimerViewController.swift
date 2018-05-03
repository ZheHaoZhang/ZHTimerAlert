//
//  TimerViewController.swift
//  CountDownTimer
//
//  Created by 張哲豪 on 2018/5/2.
//  Copyright © 2018年 Ziv. All rights reserved.
//

import UIKit

class TimerViewController: UIViewController {

    var seconds = 60{
        didSet{
            timerLabel?.text = timeString(time: TimeInterval(seconds))
        }
    }
    var timer = Timer()
    var automaticRun = false
    var isTimerRunning = false{
        didSet{
            if isTimerRunning == false {
                self.timePickerView.isHidden = false
                self.timerLabelView.isHidden = true
            }else{
                self.timePickerView.isHidden = true
                self.timerLabelView.isHidden = false
            }
        }
    }
    var resumeTapped = false{
        didSet{
            if resumeTapped == false {
                self.pauseButton.setTitle("Pause",for: .normal)
            }else{
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
        if self.resumeTapped == false {
            self.timer.invalidate()
            self.resumeTapped = true
        } else {
            self.runTimer()
            self.resumeTapped = false
        }
    }
    //重新
    @IBAction func resetButtonAction(_ sender: UIButton) {
        timer.invalidate()
        self.seconds = self.myPickerView.getTimeInterval()
        isTimerRunning = false
        pauseButton.isEnabled = false
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
    func timeString(time:TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
}

