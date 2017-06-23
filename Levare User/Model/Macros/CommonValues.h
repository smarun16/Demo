//
//  CommonValues.h
//
//  Copyright (c) 2015 anglereit. All rights reserved.
//

#ifndef iOSAppTemplate_CommonValues_h
#define iOSAppTemplate_CommonValues_h


#define UIColorFromHEXA(hexaValue) [UIColor colorWithRed:((float)((hexaValue & 0xFF0000) >> 16))/255.0 \
green:((float)((hexaValue & 0xFF00) >> 8))/255.0   \
blue:((float)(hexaValue & 0xFF))/255.0 alpha:1.0]

#define UIColorFromHEXA_WITH_ALPHA(hexaValue) [UIColor colorWithRed:((float)((hexaValue & 0xFF0000) >> 16))/255.0 \
green:((float)((hexaValue & 0xFF00) >> 8))/255.0   \
blue:((float)(hexaValue & 0xFF))/255.0 alpha:1.0]

#define VALIDATE_WITH_DEFAULT_VALUE(value,default) (value ? ((value == [NSNull null]) ? default : value) : default)

#define SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

// App Info
#define APP_NAME @"Levare"
#define TEXT_SEPARATOR  @"^^^%%"
#define TWO_STRING(string1,string2) [NSString stringWithFormat:@"%@ %@",string1,string2]
#define WEB_SERVICE_STRING(string1,string2) [NSString stringWithFormat:@"%@%@",string1,string2]
#define INTEGER_TO_STRING(aInteger) [NSString stringWithFormat:@"%d",aInteger]

//Date And Time
#define APP_DATE_FORMAT @"MMM dd, yyyy"
#define APP_DATE_AND_TIME_FORMAT @"MMM dd, yyyy hh:mm a"
#define APP_DATE_PICKER @"MMM dd, yyyy hh:mm a"
#define BIRTHDAY_UPDATE_DATE_FORMAT @"yyyy-MM-dd HH:mm:ss Z"
#define WEB_DATE_FORMAT @"yyyy-MM-dd"
#define APP_TIME_FORMATE @"hh:mm a"
#define XML_POST_DATE_FORMATE @"dd/MM/yyyy"
#define CARD_DATE_FORMATE @"dd/MM/yyyy hh:mm:ss Z"
#define NEW_DATE_FORMAT @"dd-MMM-yyyy"
#define UPDATE_NEW_DATE_FORMAT @"MM-dd-YYYY"

//Font Name
#define FONT_MEDIUM_FONT @"Eras Medium ITC"


// Rupee Symbol
#define RUPEE_SYMBOL @"₹"

// Color Code
#define COLOR_APP_PRIMARY @"3399CC"
#define COLOR_APP_SECONDAY @"F37022"
#define COLOR_APP_RED @"FF3300"
#define COLOR_APP_LOGIN_BG @"74C11D"
#define COLOR_GROUP_TABLE_VIEW @"EFEFF4"
#define COLOR_APP_BROWN_HEADER @"B18500"
#define COLOR_APP_YELLOW @"ECC924"
#define COLOR_DEFAULT_BLUE @"0066CC"
#define COLOR_TABLE_VIEW_SEPERATOR @"CCCCCC"

#define COLOR_NAVIGATION_COLOR UIColorFromHEXA_WITH_ALPHA(0x3399CC)


// Font
#define FONT_HELVETICA_NEUE @"Helvetica Neue"

// COMMON UI COLORS
#define COLOR_CLEAR [UIColor clearColor]
#define WHITE_COLOUR [UIColor whiteColor]
#define COLOR_BLACK [UIColor blackColor]
#define LIGHT_GRAY_COLOUR [UIColor lightGrayColor]

// Messages
#define MESSAGE_NO_DATA @"No data available"
#define MESSAGE_FAILED_BLOCK @"Could not reach server"
#define ALERT_NO_INTERNET @"It seems like you are not connected to internet"

//Alert On Textfield
#define K_ALERT_PASSWORD @"Please enter password"
#define K_ALERT_FIRST_NAME @"Please enter first name"
#define K_ALERT_LAST_NAME @"Please enter last name"
#define K_ALERT_CURRENT_PASSWORD @"Please enter a current password"
#define K_ALERT_NEW_PASSWORD @"Please enter a new password"
#define K_ALERT_CONFORM_PASSWORD @"Please enter a confirm password"
#define K_ALERT_PASSWORD_LENGTH @"Password should contain atleast 6 character"
#define K_ALERT_SAME_CURRENT_PASSWORD @"Please enter a correct current password"
#define K_ALERT_PASSWORD_IS_SAME @"The new password and current password are same"
#define K_ALERT_USER_ID @"Please enter User ID"
#define K_ALERT_EMAIL @"Please enter email id"
#define K_ALERT_EMAIL_NOT_VALID @"Please enter a valid email id"
#define K_ALERT_VALIDATE_MOBILE_NO @"Please enter a valid mobile number"
#define K_ALERT_MOBILE_NO @"Please enter a mobile number"
#define MESSAGE_SOMETHING_WENT_WRONG @"It seems that there are some technical or network issue! So app may not respond properly"
#define ALERT_UNABLE_TO_FETCH_LOCATION @"Unable to fetch your location"
#define MESSAGE_TIME_OUT_BLOCK @"It sounds that this request is taking time more than expected. Sorry, the server has given up. Please try again"


