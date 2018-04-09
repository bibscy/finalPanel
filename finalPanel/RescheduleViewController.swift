//
//  Reschedule.swift
//  controlpanel
//
//  Created by Bogdan Barbulescu on 14/12/2016.
//  Copyright © 2016 Appfish. All rights reserved.
//

//Reschedule as admin is not implemented in server

import UIKit
import Foundation


class RescheduleViewController: UIViewController {

    
    @IBOutlet weak var rescheduleDatePicker: UIDatePicker!
    var alertMessage = "Please choose a time betwen 7:00 - 19:00."
    var currentTime = Date()
    let timeRestricted = [0,1,2,3,4,5,6,7,19,20,21,22,23]
    var dateComponents = DateComponents()
    var dateFormatter:DateFormatter = DateFormatter()
    var hourComponents:Int = 0
    var dateAndTime = Date()
    let dateKey = "dateAndTimeKeyRescheduleViewControllerSingleBooking"
    let hourKey = "hourComponentsKeyRescheduleViewControllerSingleBooking"
    
    
    // the alert text when checking
    var alertMessageReschedule:String!
    let timeStampNow = Int(Date().timeIntervalSince1970)
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // load current time as minimum date
        self.rescheduleDatePicker.minimumDate = Date(timeInterval: 1, since: currentTime)
        
        
        // Call datePickerAction when rescheduleDatePicker value is changed
        rescheduleDatePicker.addTarget(self, action: #selector(self.datePickerAction(_:)), for: UIControlEvents.valueChanged)
    }

    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // retrieve date and time from NSUserDefaults
        loadDate(true)
        print("dateAndTime line 51 viewDidAppear RescheduleViewController \(dateAndTime)")
        
        
    }
    
    
      
    func datePickerAction(_ sender: UIDatePicker) {
        
        let timeSelected = sender.date
        dateAndTime = timeSelected
        // extract hour component from timeSelected in rescheduleDatePicker
        let unitFlags: NSCalendar.Unit = [.hour]
        let components = (Calendar.current as NSCalendar).components(unitFlags, from: timeSelected)
        let hour = components.hour
        hourComponents = hour!
    }
    

    
    
    @IBAction func rescheduleNow(_ sender: Any) {
    
        savePickerData() // save date to UserDefaults
        
        let currentDate = Date()
        let datePickedTimeStamp = Int(dateAndTime.timeIntervalSince1970)
        let currentDateTimeStamp = Int(currentDate.timeIntervalSince1970)
        
        // calculate the difference between the desired date for booking and current time.
        var timeUntilBooking:Int {
            return datePickedTimeStamp - currentDateTimeStamp
        }
        
        print("Date and time in Picker records \(dateAndTime) and hourComponents is \(hourComponents)")
        
        // check if hour selected is included in timeRestricted
        if timeRestricted.contains(hourComponents) {
            //display the error
            self.alertMessage = "Please choose a time betwen 7:00 - 19:00."
            self.displayAlert()
            
            
            //if there is less than 24 hours left till booking time, display alert
        } else if timeUntilBooking < 86400 {
            alertMessage = "Due to high demand we do not have availability at that time. Please try booking 24 hours away."
            self.displayAlert()
            
            
        } else {
            //calculate amount to charge customer for rescheduling this booking
            calculateRescheduleAmount()
            //display alert with the amount the customer will be charged to reschedule this  booking
            displayRescheduleAmountAlert()
        }
} // end of rescheduleNow
    
    
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toRescheduleCompleted" {
            
