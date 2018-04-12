//
//  StringUtils.swift
//  integralerpapp
//
//  Created by Eyal Muchtar on 19/11/2016.
//  Copyright © 2016 Integral. All rights reserved.
//

import Foundation

class StringUtils {

    static func isStringEmpty(stringValue: String) -> Bool {
        var stringValue = stringValue
        var returnValue = false
    
        if stringValue.isEmpty  == true {
            returnValue = true
            return returnValue
        }
    
        // Make sure user did not submit number of empty spaces
        stringValue = stringValue.trimmingCharacters(in: NSCharacterSet.whitespaces)
    
        if(stringValue.isEmpty == true) {
            returnValue = true
            return returnValue
        }
        return returnValue
    }
}
