//
//  DataModelDisbursePayment.swift
//  finalPanel
//
//  Created by Bogdan Barbulescu on 12/02/2018.
//  Copyright © 2018 Appfish. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase




class RescheduledObject {
    
    var changesMadeBy:String!
    var bookingNumber:String!
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
        
        if let changesMadeByContent = (snapshot.value! as? NSDictionary)?["ChangesMadeBy"] as? String {
            self.changesMadeBy = changesMadeByContent
        }
        
        if let bookingNumberClientContent = (snapshot.value! as? NSDictionary)?["BookingNumber"] as? String {
            self.bookingNumber = bookingNumberClientContent
        }
        
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
        
        someDict["ChangesMadeBy"] = self.changesMadeBy as AnyObject?
        someDict["BookingNumber"] = self.bookingNumber as AnyObject?
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
    
    var changesMadeBy:String!
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
        
     
        if let changesMadeByContent = (snapshot.value! as? NSDictionary)?["ChangesMadeBy"] as? String {
            self.changesMadeBy = changesMadeByContent
        }
        
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
        
        someDict["ChangesMadeBy"] = self.changesMadeBy as AnyObject?
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








//NoShowObject holds the data after a booking was cancelled
//  Cleaners/UID/bookings/bookingNumber/NoShowBy/TimeStamp
// a booking can be reported as noShow only once
class NoShowObject {
    
    var changesMadeBy:String!
    var bookingState:String!
    var bookingStateTimeStamp:String!
    var bookingAmount:String!
    var commentNoShow:String!
    var amountDebtToCleaner:String!
    var reasonDebtToCleaner:String!
    var feeAmountChargedToCleaner:String!
    var feeReasonChargedToCleaner:String!
    var costNoShowReported:String!
    var usersUID:String!
    var cleanerUID:String!
    var bookingNumber:String!
    var timeStampBookingNoShow:String!
    var claimed:String!
    var timeStampBookingClaimed:String!
    var dateAndTime:String!
    var timeStampDateAndTime:String!
    var noShowReportedBy:String!
    var key: String!
    var ref: FIRDatabaseReference?
    
    init(snapshot:FIRDataSnapshot) {
        
        if let changesMadeByContent = (snapshot.value! as? NSDictionary)?["ChangesMadeBy"] as? String {
            self.changesMadeBy = changesMadeByContent
        }
        
        if let bookingStateContent = (snapshot.value! as? NSDictionary)?["BookingState"] as? String {
            self.bookingState = bookingStateContent
        }
        
        if let bookingStateTimeStampContent = (snapshot.value! as? NSDictionary)?["BookingStateTimeStamp"] as? String {
            self.bookingStateTimeStamp = bookingStateTimeStampContent
        }
        
        if let bookingAmountContent = (snapshot.value! as? NSDictionary)?["BookingAmount"] as? String {
            self.changesMadeBy = bookingAmountContent
        }
        
        if let commentNoShowContent = (snapshot.value! as? NSDictionary)?["CommentNoShow"] as? String {
            self.commentNoShow = commentNoShowContent
        }
        
        if let amountDebtToCleanerContent = (snapshot.value! as? NSDictionary)?["AmountDebtToCleaner"] as? String {
            self.amountDebtToCleaner = amountDebtToCleanerContent
        }
        
        if let reasonDebtToCleanerContent = (snapshot.value! as? NSDictionary)?["ReasonDebtToCleaner"] as? String {
            self.reasonDebtToCleaner = reasonDebtToCleanerContent
        }
        
        
        if let feeAmountChargedToCleanerContent = (snapshot.value! as? NSDictionary)?["FeeAmountChargedToCleaner"] as? String {
            self.feeAmountChargedToCleaner = feeAmountChargedToCleanerContent
        }
        
        
        if let feeReasonChargedToCleanerContent = (snapshot.value! as? NSDictionary)?["FeeReasonChargedToCleaner"] as? String {
            self.feeReasonChargedToCleaner = feeReasonChargedToCleanerContent
        }
        
        
        if let costNoShowReportedContent = (snapshot.value! as? NSDictionary)?["CostNoShowReported"] as? String {
            self.costNoShowReported = costNoShowReportedContent
        }
        
        
        if let usersUIDContent = (snapshot.value! as? NSDictionary)?["usersUID"] as? String {
            self.usersUID = usersUIDContent
        }
        
        
        if let cleanerUIDContent = (snapshot.value! as? NSDictionary)?["CleanerUID"] as? String {
            self.cleanerUID = cleanerUIDContent
        }
        
        
        if let bookingNumberContent = (snapshot.value! as? NSDictionary)?["bookingNumber"] as? String {
            self.bookingNumber = bookingNumberContent
        }
        
        
        if let timeStampBookingNoShowContent = (snapshot.value! as? NSDictionary)?["TimeStampBookingNoShow"] as? String {
            self.timeStampBookingNoShow = timeStampBookingNoShowContent
        }
        
        
        if let claimedContent = (snapshot.value! as? NSDictionary)?["Claimed"] as? String {
            self.claimed = claimedContent
        }
        
        
        if let timeStampBookingClaimedContent = (snapshot.value! as? NSDictionary)?["TimeStampBookingClaimed"] as? String {
            self.timeStampBookingClaimed = timeStampBookingClaimedContent
        }
        
        
        if let dateAndTimeContent = (snapshot.value! as? NSDictionary)?["DateAndTime"] as? String {
            self.dateAndTime = dateAndTimeContent
        }
        
        
        if let timeStampDateAndTimeContent = (snapshot.value! as? NSDictionary)?["TimeStampDateAndTime"] as? String {
            self.timeStampDateAndTime = timeStampDateAndTimeContent
        }
        
        
        if let noShowReportedByContent = (snapshot.value! as? NSDictionary)?["NoShowReportedBy"] as? String {
            self.noShowReportedBy = noShowReportedByContent
        }
        
        self.key = snapshot.key
        self.ref = nil
        
    }//end of init
    
    
    //create convertToAnyObj func
    
