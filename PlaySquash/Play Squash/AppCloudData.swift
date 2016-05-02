//
//  AppCloudData.swift
//  Play Squash
//
//  Created by Imran Aziz on 4/7/16.
//  Copyright © 2016 Maikya. All rights reserved.
//

import Foundation
import CloudKit
import UIKit

// Used to retrieve and push app data to the cloud
class AppCloudData {

    struct RecordName {
        static let UserProfile = "MyUserProfileRecord"
    }
    
    // Types of app records that can be queries
    enum AppRecordType: Int {
        case UserProfile = 1
        
        func simpleDescription() -> String {
            switch self {
            case .UserProfile:
                return "UserProfile"
            default:
                return String(self.rawValue)
            }
        }
    }
    
    func CorrespondingRecordID(recordType : AppRecordType) -> String {
        switch recordType {
        case .UserProfile:
                return RecordName.UserProfile
        default:
                return "N/A"
        }
    }
    
    // CloudKit DB's
    let container : CKContainer
    let publicDB  : CKDatabase
    let privateDB : CKDatabase
    
    // Type of records
    let userProfileRecordType : AppRecordType = AppRecordType.UserProfile
    
    // Profile record
    var profileRecord : CKRecord?
    let profileRecordID : CKRecordID
    
    init() {
        container = CKContainer.defaultContainer()
        publicDB = container.publicCloudDatabase
        privateDB = container.privateCloudDatabase
        
        // Initialize singular profile record ID
        profileRecordID = CKRecordID(recordName: RecordName.UserProfile)
    }
    
    // Async gets iCloud record name of logged-in user
    func GetiCloudUserID(complete: (instance: CKRecordID?, error: NSError?) -> ()) {
        self.container.fetchUserRecordIDWithCompletionHandler() {
            recordID, error in
            if error != nil {
                print(error!.localizedDescription)
                complete(instance: nil, error: error)
            } else {
                print("fetched ID \(recordID?.recordName)")
                complete(instance: recordID, error: nil)
            }
        }
    }
    
    // Async gets the iCloud user ID associated with current loged in user
    func getCurrentUserID() -> String {
        var userID : String?
        GetiCloudUserID() {
            recordID, error in
            userID = recordID?.recordName
            if userID != nil {
                print("received iCloudID \(userID)")
            } else {
                print("Fetched iCloudID was nil")
            }
        }
        return userID!
    }
    
    // TODO: Implement delegate protocol for CloudKit notifications and errors
    /* protocol CloudKitDelegate {
    func errorUpdating(error: NSError)
        func modelUpdated()
    }
    */
    
    // Persists to iCloud for the current logged in user's profile record
    func persistUserProfile(userProfile : AppUserProfile) -> Bool {
        var iCloudAccessErrorOccurred : Bool = false
        
        // Check to see if the profile is valid before persisting it to iCloud
        if !userProfile.isValid() {
            return false
        }
        
        // Synchronization of execution blocks
        let operationQueue = NSOperationQueue()
        var fetchOperationFailed : Bool = false
        
        var myRecord = CKRecord(recordType: userProfileRecordType.simpleDescription(),
                                recordID: self.profileRecordID)

        // Try to first fetch the profile record if it already exists
        self.privateDB.fetchRecordWithID(self.profileRecordID) {
        returnRecord, error in
            if let err = error {
                fetchOperationFailed = true
            } else {
                myRecord = returnRecord!
            }
        }

        // Set the properties of the record to save to iCloud
        
        myRecord.setObject(userProfile.userFirstName,
                           forKey: AppUserProfile.ProfilePropertyName.FirstName)
        myRecord.setObject(userProfile.userLastName,
                           forKey: AppUserProfile.ProfilePropertyName.LastName)
        myRecord.setObject(userProfile.userNickName,
                           forKey: AppUserProfile.ProfilePropertyName.NickName)
        myRecord.setObject(userProfile.userEmail,
                           forKey: AppUserProfile.ProfilePropertyName.Email)
        myRecord.setObject(userProfile.userPhone,
                           forKey: AppUserProfile.ProfilePropertyName.Phone)
        myRecord.setObject(userProfile.userRating,
                           forKey: AppUserProfile.ProfilePropertyName.NickName)
        myRecord.setObject(userProfile.userHomeClub.simpleDescription(),
                           forKey: AppUserProfile.ProfilePropertyName.HomeClub)
        
        let imageAsset = CKAsset(fileURL: userProfile.userImageURL!)
        myRecord.setObject(imageAsset, forKey: AppUserProfile.ProfilePropertyName.Image)
        
        // Wrap saving an iCloud record within an operation block to be executed on condition
        let blockOperation = NSBlockOperation {
            self.privateDB.saveRecord(myRecord) {
            returnRecord, error in
                if let err = error {
                    iCloudAccessErrorOccurred = true
                } else {
                    self.profileRecord = myRecord
                }
            }
        }
        
        // Only execute save record if the preceeding iCloud fetch operation failed
        if fetchOperationFailed {
            operationQueue.addOperation(blockOperation)
        }
        
        return iCloudAccessErrorOccurred
    }
    
    // Fetch the current logged in user's profile record
    func fetchUserProfile(userProfile : AppUserProfile) -> Bool {
        var iCloudAccessErrorOccurred : Bool = false

        // Create a record with the profile properties provided by the caler
        var myRecord = CKRecord(recordType: userProfileRecordType.simpleDescription(),
                                recordID: self.profileRecordID)
        
        // Try to fetch the profile record if it exists
        self.privateDB.fetchRecordWithID(self.profileRecordID) {
            returnRecord, error in
            if let err = error {
                iCloudAccessErrorOccurred = true
            } else {
                myRecord = returnRecord!
            }
        }
        
        if iCloudAccessErrorOccurred { return false }
        
        userProfile.userFirstName = myRecord.objectForKey(AppUserProfile.ProfilePropertyName.FirstName) as! String
        userProfile.userLastName = myRecord.objectForKey(AppUserProfile.ProfilePropertyName.LastName) as! String
        userProfile.userNickName = myRecord.objectForKey(AppUserProfile.ProfilePropertyName.NickName) as! String
        userProfile.userEmail = myRecord.objectForKey(AppUserProfile.ProfilePropertyName.Email) as! String
        userProfile.userPhone = myRecord.objectForKey(AppUserProfile.ProfilePropertyName.Phone) as! String
        userProfile.userRating = myRecord.objectForKey(AppUserProfile.ProfilePropertyName.Rating) as! String
        userProfile.userHomeClub.ConvertToEnum(myRecord.objectForKey(AppUserProfile.ProfilePropertyName.HomeClub) as! String)
        
        let imageAsset = myRecord.objectForKey(AppUserProfile.ProfilePropertyName.Image) as! CKAsset
        let urlImage = imageAsset.fileURL
        
        // Load image from disk
        if let loadedImage = UIImage(contentsOfFile: urlImage.absoluteString) {
            userProfile.userImage = loadedImage
        } else {
            iCloudAccessErrorOccurred = true
        }

        return iCloudAccessErrorOccurred
    }
}