// Key Values

#define K_PROFILE_IMAGE @"profile_picture"
#define K_PROFILE_DATA @"profile_data"
#define K_FIRST_NAME @"first_name"
#define K_LAST_NAME @"last_name"
#define K_MOBILE_NUMBER @"Mobile_Number"
#define K_COUNTRY_CODE @"Country_Code"
#define K_COUNTRY @"Country"
#define K_OTP @"OTP"
#define K_PASSWORD @"Password"
#define k_EMAIL @"Email_ID"
#define k_IS_ACTIVE @"is_active"

//Pop up type
#define FACEBOOK @"Facebook"
#define MAIL @"Mail"
#define WHATSAPP @"Whatsapp"
#define TWITTER @"Twitter"
#define MESSAGES @"Messages"

#define IS_CONTACT_SELECTED @"is_selected"

// Comman Screen Title

#define TITLE_SIGNUP @"CREATE AN ACCOUNT"
#define TITLE_LOGIN @"ACCOUNT SIGNIN"
#define TITLE_FORGOT_PASSWORD @"FORGOT PASSWORD"
#define TITLE_PROFILE @"YOUR PROFILE"
#define TITLE_OTP @"VERIFY ACCOUNT"
#define TITLE_SETTING @"Settings"
#define TITLE_CHANGE_PASSWORD @"Change Password"
#define TITLE_EDIT_PROFILE @"EDIT ACCOUNT"
#define TITLE_DASHBOARD @"LEVARE"
#define TITLE_FAVORITE_PLACES @"FAVORITE PLACES"
#define TITLE_HELP @"HELP & SUPPORT"
#define TITLE_REFER @"REFER FRIENDS"
#define TITLE_FAMILY_FRIENDS @"FAMILY & FRIENDS"
#define TITLE_FARE_ESTIMATE @"FARE ESTIMATE"
#define TITLE_TRIP_HISTORY @"TRIP HISTORY"
#define TITLE_MANAGE_CARD @"MANAGE CARD"
#define TITLE_SEND_NOTIFICATION @"SEND NOTIFICATION"
#define TITLE_CHAT @"CHAT"
#define TITLE_RATE_ME @"RATE ME"


#define SCREEN_TITLE_SIGNUP @"Create an Account"
#define SCREEN_TITLE_LOGIN @"Account Signin"
#define SCREEN_TITLE_FORGOT_PASSWORD @"Forgot Password"
#define SCREEN_TITLE_PROFILE @"Your Profile"
#define SCREEN_TITLE_OTP @"Verify Account"
#define SCREEN_TITLE_SETTING @"Settings"
#define SCREEN_TITLE_CHANGE_PASSWORD @"Change Password"
#define SCREEN_TITLE_EDIT_PROFILE @"Edit Account"
#define SCREEN_TITLE_DASHBOARD @"Levare"
#define SCREEN_TITLE_FAVORITE_PLACES @"Favorite Places"
#define SCREEN_TITLE_HELP @"Help & Support"
#define SCREEN_TITLE_REFER @"Refer Friends"
#define SCREEN_TITLE_FAMILY_FRIENDS @"Family & Friends"
#define SCREEN_TITLE_ADD_CONATACTS @"Add Contacts"
#define SCREEN_TITLE_FARE ESTIMATE @"Fare Estimate"
#define SCREEN_TITLE_TRIP_HISTORY @"Trip History"
#define SCREEN_TITLE_MANAGE_CARD @"Manage Card"
#define SCREEN_TITLE_ADD_CARD @"Add Card"
#define SCREEN_TITLE_SEND_NOTIFICATION @"Send Notification"
#define SCREEN_TITLE_CHAT @"Chat"
#define SCREEN_TITLE_RATE_ME @"Rate Me"

// Zoom level
#define ZOOM_LEVEL_OUTLET 5

// Trip History
#define TRIP_REQUEST 1
#define TRIP_ACCEPTED 2
#define TRIP_DRIVER_CANCEL 3
#define TRIP_USER_CANCEL 4
#define TRIP_ARRIVED 5
#define TRIP_STARTED 6
#define TRIP_COMPLETED 7


// Signal R

#define SR_FROM_LATITUDE @"StrFromlatitude"
#define SR_FROM_LONGITUDE @"StrFromlongitude"
#define SR_TO_LATITUDE @"StrTolatitude"
#define SR_TO_LONGITUDE @"StrTolongitude"
#define SR_SERVICE_TYPE_ID @"StrServicetypeId"
#define SR_USER_ID @"User_Id"
#define SR_CONNECTION_ID @"Connection_Id"
#define SR_CUSTOMER_TYPE @"C"
#define SR_CUSTOMER_TYPE_NAME @"StrUserType"
#define SR_CUSTOMER_ID @"StrCustomerId"
#define SR_DRIVER_ID @"Driver_Id"
#define SR_DRIVER_NAME @"Driver_Name"
#define SR_CAR_LOCATION_LATITUDE @"Strlatitude"
#define SR_CAR_LOCATION_LONGITUDE @"Strlongtitude"
#define SR_CAR_LOCATION_ADDRESS @"StrLocation"
#define SR_TRIP_ID @"StrTripId"
#define SR_TRIP_STATUS_ID @"Trip_Status_Id"
#define SR_CANCEL_ID @"StrCancelId"
#define SR_MESSAGE @"Message"
#define SR_USER_TYPE @"Type"


