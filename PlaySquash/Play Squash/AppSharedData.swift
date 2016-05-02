//
//  AppSharedData.swift
//  Play Squash
//
//  Created by Imran Aziz on 12/9/15.
//  Copyright © 2015 Maikya. All rights reserved.
//

import Foundation
import UIKit

class AppShareData {
    class var sharedInstance: AppShareData {
        struct Static {
            static var instance: AppShareData?
            static var token: dispatch_once_t = 0
        }
        //TODO: Use Swift singleton pattern instead
        dispatch_once(&Static.token) {
            Static.instance = AppShareData()
            Static.instance!.userProfile = AppUserProfile()
            Static.instance!.cloudData = AppCloudData()
        }
        
        return Static.instance!
    }
    
    var userProfile : AppUserProfile!
    var cloudData : AppCloudData!
}
    /*
 
    var validProfile : String = "false"
    var playerProfileImage : UIImage!
    var playerFirstName : String! = ""
    var playerLastName : String! = ""
    var playerNickName : String!  = ""
    var playerPhone : String! = ""
    var playerEmail : String! = ""
    var playerSquashID : String! = ""
    var playerHomeClub : String! = ""
    var playerRating : String! = ""

    func persistPlayerProfileInformation()
    {
        if validProfile == "false" { return }

        let directories = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)

        if let documents = directories.first {
            if let urlDocuments = NSURL(string: documents) {
                let urlDictionary = urlDocuments.URLByAppendingPathComponent("playerprofile.plist")
    
                // Write Array to disk
                let dictionary = ["ValidProfile" : validProfile, "FirstName" : playerFirstName, "LastName" : playerLastName, "NickName" : playerNickName, "Phone" : playerPhone, "Email" : playerEmail, "SquashID" : playerSquashID, "HomeClub" : playerHomeClub, "Rating" : playerRating] as NSDictionary
                
                    dictionary.writeToFile(urlDictionary.path!, atomically: true)
                
                // Write user profile image to disk
                let pngFilePath = urlDocuments.URLByAppendingPathComponent("playerProfile.png")
                UIImagePNGRepresentation(playerProfileImage)?.writeToFile(pngFilePath.path!, atomically: true)
            }
        }
    }
    
    func loadPlayerProfileInformation()
    {
        let directories = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        
        if let documents = directories.first {
            if let urlDocuments = NSURL(string: documents) {
                let urlDictionary = urlDocuments.URLByAppendingPathComponent("playerprofile.plist")
                
                // Load from disk
                let loadedDictionary = NSDictionary(contentsOfFile: urlDictionary.absoluteString)
                
                if loadedDictionary == nil {return}
                if loadedDictionary?.count == 0 {return}
                if loadedDictionary!["ValidProfile"] == nil {return}
                
                let validProfileOnDisk = loadedDictionary!["ValidProfile"] as! String
                if validProfileOnDisk == "false" {return}
                
                playerFirstName = loadedDictionary!["FirstName"] as! String
                playerLastName = loadedDictionary!["LastName"] as! String
                playerNickName = loadedDictionary!["NickName"] as! String
                playerPhone = loadedDictionary!["Phone"] as! String
                playerEmail = loadedDictionary!["Email"] as! String
                playerSquashID = loadedDictionary!["SquashID"] as! String
                playerHomeClub = loadedDictionary!["HomeClub"] as! String
                playerRating = loadedDictionary!["Rating"] as! String
                
                // Load image from disk
                let urlImage = urlDocuments.URLByAppendingPathComponent("playerProfile.png")
                playerProfileImage = UIImage(contentsOfFile: urlImage.absoluteString)
                
                validProfile = "true"
            }
        }
    }
     */
