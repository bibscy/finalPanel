//
//  DetailViewController.swift
//  controlpanel
//
//  Created by Bogdan Barbulescu on 12/12/2016.
//  Copyright © 2016 Appfish. All rights reserved.
//


import UIKit

class DetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var cancelButton: UIButton!
 
    @IBOutlet weak var rescheduleButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var titles: [String] = ["Date", "Booking#", "Address","EntryInfo","EntryInstructions", "Extras","Notes","BookingCancelled","BookingStatusClient","BookingStatusAdmin","BookingCompleted","PaymentID","CostToCancelAdmin","CostToCancelClient","CostToRescheduleAdmin","CostToRescheduleClient","Total"]
    
    var titlesToValues = [String: String]()
 
    @IBAction func reschedule(_ sender: AnyObject) {
    }
    
    @IBAction func cancel(_ sender: Any) {
    }
    
    var dateAndTimeReceived:String!
    var flatNumberReceived:String!
    var streetAddressReceived:String!
    var postCodeReceived:String!
    
    var insideCabinetsReceived:Bool!
    var insideFridgeReceived:Bool!
    var insideOvenReceived:Bool!
    var laundryWashReceived:Bool!
    var interiorWindowsReceived:Bool!
    var bookingNumberReceived:String!
    var extrasArray = [String]()
    var addressArray = [String]()
    var entryArray = [String]()
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        // if bookingCancelled is set in RootViewController to true value, then hide buttons
        if  FullData.bookingCancelled == true {
            self.cancelButton.isHidden = true
            self.rescheduleButton.isHidden = true
        }
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
   
        
        addressArray.append(self.flatNumberReceived)
        addressArray.append(self.streetAddressReceived)
        addressArray.append(self.postCodeReceived)
        
        
        titlesToValues["Date"] = self.dateAndTimeReceived
        titlesToValues["Booking#"] = "Booking #" + self.bookingNumberReceived
        titlesToValues["Address"] = addressArray.joined(separator: ",")
        
        
        
        if insideCabinetsReceived == true {
            self.extrasArray.append("Inside Cabinets" + " ")
        }
        
        if insideFridgeReceived == true {
            self.extrasArray.append("Inside Fridge" + " ")
        }
        
        if insideOvenReceived == true {
            self.extrasArray.append("Inside Oven" + " ")
        }
        
        if laundryWashReceived == true {
            self.extrasArray.append("Laundry wash & dry" + " ")
        }
        
        if interiorWindowsReceived == true {
            self.extrasArray.append("Interior Windows" + " ")
        }
        
        
        
        
        
        
        
        //if array is not empty assign the values of extras label
        if !extrasArray.isEmpty{
            // self.extras.text = extrasArray.joined(separator: ",")
            self.titlesToValues["Extras"] = extrasArray.joined(separator: ", ")
        }
        
        if !FullData.finalNoteInstructions.isEmpty {
            //notes.text = FullData.finalNoteInstructions
            titlesToValues["Notes"] = FullData.finalNoteInstructions
        }
        
        
        if FullData.finalDoormanOption != nil {
            titlesToValues["EntryInfo"] = FullData.finalDoormanOption
        }
        
        
        if !FullData.finalEntryInstructions.isEmpty {
            titlesToValues["EntryInstructions"] = FullData.finalEntryInstructions
        }
        
        titlesToValues["BookingCancelled"] = String(FullData.bookingCancelled)
        
        titlesToValues["BookingStatusClient"] = String(FullData.finalClientBookingStatus)
        titlesToValues["BookingStatusAdmin"] = String(FullData.finalAdminBookingStatus)
        titlesToValues["BookingCompleted"] = String(FullData.finalBookingCompleted)
        titlesToValues["PaymentID"] = FullData.finalPaymentID
        
        if FullData.costToCancelAdmin != nil {
            titlesToValues["CostToCancelAdmin"] = FullData.costToCancelAdmin
        }
        
        if FullData.costToCancelClient != nil {
            titlesToValues["CostToCancelClient"] = FullData.costToCancelClient
        }
        
        if FullData.costToRescheduleAdmin != nil {
            titlesToValues["CostToRescheduleAdmin"] = FullData.costToRescheduleAdmin
        }
        
        if FullData.costToRescheduleClient != nil {
            titlesToValues["CostToRescheduleClient"] = FullData.costToRescheduleClient
        }
        
   
        
        titlesToValues["Total"] = FullData.finalBookingAmount
    } // end of viewDidLoad

    
    
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContentCell")
        (cell?.contentView.viewWithTag(1) as? UILabel)?.text = titles[indexPath.row]
        
        (cell?.contentView.viewWithTag(2) as? UILabel)?.text = titlesToValues[titles[indexPath.row]]
        return cell ?? UITableViewCell()
    }
    

    
    
} //end of class


