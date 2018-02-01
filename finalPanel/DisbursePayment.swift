//
//  DisbursePayment.swift
//  finalPanel
//
//  Created by Bogdan Barbulescu on 07/12/2017.
//  Copyright © 2017 Appfish. All rights reserved.
//



import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase




class DisbursePayment: UIViewController {


    @IBOutlet weak var fromDateString: UITextField!
    
    @IBOutlet weak var toDateString: UITextField!
    
    @IBOutlet weak var fromUidString: UITextField!
    var uidOfTextField:String? = nil
    var fromDateStringFieldContent: String? = nil
    var toDateStringFieldContent: String? = nil
    
    var dbRef:FIRDatabaseReference!
    
    var bookingsFromQuery = [FireBaseData]()
    
    var startDateTimeStamp:Int! {
        return convertDateStringToTimpeStamp(inputStringDate: fromDateString.text!)
    }
    
    var endDateTimeStamp:Int! {
        return convertDateStringToTimpeStamp(inputStringDate: toDateString.text!)
    }
    
    
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //uid of admin
        guard let uid = FIRAuth.auth()?.currentUser?.uid  else {
            logError.prints(message: "user should be logged in before making a request to Firebase")
            return
        }
        
        guard let uidOfCleaner = fromUidString.text else {
            logError.prints(message: " UID of cleaner should be input in textField before making a request to Firebase")
              return
        }
                self.uidOfTextField = uidOfCleaner
        
        
        guard let fromDate = fromDateString.text else {
            logError.prints(message: "fromDateString.text is missing")
            return
        }
                self.fromDateStringFieldContent = fromDate
        
        guard let toDate = toDateString.text else {
            logError.prints(message: "toDateString.text is missing")
            return
        }
                self.toDateStringFieldContent = toDate
        
        fromDateString.text = "2017-11-13 00:01"
        toDateString.text = "2017-12-10 23:59"
        
        guard let startDate = startDateTimeStamp else {
              showCustomAlert(customMessage: "no startDate in field", viewController: self)
                return
        }
        
        guard let endDate = endDateTimeStamp else {
            showCustomAlert(customMessage: "no endDate in field", viewController: self)
            return
        }
        
         dbRef = FIRDatabase.database().reference().child("Cleaners")
        
