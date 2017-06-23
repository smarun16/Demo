//
//  KeyValues.h
//
//  Copyright (c) 2015 anglereit. All rights reserved.
//

#ifndef iOSAppTemplate_KeyValues_h
#define iOSAppTemplate_KeyValues_h

#define CAST_OBJECT(fromObject,toObject) ((toObject*)fromObject)
#define KEY_DATE_TIME_FORMAT_NORMAL @"yyyy-MM-dd hh:mm a"
#define KEY_DATE_TIME_FORMAT_RAILWAY @"yyyy-MM-dd HH:mm:ss"

#define DEGREES_TO_RADIANS(angle) (angle / 180.0 * M_PI)

#define KEY_IMAGE @"image"
#define KEY_TEXT @"text"
#define KEY_TITLE @"title"
#define KEY_URL @"image_url"
#define KEY_SCREEN @"screen"
#define KEY_VIEWCONTROLLER @"viewController"

#define BACK @"Back"
#define CANCEL @"Cancel"
#define NEXT @"Next"
#define SAVE @"Save"
#define EDIT @"Edit"

#define HOME @"HOME"
#define OFFICE @"OFFICE"
#define ADD_HOME @"Add Home"
#define ADD_OFFICE @"Add Office"

#define kCountryName        @"name"
#define kCountryCallingCode @"dial_code"
#define kCountryCode        @"code"
#define kCountryflag        @"flag"
#define kFLAG_SIZE @"35"

//Mode
#define GET_DETAIL @"1"
#define UPDATE_MODE @"2"
#define KEYBOARD_TYPE @"keybord Type"
#define RETURN_KEY_TYPE @"returnKeyType"

#define KEY_FORMAT_DIGIT @"(^(?:|0|[1-9]\\d*)(?:\\.\\d*)?$)"
#define KEY_FORMAT_PHONE @"(^(\\+)?(\\d|\\s|\\(|\\))*$)"


#define KEY_WEATHER_API_KEY @"dad687f608300c8042733a8276c35d77"


// email id - angleria16@gmail.com,
// Pwd - angler@16,
// Project - Coromandel Map - Levare Api key

//#define KEY_GOOGLE_MAP_API_KEY @"AIzaSyAWUXcWxvpKyYQBnMOBMjB7rWYppONP14E"

// key is given by client
#define KEY_GOOGLE_MAP_API_KEY @"AIzaSyCzamUbXfmgwDtopQOttJxePXy6Yqvmmbg"

//Key Test Fary
#define KEY_TEST_FARY @"f80a5ff06e400f8bba51c014d505abbcd6bbd2df"

// ALERT
#define KEY_ALERT_TITLE @"Alert Title"
#define KEY_ALERT_DESC @"Alert Desc"
#define KEY_ALERT_IMAGE @"Alert Image"
#define KEY_ALERT_HEADER @"Alert Header"
#define KEY_ALERT_TITLE_COLOR @"Alert Color"



#define ALERT_RETRY_TITLE @"Tap to retry"
#define ALERT_NO_INTERNET_DESC @"Oops!! Itseems like you are not connected to internet"
#define ALERT_NO_INTERNET_IMAGE @"icon_no_internet"
#define ALERT_UNABLE_TO_REACH_DESC @"We've seem to have gotten a little confused and can't find the page you were looking for"
#define ALERT_UNABLE_TO_REACH_IMAGE @"icon_unable_reach_server"
#define ALERT_TAP_HERE @"Tap here "
#define ALERT_UNABLE_TO_FETCH_LOCATION @"Unable to fetch your location"
#define ALERT_NO_DATA_DESC @"No Trips Found"
#define ALERT_NO_SERVICE_DESC @"No Service Found"

//Image
#define ALERT_UNABLE_TO_REACH_IMAGE @"icon_unable_reach_server"


#define ALERT_NO_INTERNET_DICT @{KEY_ALERT_TITLE:ALERT_RETRY_TITLE,KEY_ALERT_DESC:ALERT_NO_INTERNET_DESC,KEY_ALERT_IMAGE:ALERT_NO_INTERNET_IMAGE}

#define ALERT_UNABLE_TO_REACH_DICT @{KEY_ALERT_TITLE:ALERT_RETRY_TITLE,KEY_ALERT_DESC:ALERT_UNABLE_TO_REACH_DESC,KEY_ALERT_IMAGE:ALERT_UNABLE_TO_REACH_IMAGE}
#define ALERT_SIGNALR_UNABLE_TO_REACH_DICT @{KEY_ALERT_TITLE:ALERT_RETRY_TITLE,KEY_ALERT_DESC:MESSAGE_TIME_OUT_BLOCK,KEY_ALERT_IMAGE:ALERT_UNABLE_TO_REACH_IMAGE}


#define ALERT_UNABLE_TO_FETCH_LOCATION_DICT @{KEY_ALERT_TITLE:ALERT_RETRY_TITLE,KEY_ALERT_DESC:ALERT_UNABLE_TO_FETCH_LOCATION,KEY_ALERT_IMAGE:IMAGE_UNABLE_TO_REACH}

#define ALERT_NO_DATA_DICT @{KEY_ALERT_TITLE:APP_NAME,KEY_ALERT_DESC:ALERT_NO_DATA_DESC,KEY_ALERT_IMAGE:@"icon_alert"}
#define ALERT_NO_SERVICE_DICT @{KEY_ALERT_TITLE:APP_NAME,KEY_ALERT_DESC:ALERT_NO_SERVICE_DESC,KEY_ALERT_IMAGE:@"icon_alert"}

#endif
