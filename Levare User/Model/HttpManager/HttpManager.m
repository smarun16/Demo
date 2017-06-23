//
//  RTCHttpManager.m
//  Social Networking
//
//  Created by Bedrocket on 10/10/14.
//  Copyright (c) 2014 ANGLER EIT. All rights reserved.
//

#import "HttpManager.h"
#import <AFNetworking/AFNetworking.h>
#import "AFNetworkActivityIndicatorManager.h"

//#define NSLog(...)

@implementation HttpManager

+ (HttpManager *)sharedObject {
    
    static id sharedObject = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedObject = [[self alloc] init];
        [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
        myURLSessionTaskMutableArray = [NSMutableArray new];
    });
    
    return sharedObject;
}

- (instancetype)init {
    
    self = [super init];
    if (self) {
        
       // self.requestSerializer = [AFJSONRequestSerializer serializer];
      //  self.responseSerializer = [AFJSONResponseSerializer serializer];
        self.responseSerializer.acceptableContentTypes = [self.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
        
    }
    
    return self;
}

- (BOOL)isNetworkRechable {
    
    if ([AFNetworkReachabilityManager sharedManager].reachable) {
        
        if ([AFNetworkReachabilityManager sharedManager].isReachableViaWiFi)
            NSLog(@"Network Reachable Via WWAN *****");
        else
            NSLog(@"Network Reachable Via WiFi *****");
        
        return YES;
    }
    else {
        
        if ([AFNetworkReachabilityManager sharedManager].reachable) {
            
            if ([AFNetworkReachabilityManager sharedManager].isReachableViaWiFi)
                NSLog(@"Network Reachable Via WWAN *****");
            else
                NSLog(@"Network Reachable Via WiFi *****");
            
            return YES;
        }
        NSLog(@"Network Not Reachable *****");
        return NO;
    }
}

#pragma mark - Project Oriented Methods for SOAP -

#pragma mark - Login
// http://192.168.0.48/PPTCustomer/API/Login/ValidateLogin?StrJson={"Login_Info": {"User_Name": "sivakumar.r@angleritech.com","Password": "Siva","Gcm_Reg_Id": "dfgdfgdfg","IMEI_No": "fgfgfg","Device_Type": "A",   "Version_Number": "1.0.0"}}

- (NSURLSessionDataTask *)getLoginDetails:(NSMutableDictionary *)parameters completedBlock :(void (^)(NSDictionary* response))completionBlock failedBlock:(void (^)(NSError *error))failedBlock {
    
    NSLog(@"parameters ==> %@", parameters);
    
    NSURLSessionDataTask *aTask = [HTTPMANAGER GET:WEB_SERVICE_STRING(WEB_SERVICE_URL, CASE_LOGIN) parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *responseDict = responseObject;
        [self sendErrorResponseToTestFairy:CASE_LOGIN parameter:parameters response:responseDict];
        
        completionBlock(responseDict);
        [self removeURLSessionTask:task];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self sendErrorToTestFairy:CASE_LOGIN parameter:parameters response:error];

        failedBlock(error);
        [self removeURLSessionTask:task];
    }];
    
    [self addURLSessionTask:aTask];
    return aTask;
}

#pragma mark - Registration

//   http://192.168.0.4StrJson = "{\n  \"Registration_Info\" : {\n    \"Mobile_Number\" : \"+919043743243\",\n    \"Customer_Id\" : \"\",\n    \"Email_ID\" : \"arun@gmail.com\"\n  }\n}"8/PPTCustomer/API/Register/ValidateMobileNo?StrJson={"Registration_Info":{"Mobile_Number":"%2B919677892277","Email_Id":"sivakuma@angleritech.com"," Customer_Id ":""}}

- (NSURLSessionDataTask *)getRegisterDetails:(NSMutableDictionary *)parameters completedBlock :(void (^)(NSDictionary* response))completionBlock failedBlock:(void (^)(NSError *error))failedBlock {
    
    NSLog(@"parameters ==> %@", parameters);
    
    NSURLSessionDataTask *aTask = [HTTPMANAGER GET:WEB_SERVICE_STRING(WEB_SERVICE_URL, CASE_VALDATE_MOBILE_NO) parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *responseDict = responseObject;
        [self sendErrorResponseToTestFairy:CASE_VALDATE_MOBILE_NO parameter:parameters response:responseDict];

        completionBlock(responseDict);
        [self removeURLSessionTask:task];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self sendErrorToTestFairy:CASE_VALDATE_MOBILE_NO parameter:parameters response:error];

        failedBlock(error);
        [self removeURLSessionTask:task];
    }];
    
    [self addURLSessionTask:aTask];
    return aTask;
}

#pragma mark - OTP

// http://192.168.0.48/PPTCustomer/API/OTP/GetOTP?StrPhoneNumber=%2B919677892275&StrCountryCode=+91

