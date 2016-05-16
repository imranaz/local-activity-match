//
//  ProfileEditorUIViewController.swift
//  Play Squash
//
//  Created by Imran Aziz on 12/7/15.
//  Copyright © 2015 Maikya. All rights reserved.
//

import UIKit

class ProfileEditorTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var saveButton: UIButton!
    
    var imageThumbnail: UIImageView!
    var firstNameTextField: UITextField!
    var lastNameTextField: UITextField!
    
    let imagePicker = UIImagePickerController()
    let sharedData = AppShareData.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let navController = self.navigationController as! CustomNavController
        let progressView = navController.progressView!
        
        // Load user profile data from app directory as an optimization for UI refresh
        progressView.setProgress(1.0, animated: true)
        
        // Load user profile data from app directory
        sharedData.userProfile.fetchProfileFromDisk()
        progressView.hidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    @IBAction func cancelButtonAction(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func saveButtonAction(sender: AnyObject) {
        // Persist profile information entered by the user to both local device and the cloud
        sharedData.userProfile.persistProfileToDisk();
        sharedData.cloudData.persistUserProfile(sharedData.userProfile)
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if saveButton === sender {
            self.sharedData.userProfile.userImage = imageThumbnail.image
            self.sharedData.userProfile.userFirstName = firstNameTextField.text!
            self.sharedData.userProfile.userLastName = lastNameTextField.text!
            
            // Persist profile information entered by the user to both local device and the cloud
            sharedData.userProfile.persistProfileToDisk();
            //sharedData.cloudData.persistUserProfile(sharedData.userProfile)
        }
    }

    // Form validation logic
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        
        return true
    }
    
    func isValidForm() -> Bool {
        // Disable the Save button if manditory name fields are empty.
        let firstName = firstNameTextField.text ?? ""
        let lastName = lastNameTextField.text ?? ""
        
        return !((firstName == "") || (lastName == "") || imageThumbnail == nil)
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        // Make sure the form is still valid after editing.
        if self.isValidForm() {
            saveButton.enabled = false
        }
    }
    
    // Format a phone number text field
    // Credit: http://stackoverflow.com/questions/1246439/uitextfield-for-phone-number
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        var isMobileField = false
        
        // Determine if field being edited is a phone number
        if let containerView = textField.superview {
            if let customCell = containerView as? UserProfileTableViewCell {
                if customCell.propertyField.text == "mobile" {
                    isMobileField = true
                }
            }
        }
        
        if isMobileField {
            let newString = (textField.text! as NSString).stringByReplacingCharactersInRange(range, withString: string)
            let components = newString.componentsSeparatedByCharactersInSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet)
            
            let decimalString : String = components.joinWithSeparator("")
            let length = decimalString.characters.count
            let decimalStr = decimalString as NSString
            let hasLeadingOne = length > 0 && decimalStr.characterAtIndex(0) == (1 as unichar)
            
            if length == 0 || (length > 10 && !hasLeadingOne) || length > 11
            {
                let newLength = (textField.text! as NSString).length + (string as NSString).length - range.length as Int
                
                return (newLength > 10) ? false : true
            }
            var index = 0 as Int
            let formattedString = NSMutableString()
            
            if hasLeadingOne
            {
                formattedString.appendString("1 ")
                index += 1
            }
            if (length - index) > 3
            {
                let areaCode = decimalStr.substringWithRange(NSMakeRange(index, 3))
                formattedString.appendFormat("(%@) ", areaCode)
                index += 3
            }
            if length - index > 3
            {
                let prefix = decimalStr.substringWithRange(NSMakeRange(index, 3))
                formattedString.appendFormat("%@-", prefix)
                index += 3
            }
            
            let remainder = decimalStr.substringFromIndex(index)
            formattedString.appendString(remainder)
            textField.text = formattedString as String
            return false
        }
        else {
            return true
        }
    }
    
    // User profile thumnail picker
    @IBAction func pickUserImage(sender: AnyObject)
    {
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .PhotoLibrary
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    // UIImagePickerControllerDelegate Methods
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!) {
        let selectedImage : UIImage = image
        //var tempImage:UIImage = editingInfo[UIImagePickerControllerOriginalImage] as UIImage
        imageThumbnail.image = selectedImage
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // UITableViewDataSource Protocol Methods
    
    let sectionName = ["Personal Info", "Contact Info", "Club Info", "Squash Info", "Coaching Info", "Pricing"]
    let cellName = [["photo and name"],["email", "mobile"], ["name", "city", "state", "country"], ["level", "ranking"], ["highest rank", "experience"], ["adult", "junior", "assesement"]]
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sectionName.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 4 || section == 5) {
            return 0
        } else {
            return self.cellName[section].count
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sectionName[section]
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        if indexPath.section == 0 {
            return 120.0
        } else {
            return 48.0
        }
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        var sectionHeight = CGFloat(0.0)
        switch section {
        case 0, 4, 5:
            sectionHeight = 0.0
        default:
            sectionHeight = 20.0
            
        }
        return sectionHeight
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // Special case for the first section, since it has a differnt layout for image and name
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("PhotoCell", forIndexPath: indexPath) as! UserProfilePhotoCell
            
            if sharedData.userProfile.isValid() {
                cell.firstnameField.text = sharedData.userProfile.userFirstName
                cell.lastnameField.text = sharedData.userProfile.userLastName
                cell.profileImage.image = sharedData.userProfile.userImage
                
                cell.firstnameField.textColor = UIColor.blackColor()
                cell.lastnameField.textColor = UIColor.blackColor()
                
                if sharedData.userProfile.userNickName != "" {
                    cell.nicknameField.text = sharedData.userProfile.userNickName
                    cell.nicknameField.textColor = UIColor.blackColor()
                }
            }
            // Set instance variable used in other functionals within the class
            self.imageThumbnail = cell.profileImage
            self.firstNameTextField = cell.firstnameField
            self.lastNameTextField = cell.lastnameField
                
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("DefaultCell", forIndexPath: indexPath) as! UserProfileTableViewCell

            cell.propertyLabel.text = cellName[indexPath.section][indexPath.row]
            
            if !sharedData.userProfile.isValid() { return cell }
            
            switch indexPath.section {
            case 1:
                switch indexPath.row {
                case 0:
                    cell.propertyField.text = sharedData.userProfile.userEmail
                    cell.propertyField.keyboardType = UIKeyboardType.EmailAddress
                case 1:
                    cell.propertyField.text = sharedData.userProfile.userPhone
                    cell.propertyField.keyboardType = UIKeyboardType.NumberPad
                default:
                    cell.propertyField.text = ""
                }
            case 2:
                switch indexPath.row {
                case 0:
                    cell.propertyField.text = sharedData.userProfile.userHomeClub.simpleDescription()
                    cell.propertyField.keyboardType = UIKeyboardType.Default
                case 1:
                    cell.propertyField.text = "Seattle"
                case 2:
                    cell.propertyField.text = "WA"
                case 3:
                    cell.propertyField.text = "United States"
                default:
                    cell.propertyField.text = ""
                }
            case 3:
                switch indexPath.row {
                case 0:
                    cell.propertyField.text = "A"
                    cell.propertyField.keyboardType = UIKeyboardType.Default
                case 1:
                    cell.propertyField.text = sharedData.userProfile.userRating
                default:
                    cell.propertyField.text = ""
                }
            default:
                cell.propertyField.text = "Default"
            }
            
            return cell
        }
    }
}
