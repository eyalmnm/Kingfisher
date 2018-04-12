//
//  BaseTabBarController.swift
//  integralerpapp
//
//  Created by Eyal Muchtar on 07/09/2016.
//  Copyright © 2016 Integral. All rights reserved.
//

import UIKit

class BaseTabBarController: UITabBarController {
    
    @IBInspectable var defaultIndex: Int = 2
    
    // Seclet the defaultIndex to be the selected one.
    override func viewDidLoad() {
        super.viewDidLoad()
        print("BaseTabBarController viewDidLoad")
        selectedIndex = defaultIndex
    }
    
}
