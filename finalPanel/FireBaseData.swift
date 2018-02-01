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







class RescheduledObject {
    
    var bookingStatusClient:String? = nil
    var claimed:String!
    var cleanerUID:String!
    var costToRescheduleClient:String!
    
    var feeAmountChargedToCleaner: String!
    var feeReasonChargedToCleaner:String!
    var amountDebtToCleaner:String!
    var reasonDebtToCleaner:String!
    
    
    var dateAndTime:String!
    var rescheduledByCustomer:String!
    var timeStampBookingRescheduledByCustomer:String!
    var timeStampDateAndTime:String!
    var key: String!
    var ref: FIRDatabaseReference? = nil
    
    init(snapshot:FIRDataSnapshot) {
        
        self.key = snapshot.key
        self.ref = snapshot.ref
        
        if let bookingStatusClientContent = (snapshot.value! as? NSDictionary)?["BookingStatusClient"] as? String {
            self.bookingStatusClient = bookingStatusClientContent
        }
        
        if let claimedContent = (snapshot.value! as? NSDictionary)?["Claimed"] as? String {
            self.claimed = claimedContent
        }
        
        
        if let CleanerUIDContent = (snapshot.value! as? NSDictionary)?["CleanerUID"] as? String {
            self.cleanerUID = CleanerUIDContent
        }
        
        
        if let CostToRescheduleClientContent = (snapshot.value! as? NSDictionary)?["CostToRescheduleClient"] as? String {
            self.costToRescheduleClient = CostToRescheduleClientContent
        }
        
        
        if let feeAmountChargedToCleanerContent = (snapshot.value! as? NSDictionary)?["FeeAmountChargedToCleaner"] as? String {
            self.feeAmountChargedToCleaner = feeAmountChargedToCleanerContent
        }
        
        if let feeReasonChargedToCleanerContent = (snapshot.value! as? NSDictionary)?["FeeReasonChargedToCleaner"] as? String {
            self.feeReasonChargedToCleaner = feeReasonChargedToCleanerContent
        }
        
        if let amountDebtToCleanerContent = (snapshot.value! as? NSDictionary)?["AmountDebtToCleaner"] as? String {
            self.amountDebtToCleaner = amountDebtToCleanerContent
        }
        
        
        if let reasonDebtToCleanerContent = (snapshot.value! as? NSDictionary)?["ReasonDebtToCleaner"] as? String {
            self.reasonDebtToCleaner = reasonDebtToCleanerContent
        }
        
        
        
        if let RescheduledByCustomerContent = (snapshot.value! as? NSDictionary)?["RescheduledByCustomer"] as? String {
            self.rescheduledByCustomer = RescheduledByCustomerContent
        }
        
        
        if let TimeStampBookingRescheduledByCustomerContent = (snapshot.value! as? NSDictionary)?["TimeStampBookingRescheduledByCustomer"] as? String {
            self.timeStampBookingRescheduledByCustomer = TimeStampBookingRescheduledByCustomerContent
        }
        
        
        if let timeStampDateAndTimeContent = (snapshot.value! as? NSDictionary)?["TimeStampDateAndTime"] as? String {
            self.timeStampDateAndTime = timeStampDateAndTimeContent
        }
        
    }//end of init
    
    
    func toAnyObject() -> AnyObject {
        var someDict = [String : AnyObject]()
        
        someDict["BookingStatusClient"] = self.bookingStatusClient as AnyObject?
        someDict["Claimed"] = self.claimed as AnyObject?
        someDict["CleanerUID"] = self.cleanerUID as AnyObject?
        someDict["CostToRescheduleClient"] = self.costToRescheduleClient as AnyObject?
        someDict["FeeAmountChargedToCleaner"] = self.feeAmountChargedToCleaner as AnyObject?
        someDict["FeeReasonChargedToCleaner"] = self.feeReasonChargedToCleaner as AnyObject?
        someDict["AmountDebtToCleaner"] = self.amountDebtToCleaner as AnyObject?
        someDict["ReasonDebtToCleaner"] = self.reasonDebtToCleaner as AnyObject?
        someDict["DateAndTime"] = self.dateAndTime as AnyObject?
        someDict["RescheduledByCustomer"] = self.rescheduledByCustomer as AnyObject?  //uid of customer

        someDict["TimeStampBookingRescheduledByCustomer"] = self.timeStampBookingRescheduledByCustomer as AnyObject?
        someDict["TimeStampDateAndTime"] = self.timeStampDateAndTime as AnyObject?
        
        return someDict as AnyObject
    }

    
}//end of struct RescheduledObject






