//
//  extensionRootController.swift
//  finalPanel
//
//  Created by Bogdan Barbulescu on 13/02/2018.
//  Copyright © 2018 Appfish. All rights reserved.
//


import Foundation
import Firebase
import FirebaseAuth
import FirebaseDatabase



extension RootController {


    
    
    
    func getBookingsSingleCleaner(callback: @escaping ((_ cleanerObj:[FireBaseData]) -> Void)) {
        dbRef.child("Cleaners").child(FullData.uid!).child("bookings").observe(.value, with: { (snapshot: FIRDataSnapshot) in
            
            // an instance of FireBaseData holding all bookings under Cleaners/cleanerUID/bookings
            var newBookingInfo = [FireBaseData]()
            
            for booking in snapshot.children {
                let bookingItem = FireBaseData(snapshot: booking as! FIRDataSnapshot)
//                print("bookingItem is \(bookingItem)")
                newBookingInfo.append(bookingItem)
            }

            callback(newBookingInfo)
            
        }) { (error: Error) in
            print(error.localizedDescription)
        }
    }
    
    
 
            func getBookingsSingleUser(callback: @escaping ((_ bookings:[FireBaseData]?) -> Void)) {
        
                self.dbRef.child("Users").child(FullData.uid!).observe(.value, with: { (snapshot: FIRDataSnapshot) in

                    // an instance of FireBaseData holding all bookings under currentUid
                    var newBookingInfo = [FireBaseData]()
        
                    //iterate over all children under /FullData.uid! path
                    for customer in snapshot.children {
        
                        //the customer node starting with cus...
                        let customerObject = customer as! FIRDataSnapshot
        
                        //customer key
                        self.customerKey = customerObject.key
                        print("this is the Stripe customer that can be charged \(customerObject.key)")
        
                        //now iterate over each booking which is located under customerObject in Firebase, object starting with cus...
                        for booking in customerObject.children {
        
        
                            // after each iteration through snapshot.children, create an instance of FireBaseData with  'booking' for the current iteration & assign it to bookingItem
                            var bookingItem = FireBaseData(snapshot: booking as! FIRDataSnapshot)
        
                            //assign key of the parent to each booking
                            // the key which starts with cus... represents a Stripe Customer which will be used to charge the client in future, rather than charging a card
                            bookingItem.Key = self.customerKey
        
                            // append the bookingItem after each iteration to newBookingInfo array
                            newBookingInfo.append(bookingItem)
        
                        } // end of  for booking in myCustomer
        
                    } // end of  for customer in snapshot.children
        
                    // sort the array in place so that the most recent date will appear first
                    self.bookingInfo.sort(by: {(DateAndTimeObject_1,DateAndTimeObject_2) -> Bool in
        
                        DateAndTimeObject_1.TimeStampDateAndTime > DateAndTimeObject_2.TimeStampDateAndTime
                    })
        
                    callback(newBookingInfo)
        
//               // reload the data every time FIRDataEventType is triggered by value changes in Database
//                    self.tableView.reloadData()
                }, withCancel: { (Error:Any) in
                    print("Error firebase \(Error)")
                })
                
                //Set the estimatedRowHeight of your table view
                tableView.estimatedRowHeight = 44.0
                // Set the rowHeight of your table view to UITableViewAutomaticDimension
                tableView.rowHeight = UITableViewAutomaticDimension
                
        } // end of readUsersFirebaseSingleBooking()
           
    
    
    
    func getAllBookingsOfCleaners(callback: @escaping ((_ cleanerObj:[FireBaseData]) -> Void)) {
            dbRef.child("Cleaners").observe(.value, with: { (snapshot: FIRDataSnapshot) in
                
                //.child(FullData.uid!).child("bookings")
                
                // an instance of FireBaseData holding all bookings under Cleaners/cleanerUID/bookings
                var newBookingInfo = [FireBaseData]()
                
                for user_child in snapshot.children {
                    let user_snap = user_child as! FIRDataSnapshot //each cleaner node
                    
                    guard user_snap.hasChild("bookings") else {
                        return
                    }
                    

                   let bookingsNode = user_snap.children
                
                for booking in bookingsNode {
                    let bookingItem = FireBaseData(snapshot: booking as! FIRDataSnapshot)
                    //                print("bookingItem is \(bookingItem)")
                    newBookingInfo.append(bookingItem)
                }
        }//end of for user_child in snapshot.children

                
                callback(newBookingInfo)
                
            }) { (error: Error) in
                print(error.localizedDescription)
            }
        }//end of getAllBookingsOfCleaners

    
    
    
    
    
    func getAllBookingsOfAllUsers(callback: @escaping ((_ bookings:[FireBaseData]?) -> Void)) {
        
        self.dbRef.child("Users").observe(.value, with: { (snapshot: FIRDataSnapshot) in
            
          //an instance of FireBaseData holding all bookings under currentUid
            var newBookingInfo = [FireBaseData]()
           
            
       //iterate over each user node child
       for user_child in snapshot.children {
            let user_snap = user_child as! FIRDataSnapshot
        
            //iterate over all children under /Users/Uid
            for customer in user_snap.children {
                
                //the customer node starting with cus...
                let customerObject = customer as! FIRDataSnapshot
                
                //customer key
                self.customerKey = customerObject.key
                print("this is the Stripe customer that can be charged \(customerObject.key)")
                
                //now iterate over each booking which is located under customerObject in Firebase, object starting with cus...
                for booking in customerObject.children {
                    
                    // after each iteration through snapshot.children, create an instance of FireBaseData with  'booking' for the current iteration & assign it to bookingItem
                    var bookingItem = FireBaseData(snapshot: booking as! FIRDataSnapshot)
                    
                    //assign key of the parent to each booking
                    // the key which starts with cus... represents a Stripe Customer which will be used to charge the client in future, rather than charging a card
                    bookingItem.Key = self.customerKey
                    
                    // append the bookingItem after each iteration to newBookingInfo array
                    newBookingInfo.append(bookingItem)
                    
                } // end of  for booking in myCustomer
            } // end of  for customer in snapshot.children
        
        }//end of  for user_child in snapshot.children
            
            // sort the array in place so that the most recent date will appear first
            self.bookingInfo.sort(by: {(DateAndTimeObject_1,DateAndTimeObject_2) -> Bool in
                
                DateAndTimeObject_1.TimeStampDateAndTime > DateAndTimeObject_2.TimeStampDateAndTime
            })
            
            callback(newBookingInfo)
            
            //               // reload the data every time FIRDataEventType is triggered by value changes in Database
            //                    self.tableView.reloadData()
        }, withCancel: { (Error:Any) in
            print("Error firebase \(Error)")
        })
        
        //Set the estimatedRowHeight of your table view
        tableView.estimatedRowHeight = 44.0
        // Set the rowHeight of your table view to UITableViewAutomaticDimension
        tableView.rowHeight = UITableViewAutomaticDimension
        
    }//end of  for user_child in snapshot.children
    
    
    
    
 
   
  
    
    func getBookingsOfAllUID() {
            
            switch self.bookingOfUserBool {
                
            case true:
                
                self.getAllBookingsOfAllUsers { (bookingsUser:[FireBaseData]?) in
                    
                    DispatchQueue.main.async {
                        guard let bookingsReceivedUser = bookingsUser else {
                            print("\(#line) no bookingsReceivedUser")
                            return
                        }
                        self.bookingInfo = bookingsReceivedUser
                        self.tableView.reloadData()
                        print("getting bookings of User \(bookingsReceivedUser)")
                        return
                    }
                }
                
            case false:
                
                print("entering false statement")
                self.getAllBookingsOfCleaners { (bookingsCleaner: [FireBaseData]?) in
                    
                    DispatchQueue.main.async {
                        guard let bookingsReceivedCleaner = bookingsCleaner else {
                            print("\(#line) no bookingsReceivedCleaner ")
                            return
                        }
                        self.bookingInfo = bookingsReceivedCleaner
                        self.tableView.reloadData()
                        print("getting bookings of Cleaner \(bookingsReceivedCleaner)")
                    }
                }
                
            default: print("Hang on, unhandled case \(#line)")
            }//end of switch
    
    }
    
    
    
    
    
    
    
    
    //if bookingOfUserBool was set to true in VC1, get bookings from User node, else Cleaner node
    
