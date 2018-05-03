//
//  TimePickerView.swift
//  CountDownTimer
//
//  Created by 張哲豪 on 2018/5/2.
//  Copyright © 2018年 Ziv. All rights reserved.
//

import UIKit

enum CountDownType {
    case hour
    case minute
    case second
    
    func getUnit() -> String {
        switch self {
        case .hour:
            return "hour"
        case .minute:
            return "minute"
        case .second:
            return "second"
        }
    }
}

protocol TimePickerViewDelegate {
    func pickerViewDidSelectRow(time:Int)
}
class TimePickerView: UIPickerView {
    
    lazy var unitStackView: UIStackView = {
        return self.setUnitStackView()
    }()
    
    var hour:Int = 0
    var minute:Int = 0
    var second:Int = 0
    var components: [CountDownType] = [.minute,.second]
    var myDelegate: TimePickerViewDelegate?
 
    required override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    func commonInit(){
        self.delegate = self
        self.dataSource = self
        self.setUnit(components: self.components)

        
    }
    override func draw(_ rect: CGRect) {
//        self.setCountDownTimerValue(time: 300)
    }
    func setCountDownTimerValue(time:TimeInterval)  {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        
        self.hour = hours
        self.minute = minutes
        self.second = seconds
        self.valueChange()
        
        if self.components.index(of: .hour) == nil && hours > 0 {
          //GG 超過
        }
        
        let count = self.components.count
        for i in 0 ..< count {
            let component = self.components[i]
            switch component {
            case .hour:
                self.selectRow(hour, inComponent: i, animated: true)
            case .minute:
                self.selectRow(minute, inComponent: i, animated: true)
            case .second:
                self.selectRow(second, inComponent: i, animated: true)
            }
        }
    }
    func setUnit(components: [CountDownType]) {
        for removeView in self.unitStackView.arrangedSubviews {
            self.unitStackView.removeArrangedSubview(removeView)
        }
        for component in components {
            let label = UILabel.init()
            label.text = component.getUnit()
            label.textAlignment = .left
            self.unitStackView.addArrangedSubview(label)
        }
    }
    
    func setUnitStackView() -> UIStackView {
        let stackView = UIStackView.init()
        stackView.frame = self.bounds
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        self.addSubview(stackView)
        
        let centerX = NSLayoutConstraint.init(item: stackView,
                                              attribute: .centerX,
                                              relatedBy: .equal,
                                              toItem: self,
                                              attribute: .centerX,
                                              multiplier: 3/2,
                                              constant: 20)
   
        let centerY = NSLayoutConstraint.init(item: stackView,
                                              attribute: .centerY,
                                              relatedBy: .equal,
                                              toItem: self,
                                              attribute: .centerY,
                                              multiplier: 1,
                                              constant: 0)
        
        let height = NSLayoutConstraint.init(item: stackView,
                                             attribute: .height,
                                             relatedBy: .equal,
                                             toItem: self,
                                             attribute: .height,
                                             multiplier: 1,
                                             constant: 0)
        
        let width = NSLayoutConstraint.init(item: stackView,
                                            attribute: .width,
                                            relatedBy: .equal,
                                            toItem: self,
                                            attribute: .width,
                                            multiplier: 1,
                                            constant: 0)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([centerX,centerY,height,width])
        return stackView
    }
}
extension TimePickerView: UIPickerViewDataSource, UIPickerViewDelegate{
    
    func getDate() -> Date?{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        let date = dateFormatter.date(from: String(format: "%02d", self.hour) + ":" + String(format: "%02d", self.minute) + ":" + String(format: "%02d", self.second))
        return date
    }
    func valueChange() {
        self.myDelegate?.pickerViewDidSelectRow(time: self.getTimeInterval())
    }
    func getTimeInterval() -> Int {
        return (hour * 3600) + (minute * 60) + second
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return components.count
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch components[component] {
        case .hour:
            return 24
        default:
            return 60
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(format:"%2lu", row)
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch components[component] {
        case .hour:
            self.hour = row
        case .minute:
            self.minute = row
        case .second:
            self.second = row
        }
        self.valueChange()
    }
}



