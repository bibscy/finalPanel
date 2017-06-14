//
//  FireBaseData.swift
//  controlpanel
//
//  Created by Bogdan Barbulescu on 12/12/2016.
//  Copyright © 2016 Appfish. All rights reserved.


import Foundation
import UIKit
import Firebase
import FirebaseDatabase




struct FireBaseData {
   
    // Create our Firebase Data model
    // get arbitrary data
    
    var FirebaseUserID:String!
    var PaymentID:String!
    var BookingAmount:String!
    var BookingNumber:String!
    var Key:String!
    var PostCode:String!
    var SelectedBathRow:Int!
    var SelectedBedRow:Int!
    
    var DateAndTime:String!
     var TimeStampDateAndTime:Int!
    var TimeStampBookingSavedInDB:Int!
    
    var BookingStatusClient:Bool!
    var BookingStatusAdmin:Bool!
    var BookingCompleted:Bool!
    
    
    //used in RootController and RootController1 to determine if the booking has already been cancelled or not
    var CostToCancelClient:String!
    var CostToCancelAdmin:String!
    
    var CostToRescheduleAdmin:String!
    var CostToRescheduleClient:String!
    
    var DoormanOption:String!
    var EntryInstructions:String!
    var NoteInstructions:String!

    
    var FrequencyName:String!
    var FrequecyAmount:Int!
    var insideCabinets:Bool!
    var insideFridge:Bool!
    var insideOven:Bool!
    var laundryWash:Bool!
    var interiorWindows:Bool!
    
    var SuppliesName:String!
    var SuppliesAmount:Int!
    var FullName:String!
    var FlatNumber:String!
    var StreetAddress:String!
    var PhoneNumber:String!
    var EmailAddress:String!
    
    let Ref:FIRDatabaseReference?
    
    init(BookingAmount:String,
         BookingNumber:String,
         PostCode:String,
         SelectedBathRow:Int,
SelectedBedRow:Int,
DateAndTime:String,
TimeStampDateAndTime:Int,

BookingStatusClient:Bool,
BookingStatusAdmin:Bool,
BookingCompleted:Bool,

FrequencyName:String,
FrequecyAmount:Int,
insideCabinets:Bool,
insideFridge:Bool,
insideOven:Bool,
laundryWash:Bool,
interiorWindows:Bool,
FullName:String,
SuppliesName:String,
SuppliesAmount:Int,
FlatNumber:String,
StreetAddress:String,
PhoneNumber:String,
EmailAddress:String,
Key:String = "") {
        
        self.BookingAmount = BookingAmount
        self.BookingNumber = BookingNumber
        self.Key = Key
        self.PostCode = PostCode
        self.SelectedBathRow = SelectedBathRow
        self.SelectedBedRow = SelectedBedRow
        self.DateAndTime = DateAndTime
        self.TimeStampDateAndTime = TimeStampDateAndTime
        
        self.BookingStatusClient = BookingStatusClient
        self.BookingStatusAdmin = BookingStatusAdmin
        self.BookingCompleted = BookingCompleted

        
        self.FrequencyName = FrequencyName
        self.FrequecyAmount = FrequecyAmount
        
        self.insideCabinets = insideCabinets
        self.insideFridge = insideFridge
        self.insideOven = insideOven
        self.laundryWash = laundryWash
        self.interiorWindows = interiorWindows
        
        self.FullName = FullName
        self.SuppliesName = SuppliesName
        self.SuppliesAmount = SuppliesAmount
        self.FlatNumber = FlatNumber
        
        self.StreetAddress = StreetAddress
        self.PhoneNumber = PhoneNumber
        self.EmailAddress = EmailAddress
        self.Ref = nil
        
    }
    
    // Content
    // receive data from our firebase database
    
