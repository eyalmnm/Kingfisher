//
//  CompanyDefApi.swift
//  integralerpapp
//
//  Created by Eyal Muchtar on 20/11/2016.
//  Copyright © 2016 Integral. All rights reserved.
//

import Foundation

class CompanyDefApi {
    
    func getCompanyDef (comDef: Int, listener: CommListener!) {
        
        var params = ["sub_id" : "1"]
        params["com_id"] = "1"
        params["get_com_def"] = String(comDef)
        
        let commManager = CommManager.sharedInstance
        commManager.connectPost(urlStr: Constants.Sever.BASE_URL, params: params, listener: listener)
    }
    
    func updateCompanyDef (companyName: String, companyName2: String, companyNo: String, address1: String, city1: String,
                           country1: String, zipCode1: String, address2: String, city2: String, country2: String, zipCode2: String, website: String, email: String, defaultEmail: String, phoneCountryCode: String, phoneAreaCode: String, phoneNumber: String, faxCountryCode: String, faxAreaCode: String, faxNumber: String, mobileCountryCode: String, mobileAreaCode: String, mobileNumber: String, currencyCode: Int, useForeignCurrency: Int, invManage: Int, saleTax: Float, purchaseTax: Float, itemAutoNumbering: Int, custAutoNumbering: Int, supplAutoNumbering: Int, publicCompany: Int, custDeliveryDays: Int, custCurrent: Int, custCreditDays: Int, supDeliveryDays: Int, supCurrent: Int, supCreditDays: Int, comLongitude: Float, comLatitude: Float, listener: CommListener!) {
        
        var params = ["sub_id" : "1"]
        params["com_id"] = "1"
        params["upd_com_def_name"] = companyName
        params["company_name2"] = companyName2
        params["company_no"] = companyNo
        params["address1"] = address1
        params["city1"] = city1
        params["country1"] = country1
        params["zipcode1"] = zipCode1
        params["address2"] = address2
        params["city2"] = city2
        params["country2"] = country2
        params["zipcode2"] = zipCode2
        params["website"] = website
        params["email"] = email
        params["default_email"] = defaultEmail
        params["phone_country_code"] = phoneCountryCode
        params["phone_area_code"] = phoneAreaCode
        params["phone_number"] = phoneNumber
        params["fax_country_code"] = faxCountryCode
        params["fax_area_code"] = faxAreaCode
        params["fax_number"] = faxNumber
        params["mobile_country_code"] = mobileCountryCode
        params["mobile_area_code"] = mobileAreaCode
        params["mobile_number"] = mobileNumber
        params["currency_code"] = String(currencyCode)
        params["use_foreign_currency"] = String(useForeignCurrency)
        params["inv_manage"] = String(invManage)
        params["sale_tax"] = String(saleTax)
        params["purchase_tax"] = String(purchaseTax)
        params["item_auto_numbering"] = String(itemAutoNumbering)
        params["cust_auto_numbering"] = String(custAutoNumbering)
        params["suppl_auto_numbering"] = String(supplAutoNumbering)
        params["public_company"] = String(publicCompany)
        params["cust_delivery_days"] = String(custDeliveryDays)
        params["cust_current"] = String(custCurrent)
        params["cust_credit_days"] = String(custCreditDays)
        params["sup_delivery_days"] = String(supDeliveryDays)
        params["sup_current"] = String(supCurrent)
        params["sup_credit_days"] = String(supCreditDays)
        params["att_lon"] = String(comLongitude)
        params["att_lat"] = String(comLatitude)
        
        let commManager = CommManager.sharedInstance
        commManager.connectPost(urlStr: Constants.Sever.BASE_URL, params: params, listener: listener)
    }
    
    func getCompanyLogo (logoId: Int, listener: CommListener!) {
        
        var params = ["sub_id" : "1"]
        params["com_id"] = "1"
        params["comp_logo_get_id"] = String(logoId)
        
        let commManager = CommManager.sharedInstance
        commManager.connectPost(urlStr: Constants.Sever.BASE_URL, params: params, listener: listener)
    }
    
    func setCompanyLogo (imageAsBase64: String, listener: CommListener!) {
        
        var params = ["sub_id" : "1"]
        params["com_id"] = "1"
        params["comp_logo_set"] = imageAsBase64
        
        let commManager = CommManager.sharedInstance
        commManager.connectPost(urlStr: Constants.Sever.BASE_URL, params: params, listener: listener)
    }
}
