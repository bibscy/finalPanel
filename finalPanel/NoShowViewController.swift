//
//  NoShowViewController.swift
//  finalPanel
//
//  Created by Bogdan Barbulescu on 17/02/2018.
//  Copyright © 2018 Appfish. All rights reserved.
//

import UIKit

class NoShowViewController: UIViewController, UITextFieldDelegate {
    
    
    let activityIndicator = FullDataActivityIndicator()
    let activityInd = UIActivityIndicatorView()
    
    var objectReceived:Any! //the JSON object received in Alamofire
    var messageAlert:String! // the message to display in myAlert
    

     let logErr = LogError()
     var bookingSelected:FireBaseData!
    
    var params = [String:Any]()
    var commentNoShow: String!
    var currentTimeStamp: Int {
        return Int(Date().timeIntervalSince1970)
    }

    
    @IBOutlet weak var noShowUserOutlet: UIButton!
    
    @IBOutlet weak var noShowCleanerOutlet: UIButton!
    
    
    weak var actionToEnable : UIAlertAction? //holds the sendAction of the alert controller to manage the text field 
    
    
    @IBAction func reportNoShowByUser(_ sender: Any) {
        let message = "Are you sure you want to report as User that cleaner has not shown?"
        self.showInputDialogNoShow(message: message, reportNoShow: reportNoShowAsUserByAdmin)
    }
    
    
    @IBAction func reportNoShowByCleaner(_ sender: Any) {
        let message = "Are you sure you want to report as Cleaner that cleaner can't can't access the property."
        self.showInputDialogNoShow(message: message, reportNoShow: reportNoShowAsCleanerByAdmin)
    }
    
    
    var currentTimeAsString: String!
    
    //format date as string representation
    func formatDate() {
        
        let dateFormatter = DateFormatter()
        let currentDate = Date(timeIntervalSince1970: Double(currentTimeStamp))
        dateFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm"
        self.currentTimeAsString = dateFormatter.string(from: currentDate)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
    
//      FullData.bookingOfUserBool:Bool!
        //true when pressing getBookingsOfUsers
        //false when pressing getBookingsOfCleaners
        
        switch FullData.bookingOfUserBool {
            
        case true:
            self.noShowCleanerOutlet.isEnabled = false
            self.noShowCleanerOutlet.isEnabled = true
            
        case false:
            self.noShowCleanerOutlet.isEnabled = true
            self.noShowCleanerOutlet.isEnabled = false
            
        default:
            print("hang on unhandled case!")
        }
        
    }

  
    
    
   
}//end of class
