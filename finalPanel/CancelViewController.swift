//
//  CancelViewController.swift
//  finalPanel
//
//  Created by Bogdan Barbulescu on 09/02/2017.
//  Copyright © 2017 Appfish. All rights reserved.
//

import UIKit

class CancelViewController: UIViewController {
    
    var alertMessage:String!
    @IBOutlet weak var label: UILabel!
     let timeStampNow = Int(Date().timeIntervalSince1970)
    
    
    @IBAction func cancelNow(_ sender: Any) {
        //calculate amount to charge customer for cancelling this booking
        calculateCancelAmount()
        
        //display an alert
        let myAlert = UIAlertController(title: "Do you want to cancel booking?", message: alertMessage, preferredStyle: .alert)
        
        //add an action (namely a button) to myAlert UIAlertController
        myAlert.addAction(UIAlertAction(title: "YES", style: .default, handler: { (action:UIAlertAction) in
            self.performSegue(withIdentifier: "cancelCompletedSingle", sender: self)
        }))
        
        //add an action (namely a button) to myAlert UIAlertController
        myAlert.addAction(UIAlertAction(title: "NO", style: .cancel, handler: nil))
        
        self.present(myAlert, animated: true, completion: nil)
        
    } // end of cancelNow


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    // calculate the difference between the time when booking was made and current time in order to apply the correct overcharge for cancelling the booking
    var timeLeft:Int{
        return FullData.finalTimeStampDateAndTime - timeStampNow
    }
    
    func calculateCancelAmount(){
        switch timeLeft {
            
        case Int.min..<7200:
            
            // cancel less than 2 hours before booking
            //Refund 0
            //the cost of cancelling = FullData.finalCancelAmount
            FullData.finalCancelAmount = FullData.finalBookingAmount
            // cancel and process no refund
            FullData.finalAmountRefunded = "0"
            label.text = "You are cancelling less than 2 hours before booking. The full booking amount \(FullData.finalBookingAmount) will be charged to cancel this booking."
            //alert message for UIAlertController to be displayed
            alertMessage = label.text
            
            print("Less than 2 hours before booking Full booking amount.")
            
            
        //cancel 2-24 hours before booking
        case 7200..<86400:
            print("2-24 hours before booking £10")
            
            //Refund finalBookingAmount - £10
            let amountRefunded = Int(FullData.finalBookingAmount)! - 10
            FullData.finalCancelAmount = "10"
            FullData.finalAmountRefunded = String(amountRefunded)
            
            label.text = "You are cancelling 2-24 hours before booking. \(FullData.finalCancelAmount) will be charged to cancel this booking. We will refund \(FullData.finalAmountRefunded)."
            alertMessage = label.text
            
            
        // cancel more than 24 hours before booking
        case 86400..<Int.max:
            
            // Refund full amount
            FullData.finalCancelAmount = "0"
            FullData.finalAmountRefunded = FullData.finalBookingAmount
            label.text = "You are cancelling more than 24 hours before booking. Full booking amount £\(FullData.finalBookingAmount!) will be refunded."
            alertMessage = label.text
            print("more than 24 hours free")
            
            
        default: print("Hang on, unhandled case...")
            
            
            
        } // end of switch
    } // end of calculateCancelAmount
    
    
    //Also don't forget to check if timeStampNow is in the future, for example the booking date has passed and it was not handled
    //BookingDate: 14 Jan 2017 15:30
    //trying to cancel:15 Jan 08:41
    //evaluates true for this case  case 7200..<86400:
    //    print("2-24 hours before booking £10")
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //
    }

}