#define SR_TRIP_REQUEST 1
#define SR_TRIP_BEFORE_CANCEL 2
#define SR_TRIP_ACCEPTED 3
#define SR_TRIP_AFTER_CANCEL 4
#define SR_TRIP_ARRIVED 5
#define SR_TRIP_STARTED 6
#define SR_TRIP_COMPLETED 7

#define SR_ON_GOINIG_REQUEST 0
#define SR_RIDE_REQUEST 1
#define SR_RECEIVE_CANCEL_REQUEST 2
#define SR_RECEIVE_CHAT_MESSAGE_REQUEST 3
#define SR_CANCEL_REASON_REQUEST 4
#define SR_GET_FARE_ESTIMATION_REQUEST 5
#define SR_GET_NEAREST_VEHICLE_REQUEST 6
#define SR_CANCEL_TRIP_REQUEST 7
#define SR_OFFLINE_REQUEST 8

// Live
#define vHUB_URL @"http://116.212.240.36/DriverAPI/signalr/hubs"
// Local
//#define vHUB_URL @"http://192.168.0.48/DriverAPI/signalr/hubs"

#define vHUB_PROXY @"DriverHub"

#define vHUB_SERVER_METHOD_DETERMINE_LENGTH @"DetermineLength"
#define vHUB_SERVER_METHOD_OPEN_CONNECTION @"openConnection"
#define vHUB_SERVER_METHOD_CLOSE_CONNECTION @"GoOffline"
#define vHUB_SERVER_METHOD_MESSAGE_TRANSFER @"messageTransfer"
#define vHUB_CLIENT_METHOD @"acknowledge"
#define vHUB_ORGANIZATION_CODE @"PKM"
#define vSIGNAL_R_LOCATION_SEPARATOR @"#"


// Case
#define SR_GO_ONLINE @"GoOnline"
#define SR_GO_OFFLINE @"GoOffline"
#define SR_GET_NEAREST_VEHICLE @"GetNearestVehicles"
#define SR_GET_ON_GOING_REQUEST @"GetOnGoingRequest"
#define SR_GET_FARE_ESTIMATION @"GetFareEstimation"
#define SR_SEND_CHAT_MESSAGE @"SendMessage"
#define SR_REQUEST_RIDE @"RequestRide"
#define SR_GET_CANCEL_REASON @"GetTripCancellationReason"
#define SR_CANCEL_TRIP @"CancelTrip"
#define SR_UPDATE_RATING @"UpdateUserRating"
#define SR_GET_ALL_CHAT_MESSAGE @"GetChatMessage"


// Notification center

#define NOTIFICATION_VIEW_UPADTE_BASED_ON_MY_QUERY_STATUS @"UpdateViewForMyQueryStatusChange"
#define NOTIFICATION_MY_QUERY_STATUS_KEY @"MyQueryStatusChange"

#define NOTIFICATION_VIEW_UPADTE_BASED_ON_CHAT_STATUS @"UpdateViewForCHATStatusChange"
#define NOTIFICATION_CHAT_STATUS_KEY @"CHATStatusChange"

#define NOTIFICATION_VIEW_UPADTE_BASED_ON_REQUEST_STATUS @"UpdateViewForREQUESTStatusChange"
#define NOTIFICATION_REQUEST_STATUS_KEY @"REQUESTStatusChange"

#define VIEW_UPADTE_BASED_ON_REQUEST_STATUS @"ViewForREQUESTStatusChange"
#define REQUEST_STATUS_KEY @"ViewStatusChange"

#define VIEW_UPADTE_BASED_ON_FAV_STATUS @"ViewForfavStatusChange"
#define VIEW_UPADTE_BASED_ON_FAV_STATUS_KEY @"ViewFavStatusChange"

#define NOTIFICATION_VIEW_UPADTE_FOR_REQUEST_TIMER @"UpdateViewForRequesttimer"
#define NOTIFICATION_FOR_REQUEST_TIMER_KEY @"UpdateViewForRequestTimerKey"

#define NOTIFICATION_VIEW_UPADTE_BASED_ON_REQUEST_STATUS_FROM_BACKGROUND @"UpdateViewForREQUESTStatusChange_FROM_BACKGROUND"
#define NOTIFICATION_REQUEST_STATUS_KEY_FROM_BACKGROUND @"REQUESTStatusChange_FROM_BACKGROUND"

#define NOTIFICATION_VIEW_UPADTE_FAV_DELETED  @"FavouritesDeleted"

#endif
