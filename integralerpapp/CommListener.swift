//
//  CommListener.swift
//  integralerpapp
//
//  Created by Eyal Muchtar on 29/10/2016.
//  Copyright © 2016 Integral. All rights reserved.
//

import Foundation

protocol CommListener {
    func newDataArrived(response: String)
    func exceptionThrown(error: Error)
}
