//
//  PreferencesManager.swift
//  integralerpapp
//
//  Created by Eyal Muchtar on 20/11/2016.
//  Copyright © 2016 Integral. All rights reserved.
//

import Foundation

class PreferencesManager {
    
    // MARK: Singleton mechanizm
    
    static let sharedInstance = PreferencesManager()
    
    required internal init() {
    }
    
    struct defaultsKeys {
        static let keyOne = "firstStringKey"
        static let keyTwo = "secondStringKey"
    }
    
    func setData() {
        let defaults = UserDefaults.standard
        
        defaults.setValue("Some String Value", forKey: defaultsKeys.keyOne)
        defaults.setValue("Another String Value", forKey: defaultsKeys.keyTwo)
        
        defaults.synchronize()
    }
    
    func getData() -> String{
        let defaults = UserDefaults.standard
        
        if let stringOne = defaults.string(forKey: defaultsKeys.keyOne) {
            print(stringOne) // Some String Value
            return stringOne
        }
        
        if let stringTwo = defaults.string(forKey: defaultsKeys.keyTwo) {
            print(stringTwo) // Another String Value
            return stringTwo
        }
        
        return ""
    }
}

