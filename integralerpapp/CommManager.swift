//
//  CommManager.swift
//  integralerpapp
//
//  Created by Eyal Muchtar on 29/10/2016.
//  Copyright © 2016 Integral. All rights reserved.
//

import Foundation

class CommManager {
    
    
    
    // MARK: Errors
    
    enum DataVlidationErrors: Error {
        case InavlidDataError(text: String)
        case NullPointerException(text: String)
        case GeneralError
    }
    
    // MARK: Singleton mechanizm
    
    static let sharedInstance = CommManager()
    
    required internal init() {
    }
    
    // Login Request - GET
    func login(username: String, password: String, listener: CommListener!) {
        
        let urlWithParams = Constants.Sever.BASE_URL + "?userName=\(username)&password=\(password)"
        
        // Create NSURL object
        let loginUrl = NSURL(string: urlWithParams);
        
        // Creaste URL Request
        let request = NSMutableURLRequest(url:loginUrl! as URL);
        
        // Set request HTTP method to GET. It could be POST as well
        request.httpMethod = "GET"
        
        // If we need to add Authorization header value
        // Add Basic Authorization
        /*
         let username = "myUserName"
         let password = "myPassword"
         let loginString = NSString(format: "%@:%@", username, password)
         let loginData: NSData = loginString.dataUsingEncoding(NSUTF8StringEncoding)!
         let base64LoginString = loginData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions())
         request.setValue(base64LoginString, forHTTPHeaderField: "Authorization")
         */
        
        // Or it could be a single Authorization Token value
        //request.addValue("Token token=884288bae150b9f2f68d8dc3a932071d", forHTTPHeaderField: "Authorization")
        
        // Excute HTTP Request
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            // Check for error
            if error != nil {
                print("error=\(error)")
                if listener != nil {
                    listener.exceptionThrown(error: error!)
                }
            }
            
            // Print out response string
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print("responseString = \(responseString)")
            
            
            // Convert server json response to NSDictionary
            do {
                if let convertedJsonIntoDict = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                    
                    // Print out dictionary
                    print(convertedJsonIntoDict)
                    
                    // Get value by key
                    let firstNameValue = convertedJsonIntoDict["userName"] as? String
                    print(firstNameValue!)
                    
                    if listener != nil {
                        listener.newDataArrived(response: responseString as! String)
                    }
                    
                }
            } catch let error as NSError {
                print(error.localizedDescription)
                if listener != nil {
                    listener.exceptionThrown(error: error)
                }
            }
        }
        
        task.resume()
    }
    
    // Login Request - POST
    func connectPost(urlStr: String, params : Dictionary<String, String>, listener: CommListener!) {
        let url:NSURL = NSURL(string: urlStr)!
        let session = URLSession.shared
        
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "POST"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        
        //let paramString = "data=Hello"
        request.httpBody = params.description.data(using: String.Encoding.utf8)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTask(with: request as URLRequest) {
            (
            data, response, error) in
            
            guard let _:NSData = data as NSData?, let _:URLResponse = response, error == nil else {
                print("error")
                if listener != nil {
                    listener.exceptionThrown(error: error!)
                }
                return
            }
            
            let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print(dataString as! String)
            if listener != nil {
                listener.newDataArrived(response: dataString as! String)
            }
        }
        
        task.resume()
    }
}
