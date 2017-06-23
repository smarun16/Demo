//
//  SwiftCommanValues.swift
//  Levare Associate
//
//  Created by Arun Prasad.S, ANGLER - EIT on 11/05/17.
//  Copyright © 2017 AngMac137. All rights reserved.
//

import Foundation


// Response
let kRESPONSE = "Response"
let kRESPONSE_MESSAGE = "Response_Message"
let kRESPONSE_CODE = "Response_code"

let kSUCCESS_CODE = 1
let K_NO_DATA_CODE = -1
let k_BAD_REQUEST = 0

// App Info
let APP_NAME = "Levare User"
let TEXT_SEPARATOR = "^^^%%"

// Font
let FONT_HELVETICA_NEUE = "Helvetica Neue"

//Date And Time

let APP_DATE_FORMAT  = "MMM dd, yyyy"
let APP_DATE_AND_TIME_FORMAT  = "MMM dd, yyyy hh:mm a"
let APP_DATE_PICKER  = "MMM dd, yyyy hh:mm a"
let BIRTHDAY_UPDATE_DATE_FORMAT  = "yyyy-MM-dd HH:mm:ss Z"
let WEB_DATE_FORMAT  = "yyyy-MM-dd"
let APP_TIME_FORMATE  = "hh:mm a"
let XML_POST_DATE_FORMATE  = "dd/MM/YYYY"
let NEW_DATE_FORMAT  = "dd-MMM-yyyy"
let UPDATE_NEW_DATE_FORMAT  = "MM-dd-YYYY"
let REF_DATE_FORMAT  = "dd MMM yyyy"

let DEFAULT_LATITUDE = -35.280636
let DEFAULT_LONGITUDE =  149.131696

// Rupee Symbol

let RUPEE_SYMBOL  = "₹"

// Color Code

let COLOR_APP_PRIMARY  = "3399CC"
let COLOR_APP_SECONDAY  = "F37022"
let COLOR_APP_RED  = "FF3300"
let COLOR_APP_GREEN  = "58A92F"
let COLOR_APP_LOGIN_BG  = "74C11D"
let COLOR_GROUP_TABLE_VIEW  = "EFEFF4"
let COLOR_APP_BROWN_HEADER  = "B18500"
let COLOR_APP_YELLOW  = "ECC924"
let COLOR_DEFAULT_BLUE  = "0066CC"
let COLOR_TABLE_VIEW_SEPERATOR  = "CCCCCC"
let COLOR_GRAY_COLOR  = "B8B8B8"
let COLOR_APP_GOLD = "FFD700"


// Messages

let MESSAGE_NO_DATA  = "No data available"
let MESSAGE_FAILED_BLOCK  = "Could not reach server"
let ALERT_NO_INTERNET  = "It seems like you are not connected to internet"

//Alert On Textfield

let MESSAGE_SOMETHING_WENT_WRONG  = "It seems that there are some technical or network issue! So app may not respond properly"
let ALERT_UNABLE_TO_FETCH_LOCATION  = "Unable to fetch your location"
let MESSAGE_TIME_OUT_BLOCK  = "It sounds that this request is taking time more than expected. Sorry, the server has given up. Please try again"
let k_ALERT_GO_OFLINE  = "Are you sure to go offline"


// Screen Title

let SCREEN_TITLE_DASHBOARD  = "Levare"
let SCREEN_TITLE_CHAT  = "Chat"
let SCREEN_TITLE_RATE_ME  = "Rate Me"


// Trip History

let TRIP_REQUEST  = 1
let TRIP_ACCEPTED = 2
let TRIP_DRIVER_CANCEL = 3
let TRIP_USER_CANCEL = 4
let TRIP_ARRIVED = 5
let TRIP_STARTED = 6
let TRIP_COMPLETED = 7


// Zoom level

let ZOOM_LEVEL_OUTLET = 5

// Signal R

let SR_FROM_LATITUDE  = "StrFromlatitude"
let SR_FROM_LONGITUDE  = "StrFromlongitude"
let SR_TO_LATITUDE  = "StrTolatitude"
let SR_TO_LONGITUDE  = "StrTolongitude"
let SR_SERVICE_TYPE_ID  = "StrServicetypeId"
let SR_USER_ID  = "User_Id"
let SR_CONNECTION_ID  = "Connection_Id"
let SR_CUSTOMER_TYPE  = "C"
let SR_CUSTOMER_TYPE_NAME  = "StrUserType"
let SR_CUSTOMER_ID  = "StrCustomerId"
let SR_DRIVER_ID  = "Driver_Id"
let SR_DRIVER_NAME  = "Driver_Name"
let SR_CAR_LOCATION_LATITUDE  = "Strlatitude"
let SR_CAR_LOCATION_LONGITUDE  = "Strlongtitude"
let SR_CAR_LOCATION_ADDRESS  = "StrLocation"
let SR_TRIP_ID  = "StrTripId"
let SR_TRIP_STATUS_ID  = "Trip_Status_Id"
let SR_CANCEL_ID  = "StrCancelId"
let SR_MESSAGE  = "Message"
let SR_USER_TYPE  = "Type"

let SR_TRIP_REQUEST = 1
let SR_TRIP_BEFORE_CANCEL = 2
let SR_TRIP_ACCEPTED  = 3
let SR_TRIP_AFTER_CANCEL = 4
let SR_TRIP_ARRIVED = 5
let SR_TRIP_STARTED = 6
let SR_TRIP_COMPLETED = 7

