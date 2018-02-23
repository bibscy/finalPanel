//
//  VC1.swift
//  controlpanel
//
//  Created by Bogdan Barbulescu on 12/12/2016.
//  Copyright © 2016 Appfish. All rights reserved.
//


import UIKit

class VC1: UIViewController {

  
    
    @IBOutlet weak var fromDate: UITextField!
    @IBOutlet weak var toDate: UITextField!
    @IBOutlet weak var enterDataTextField: UITextField!

//    var formatter = DateFormatter()
   
//this property enables us to decide in RootController if we will retrieve the bookings assigned to a User or a Cleaner and also show/hide buttons in next controllers
    var bookingOfUserBool:Bool!
    
override func viewDidLoad() {
        super.viewDidLoad()
}
    
    
    //get a single booking object with the uid value obtained from firebase


    @IBAction func getBookingsSingleUser(_ sender: Any) {

        // assign the uid from textField to var currentUid
      FullData.uid = enterDataTextField.text!
        self.bookingOfUserBool = true
        FullData.bookingOfUserBool = self.bookingOfUserBool
        FullData.singleUidBool = true
        self.performSegue(withIdentifier: "segueToRootController", sender: self)
    }
    
    

    
  
    @IBAction func getBookingsSingleCleaner(_ sender: Any) {
  
        // assign the uid from textField to var currentUid
        FullData.uid = enterDataTextField.text!
        self.bookingOfUserBool = false
         FullData.bookingOfUserBool = self.bookingOfUserBool
         FullData.singleUidBool = true
         self.performSegue(withIdentifier: "segueToRootController", sender: self)
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier! {
        case "segueToRootController":
            let rootController = segue.destination as! RootController
            rootController.bookingOfUserBool = self.bookingOfUserBool
        default:
            print("hang on, unhandled case")
        }
    }
    
    
    
    
    
// convert the value from the text field to Date object then convert it to a timestamp
//func convertDate(inputStringDate:String) -> Int {
//    
//    self.formatter.dateFormat = "yyyy-MM-dd HH:mm"
//      self.formatter.date(from: inputStringDate)
//         let stringToDate = self.formatter.date(from: inputStringDate)
//            let timeStamp = Int(stringToDate!.timeIntervalSince1970)
//      return timeStamp
//}
//    

 
    
   //get all bookings of all Users
    @IBAction func getAllBookingsOfUsers(_ sender: Any) {
        
        guard let _ = fromDate.text else { return }
        guard let _ = toDate.text else { return }
        
        FullData.fromDate = convertDateStringToTimpeStamp(inputStringDate: fromDate.text!)
        FullData.toDate = convertDateStringToTimpeStamp(inputStringDate: toDate.text!)
        
        self.bookingOfUserBool = true
        FullData.bookingOfUserBool = self.bookingOfUserBool
        FullData.singleUidBool = false
        self.performSegue(withIdentifier: "segueToRootController", sender: self)
    }
    
    
    
    
    
//get all bookings of all Cleaners
    @IBAction func getAllBookingsOfCleaners(_ sender: Any) {
        guard let _ = fromDate.text else { return }
        guard let _ = toDate.text else { return }
        
        FullData.fromDate = convertDateStringToTimpeStamp(inputStringDate: fromDate.text!)
        FullData.toDate = convertDateStringToTimpeStamp(inputStringDate: toDate.text!)
        
        self.bookingOfUserBool = false
        FullData.bookingOfUserBool = self.bookingOfUserBool
        FullData.singleUidBool = false
        self.performSegue(withIdentifier: "segueToRootController", sender: self)
    }
    
    
    

}//end of class