    func toAnyObject() -> AnyObject {
       var someDict = [String : AnyObject]()
        
        someDict["ChangesMadeBy"] = self.changesMadeBy as AnyObject?
        someDict["BookingState"] = self.bookingState as AnyObject?
        someDict["BookingStateTimeStamp"] = self.bookingStateTimeStamp as AnyObject?
        someDict["BookingAmount"] = self.bookingAmount as AnyObject?
        someDict["CommentNoShow"] = self.commentNoShow as AnyObject?
        someDict["AmountDebtToCleaner"] = self.amountDebtToCleaner as AnyObject?
        someDict["ReasonDebtToCleaner"] = self.reasonDebtToCleaner as AnyObject?
        someDict["FeeAmountChargedToCleaner"] = self.feeAmountChargedToCleaner as AnyObject?
        someDict["FeeReasonChargedToCleaner"] = self.feeReasonChargedToCleaner as AnyObject?
        someDict["CostNoShowReported"] = self.costNoShowReported as AnyObject?
        someDict["UsersUID"] = self.usersUID as AnyObject?
        someDict["CleanerUID"] = self.cleanerUID as AnyObject?
        
        someDict["BookingNumber"] = self.bookingNumber as AnyObject?

        someDict["TimeStampBookingNoShow"] = self.timeStampBookingNoShow as AnyObject?
        someDict["Claimed"] = self.claimed as AnyObject?
        someDict["TimeStampBookingClaimed"] = self.timeStampBookingClaimed as AnyObject?
        someDict["DateAndTime"] = self.dateAndTime as AnyObject?
        someDict["TimeStampDateAndTime"] = self.timeStampDateAndTime as AnyObject?
        someDict["NoShowReportedBy"] = self.noShowReportedBy as AnyObject?
        
        return someDict as AnyObject
    }
    
}//end of class NoShowObject







struct DisbursePaymentData {
    
    var payPeriodDateStartDate:String?
    var payPeriodEndDate:String?
    var payPeriodTimeStampStartDate:String?
    var payPeriodTimeStampEndDate:String?
    
    var totalAmountPaidToCleanerForAllBookings:String?
    var totalAmountProfitToCleanerForAllBookings:String?
    var totalAdminProfitForBookings:String?
    var totalAmountFeesCurrentPayPeriod:String?
    var totalAmountDebtToCleaner:String?
    
    
    var paymentRef:String?
    var timeStampDisbursedPayment:String?
    
    var cancelledBy: [String: AnyObject]?
    var rescheduledBy: [String: AnyObject]?
    var noShowBy:[String:AnyObject]?
    