- (NSURLSessionDataTask *)getOTP:(NSMutableDictionary *)parameters completedBlock :(void (^)(NSDictionary* response))completionBlock failedBlock:(void (^)(NSError *error))failedBlock {
    
    NSLog(@"parameters ==> %@", parameters);
    
    NSURLSessionDataTask *aTask = [HTTPMANAGER GET:WEB_SERVICE_STRING(WEB_SERVICE_URL, CASE_VALDATE_OTP) parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *responseDict = responseObject;
        [self sendErrorResponseToTestFairy:CASE_VALDATE_OTP parameter:parameters response:responseDict];

        completionBlock(responseDict);
        [self removeURLSessionTask:task];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self sendErrorToTestFairy:CASE_VALDATE_OTP parameter:parameters response:error];

        failedBlock(error);
        [self removeURLSessionTask:task];
    }];
    
    [self addURLSessionTask:aTask];
    return aTask;
}

#pragma mark - Get Customer Details

//   http://192.168.0.48/PPTCustomer/API/Register/SaveCustomer?StrJson={"Registration_Info":                    {"Mobile_Number":"+919677892277","Email_ID":"arun@gmail.com","First_Name":"Sivakumar","Last_Name":"R","OTP":"1232","Customer_Id":"11" ,"Password":"Siva","Gcm_Reg_Id":"Addfh5765fsdfjaklf","IMEI_No":"ABR144DDSS","Device_Type":"A", "Version_Number":"1.0.0"}}

- (NSURLSessionDataTask *)getCustomerDetails:(NSMutableDictionary *)parameters path:(NSData *)aImageData imageName:(NSString *)aImageName completedBlock :(void (^)(NSDictionary* response))completionBlock failedBlock:(void (^)(NSError *error))failedBlock {
    
    //parameters = [NSMutableDictionary new];
    NSLog(@"parameters ==> %@", parameters);
    
    NSURLSessionDataTask *aTask = [HTTPMANAGER POST:WEB_SERVICE_STRING(WEB_SERVICE_URL, CASE_REGISTRATION) parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSString *aMineType;
        
        if ([aImageName containsString:@"JPEG"])
            aMineType = @"image/jpeg";
        else
            aMineType = @"image/png";
        
        if (aImageData)
            [formData appendPartWithFileData:aImageData name:@"file_name" fileName:aImageName mimeType:aMineType];
        
    }  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *responseDict = responseObject;
        [self sendErrorResponseToTestFairy:CASE_REGISTRATION parameter:parameters response:responseDict];

        completionBlock(responseDict);
        [self removeURLSessionTask:task];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self sendErrorToTestFairy:CASE_REGISTRATION parameter:parameters response:error];

        failedBlock(error);
        [self removeURLSessionTask:task];
    }];
    
    [self addURLSessionTask:aTask];
    return aTask;
}
#pragma mark - Forgotpassword

// http://192.168.0.48/PPTCustomer/API/Login/GetForgotPassword?StrEmailId:arun@gmail.com

- (NSURLSessionDataTask *)getForgotpassword:(NSMutableDictionary *)parameters completedBlock :(void (^)(NSDictionary* response))completionBlock failedBlock:(void (^)(NSError *error))failedBlock {
    
    NSLog(@"parameters ==> %@", parameters);
    
    NSURLSessionDataTask *aTask = [HTTPMANAGER GET:WEB_SERVICE_STRING(WEB_SERVICE_URL, CASE_FORGOT_PASSWORD) parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *responseDict = responseObject;
        [self sendErrorResponseToTestFairy:CASE_FORGOT_PASSWORD parameter:parameters response:responseDict];

        completionBlock(responseDict);
        [self removeURLSessionTask:task];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self sendErrorToTestFairy:CASE_FORGOT_PASSWORD parameter:parameters response:error];

        failedBlock(error);
        [self removeURLSessionTask:task];
    }];
    
    [self addURLSessionTask:aTask];
    return aTask;
}

#pragma mark - Service Types


// http://192.168.0.48/PPTCustomer/API/Service/GetServiceTypes