let SR_ON_GOINIG_REQUEST = 0
let SR_RIDE_REQUEST = 1
let SR_RECEIVE_CANCEL_REQUEST = 2
let SR_RECEIVE_CHAT_MESSAGE_REQUEST = 3
let SR_CANCEL_REASON_REQUEST = 4
let SR_GET_FARE_ESTIMATION_REQUEST = 5
let SR_GET_NEAREST_VEHICLE_REQUEST = 6
let SR_CANCEL_TRIP_REQUEST = 7
let SR_OFFLINE_REQUEST = 8

//Param
let K_CUSTOMER_ID = "Customer_Id"
let K_FAVORITE_ID = "Fav_Id"
let K_FAVORITE_LATITUDE = "Latitude"
let K_FAVORITE_LONGITUDE = "Longitude"
let K_FAVORITE_DISPLAY_NAME = "Display_Name"
let K_FAVORITE_ADDRESS = "Address"
let K_FAVORITE_PRIMARY_LOCATION = "Primary_Location"
// Live
let vHUB_URL  = "http://116.212.240.36/DriverAPI/signalr/hubs"
// Local
//let vHUB_URL  = "http://192.168.0.48/DriverAPI/signalr/hubs"

let vHUB_PROXY  = "DriverHub"

let vHUB_SERVER_METHOD_DETERMINE_LENGTH  = "DetermineLength"
let vHUB_SERVER_METHOD_OPEN_CONNECTION  = "openConnection"
let vHUB_SERVER_METHOD_CLOSE_CONNECTION  = "GoOffline"
let vHUB_SERVER_METHOD_MESSAGE_TRANSFER  = "messageTransfer"
let vHUB_CLIENT_METHOD  = "acknowledge"
let vHUB_ORGANIZATION_CODE  = "PKM"
let vSIGNAL_R_LOCATION_SEPARATOR  = "#"


// Case
let SR_GO_ONLINE  = "GoOnline"
let SR_GO_OFFLINE  = "GoOffline"
let SR_GET_NEAREST_VEHICLE  = "GetNearestVehicles"
let SR_GET_ON_GOING_REQUEST  = "GetOnGoingRequest"
let SR_GET_FARE_ESTIMATION  = "GetFareEstimation"
let SR_SEND_CHAT_MESSAGE  = "SendMessage"
let SR_REQUEST_RIDE  = "RequestRide"
let SR_GET_CANCEL_REASON  = "GetTripCancellationReason"
let SR_CANCEL_TRIP  = "CancelTrip"
let SR_UPDATE_RATING  = "UpdateUserRating"
let SR_GET_ALL_CHAT_MESSAGE  = "GetChatMessage"


// Notification center

let NOTIFICATION_VIEW_UPADTE_BASED_ON_MY_QUERY_STATUS  = "UpdateViewForMyQueryStatusChange"
let NOTIFICATION_MY_QUERY_STATUS_KEY  = "MyQueryStatusChange"

let NOTIFICATION_VIEW_UPADTE_BASED_ON_CHAT_STATUS  = "UpdateViewForCHATStatusChange"
let NOTIFICATION_CHAT_STATUS_KEY  = "CHATStatusChange"

let NOTIFICATION_VIEW_UPADTE_BASED_ON_REQUEST_STATUS  = "UpdateViewForREQUESTStatusChange"
let NOTIFICATION_REQUEST_STATUS_KEY  = "REQUESTStatusChange"

let VIEW_UPADTE_BASED_ON_REQUEST_STATUS  = "ViewForREQUESTStatusChange"
let REQUEST_STATUS_KEY  = "ViewStatusChange"

let VIEW_UPADTE_BASED_ON_FAV_STATUS  = "ViewForfavStatusChange"
let VIEW_UPADTE_BASED_ON_FAV_STATUS_KEY  = "ViewFavStatusChange"

let NOTIFICATION_VIEW_UPADTE_FOR_REQUEST_TIMER  = "UpdateViewForRequesttimer"
let NOTIFICATION_FOR_REQUEST_TIMER_KEY  = "UpdateViewForRequestTimerKey"

let NOTIFICATION_VIEW_UPADTE_BASED_ON_REQUEST_STATUS_FROM_BACKGROUND  = "UpdateViewForREQUESTStatusChange_FROM_BACKGROUND"
let NOTIFICATION_REQUEST_STATUS_KEY_FROM_BACKGROUND  = "REQUESTStatusChange_FROM_BACKGROUND"

let NOTIFICATION_VIEW_RIDE_ACCEPTED  = "RideAccepted"
let NOTIFICATION_VIEW_RIDE_REJECTED  = "RideRejected"


//Local
//let SWIFT_WEB_SERVICE_URL = "http://192.168.0.48/CustomerAPI/API/"

//Live
let SWIFT_WEB_SERVICE_URL  = "http://116.212.240.36/SuburbanAPI/API/"
let CASE_DELETE_FAVORITE_LIST = "CustomerFavourites/DeleteFavourites"


// Methods

func TWO_STRING(string1:String, string2: String) -> String {
    
    let newString = "\(string1)\(" ")\(string2)"
    return newString
}

func SWIFT_WEB_SERVICE_STRING(string1:String, string2: String) -> String {
    
    let newString = "\(string1)\(string2)"
    return newString
}


/*func INTEGER_TO_STRING(aInteger: Integer) -> String {
    
    var newString = String(aInteger)
}*/