    var numberOfHours:String?
    var bookingAmount:String?
    var suppliesAmount:String?
    var flatNumber:String?
    var postCode:String?
    var streetAddress:String?
    var dateAndTime:String?
    var timeStampDateAndTime:String?
    var timeStampBookingClaimed:String?
    
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
    
    var balanceCarriedForwardAmount:String!
    var previousBalanceCarriedForward:String!
 
    var backgroundCheckFeeStatus:String!
    var backgroundCheckFeeAmount:String!
    var backgroundCheckTimeStampProfileCreated:String!
    
    var bookings:[String: AnyObject]?
    
    
    init(
        payPeriodDateStartDate:String? = nil,
        payPeriodEndDate:String? = nil,
        payPeriodTimeStampStartDate:String? = nil,
        payPeriodTimeStampEndDate:String? = nil,
        paymentRef:String? = nil,
        timeStampDisbursedPayment:String? = nil,
        totalAmountPaidToCleanerForAllBookings:String? = nil,
        totalAmountProfitToCleanerForAllBookings:String? = nil,
        totalAdminProfitForBookings:String? = nil,
        totalAmountFeesCurrentPayPeriod:String? = nil,
        totalAmountDebtToCleaner:String? = nil,
        balanceCarriedForwardAmount:String,
        previousBalanceCarriedForward:String,
        backgroundCheckFeeStatus:String,
        backgroundCheckFeeAmount:String,
        backgroundCheckTimeStampProfileCreated:String,
       
        
        bookings:[String: AnyObject]? = nil) {
        
        self.payPeriodDateStartDate = payPeriodDateStartDate
        self.payPeriodEndDate = payPeriodEndDate
        self.payPeriodTimeStampStartDate = payPeriodTimeStampStartDate
        self.payPeriodTimeStampEndDate = payPeriodTimeStampEndDate
        self.paymentRef = paymentRef
        self.timeStampDisbursedPayment = timeStampDisbursedPayment
        
        self.totalAmountPaidToCleanerForAllBookings = totalAmountPaidToCleanerForAllBookings
        self.totalAmountProfitToCleanerForAllBookings = totalAmountProfitToCleanerForAllBookings
        self.totalAdminProfitForBookings = totalAdminProfitForBookings
        self.totalAmountFeesCurrentPayPeriod = totalAmountFeesCurrentPayPeriod
        self.totalAmountDebtToCleaner = totalAmountDebtToCleaner
        self.balanceCarriedForwardAmount = balanceCarriedForwardAmount
        self.previousBalanceCarriedForward = previousBalanceCarriedForward
        self.backgroundCheckFeeStatus = backgroundCheckFeeStatus
        self.backgroundCheckFeeAmount = backgroundCheckFeeAmount
        self.backgroundCheckTimeStampProfileCreated = backgroundCheckTimeStampProfileCreated
      
        
        self.bookings = bookings
        
    }//end of first init
    
    
    
    
    init(
        
        numberOfHours:String? = nil,
        bookingAmount:String? = nil,
        suppliesAmount:String? = nil,
        flatNumber:String? = nil,
        postCode:String? = nil,
        streetAddress:String? = nil,
        dateAndTime:String? = nil,
        timeStampDateAndTime:String? = nil,
        timeStampBookingClaimed:String? = nil,
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
        rescheduledBy:[String:AnyObject]? = nil,
        noShowBy:[String:AnyObject]? = nil
        
        ) {
        
        self.numberOfHours = numberOfHours
        self.bookingAmount = bookingAmount
        self.suppliesAmount = suppliesAmount
        
        self.flatNumber = flatNumber
        self.postCode = postCode
        self.streetAddress = streetAddress
        self.dateAndTime = dateAndTime
        self.timeStampDateAndTime = timeStampDateAndTime
        self.timeStampBookingClaimed = timeStampBookingClaimed
        
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
        self.noShowBy = noShowBy
        
    }
    
    
    func convertDisbursePaymentDataToAnyObject() -> AnyObject {
        var someDict = [String : AnyObject]()
        
        someDict["NumberOfHours"] = self.numberOfHours as AnyObject?
        someDict["BookingAmount"] = self.bookingAmount as AnyObject?
        someDict["suppliesAmount"] = self.suppliesAmount as AnyObject?
        
        someDict["FlatNumber"] = self.flatNumber as AnyObject?
        someDict["PostCode"] = self.postCode as AnyObject?
        someDict["StreetAddress"] = self.streetAddress as AnyObject?
        someDict["DateAndTime"] = self.dateAndTime as AnyObject?
        someDict["TimeStampDateAndTime"] = self.timeStampDateAndTime as AnyObject?
        someDict["TimeStampBookingClaimed"] = self.timeStampBookingClaimed as AnyObject?
        
        
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
        someDict["NoShowBy"] = self.noShowBy as AnyObject?
        
        return someDict as AnyObject
    }
    
    
    func toAnyObj() -> AnyObject {
        var someDict = [String : AnyObject]()
        
        someDict["PayPeriodDateStartDate"] = self.payPeriodDateStartDate as AnyObject?
        someDict["PayPeriodEndDate"] = self.payPeriodEndDate as AnyObject?
        someDict["PayPeriodTimeStampStartDate"] = self.payPeriodTimeStampStartDate as AnyObject?
        someDict["PayPeriodTimeStampEndDate"] = self.payPeriodTimeStampEndDate as AnyObject?
        someDict["PaymentRef"] = self.paymentRef as AnyObject?
        someDict["TimeStampDisbursedPayment"] = self.timeStampDisbursedPayment as AnyObject?
        
        someDict["TotalAmountPaidToCleanerForAllBookings"] = self.totalAmountPaidToCleanerForAllBookings as AnyObject?
        someDict["TotalAmountProfitToCleanerForAllBookings"] = self.totalAmountProfitToCleanerForAllBookings as AnyObject?
        someDict["TotalAdminProfitForBookings"] = self.totalAdminProfitForBookings as AnyObject?
        someDict["TotalAmountFeesCurrentPayPeriod"] = self.totalAmountFeesCurrentPayPeriod as AnyObject?
        someDict["TotalAmountDebtToCleaner"] = self.totalAmountDebtToCleaner as AnyObject?
        someDict["BalanceCarriedForwardAmount"] = self.balanceCarriedForwardAmount as AnyObject?
        someDict["PreviousBalanceCarriedForward"] = self.previousBalanceCarriedForward as AnyObject?
        someDict["BackgroundCheckFeeStatus"] = self.backgroundCheckFeeStatus as AnyObject?
        someDict["BackgroundCheckFeeAmount"] = self.backgroundCheckFeeAmount as AnyObject?
        someDict["BackgroundCheckTimeStampProfileCreated"] = self.backgroundCheckTimeStampProfileCreated as AnyObject?
        
        someDict["Bookings"] = self.bookings as AnyObject?
        return  someDict as AnyObject
    }
    
}//end of struct DataDisbursePayment







/*
 /FeesCleaner
 -UID
  -OutstandingFees:
      TimeStampFeesCarriedForward:
      BalanceCarriedForwardAmount:
 
   -TimeStampFeesSaved
       payPeriodTimeStampStartDate
       totalAmountPaidToCleanerForAllBookings
       totalAmountProfitToCleanerForAllBookings
       totalAmountFeesCurrentPayPeriod
       totalAmountDebtToCleaner
       paymentRef
       timeStampDisbursedPayment
 
  -BackgroundCheck
      TimeStampProfileCreated:
      FeeAmount:
      FeeStatus: true/false
 */

//retrieve Fees charged to Cleaner
struct FeesCleaner {
    
