//
//  extensionDisbursePayment.swift
//  finalPanel
//
//  Created by Bogdan Barbulescu on 07/12/2017.
//  Copyright © 2017 Appfish. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseDatabase

extension DisbursePayment {
    
    
    //retrieve the profile of cleaner and its fees
    //after each disbursement fees are saved in /FeesCleaner/ node
    func readFeesCleaner(callback: @escaping ((_ feesCleaner: FeesCleaner) -> Void)) {
      
       
        
        guard (FIRAuth.auth()?.currentUser?.uid) != nil  else {
            let message = "user should be logged in before making a request to Firebase"
                showCustomAlert(customMessage: message, viewController: self)
            logError.prints(message: message)
            return
        }
        
        let activityIndicator = FullDataActivityIndicator()
         activityIndicator.show(view: self.view, targetViewController: self)
        
        dbRef.child("FeesCleaner").child(self.uidOfTextField!).observeSingleEvent(of: .value, with: { (snapshot: FIRDataSnapshot) in
            
             activityIndicator.hide(view: self.view)
            
            print("snapshot.value is \(snapshot.value)")
            guard !(snapshot.value is NSNull) else {
                let message = "FeesCleaner node is empty"
                showCustomAlert(customMessage: message, viewController: self)
                logError.prints(message: message)
                
                return
            }
            
                     
                let feesCleanersReceived = FeesCleaner(snapshot: snapshot)
                    callback(feesCleanersReceived)
            
        }) { (error:Error) in
            print("error on line ,\(#line) is \(error.localizedDescription)")
        }
        
    }//end of func readFeesCleaner
    
    
    
    
    
    
    
    //retrieve all bookings of cleaner
    func startObservingDB(callback: @escaping (( _ bookings: [FireBaseData]?, _ cancelledByArray: [CancelledObject], _ rescheduledByArray: [RescheduledObject], _ noShowReportedByArray: [NoShowObject]) -> Void)) {
        
        
        guard let uid = FIRAuth.auth()?.currentUser?.uid  else {
            let message = "user should be logged in before making a request to Firebase"
            logError.prints(message: message)
            return
        }

        
        let finalRef = dbRef.child("Cleaners").child(self.uidOfTextField!).child("bookings").queryOrdered(byChild: "TimeStampDateAndTime").queryStarting(atValue: String(startDateTimeStamp!)).queryEnding(atValue: String(endDateTimeStamp!))

        print("startDateTimeStamp is \(startDateTimeStamp!) and endDateTimeStamp is \(endDateTimeStamp)")
        let activityIndicator = FullDataActivityIndicator()
            activityIndicator.show(view: self.view, targetViewController: self)
        
        finalRef.observeSingleEvent(of: .value, with: { (snapshot: FIRDataSnapshot) in
            
   print("snapshot.value is  line 81 is \(snapshot.value)")
            
            print("it ends here ")
            //a cleaner may or may not have bookings reason why we use if instead of guard
            var finalBookings = [FireBaseData]()
                for booking in snapshot.children{
                    
                    let bookingItem = FireBaseData(snapshot: booking as! FIRDataSnapshot)
                   
//                    print("bookingItem Cancelled is \(bookingItem.objectsUnderCancelledBy)")
                        finalBookings.append(bookingItem)
                    
                }
            
         
            
            var cancelledByArray: [CancelledObject] {
            
                   var arrayOfObjects = [CancelledObject]()
                 for eachBooking in snapshot.children {
                     let bookingItem = eachBooking as! FIRDataSnapshot
                    
                    for eachChild in bookingItem.children {
                        let item = eachChild as! FIRDataSnapshot
                        
                        if item.key == "CancelledBy" {
                            
                            for timeStamp in item.children {
                                
                                let objectUnderTimeStamp = CancelledObject(snapshot: timeStamp as! FIRDataSnapshot)
                            
                                arrayOfObjects.append(objectUnderTimeStamp)
                        }
                    }
               }
            }
            return arrayOfObjects
        }
            
            
            
            var rescheduledByArray: [RescheduledObject] {
                
                var arrayOfObjects = [RescheduledObject]()
                for eachBooking in snapshot.children {
                    let bookingItem = eachBooking as! FIRDataSnapshot
                    
                    for eachChild in bookingItem.children {
                        let item = eachChild as! FIRDataSnapshot
                        
                        if item.key == "RescheduledBy" {
                            for timeStamp in item.children {
                                
                                let objectUnderTimeStamp = RescheduledObject(snapshot: timeStamp as! FIRDataSnapshot)
                                
                                arrayOfObjects.append(objectUnderTimeStamp)
                            }
                        }
                    }
                }
                return arrayOfObjects
            }
            
            
            var noShowReportedByArray: [NoShowObject] {
                
                var arrayOfObjects = [NoShowObject]()
                for eachBooking in snapshot.children {
                    let bookingItem = eachBooking as! FIRDataSnapshot
                    
                    for eachChild in bookingItem.children {
                        let item = eachChild as! FIRDataSnapshot
                        
                        if item.key == "NoShowBy" {
                            for timeStamp in item.children {
                                
                                let objectUnderTimeStamp = NoShowObject(snapshot: timeStamp as! FIRDataSnapshot)
                                
                                arrayOfObjects.append(objectUnderTimeStamp)
                            }
                        }
                    }
                }
                return arrayOfObjects
            }
            
  
       
//            print("cancelledByArray is \(cancelledByArray)")
            
             activityIndicator.hide(view: self.view)
       
            callback(finalBookings, cancelledByArray, rescheduledByArray, noShowReportedByArray)
            
        }, withCancel: { (Error:Any) in
            
             activityIndicator.hide(view: self.view)
            print("error line \(#line) as\(Error as! String)")
        })
        
        dbRef.removeAllObservers()
        
    }//end of startObserving
    

    
}//end of extension
