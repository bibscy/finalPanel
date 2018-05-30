//
//  CleanerProfile.swift
//  finalPanel
//
//  Created by Bogdan Barbulescu on 07/05/2018.
//  Copyright © 2018 Appfish. All rights reserved.
//

//used to save the profile in the database when user registers

class CleanerProfile {
    
    
    let cleanerStatus:String
    let cleanerUID:String
    let emailAddress: String
    let nationalInsurance: String
    let firstName: String
    let lastName: String
    let phoneNumber: String
    let postCode: String
    let city: String
    let streetAddress: String
    let userType: String
    var profileCreatedDate: String
    var profileCreatedTimeStamp: String
    let account = ""
    let sortCode = ""
    var profileImage = UIImage()
    var identityDocumentImage = UIImage()
    
    //download text data from firebase
    init(dictionary:[String: Any]) {
        self.cleanerStatus = dictionary["cleanerStatus"] as! String
        self.cleanerUID = dictionary["cleanerUID"] as! String
        self.emailAddress = dictionary["emailAddress"] as! String
        self.nationalInsurance = dictionary["nationalInsurance"] as! String
        self.firstName = dictionary["firstName"] as! String
        self.lastName = dictionary["lastName"] as! String
        self.phoneNumber = dictionary["phoneNumber"] as! String
        self.postCode = dictionary["postCode"] as! String
        self.city = dictionary["city"] as! String
        self.streetAddress = dictionary["streetAddress"] as! String
        self.userType = dictionary["userType"] as! String
        self.profileCreatedDate = dictionary["profileCreatedDate"] as! String
        self.profileCreatedTimeStamp = dictionary["profileCreatedTimeStamp"] as! String
    }
    
}//end of class


extension CleanerProfile {
    
    func downloadProfilePicture(completion: @escaping (UIImage?, Error?) -> Void) {
        FIRImage.downloadProfileImage(cleanerUID) { (image, error) in
            completion(image, error)
        }
    }
    
    
    
    func downloadIdentityImg(completion: @escaping (UIImage?, Error?) -> Void) {
        FIRImage.downloadIdentityDocumentImage(cleanerUID) { (image, error) in
            completion(image, error)
        }
    }
    
    
}//end of extension



//enable the the programmer to compare two objects of type CleanerProfile
extension CleanerProfile:Equatable { }

func ==(lhs: CleanerProfile,rhs: CleanerProfile) -> Bool {
    return lhs.cleanerUID == rhs.cleanerUID
}






