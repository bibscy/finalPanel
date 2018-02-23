//
//  extensionNoShowViewController.swift
//  finalPanel
//
//  Created by Bogdan Barbulescu on 17/02/2018.
//  Copyright © 2018 Appfish. All rights reserved.
//

import Foundation
import Alamofire
import Firebase

extension NoShowViewController {
    
    
    
    //show an input dialogue with textfield, customize textField color depending on number of characters and collect the input text in order to post it to the server
    func showInputDialogNoShow(message: String, reportNoShow: @escaping () -> Void) {
        
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        
        alertController.addTextField(configurationHandler: { (textField:UITextField) in
            
            textField.delegate = self
            textField.placeholder = "write more details........................................"
            textField.addTarget(self, action: #selector(self.textFieldTextDidChange(_:)), for: .editingChanged)
        })
        
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (alertAction) in
            }
        
            let sendAction = UIAlertAction(title: "Send", style: .default) { (alertAction) in
                let textField = alertController.textFields!.first!
            
                self.commentNoShow = textField.text!
                
                 //create paramas and post to server
                reportNoShow()
        }
        
            alertController.addAction(cancelAction)
            alertController.addAction(sendAction)
        
            self.actionToEnable = sendAction
            sendAction.isEnabled = false
            self.present(alertController, animated:true, completion: nil)
    }
    
//observe changes in textfield
   func textFieldTextDidChange(_ textField: UITextField) {
    
    
    if let alert = presentedViewController as? UIAlertController,
        let action = alert.actions.last,
        let text = textField.text {
        
        if text.characters.count > 10 {
            self.actionToEnable?.isEnabled = true
        } else {
             self.actionToEnable?.isEnabled = false
        }
    }
}
    
    
    
    
    //recompensate the cleaner with amountPaidToCleanerWithoutSuppliesForBooking, that's: (numberOfHours * ratePriceCleaner) .. see more details in ClaimBookingCleaner in server app
    func reportNoShowAsCleanerByAdmin() -> Void {
        
        self.params.removeAll()
        guard let cleanersUID = (FIRAuth.auth()?.currentUser?.uid) else {
            logErr.prints(message: "no uid line \(#line)")
            return
        }

        self.formatDate()
        let urlString =  "http://0.0.0.0:8080/noshowascleaner/byadmin"
        
        //this is the amount the cleaner will be recompensated because could not get access to property
        params["amountPaidToCleanerWithoutSuppliesForBooking"] = self.bookingSelected.AmountPaidToCleanerWithoutSuppliesForBooking
        params["bookingStatusAdmin"] = "true"
        params["bookingAmount"] = self.bookingSelected.BookingAmount
        params["bookingState"] = "Noshow"
        params["bookingStateTimeStamp"] = String(currentTimeStamp)
        params["commentNoShowByReportedCleaner"] = self.commentNoShow
        params["amountDebtToCleaner"] = self.bookingSelected.AmountPaidToCleanerWithoutSuppliesForBooking
        params["reasonDebtToCleaner"] = "Cleaner could not access the property on \(self.currentTimeAsString)"
        params["feeAmountChargedToCleaner"] = "0.0"
        params["feeReasonChargedToCleaner"] = "Cleaner could not access the property on \(self.currentTimeAsString)"
        
        params["costNoShowReportedByCleaner"] = "0.0"
        params["usersUID"] = self.bookingSelected.FirebaseUserID
        params["cleanerUID"] = self.bookingSelected.CleanerUID
        params["userStripeIdCustomer"] = self.bookingSelected.StripeCustomerID
        params["bookingNumber"] = self.bookingSelected.BookingNumber
        params["timeStampBookingClaimed"] = self.bookingSelected.TimeStampBookingClaimed
        params["timeStampBookingNoShowReportedByCleaner"] = String(currentTimeStamp)
        params["claimed"] = self.bookingSelected.Claimed
        params["dateAndTime"] = self.bookingSelected.DateAndTime
        params["timeStampDateAndTime"] = self.bookingSelected.TimeStampDateAndTime
        
                self.postToServer(url: urlString)
    }
    
    
    