    var outstandingFees: AnyObject?
    var timeStampFeesSaved: [AnyObject]?
    var backgroundCheck: AnyObject!
    
    init(
        outstandingFees: AnyObject? = nil,
        timeStampFeesSaved: [AnyObject]? = nil,
        backgroundCheck: AnyObject) {
        
        self.outstandingFees = outstandingFees
        self.timeStampFeesSaved = timeStampFeesSaved
        self.backgroundCheck = backgroundCheck
        
    }//end of init
    
    init(snapshot: FIRDataSnapshot){
        

            
            //every value under FeesCleaner/UID
            for item in snapshot.children {
               
            if let elementUnderFeesCleaner = item as? FIRDataSnapshot {
                
                if elementUnderFeesCleaner.key == "OutstandingFees" {
                    
                   
                    self.outstandingFees = OutstandingFees(snapshot: elementUnderFeesCleaner).convertOutstandingFeesToAnyObject()
                     print("line 699 print \(self.outstandingFees)")
                    
                }//end of  if elementUnderFeesCleaner.key
                    
                }
         }
        
        
        
        
      //  initialize timeStamFeesSaved
        if  !((snapshot.value) is NSNull) {
          
            
            var objectsUnderTimeStampFeesSaved = [AnyObject]()
            
            //every value under FeesCleaner/UID
            for item in snapshot.children {
                
                let objectUnderTimeStampFeesSaved = item as! FIRDataSnapshot
                if objectUnderTimeStampFeesSaved.key == "TimeStampFeesSaved" {
                    
                    for payment in objectUnderTimeStampFeesSaved.children {
                        let feeObj = TimeStampFeesSaved(snapshot: payment as! FIRDataSnapshot)
                       
                        //assign each key:val to objectsUnderTimeStampFeesSaved WHERE
                        //key = time stam when object was saved and
                        //val = an instance of TimeStampFeesSaved
                        let feeObjConverted = feeObj.convertTimeStampFeesSavedToAnyObject()
                        objectsUnderTimeStampFeesSaved.append(feeObjConverted)
                    }
                }
            }
            
            self.timeStampFeesSaved = objectsUnderTimeStampFeesSaved
        }
        
        
     if !((snapshot.value) is NSNull) {
        
            for item in snapshot.children {
                
                if let elementUnderFeesCleaner = item as? FIRDataSnapshot {
                    
                    print("line 766")
                    
                    print("elementUnderFeesCleaner.key is \(elementUnderFeesCleaner.key)")
                    
                if elementUnderFeesCleaner.key == "BackgroundCheck" {
                    
                    self.backgroundCheck = BackgroundCheck(snapshot: elementUnderFeesCleaner).convertBackgroundCheckToAnyObject()
                    
                    print("self.backgroundCheck line 768 \(self.backgroundCheck)")
                    
                }//end of  if elementUnderFeesCleaner.key
                
            }
          }
  
    }
    
    }//end of init

    
    
