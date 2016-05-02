//
//  AppUserProfile.swift
//  Play Squash
//
//  Created by Imran Aziz on 4/7/16.
//  Copyright © 2016 Maikya. All rights reserved.
//

import Foundation
import UIKit

// User profile properties, accessors and store
class AppUserProfile {
    
    // User type enumeration to allow for different login types
    enum ProfileUserType: Int {
        case Player = 1
        case Professional, Parent
        
        func simpleDescription() -> String {
            switch self {
            case .Player:
                return "Player"
            case .Professional:
                return "Professional"
            case .Parent:
                return "Parent"
            default:
                return String(self.rawValue)
            }
        }
        
        func ConvertToEnum(name: String) -> ProfileUserType {
            switch name {
            case ProfileUserType.Player.simpleDescription():
                return ProfileUserType.Player
            case ProfileUserType.Professional.simpleDescription():
                return ProfileUserType.Professional
            case ProfileUserType.Parent.simpleDescription():
                return ProfileUserType.Parent
            default:
                return ProfileUserType.Player
            }
        }
    }
    
    // Enumeration of file types storaged within the device directory
    enum DeviceFileNames: Int {
        case PlayerProfileFilename = 1
        case PlayerImageFileName
        func simpleDescription() -> String {
            switch self {
            case .PlayerProfileFilename:
                return "playerprofile.plist"
            case .PlayerImageFileName:
                return "playerprofile.png"
            }
        }
    }
        
    enum ProfileProperty: Int {
        case UserType = 1
        case Image, FirstName, LastName, NickName, Phone, Email, SquashID, HomeClub, Rating, Description
    }
    
    struct ProfilePropertyName {
        static let UserType = "UserType"
        static let FirstName = "FirstName"
        static let LastName = "LastName"
        static let NickName = "NickName"
        static let Image = "UserImage"
        static let Phone = "MobilePhone"
        static let Email = "Email"
        static let SquashID = "SquashID"
        static let HomeClub = "HomeClub"
        static let Rating = "Rating"
        static let Description = "Description"
    }
    
    enum HomeClubs: Int {
        case NONE = 0,
        SACD = 1
        case SACN
        func simpleDescription() -> String {
            switch self {
            case .SACD:
                return "SAC Downtown"
            case .SACN:
                return "SAC Northgate"
            case .NONE:
                return ""
            }
        }
        func ConvertToEnum(name: String) -> HomeClubs {
            switch name {
            case "SACD", HomeClubs.SACD.simpleDescription():
                return HomeClubs.SACD
            case "SACN", HomeClubs.SACN.simpleDescription():
                return HomeClubs.SACN
            default:
                return HomeClubs.NONE
            }
        }

    }
    
    // Profile properties
    
    var userType : ProfileUserType
    var userImage : UIImage?
    var userImageURL : NSURL?
    var userFirstName : String
    var userLastName : String
    var userNickName : String
    var userPhone : String
    var userEmail : String
    var userSquashID : String
    var userHomeClub : HomeClubs
    var userRating : String // >1.0 - <2.0: D; >2.0 & <3.0: C; >3.0 & <4.0: B; >4.0 & <6.0: A
    var userDescription : String
    
    // Default initializer for a profile class
    init()
    {
        self.userType = ProfileUserType.Player
        self.userImage = nil
        self.userFirstName = ""
        self.userLastName = ""
        self.userNickName = ""
        self.userPhone = ""
        self.userEmail = ""
        self.userSquashID = ""
        self.userHomeClub = HomeClubs.SACD
        self.userRating = ""
        self.userDescription = ""
    }
    
    // Does basic validation on whether the user profile is valid
    func isValid() -> Bool
    {
        //TODO: Make this more sophisticated
        if userImage == nil || userFirstName == "" || userLastName == ""
        {
            return false
        } else {
            return true
        }
    }
    
    // Saves the profile information to device disk for peristance through app life-cycle. Returns true if successful.
    func persistProfileToDisk() -> Bool
    {
        if !self.isValid() {
            return false
        }
        
        let directories = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        
        if let documents = directories.first {
            if let urlDocuments = NSURL(string: documents) {
                let urlDictionary = urlDocuments.URLByAppendingPathComponent(DeviceFileNames.PlayerProfileFilename.simpleDescription())
                
                if urlDictionary.path == nil { return false }
                
                // Write Array to disk
                
                let dictionary = [
                    ProfilePropertyName.UserType : userType.simpleDescription(),
                    ProfilePropertyName.FirstName : self.userFirstName,
                    ProfilePropertyName.LastName : self.userLastName,
                    ProfilePropertyName.NickName : self.userNickName,
                    ProfilePropertyName.Phone : self.userPhone,
                    ProfilePropertyName.Email : self.userEmail,
                    ProfilePropertyName.SquashID : self.userSquashID,
                    ProfilePropertyName.HomeClub : self.userHomeClub.simpleDescription(),
                    ProfilePropertyName.Rating : self.userRating] as NSDictionary
                
                dictionary.writeToFile(urlDictionary.path!, atomically: true)
                
                // Write user profile image to disk
                let pngFilePath = urlDocuments.URLByAppendingPathComponent(DeviceFileNames.PlayerImageFileName.simpleDescription())
                self.userImageURL = pngFilePath
                UIImagePNGRepresentation(userImage!)?.writeToFile(pngFilePath.path!, atomically: true)
            }
        }
        return true
    }
    
    // Loads profile information from device disk if present. Returns true if succesful.
    func fetchProfileFromDisk() -> Bool
    {
        let directories = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        
        if let documents = directories.first {
            if let urlDocuments = NSURL(string: documents) {
                let urlDictionary = urlDocuments.URLByAppendingPathComponent(DeviceFileNames.PlayerProfileFilename.simpleDescription())
                let userProfile = AppUserProfile()
                
                // Load from disk
                let loadedDictionary = NSDictionary(contentsOfFile: urlDictionary.absoluteString)
                
                if loadedDictionary == nil {return false}
                if loadedDictionary?.count == 0 {return false}
                
                let loadedUserType = loadedDictionary![ProfilePropertyName.UserType] as! String
                userType = userType.ConvertToEnum(loadedUserType)
                userFirstName = loadedDictionary![ProfilePropertyName.FirstName] as! String
                userLastName = loadedDictionary![ProfilePropertyName.LastName] as! String
                userNickName = loadedDictionary![ProfilePropertyName.NickName] as! String
                userPhone = loadedDictionary![ProfilePropertyName.Phone] as! String
                userEmail = loadedDictionary![ProfilePropertyName.Email] as! String
                userSquashID = loadedDictionary![ProfilePropertyName.SquashID] as! String
                let loadedHomeClub = loadedDictionary![ProfilePropertyName.HomeClub] as! String
                userHomeClub = userHomeClub.ConvertToEnum(loadedHomeClub)
                userRating = loadedDictionary![ProfilePropertyName.Rating] as! String
                
                // Load image from disk
                let urlImage = urlDocuments.URLByAppendingPathComponent(DeviceFileNames.PlayerImageFileName.simpleDescription())
                if let loadedImage = UIImage(contentsOfFile: urlImage.absoluteString) {
                    userImage = loadedImage
                } else {
                    return false
                }
            }
        }
        return true
    }
}






