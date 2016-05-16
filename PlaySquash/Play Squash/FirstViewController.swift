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
    
    let squashMatchList = [("5/03/16", "W", "Muhammad Kapasi", "Pro Sports Club"),
                           ("4/15/15", "W", "Alex Bard", "Seattle Athletic Club Downtown"),
                           ("3/27/15", "W", "Phil Chung", "Seattle Atheletic Club Northgate"),
                           ("3/16/15", "L", "Andrew Patterson", "Bay Club"),
                           ("2/25/14", "L", "Axel Luft", "Pro Club"),
                           ("2/04/14", "W", "Joe Manaca", "Seattle Athletic Club")]
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
        let navController = self.navigationController as! CustomNavController
        let progressView = navController.progressView!
        
        // Load user profile data from app directory as an optimization for UI refresh
        progressView.setProgress(0.25, animated: true)
        sharedData.userProfile.fetchProfileFromDisk()
        if sharedData.userProfile.isValid() {
            updateProfileCard()
        }
        
        // Async: retreive user profile information from iCloud to get any updates on other devices
        progressView.setProgress(0.6, animated: true)
        sharedData.cloudData.fetchUserProfile(self.sharedData.userProfile) {
            if self.sharedData.userProfile.isValid() {
                self.updateProfileCard()
            }
            progressView.setProgress(1.0, animated: true)
            self.sharedData.userProfile.persistProfileToDisk()
            progressView.hidden = true
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
        
        let (matchDate, matchResult, matchOpponent, matchClub) = squashMatchList[indexPath.row]
        cell.textLabel!.text = matchDate + ": " + matchOpponent + " (" + matchResult + ")"
    
        cell.detailTextLabel!.text = matchClub
        return cell
    }
}