//CancelledObject holds the data after a booking was cancelled
//  Cleaners/UID/bookings/bookingNumber/CancelledBy/TimeStamp
//a booking can be cancelled sucessively by multiple cleaners
//e.g cleaner1 claims & cancelles ,cleane2 does the same and so on, so with this object we keep track of each cancelled booking based on timestamp when booking was cancelled


class CancelledObject {
    
    
    var bookingNumber:String!
    var claimed: String!
    var cleanerUID: String!
    var costToCancelByCleaner: String!
    
    var feeAmountChargedToCleaner: String!
    var feeReasonChargedToCleaner:String!
    
    var amountDebtToCleaner:String!
    var reasonDebtToCleaner:String!
    
    var dateAndTime: String! //of booking when it was made
    var timeStampBookingCancelledByCleaner: String!
    var timeStampDateAndTime: String!
    var usersUID: String!
    var key: String!
    var ref: FIRDatabaseReference?
    
    init(snapshot: FIRDataSnapshot){
        
        if let bookingNumberContent = (snapshot.value! as? NSDictionary)?["BookingNumber"] as? String {
            self.bookingNumber = bookingNumberContent
        }
        
        if let claimedContent = (snapshot.value! as? NSDictionary)?["Claimed"] as? String {
            self.claimed = claimedContent
        }
        
        if let cleanerUIDContent = (snapshot.value! as? NSDictionary)?["CleanerUID"] as? String {
            self.cleanerUID = cleanerUIDContent
        }
        
        if let costToCancelByCleanerContent = (snapshot.value! as? NSDictionary)?["CostToCancelByCleaner"] as? String {
            self.costToCancelByCleaner = costToCancelByCleanerContent
        }
        
        if let feeAmountChargedToCleanerContent = (snapshot.value! as? NSDictionary)?["FeeAmountChargedToCleaner"] as? String {
            self.feeAmountChargedToCleaner = feeAmountChargedToCleanerContent
        }
        
        if let feeReasonChargedToCleanerContent = (snapshot.value! as? NSDictionary)?["FeeReasonChargedToCleaner"] as? String {
            self.feeReasonChargedToCleaner = feeReasonChargedToCleanerContent
        }
        
        if let amountDebtToCleanerContent = (snapshot.value! as? NSDictionary)?["AmountDebtToCleaner"] as? String {
            self.amountDebtToCleaner = amountDebtToCleanerContent
        }
        
        
        if let reasonDebtToCleanerContent = (snapshot.value! as? NSDictionary)?["ReasonDebtToCleaner"] as? String {
            self.reasonDebtToCleaner = reasonDebtToCleanerContent
        }
        
        
        
        if let dateAndTimeContent = (snapshot.value! as? NSDictionary)?["DateAndTime"] as? String {
            self.dateAndTime = dateAndTimeContent
        }
        
        if let timeStampBookingCancelledByCleanerContent = (snapshot.value! as? NSDictionary)?["timeStampBookingCancelledByCleaner"] as? String {
            self.timeStampBookingCancelledByCleaner = timeStampBookingCancelledByCleanerContent
        }
        
        if let timeStampDateAndTimeContent = (snapshot.value! as? NSDictionary)?["TimeStampDateAndTime"] as? String {
            self.timeStampDateAndTime = timeStampDateAndTimeContent
        }
        
        if let usersUIDContent = (snapshot.value! as? NSDictionary)?["usersUID"] as? String {
            self.usersUID = usersUIDContent
        }
        
        self.key = snapshot.key
        self.ref = nil
        
    }
    
    
    func toAnyObject() -> AnyObject {
        
        var someDict = [String : AnyObject]()
        
            someDict["BookingNumber"] = self.bookingNumber as AnyObject?
            someDict["Claimed"] = self.claimed as AnyObject?
            someDict["CleanerUID"] = self.cleanerUID as AnyObject?
            someDict["CostToCancelByCleaner"] = self.costToCancelByCleaner as AnyObject?
            someDict["FeeAmountChargedToCleaner"] = self.feeAmountChargedToCleaner as AnyObject?
            someDict["FeeReasonChargedToCleaner"] = self.feeReasonChargedToCleaner as AnyObject?
            someDict["AmountDebtToCleaner"] = self.amountDebtToCleaner as AnyObject?
            someDict["ReasonDebtToCleaner"] = self.reasonDebtToCleaner as AnyObject?
            someDict["DateAndTime"] = self.dateAndTime as AnyObject?
            someDict["timeStampBookingCancelledByCleaner"] = self.timeStampBookingCancelledByCleaner as AnyObject?
            someDict["TimeStampDateAndTime"] = self.timeStampDateAndTime as AnyObject?
            someDict["usersUID"] = self.usersUID as AnyObject?
        
                 return someDict as AnyObject
    }
 
    
}//end of class CancelledObject