- (NSURLSessionDataTask *)getServiceTypeWithcompletedBlock :(void (^)(NSDictionary* response))completionBlock failedBlock:(void (^)(NSError *error))failedBlock {
    
    
    NSURLSessionDataTask *aTask = [HTTPMANAGER GET:WEB_SERVICE_STRING(WEB_SERVICE_URL, CASE_SERVICE_TYPE) parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *responseDict = responseObject;
        NSMutableArray *aMutableArray = [responseDict  valueForKey:@"Service_Types"];
        
        if (aMutableArray .count) {
            
            [COREDATAMANAGER deleteAllEntities:TABEL_SERVICE_TYPE];
            
            for (int i = 0; i <= aMutableArray.count + 1; i++) {
                
                NSMutableDictionary *aDictionary = [NSMutableDictionary new];
                
                if (i == 0 || i == aMutableArray.count + 1) {
                    
                    aDictionary[@"ServiceType_Id"] = @"";
                    aDictionary[@"ServiceType_Name"] = @"";
                    aDictionary[@"ServiceType_Icon"] = @"";
                    aDictionary[@"Vehicle_Max_Range"] = @"";
                    
                    [COREDATAMANAGER addServiceListInfo:[aDictionary copy]];
                }
                else {
                    
                    aDictionary[@"ServiceType_Id"] = aMutableArray[i - 1][@"ServiceType_Id"];
                    aDictionary[@"ServiceType_Name"] = aMutableArray[i - 1][@"ServiceType_Name"];
                    aDictionary[@"ServiceType_Icon"] = aMutableArray[i - 1][@"ServiceType_Icon"];
                    aDictionary[@"Vehicle_Max_Range"] = aMutableArray[i - 1][@"Vehicle_Max_Range"];
                    
                    [COREDATAMANAGER addServiceListInfo:[aDictionary copy]];
                }
            }
            
        }
        
        [self sendErrorResponseToTestFairy:CASE_SERVICE_TYPE parameter:nil response:responseDict];

        completionBlock(responseDict);
        [self removeURLSessionTask:task];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self sendErrorToTestFairy:CASE_SERVICE_TYPE parameter:nil response:error];

        failedBlock(error);
        [self removeURLSessionTask:task];
    }];
    
    [self addURLSessionTask:aTask];
    return aTask;
}

#pragma mark - get Trip History

- (NSURLSessionDataTask *)getTripHistory:(NSMutableDictionary *)aParameter completedBlock :(void (^)(NSDictionary* response))completionBlock failedBlock:(void (^)(NSError *error))failedBlock {
    
    
    NSURLSessionDataTask *aTask = [HTTPMANAGER GET:WEB_SERVICE_STRING(WEB_SERVICE_URL, CASE_GET_TRIP_HISTORY) parameters:aParameter success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *responseDict = responseObject;
        [self sendErrorResponseToTestFairy:CASE_GET_TRIP_HISTORY parameter:aParameter response:responseDict];

        completionBlock(responseDict);
        [self removeURLSessionTask:task];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self sendErrorToTestFairy:CASE_GET_TRIP_HISTORY parameter:aParameter response:error];

        failedBlock(error);
        [self removeURLSessionTask:task];
    }];
    
    [self addURLSessionTask:aTask];
    return aTask;
}

#pragma mark - Save Card

// http://192.168.0.65:66/API/Payment/SaveBankInfo?StrJson={"Card_Info":{"Credit_Card_Number":"4655646546465465","Customer_Id":"1113","CVN":"142","Expiry_Date":"2017-0-6"}}

- (NSURLSessionDataTask *)saveCardDetails:(NSMutableDictionary *)aParameter completedBlock :(void (^)(NSDictionary* response))completionBlock failedBlock:(void (^)(NSError *error))failedBlock {
    
    
    NSURLSessionDataTask *aTask = [HTTPMANAGER GET:WEB_SERVICE_STRING(WEB_SERVICE_URL, CASE_SAVE_CARD) parameters:aParameter success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *responseDict = responseObject;
        [self sendErrorResponseToTestFairy:CASE_SAVE_CARD parameter:aParameter response:responseDict];

        completionBlock(responseDict);
        [self removeURLSessionTask:task];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self sendErrorToTestFairy:CASE_SAVE_CARD parameter:aParameter response:error];

        failedBlock(error);
        [self removeURLSessionTask:task];
    }];
    
    [self addURLSessionTask:aTask];
    return aTask;
}

#pragma mark - Delete Card

- (NSURLSessionDataTask *)deleteCardDetails:(NSMutableDictionary *)aParameter completedBlock :(void (^)(NSDictionary* response))completionBlock failedBlock:(void (^)(NSError *error))failedBlock {
    
    
    NSURLSessionDataTask *aTask = [HTTPMANAGER GET:WEB_SERVICE_STRING(WEB_SERVICE_URL, CASE_DELETE_CARD) parameters:aParameter success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *responseDict = responseObject;
        [self sendErrorResponseToTestFairy:CASE_DELETE_CARD parameter:aParameter response:responseDict];

        completionBlock(responseDict);
        [self removeURLSessionTask:task];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self sendErrorToTestFairy:CASE_DELETE_CARD parameter:aParameter response:error];

        failedBlock(error);
        [self removeURLSessionTask:task];
    }];
    
    [self addURLSessionTask:aTask];
    return aTask;
}

#pragma mark - Change Card Status


