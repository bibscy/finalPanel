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
            logError.prints(message: "user should be logged in before making a request to Firebase")
            return
        }
    
        
        dbRef.child("FeesCleaner").child(self.uidOfTextField!).observeSingleEvent(of: .value, with: { (snapshot: FIRDataSnapshot) in
            
            let feesCleanersReceived = FeesCleaner(snapshot: (snapshot.value)! as! FIRDataSnapshot)
                    callback(feesCleanersReceived)
            
        }) { (error:Error) in
            print(#line, "\(error.localizedDescription)")
        }
        
    }//end of func readFeesCleaner
    
    
    
    
    
    
    
    //retrieve all bookings of cleaner
    func startObservingDB(callback: @escaping (( _ bookings: [FireBaseData]?, _ cancelledByArray: [CancelledObject], _ rescheduledByArray: [RescheduledObject]) -> Void)) {
        
        
        guard let uid = FIRAuth.auth()?.currentUser?.uid  else {
            logError.prints(message: "user should be logged in before making a request to Firebase")
            return
        }

        
        dbRef.child("Cleaners").child(self.uidOfTextField!).child("bookings").observeSingleEvent(of: .value, with: { (snapshot: FIRDataSnapshot) in
            
   
            //a cleaner may or may no have bookings reason why we use if instead of guard
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
  
       
            print("cancelledByArray is \(cancelledByArray)")
       
            callback(finalBookings, cancelledByArray, rescheduledByArray)
            
        }, withCancel: { (Error:Any) in
            
            print("error lone 45 as\(Error as! String)")
            //            self.messageText = Error as! String
            //            self.showAlert()
        })
        
        dbRef.removeAllObservers()
        
    }//end of startObserving
    

    
}//end of extension
