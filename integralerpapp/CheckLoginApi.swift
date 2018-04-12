//
//  CheckLoginApi.swift
//  integralerpapp
//
//  Created by Eyal Muchtar on 20/11/2016.
//  Copyright © 2016 Integral. All rights reserved.
//

import Foundation

class CheckLoginApi {
    
    // MARK: Errors
    
    enum DataVlidationErrors: Error {
        case EmptyUsernameOrPassword(text: String)
        case GeneralError
    }
    
    
    func checkLogin(username: String, password: String, listener: CommListener!) throws {
        if StringUtils.isStringEmpty(stringValue: username) || StringUtils.isStringEmpty(stringValue: password) {
            throw DataVlidationErrors.EmptyUsernameOrPassword(text: "username and / or password is empty.")
        }
        var params = ["check_login_user" : username]
        params["check_login_pass"] = password.sha256()
        params["sub_id"] = String(1)
        params["com_id"] = String(1)
        
        let commManager = CommManager.sharedInstance
        commManager.connectPost(urlStr: Constants.Sever.BASE_URL, params: params, listener: listener)
    }
}
