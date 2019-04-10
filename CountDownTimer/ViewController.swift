//
//  ViewController.swift
//  CountDownTimer
//
//  Created by 張哲豪 on 2018/5/2.
//  Copyright © 2018年 Ziv. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        LocalNotification.registerForLocalNotification(on: UIApplication.shared)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showCountdownTimer()
    }

    @IBAction func buttonAction(_ sender: UIButton) {
        showCountdownTimer()
    }
    
    func showCountdownTimer() {
        let alert = UIAlertController(title: "title", message: "message", preferredStyle: UIAlertControllerStyle.actionSheet)
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
            //
        }
        let storyboard = UIStoryboard(name: "CountDownTimer", bundle: nil)
        let VC = storyboard.instantiateViewController(withIdentifier: "TimerViewController") as! TimerViewController
        VC.preferredContentSize = CGSize(width: 272, height: 250)
        
        alert.setValue(VC, forKey: "contentViewController")
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
}

