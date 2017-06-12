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

    var formatter = DateFormatter()
   

override func viewDidLoad() {
        super.viewDidLoad()
}
    
    
    //get a single booking object with the uid value obtained from firebase
    @IBAction func getBookingButton(_ sender: Any) {
        // assign the uid from textField to var currentUid
      FullData.uid = enterDataTextField.text!
    }
    
    
// convert the value from the text field to Date object then convert it to a timestamp
func convertDate(inputStringDate:String) -> Int {
    
    self.formatter.dateFormat = "yyyy-MM-dd HH:mm"
      self.formatter.date(from: inputStringDate)
         let stringToDate = self.formatter.date(from: inputStringDate)
            let timeStamp = Int(stringToDate!.timeIntervalSince1970)
      return timeStamp
}
    

@IBAction func getAllBookings(_ sender: Any) {
    
     print("FullData.toDate iso \(FullData.toDate)")
    // if the textfiled is not empty then convert the value from the textField in a timestamp, else in RootController_1, filter method will not be called because FullData.fromDate will be nil
    
    if let text = fromDate.text, !text.isEmpty {
        // call convertDate function to convert fromDate & toDate to timstamps
            FullData.fromDate = self.convertDate(inputStringDate: fromDate.text!)
                FullData.toDate = self.convertDate(inputStringDate: toDate.text!)
            print("FullData.toDate is\(self.convertDate(inputStringDate: fromDate.text!))")
       
      }
    }
}