- (NSURLSessionDataTask *)ChangeCardStatus:(NSMutableDictionary *)aParameter completedBlock :(void (^)(NSDictionary* response))completionBlock failedBlock:(void (^)(NSError *error))failedBlock {
    
    
    NSURLSessionDataTask *aTask = [HTTPMANAGER GET:WEB_SERVICE_STRING(WEB_SERVICE_URL, CASE_CHANGE_CARD_STATUS) parameters:aParameter success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *responseDict = responseObject;
        [self sendErrorResponseToTestFairy:CASE_CHANGE_CARD_STATUS parameter:aParameter response:responseDict];

        completionBlock(responseDict);
        [self removeURLSessionTask:task];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self sendErrorToTestFairy:CASE_CHANGE_CARD_STATUS parameter:aParameter response:error];

        failedBlock(error);
        [self removeURLSessionTask:task];
    }];
    
    [self addURLSessionTask:aTask];
    return aTask;
}


#pragma mark - send Notification

- (NSURLSessionDataTask *)sendNotification:(NSMutableDictionary *)aParameter completedBlock :(void (^)(NSDictionary* response))completionBlock failedBlock:(void (^)(NSError *error))failedBlock {
    
    
    NSURLSessionDataTask *aTask = [HTTPMANAGER GET:WEB_SERVICE_STRING(WEB_SERVICE_URL, CASE_SEND_NOTIFICATION) parameters:aParameter success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *responseDict = responseObject;
        [self sendErrorResponseToTestFairy:CASE_SEND_NOTIFICATION parameter:aParameter response:responseDict];

        completionBlock(responseDict);
        [self removeURLSessionTask:task];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self sendErrorToTestFairy:CASE_SEND_NOTIFICATION parameter:aParameter response:error];

        failedBlock(error);
        [self removeURLSessionTask:task];
    }];
    
    [self addURLSessionTask:aTask];
    return aTask;
}


#pragma mark - send Promo

// http://192.168.0.65:66/API/PromoCode/ValidatePromoCode?StrCustomerID=1&StrPromoCode=TxtS

- (NSURLSessionDataTask *)sendPromoCode:(NSMutableDictionary *)aParameter completedBlock :(void (^)(NSDictionary* response))completionBlock failedBlock:(void (^)(NSError *error))failedBlock {
    
    
    NSURLSessionDataTask *aTask = [HTTPMANAGER GET:WEB_SERVICE_STRING(WEB_SERVICE_URL, CASE_VALIDATE_PROMO_CODE) parameters:aParameter success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *responseDict = responseObject;
        [self sendErrorResponseToTestFairy:CASE_VALIDATE_PROMO_CODE parameter:aParameter response:responseDict];

        completionBlock(responseDict);
        [self removeURLSessionTask:task];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self sendErrorToTestFairy:CASE_VALIDATE_PROMO_CODE parameter:aParameter response:error];

        failedBlock(error);
        [self removeURLSessionTask:task];
    }];
    
    [self addURLSessionTask:aTask];
    return aTask;
}

#pragma mark - referal Promo

- (NSURLSessionDataTask *)referalCode:(NSMutableDictionary *)aParameter completedBlock :(void (^)(NSDictionary* response))completionBlock failedBlock:(void (^)(NSError *error))failedBlock {
    
    
    NSURLSessionDataTask *aTask = [HTTPMANAGER GET:WEB_SERVICE_STRING(WEB_SERVICE_URL, CASE_SAVE_REFERAL_CODE) parameters:aParameter success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *responseDict = responseObject;
        [self sendErrorResponseToTestFairy:CASE_SAVE_REFERAL_CODE parameter:aParameter response:responseDict];

        completionBlock(responseDict);
        [self removeURLSessionTask:task];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self sendErrorToTestFairy:CASE_SAVE_REFERAL_CODE parameter:aParameter response:error];

        failedBlock(error);
        [self removeURLSessionTask:task];
    }];
    
    [self addURLSessionTask:aTask];
    return aTask;
}


#pragma mark - FAVORITE -

#pragma mark - Get favorite

// http://192.168.0.48/PPTCustomer/API/CustomerFavourites/GetFavourites?Customer_Id=11

