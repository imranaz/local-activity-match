//
//  FirstViewController.swift
//  Play Squash
//
//  Created by Imran Aziz on 10/22/15.
//  Copyright © 2015 Maikya. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDataSource {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var playerNameTextField: UILabel!
    @IBOutlet weak var mobilePhoneTextField: UILabel!
    @IBOutlet weak var homeClubTextField: UILabel!
    @IBOutlet weak var ratingTextField: UILabel!
    
    let squashMatchList = [("12/03/15", "W", "Muhammad Kapasi", "8-9, 9-7, 9-2, 3-9, 9-6", "ProClub"),
                           ("11/03/15", "W", "Alex Bard", "9-4, 6-9, 9-3, 7-9, 9-3", "SACD"),
                           ("10/27/15", "W", "Phil Chung", "9-5, 4-9, 8-9, 9-7, 9-2", "SACN"),
                           ("5/16/15", "L", "Andrew Patterson", "9-2 9-4, 9-6", "BCSF"),
                           ("3/25/14", "L", "Axel Luft", "9-7, 9-1, 9-3", "ProClub"),
                           ("3/04/14", "W", "Joe Manaca", "9-6, 9-3, 1-9, 9-3", "SACD")]
    let sharedData = AppShareData.sharedInstance
    
    // Update the profile card within the UI
    func updateProfileCard() {
        profileImage.image = sharedData.userProfile.userImage
        playerNameTextField.text = sharedData.userProfile.userFirstName + " " + sharedData.userProfile.userLastName
        mobilePhoneTextField.text = sharedData.userProfile.userPhone
        homeClubTextField.text = sharedData.userProfile.userHomeClub.simpleDescription()
        ratingTextField.text = sharedData.userProfile.userRating
    }
    
     override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Load user profile data from app directory as an optimization for UI refresh
        //sharedData.userProfile.fetchProfileFromDisk()
        if sharedData.userProfile.isValid() {
            updateProfileCard()
        }
        
        // Async: retreive user profile information from iCloud to get any updates on other devices
        sharedData.cloudData.fetchUserProfile(self.sharedData.userProfile) {
            if self.sharedData.userProfile.isValid() {
                self.updateProfileCard()
            }
        }
    }
        
    // Navigation methods

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToUserProfile(sender: UIStoryboardSegue) {
        // Code to perform on return from editing user profile
        profileImage.image = sharedData.userProfile.userImage
        playerNameTextField.text = sharedData.userProfile.userFirstName + " " + sharedData.userProfile.userLastName
        mobilePhoneTextField.text = sharedData.userProfile.userPhone
        homeClubTextField.text = sharedData.userProfile.userHomeClub.simpleDescription()
        ratingTextField.text = sharedData.userProfile.userRating
    }
    
    // TableView methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return squashMatchList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
        
        let (matchDate, matchResult, matchOpponent, matchScore, matchClub) = squashMatchList[indexPath.row]
        cell.textLabel!.text = matchDate + ": " + matchOpponent + " (" + matchResult + ")"
    
        cell.detailTextLabel!.text = matchScore + " @ " + matchClub
        return cell
    }
}