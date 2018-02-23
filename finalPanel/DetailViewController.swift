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
    
    //implement BookingStatus here
    var titles: [String] = ["Date","BookingState","BookingStateTimeStamp", "Booking#", "Address","EntryInfo","EntryInstructions", "Extras","Notes","BookingCancelled","BookingStatusClient","BookingStatusAdmin","BookingCompleted","PaymentID","CostToCancelAdmin","CostToCancelClient","CostToRescheduleAdmin","CostToRescheduleClient","Total"]
    
    var titlesToValues = [String: String]()
 
    @IBAction func reschedule(_ sender: AnyObject) {
    }
    
    
    
    @IBAction func cancel(_ sender: Any) {
        
        self.performSegue(withIdentifier: "segueDetailToCancelViewController", sender: self)
    }
    
    
    @IBAction func reportNoShow(_ sender: Any) {
        
         self.performSegue(withIdentifier: "segueToNoShowViewController", sender: self)
        
//        if bookingSelected.BookingState == "Active" ||
//            bookingSelected.BookingState == "Rescheduled" &&
//            
//            bookingSelected.BookingCompleted == false {
//             self.performSegue(withIdentifier: "segueToNoShowViewController", sender: self)
//        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier! {
            case "segueDetailToCancelViewController":
                
                let vc = segue.destination as! CancelViewController
                vc.bookingSelected = self.bookingSelected

            case "segueToNoShowViewController":
                
                let vc = segue.destination as! NoShowViewController
                vc.bookingSelected = self.bookingSelected
        default:
            print("hang on, unhandled case")
            
        }
    }
    
    
 
    
    @IBAction func exportSimple(_ sender: Any) {
        exportBookingsForCustomerUse()
    }
    
    
    @IBAction func exportFull(_ sender: Any) {
        
        exportAllBookingsAsInFireBase()
    }
    
    var bookingSelected:FireBaseData!
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
    
    let formatter = DateFormatter()
    
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
        
       // "BookingState","BookingStateTimeStamp",
        
        //implement BookingStatus here
        titlesToValues["Date"] = self.dateAndTimeReceived
        titlesToValues["BookingState"] = bookingSelected.BookingState ?? ""
        
        let date = Date(timeIntervalSince1970: 1518959125.0)
//        let date = Date(timeIntervalSince1970: (Double(bookingSelected.BookingStateTimeStamp)!)) 
        formatter.dateFormat = "EEE, dd MMM yyyy HH:mm"
        //"dd-MM-yyyy HH:mm"
        let dateString = formatter.string(from: date)
        titlesToValues["BookingStateTimeStamp"] = dateString
        
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
    
    

    func exportAllBookingsAsInFireBase(){
        // get the documents folder url
        let documentDirectory = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        
        // create the destination url for the text file to be saved
        let fileURL = documentDirectory.appendingPathComponent("file.txt")
        
        print("the path is \(fileURL)")
        
        do {
            // writing to disk
            try FullData.formattedString.write(to: fileURL, atomically: false, encoding: .utf8)
            
            // saving was successful. any code posterior code goes here
            // reading from disk
            do {
                let mytext = try String(contentsOf: fileURL)
                print(mytext)   // "some text\n"
            } catch {
                print("error loading contents of:", fileURL, error)
            }
        } catch {
            print("error writing to url:", fileURL, error)
        }
    }
    
    
    
    
    func exportBookingsForCustomerUse(){
       // get the documents folder url
       let documentDirectory = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
      // create the destination url for the text file to be saved
       let fileURL = documentDirectory.appendingPathComponent("file.txt")
    
       print("the path is \(fileURL)")
    
       do {
       // writing to disk
       try FullData.cleanerString.write(to: fileURL, atomically: false, encoding: .utf8)
    
       // saving was successful. any code posterior code goes here
        // reading from disk
        do {
         let mytext = try String(contentsOf: fileURL)
           print(mytext)   // "some text\n"
         } catch {
             print("error loading contents of:", fileURL, error)
          }
        } catch {
          print("error writing to url:", fileURL, error)
        }
     }
    
} //end of class


