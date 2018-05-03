//
//  Utils.swift
//  mohotiOSAPP
//
//  Created by 張哲豪 on 2017/1/17.
//  Copyright © 2017年 Ziv. All rights reserved.
//

import UIKit

class Utils: NSObject {

    class func delay(_ delay: Double, closure:@escaping () -> Void) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
    
}





