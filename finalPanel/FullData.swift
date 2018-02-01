//
//  FullData.swift
//  controlpanel
//
//  Created by Bogdan Barbulescu on 12/12/2016.
//  Copyright © 2016 Appfish. All rights reserved.
//

import Foundation
import UIKit






//display an alert when cancel button is tapped
func showCustomAlert(customMessage:String, viewController:UIViewController) {
    
    let myAlert = UIAlertController(title: "", message: customMessage, preferredStyle: .alert)
    //add an action (namely a button) to myAlert UIAlertController
        myAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
         viewController.present(myAlert, animated: true, completion: nil)
}




class LogError {
    init() {}
    
    func prints(function: String = #function,
                line:Int = #line,
                file:String = #file,
                message: String? = "",
                code:Int? = 0) {
        
        print("\(function): error on line \(line) in \(file) is message: \(String(describing: message)), code: \(String(describing: code))).")
    }
}


let logError = LogError()




func convertDateStringToTimpeStamp(inputStringDate: String) -> Int {
    
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm"
    formatter.date(from: inputStringDate)
    let stringToDate = formatter.date(from: inputStringDate)
    let timeStamp = Int(stringToDate!.timeIntervalSince1970)
    return timeStamp
}



struct FullData {
    static  var uid:String!
    static  var finalEmailAddress:String!
    static  var finalDateAndTime:String!
    static  var finalBookingNumber:String!
    static  var finalBookingAmount:String!
    static  var finalCancelAmount:String!
    static  var finalAmountRefunded:String!
    static var finalAmountChargedToReschedule:String!
    
    static  var  finalClientBookingStatus:Bool!
    static  var finalBookingCompleted:Bool!
    static  var finalAdminBookingStatus:Bool!
    static var  finalPaymentID:String!
    static var  finalFirebaseUserID:String!
    static var  finalStripeCustomerID:String!
    
    static var finalDoormanOption:String!
    static var finalEntryInstructions:String = "No"
    static var finalNoteInstructions:String = "No"
    static var bookingCancelled:Bool = false
    
    static var costToCancelAdmin:String!
    static var costToCancelClient:String!
    
    static var costToRescheduleAdmin:String!
    static var costToRescheduleClient:String!
    
    static var finalTimeStampDateAndTime:Int!
    
    static var fromDate:Int!
    static var toDate:Int!
    

    static var formattedString:String!
    static var cleanerString:String!
    
    
}







