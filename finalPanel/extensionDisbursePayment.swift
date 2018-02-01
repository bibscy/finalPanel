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
    
    
    
    //retrieve the profile of cleaner and all bookings
    func startObservingDB(callback: @escaping (( _ bookings: [FireBaseData]?, _ cancelledByArray: [CancelledObject], _ rescheduledByArray: [RescheduledObject] ) -> Void)) {
        
        
        guard let uid = FIRAuth.auth()?.currentUser?.uid  else {
            logError.prints(message: "user should be logged in before making a request to Firebase")
            return
        }

        
        dbRef.child(self.uidOfTextField!).child("bookings").observeSingleEvent(of: .value, with: { (snapshot: FIRDataSnapshot) in
            
   
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