    init(snapshot:FIRDataSnapshot){
        
        if let firebaseUserID = (snapshot.value! as? NSDictionary)?["FirebaseUserID"] as? String {
            FirebaseUserID = firebaseUserID
        }
        
      if let paymentID = (snapshot.value! as? NSDictionary)?["PaymentID"] as? String {
            PaymentID = paymentID
        }
        
        if let BookingAmountContent = (snapshot.value! as? NSDictionary)?["BookingAmount"] as? String {
            BookingAmount = BookingAmountContent
        }
        
        if let BookingNumberContent = (snapshot.value! as? NSDictionary)?["BookingNumber"] as? String {
            BookingNumber = BookingNumberContent
        }
        
        Key = snapshot.key
        Ref = snapshot.ref
        
        if let PostCodeContent = (snapshot.value! as? NSDictionary)?["PostCode"] as? String {
            PostCode = PostCodeContent
        }
        
        if let SelectedBathRowContent = (snapshot.value! as? NSDictionary)?["SelectedBathRow"] as? String {
            SelectedBathRow = Int(SelectedBathRowContent)
        }
        
        if let SelectedBedRowContent = (snapshot.value! as? NSDictionary)?["SelectedBedRow"] as? String {
            SelectedBedRow = Int(SelectedBedRowContent)
        }
        
        if let DateAndTimeContent = (snapshot.value! as? NSDictionary)?["DateAndTime"] as? String {
            DateAndTime = DateAndTimeContent
        }
        
        
        
        if let TimeStampDateAndTimeContent = (snapshot.value! as? NSDictionary)?["TimeStampDateAndTime"] as? String {
            TimeStampDateAndTime = Int(TimeStampDateAndTimeContent)
        }
        
        if let TimeStampBookingSavedInDBContent = (snapshot.value! as? NSDictionary)?["TimeStampBookingSavedInDB"] as? String {
        TimeStampBookingSavedInDB = Int(TimeStampBookingSavedInDBContent)
        }
        
        
        if let BookingStatusClientContent = (snapshot.value! as? NSDictionary)?["BookingStatusClient"] as? String{
            BookingStatusClient = Bool(BookingStatusClientContent)
        }
        
        
        
        if let BookingStatusAdminContent = (snapshot.value! as? NSDictionary)?["BookingStatusAdmin"] as? String {
            BookingStatusAdmin = Bool(BookingStatusAdminContent)
        }
        
        if let BookingCompletedContent = (snapshot.value! as? NSDictionary)?["BookingCompleted"] as? String {
            BookingCompleted = Bool(BookingCompletedContent)
        }

        
        
        if let costToCancelCient = (snapshot.value! as? NSDictionary)?["CostToCancelClient"] as? String {
            CostToCancelClient = costToCancelCient
        }
        
        
        if let costToCancelAdmin = (snapshot.value! as? NSDictionary)?["CostToCancelAdmin"] as? String {
            CostToCancelAdmin  = costToCancelAdmin
        }
        
        
        if let costToRescheduleAdmin = (snapshot.value! as? NSDictionary)?["CostToRescheduleAdmin"] as? String {
            CostToRescheduleAdmin = costToRescheduleAdmin
        }
        
        if let costToRescheduleClient = (snapshot.value! as? NSDictionary)?["CostToRescheduleClient"] as? String {
            CostToRescheduleClient = costToRescheduleClient
        }
     
        
        
        
   
        
        if let doormanOption = (snapshot.value! as? NSDictionary)?["DoormanOption"] as? String {
            DoormanOption = doormanOption
        }
        
        if let entryInstructions = (snapshot.value! as? NSDictionary)?["EntryInstructions"] as? String {
            EntryInstructions = entryInstructions
        }
        
        if let noteInstructions = (snapshot.value! as? NSDictionary)?["NoteInstructions"] as? String {
            NoteInstructions = noteInstructions
        }
        
        
        
        if let FrequencyNameContent = (snapshot.value! as? NSDictionary)?["FrequencyName"] as? String {
            FrequencyName = FrequencyNameContent
        }
        
        if let FrequecyAmountContent = (snapshot.value! as? NSDictionary)?["FrequecyAmount"] as? String {
            FrequecyAmount = Int(FrequecyAmountContent)
        }
        
        if let insideCabinetsContent = (snapshot.value! as? NSDictionary)?["InsideCabinets"] as? String {
            insideCabinets = Bool(insideCabinetsContent)
        }
        
        if let insideFridgeContent = (snapshot.value! as? NSDictionary)?["InsideFridge"] as? String {
            insideFridge = Bool(insideFridgeContent)
        }
        
        if let insideOvenContent = (snapshot.value! as? NSDictionary)?["InsideOven"] as? String {
            insideOven = Bool(insideOvenContent)
        }
        
        if let laundryWashContent = (snapshot.value! as? NSDictionary)?["LaundryWash"] as? String {
            laundryWash = Bool(laundryWashContent)
        }
        
        if let interiorWindowsContent = (snapshot.value! as? NSDictionary)?["InteriorWindows"] as? String {
            interiorWindows = Bool(interiorWindowsContent)
        }
        
        
        if let FullNameContent = (snapshot.value! as? NSDictionary)?["FullName"] as? String {
            FullName = FullNameContent
        }
        
        if let SuppliesNameContent = (snapshot.value! as? NSDictionary)?["SuppliesName"] as? String {
            SuppliesName = SuppliesNameContent
        }
        
        if let SuppliesAmountContent = (snapshot.value! as? NSDictionary)?["SuppliesAmount"] as? String {
            SuppliesAmount = Int(SuppliesAmountContent)
        }
        
        if let FlatNumberContent = (snapshot.value! as? NSDictionary)?["FlatNumber"] as? String {
            FlatNumber = FlatNumberContent
        }
        
        if let StreetAddressContent = (snapshot.value! as? NSDictionary)?["StreetAddress"] as? String {
            StreetAddress = StreetAddressContent
        }
        
        if let PhoneNumberContent = (snapshot.value! as? NSDictionary)?["PhoneNumber"] as? String {
            PhoneNumber = PhoneNumberContent
        }
        
        if let EmailAddressContent = (snapshot.value! as? NSDictionary)?["EmailAddress"] as? String {
            EmailAddress = EmailAddressContent
        }
}
    
    

