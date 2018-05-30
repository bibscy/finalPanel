//
//  MediaTableViewCell.swift
//  finalPanel
//
//  Created by Bogdan Barbulescu on 07/05/2018.
//  Copyright © 2018 Appfish. All rights reserved.


import UIKit
import SAMCache

protocol MediaTableViewCellDelegate: class {
    
    func approveButtonTappedAt(cell: MediaTableViewCell, cleanerUID: String)
    func rejectButtonTappedAt(cell: MediaTableViewCell, cleanerUID: String)
}


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
    @IBOutlet weak var approveButton: UIButton!
    @IBOutlet weak var rejectButton: UIButton!
    
    weak var delegate: MediaTableViewCellDelegate?
    
    var currentCleaner: CleanerProfile! {
        didSet {
            updateUI()
        }
    }
    
    var cache = SAMCache.shared()
    
    @IBAction func approveCleaner(_ sender: Any) {
        self.delegate?.approveButtonTappedAt(cell: self, cleanerUID: currentCleaner.cleanerUID)
    }
    
    @IBAction func rejectCleaner(_ sender: Any) {
        self.delegate?.rejectButtonTappedAt(cell: self, cleanerUID: currentCleaner.cleanerUID)
    }
    
    
    func updateUI() {
        
        self.identityImage.image = nil
        self.profileImage.image = nil
        
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
        
        let identityPictureKey = "\(currentCleaner.cleanerUID)-identityPictureKey"
        let profilePictureKey = "\(currentCleaner.cleanerUID)-profilePictureKey"
        
        if let image = cache?.image(forKey: identityPictureKey) {
            self.profileImage.image = image
        }else {
            
            currentCleaner.downloadProfilePicture(completion: { [weak self](image, error) in
                guard let profileImage = image else {
                    let message = "\(error!.localizedDescription) error is on line \(#line)"
                    print(message)
                    return
                }
                   self?.profileImage.image = profileImage
        })
    }
       
        
        if let image = cache?.image(forKey: profilePictureKey) {
            self.identityImage.image = image
        }else {
            currentCleaner.downloadIdentityImg(completion: { [weak self](image, error) in
                guard let identityImage = image else {
                    let message = "\(error!.localizedDescription) error is on line \(#line)"
                    print(message)
                    return
                }
                self?.identityImage.image = identityImage
            })
        }
    }//end of func updateUI


}//end of class
