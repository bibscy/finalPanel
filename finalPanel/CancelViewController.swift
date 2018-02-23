//
//  CancelViewController.swift
//  finalPanel
//
//  Created by Bogdan Barbulescu on 09/02/2017.
//  Copyright © 2017 Appfish. All rights reserved.
//

import UIKit
import Alamofire

class CancelViewController: UIViewController {
  
    var bookingSelected:FireBaseData!

    @IBAction func exportBookings(_ sender: Any) { }

    @IBOutlet weak var label: UILabel!
   
    
    var alertMessage:String!
    var objectReceived:Any! //the JSON object received from in Alamofire
    var messageAlert:String! // the message to display in myAlert
    
    var timeStampNow: Int {
        return Int(Date().timeIntervalSince1970)
    }
    
    //calculate the difference between the time when booking was made and current time in order to apply the correct overcharge for cancelling the booking
    var timeLeft:Int {
        return FullData.finalTimeStampDateAndTime - timeStampNow
    }
    
    //string representation  [.hour, .minute, .second] used in calculateCancelAmountAsCleaner
    var timeLeftUntilBookingStart:String!
    
    //Cancel booking as Admin in the morning 6am or any time we want because the booking has not been claimed by any cleaner and refund full amount charged
    
    //Refund the User full amount
    @IBAction func cancelBookingNotClaimed(_ sender: Any) {
   
        guard bookingSelected.BookingState == "Active" || bookingSelected.BookingState == "Reschedulled" else  {
            print("bookingState should be Active or Reschedulled so that it can be cancelled")
            return
        }
        guard bookingSelected.Claimed != nil else {
            print(" \(#line) value of Claimed is nil") 
            return
        }
        
         if bookingSelected.Claimed == "false"  {
            //cancel
            //refund full amount charged
            
            //display an alert
            let myAlert = UIAlertController(title: "Do you want to cancel booking and Refund FULL Amount of £ \(bookingSelected.BookingAmount)?", message: alertMessage, preferredStyle: .alert)
            //add an action (namely a button) to myAlert UIAlertController
            myAlert.addAction(UIAlertAction(title: "YES", style: .default, handler: { (action:UIAlertAction) in
                
                let parameters = self.createParamsToCancelWhenNoCleanerClaimsTheBooking()
                let urlString = "http://0.0.0.0:8080/cancelandrefundnocleaneravailable/byadmin"
                    self.postToServer(url: urlString, params: parameters)
                
            }))
            //add an action (namely a button) to myAlert UIAlertController
            myAlert.addAction(UIAlertAction(title: "NO", style: .cancel, handler: nil))
            self.present(myAlert, animated: true, completion: nil)

        }
    }
    
    
    

    
 
        //cancel the booking as Admin on behalf of user and apply charges accordingly
    @IBAction func cancelAsUser(_ sender: Any) {
        
    guard bookingSelected.BookingState == "Active" || bookingSelected.BookingState == "Reschedulled" else  {
            print("bookingState should be Active or Reschedulled so that it can be cancelled")
            return
        }

        //calculate amount to charge customer for cancelling this booking
        calculateCancelAmountForUser()
        
        //display an alert
        let myAlert = UIAlertController(title: "Do you want to cancel booking as USER ?", message: alertMessage, preferredStyle: .alert)
        
        //add an action (namely a button) to myAlert UIAlertController
        myAlert.addAction(UIAlertAction(title: "YES", style: .default, handler: { (action:UIAlertAction) in
            
            let parameters = self.createParamsToCancelAsAdminOnBehalfOfUser()
            
            let urlString = "http://0.0.0.0:8080/cancelasadminonbehalfofuser/byadmin"
            self.postToServer(url: urlString, params: parameters)
            
        }))
        
        //add an action (namely a button) to myAlert UIAlertController
        myAlert.addAction(UIAlertAction(title: "NO", style: .cancel, handler: nil))
         self.present(myAlert, animated: true, completion: nil)
    }
    
    
    
    @IBAction func cancelAsCleaner(_ sender: Any) {
        
        guard bookingSelected.BookingState == "Active" || bookingSelected.BookingState == "Reschedulled" && bookingSelected.Claimed == "true"  else  {
            print("bookingState should be Active or Reschedulled and Claimed == true so that it can be cancel on behalf of cleaner")
              return
        }
        
        //calculate amount to charge customer for cancelling this booking
        calculateCancelAmountAsCleaner()
        
        //display an alert
        let myAlert = UIAlertController(title: "Do you want to cancel booking as CLEANER ?", message: alertMessage, preferredStyle: .alert)
        
        //add an action (namely a button) to myAlert UIAlertController
        myAlert.addAction(UIAlertAction(title: "YES", style: .default, handler: { (action:UIAlertAction) in
            
            let parameters = self.createParamsToCancelAsAdminOnBehalfOfCleaner()
            let urlString = "http://0.0.0.0:8080/cancelasadminonbehalfofcleaner/refund"
            self.postToServer(url: urlString, params: parameters)
            
        }))
        
        //add an action (namely a button) to myAlert UIAlertController
        myAlert.addAction(UIAlertAction(title: "NO", style: .cancel, handler: nil))
        self.present(myAlert, animated: true, completion: nil)
    }
    

   
}//end of class
