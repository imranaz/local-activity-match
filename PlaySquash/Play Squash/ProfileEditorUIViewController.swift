//
//  ProfileEditorUIViewController.swift
//  Play Squash
//
//  Created by Imran Aziz on 12/7/15.
//  Copyright © 2015 Maikya. All rights reserved.
//

import UIKit

class ProfileEditorUIViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBOutlet weak var imageThumbnail: UIImageView!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var nickNameTextField: UITextField!
    @IBOutlet weak var mobilePhoneTextField: UITextField!
    @IBOutlet weak var homeClubTextField: UITextField!
    @IBOutlet weak var ratingTextField: UITextField!
    @IBOutlet weak var squashIDTextField: UITextField!
   
    
    let imagePicker = UIImagePickerController()
    let sharedData = AppShareData.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ProfileEditorUIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        // load data from app directory if user had saved it prior
        sharedData.loadPlayerProfileInformation();
        
        imagePicker.delegate = self
        if sharedData.validProfile == "true" {
            imageThumbnail.image = sharedData.playerProfileImage
            firstNameTextField.text = self.sharedData.playerFirstName
            lastNameTextField.text = self.sharedData.playerLastName
            mobilePhoneTextField.text = self.sharedData.playerPhone
            ratingTextField.text = self.sharedData.playerRating
            homeClubTextField.text = self.sharedData.playerHomeClub
            squashIDTextField.text = self.sharedData.playerSquashID
        }
        
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        mobilePhoneTextField.delegate = self
        nickNameTextField.delegate = self
        mobilePhoneTextField.delegate = self
        homeClubTextField.delegate = self
        ratingTextField.delegate = self
        squashIDTextField.delegate = self
        
        checkValidFormFields()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    @IBAction func cancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if saveButton === sender {
            self.sharedData.playerProfileImage = imageThumbnail.image
            self.sharedData.playerFirstName = firstNameTextField.text
            self.sharedData.playerLastName = lastNameTextField.text
            self.sharedData.playerPhone = mobilePhoneTextField.text
            self.sharedData.playerRating = ratingTextField.text
            self.sharedData.playerHomeClub = homeClubTextField.text
            sharedData.validProfile = "true"
            sharedData.persistPlayerProfileInformation();
        }
    }

    // Form validation logic

    func textFieldDidBeginEditing(textField: UITextField) {
        // Disable the Save button while editing.
        saveButton.enabled = false
        if ((textField == homeClubTextField) || (textField == ratingTextField) || (textField == squashIDTextField)) {
            animateViewMoving(true, moveValue: 100)
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        checkValidFormFields()
        if ((textField == homeClubTextField) || (textField == ratingTextField) || (textField == squashIDTextField)) {
            animateViewMoving(false, moveValue: 100)
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }

    func animateViewMoving (up:Bool, moveValue :CGFloat){
        let movementDuration:NSTimeInterval = 0.3
        let movement:CGFloat = ( up ? -moveValue : moveValue)
        UIView.beginAnimations( "animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration )
        self.view.frame = CGRectOffset(self.view.frame, 0,  movement)
        UIView.commitAnimations()
    }
    
    func checkValidFormFields() {
        // Disable the Save button if manditory name fields are empty.
        let firstName = firstNameTextField.text ?? ""
        let lastName = lastNameTextField.text ?? ""
        let mobilePhone = mobilePhoneTextField.text ?? ""
        let homeClub = homeClubTextField.text ?? ""
        let rating = ratingTextField.text ?? ""
        saveButton.enabled = !(firstName.isEmpty && lastName.isEmpty && mobilePhone.isEmpty && homeClub.isEmpty && rating.isEmpty)
    }
    
    // Format a phone number text field
    // Credit: http://stackoverflow.com/questions/1246439/uitextfield-for-phone-number
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if textField == mobilePhoneTextField {
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
    
    @IBAction func pickUserImage(sender: AnyObject) {
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .PhotoLibrary
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    // MARK: - UIImagePickerControllerDelegate Methods
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!) {
        let selectedImage : UIImage = image
        //var tempImage:UIImage = editingInfo[UIImagePickerControllerOriginalImage] as UIImage
        imageThumbnail.image = selectedImage
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
}
