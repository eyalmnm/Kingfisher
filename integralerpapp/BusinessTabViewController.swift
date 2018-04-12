//
//  BusinessTabViewController.swift
//  integralerpapp
//
//  Created by Eyal Muchtar on 08/09/2016.
//  Copyright © 2016 Integral. All rights reserved.
//

import UIKit

@IBDesignable
class BusinessTabViewController: UIViewController {
    
//    @IBOutlet weak var taskPreformanceView: ArcGaugeView!
//    @IBOutlet weak var onTimeDeliveryView: ArcGaugeView!
    
    
    // MARK: Outlets
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var taskAndDeliveryButton: UIButton!
    @IBOutlet weak var salesActivityButton: UIButton!
    @IBOutlet weak var weeklySalesButton: UIButton!
    @IBOutlet weak var topCustomersButton: UIButton!
    @IBOutlet weak var topItemsButton: UIButton!
    @IBOutlet weak var quarterlyActivityButton: UIButton!
    
    @IBOutlet weak var greetingLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var businessTabItem: UITabBarItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Business tab did load")
        
        // Make profileImageView Cyrcular
        profileImageView.layer.borderWidth = 1
        profileImageView.layer.masksToBounds = false
//        profileImageView.layer.borderColor = UIColor.black.cgColor
        profileImageView.layer.cornerRadius = profileImageView.frame.width/2
        profileImageView.clipsToBounds = true
        
        // Add Action to profileImageView
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action: #selector(BusinessTabViewController.onProfileImageClick))
        profileImageView.isUserInteractionEnabled = false // true
        profileImageView.addGestureRecognizer(tapGestureRecognizer)
        
        let hour = Calendar.current.component(.hour, from: Date())
        let date = getFormatedDate();
        
        greetingLabel.text = getGreating(hourOfDay: hour)
        dateLabel.text = date
    }
    
    // MARK: Actions
    
    @IBAction func showDetailScreen(_ sender: UIButton) {
        print("button pressed: \(sender.tag)")
    }
    
    //MARK: Logics
    
    func getGreating(hourOfDay: Int) -> String {
        var greeting: String = "Good night"
        if hourOfDay >= 5 && hourOfDay <= 12 {
            greeting = "Good Morning"
        } else if hourOfDay >= 13 && hourOfDay <= 16 {
            greeting = "Good afternoon"
        } else if hourOfDay >= 17 && hourOfDay <= 21 {
            greeting = "Good evening"
        }
        return greeting
    }
    
    // Loading profile image
    func setProfileImage(image: UIImage) {
        print("BusinessTab -> setProfileImage")
        profileImageView.image = image
    }

    func onProfileImageClick() {
        print("BusinessTab -> onProfileImageClick")
    }
    
    func getFormatedDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd yyyy"
        let currentDate = NSDate()
        let convertedDateString = dateFormatter.string(from: currentDate as Date)
        return convertedDateString
    }
    
    
    func addNitification(number: Int) {
        businessTabItem.badgeValue = String(number)
        setBadgeColor()
    }
    
    internal func setBadgeColor() {
        if #available(iOS 10.0, *) {
            businessTabItem.badgeColor = UIColor.red
        }
    }
    
//    func setValueTaskPreformance(currentValue: CGFloat, minimumValue: CGFloat, maximumValue: CGFloat) {
//        taskPreformanceView.setValue(currentValue: Float(currentValue), minimumValue: Float(minimumValue), maximumValue: Float(maximumValue))
//    }
    
//    func setValueOnTimeDelivery(currentValue: CGFloat, minimumValue: CGFloat, maximumValue: CGFloat) {
//        onTimeDeliveryView.setValue(currentValue: Float(currentValue), minimumValue: Float(minimumValue), maximumValue: Float(maximumValue))
//    }
    
}
