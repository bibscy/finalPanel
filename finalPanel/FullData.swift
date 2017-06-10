//
//  FullData.swift
//  controlpanel
//
//  Created by Bogdan Barbulescu on 12/12/2016.
//  Copyright © 2016 Appfish. All rights reserved.
//

import Foundation
import UIKit

struct FullData {
    static  var uid:String!
    static  var finalEmailAddress:String!
    static  var finalDateAndTime:String!
    static  var finalBookingNumber:String!
    static  var finalBookingAmount:String!
    static  var finalCancelAmount:String!
    static  var finalAmountRefunded:String!
    static var finalAmountChargedToReschedule:String!
    
    static  var  finalClientBookingStatus:Bool!
    static  var finalBookingCompleted:Bool!
    static  var finalAdminBookingStatus:Bool!
    static var  finalPaymentID:String!
    static var  finalFirebaseUserID:String!
    static var  finalStripeCustomerID:String!

    
    
    static var finalTimeStampDateAndTime:Int!
    
    static var fromDate:Int!
    static var toDate:Int!
}