struct DisbursePaymentData {
    
    var payPeriodDateStartDate:String?
    var payPeriodEndDate:String?
    var payPeriodTimeStampStartDate:String?
    var payPeriodTimeStampEndDate:String?
    
    var totalAmountPaidToCleanerForAllBookings:String?
    var totalAmountProfitToCleanerForAllBookings:String?
    var totalAdminProfitForBookings:String?
    var totalAmountFeesChargedToCleaner:String?
    var totalAmountDebtToCleaner:String?
    
    
    var paymentRef:String?
    
    var cancelledBy: [String: AnyObject]?
    var rescheduledBy: [String: AnyObject]?
    
    var numberOfHours:String?
    var bookingAmount:String?
    var amountPaidToCleanerForBooking:String?
    var profitForBooking:String?
    var checkInDate:String?
    var checkOutDate:String?
    
    var checkInTimeStamp:String?
    var checkOutTimeStamp:String?
    
    var ratePriceClient:String?
    var rateNumberClient:String?
    var ratePriceCleaner:String?
    var rateNumberCleaner:String?
    var bookings:[String: AnyObject]?
    
    
    init(
        payPeriodDateStartDate:String? = nil,
        payPeriodEndDate:String? = nil,
        payPeriodTimeStampStartDate:String? = nil,
        payPeriodTimeStampEndDate:String? = nil,
        paymentRef:String? = nil,
        totalAmountPaidToCleanerForAllBookings:String? = nil,
        totalAmountProfitToCleanerForAllBookings:String? = nil,
        totalAdminProfitForBookings:String? = nil,
        totalAmountFeesChargedToCleaner:String? = nil,
        totalAmountDebtToCleaner:String? = nil,
        bookings:[String: AnyObject]? = nil
        
        ) {
        
        self.payPeriodDateStartDate = payPeriodDateStartDate
        self.payPeriodEndDate = payPeriodEndDate
        self.payPeriodTimeStampStartDate = payPeriodTimeStampStartDate
        self.payPeriodTimeStampEndDate = payPeriodTimeStampEndDate
        self.paymentRef = paymentRef
        
        self.totalAmountPaidToCleanerForAllBookings = totalAmountPaidToCleanerForAllBookings
        self.totalAmountProfitToCleanerForAllBookings = totalAmountProfitToCleanerForAllBookings
        self.totalAdminProfitForBookings = totalAdminProfitForBookings
        self.totalAmountFeesChargedToCleaner = totalAmountFeesChargedToCleaner
        self.totalAmountDebtToCleaner = totalAmountDebtToCleaner
        
        self.bookings = bookings
    }//end of first init
    
    

    
    init(
        
        numberOfHours:String? = nil,
        bookingAmount:String? = nil,
        amountPaidToCleanerForBooking:String? = nil,
        profitForBooking:String? = nil,

        checkInDate:String? = nil,
        checkOutDate:String? = nil,
        checkInTimeStamp:String? = nil,
        checkOutTimeStamp:String? = nil,
        ratePriceClient:String? = nil,
        rateNumberClient:String? = nil,
        ratePriceCleaner:String? = nil,
        rateNumberCleaner:String? = nil,
        cancelledBy:[String:AnyObject]? = nil,
        rescheduledBy:[String:AnyObject]? = nil
        
        ) {
        
        self.numberOfHours = numberOfHours
        self.bookingAmount = bookingAmount
        self.amountPaidToCleanerForBooking = amountPaidToCleanerForBooking
        self.profitForBooking = profitForBooking
        self.checkInDate = checkInDate
        self.checkOutDate = checkOutDate
        self.checkInTimeStamp = checkInTimeStamp
        self.checkOutTimeStamp = checkOutTimeStamp
        self.ratePriceClient = ratePriceClient
        self.rateNumberClient = rateNumberClient
        self.ratePriceCleaner = ratePriceCleaner
        self.rateNumberCleaner = rateNumberCleaner
        self.cancelledBy =  cancelledBy
        self.rescheduledBy = rescheduledBy

    }
    
    
    func convertDisbursePaymentDataToAnyObject() -> AnyObject {
        var someDict = [String : AnyObject]()
        
        someDict["NumberOfHours"] = self.numberOfHours as AnyObject?
        someDict["AmountPaidToCleanerForBooking"] = self.amountPaidToCleanerForBooking as AnyObject?
        someDict["ProfitForBooking"] = self.profitForBooking as AnyObject?
        someDict["CheckInDate"] = self.checkInDate as AnyObject?
        someDict["CheckOutDate"] = self.checkOutDate as AnyObject?
        someDict["CheckInTimeStamp"] = self.checkInTimeStamp as AnyObject?
        someDict["CheckOutTimeStamp"] = self.checkOutTimeStamp as AnyObject?
        someDict["RatePriceClient"] = self.ratePriceClient as AnyObject?
        someDict["RateNumberClient"] = self.rateNumberClient as AnyObject?
        someDict["RatePriceCleaner"] = self.ratePriceCleaner as AnyObject?
        someDict["RateNumberCleaner"] = self.rateNumberCleaner as AnyObject?
        someDict["CancelledBy"] = self.cancelledBy as AnyObject?
        someDict["RescheduledBy"] = self.rescheduledBy as AnyObject?
        
        return someDict as AnyObject
    }


