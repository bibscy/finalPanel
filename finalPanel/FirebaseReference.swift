//
//  FirebaseReference.swift
//  finalPanel
//
//  Created by Bogdan Barbulescu on 07/05/2018.
//  Copyright © 2018 Appfish. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage


enum DatabaseReference {
    
    case root
    case cleanersProfile
    case cleanerProfileNested(uid: String)
    
    
//return root ref 
    
    func reference() -> FIRDatabaseReference {
        return FIRDatabase.database().reference().child(path)
    }
    
        private var path: String {
            switch self {
            case .root: return ""
            case .cleanersProfile: return "CleanersProfile"
            case .cleanerProfileNested(let uid): return "Cleaners/\(uid)/profile/cleanerProfile"
            }
        }
    
  }//end of enum



//used to create FIRStorageReference to a specific path for pictures stored
enum StorageReference {
    
    case root
    case profileImage
    case identityDocumentImage
    
    func reference() -> FIRStorageReference {
        return FIRStorage.storage().reference().child(path)
    }
    
    private var path: String {
        
        switch self {
        case .root: return ""
        case .profileImage: return "profileImage"
        case . identityDocumentImage: return "identityDocumentImage"
            
        }
    }
    
}//end of enum





















