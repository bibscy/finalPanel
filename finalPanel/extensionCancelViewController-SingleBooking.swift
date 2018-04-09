//
//  extensionCancelViewController-SingleBooking.swift
//  finalPanel
//
//  Created by Bogdan Barbulescu on 13/02/2018.
//  Copyright © 2018 Appfish. All rights reserved.
//

import Foundation
import Alamofire

extension CancelViewController {
    
    
    //calculate the amount the User will be charged for cancelling this booking
    //admin will override and cancel the booking on User's behalf
    func calculateCancelAmountForUser(){
        
    
    switch self.timeLeft {
            
         case Int.min..<7200:
            
            // cancel less than 2 hours before booking
            //Refund 0
            //the cost of cancelling = FullData.finalCancelAmount
            FullData.finalCancelAmount = bookingSelected.AmountPaidToCleanerWithoutSuppliesForBooking
            // cancel and process no refund
            FullData.finalAmountRefunded = "0"
            label.text = "You are cancelling less than 2 hours before booking. The full booking amount \(FullData.finalBookingAmount!) will be charged to cancel this booking."
            //alert message for UIAlertController to be displayed
            alertMessage = label.text
            
            print("Less than 2 hours before booking Full booking amount.")
            
            
        //cancel 2-24 hours before booking
        case 7200..<86400:
            print("2-24 hours before booking £10")
            
            //Refund finalBookingAmount - £10
            let amountRefunded = Int(FullData.finalBookingAmount)! - 10
            FullData.finalCancelAmount = "10"
            FullData.finalAmountRefunded = String(amountRefunded)
            
            label.text = "You are cancelling 2-24 hours before booking. \(FullData.finalCancelAmount!) will be charged to cancel this booking. We will refund \(FullData.finalAmountRefunded!)."
            alertMessage = label.text
            
            
        // cancel more than 24 hours before booking
        case 86400..<Int.max:
            
            // Refund full amount
            FullData.finalCancelAmount = "0"
            FullData.finalAmountRefunded = FullData.finalBookingAmount
            label.text = "You are cancelling more than 24 hours before booking. Full booking amount £\(FullData.finalBookingAmount!) will be refunded."
            alertMessage = label.text
            print("more than 24 hours free")
            
                default: print("Hang on, unhandled case...")

        } // end of switch
    } // end of calculateCancelAmountAsUser
    
    
    