- (NSURLSessionDataTask *)getFavoriteType:(NSMutableDictionary *)aParameter completedBlock :(void (^)(NSDictionary* response))completionBlock failedBlock:(void (^)(NSError *error))failedBlock {
    
    
    NSURLSessionDataTask *aTask = [HTTPMANAGER GET:WEB_SERVICE_STRING(WEB_SERVICE_URL, CASE_GET_FAVORITE_LIST) parameters:aParameter success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *responseDict = responseObject;
        NSMutableArray *aMutableArray = [responseDict  valueForKey:@"Favourites_Types"];
        NSMutableArray *aListMutableArray = [NSMutableArray new];
        
        if (aMutableArray .count) {
            
            for (NSDictionary *aDictionary in aMutableArray) {
                
                NSMutableDictionary *aMutableDictionary  = [NSMutableDictionary new];

                aMutableDictionary = [aDictionary mutableCopy];
                
                if ([[aDictionary valueForKey:@"PrimaryLocation"] isEqualToString:@"1"])
                    aMutableDictionary[@"favourite_filter"] = @"0";
                else if ([[aDictionary valueForKey:@"PrimaryLocation"] isEqualToString:@"2"])
                    aMutableDictionary[@"favourite_filter"] = @"1";
                else
                    aMutableDictionary[@"favourite_filter"] = @"2";
                
                [aListMutableArray addObject:aMutableDictionary];
            }
            
            [SESSION setFavoriteInfoList:aListMutableArray];
            [COREDATAMANAGER deleteAllEntities:TABEL_FAVOURITE_TYPE];
            
            BOOL isHomePresent = false, isOfficePresent = false;
            
            for (NSDictionary *aDictionary in aMutableArray) {
                
                if ([aDictionary[@"PrimaryLocation"] isEqualToString:@"1"]) {
                    
                    [COREDATAMANAGER deleteSpecificEntities:TABEL_FAVOURITE_TYPE attriputesNameAndValue:[NSPredicate predicateWithFormat:@"favourite_primary_location = 1"]];
                    isHomePresent = YES;
                    [COREDATAMANAGER addFavouriteListInfo:aDictionary];
                }
                else if ([aDictionary[@"PrimaryLocation"] isEqualToString:@"2"]) {
                    
                    [COREDATAMANAGER deleteSpecificEntities:TABEL_FAVOURITE_TYPE attriputesNameAndValue:[NSPredicate predicateWithFormat:@"favourite_primary_location = 2"]];
                    isOfficePresent = YES;
                    [COREDATAMANAGER addFavouriteListInfo:aDictionary];
                }
                else {
                    
                    [COREDATAMANAGER addFavouriteListInfo:aDictionary];
                }
            }
            
            if (!isHomePresent) {
                
                [HELPER addFavoriteList:1];
            }
            
            if (!isOfficePresent) {
                
                [HELPER addFavoriteList:2];
            }
            
        }
        [self sendErrorResponseToTestFairy:CASE_GET_FAVORITE_LIST parameter:aParameter response:responseDict];

        completionBlock(responseDict);
        [self removeURLSessionTask:task];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self sendErrorToTestFairy:CASE_GET_FAVORITE_LIST parameter:aParameter response:error];

        failedBlock(error);
        [self removeURLSessionTask:task];
    }];
    
    [self addURLSessionTask:aTask];
    return aTask;
}

// http://192.168.0.48/PPTCustomer/API/CustomerFavourites/SaveFavourites?StrJson={ "Favourites_Info":{"Fav_Id":"",         "Customer_Id":"11","Latitude":"44.968046","Longitude":"-94.420307","Display_Name":"Siva","Address":"Coimbatore","Primary_Location":"1"} }

- (NSURLSessionDataTask *)saveOrUpdateFavoriteType:(NSMutableDictionary *)aParameter completedBlock :(void (^)(NSDictionary* response))completionBlock failedBlock:(void (^)(NSError *error))failedBlock {
    
    
    NSURLSessionDataTask *aTask = [HTTPMANAGER POST:WEB_SERVICE_STRING(WEB_SERVICE_URL, CASE_SAVE_FAVORITE_LIST) parameters:aParameter constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    }  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *responseDict = responseObject;
        NSMutableArray *aMutableArray = [responseDict  valueForKey:@"Favourites_Types"];
        NSMutableArray *aListMutableArray = [NSMutableArray new];
        
        if (aMutableArray .count) {
            
            for (NSDictionary *aDictionary in aMutableArray) {
                
                NSMutableDictionary *aMutableDictionary  = [NSMutableDictionary new];
                
                aMutableDictionary = [aDictionary mutableCopy];
                
                if ([[aDictionary valueForKey:@"PrimaryLocation"] isEqualToString:@"1"])
                    aMutableDictionary[@"favourite_filter"] = @"0";
                else if ([[aDictionary valueForKey:@"PrimaryLocation"] isEqualToString:@"2"])
                    aMutableDictionary[@"favourite_filter"] = @"1";
                else
                    aMutableDictionary[@"favourite_filter"] = @"2";
                
                [aListMutableArray addObject:aMutableDictionary];
            }
            
            [SESSION setFavoriteInfoList:aListMutableArray];
            [COREDATAMANAGER deleteAllEntities:TABEL_FAVOURITE_TYPE];
            
            BOOL isHomePresent = false, isOfficePresent = false;
            
            for (NSDictionary *aDictionary in aMutableArray) {
                
                if ([aDictionary[@"PrimaryLocation"] isEqualToString:@"1"]) {
                    
                    [COREDATAMANAGER deleteSpecificEntities:TABEL_FAVOURITE_TYPE attriputesNameAndValue:[NSPredicate predicateWithFormat:@"favourite_primary_location = 1"]];
                    isHomePresent = YES;
                    [COREDATAMANAGER addFavouriteListInfo:aDictionary];
                }
                else if ([aDictionary[@"PrimaryLocation"] isEqualToString:@"2"]) {
                    
                    [COREDATAMANAGER deleteSpecificEntities:TABEL_FAVOURITE_TYPE attriputesNameAndValue:[NSPredicate predicateWithFormat:@"favourite_primary_location = 2"]];
                    isOfficePresent = YES;
                    [COREDATAMANAGER addFavouriteListInfo:aDictionary];
                }
                else {
                    
                    [COREDATAMANAGER addFavouriteListInfo:aDictionary];
                }
            }
            
            if (!isHomePresent) {
                
                [HELPER addFavoriteList:1];
            }
            
            if (!isOfficePresent) {
                
                [HELPER addFavoriteList:2];
            }
        }
        [self sendErrorResponseToTestFairy:CASE_SAVE_FAVORITE_LIST parameter:aParameter response:responseDict];

        completionBlock(responseDict);
        [self removeURLSessionTask:task];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self sendErrorToTestFairy:CASE_SAVE_FAVORITE_LIST parameter:aParameter response:error];

        failedBlock(error);
        [self removeURLSessionTask:task];
    }];
    
    [self addURLSessionTask:aTask];
    return aTask;
}

