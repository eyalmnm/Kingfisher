//
//  DateUtils.swift
//  integralerpapp
//
//  Created by Eyal Muchtar on 20/11/2016.
//  Copyright © 2016 Integral. All rights reserved.
//

import Foundation

class DateUtils {

    static func convertDateTo_yyyyddmm() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyddmm"
        let currentDate = NSDate()
        return dateFormatter.string(from: currentDate as Date)
    }
}
