//
//  BiApi.swift
//  integralerpapp
//
//  Created by Eyal Muchtar on 20/11/2016.
//  Copyright © 2016 Integral. All rights reserved.
//

import Foundation

class BiApi {

    func getTopCustList (customerid: Int, fromDate: String, toDate: String, filter: String, listener: CommListener!) {
        
        var params = ["sub_id" : "1"]
        params["com_id"] = "1"
        params["get_top_cust_list"] = String(customerid)
        params["fr_input_date"] = fromDate
        params["to_input_date"] = toDate
        params["filter_clause"] = filter
        
        let commManager = CommManager.sharedInstance
        commManager.connectPost(urlStr: Constants.Sever.BASE_URL, params: params, listener: listener)
    }
    
    func getTopItemList (customerid: Int, fromDate: String, toDate: String, filter: String, listener: CommListener!) {
        
        var params = ["sub_id" : "1"]
        params["com_id"] = "1"
        params["get_top_item_list"] = String(customerid)
        params["fr_input_date"] = fromDate
        params["to_input_date"] = toDate
        params["filter_clause"] = filter
        
        let commManager = CommManager.sharedInstance
        commManager.connectPost(urlStr: Constants.Sever.BASE_URL, params: params, listener: listener)
    }
    
    func getLastYearSales (customerid: Int, listener: CommListener!) {
        
        var params = ["sub_id" : "1"]
        params["com_id"] = "1"
        params["get_doc_monthly_balance"] = String(customerid)
        
        let commManager = CommManager.sharedInstance
        commManager.connectPost(urlStr: Constants.Sever.BASE_URL, params: params, listener: listener)
    }
    
    func getTheLast24Hours (customerid: Int, listener: CommListener!) {
        
        var params = ["sub_id" : "1"]
        params["com_id"] = "1"
        params["get_sales_hourly"] = String(customerid)
        
        let commManager = CommManager.sharedInstance
        commManager.connectPost(urlStr: Constants.Sever.BASE_URL, params: params, listener: listener)
    }
    
    func getTheLast24Hours (taskPerformance: Int, taskStatusList: String, listener: CommListener!) {
        
        var params = ["sub_id" : "1"]
        params["com_id"] = "1"
        params["get_task_performance"] = String(taskPerformance)
        params["task_status_list"] = taskStatusList
        
        let commManager = CommManager.sharedInstance
        commManager.connectPost(urlStr: Constants.Sever.BASE_URL, params: params, listener: listener)
    }
    
    func getTheLast24Hours (salesActivityToday: Int, listener: CommListener!) {
    
        var params = ["sub_id" : "1"]
        params["com_id"] = "1"
        params["get_sales_activity_today"] = String(salesActivityToday)
        
        let commManager = CommManager.sharedInstance
        commManager.connectPost(urlStr: Constants.Sever.BASE_URL, params: params, listener: listener)
    }
    
    func getLastYearSales (qtrSalesGetList: Int, inputDate: String, listener: CommListener!) {
        
        var params = ["sub_id" : "1"]
        params["com_id"] = "1"
        params["qtr_sales_get_list"] = String(qtrSalesGetList)
        params["input_date"] = inputDate

        let commManager = CommManager.sharedInstance
        commManager.connectPost(urlStr: Constants.Sever.BASE_URL, params: params, listener: listener)
    }
}
