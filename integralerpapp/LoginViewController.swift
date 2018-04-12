//
//  LoginViewController.swift
//  integralerpapp
//
//  Created by Eyal Muchtar on 04/09/2016.
//  Copyright © 2016 Integral. All rights reserved.
//

import UIKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class LoginViewController: UIViewController {

    
    
    @IBOutlet weak var usernameEditText: UITextField!
    @IBOutlet weak var passwordEditText: UITextField!
    
    @IBOutlet weak var loginViaQQ: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var forgetPassword: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        print("Login Screen viewWillAppear")
        
        // Disable Login Bottons
        loginButton.isEnabled = false
        loginViaQQ.isEnabled = false
        
        // Add blue border to login via QQ button
        loginViaQQ.layer.borderWidth = 1
        loginViaQQ.layer.borderColor = UIColor.blue.cgColor
        
        // Add rounded corners to components
        roundAllCorners()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    // MARK: Keyboard appearnce helpers methods
    
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    
    func roundAllCorners() -> Void {
        print("roundAllCorners")
        let cornerRadios: CGFloat = 5
        loginButton.layer.cornerRadius = cornerRadios
        loginViaQQ.layer.cornerRadius = cornerRadios
    }

    @IBAction func onLogin(_ sender: AnyObject) {
        print("Login Pressed")
        moveToTabsScreen()
    }
    
    @IBAction func onLoginViaQQ(_ sender: AnyObject) {
        print("Login Via QQ Pressed")
        moveToTabsScreen()
    }
    
    @IBAction func onRegister(_ sender: AnyObject) {
        print("Register Pressed")
    }
    
    @IBAction func onForgetPassword(_ sender: AnyObject) {
        print("Forget Password Pressed")
    }
    
    @IBAction func onUsernameBeginEdit(_ sender: AnyObject) {
        print("UserName Begin Edit")
        loginButton.isEnabled = true
        loginViaQQ.isEnabled = true
    }
    
    func checkExpirationDate() -> Bool  {
        let currentDate = Date()
        let limitationDate = getLimitationDate()
        if currentDate <= limitationDate {
            return false
        } else {
            return true
        }
    }
    
    func getLimitationDate() -> Date {
        let strTime = "2016-12-10 19:29:50 +0000"
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        return formatter.date(from: strTime)!
    }
    
    func moveToTabsScreen() -> Void {
        // Move to the next Screen just after faked login
        let userName = usernameEditText.text
        let password = passwordEditText.text
        
        if checkExpirationDate() {
            exit(0)
        }
        
        // Move to the next screen by calling Segue with identifier
        if userName != nil && password != nil && userName?.characters.count > 0 && password?.characters.count > 0 {
            print("login with \(userName) and \(password)")
            self.performSegue(withIdentifier: "MoveToTabsScreen", sender: self)
        }
        // Remove the entered data. Privacy porpuse
        usernameEditText.text = ""
        passwordEditText.text = ""
    }
}

