//
//  FIRImage.swift
//  finalPanel
//
//  Created by Bogdan Barbulescu on 07/05/2018.
//  Copyright © 2018 Appfish. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage


class FIRImage {
    
    var image: UIImage
    
    init(image:UIImage) {
        self.image = image
    }
    
}//end of class


extension FIRImage {
    
    
    class func downloadProfileImage(_ uid: String, completion: @escaping (UIImage?,Error?) -> Void) {
        
        StorageReference.profileImage.reference().child(uid).data(withMaxSize: 1 * 1024 * 1024) { (imageData, error) in
            if error == nil && imageData != nil {
                let image = UIImage(data: imageData!)
                completion(image, error)
            }else {
                completion(nil, error)
            }
        }
    }
    
    
    
    class func downloadIdentityDocumentImage(_ uid: String, completion: @escaping (UIImage?,Error?) -> Void) {
        
        StorageReference.identityDocumentImage.reference().child(uid).data(withMaxSize: 1 * 1024 * 1024) { (imageData, error) in
            if error == nil && imageData != nil {
                let image = UIImage(data: imageData!)
                completion(image, error)
            }else {
                completion(nil, error)
            }
        }
    }
    
    
    
    
    
}//end of extension




