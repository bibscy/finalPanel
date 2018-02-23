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
    
    var AmountPaidToCleanerWithoutSuppliesForBooking:String! // calculated when cleaner claims booking
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
    var TimeStampBookingClaimed:String!
    
    var BookingStatusClient:Bool!
    var BookingStatusAdmin:Bool!
    var BookingCompleted:Bool!
    var BookingState:String! //Active/Rescheduled/Cancelled/Completed/NoShow
    var BookingStateTimeStamp:String!
    var Claimed:String!
    
    //used in RootController and RootController1 to determine if the booking has already been cancelled or not
    var CostToCancelClient:String!
    var CostToCancelAdmin:String!
    
    var CostToRescheduleAdmin:String!
    var CostToRescheduleClient:String!
    
    var StripeCustomerID:String!
    var CleanerUID:String!
    
    
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
    var RatePriceClient:String!
    var RateNumberClient:String!
    
    var RatePriceCleaner:String!
    var RateNumberCleaner:String!
    
    var NumberOfHours:String!
    var AmountPaidToCleanerForBooking:String!
    
    
    var ProfitForBooking:String!

    
    var checkInDate:String!
    var checkOutDate:String!
    var checkInTimeStamp:String!
    var checkOutTimeStamp:String!
    
    var objectsUnderCancelledBy:[String: AnyObject]!
    var objectsUnderRescheduledBy:[String: AnyObject]!
    
    
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
//
    // Content
    // receive data from our firebase database
    
    
    init(snapshot:FIRDataSnapshot){
        
        
        if let amountPaidToCleanerWithoutSuppliesForBooking =
            (snapshot.value! as? NSDictionary)?["AmountPaidToCleanerWithoutSuppliesForBooking"] as? String {
            self.AmountPaidToCleanerWithoutSuppliesForBooking = amountPaidToCleanerWithoutSuppliesForBooking
        }
        
        if let firebaseUserID = (snapshot.value! as? NSDictionary)?["FirebaseUserID"] as? String {
            FirebaseUserID = firebaseUserID
        }
        
      if let paymentID = (snapshot.value! as? NSDictionary)?["PaymentID"] as? String {
            PaymentID = paymentID
        }
        
        if let BookingAmountContent = (snapshot.value! as? NSDictionary)?["BookingAmount"] as? String {
            BookingAmount = BookingAmountContent
        }
        
        
       
        //check if a booking was Cancelled before and if it was assign each object to cancelledItems array
        if ((snapshot.value! as? NSDictionary)?["BookingNumber"] as? String) != nil {
            
            var cancelledItems = [String: AnyObject]()
            
            //each key:value under the bookingNumber
            for item in snapshot.children {
           let elementUnderBookingNumber = item as! FIRDataSnapshot
                if elementUnderBookingNumber.key == "CancelledBy" {
                  
                    //iterate through the elements under each timeStamp
                    for objectUnderTimeStamp in elementUnderBookingNumber.children {
                        let item = CancelledObject(snapshot: objectUnderTimeStamp as! FIRDataSnapshot)
                        
                        cancelledItems["\(item.key!)"] = item.toAnyObject()
                    }
                }
            }
            self.objectsUnderCancelledBy = cancelledItems
            
//            print("self.objectsUnderCancelledBy 190 \(self.objectsUnderCancelledBy)")
//            
//            print("")
//            print(" self.objectsUnderCancelledBy \( self.objectsUnderCancelledBy)")

        }//end of if let bookingNO
        
        
        
        
        //check if a booking was Rescheduled before and if it was assign each object to cancelledItems array
        if ((snapshot.value! as? NSDictionary)?["BookingNumber"] as? String) != nil {
            
            var rescheduledItems = [String: AnyObject]()
            
            //each key:value under the bookingNumber
            for item in snapshot.children{
                let elementUnderBookingNumber = item as! FIRDataSnapshot
                if elementUnderBookingNumber.key == "RescheduledBy" {
                    
                    //iterate through the elements under each timeStamp
                    for objectUnderTimeStamp in elementUnderBookingNumber.children {
                        let item = RescheduledObject(snapshot: objectUnderTimeStamp as! FIRDataSnapshot)
                        
                        rescheduledItems["\(item.key!)"] = item.toAnyObject()
                    }
                }
            }
            self.objectsUnderRescheduledBy = rescheduledItems
            
            //            print("self.objectsUnderRescheduledBy 221 \(self.objectsUnderRescheduledBy)")

        }//end of if let bookingNO
        
        
        
        
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
        
        
        if let TimeStampBookingClaimedContent = (snapshot.value! as? NSDictionary)?["TimeStampBookingClaimed"] as? String {
            TimeStampBookingClaimed = TimeStampBookingClaimedContent
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

        if let BookingStateContent = (snapshot.value! as? NSDictionary)?["BookingState"] as? String {
            BookingState = BookingStateContent
        }

        
        if let BookingStateTimeStampContent = (snapshot.value! as? NSDictionary)?["BookingStateTimeStamp"] as? String {
            BookingStateTimeStamp = BookingStateTimeStampContent
        }

        if let ClaimedContent = (snapshot.value! as? NSDictionary)?["Claimed"] as? String {
            Claimed = ClaimedContent
        }

        
        if let costToCancelCient = (snapshot.value! as? NSDictionary)?["CostToCancelClient"] as? String {
            CostToCancelClient = costToCancelCient
    } else {
            CostToCancelClient = nil
        }
        
        
        if let costToCancelAdmin = (snapshot.value! as? NSDictionary)?["CostToCancelAdmin"] as? String {
            CostToCancelAdmin  = costToCancelAdmin
    } else {
            CostToCancelAdmin = nil
        }
        
        
        if let costToRescheduleAdmin = (snapshot.value! as? NSDictionary)?["CostToRescheduleAdmin"] as? String {
            CostToRescheduleAdmin = costToRescheduleAdmin
        } else {
            CostToRescheduleAdmin = nil
        }
            
        
        if let costToRescheduleClient = (snapshot.value! as? NSDictionary)?["CostToRescheduleClient"] as? String {
            CostToRescheduleClient = costToRescheduleClient
        } else {
            CostToRescheduleClient = nil
        }
   
        if let stripeCustomerID = (snapshot.value! as? NSDictionary)?["StripeCustomerID"] as? String {  StripeCustomerID = stripeCustomerID
        }
        
        if let cleanerUID = (snapshot.value! as? NSDictionary)?["CleanerUID"] as? String {
            CleanerUID = cleanerUID
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
        
        if let RatePriceClientContent = (snapshot.value! as? NSDictionary)?["RatePriceClient"] as? String {
            RatePriceClient = RatePriceClientContent
        }
        
        if let RateNumberClientContent = (snapshot.value! as? NSDictionary)?["RateNumberClient"] as? String {
            RateNumberClient = RateNumberClientContent
        }
        
        if let RatePriceCleanerContent = (snapshot.value! as? NSDictionary)?["RatePriceCleaner"] as? String {
            RatePriceCleaner = RatePriceCleanerContent
        }
        
        if let RateNumberCleanerContent = (snapshot.value! as? NSDictionary)?["RateNumberCleaner"] as? String {
            RateNumberCleaner = RateNumberCleanerContent
        }
 
        
        if let numberOfHours = (snapshot.value! as? NSDictionary)?["NumberOfHours"] as? String {
            NumberOfHours = numberOfHours
        }
        
        if let amountPaidToCleanerForBooking = (snapshot.value! as? NSDictionary)?["AmountPaidToCleanerForBooking"] as? String {
            AmountPaidToCleanerForBooking = amountPaidToCleanerForBooking
        }
        
        if let profitForBooking = (snapshot.value! as? NSDictionary)?["ProfitForBooking"] as? String {
            ProfitForBooking = profitForBooking
        }
        
        
        if let checkInDateContent = (snapshot.value! as? NSDictionary)?["checkInDate"] as? String {
            checkInDate = checkInDateContent
        }
        
        if let checkOutDateContent = (snapshot.value! as? NSDictionary)?["checkOutDate"] as? String {
            checkOutDate = checkOutDateContent
        }
        
        if let checkInTimeStampContent = (snapshot.value! as? NSDictionary)?["checkInTimeStamp"] as? String {
            checkInTimeStamp = checkInTimeStampContent
        }
        
        if let checkOutTimeStampContent = (snapshot.value! as? NSDictionary)?["checkOutTimeStamp"] as? String {
            checkOutTimeStamp = checkOutTimeStampContent
        }
        
        
        
   }//end of init(snapshot:FIRDataSnapshot)

    
//returns all objects as in Firebase
    func toAnyObject() -> [String : String] {
        
        var someDict = [String : String]()
        
        someDict["FirebaseUserID"] = String(self.FirebaseUserID)
        
        someDict["PaymentID"] = String(self.PaymentID)
        someDict["BookingAmount"] = String(self.BookingAmount)
        someDict["BookingNumber"] = String(self.BookingNumber)
        someDict["PostCode"] = String(self.PostCode)
        someDict["SelectedBathRow"] = String(self.SelectedBathRow)
        someDict["SelectedBedRow"] = String(self.SelectedBedRow)
        someDict["DateAndTime"] = String(self.DateAndTime)
        someDict["TimeStampDateAndTime"] = String(self.TimeStampDateAndTime)
        someDict["TimeStampBookingSavedInDB"] = String(self.TimeStampBookingSavedInDB)
        someDict["BookingStatusClient"] = String(self.BookingStatusClient)
        someDict["BookingStatusAdmin"] = String(self.BookingStatusAdmin)
        someDict["BookingCompleted"] = String(self.BookingCompleted)
        
        if CostToCancelClient != nil {
            someDict["CostToCancelClient"] = String(self.CostToCancelClient)
        }
        
        if CostToCancelAdmin != nil {
             someDict["CostToCancelAdmin"] = self.CostToCancelAdmin
        }
       
        
        if CostToRescheduleAdmin != nil{
            someDict["CostToRescheduleAdmin"] = String(self.CostToRescheduleAdmin)
        }
        
        if CostToRescheduleClient != nil {
            someDict["CostToRescheduleClient"] = String(self.CostToRescheduleClient)
        }
        
        
        if DoormanOption != nil {
            someDict["DoormanOption"] = String(self.DoormanOption)
        }
        
        if EntryInstructions != nil {
            someDict["EntryInstructions"] = String(self.EntryInstructions)
        }
        
        if NoteInstructions != nil {
            someDict["NoteInstructions"] = String(self.NoteInstructions)
        }
        
        
        
        
        someDict["FrequencyName"] = String(self.FrequencyName)
        someDict["FrequecyAmount"] = String(self.FrequecyAmount)
        someDict["insideCabinets"] = String(self.insideCabinets) //? "true" : "false"
        someDict["insideFridge"] = String(self.insideFridge) //? "true" : "false"
        someDict["insideOven"] = String(self.insideOven) //? "true" : "false"
        someDict["laundryWash"] = String(self.laundryWash) //? "true" : "false"
        someDict["interiorWindows"] = String(self.interiorWindows) //? "true" : false
        someDict["FullName"] = String(self.FullName)
        someDict["SuppliesName"] = String(self.SuppliesName)
        
        someDict["SuppliesAmount"] = String(self.SuppliesAmount)
        someDict["FlatNumber"] = String(self.FlatNumber)
        someDict["StreetAddress"] = String(self.StreetAddress)
        someDict["PhoneNumber"] = String(self.PhoneNumber)
        someDict["EmailAddress"] = String(self.EmailAddress)
        
        return someDict
        
    }
 
    
    

    
    //returns only some objects necessary to customer
    func toStringString() -> [String : String] {
        
        var someDict = [String : String]()

        someDict["BookingAmount"] = String(self.BookingAmount)
        someDict["BookingNumber"] = String(self.BookingNumber)
        someDict["PostCode"] = String(self.PostCode)
        someDict["SelectedBathRow"] = String(self.SelectedBathRow)
        someDict["SelectedBedRow"] = String(self.SelectedBedRow)
        someDict["DateAndTime"] = String(self.DateAndTime)

        someDict["FrequencyName"] = String(self.FrequencyName)
        someDict["FrequecyAmount"] = String(self.FrequecyAmount)
        someDict["insideCabinets"] = String(self.insideCabinets) //? "true" : "false"
        someDict["insideFridge"] = String(self.insideFridge) //? "true" : "false"
        someDict["insideOven"] = String(self.insideOven) //? "true" : "false"
        someDict["laundryWash"] = String(self.laundryWash) //? "true" : "false"
        someDict["interiorWindows"] = String(self.interiorWindows) //? "true" : false
        someDict["FullName"] = String(self.FullName)
        someDict["SuppliesName"] = String(self.SuppliesName)
        
        someDict["SuppliesAmount"] = String(self.SuppliesAmount)
        someDict["FlatNumber"] = String(self.FlatNumber)
        someDict["StreetAddress"] = String(self.StreetAddress)
        someDict["PhoneNumber"] = String(self.PhoneNumber)
        someDict["EmailAddress"] = String(self.EmailAddress)

        
        someDict["BookingStatusClient"] = String(self.BookingStatusClient)
        someDict["BookingStatusAdmin"] = String(self.BookingStatusAdmin)
        someDict["BookingCompleted"] = String(self.BookingCompleted)


        if DoormanOption != nil {
            someDict["DoormanOption"] = String(self.DoormanOption)
        }
        
        if EntryInstructions != nil {
            someDict["EntryInstructions"] = String(self.EntryInstructions)
        }
        
        if NoteInstructions != nil {
            someDict["NoteInstructions"] = String(self.NoteInstructions)
         }
        
               return someDict
      }
    
    
}//end of FirebaseData struct




