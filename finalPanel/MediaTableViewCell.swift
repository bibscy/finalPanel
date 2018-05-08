//
//  MediaTableViewCell.swift
//  finalPanel
//
//  Created by Bogdan Barbulescu on 07/05/2018.
//  Copyright © 2018 Appfish. All rights reserved.
//

import UIKit


class MediaTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var emailAddress: UILabel!
    @IBOutlet weak var nationalInsurance: UILabel!
    @IBOutlet weak var firstName: UILabel!
    @IBOutlet weak var lastName: UILabel!
    @IBOutlet weak var phoneNumber: UILabel!
    @IBOutlet weak var postCode: UILabel!
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var streetAddress: UILabel!
    @IBOutlet weak var profileCreatedDate: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var identityImage: UIImageView!
    
    
    var currentCleaner: CleanerProfile! {
        didSet {
            updateUI()
        }
    }
    
    
    func updateUI() {
        
        status.text = currentCleaner.cleanerStatus
        emailAddress.text = currentCleaner.emailAddress
        nationalInsurance.text = currentCleaner.nationalInsurance
        firstName.text = currentCleaner.firstName
        lastName.text = currentCleaner.lastName
        phoneNumber.text = currentCleaner.phoneNumber
        postCode.text = currentCleaner.postCode
        city.text = currentCleaner.city
        streetAddress.text = currentCleaner.streetAddress
        profileCreatedDate.text = currentCleaner.profileCreatedDate
        
        
        currentCleaner.downloadIdentityImg(completion: { [weak self](image, error) in
            guard let profileImage = image else {
                let message = "\(error!.localizedDescription) error is on line \(#line)"
                print(message)
                return
            }
            self?.currentCleaner.profileImage = profileImage
            
            self?.currentCleaner.downloadIdentityImg(completion: { [weak self](image, error) in
                guard let identityImage = image else {
                    let message = "\(error!.localizedDescription) error is on line \(#line)"
                    print(message)
                    return
                }
                self?.currentCleaner.identityDocumentImage = identityImage
            })
        })
        

        
    }//end of func updateUI


}//end of class
