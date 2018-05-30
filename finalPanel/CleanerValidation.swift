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


    var activityIndicatorView = DGActivityIndicatorView(type: .ballSpinFadeLoader, tintColor: UIColor.black, size: 100.0)
    
    var cleaners = [CleanerProfile]()
    
    var emailOfUser: String! //assigned from cellForRow
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.activityIndicatorView?.frame = CGRect(x: 150, y: 200, width: 100.0, height: 100.0)
        self.view.addSubview(activityIndicatorView!)
        self.navigationItem.title = "Cleaner Validation"
        
        self.readCleanerProfile { (cleanersArray: [CleanerProfile]?) in
            guard let newCleaners = cleanersArray else  {
                return
            }
            self.cleaners = newCleaners
            self.tableView.reloadData()
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
        self.emailOfUser = cleaners[indexPath.section].emailAddress
        cell.currentCleaner = cleaners[indexPath.section]
        cell.delegate = self
        
        //add gesture for emailTextField
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CleanerValidation.copyToPasteBoard))
        (cell.contentView.viewWithTag(1) as? UILabel)?.addGestureRecognizer(tapGesture)
        (cell.contentView.viewWithTag(1) as? UILabel)?.isUserInteractionEnabled = true
        
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
        
        let t1 = "\(Date().timeIntervalSince1970 - 24 * 60 * 60)"
        let t2 = "\(Date().timeIntervalSince1970)"
     
        
        DatabaseReference.cleanersProfile.reference()
//            .queryOrdered(byChild: "profileCreatedTimeStamp").queryStarting(atValue: t1).queryEnding(atValue: t2)
        
        DatabaseReference.cleanersProfile.reference()
.queryOrdered(byChild: "cleanerStatus").queryEqual(toValue: "Pending").observe(.value, with: { [weak self] (snapshot) in
            
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
                    if cleanerProfile.cleanerStatus != "Rejected" ||
                        cleanerProfile.cleanerStatus != "Approved" {
                        newCleanersProfile.append(cleanerProfile)
                    }
                }
            }//end of for item in snapshot.children
              completion(newCleanersProfile)
        }) { (error) in
            let message = "error in CleanerValidation on line \(#line) is \(error.localizedDescription)"
            print(message)
            showCustomAlert(customMessage: message, viewController: self)
        }
    }//end of readCleanerProfile
    
    
    
}//end of extension



extension CleanerValidation: MediaTableViewCellDelegate  {
    
    
// get approved & reject buttons event from MediaTableViewCellDelegate
// write in firebase the status of the user Approved || Rejected
    func approveButtonTappedAt(cell: MediaTableViewCell, cleanerUID: String) {
        
        print("approveButtonTappedAt is called")

        
        cell.approveButton.tintColor = .gray
        cell.rejectButton.tintColor = .gray
        DatabaseReference.cleanersProfile.reference().child(cleanerUID).updateChildValues(["cleanerStatus" : "Approved"]) { (error, ref) in
            
            let index = self.tableView.indexPath(for: cell)!
            self.cleaners.remove(at: index.row)
        
        }

        
        
        DatabaseReference.cleanerProfileNested(uid: cleanerUID).reference().updateChildValues((["cleanerStatus" : "Approved"])) { (error, ref) in
            
            self.tableView.reloadData()
        }
        
    }
    
    func rejectButtonTappedAt(cell: MediaTableViewCell, cleanerUID: String) {
        
        print("rejectButtonTappedAt is called")
        
        cell.approveButton.layer.backgroundColor = UIColor.gray.cgColor
        cell.rejectButton.layer.backgroundColor = UIColor.gray.cgColor
        DatabaseReference.cleanersProfile.reference().child(cleanerUID).updateChildValues(["cleanerStatus" : "Rejected"])
        DatabaseReference.cleanerProfileNested(uid: cleanerUID).reference().updateChildValues(["cleanerStatus" : "Rejected"])
    }
    
    
}//end of extension



//Gesture Recognizer
extension CleanerValidation {
    
    func copyToPasteBoard() {
        print("function is called")
        UIPasteboard.general.string = self.emailOfUser
    }
}

