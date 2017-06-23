//
//  HttpMacro.h
//
//  Copyright (c) 2015 anglereit. All rights reserved.
//

#ifndef iOSAppTemplate_HttpMacro_h
#define iOSAppTemplate_HttpMacro_h

//Local
//#define WEB_SERVICE_URL @"http://192.168.0.48/CustomerAPI/API/"

//Live
#define WEB_SERVICE_URL @"http://116.212.240.36/SuburbanAPI/API/"


#define WEATHER_WEB_URL @"http://api.openweathermap.org/data/2.5/forecast/daily"

#define MY_URL @"MY_URL"


// Request
#define kCASE @"Case"
#define kLAST_UPDATED_TIME @"last_updated_time"

// Response
#define kRESPONSE @"Response"
#define kRESPONSE_MESSAGE @"Response_Message"
#define kRESPONSE_CODE @"Response_code"

#define kSUCCESS_CODE 1
#define K_NO_DATA_CODE -1
#define k_BAD_REQUEST 0

// Case SaveCustomer TestFile
#define CASE_LOGIN @"Login/ValidateLogin"
#define CASE_LOGOUT @"Login/Logout"
#define CASE_FORGOT_PASSWORD @"Login/GetForgotPassword"
#define CASE_REGISTRATION @"Register/SaveCustomer"
#define CASE_VALDATE_MOBILE_NO @"Register/ValidateMobileNo"
#define CASE_VALDATE_OTP @"OTP/GetOTP"
#define CASE_UPDATE_PROFILE @"UpdateDealerProfileDetails"
#define CASE_NOTIFICATIONS @"GetNotification"
#define CASE_SERVICE_TYPE @"Service/GetServiceTypes"
#define CASE_GET_FAVORITE_LIST @"CustomerFavourites/GetFavourites"
#define CASE_SAVE_FAVORITE_LIST @"CustomerFavourites/SaveFavourites"
#define CASE_DELETE_FAVORITE_LIST @"CustomerFavourites/DeleteFavourites"
#define CASE_GET_FRIEND_LIST @"FamilyandFriends/GetFamilyandFriends"
#define CASE_DELETE_FRIENDS_CONATACT @"FamilyandFriends/DeleteFamilyandFriends"
#define CASE_ADD_FRIENDS_CONATACT @"FamilyandFriends/SaveFamilyandFriends"
#define CASE_GET_TRIP_HISTORY @"Trip/GetTripHistory"
#define CASE_SAVE_CARD @"Payment/SaveBankInfo"
#define CASE_DELETE_CARD @"Payment/DeleteCard"
#define CASE_CHANGE_CARD_STATUS @"Payment/UpdateCardStatus"
#define CASE_VALIDATE_PROMO_CODE @"PromoCode/ValidatePromoCode"
#define CASE_SAVE_REFERAL_CODE @"PromoCode/SaveReferralCode"
#define CASE_SEND_NOTIFICATION @"FamilyandFriends/SendNotification"
#define CASE_UPDATE_NOTIFICATION_STATUS @"FamilyandFriends/UpdateNotificationStatus"
#define CASE_PUSH_NOTIFICATION_STATUS @"Register/UpdateTripNotificationStatus"

//Param
#define K_CUSTOMER_ID @"Customer_Id"
#define K_FAVORITE_ID @"Fav_Id"
#define K_FAVORITE_LATITUDE @"Latitude"
#define K_FAVORITE_LONGITUDE @"Longitude"
#define K_FAVORITE_DISPLAY_NAME @"Display_Name"
#define K_FAVORITE_ADDRESS @"Address"
#define K_FAVORITE_PRIMARY_LOCATION @"Primary_Location"

#endif
