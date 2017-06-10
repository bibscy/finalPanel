//
//  CancelCompleted.swift
//  finalPanel
//
//  Created by Bogdan Barbulescu on 11/01/2017.
//  Copyright © 2017 Appfish. All rights reserved.
//

// When cancelling a booking, you hold a certain amount from the initial price of the booking and refund the rest to the customer
import UIKit
import Foundation
import Alamofire

class CancelCompleted_1: UIViewController {
    
    var currentDate = Date()
    var timeStampBookingCancelled:Int!
    let urlString = "http://0.0.0.0:8080/refund/stripe"
    var params = [String:Any]()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        createParams()
      postToServer()
    } // end of viewDidLoad()

//populate params array
    func createParams(){
   //make it true to indicate that the booking was cancelled by Admin
        FullData.finalAdminBookingStatus = true
        timeStampBookingCancelled = Int(currentDate.timeIntervalSince1970)
     

  params["PaymentID"] = FullData.finalPaymentID
  params["StripeCustomerID"] = FullData.finalStripeCustomerID
  params["CancelAmount"] = FullData.finalCancelAmount
  params["AmountRefunded"] = FullData.finalAmountRefunded
  params["TimeStampBookingCancelled"] = timeStampBookingCancelled
  params["FirebaseUserID"] = FullData.finalFirebaseUserID
  params["BookingNumber"] = FullData.finalBookingNumber
  params["AdminBookingStatus"] = String(FullData.finalAdminBookingStatus)
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
    
    
    } //end of Alamofire
        
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

}  // end of classs