        self.startObservingDB { (bookingsReceived: [FireBaseData]?, cancelledByArray: [CancelledObject],rescheduledByArray: [RescheduledObject] ) in
            
            
            
            guard let bookings = bookingsReceived else {
            showCustomAlert(customMessage: "no bookings for this user", viewController: self)
                print("bookings are \(bookingsReceived!)")
                return
            }
            
            
            //rate1 = 
            
            //this will also hold the bookings that were cancelled and rescheduled, but were not completed
            let allBookings = bookings.filter { $0.TimeStampDateAndTime >= startDate && $0.TimeStampDateAndTime <= endDate}
           
            
            
            let bookingCompletedLastWeek = bookings.filter { $0.TimeStampDateAndTime >= startDate && $0.TimeStampDateAndTime <= endDate && $0.BookingCompleted == true }
            
            self.bookingsFromQuery = allBookings
            
          
            
            //separate bookings by rates
            let bookingsWithRate1 = bookingCompletedLastWeek.filter { $0.RateNumberCleaner == "1"}
            
            //get the rate
//            var rate1: Double {
//                if !bookingsWithRate1.isEmpty {
//                    return Double(bookingsWithRate1[0].RatePriceCleaner)!
//                }
//               return 0.0
//            }
            
            let bookingsWithRate2 = bookingCompletedLastWeek.filter {$0.RateNumberCleaner == "2"}
            
            let bookingsWithRate3 = bookingCompletedLastWeek.filter {$0.RateNumberCleaner == "3"}
      
            let bookingsWithRate4 = bookingCompletedLastWeek.filter {$0.RateNumberCleaner == "4"}
      

            
            let amountsForBookingsWithRate1 = bookingsWithRate1.map { Double($0.AmountPaidToCleanerForBooking)!}
            
//            let amountsForBookingsWithRate1 = bookingsWithRate1.map { Double($0.BookingAmount)! - (Double($0.NumberOfHours)! * Double($0.RatePriceCleaner)!) }
            
            let amountsForBookingsWithRate2 = bookingsWithRate2.map { Double($0.AmountPaidToCleanerForBooking)!}

            
            let amountsForBookingsWithRate3 = bookingsWithRate3.map { Double($0.AmountPaidToCleanerForBooking)!}
            
            
            let amountsForBookingsWithRate4 = bookingsWithRate4.map { Double($0.AmountPaidToCleanerForBooking)!}

     
            let arrayOfAllBookingsRates = [amountsForBookingsWithRate1, amountsForBookingsWithRate2, amountsForBookingsWithRate3,amountsForBookingsWithRate4].flatMap {$0}
            
                //same as totalAmountPaidToCleanerForAllBookings, the only difference being that we separates bookings by rates above
//            let sumOfArrayOfAllBookingAmountsPaidToCleaner = arrayOfAllBookingsRates.reduce(0, +)
            
            
            
            
            //check if any bookings containes RateNumberClient and map each amount to an array
            //calculate the sume of all amounts paid to cleaner for each booking completed
              let bookingsWithRates = bookingCompletedLastWeek.filter {$0.RateNumberClient != nil}.map { Double($0.AmountPaidToCleanerForBooking)!}
            let totalAmountPaidToCleanerForAllBookings = bookingsWithRates.reduce(0, +)
            
            
            
            //you can make the rates for yourself too to see how much you gain for each booking or for all of them
            let adminProfitAmounts = bookingCompletedLastWeek.flatMap {Double($0.ProfitForBooking)!}
            let totalAdminProfitForBookings = adminProfitAmounts.reduce(0, +)

           
            

            //FEE_______________________________
            //filter all elements where FeeAmountChargedToCleaner != nil
            let cancellationFeesArray = cancelledByArray.filter { $0.feeAmountChargedToCleaner != nil && $0.cleanerUID == uidOfCleaner }.map {Double($0.feeAmountChargedToCleaner)!}
            
            //alternative way of finding the fees as in cancellationFeesArray
//            let cancelledBookings = allBookings.filter {$0.objectsUnderCancelledBy != nil}.map {$0.objectsUnderCancelledBy["FeeAmountChargedToCleaner"] as? String}
//            
            
            
            //filter all elements where amountDebtToCleaner != nil
            let cancellationAmountsToRecompensateCleanerArray = cancelledByArray.filter {$0.amountDebtToCleaner != nil}.map {Double($0.amountDebtToCleaner)!}
            
            

            //filter all elements where feeAmount != nil
            let rescheduledFeesArray = rescheduledByArray.filter {$0.feeAmountChargedToCleaner != nil}.map {Double($0.feeAmountChargedToCleaner)!}
            
            
            //filter all elements where amountToRecompensate != nil
            let rescheduledAmountsToRecompensateCleanerArray = rescheduledByArray.filter {$0.amountDebtToCleaner != nil}.map {Double($0.amountDebtToCleaner)!}
            
            
            
            
            //calculate total amount of fees charged to cleaner for bookings:
            // - cancelled by cleaner
            // - rescheduled by customer (always 0) - cleaner is not charged when booking rescheduled by customer, cleaner is recompensated
            let finalArrayOfFees = [cancellationFeesArray, rescheduledFeesArray].flatMap {$0}
            let sumOfFinalArrayOfFees = finalArrayOfFees.reduce(0, +)
            
            
            //calculate total amount to recompensate cleaner for bookings:
            // - cancelled by customer or cleaner
            // - rescheduled by customer
            let finalArrayOfAmountsToRecompensateCleaner = [cancellationAmountsToRecompensateCleanerArray, rescheduledAmountsToRecompensateCleanerArray].flatMap { $0 }
            let sumOfFinalArrayOfAmountsToRecompensateCleaner = finalArrayOfAmountsToRecompensateCleaner.reduce (0, +)
            
            //profit of cleaner
            let totalAmountProfitToCleanerForAllBookings = totalAmountPaidToCleanerForAllBookings - sumOfFinalArrayOfFees
            //profitCleaner ==  totalAmountPaidToCleanerForAllBookings - sumOfFinalArrayOfFees
            
            //_______________________end of fee
            
            
            // create a child in our Database with the name "Cleaners"
            
            let timeStamp = String(Int(Date().timeIntervalSince1970))
            let paymentRef = self.random9DigitString() //payment reference

            
            
    var finalArrayOfBookings = [String: AnyObject]()
   
            //bookingsFromQuery will also include the bookings that were cancelled and rescheduled, but were not completed
            for booking in self.bookingsFromQuery {
              
            //create an instance with data from all bookings fromStartData to endDate
            let bookingForPayPeriod = DisbursePaymentData(
                    
                    numberOfHours: booking.NumberOfHours,
                    bookingAmount: booking.BookingAmount,
                    amountPaidToCleanerForBooking: booking.AmountPaidToCleanerForBooking,
                    profitForBooking:booking.ProfitForBooking,
                    checkInDate: booking.checkInDate,
                    checkOutDate: booking.checkOutDate,
                    checkInTimeStamp: booking.checkInTimeStamp,
                    checkOutTimeStamp: booking.checkOutTimeStamp,
                    ratePriceClient: booking.RatePriceClient,
                    rateNumberClient: booking.RateNumberClient,
                    ratePriceCleaner: booking.RatePriceCleaner,
                    rateNumberCleaner: booking.RateNumberCleaner,
                    cancelledBy: booking.objectsUnderCancelledBy,
                    rescheduledBy:booking.objectsUnderRescheduledBy)
            
                    let fullItem = bookingForPayPeriod.convertDisbursePaymentDataToAnyObject()
                finalArrayOfBookings[booking.BookingNumber] = fullItem
            }

            
            //create the final object which will hold:
            // - all bookings for a certain period, 
            //including cancelled and rescheduled bookings and the costs for taking such actions 

            let finalObject = DisbursePaymentData(
                payPeriodDateStartDate: self.fromDateStringFieldContent!,
                payPeriodEndDate: self.toDateStringFieldContent!,
                payPeriodTimeStampStartDate: String(describing: self.startDateTimeStamp),
                payPeriodTimeStampEndDate: String(describing: self.endDateTimeStamp),
                paymentRef: paymentRef,
                
                totalAmountPaidToCleanerForAllBookings: String(describing: totalAmountPaidToCleanerForAllBookings),
                totalAmountProfitToCleanerForAllBookings: String(describing: totalAmountProfitToCleanerForAllBookings),
                totalAdminProfitForBookings: String(describing: totalAdminProfitForBookings),
                totalAmountFeesChargedToCleaner: String(describing: sumOfFinalArrayOfFees),
                totalAmountDebtToCleaner: String(describing: sumOfFinalArrayOfAmountsToRecompensateCleaner),
                
                bookings: finalArrayOfBookings).toAnyObj()
            


//          let objectComplete = finalObject.toAnyObj()

              let childUpdates = ["Payments/\(uid)/\(timeStamp)/\(paymentRef)" : finalObject]
            
            
        self.dbRef.updateChildValues(childUpdates)

          
        }//end of startObserving
        
        
    }//end of viewDidLoad
    
    
    
    
    
    
    // generate a random number
    func random9DigitString() -> String {
        let min: UInt32 = 100_000_000
        let max: UInt32 = 999_999_999
        let i = min + arc4random_uniform(max - min + 1)
        return String(i)
    } //end of random9DigitString()
    
    
  
}





