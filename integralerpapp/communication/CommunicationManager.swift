//
//  CommunicationManager.swift
//  integralerpapp
//
//  Created by Eyal Muchtar on 02/11/2016.
//  Copyright © 2016 Integral. All rights reserved.
//

import Foundation

class CommunicationManager {
    
    // MARK: Class'es private properties
    
    private var queue: [CommRequest]
    
    // MARK: Singleton machanizm
    
    private static var instance: CommunicationManager? = nil
    
    static func getInstance() -> CommunicationManager {
        if nil == instance {
            instance = CommunicationManager()
        }
        return instance!
    }
    
    private init() {
        initMainThread()
    }
    
    
}