    func toAnyObj() -> AnyObject {
         var someDict = [String : AnyObject]()

        someDict["PayPeriodDateStartDate"] = self.payPeriodDateStartDate as AnyObject?
        someDict["PayPeriodEndDate"] = self.payPeriodEndDate as AnyObject?
        someDict["PayPeriodTimeStampStartDate"] = self.payPeriodTimeStampStartDate as AnyObject?
        someDict["PayPeriodTimeStampEndDate"] = self.payPeriodTimeStampEndDate as AnyObject?
        someDict["PaymentRef"] = self.paymentRef as AnyObject?
        
        someDict["TotalAmountPaidToCleanerForAllBookings"] = self.totalAmountPaidToCleanerForAllBookings as AnyObject?
        someDict["TotalAmountProfitToCleanerForAllBookings"] = self.totalAmountProfitToCleanerForAllBookings as AnyObject?
        someDict["TotalAdminProfitForBookings"] = self.totalAdminProfitForBookings as AnyObject?
        someDict["TotalAmountFeesChargedToCleaner"] = self.totalAmountFeesChargedToCleaner as AnyObject?
        someDict["TotalAmountDebtToCleaner"] = self.totalAmountDebtToCleaner as AnyObject?
        
        someDict["Bookings"] = self.bookings as AnyObject?
        return  someDict as AnyObject
    }
    
}//end of struct DataDisbursePayment