if let destViewController = segue.destination as? RescheduleCompleted {
    
    //send the date from UIDatePicker to new controller so as to overwrite the current value in Firebase
          destViewController.TimeStampDateAndTime = String(Int(dateAndTime.timeIntervalSince1970))
    
    // assign dateAndTime to FullData structure which will overwrite the current value in Firebase
                dateFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm"
                FullData.finalDateAndTime = dateFormatter.string(from: dateAndTime)
            }
        }
    }
    
    // calculate the difference between the time when booking was made and current time in order to apply the correct overcharge for cancelling the booking
    var timeLeft:Int{
        return FullData.finalTimeStampDateAndTime - timeStampNow
    }
    
    
    func calculateRescheduleAmount() {
        switch timeLeft {
            
            // reschedule less than 2 hours before booking
            
        case Int.min..<7200:
            
            // basically, retain the full amount for the original booking and charge the customer for a new booking
            //  charge full price of booking as if customer would make a new booking.
            
            FullData.finalAmountChargedToReschedule = FullData.finalBookingAmount
            
            
            //alert message for UIAlertController to be displayed
            alertMessageReschedule = "You are rescheduling less than 2 hours before booking. You will be charged \(FullData.finalAmountChargedToReschedule) to reschedule this booking."
            
            print("Less than 2 hours before booking Full booking amount.")
            
            
        case 7200..<86400:
            print("2-24 hours before booking £10")
            
            //Charge £10
            FullData.finalAmountChargedToReschedule = "10"
            
            //alert message for UIAlertController to be displayed
            alertMessageReschedule = "You are rescheduling 2-24 hours before booking. \(FullData.finalAmountChargedToReschedule) will be charged to reschedule this booking."
            
        case 86400..<Int.max:
            
            // Charge £0
            FullData.finalAmountChargedToReschedule = "0"
            
            //alert message for UIAlertController to be displayed
            alertMessageReschedule = "You are rescheduling more than 24 hours before booking. You will be charged \(FullData.finalAmountChargedToReschedule)."
            
            print("more than 24 hours free")
            
            
        default: print("Hang on, unhandled case...")
        } // end of switch
    } // end of calculateRescheduleAmount
    
    
    
    
    func savePickerData() {
        
        //save date and time to NSUserDefaults
        UserDefaults.standard.set(rescheduleDatePicker.date, forKey: dateKey)
        UserDefaults.standard.set(hourComponents, forKey: hourKey)
        
        // assign the value of rescheduleDatePicker to dateAndTime global variable
        // even if the customer did not touch myDatePicker and moved to next controller, we record the time the customer saw when we segue into next controller
        dateAndTime = rescheduleDatePicker.date
        
        // extract hour component from timeSelected in rescheduleDatePicker
        let unitFlags: NSCalendar.Unit = [.hour]
        let components = (Calendar.current as NSCalendar).components(unitFlags, from: dateAndTime)
        let hour = components.hour
        hourComponents = hour!
    }
    

    
    
    // retrieve date and time from NSUserDefaults
    func loadDate(_ animation:Bool) {
        if let loadedDate = UserDefaults.standard.object(forKey: dateKey) as? Date {
            rescheduleDatePicker.setDate(loadedDate, animated: animation)
            dateAndTime = loadedDate // update the date we are sending to next viewController
        }
        
        if let loadHour = UserDefaults.standard.object(forKey: hourKey) as? Int {
            hourComponents = loadHour
        }
    }
    

    
    //if timeRestricted.contains(hourComponents) display an alert with the error
    func displayAlert() {
        let myAlert = UIAlertController(title: "", message: self.alertMessage, preferredStyle:
            .alert)
        myAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(myAlert, animated: true, completion: nil)
    }
    
    
    
    
    //display an alert with the cost the customer will be charged to reschedule this booking and segue if YES
    func displayRescheduleAmountAlert() {
        let myAlert = UIAlertController(title: "Do you want to reschedule booking?", message:   alertMessageReschedule, preferredStyle: .alert)
        
        //add an action (namely a button) to myAlert UIAlertController
        myAlert.addAction(UIAlertAction(title: "YES", style: .default, handler: { (action:UIAlertAction) in
            self.performSegue(withIdentifier: "toRescheduleCompleted", sender: self)
        }))
        
        myAlert.addAction(UIAlertAction(title: "NO", style: .cancel, handler: nil))
        self.present(myAlert, animated: true, completion: nil)
    }
    

    
    
    
}