// http://192.168.0.48/PPTCustomer/API/CustomerFavourites/DeleteFavourites?StrJson={"Favourites_Info":{"Fav_Id":"11",        "Customer_Id":"49"} }

- (NSURLSessionDataTask *)deleteFavoriteType:(NSMutableDictionary *)aParameter primaryLocatio:(NSString *)aFavPrimaryLocation  completedBlock :(void (^)(NSDictionary* response))completionBlock failedBlock:(void (^)(NSError *error))failedBlock {
    
    NSLog(@"aParameter ---- %@",aParameter);
    
    NSURLSessionDataTask *aTask = [HTTPMANAGER GET:WEB_SERVICE_STRING(WEB_SERVICE_URL, CASE_DELETE_FAVORITE_LIST) parameters:aParameter success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *responseDict = responseObject;
        NSMutableArray *aMutableArray = [responseDict  valueForKey:@"Favourites_Types"];
        NSMutableArray *aListMutableArray = [NSMutableArray new];
        
        NSLog(@"responseDict ---- %@",responseDict);

        if (aMutableArray .count) {
            
            for (NSDictionary *aDictionary in aMutableArray) {
                
                NSMutableDictionary *aMutableDictionary  = [NSMutableDictionary new];
                
                aMutableDictionary = [aDictionary mutableCopy];
                
                if ([[aDictionary valueForKey:@"PrimaryLocation"] isEqualToString:@"1"])
                    aMutableDictionary[@"favourite_filter"] = @"0";
                else if ([[aDictionary valueForKey:@"PrimaryLocation"] isEqualToString:@"2"])
                    aMutableDictionary[@"favourite_filter"] = @"1";
                else
                    aMutableDictionary[@"favourite_filter"] = @"2";
                
                [aListMutableArray addObject:aMutableDictionary];
            }
            
            [SESSION setFavoriteInfoList:aListMutableArray];
        }
        else {
            
            
            [SESSION setFavoriteInfoList:[NSMutableArray new]];
        }
        
        [COREDATAMANAGER deleteAllEntities:TABEL_FAVOURITE_TYPE];
        
        
        BOOL isHomePresent = false, isOfficePresent = false;
        
        for (NSDictionary *aDictionary in aMutableArray) {
            
            [COREDATAMANAGER addFavouriteListInfo:aDictionary];
            
            
            if ([aDictionary[@"PrimaryLocation"] isEqualToString:@"1"]) {
                
                //  [COREDATAMANAGER deleteSpecificEntities:TABEL_FAVOURITE_TYPE attriputesNameAndValue:[NSPredicate predicateWithFormat:@"favourite_primary_location = %@",aFavPrimaryLocation]];
                isHomePresent = YES;
                // [COREDATAMANAGER addFavouriteListInfo:aDictionary];
            }
            else if ([aDictionary[@"PrimaryLocation"] isEqualToString:@"2"]) {
                
                //  [COREDATAMANAGER deleteSpecificEntities:TABEL_FAVOURITE_TYPE attriputesNameAndValue:[NSPredicate predicateWithFormat:@"favourite_primary_location = %@",aFavPrimaryLocation]];
                isOfficePresent = YES;
                // [COREDATAMANAGER addFavouriteListInfo:aDictionary];
            }
            else {
                
                //   [COREDATAMANAGER deleteSpecificEntities:TABEL_FAVOURITE_TYPE attriputesNameAndValue:[NSPredicate predicateWithFormat:@"favourite_type_id = %@",aParameter[K_FAVORITE_ID]]];
                
                
                // [COREDATAMANAGER addFavouriteListInfo:aDictionary];
            }
        }
        
        if (!isHomePresent) {
            
            [HELPER addFavoriteList:1];
        }
        
        if (!isOfficePresent) {
            
            [HELPER addFavoriteList:2];
        }
        [self sendErrorResponseToTestFairy:CASE_DELETE_FAVORITE_LIST parameter:aParameter response:responseDict];
        completionBlock(responseDict);
        [self removeURLSessionTask:task];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self sendErrorToTestFairy:CASE_DELETE_FAVORITE_LIST parameter:aParameter response:error];

        failedBlock(error);
        [self removeURLSessionTask:task];
    }];
    
    [self addURLSessionTask:aTask];
    return aTask;
}