    //we will have to refund to the User the full amount initially charged
    func reportNoShowAsUserByAdmin() -> Void {
        
        self.params.removeAll()
        guard let cleanersUID = (FIRAuth.auth()?.currentUser?.uid) else {
            logErr.prints(message: "no uid line \(#line)")
            return
        }
       
      
        self.formatDate()
        let urlString =  "http://0.0.0.0:8080/reportnoshowasuser/byadmin"
        
        params["bookingStatusAdmin"] = "true"
        params["bookingAmount"] = self.bookingSelected.BookingAmount
        params["paymentID"] = self.bookingSelected.PaymentID
        params["bookingState"] = "NoShow"
        params["bookingStateTimeStamp"] = String(currentTimeStamp)
        params["commentNoShowReportedByUser"] = self.commentNoShow
        params["amountDebtToCleaner"] = "0.0"
        params["reasonDebtToCleaner"] = "User reported cleaner did not show up at the property on \(self.currentTimeAsString)"
        params["feeAmountChargedToCleaner"] = "25.0"
        params["feeReasonChargedToCleaner"] = "User reported cleaner did not show up at the property on \(self.currentTimeAsString)"
        params["costNoShowReportedByUser"] = "0.0"
        
        params["usersUID"] = self.bookingSelected.FirebaseUserID
        params["cleanerUID"] = self.bookingSelected.CleanerUID
        params["userStripeIdCustomer"] = self.bookingSelected.StripeCustomerID
        params["bookingNumber"] = self.bookingSelected.BookingNumber
        params["timeStampBookingClaimed"] = self.bookingSelected.TimeStampBookingClaimed
        params["timeStampBookingNoShowReportedByUser"] = String(currentTimeStamp)
        params["claimed"] = self.bookingSelected.Claimed
        params["dateAndTime"] = self.bookingSelected.DateAndTime
        params["timeStampDateAndTime"] = self.bookingSelected.TimeStampDateAndTime
        
        self.postToServer(url: urlString)
    }
    

    
    
    
    
    func displayAlertOrSegue() {
        
        //cast the Json object to Dictionary and check if the response received from server contains the key "success"
        
        if let responseError = objectReceived as? NSDictionary,
            let error = responseError["error"] {
            
            //hide activity indicator
            //            self.activityIndicator.hide(view: self.view)
            
            
            self.messageAlert = "error from server: \(error as! String)"
            print(self.messageAlert)
            let myAlert = UIAlertController(title: "", message: messageAlert, preferredStyle: .alert)
            myAlert.addAction(UIAlertAction(title: "OK", style: .default,  handler: { (action:UIAlertAction) in
                
                self.navigationController?.popToRootViewController(animated: true)
            }))
            
            self.present(myAlert, animated: true, completion: nil)
        }
        
        
        if let responseSuccess = objectReceived as? NSDictionary,
            let success = responseSuccess["success"] {
            //hide activity indicator
            //            self.activityIndicator.hide(view: self.view)
            print("successful response from CancelBookingCleaner: \(success as? String)")
            
            self.navigationController?.popToRootViewController(animated: true)
        }
    } //end of displayAlertOrSegue
    
    
    
    
    
    
    
    
    
    func postToServer(url: String) {
        
        guard !params.isEmpty else {return}
        
        //disabe user interaction
        self.view.isUserInteractionEnabled = false
        
        //send a post request to the server
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: ["Content-Type":"application/json"]).responseJSON { (response: DataResponse<Any>) in
            
            
            self.view.isUserInteractionEnabled = true
            
            
            //check if the Json object could be created,otherwise exit function
            guard let responseReceived = response.result.value else {
                print("error Alamofire \(response.result.value)")
                
                self.activityIndicator.hide(view: self.view)
                self.messageAlert = response.result.error?.localizedDescription
                let myAlert = UIAlertController(title: "", message: self.messageAlert, preferredStyle: .alert)
                
                myAlert.addAction(UIAlertAction(title: "OK", style: .default, handler:nil))
                self.present(myAlert, animated: true, completion: nil)
                return
            }
            
            //assign responseReceived of type JSON to a global var in order to use outside of closure
            self.objectReceived = responseReceived
            print("responseReceived in ClaimDetail is JSON: \(self.objectReceived) line 135")
            
            
            // If no errors occur and the server data is successfully serialized into a JSON object, the response Result will be a .success and the value will be of type Any.
            print("Success : \(response.result.isSuccess) line 139")
            print("Response value is : \(String(describing: response.result.value)) line 140")
            
            
            
            switch response.result {
                
            //display an alert with error or success
            case .success:
                print("JSON could be created, it means we received a value from server")
                self.displayAlertOrSegue()
                
            //display alert with the error the server received if the Alamofire call to server was not successful
            case .failure(let error):
                
                //hide activity indicator
                self.activityIndicator.hide(view: self.view)
                print("error alamofire in .failure case \(error.localizedDescription)")
                self.messageAlert = error.localizedDescription
                
                let myAlert = UIAlertController(title: "", message: self.messageAlert, preferredStyle: .alert)
                myAlert.addAction(UIAlertAction(title: "OK", style: .default, handler:nil))
                self.present(myAlert, animated: true, completion: nil)
                
            }// end of switch
            
        } //end of Alamofire
        
        
    }//end of postToServer()
    
    
    
}//end of extension
