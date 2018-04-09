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
    
    
    @IBOutlet weak var totalEarningsCleaner: UILabel! //
    
    @IBOutlet weak var profitForCleanerOutlet: UILabel!
    @IBOutlet weak var adminProfitOutlet: UILabel!
    @IBOutlet weak var feesCurrentPayPeriodOutlet: UILabel!
    @IBOutlet weak var balanceCarriedForwardOutlet: UILabel!
    @IBOutlet weak var previousBalanceCarriedForwardOutlet: UILabel!
    
    @IBOutlet weak var debtToCleaner: UILabel!
    
    
    
    
    var uidOfTextField:String? = nil
    var fromDateStringFieldContent: String? = nil
    var toDateStringFieldContent: String? = nil
    
    var dbRef:FIRDatabaseReference!
    
    var feesFromFirebase: FeesCleaner! //object containing fees retrieved from firebase
    var rescheduledByArray: [RescheduledObject]!
    var cancelledByArray: [CancelledObject]!
    var noShowReportedByArray: [NoShowObject]!
    var bookings: [FireBaseData]!
    
    var bookingsFromQuery = [FireBaseData]()
    
    var disbursePaymentData_Object: AnyObject!
    var feesCleaner_Object: AnyObject!
    var dataForUI: DataForUI!
    
    var startDateTimeStamp:Int! {
        return convertDateStringToTimpeStamp(inputStringDate: fromDateString.text!)
    }
    
    var endDateTimeStamp:Int! {
        return convertDateStringToTimpeStamp(inputStringDate: toDateString.text!)
    }
    
    
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //uid of admin
        guard ((FIRAuth.auth()?.currentUser?.uid) != nil)  else {
            logError.prints(message: "admin should be logged in before making a request to Firebase")
            return
        }
          dbRef = FIRDatabase.database().reference()
        
    }//end of viewDidLoad
    
    
    
    
    @IBAction func readDatabase(_ sender: Any) {
       
        //check if textFields contain a value
        let textFieldIsTrue = checkTextFields()
           guard textFieldIsTrue == true else  {
            return
        }
        
        self.startReadingDatabase()
    }
    
    
    @IBAction func writeDatabase(_ sender: Any) {
        self.writeToDB()
    }
    
    
    
    func checkTextFields() -> Bool {
        
        fromDateString.text = "2018-03-30 00:01"
        toDateString.text = "2018-04-07 00:01"
        
        guard let uidOfCleaner = fromUidString.text, !uidOfCleaner.isEmpty else {
            let message = "UID of cleaner should be input in textField before making a request to Firebase"
            showCustomAlert(customMessage: message, viewController: self)
            logError.prints(message: message )
            return false
        }
        
            self.uidOfTextField = uidOfCleaner
        
        
        guard let fromDate = fromDateString.text else {// add !condition.isEmpty
            let message = "fromDateString.text is missing"
            showCustomAlert(customMessage: message, viewController: self)
            logError.prints(message: message)
            return false
        }
        self.fromDateStringFieldContent = fromDate
        
        guard let toDate = toDateString.text else {
            let message = "toDateString.text is missing"
            showCustomAlert(customMessage: message, viewController: self)
            logError.prints(message: message)
            return false
        }
        self.toDateStringFieldContent = toDate
        
        return true
    }
    
    
    
    func startReadingDatabase() {
        
      
      
        //retrieve the profile of cleaner and its fees
        //after each disbursement fees are saved in /FeesCleaner/ node
  self.readFeesCleaner { (feesCleanersObject: FeesCleaner) in

            print("readFeesCleaner is called")
            DispatchQueue.main.async {
                
                print("readFeesCleaner is called inside DispatchQueue")
                self.feesFromFirebase = feesCleanersObject
                
                // after reading FeesCleaner read Users
                self.readUsers()
            }
        }
    }//end of readDB
    
    
    
    
    
    
    
    func readUsers() {
        
        self.startObservingDB { (bookingsReceived: [FireBaseData]?, cancelledByArray: [CancelledObject],rescheduledByArray: [RescheduledObject],noShowReportedByArray: [NoShowObject]) in
            
            
            DispatchQueue.main.async {
                
                
                print("startObservingDB is called inside DispatchQueue")
                
                guard let bookings = bookingsReceived, bookings.count > 0 else {
                    let message = "no bookings for this Cleaner"
                    showCustomAlert(customMessage: message, viewController: self)
                    print("bookings are \(bookingsReceived!)")
                    return
                }
                
                print("bookings.count is \(bookings.count)")
                
                self.bookings = bookings //all bookings of the cleaner since registering on the platform
                
                print("self.bookings line 182 is \(self.bookings)")
                self.cancelledByArray = cancelledByArray
                self.rescheduledByArray = rescheduledByArray
                self.noShowReportedByArray = noShowReportedByArray
                
                    self.calculateFeesAndProfit()  //runs on Main Queue
                    self.showFeesInLabels()  //runs on Main Queue
            }//end of DispatchQueue
            
        }//end of startObserving
        
    }//end of readusers()
    



    
    func showFeesInLabels() {
        
        print("showFeesInLabels is called")
         self.totalEarningsCleaner.text = dataForUI.totalEarningsCleaner
         self.profitForCleanerOutlet.text = dataForUI.profitForCleaner
         self.adminProfitOutlet.text = dataForUI.adminProfit
         self.feesCurrentPayPeriodOutlet.text = dataForUI.feesCurrentPayPeriod
         self.balanceCarriedForwardOutlet.text = dataForUI.balanceCarriedForward
         self.previousBalanceCarriedForwardOutlet.text = dataForUI.previousBalanceCarriedForward
        self.debtToCleaner.text = dataForUI.debtToCleaner
    }
    
    
    
 
    
    
    func calculateFeesAndProfit() {
        
        print("calculateFeesAndProfit is called")
        
        guard let startDate = self.startDateTimeStamp else {
            showCustomAlert(customMessage: "no startDate in field", viewController: self)
            return
        }
        
        guard let endDate = self.endDateTimeStamp else {
            showCustomAlert(customMessage: "no endDate in field", viewController: self)
            return
        }
        
        //this property will also hold the bookings that were cancelled, rescheduled,noShow, Completed: false, Completed: true
        guard self.bookings != nil else {
            print("bookings is \(bookings)")
            return
        }
        
        
        fromDateString.text = "2018-03-01 00:01"
        toDateString.text = "2018-03-20 00:01"
        
        //all bookings fromDate - toDate
        let allBookings = self.bookings.filter { $0.TimeStampDateAndTime >= startDate && $0.TimeStampDateAndTime <= endDate}
        
        self.bookingsFromQuery = allBookings
        
        print("self.bookingsFromQuery.count is \(self.bookingsFromQuery.count)")
        
        
       //if $0.BookingCompleted == true , booking was completed by cleaner, it is marked as true when cleaner checks out
        let bookingCompletedLastWeek = self.bookings.filter { $0.BookingCompleted == false  }
        //&& $0.BookingState == "Completed"
        
            //self.bookings.filter { $0.TimeStampDateAndTime >= startDate && $0.TimeStampDateAndTime <= endDate && $0.BookingCompleted == true }
        
        
        
        
        
        //separate bookings by rates
        //            let bookingsWithRate1 = bookingCompletedLastWeek.filter { $0.RateNumberCleaner == "1"}
        
        //get the rate
        //            var rate1: Double {
        //                if !bookingsWithRate1.isEmpty {
        //                    return Double(bookingsWithRate1[0].RatePriceCleaner)!
        //                }
        //               return 0.0
        //            }
        
        
        
        //            let amountsForBookingsWithRate1 = bookingsWithRate1.map { Double($0.AmountPaidToCleanerForBooking)!}
        

        //            let arrayOfAllBookingsRates = [amountsForBookingsWithRate1, amountsForBookingsWithRate2, amountsForBookingsWithRate3,amountsForBookingsWithRate4].flatMap {$0}
        
        //same as totalAmountPaidToCleanerForAllBookings, the only difference being that we separates bookings by rates above
        //            let sumOfArrayOfAllBookingAmountsPaidToCleaner = arrayOfAllBookingsRates.reduce(0, +)
        
        
        
        //check if any bookings containes RateNumberCleaner and map each amount to an array
        //calculate the sum of all amounts paid to cleaner for each booking completed
       
        let bookingsWithRates = bookingCompletedLastWeek.filter {$0.RateNumberCleaner != nil}.map { Double($0.AmountPaidToCleanerForBooking)!}
        let totalAmountPaidToCleanerForAllBookings = bookingsWithRates.reduce(0, +)
        
        print("line 266 totalAmountPaidToCleanerForAllBookings \(totalAmountPaidToCleanerForAllBookings)")
        
        //you can make the rates for yourself too to see how much you gain for each booking or for all of them
        let adminProfitAmounts = bookingCompletedLastWeek.flatMap {Double($0.ProfitForBooking)!}
        let totalAdminProfitForBookings = adminProfitAmounts.reduce(0, +)
        
           print("line 272 totalAdminProfitForBookings \(totalAdminProfitForBookings)")
        
        
        //FEE_______________________________
        //filter all elements where FeeAmountChargedToCleaner != nil
        let cancellationFeesArray = self.cancelledByArray.filter { $0.feeAmountChargedToCleaner != nil && $0.cleanerUID == self.uidOfTextField }.map {Double($0.feeAmountChargedToCleaner)!}
        
        //alternative way of finding the fees as in cancellationFeesArray Wrong Wrong!
        //            let cancelledBookings = allBookings.filter {$0.objectsUnderCancelledBy != nil}.map {$0.objectsUnderCancelledBy["FeeAmountChargedToCleaner"] as? String}
        //
        
        //create array with cancelledBy and rescheduledBy items
        
        
        
        //filter all elements where amountDebtToCleaner != nil
        let cancellationAmountsToRecompensateCleanerArray = cancelledByArray.filter {$0.amountDebtToCleaner != nil && $0.cleanerUID == self.uidOfTextField}.map {Double($0.amountDebtToCleaner)!}
        

        
        //filter all elements where feeAmount != nil
        let rescheduledFeesArray = rescheduledByArray.filter {$0.feeAmountChargedToCleaner != nil && $0.cleanerUID == self.uidOfTextField}.map {Double($0.feeAmountChargedToCleaner)!}
        
        //filter all elements where amountDebtToCleaner != nil
        let rescheduledAmountsToRecompensateCleanerArray = rescheduledByArray.filter {$0.amountDebtToCleaner != nil && $0.cleanerUID == self.uidOfTextField}.map {Double($0.amountDebtToCleaner)!}
        
        
        let noShowFeesArray = noShowReportedByArray.filter {$0.feeAmountChargedToCleaner != nil && $0.cleanerUID == self.uidOfTextField}.map {Double($0.feeAmountChargedToCleaner)!}
        let noShowAmountsToRecompensateCleanerArray = noShowReportedByArray.filter {$0.amountDebtToCleaner != nil && $0.cleanerUID == self.uidOfTextField}.map {Double($0.amountDebtToCleaner)!}
        
     
        
        //calculate total amount of fees charged to cleaner for bookings:
        // - cancelled by cleaner
        // - rescheduled by customer (always 0) - cleaner is not charged when booking rescheduled by customer, cleaner is recompensated
        let finalArrayOfFees = [cancellationFeesArray, rescheduledFeesArray, noShowFeesArray].flatMap {$0}
        var sumOfFinalArrayOfFees = finalArrayOfFees.reduce(0, +)
        
        print("line 312 sumOfFinalArrayOfFees \(sumOfFinalArrayOfFees)")

        
        //calculate total amount to recompensate cleaner for bookings:
        // - cancelled by customer or cleaner
        // - rescheduled by customer
        // - noShow by customer or cleaner
        let finalArrayOfAmountsToRecompensateCleaner = [cancellationAmountsToRecompensateCleanerArray, rescheduledAmountsToRecompensateCleanerArray, noShowAmountsToRecompensateCleanerArray].flatMap { $0 }
        let sumOfFinalArrayOfAmountsToRecompensateCleaner = finalArrayOfAmountsToRecompensateCleaner.reduce (0, +)
        
        
        print("line 323 sumOfFinalArrayOfAmountsToRecompensateCleaner \(sumOfFinalArrayOfAmountsToRecompensateCleaner)")

       
                var outstandingFees:OutstandingFees?
            if let obj = self.feesFromFirebase.outstandingFees as? [String:String] {
               outstandingFees = OutstandingFees(
                 timeStampFeesCarriedForward: obj["TimeStampFeesCarriedForward"],
                 balanceCarriedForwardAmount: obj["BalanceCarriedForwardAmount"],
                 previousBalanceCarriedForward: obj["PreviousBalanceCarriedForward"])
        }
        
        
        
            var backgroundCheck:BackgroundCheck!
        
      
        
        if let obj = self.feesFromFirebase.backgroundCheck as? [String:String] {
             backgroundCheck = BackgroundCheck(
                 TimeStampProfileCreated: obj["TimeStampProfileCreated"],
                 FeeAmount: obj["FeeAmount"],
                 FeeStatus: obj["FeeStatus"])
            
            print("backgroundCheck is line 338 \(backgroundCheck)")
          
        }
        
        
          var previousBalanceCarriedForwardReceived = 0.0
        if outstandingFees?.balanceCarriedForwardAmount != nil &&  !(outstandingFees?.balanceCarriedForwardAmount?.isEmpty)! {
             previousBalanceCarriedForwardReceived = Double(outstandingFees!.balanceCarriedForwardAmount!)!
            //basically this is the amount owed by the cleaner since last week pay cycle
        }
        
        
        print("backgroundCheck is line 342 \(backgroundCheck)")
        
        let backgroundCheckFeeReceived = Double(backgroundCheck.FeeAmount)!
        let statusPaymentBackgroundCheckReceived = Bool(backgroundCheck.FeeStatus)!
        let backgroundCheckTimeStampProfileCreatedReceived = backgroundCheck.TimeStampProfileCreated
      

        
        //cleaner profit
        var totalAmountProfitToCleanerForAllBookings: Double! = totalAmountPaidToCleanerForAllBookings + sumOfFinalArrayOfAmountsToRecompensateCleaner - sumOfFinalArrayOfFees - previousBalanceCarriedForwardReceived
        
        print("line 351 totalAmountProfitToCleanerForAllBookings \(totalAmountProfitToCleanerForAllBookings)")
        
        var backgroundCheckFeeWasPaid: Bool = false
        
        //check if backgroundCheckFee has not been paid
        //if profit is lower than fees don't subtract backgroundCheckFee
        
        
        if statusPaymentBackgroundCheckReceived == false  {
            //subtract backgroundcheckfee from profit cleaner and add it to sumOfFinalArrayOfFees
            
            backgroundCheckFeeWasPaid = true
            print("sumOfFinalArrayOfFees is up \(sumOfFinalArrayOfFees)")

            sumOfFinalArrayOfFees += backgroundCheckFeeReceived
            print("sumOfFinalArrayOfFees is down \(sumOfFinalArrayOfFees)")
            
//            if totalAmountProfitToCleanerForAllBookings > backgroundCheckFeeReceived {
                let finalAmountProfitCleaner = totalAmountProfitToCleanerForAllBookings - backgroundCheckFeeReceived
                totalAmountProfitToCleanerForAllBookings = finalAmountProfitCleaner
            
//            }
        }
        
        
        
        
          //if totalAmountProfitToCleanerForAllBookings < 0:
         // -  that amount represents fees to be charged in next payment cycle
        // - assign 0.0 to profit of cleaner
        var currentBalanceCarriedForward:String!
        
        if totalAmountProfitToCleanerForAllBookings < 0.0 {
            //abs() converts a negative number in a positive one
            currentBalanceCarriedForward = String(abs(totalAmountProfitToCleanerForAllBookings))
            //make profit 0.0
            totalAmountProfitToCleanerForAllBookings = 0.0
        } else {
            currentBalanceCarriedForward = "0.0"
        }
        
       
        let timeStampNow = String(Int(Date().timeIntervalSince1970))
        let paymentRef = self.random9DigitString() //payment reference
        
       print("totalAmountProfitToCleanerForAllBookings line 388 \(totalAmountProfitToCleanerForAllBookings)")
      
        
//        let outstandingFeesConverted = OutstandingFees(
//                            timeStampFeesCarriedForward: timeStampNow,
//                            balanceCarriedForwardAmount: currentBalanceCarriedForward,
//                            previousBalanceCarriedForward: String(previousBalanceCarriedForwardReceived)).convertOutstandingFeesToAnyObject()
//        
//        let timeStampFeesConverted = TimeStampFeesSaved(
//                                payPeriodTimeStampStartDate: String(self.startDateTimeStamp),
//                                totalAmountPaidToCleanerForAllBookings: String(totalAmountPaidToCleanerForAllBookings),
//                                totalAmountProfitToCleanerForAllBookings: String(totalAmountProfitToCleanerForAllBookings),
//                                totalAmountFeesCurrentPayPeriod: String(sumOfFinalArrayOfFees),
//                                totalAmountDebtToCleaner: String(sumOfFinalArrayOfAmountsToRecompensateCleaner),
//                                paymentRef: paymentRef,
//                                timeStampDisbursedPayment: timeStampNow,
//                                balanceCarriedForwardAmount: currentBalanceCarriedForward,
//                                previousBalanceCarriedForward: String(previousBalanceCarriedForwardReceived)).convertTimeStampFeesSavedToAnyObject()
//        
//        let backgroundCheckConverted = BackgroundCheck(FeeStatus: String(backgroundCheckFeeWasPaid)).convertBackgroundCheckToAnyObject()
        
      

        //assign globally to update in Firebase
        self.feeStatusComputed  = String(backgroundCheckFeeWasPaid)
        
        self.timeStampFeesComputed = TimeStampFeesSaved(
            payPeriodTimeStampStartDate: String(self.startDateTimeStamp),
            totalAmountPaidToCleanerForAllBookings: String(totalAmountPaidToCleanerForAllBookings),
            totalAmountProfitToCleanerForAllBookings: String(totalAmountProfitToCleanerForAllBookings),
            totalAmountFeesCurrentPayPeriod: String(sumOfFinalArrayOfFees),
            totalAmountDebtToCleaner: String(sumOfFinalArrayOfAmountsToRecompensateCleaner),
            paymentRef: paymentRef,
            timeStampDisbursedPayment: timeStampNow,
            balanceCarriedForwardAmount: currentBalanceCarriedForward,
            previousBalanceCarriedForward: String(previousBalanceCarriedForwardReceived),
            backgroundCheckFeeStatus: String(backgroundCheckFeeWasPaid))
        
        self.outstandingFeesComputed = OutstandingFees(
            timeStampFeesCarriedForward: timeStampNow,
            balanceCarriedForwardAmount: currentBalanceCarriedForward,
            previousBalanceCarriedForward: String(previousBalanceCarriedForwardReceived))
        
        
        //This object will hold the fees and additional data after a payment is made to a cleaner every pay cycle
        //A pay cycle should be made once a week
//        let feesCleaner_Obj = FeesCleaner(outstandingFees: outstandingFeesConverted,
//                                           timeStampFeesSaved: [timeStampNow: timeStampFeesConverted],
//                                           backgroundCheck: backgroundCheckConverted).convertToAnyObject()
        
        //assign feesCleaner_Obj to global var in order to post it to database later
//        self.feesCleaner_Object = feesCleaner_Obj
        
      
     
        // - all bookings for a certain period
        var finalArrayOfBookings = [String: AnyObject]()
        
        //bookingsFromQuery will also include the bookings that were cancelled, rescheduled, noShow, completed: true/false
        
        print("bookings from query are \(bookingsFromQuery)")
      
        
        for booking in self.bookingsFromQuery {
            //create an instance with data from all bookings fromStartData to endDate
            let bookingForPayPeriod = DisbursePaymentData(
              
                numberOfHours: booking.NumberOfHours,
                bookingAmount: booking.BookingAmount,
                suppliesAmount: String(booking.SuppliesAmount),
                flatNumber: booking.FlatNumber,
                postCode: booking.PostCode,
                streetAddress: booking.StreetAddress,
                dateAndTime: booking.DateAndTime,
                timeStampDateAndTime: String(booking.TimeStampDateAndTime),
                timeStampBookingClaimed: booking.TimeStampBookingClaimed,
                amountPaidToCleanerForBooking: booking.AmountPaidToCleanerForBooking,
                profitForBooking:booking.ProfitForBooking, // profit made by admin for this booking
                checkInDate: booking.checkInDate,
                checkOutDate: booking.checkOutDate,
                checkInTimeStamp: booking.checkInTimeStamp,
                checkOutTimeStamp: booking.checkOutTimeStamp,
                ratePriceClient: booking.RatePriceClient,
                rateNumberClient: booking.RateNumberClient,
                ratePriceCleaner: booking.RatePriceCleaner,
                rateNumberCleaner: booking.RateNumberCleaner,
                cancelledBy: booking.objectsUnderCancelledBy,
                rescheduledBy:booking.objectsUnderRescheduledBy,
                noShowBy: booking.objectsUnderNoShowBy)
            
            let fullItem = bookingForPayPeriod.convertDisbursePaymentDataToAnyObject()
            finalArrayOfBookings[booking.BookingNumber] = fullItem
        }
        
        print("line 487 finalArrayOfBookings is \(finalArrayOfBookings)")
        
        //create the final object which will hold:
        // - all bookings for a certain period,
        //including cancelled, rescheduled, noShow, completed: true/false bookings and the costs for taking such actions
        // let finalObject
        let disbursePaymentData_Obj = DisbursePaymentData(
            payPeriodDateStartDate: self.fromDateStringFieldContent!,
            payPeriodEndDate: self.toDateStringFieldContent!,
            payPeriodTimeStampStartDate: String(describing: self.startDateTimeStamp!),
            payPeriodTimeStampEndDate: String(describing: self.endDateTimeStamp!),
            paymentRef: paymentRef,
            timeStampDisbursedPayment: timeStampNow,
            
            totalAmountPaidToCleanerForAllBookings: String(describing: totalAmountPaidToCleanerForAllBookings), //total amount without fees subtracted
            totalAmountProfitToCleanerForAllBookings: String(describing: totalAmountProfitToCleanerForAllBookings!),
            
            totalAdminProfitForBookings: String(describing: totalAdminProfitForBookings),
            
            totalAmountFeesCurrentPayPeriod: String(describing: sumOfFinalArrayOfFees),
            
            totalAmountDebtToCleaner: String(describing: sumOfFinalArrayOfAmountsToRecompensateCleaner),
            
            balanceCarriedForwardAmount: currentBalanceCarriedForward,
            
            previousBalanceCarriedForward: String(previousBalanceCarriedForwardReceived), //== balanceCarriedForwardAmount from previous pay cycle
            
            backgroundCheckFeeStatus: String(backgroundCheckFeeWasPaid),
            backgroundCheckFeeAmount: String(backgroundCheckFeeReceived),
            backgroundCheckTimeStampProfileCreated: String(backgroundCheckTimeStampProfileCreatedReceived!),
            
            bookings: finalArrayOfBookings).toAnyObj()
        
        
        self.disbursePaymentData_Object = disbursePaymentData_Obj
        
        print(" disbursePaymentData_Obj is \(self.disbursePaymentData_Object)")
        
        //assign the data necessary for UI
        
        print("totalAmountProfitToCleanerForAllBookings is \(totalAmountProfitToCleanerForAllBookings)")
        
        self.dataForUI = DataForUI(
            totalEarningsCleaner:String(totalAmountPaidToCleanerForAllBookings),
            profitForCleaner: String(describing: totalAmountProfitToCleanerForAllBookings!),
            adminProfit: String(describing: totalAdminProfitForBookings),
            feesCurrentPayPeriod: String(describing: sumOfFinalArrayOfFees),
            balanceCarriedForward: currentBalanceCarriedForward,
            previousBalanceCarriedForward: String(previousBalanceCarriedForwardReceived),
            paymentRef:paymentRef,
            timeStamp: timeStampNow,
            debtToCleaner:String(sumOfFinalArrayOfAmountsToRecompensateCleaner))
        
        
    }//end of calculateFeesAndProfit
    


    struct DataForUI {
        
        let totalEarningsCleaner:String
        let profitForCleaner:String
        let adminProfit:String
        let feesCurrentPayPeriod:String
        let balanceCarriedForward:String
        let previousBalanceCarriedForward:String
        let paymentRef:String
        let timeStamp:String
        let debtToCleaner:String
    }


    
    // generate a random number
    func random9DigitString() -> String {
        let min: UInt32 = 100_000_000
        let max: UInt32 = 999_999_999
        let i = min + arc4random_uniform(max - min + 1)
        return String(i)
    } //end of random9DigitString()
    
    
    
    
    var feeStatusComputed:String!
    var outstandingFeesComputed:OutstandingFees!
    var timeStampFeesComputed:TimeStampFeesSaved!
    
  
    
    func writeToDB() {
        
        let ts = self.timeStampFeesComputed
        let otf = self.outstandingFeesComputed
        //          let objectComplete = finalObject.toAnyObj()

        
        let ref_1 = "CleanersPayments/\(self.fromUidString.text!)"
        let ref_2 = "FeesCleaner/\(self.fromUidString.text!)"
        let ref_3 = "\(ref_2)/TimeStampFeesSaved/\(self.dataForUI.paymentRef)"
      
        
        let childUpdates =
        ["\(ref_1)/\(self.dataForUI.paymentRef)" : self.disbursePaymentData_Object,
                            
          "\(ref_2)/BackgroundCheck/FeeStatus": feeStatusComputed as AnyObject,
          
         "\(ref_2)/OutstandingFees/BalanceCarriedForwardAmount": otf?.balanceCarriedForwardAmount as AnyObject,
         "\(ref_2)/OutstandingFees/PreviousBalanceCarriedForward": otf?.previousBalanceCarriedForward as AnyObject,
         "\(ref_2)/OutstandingFees/TimeStampFeesCarriedForward": otf?.timeStampFeesCarriedForward as AnyObject,
         
         
         "\(ref_3)/\("PayPeriodTimeStampStartDate")": ts?.payPeriodTimeStampStartDate! as AnyObject,
         
              "\(ref_3)/\("TotalAmountPaidToCleanerForAllBookings")": ts?.totalAmountPaidToCleanerForAllBookings! as AnyObject,
            
                "\(ref_3)/\("TotalAmountProfitToCleanerForAllBookings")": ts?.totalAmountProfitToCleanerForAllBookings! as AnyObject,
                
                "\(ref_3)/\("TotalAmountFeesCurrentPayPeriod")": ts?.totalAmountFeesCurrentPayPeriod! as AnyObject,
            
                "\(ref_3)/\("TotalAmountDebtToCleaner")": ts?.totalAmountDebtToCleaner! as AnyObject,
                
                "\(ref_3)/\("PaymentRef")": ts?.paymentRef! as AnyObject,
                
                "\(ref_3)/\("TimeStampDisbursedPayment")": ts?.timeStampDisbursedPayment! as AnyObject,
                
                "\(ref_3)/\("BalanceCarriedForwardAmount")": ts?.balanceCarriedForwardAmount! as AnyObject,
                
                "\(ref_3)/\("PreviousBalanceCarriedForward")": ts?.previousBalanceCarriedForward! as AnyObject,
                "\(ref_3)/\("BackgroundCheckFeeStatus")": ts?.backgroundCheckFeeStatus! as AnyObject
        ]
        
        
            self.dbRef.updateChildValues(childUpdates, withCompletionBlock: { (error, response) in
                
                if error != nil {
                    let message = ("#line, \(error!.localizedDescription)")
                    showCustomAlert(customMessage: message, viewController: self)
                    print(message)
                }else {
                    let message = "success"
                    showCustomAlert(customMessage: message, viewController: self)
                    print(message)
                }
            })
     }//end of writeDB

    
    
  
}//end of class






