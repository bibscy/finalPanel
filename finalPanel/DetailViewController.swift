//
//  DetailViewController.swift
//  controlpanel
//
//  Created by Bogdan Barbulescu on 12/12/2016.
//  Copyright © 2016 Appfish. All rights reserved.
//


import UIKit

class DetailViewController: UIViewController {
    
    
    @IBOutlet weak var dateAndTime: UILabel!
    @IBOutlet weak var flatNumber: UILabel!
    @IBOutlet weak var streetAddress: UILabel!
    @IBOutlet weak var postCode: UILabel!
    @IBOutlet weak var extras: UILabel!
    @IBOutlet weak var bookingNumberLabel: UILabel!
    
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
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
    
 
        
        
    }
    
}