    func toAnyObject() -> AnyObject {
        
        var someDict = [String : Any]()
        
        someDict["FirebaseUserID"] = self.FirebaseUserID as AnyObject?
        someDict["PaymentID"] = self.PaymentID as AnyObject?
        someDict["BookingAmount"] = self.BookingAmount as AnyObject?
        someDict["BookingNumber"] = self.BookingNumber as AnyObject?
        someDict["PostCode"] = self.PostCode as AnyObject?
        someDict["SelectedBathRow"] = self.SelectedBathRow as AnyObject?
        someDict["SelectedBedRow"] = self.SelectedBedRow as AnyObject?
        someDict["DateAndTime"] = self.DateAndTime as AnyObject?
        someDict["TimeStampDateAndTime"] = self.TimeStampDateAndTime as AnyObject?
        someDict["TimeStampBookingSavedInDB"] = self.TimeStampBookingSavedInDB as AnyObject?
        someDict["BookingStatusClient"] = self.BookingStatusClient as AnyObject?
        someDict["BookingStatusAdmin"] = self.BookingStatusAdmin as AnyObject?
        someDict["BookingCompleted"] = self.BookingCompleted as AnyObject?
        
        someDict["CostToCancelClient"] = self.CostToCancelClient as AnyObject?
        someDict["CostToCancelAdmin"] = self.CostToCancelAdmin as AnyObject?
        someDict["CostToRescheduleAdmin"] = self.CostToRescheduleAdmin as AnyObject?
        someDict["CostToRescheduleClient"] = self.CostToRescheduleClient as AnyObject?
        
        someDict["DoormanOption"] = self.DoormanOption as AnyObject?
        someDict["EntryInstructions"] = self.EntryInstructions as AnyObject?
        someDict["NoteInstructions"] = self.NoteInstructions as AnyObject?
        
        
        someDict["FrequencyName"] = self.FrequencyName as AnyObject?
        someDict["FrequecyAmount"] = self.FrequecyAmount as AnyObject?
        someDict["insideCabinets"] = self.insideCabinets ? "true" : "false"
        someDict["insideFridge"] = self.insideFridge ? "true" : "false"
        someDict["insideOven"] = self.insideOven ? "true" : "false"
        someDict["laundryWash"] = self.laundryWash ? "true" : "false"
        someDict["interiorWindows"] = self.interiorWindows ? "true" : false
        someDict["FullName"] = self.FullName as AnyObject?
        someDict["SuppliesName"] = self.SuppliesName as AnyObject?
        someDict["SuppliesAmount"] = self.SuppliesAmount as AnyObject?
        someDict["FlatNumber"] = self.FlatNumber as AnyObject?
        someDict["StreetAddress"] = self.StreetAddress as AnyObject?
        someDict["PhoneNumber"] = self.PhoneNumber as AnyObject?
        someDict["EmailAddress"] = self.EmailAddress as AnyObject?
        
        return someDict as AnyObject
        
    }
 

}