#pragma mark - Get friend list

- (NSURLSessionDataTask *)getFriendListWithCompletedBlock :(void (^)(NSDictionary* response))completionBlock failedBlock:(void (^)(NSError *error))failedBlock {
    
    NSMutableDictionary *aMDictParameters = [NSMutableDictionary new];
    
    aMDictParameters [@"Customer_Id"] = [SESSION getUserInfo][0][K_CUSTOMER_ID];
    
    NSURLSessionDataTask *aTask = [HTTPMANAGER GET:WEB_SERVICE_STRING(WEB_SERVICE_URL, CASE_GET_FRIEND_LIST) parameters:aMDictParameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *responseDict = responseObject;
        [self sendErrorResponseToTestFairy:CASE_GET_FRIEND_LIST parameter:aMDictParameters response:responseDict];
        
        completionBlock(responseDict);
        [self removeURLSessionTask:task];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self sendErrorToTestFairy:CASE_GET_FRIEND_LIST parameter:aMDictParameters response:error];

        [self removeURLSessionTask:task];
    }];
    
    [self addURLSessionTask:aTask];
    
    return aTask;
}


#pragma mark - Delete Friend Contact

- (NSURLSessionDataTask *)deleteFriendsContact:(NSMutableDictionary *)parameters completedBlock :(void (^)(NSDictionary* response))completionBlock failedBlock:(void (^)(NSError *error))failedBlock {
    
    
    NSURLSessionDataTask *aTask = [HTTPMANAGER GET:WEB_SERVICE_STRING(WEB_SERVICE_URL, CASE_DELETE_FRIENDS_CONATACT) parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *responseDict = responseObject;
        [self sendErrorResponseToTestFairy:CASE_DELETE_FRIENDS_CONATACT parameter:parameters response:responseDict];

        completionBlock(responseDict);
        [self removeURLSessionTask:task];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self sendErrorToTestFairy:CASE_DELETE_FRIENDS_CONATACT parameter:parameters response:error];

        [self removeURLSessionTask:task];
    }];
    
    [self addURLSessionTask:aTask];
    
    return aTask;
}

#pragma mark - Add Friend Contact

- (NSURLSessionDataTask *)addContactToWebservice:(NSMutableDictionary *)parameters completedBlock :(void (^)(NSDictionary* response))completionBlock failedBlock:(void (^)(NSError *error))failedBlock {
    
    NSURLSessionDataTask *aTask = [HTTPMANAGER POST:WEB_SERVICE_STRING(WEB_SERVICE_URL, CASE_ADD_FRIENDS_CONATACT) parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        /* if (parameters) {// StrJson
         
         [formData appendPartWithHeaders:nil body:nil];
         // [formData appendPartWithFileData:parameters name:@"Json" fileName:@"StrJson" mimeType:@"image/png" ];
         }*/
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *responseDict = responseObject;
        [self sendErrorResponseToTestFairy:CASE_ADD_FRIENDS_CONATACT parameter:parameters response:responseDict];

        completionBlock(responseDict);
        [self removeURLSessionTask:task];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self sendErrorToTestFairy:CASE_ADD_FRIENDS_CONATACT parameter:parameters response:error];

        failedBlock(error);
        
        [self removeURLSessionTask:task];
    }];
    
    [self addURLSessionTask:aTask];
    
    return aTask;
}


#pragma mark - update Notification

- (NSURLSessionDataTask *)updateNotification:(NSMutableDictionary *)aParameter completedBlock :(void (^)(NSDictionary* response))completionBlock failedBlock:(void (^)(NSError *error))failedBlock {
    
    
    NSURLSessionDataTask *aTask = [HTTPMANAGER GET:WEB_SERVICE_STRING(WEB_SERVICE_URL, CASE_UPDATE_NOTIFICATION_STATUS) parameters:aParameter success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *responseDict = responseObject;
        [self sendErrorResponseToTestFairy:CASE_UPDATE_NOTIFICATION_STATUS parameter:aParameter response:responseDict];

        completionBlock(responseDict);
        [self removeURLSessionTask:task];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self sendErrorToTestFairy:CASE_UPDATE_NOTIFICATION_STATUS parameter:aParameter response:error];

        failedBlock(error);
        [self removeURLSessionTask:task];
    }];
    
    [self addURLSessionTask:aTask];
    return aTask;
}

#pragma mark - update Push Notification