    func getBookingsOfSingleUID() {
        
    switch self.bookingOfUserBool {

         case true:
            
            self.getBookingsSingleUser { (bookingsUser:[FireBaseData]?) in
                
                DispatchQueue.main.async {
                    guard let bookingsReceivedUser = bookingsUser else {
                        print("\(#line) no bookingsReceivedUser")
                        return
                    }
                    self.bookingInfo = bookingsReceivedUser
                    self.tableView.reloadData()
                    print("getting bookings of User \(bookingsReceivedUser)")
                    return
                }
            }
            
        case false:
            
            print("entering false statement")
            self.getBookingsSingleCleaner { (bookingsCleaner: [FireBaseData]?) in
                
                DispatchQueue.main.async {
                    guard let bookingsReceivedCleaner = bookingsCleaner else {
                        print("\(#line) no bookingsReceivedCleaner ")
                        return
                    }
                    self.bookingInfo = bookingsReceivedCleaner
                    self.tableView.reloadData()
                    print("getting bookings of Cleaner \(bookingsReceivedCleaner)")
                }
            }
            
        default: print("Hang on, unhandled case \(#line)")
        }//end of switch
    }//end of getBookings()
        
        
    
    //check if we should request bookings for 
    // a single uid entered in textField in VC1 or
    // all uids fromDate - toDate
    func getBookings() {
        
        guard self.bookingOfUserBool != nil else {return}
        
    switch self.singleUidBool {
        case true:
            
            self.getBookingsOfSingleUID()
            
        case false:
            self.getBookingsOfAllUID()
            
        default:
            print("uhh..oh..unhandled case")
        }
        
    }//end of func getBookings
    
    
    
    
    
    
    
    
    
    
    
        
//        if self.bookingOfUserBool! == true {
//            
//            self.startObservingDB { (bookingsUser:[FireBaseData]?) in
//                
//                DispatchQueue.main.async {
//                    guard let bookingsReceivedUser = bookingsUser else {
//                        print("\(#line) no bookingsReceivedUser")
//                        return
//                    }
//                    self.bookingInfo = bookingsReceivedUser
//                    self.tableView.reloadData()
//                    print("getting bookings of User \(bookingsReceivedUser)")
//                    return
//                }
//            }
//        }
//        
//        
//        //else
//        print("entering else statement")
//        self.readCleanersFirebase { (bookingsCleaner: [FireBaseData]?) in
//            
//            DispatchQueue.main.async {
//                guard let bookingsReceivedCleaner = bookingsCleaner else {
//                    print("\(#line) no bookingsReceivedCleaner ")
//                    return
//                }
//                self.bookingInfo = bookingsReceivedCleaner
//                self.tableView.reloadData()
//                print("getting bookings of Cleaner \(bookingsReceivedCleaner)")
//            }
//        }
  
    
    
    
    
    

        
}//end of extension
    
//
//    
//
//
//
//
//
