//
//  DetailViewController_1.swift
//  finalPanel
//
//  Created by Bogdan Barbulescu on 18/12/2016.
//  Copyright © 2016 Appfish. All rights reserved.
//

import UIKit

import UIKit

class DetailViewController_1: UIViewController {
    
    
    @IBOutlet weak var dateAndTime: UILabel!
    @IBOutlet weak var flatNumber: UILabel!
    @IBOutlet weak var streetAddress: UILabel!
    @IBOutlet weak var postCode: UILabel!
    @IBOutlet weak var extras: UILabel!
    @IBOutlet weak var bookingNumberLabel: UILabel!
    
    
    @IBAction func reschedule(_ sender: AnyObject) {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("the key has passed \(FullData.finalStripeCustomerID)")
        
        self.dateAndTime.text = self.dateAndTimeReceived
        self.flatNumber.text = self.flatNumberReceived
        self.streetAddress.text = self.streetAddressReceived
        self.postCode.text = self.postCodeReceived
        self.bookingNumberLabel.text =  self.bookingNumberReceived
        self.bookingNumberLabel.text = self.bookingNumberReceived
        
        if insideCabinetsReceived == true {
            self.extrasArray.append("Inside Cabinets")
            
        }
        
        if insideFridgeReceived == true {
            self.extrasArray.append("Inside Fridge")
        }
        
        if insideOvenReceived == true {
            self.extrasArray.append("Inside Oven")
            
        }
        
        if laundryWashReceived == true {
            self.extrasArray.append("Laundry wash & dry")
        }
        
        if interiorWindowsReceived == true {
            self.extrasArray.append("Interior Windows")
            
        }
        
        
        for i in extrasArray {
            self.extras.text?.append(i + ",")
        }
        
        
    }  // end of viewDidLoad
    
    
    
}

