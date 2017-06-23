//
//  SwiftSharedObjectValues.swift
//  Levare
//
//  Created by Arun Prasad.S, ANGLER - EIT on 29/05/17.
//  Copyright © 2017 AngMac137. All rights reserved.
//

import Foundation


let SWIFT_HELPER = SwiftHelper.sharedObject
let SWIFT_HTTPMANNAGER = SwiftHttpManager.sharedObject
let SWIFT_NAVIGATION = Navigation.sharedObject()

let SWIFT_APPDELEGATE = UIApplication.shared.delegate as! AppDelegate
let SWIFT_STORY_BOARD = UIStoryboard(name: "Main", bundle: nil)

let OBJ_SESSION = Session2.sharedObject()
let OBJ_HELPER = Helper.sharedObject()
let OBJ_COREDATAMANAGER = CoreDataManager.sharedObject()

