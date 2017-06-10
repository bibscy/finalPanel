//
//  RootController_2.swift
//  finalPanel
//
//  Created by Bogdan Barbulescu on 18/12/2016.
//  Copyright © 2016 Appfish. All rights reserved.
//


import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class RootController_1: UITableViewController, UISplitViewControllerDelegate {
    
    
   
    var customerKey:String! // the customer id for Stripe payments retrieved from Firebase
    
    // create a reference to Firebase
    var dbRef:FIRDatabaseReference!
    var bookingInfo = [FireBaseData]() // this array will hold all bookings for the logged in user
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dbRef = FIRDatabase.database().reference().child("Users")
        
        self.splitViewController?.delegate = self
        self.splitViewController?.preferredDisplayMode = UISplitViewControllerDisplayMode.allVisible
        startObservingDB() // observe the database for value changes
    } // end of viewDidLoad
    
    
    func startObservingDB() {
     dbRef.observe(.value, with: { (snapshot: FIRDataSnapshot) in
        
        // an instance of FireBaseData holding all bookings under currentUid
        var newBookingInfo = [FireBaseData]()
        
        //iterate over each user node child
        for user_child in snapshot.children {
            
            //user_snap is each user, basically this is every user in Firebase
            let user_snap = user_child as! FIRDataSnapshot
            
           
            var customerObject:FIRDataSnapshot!
            //the customer node located immediately under each user
            for customer_snap in user_snap.children {
   
                //customerObject is the JSON object immediately under the user, this is the node that has a key starting with cus...
//this is the id of the customer object that is used to charge a card again.
    // later on we can update the card of customer and always charge the customer instead of card
                customerObject = customer_snap as! FIRDataSnapshot
                
                // the customer key starting with cus...
                 self.customerKey = customerObject.key
                  print("the customer key is \(self.customerKey)")
                guard let cusExists = self.customerKey, cusExists.hasPrefix("cus") else{
                    print(" self.customerKey value \( self.customerKey )")
                    return
                }
                
               //now iterate over each booking which is located under customerObject in Firebase
                for booking in customerObject.children {
                    
  
                    // after each iteration through snapshot.children, create an instance of FireBaseData with  'booking' for the current iteration & assign it to bookingItem
                    var bookingItem = FireBaseData(snapshot: booking as! FIRDataSnapshot)
                    
//assign key of the parent to each booking
// the key which starts with cus... represents a Stripe Customer which will be used to charge the client in future, rather than charging a card
                    bookingItem.Key = self.customerKey
                    // append the bookingItem after each iteration to newBookingInfo array
                    newBookingInfo.append(bookingItem)
             
                     } //end of   for booking in customerObject.children
                 }//end of     for customer_snap in user_snap.children
        } // end of   for user_child in snapshot.children
            
            //assign newBookingInfo to global variable bookingInfo so it can be used globally within the class
            self.bookingInfo = newBookingInfo
        
       
     
        // sort the array in place so that the most recent date will appear first
         self.bookingInfo.sort(by: {(DateAndTimeObject_1,DateAndTimeObject_2) -> Bool in
                
                DateAndTimeObject_1.TimeStampDateAndTime > DateAndTimeObject_2.TimeStampDateAndTime
         })
        
        
 //check if a timestam was entered in fromData/toDate fields from VC1,filter the bookings according to these parameters
        if FullData.fromDate != nil {

   // filter each element in the array against the condition specified in the body of the closure
   self.bookingInfo = self.bookingInfo.filter({(firstElementInArray) -> Bool in
    
    //if both conditions are met, the element will be added to self.bookingInfo
    FullData.fromDate! <= firstElementInArray.TimeStampDateAndTime
       &&
    FullData.toDate! >= firstElementInArray.TimeStampDateAndTime
   })
} // end of if condition
       
        
            print("OurBooking is___ \(self.bookingInfo)")
            // reload the data every time FIRDataEventType is triggered by value changes in Database
            self.tableView.reloadData()
        }, withCancel: { (Error:Any) in
            print("Huge \(Error)")
        })
        
        //  dbRef.removeAllObservers()
        //Set the estimatedRowHeight of your table view
        tableView.estimatedRowHeight = 44.0
        // Set the rowHeight of your table view to UITableViewAutomaticDimension
        tableView.rowHeight = UITableViewAutomaticDimension
    } // end of startObservingDB()
    // stackoverflow.com/questions/30114483
    
    
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return bookingInfo.count
}
    
    
    // depending on the row selected assign the objects of a booking from 'bookingInfo' array to 'booking' (which is an instance of FireBaseData)
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let booking = bookingInfo[indexPath.row]
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = "Booking# " + booking.BookingNumber + "\n" + booking.DateAndTime + "\n" + booking.PostCode + "\n" + booking.Key
      
  
    
        
       //Active bookings     Clear color
 if booking.BookingStatusClient == true &&
           booking.BookingCompleted == false &&
                 booking.BookingStatusAdmin == false &&
                   booking.BookingStatusClient == false {
                          cell.backgroundColor = UIColor.clear
} else if
        //Cancelled bookings by user  Red color
 booking.BookingStatusClient == false &&
     booking.BookingCompleted == false &&
       booking.BookingStatusAdmin == false {
     cell.contentView.backgroundColor = UIColor.red
} else if
        
     //Cancelled by Admin   Brown color
 booking.BookingStatusAdmin == true {
     cell.contentView.backgroundColor = UIColor.brown
            
} else if
        
 // Completed bookings    Green color
 booking.BookingStatusClient == true &&
    booking.BookingCompleted == true {
     cell.contentView.backgroundColor = UIColor.green
} else {
    
    // if none of the cases above is met, Orange color
     cell.contentView.backgroundColor = UIColor.orange
        }
        
    return cell
       
 } // end of override func tableView
    
    
    
    //when a row is selected if the identifier of the segue is "ShowDetail_1" perform segue
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "ShowDetail_1", sender: self)
    }
    
    
    
    // DetailViewController is embedded in a UINavigationController
    // between the UINavigationController and DetailViewController there is a Relationship "rootViewController to DetailViewController",
    
    // thus the segue from RootViewController to UINavigationController which holds the DetailViewController, takes us directly to DetailViewController
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail_1" {
            
            // store the indexPath of the row that was selected
            let index = self.tableView.indexPathForSelectedRow! as IndexPath
            
            //This property contains the view controller whose contents should be displayed at the end of the segue.
            let nav = segue.destination as! UINavigationController
            
            //DetailViewController (namely 'let vc') is currently at index 0 on the navigation stack
            let vc = nav.viewControllers[0] as! DetailViewController_1
            
            // depending on the row selected in the tableView assign the objects of a single booking from 'bookingInfo' array to 'bookingSelected' (which is an instance of FireBaseData)
            let bookingSelected = bookingInfo[index.row]
            
            
            // vc is the DetailViewController
            // assign the properties from bookingSelected structure to the properties from the DetailViewController
            
            
            vc.dateAndTimeReceived = bookingSelected.DateAndTime
            vc.flatNumberReceived = bookingSelected.FlatNumber
            vc.streetAddressReceived = bookingSelected.StreetAddress
            vc.postCodeReceived = bookingSelected.PostCode
            
            vc.insideCabinetsReceived = bookingSelected.insideCabinets
            vc.insideFridgeReceived = bookingSelected.insideFridge
            vc.insideOvenReceived = bookingSelected.insideOven
            vc.laundryWashReceived = bookingSelected.laundryWash
            vc.interiorWindowsReceived = bookingSelected.interiorWindows
            vc.bookingNumberReceived = bookingSelected.BookingNumber
            
            // assign the booking number for the selected row to a global variable to use it later
