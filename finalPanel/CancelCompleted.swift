////
////  CancelCompleted.swift
////  finalPanel
////
////  Created by Bogdan Barbulescu on 09/02/2017.
////  Copyright © 2017 Appfish. All rights reserved.
////
//
//import UIKit
//import Foundation
//import Alamofire
//
//class CancelCompleted: UIViewController {
//
//    var currentDate = Date()
//    var timeStampBookingCancelled:Int!
//    let urlString = "https://secure-garden-28988.herokuapp.com/refund/stripe"
//
//    var params = [String:Any]()
//
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(true)
//        
//    }
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        createParams()
//        postToServer()
//    } // end of viewDidLoad()
//
//   
//    func cancelAsAdminForUser() {
//        
//    }
//    
//    
//    
//    func cancelAsAdminBecauseCleanerDidNotClaim(){
//        
//    }
//    
//    //populate params array
//    func createParams(){
//        
//        //make it true to indicate that the booking was cancelled by Admin
//        FullData.finalAdminBookingStatus = true
//        
//        timeStampBookingCancelled = Int(currentDate.timeIntervalSince1970)
//        
//        
//        //implement BookingStatus
//        params["PaymentID"] = FullData.finalPaymentID
//        params["StripeCustomerID"] = FullData.finalStripeCustomerID
//        params["CancelAmount"] = FullData.finalCancelAmount
//        params["AmountRefunded"] = FullData.finalAmountRefunded
//        params["TimeStampBookingCancelled"] = timeStampBookingCancelled
//        params["FirebaseUserID"] = FullData.finalFirebaseUserID
//        params["BookingNumber"] = FullData.finalBookingNumber
//        params["AdminBookingStatus"] = String(FullData.finalAdminBookingStatus)
//        
//        /* 
//         cancel as admin on behalf of:
//         
//         Cleaner 
//          - observe cleaner's node
//            - if cleaner changes his password, I can't access his application to cancel booking
//              UIDcleaner must exist
//                -
//         
//         
//        User
//         observe user's node
//         
//         
//        as Admin because no cleaner was available to claim the job
//           - don't charge cleaner or user
//           -  observe user's node
//           - refund admin
//         
//         
//         
//        */
//    }
//    
//    var objectReceived:Any! //the JSON object received from in Alamofire
//    var messageAlert:String! // the message to display in myAlert
//    
//
//    
//    func postToServer() {
//        
//        //send post requst to server
//        Alamofire.request(urlString, method: .post, parameters: params, encoding: JSONEncoding.default, headers: ["Content-Type":"application/json"]).responseJSON { response in
//            
//            
//            //the Json object
//            guard let responseReceived = response.result.value else {
//                print("error Alamofire \(response.result.value)")
//                return
//            }
//            
//            self.objectReceived = responseReceived
//            print("responseReceived in CancelCompleted JSON: \(self.objectReceived)")
//            
//            print("Success: \(response.result.isSuccess)")
//            print("Response String: \(response.result.value)")
//            
//            switch response.result {
//            case .success:
//                print("Validation Successful")
//                self.displayAlert() //display an alert with error or success
//                
//            case .failure(let error):
//                print("error alamofire \(error)")
//            }// end of switch
//            
//            
//        } //end of Alamofire
//        
//    } // end of postToServer
//    
//     
//    
//    
//func displayAlert() {
//        //cast the Json object to Dictionary
//        if let responseSuccess = self.objectReceived as? NSDictionary,
//            let success = responseSuccess["success"] {
//            self.messageAlert = success as! String
//        }
//        
//        
//        if let responseError = self.objectReceived as? NSDictionary,
//            let error = responseError["error"] {
//            self.messageAlert = error as! String
//        }
//        
//        
//        let myAlert = UIAlertController(title: "AlertTitle", message: self.messageAlert, preferredStyle: .alert)
//        myAlert.addAction(UIAlertAction(title: "OK", style: .default, handler:nil))
//        self.present(myAlert, animated: true, completion: nil)
//        
//    } //end of displayAlert
//    
//} //end of class