- (NSURLSessionDataTask *)updatePushNotification:(NSMutableDictionary *)aParameter completedBlock :(void (^)(NSDictionary* response))completionBlock failedBlock:(void (^)(NSError *error))failedBlock {
    
    
    NSURLSessionDataTask *aTask = [HTTPMANAGER GET:WEB_SERVICE_STRING(WEB_SERVICE_URL, CASE_PUSH_NOTIFICATION_STATUS) parameters:aParameter success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *responseDict = responseObject;
        [self sendErrorResponseToTestFairy:CASE_PUSH_NOTIFICATION_STATUS parameter:aParameter response:responseDict];

        completionBlock(responseDict);
        [self removeURLSessionTask:task];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self sendErrorToTestFairy:CASE_PUSH_NOTIFICATION_STATUS parameter:aParameter response:error];

        failedBlock(error);
        [self removeURLSessionTask:task];
    }];
    
    [self addURLSessionTask:aTask];
    return aTask;
}


// http://116.212.240.36/SuburbanAPI/API/Login/Logout?StrCustomerId=60

#pragma mark - Logout -

- (NSURLSessionDataTask *)logout:(NSMutableDictionary *)parameters completedBlock :(void (^)(NSDictionary* response))completionBlock failedBlock:(void (^)(NSError *error))failedBlock {
    
    NSLog(@"parameters ==> %@", parameters);
    
    NSURLSessionDataTask *aTask = [HTTPMANAGER GET:WEB_SERVICE_STRING(WEB_SERVICE_URL, CASE_LOGOUT) parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *responseDict = responseObject;
        [self sendErrorResponseToTestFairy:CASE_LOGOUT parameter:parameters response:responseDict];

        completionBlock(responseDict);
        [self removeURLSessionTask:task];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self sendErrorToTestFairy:CASE_LOGOUT parameter:parameters response:error];

        failedBlock(error);
        [self removeURLSessionTask:task];
    }];
    
    [self addURLSessionTask:aTask];
    return aTask;
}


#pragma mark - Change Password Info

- (NSURLSessionDataTask *)getChangePasswordInfo:(NSMutableDictionary *)parameters completedBlock :(void (^)(NSDictionary* response))completionBlock failedBlock:(void (^)(NSError *error))failedBlock {
    
    NSURLSessionDataTask *aTask;
    
    [self addURLSessionTask:aTask];
    return aTask;
}
#pragma mark - NSURLSessionTask Methods

- (void)addURLSessionTask:(NSURLSessionTask*)task {
    
    if (myURLSessionTaskMutableArray) {
        [myURLSessionTaskMutableArray addObject:task];
    }
}

- (void)removeURLSessionTask:(NSURLSessionTask*)task {
    
    if (myURLSessionTaskMutableArray) {
        [myURLSessionTaskMutableArray removeObject:task];
    }
}

- (void)cancelAllURLSessionTask {
    
    for (int i = 0; i < [myURLSessionTaskMutableArray count]; i++) {
        
        NSURLSessionTask *task = myURLSessionTaskMutableArray[i];
        [task cancel];
    }
    
    [myURLSessionTaskMutableArray removeAllObjects];
}

-(void)sendErrorResponseToTestFairy:(NSString *)aCase parameter:(NSMutableDictionary *)aParameter response:(NSDictionary *)aMutableResponse {
    
    if ([aMutableResponse[kRESPONSE][kRESPONSE_CODE] integerValue] == -2) {
        
        NSString *aURLString = [NSString stringWithFormat:@"%@%@",WEB_SERVICE_URL,aCase];
        [TestFairy sendUserFeedback:[NSString stringWithFormat:@"URL --- %@ parameter --  %@ response -- %@",aURLString,aParameter,aMutableResponse]];
    }
}

-(void)sendErrorToTestFairy:(NSString *)aCase parameter:(NSMutableDictionary *)aParameter response:(NSError *)aError {
    
    NSString *aURLString = [NSString stringWithFormat:@"%@%@",WEB_SERVICE_URL,aCase];
    [TestFairy sendUserFeedback:[NSString stringWithFormat:@"URL --- %@ parameter --  %@ response -- %@",aURLString,aParameter,aError]];
}

#pragma mark - Send Rating          

- (NSURLSessionDataTask *)sendRating:(NSMutableDictionary *)aParameter completedBlock :(void (^)(NSDictionary* response))completionBlock failedBlock:(void (^)(NSError *error))failedBlock {
    
    
    NSURLSessionDataTask *aTask = [HTTPMANAGER GET:WEB_SERVICE_STRING(WEB_SERVICE_URL, SR_UPDATE_RATING) parameters:aParameter success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *responseDict = responseObject;
        
        completionBlock(responseDict);
        [self removeURLSessionTask:task];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failedBlock(error);
        [self removeURLSessionTask:task];
    }];
    
    [self addURLSessionTask:aTask];
    return aTask;
}

@end