    //convenience method used to convert this struct in AnyObject type in order to write the values to Firebase
    func convertToAnyObject() -> AnyObject {
        var someDict = [String : AnyObject]()
        
        someDict["OutstandingFees"] = self.outstandingFees as AnyObject?
        someDict["TimeStampFeesSaved"] = self.timeStampFeesSaved as AnyObject?
        someDict["BackgroundCheck"] = self.backgroundCheck as AnyObject?
        
        
        return someDict as AnyObject
    }
    
  }//end of FeesCleaner















//ledger with all fees charged to cleaner and other meta data 
struct TimeStampFeesSaved {
    
    var payPeriodTimeStampStartDate:String?
    var totalAmountPaidToCleanerForAllBookings:String?
    var totalAmountProfitToCleanerForAllBookings:String?
    var totalAmountFeesCurrentPayPeriod:String?
    var totalAmountDebtToCleaner:String?
    var paymentRef:String?
    var timeStampDisbursedPayment:String?
    var balanceCarriedForwardAmount:String?
    var previousBalanceCarriedForward:String?
    var backgroundCheckFeeStatus:String?
    
    init(
        payPeriodTimeStampStartDate:String? = nil,
        totalAmountPaidToCleanerForAllBookings:String? = nil,
        totalAmountProfitToCleanerForAllBookings:String? = nil,
        totalAmountFeesCurrentPayPeriod:String? = nil,
        totalAmountDebtToCleaner:String? = nil,
        paymentRef:String? = nil,
        timeStampDisbursedPayment:String? = nil,
        balanceCarriedForwardAmount:String? = nil,
        previousBalanceCarriedForward:String? = nil,
        backgroundCheckFeeStatus:String? = nil) {
        
        self.payPeriodTimeStampStartDate = payPeriodTimeStampStartDate
        self.totalAmountPaidToCleanerForAllBookings = totalAmountPaidToCleanerForAllBookings
        self.totalAmountProfitToCleanerForAllBookings = totalAmountProfitToCleanerForAllBookings
        self.totalAmountFeesCurrentPayPeriod = totalAmountFeesCurrentPayPeriod
        self.totalAmountDebtToCleaner = totalAmountDebtToCleaner
        self.paymentRef = paymentRef
        self.timeStampDisbursedPayment = timeStampDisbursedPayment
        self.balanceCarriedForwardAmount = balanceCarriedForwardAmount
        self.previousBalanceCarriedForward = previousBalanceCarriedForward
        self.backgroundCheckFeeStatus = backgroundCheckFeeStatus //this property is only initialized so we can write in the database
        
    }//end of init
    
    
    
