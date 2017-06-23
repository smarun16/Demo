//
//  Session2.h
//  Levare Associate
//
//  Created by Gopinath, ANGLER - EIT on 17/05/17.
//  Copyright © 2017 AngMac137. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Session2 : NSObject
@property (strong, nonatomic) NSUserDefaults *userDefaults;

+ (Session2 *)sharedObject;
- (instancetype)init;
- (void)resetSession;

#pragma mark - Last updated time
- (void)setLastUpdatedTime:(NSString *)time module:(NSString *)module;
- (NSString *)getLastUpdatedTimeFor:(NSString *)module;

#pragma mark - Project Oriented Methods

#pragma mark - Color value

- (void)setColorValue:(BOOL)value;
- (BOOL)getColorValue;

#pragma mark - Device Token

- (void)setDeviceToken:(NSString*)aToken;
- (NSString *)getDeviceToken;

#pragma mark - App Version

- (void)setAppVersion:(NSString*)aToken;
- (NSString *)getAppVersion;

#pragma mark - App Launched Status

- (void)hasAppLaunchedOnce:(BOOL)aAppLaunchedOnce;
- (BOOL)hasAppLaunchedOnce;

#pragma mark - User LoggedIn Status

- (void)hasLoggedIn:(BOOL)aLoggedIn;
- (BOOL)hasLoggedIn;

#pragma mark - UserInfo

- (void)setUserInfo:(NSMutableArray *)value;
- (NSMutableArray *)getUserInfo;

#pragma mark - Vehicle Type

- (void)setVehicleType:(NSMutableArray *)value;
- (NSMutableArray *)getVehicleType;

#pragma mark - Service Type

- (void)setServiceType:(NSMutableArray *)value;
- (NSMutableArray *)getServiceType;
- (void)setSelectedServiceType:(NSMutableArray *)value;
- (NSMutableArray *)getSelectedServiceType;

#pragma mark - Bank Info

- (void)setBankInfo:(NSMutableArray *)value;
- (NSMutableArray *)getBankInfo;

#pragma mark - Current Country

- (void)setCurrentCountryDetails:(NSMutableArray *)value;
- (NSMutableArray *)getCurrentCountryDetails;

#pragma mark - Search Info 
- (void)setSearchInfo:(NSMutableArray*)value;
- (void)getSearchInfo;
#pragma mark - Chat Info

- (void)setChatInfo:(NSMutableArray*)value;
- (NSMutableArray *)getChatInfo;

#pragma mark -Request is going

- (void)isRequested:(BOOL)aLoggedIn;
- (BOOL)isRequested;


#pragma mark - Alert Shown

- (void)isAlertShown:(BOOL)aLoggedIn;
- (BOOL)isAlertShown;

#pragma mark -Vehicle Name

- (void)setVehicleName:(NSString*)aToken;
- (NSString *)getVehicleName;

#pragma mark - isSwipEnable

- (void)isSwipEnable:(BOOL)aLoggedIn;
- (BOOL)isSwipEnable;

#pragma mark - From OTP Screen

- (void)isFromOTPScreen:(BOOL)aLoggedIn;
- (BOOL)isFromOTPScreen;

#pragma mark - Notification Badge

- (void)setNotificationBadge:(NSString *)notificationBadge;
- (NSString *)getNotificationBadge;

#pragma mark - Cancel reasion Info

- (void)setCancelReasionInfo:(NSMutableArray*)value;
- (NSMutableArray *)getCancelReasionInfo;

#pragma mark -Vehicle Id

- (void)setVehicleId:(NSString*)aToken;
- (NSString *)getVehicleId;

#pragma mark -RequestTime

- (void)setRequestTime:(NSDate*)aToken;
- (NSDate *)getRequestTime;

- (void)setIntegerValue:(NSInteger)value;
- (NSInteger)getIntegerValue;

- (void)isInRequestScreen:(BOOL)aLoggedIn;
- (BOOL)isInRequestScreen;

#pragma mark - Connection Disconnect

- (void)isConnectionDisconnect:(BOOL)value;
- (BOOL)isConnectionDisconnect;

@end

