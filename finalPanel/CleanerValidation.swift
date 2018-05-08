//
//  CleanerValidation.swift
//  finalPanel
//
//  Created by Bogdan Barbulescu on 07/05/2018.
//  Copyright © 2018 Appfish. All rights reserved.
//

import UIKit
import Firebase
import DGActivityIndicatorView

class CleanerValidation: UITableViewController {

//    let convenience = ConvenienceMethods()
    var activityIndicatorView = DGActivityIndicatorView(type: .ballSpinFadeLoader, tintColor: UIColor.black, size: 100.0)
    
    var cleaners = [CleanerProfile]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.activityIndicatorView?.frame = CGRect(x: 150, y: 200, width: 100.0, height: 100.0)
        self.view.addSubview(activityIndicatorView!)
        
        self.readCleanerProfile { (cleanersArray: [CleanerProfile]?) in
            guard let newCleaners = cleanersArray else  {
                return
            }
            self.cleaners = newCleaners
         }
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return cleaners.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if cleaners.count == 0 {
            return 0
        } else{
            return 1
        }
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MediaTableViewCell", for: indexPath) as! MediaTableViewCell
        cell.currentCleaner = cleaners[indexPath.section]
        return cell
    }
  
}


extension CleanerValidation {
    
    
    func readCleanerProfile(completion: @escaping ([CleanerProfile]?) -> Void) {
        
        guard let _ =  FIRAuth.auth()?.currentUser?.uid else {
            let message = "user in not logged in line \(#line)"
            print(message)
            return
        }
        
        let t1 = Date().timeIntervalSince1970 - 24 * 60 * 60
        let t2 = Date().timeIntervalSince1970
        
        DatabaseReference.cleanersProfile.reference().queryOrdered(byChild: "profileCreatedTimeStamp").queryStarting(atValue: t1).queryEnding(atValue: t2).observe(.value, with: { [weak self] (snapshot) in
            
            guard snapshot.exists() else {
                let message = "snapshot does not exist line \(#line)"
                    showCustomAlert(customMessage: message, viewController: self!)
               return
            }
            
            var newCleanersProfile = [CleanerProfile]()
            
        for item in snapshot.children {
                let cleaner = item as! FIRDataSnapshot
                
                if let cleanerDict = cleaner.value as? [String : Any] {
                    let cleanerProfile = CleanerProfile(dictionary: cleanerDict)
                     newCleanersProfile.append(cleanerProfile)
                }
            }//end of for item in snapshot.children
              completion(newCleanersProfile)
        })
    }//end of readCleanerProfile
    
    
    
}//end of extension








