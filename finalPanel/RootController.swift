//
//  RootController.swift
//  controlpanel
//
//  Created by Bogdan Barbulescu on 12/12/2016.
//  Copyright © 2016 Appfish. All rights reserved.
//



import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class RootController: UITableViewController {
    
    
    //this property enables us to decide in RootController if we will retrieve the bookings assigned to a User or a Cleaner
    //bookingOfUserBool is initiated with the value from VC1 when segue
    var bookingOfUserBool:Bool!
    
    
    //if singleBool == true, getAllBookings for a single user or cleaner entered in the textField in VC1
    //if singleBool == false, getAllBookings for all users or cleaners based on the date of bookings
    var singleUidBool:Bool!
    
    var customerKey:String! // the customer id for Stripe customer retrieved from Firebase
    
    
  var dbRef:FIRDatabaseReference! // create a reference to Firebase
    
    var bookingInfo = [FireBaseData]() // this array will hold all bookings for the logged in user
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         dbRef = FIRDatabase.database().reference()
            self.getBookings()
    
   } // end of viewDidLoad
    
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)

        // needed to clear the text in the back navigation:
        self.navigationItem.title = " "
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        self.navigationItem.title = "RootController"
    }
 
    

       // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

 override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookingInfo.count
    }


    
      // depending on the row selected assign the objects of a booking from 'bookingInfo' array to 'booking' (which is an instance of FireBaseData)
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
       
        let booking = bookingInfo[indexPath.row]
         cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = "Booking# " + booking.BookingNumber + "\n" + booking.DateAndTime + "\n" + booking.PostCode + "\n" + booking.Key + "\n" + "Booking State:" + " "
            //+ booking.BookingState

        

        
        
        print("cellForRowAt was called")
       
        //Cancelled bookings by user  Brown color
        
        if booking.CostToCancelClient != nil {
            print("booking.CostToCancelClient line 250 \(booking.CostToCancelClient)")
            cell.contentView.backgroundColor = .brown
            //booking.CostToCancelClient = nil
            
        } else if
            //Cancelled by Admin   Gray color
            booking.CostToCancelAdmin != nil {
            cell.contentView.backgroundColor = UIColor.gray
            //booking.CostToCancelAdmin = nil
            
        } else if
            //Cancelled by Client   Gray color
            booking.CostToCancelClient != nil {
            cell.contentView.backgroundColor = UIColor.gray
            //booking.CostToCancelClient = nil
            
            
            
        } else if
            //Rescheduled bookings  Admin   blue color
            booking.CostToRescheduleAdmin != nil {
            cell.contentView.backgroundColor = .blue
            //booking.CostToRescheduleAdmin = nil
            
        } else if
            //Rescheduled bookings  Client   blue color
            booking.CostToRescheduleClient != nil {
            cell.contentView.backgroundColor = .blue
            //booking.CostToRescheduleClient = nil
            
            
        } else if
            
            //Active bookings     Clear color
            booking.CostToCancelAdmin == nil || booking.CostToCancelClient == nil {
            print("booking number 244 is \(booking.BookingNumber)")
            print("CostToCancelAdmin line 248 \(booking.CostToCancelAdmin), CostToCancelClient \(booking.CostToCancelClient) ")
            cell.backgroundColor = .clear
            
        } else {
            // if none of the cases above is met, Orange color
            cell.contentView.backgroundColor = UIColor.orange
        }
        
        return cell
        
    } // end of override func tableView


    
     //when a row is selected if the identifier of the segue is "ShowDetail" perform segue
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "segueRootViewControllerToDetailViewController", sender: self)
    }

    

    // DetailViewController is embedded in a UINavigationController
    // between the UINavigationController and DetailViewController there is a Relationship "rootViewController to DetailViewController",
    
    // thus the segue from RootViewController to UINavigationController which holds the DetailViewController, takes us directly to DetailViewController

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueRootViewControllerToDetailViewController" {
            
             // store the indexPath of the row that was selected
            let index = self.tableView.indexPathForSelectedRow! as IndexPath
            
            //This property contains the view controller whose contents should be displayed at the end of the segue.
            let vc = segue.destination as! DetailViewController
            
            
             // depending on the row selected in the tableView assign the objects of a single booking from 'bookingInfo' array to 'bookingSelected' (which is an instance of FireBaseData)
            let bookingSelected = bookingInfo[index.row]
            
            
            // vc is the DetailViewController
            // assign the properties from bookingSelected structure to the properties from the DetailViewController
            
            vc.bookingSelected = bookingSelected
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
            
       
            FullData.finalEmailAddress = bookingSelected.EmailAddress
            FullData.finalStripeCustomerID = bookingSelected.Key
            
            FullData.finalAdminBookingStatus = bookingSelected.BookingStatusAdmin
            FullData.finalClientBookingStatus = bookingSelected.BookingStatusClient
            FullData.finalBookingCompleted = bookingSelected.BookingCompleted
            
            
  if bookingSelected.DoormanOption != nil {
                FullData.finalDoormanOption = bookingSelected.DoormanOption
            }
            
            
            if bookingSelected.EntryInstructions != nil {
                FullData.finalEntryInstructions = bookingSelected.EntryInstructions
            }
            
            if bookingSelected.NoteInstructions != nil {
                FullData.finalNoteInstructions = bookingSelected.NoteInstructions
            }
            
            if bookingSelected.CostToCancelAdmin != nil {
                FullData.costToCancelAdmin = bookingSelected.CostToCancelAdmin
            }
            
            
            if bookingSelected.CostToCancelClient != nil {
                FullData.costToCancelClient = bookingSelected.CostToCancelClient
            }
            
            if bookingSelected.CostToRescheduleAdmin != nil {
                FullData.costToRescheduleAdmin = bookingSelected.CostToRescheduleAdmin
            }
            
            if bookingSelected.CostToRescheduleClient != nil {
               FullData.costToRescheduleClient = bookingSelected.CostToRescheduleClient
            }
            
           
            
            // if at least one of these values != nil,  in DetailViewController  assign true value to bookingCancelled and in DetailViewController hide Reschedule/Cancel buttons
            
            
            //Note** Implement BookingStatus property here
            
            if bookingSelected.CostToCancelAdmin != nil
                || bookingSelected.CostToCancelClient != nil {
                
                print("bookingSelected.CostToCancelAdmin \(bookingSelected.CostToCancelAdmin)  and \(bookingSelected.CostToCancelClient)")
                FullData.bookingCancelled = true
            } else {
                FullData.bookingCancelled = false
       }

            
            //after all tasks above have been completed, deselect row and segue to DetailViewController
            self.tableView.deselectRow(at: index, animated: true)
        }
    }
    
//    // MARK: - UISplitViewControllerDelegate
//    
//    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
//        
//        return true
//    }
}