FullData.finalBookingNumber = bookingSelected.BookingNumber
FullData.finalTimeStampDateAndTime = bookingSelected.TimeStampDateAndTime
FullData.finalBookingAmount = bookingSelected.BookingAmount
FullData.finalPaymentID = bookingSelected.PaymentID
FullData.finalFirebaseUserID = bookingSelected.FirebaseUserID
FullData.finalAdminBookingStatus = bookingSelected.BookingStatusAdmin
FullData.finalStripeCustomerID = bookingSelected.Key

  
            //after all tasks above have been completed, deselect row and segue to DetailViewController
            
            self.tableView.deselectRow(at: index, animated: true)
        }
    }
    
    // MARK: - UISplitViewControllerDelegate
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        
        return true
    }
    
// Swipe to Delete and the More button
    
    // asks the delegate for the actions to display in response to a swipe in the specified row
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        
        //A UITableViewRowAction object defines a single action to present when the user swipes horizontally in a table row.
        var moreActions = UITableViewRowAction(style: .default, title: "More") { (action:UITableViewRowAction, IndexPath: IndexPath)   in
            
            // when moreActions button is tapped, showOptions UIAlertController is shown with the added actions
            let showOptions = UIAlertController(title: "MoreOptions title", message: "Select a button message", preferredStyle: .actionSheet)
            
            let CancelBooking = UIAlertAction(title: "CancelBooking", style: .default, handler:nil)
           
            let MarkUnread = UIAlertAction(title: "MarkUnread", style:.default, handler: { (action) in
                  let selectedCell = tableView.cellForRow(at: IndexPath)
                    selectedCell?.contentView.backgroundColor = UIColor.red
            })
            
            let MarkRead = UIAlertAction(title: "MarkRead", style: .default, handler: { (action) in
                 let unselectCell = tableView.cellForRow(at: IndexPath)
                   unselectCell?.contentView.backgroundColor = UIColor.clear
            })
            
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
           
            
            showOptions.addAction(CancelBooking)
            showOptions.addAction(cancel)
            showOptions.addAction(MarkUnread)
            showOptions.addAction(MarkRead)
            
            self.present(showOptions, animated: true, completion: nil)
}
        
      
            
         return [moreActions]
        } // end of editActionsForRowAt
    }
    
    




// print("keyIS \(snap.key))")
// print("snap.value \(snap.value)")
//get each nodes' data as a Dictionary