    func calculateCancelAmountAsCleaner() {
        
        
        //get string representation of time left until booking starts hh:mm:ss
        let interval = timeLeft
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .full
        let formattedString = formatter.string(from: TimeInterval(interval))!
        self.timeLeftUntilBookingStart = formattedString
        
        
        switch timeLeft {
            
            /*
             
             more than 48 hours = £0
             24 - 48 hours = £10
             4 - 24 hours = £15
             Int.min - 4 hours = £20
             no show = £25
             
             */
            
        case Int.min..<(60 * 60 * 4):
            
            //cancel less than 4 hours before booking
            FullData.finalCancelAmount = "20"
            alertMessage = "You are cancelling less than 4 hours before booking. You will be charged £20"
          
            
            
        case (60 * 60 * 4)..<(60 * 60 * 24):
            
            //Cancel 4 - 24 hours before booking
            FullData.finalCancelAmount = "15"
            alertMessage = "You are cancelling 4-24 hours before booking. You will be chaged £15"
          
            
        case (60 * 60 * 24)..<(60 * 60 * 48):
            
            //Cancel 24 - 48 hours before booking
            FullData.finalCancelAmount = "10"
            alertMessage = "You are cancelling 24-48 hours before booking. You will be chaged £10"
           
            
        case (60 * 60 * 48)..<Int.max:
            
            //Cancel more than 48 hours before booking
            FullData.finalCancelAmount = "0"
            alertMessage = "Are you sure you want to cancel?"
          
            
        default:
            alertMessage = "Hang on, unhandled case..."
           
            
        } // end of switch
        
        
    }//end of calculateCancelAmountAsCleaner

    
    
    
    
    
    func createParamsToCancelAsAdminOnBehalfOfUser() -> [String:Any] {
        
        var params = [String:Any]()
        
        //make it true to indicate that the booking was cancelled by Admin
        FullData.finalAdminBookingStatus = true
        
        params["BookingState"] = "Cancelled"
        params["BookingStateTimeStamp"] = String(timeStampNow)
        
        params["PaymentID"] = FullData.finalPaymentID
        params["StripeCustomerID"] = FullData.finalStripeCustomerID
        params["CancelAmount"] = FullData.finalCancelAmount
        params["AmountRefunded"] = FullData.finalAmountRefunded
        params["TimeStampBookingCancelled"] = self.timeStampNow
        params["FirebaseUserID"] = FullData.finalFirebaseUserID
        params["BookingNumber"] = FullData.finalBookingNumber
        params["BookingStatusAdmin"] = "true"
        
        if bookingSelected.CleanerUID != nil  {
            
            params["AmountDebtToCleaner"] = FullData.finalCancelAmount!
            params["ReasonDebtToCleaner"] = "Booking cancelled by Customer \(self.timeLeftUntilBookingStart!) before booking start time"
            params["FeeAmountChargedToCleaner"] = "0"
            params["FeeReasonChargedToCleaner"] = "Booking cancelled by Customer \(self.timeLeftUntilBookingStart!) before booking start time"
        }
        
            return params
        
    }//end of createParamsToCancelAsAdminOnBehalfOfUser()
    
    
    
    
    func createParamsToCancelWhenNoCleanerClaimsTheBooking() -> [String:Any] {
        
        
        var params = [String:Any]()
        
        params["BookingState"] = "Cancelled"
        params["BookingStateTimeStamp"] = String(timeStampNow)
        
        params["PaymentID"] = bookingSelected.PaymentID
        params["StripeCustomerID"] = FullData.finalStripeCustomerID
        params["CancelAmount"] = "0.0"
        params["BookingAmount"] = bookingSelected.BookingAmount
        params["TimeStampBookingCancelled"] = String(timeStampNow)
        params["FirebaseUserID"] = bookingSelected.FirebaseUserID
        params["BookingNumber"] = bookingSelected.BookingNumber
        params["BookingStatusAdmin"] = "true"
        params["FirebaseUserID"] = bookingSelected.FirebaseUserID
        params["Claimed"] = bookingSelected.Claimed
        return params
    }
    
    
    //-----------
    func createParamsToCancelAsAdminOnBehalfOfCleaner() -> [String:Any] {
        
        var params = [String:Any]()
        
        //make it true to indicate that the booking was cancelled by Admin
        
        params["BookingStatusAdmin"] = "true"
        params["BookingState"] = "Cancelled"
        params["BookingStateTimeStamp"] = String(timeStampNow)
        params["usersUID"] = self.bookingSelected.FirebaseUserID
        params["cleanersUID"] = self.bookingSelected.CleanerUID
        params["userStripeIdCustomer"] = self.bookingSelected.StripeCustomerID
        params["bookingNumber"] = self.bookingSelected.BookingNumber
        params["timeStampBookingClaimed"] = self.bookingSelected.TimeStampBookingClaimed
        params["timeStampBookingCancelledByCleaner"] = String(timeStampNow)
        params["AmountDebtToCleaner"] = "0"
        params["ReasonDebtToCleaner"] = "Booking cancelled by cleaner \(self.timeLeftUntilBookingStart!) before booking start time"
        params["FeeAmountChargedToCleaner"] = FullData.finalCancelAmount
        params["FeeReasonChargedToCleaner"] = "Booking cancelled by cleaner \(self.timeLeftUntilBookingStart!) before booking start time"
        params["CostToCancelByCleaner"] = FullData.finalCancelAmount
        params["claimed"] = self.bookingSelected.Claimed
        params["dateAndTime"] = self.bookingSelected.DateAndTime
        params["timeStampDateAndTime"] = self.bookingSelected.TimeStampDateAndTime
        
        return params
        
    }//end of createParamsToCancelAsAdminOnBehalfOfCleaner()
    

    
    
    
    func postToServer(url: String, params:[String:Any]) {
        
        //send post requst to server
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: ["Content-Type":"application/json"]).responseJSON { response in
            
            
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
    
    
    

    
}//end of extension
