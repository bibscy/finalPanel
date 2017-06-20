//
//  RescheduleCompleted_1.swift
//  finalPanel
//
//  Created by Bogdan Barbulescu on 09/02/2017.
//  Copyright © 2017 Appfish. All rights reserved.
//

import UIKit
import Foundation
import Alamofire

class RescheduleCompleted_1: UIViewController {

    // the date of the UIPickerView received from RescheduleViewController class
    var TimeStampDateAndTime:String!
    
    var currentDate = Date()
    var TimeStampBookingRescheduledAdmin:Int!
    let urlString = "https://secure-garden-28988.herokuapp.com/rescheduleadmin/stripe"
    //"http://0.0.0.0:8080/rescheduleadmin/stripe"
    var params = [String:Any]()
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        createParams()
        
        print("before createParams FullData.finalDateAndTime \(FullData.finalDateAndTime)")
        postToServer()
        print("after postToServer FullData.finalDateAndTime \(FullData.finalDateAndTime)")
    }


    //populate params array
    func createParams(){
        //make FullData.finalAdminBookingStatus true to indicate that the booking was rescheduled by Admin
        FullData.finalAdminBookingStatus = true
        TimeStampBookingRescheduledAdmin = Int(currentDate.timeIntervalSince1970)
        
        
        params["StripeCustomerID"] = FullData.finalStripeCustomerID //charge the customer rather than card
        params["CostToRescheduleAdmin"] = FullData.finalAmountChargedToReschedule
        params["TimeStampBookingRescheduledAdmin"] = TimeStampBookingRescheduledAdmin
        params["FirebaseUserID"] = FullData.finalFirebaseUserID
        params["BookingNumber"] = FullData.finalBookingNumber
        params["AdminBookingStatus"] = String(FullData.finalAdminBookingStatus)
        params["DateAndTime"] = FullData.finalDateAndTime
        params["TimeStampDateAndTime"] = TimeStampDateAndTime // received from RescheduleViewController
        params["EmailAddress"] = FullData.finalEmailAddress
        
        print("print vars with vars or not vars line 54 RescheduleCompleted_1")
        
       
        print(" StripeCustomerID\(FullData.finalStripeCustomerID)")
         print("CostToRescheduleAdmin \(FullData.finalAmountChargedToReschedule)")
        
         print("TimeStampBookingRescheduledAdmin \(TimeStampBookingRescheduledAdmin)")
         print(" FirebaseUserID\(FullData.finalFirebaseUserID)")
         print("BookingNumber \(FullData.finalBookingNumber)")
         print(" AdminBookingStatus \(String(FullData.finalAdminBookingStatus))")
         print("DateAndTime \(FullData.finalDateAndTime)")
         print(" TimeStampDateAndTime \(TimeStampDateAndTime)")
         print(" EmailAddress\(FullData.finalEmailAddress)")

    }
    
    
    
    var objectReceived:Any! //the JSON object received from in Alamofire
    var messageAlert:String! // the message to display in myAlert
    
    
    func postToServer() {
        
        //send post requst to server
        Alamofire.request(urlString, method: .post, parameters: params, encoding: JSONEncoding.default, headers: ["Content-Type":"application/json"]).responseJSON { response in
            
            //the Json object
            guard let responseReceived = response.result.value else {
                print("error Alamofire \(response.result.value)")
                return
            }
            
            self.objectReceived = responseReceived
            print("responseReceived in CancelCompleted JSON: \(self.objectReceived)")
            
            print("Success: \(response.result.isSuccess)")
            print("Response String: \(response.result.value)")
            
            switch response.result {
            case .success:
                print("Validation Successful")
                self.displayAlert() //display an alert with error or success
                
            case .failure(let error):
                print("error alamofire \(error)")
            }// end of switch
            
        } // end of Alamofire
        
    } // end of postToServer
    
    func displayAlert() {
        //cast the Json object to Dictionary
        if let responseSuccess = self.objectReceived as? NSDictionary,
            let success = responseSuccess["success"] {
            self.messageAlert = success as! String
        }
        
        
        if let responseError = self.objectReceived as? NSDictionary,
            let error = responseError["error"] {
            self.messageAlert = error as! String
        }
        
        
        let myAlert = UIAlertController(title: "AlertTitle", message: self.messageAlert, preferredStyle: .alert)
        myAlert.addAction(UIAlertAction(title: "OK", style: .default, handler:nil))
        self.present(myAlert, animated: true, completion: nil)
        
    } //end of displayAlert
    

} //end of class
