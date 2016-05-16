//
//  CustomNavController.swift
//  Play Squash
//
//  Created by Imran Aziz on 5/10/16.
//  Copyright © 2016 Maikya. All rights reserved.
//

import UIKit

class CustomNavController: UINavigationController {

    var progressView : UIProgressView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Set the nav bar color scheme
        let navBar = self.navigationBar
        
        navBar.barStyle = UIBarStyle.Default
        navBar.backgroundColor = UIColor.orangeColor()
        
        // Create Progress View Control
        progressView = UIProgressView(progressViewStyle: UIProgressViewStyle.Bar)
        progressView?.backgroundColor = UIColor.lightGrayColor()
        progressView?.tintColor = UIColor.orangeColor()
        
        let navBarHeight = navBar.frame.height
        let progressFrame = self.progressView?.frame
        let pSetX = progressFrame!.origin.x
        let pSetY = CGFloat(navBarHeight)
        let pSetWidth = self.view.frame.width
        let pSetHight = progressFrame!.height
        
        progressView!.frame = CGRectMake(pSetX, pSetY, pSetWidth, pSetHight)
        self.navigationBar.addSubview(progressView!)
        progressView!.setProgress(0.0, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
