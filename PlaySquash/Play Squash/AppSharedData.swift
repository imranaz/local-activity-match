//
//  AppSharedData.swift
//  Play Squash
//
//  Created by Imran Aziz on 12/9/15.
//  Copyright © 2015 Maikya. All rights reserved.
//

import Foundation
import UIKit

//Shared data singleton class that is used within the application
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