    init(snapshot: FIRDataSnapshot) {
        
        if let payPeriodTimeStampStartDateContent = (snapshot.value! as? NSDictionary)?["PayPeriodTimeStampStartDate"] as? String {
            self.payPeriodTimeStampStartDate = payPeriodTimeStampStartDateContent
        }
        
        if let totalAmountPaidToCleanerForAllBookingsContent = (snapshot.value! as? NSDictionary)?["TotalAmountPaidToCleanerForAllBookings"] as? String {
            self.totalAmountPaidToCleanerForAllBookings = totalAmountPaidToCleanerForAllBookingsContent
        }
        
        if let totalAmountProfitToCleanerForAllBookingsContent = (snapshot.value! as? NSDictionary)?["TotalAmountProfitToCleanerForAllBookings"] as? String {
            self.totalAmountProfitToCleanerForAllBookings = totalAmountProfitToCleanerForAllBookingsContent
        }
        
        if let totalAmountFeesCurrentPayPeriodContent = (snapshot.value! as? NSDictionary)?["TotalAmountFeesCurrentPayPeriod"] as? String {
            self.totalAmountFeesCurrentPayPeriod = totalAmountFeesCurrentPayPeriodContent
        }
        
        if let totalAmountDebtToCleanerContent = (snapshot.value! as? NSDictionary)?["TotalAmountDebtToCleaner"] as? String {
            self.totalAmountDebtToCleaner = totalAmountDebtToCleanerContent
        }
        
        if let paymentRefContent = (snapshot.value! as? NSDictionary)?["PaymentRef"] as? String {
            self.paymentRef = paymentRefContent
        }
        
        if let timeStampDisbursedPaymentContent = (snapshot.value! as? NSDictionary)?["TimeStampDisbursedPayment"] as? String {
            self.timeStampDisbursedPayment = timeStampDisbursedPaymentContent
        }
        
        if let balanceCarriedForwardAmountContent = (snapshot.value! as? NSDictionary)?["BalanceCarriedForwardAmount"] as? String {
            self.balanceCarriedForwardAmount = balanceCarriedForwardAmountContent
        }
        
        if let previousBalanceCarriedForwardContent = (snapshot.value! as? NSDictionary)?["PreviousBalanceCarriedForward"] as? String {
            self.previousBalanceCarriedForward = previousBalanceCarriedForwardContent
        }
        
        if let backgroundCheckFeeStatusContent = (snapshot.value! as? NSDictionary)?["BackgroundCheckFeeStatus"] as? String {
            self.backgroundCheckFeeStatus = backgroundCheckFeeStatusContent
        }
        
        
        
    }//end of init
    
    
    //convenience method used to convert this struct in AnyObject type in order to write the values to Firebase
    func convertTimeStampFeesSavedToAnyObject() -> AnyObject {
        var someDict = [String : AnyObject]()
        
        someDict["PayPeriodTimeStampStartDate"] = self.payPeriodTimeStampStartDate as AnyObject?
        someDict["TotalAmountPaidToCleanerForAllBookings"] = self.totalAmountPaidToCleanerForAllBookings as AnyObject?
        someDict["TotalAmountProfitToCleanerForAllBookings"] = self.totalAmountProfitToCleanerForAllBookings as AnyObject?
        someDict["TotalAmountFeesCurrentPayPeriod"] = self.totalAmountFeesCurrentPayPeriod as AnyObject?
        someDict["TotalAmountDebtToCleaner"] = self.totalAmountDebtToCleaner as AnyObject?
        someDict["PaymentRef"] = self.paymentRef as AnyObject?
        someDict["TimeStampDisbursedPayment"] = self.timeStampDisbursedPayment as AnyObject?
        someDict["BalanceCarriedForwardAmount"] = self.balanceCarriedForwardAmount as AnyObject?
        someDict["PreviousBalanceCarriedForward"] = self.previousBalanceCarriedForward as AnyObject?
        
        return someDict as AnyObject
    }
    
}//end of struct TimeStampFeesSaved




struct OutstandingFees {
    
    var timeStampFeesCarriedForward:String?
    var balanceCarriedForwardAmount:String?
    var previousBalanceCarriedForward:String?
    
    init(timeStampFeesCarriedForward:String? = nil,
         balanceCarriedForwardAmount:String? = nil,
         previousBalanceCarriedForward:String? = nil) {
        
        self.timeStampFeesCarriedForward = timeStampFeesCarriedForward
        self.balanceCarriedForwardAmount = balanceCarriedForwardAmount
        self.previousBalanceCarriedForward = previousBalanceCarriedForward
    }
    
    
    
    init(snapshot: FIRDataSnapshot) {
        
        if let timeStampFeesCarriedForwardContent = (snapshot.value! as? NSDictionary)?["TimeStampFeesCarriedForward"] as? String {
            self.timeStampFeesCarriedForward = timeStampFeesCarriedForwardContent
        }
        
        if let balanceCarriedForwardAmountContent = (snapshot.value! as? NSDictionary)?["BalanceCarriedForwardAmount"] as? String {
            self.balanceCarriedForwardAmount = balanceCarriedForwardAmountContent
        }
        
        if let previousBalanceCarriedForwardContent = (snapshot.value! as? NSDictionary)?["PreviousBalanceCarriedForward"] as? String {
            self.previousBalanceCarriedForward = previousBalanceCarriedForwardContent
        }
        
    }//end of init
    
    
    //convenience method used to convert this struct in AnyObject type in order to write the values to Firebase
    func convertOutstandingFeesToAnyObject() -> AnyObject {
        
        var someDict = [String : AnyObject]()
        someDict["TimeStampFeesCarriedForward"] = self.timeStampFeesCarriedForward as AnyObject?
        someDict["BalanceCarriedForwardAmount"] = self.balanceCarriedForwardAmount as AnyObject?
        someDict["PreviousBalanceCarriedForward"] = self.previousBalanceCarriedForward as AnyObject?
        
        return someDict as AnyObject
    }
    
}//end of struct OutstandingFees






//will hold the data related to background check fees when Cleaner is first registered on the platform
struct BackgroundCheck {
    
    var TimeStampProfileCreated:String!
    var FeeAmount:String!
    var FeeStatus: String!
    
    init(TimeStampProfileCreated:String! = nil,
         FeeAmount:String! = nil,
         FeeStatus: String! = nil) {
        
        self.TimeStampProfileCreated = TimeStampProfileCreated
        self.FeeAmount = FeeAmount
        self.FeeStatus = FeeStatus
        
    }//end of init
    
    
    
    
    
    init(snapshot: FIRDataSnapshot) {
        
        if let TimeStampProfileCreatedContent = (snapshot.value! as? NSDictionary)?["TimeStampProfileCreated"] as? String {
            self.TimeStampProfileCreated = TimeStampProfileCreatedContent
        }
        
        if let FeeAmountContent = (snapshot.value! as? NSDictionary)?["FeeAmount"] as? String {
            self.FeeAmount = FeeAmountContent
        }
        
        //this will be a boolean value which will enable us to calculate if the fee was already paid or not when payment is disbursed to cleaner
        if let FeeStatusContent = (snapshot.value! as? NSDictionary)?["FeeStatus"] as? String {
            self.FeeStatus = FeeStatusContent
        }
        
    }//end of init
    
    
    
    //convenience method used to convert this struct in AnyObject type in order to write the values to Firebase
    func convertBackgroundCheckToAnyObject() -> AnyObject {
        
        var someDict = [String : AnyObject]()
        someDict["TimeStampProfileCreated"] = self.TimeStampProfileCreated as AnyObject?
        someDict["FeeAmount"] = self.FeeAmount as AnyObject?
        someDict["FeeStatus"] = self.FeeStatus as AnyObject?
        
        return someDict as AnyObject
    }
    
    
    func convertBackgroundCheckFeeStatusToAnyObject() -> AnyObject {
        var someDict = [String : AnyObject]()
        someDict["FeeStatus"] = self.FeeStatus as AnyObject?
        return someDict as AnyObject
    }
    
    
}//end of struct BackgroundCheck





