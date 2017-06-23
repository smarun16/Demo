//
//  Session2.m
//  Levare Associate
//
//  Created by Gopinath, ANGLER - EIT on 17/05/17.
//  Copyright © 2017 AngMac137. All rights reserved.
//

#import "Session2.h"

@implementation Session2
+ (Session2 *)sharedObject {
    
    static Session2 *_sharedObject = nil;
    
    @synchronized (self) {
        if (!_sharedObject)
            _sharedObject = [[self class] new];
    }
    
    return _sharedObject;
}

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        self.userDefaults = [NSUserDefaults standardUserDefaults];
    }
    
    return self;
}

- (void)saveSessionValues {
    
    [self.userDefaults synchronize];
}

- (void)resetSession {
    
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
}

#pragma mark - Sample Methods

- (void)setColorValue:(BOOL)value {
    
    [self.userDefaults setObject:value ? @"YES" : @"NO" forKey:@"ColorValue"];
    [self saveSessionValues];
}

- (BOOL)getColorValue {
    
    if ([self.userDefaults objectForKey:@"ColorValue"] == nil) {
        [self setColorValue:NO];
    }
    
    return [[self.userDefaults objectForKey:@"ColorValue"] isEqualToString:@"YES"] ? YES : NO;
}


- (void)setIntegerValue:(NSInteger)value {
    
    [self.userDefaults setInteger:value forKey:@"IntegerValue"];
    [self saveSessionValues];
}

- (NSInteger)getIntegerValue {
    
    NSInteger value = [self.userDefaults integerForKey:@"IntegerValue"];
    
    if(!value)
        value = 0;
    
    return value;
}


- (void)setStringValue:(NSString*)value {
    
    [self.userDefaults setObject:value forKey:@"StringValue"];
    [self saveSessionValues];
}

- (NSString *)getStringValue {
    
    NSString *value = [self.userDefaults valueForKey:@"StringValue"];
    
    if ([value length] == 0)
        value = @"";
    
    return value;
}


- (void)setMutableArrayValue:(NSMutableArray *)value {
    
    [self.userDefaults rm_setCustomObject:value forKey:@"MutableArrayValue"];
    [self saveSessionValues];
}

- (NSMutableArray *)getMutableArrayValue {
    
    NSMutableArray *value = [NSMutableArray arrayWithArray:[self.userDefaults rm_customObjectForKey:@"MutableArrayValue"]];
    return value;
}

#pragma mark - Last updated time

- (void)setLastUpdatedTime:(NSString *)time module:(NSString *)module {
    
    [self.userDefaults setObject:time forKey:module];
    [self saveSessionValues];
}

- (NSString *)getLastUpdatedTimeFor:(NSString *)module {
    
    NSString *lastUpdatedTime = [self.userDefaults valueForKey:module];
    
    if ([lastUpdatedTime length] == 0)
        lastUpdatedTime = @"";
    
    return lastUpdatedTime;
}

#pragma mark - Project Oriented Methods -

#pragma mark -Device Token

- (void)setDeviceToken:(NSString*)aToken {
    
    [self.userDefaults setObject:aToken forKey:@"DeviceToken"];
    [self saveSessionValues];
}

- (NSString *)getDeviceToken {
    
    NSString *aToken = [self.userDefaults valueForKey:@"DeviceToken"];
    
    if ([aToken length] == 0)
        aToken = @"";
    
    return aToken;
}

#pragma mark -App Version

- (void)setAppVersion:(NSString*)aToken {
    
    [self.userDefaults setObject:aToken forKey:@"AppVersion"];
    [self saveSessionValues];
}

- (NSString *)getAppVersion {
    
    NSString *aToken = [self.userDefaults valueForKey:@"AppVersion"];
    
    if ([aToken length] == 0)
        aToken = @"";
    
    return aToken;
}


- (void)hasAppLaunchedOnce:(BOOL)aAppLaunchedOnce {
    
    [self.userDefaults setBool:aAppLaunchedOnce forKey:@"AppLaunchedOnce"];
    [self saveSessionValues];
}

- (BOOL)hasAppLaunchedOnce {
    
    return [self.userDefaults boolForKey:@"AppLaunchedOnce"];
}

#pragma mark -User LoggedIn Status

- (void)hasLoggedIn:(BOOL)aLoggedIn {
    
    [self.userDefaults setBool:aLoggedIn forKey:@"LoggedIn"];
    [self saveSessionValues];
}

- (BOOL)hasLoggedIn {
    
    return [self.userDefaults boolForKey:@"LoggedIn"];
}

#pragma mark - UserInfo

- (void)setUserInfo:(NSMutableArray *)value {
    
    [self.userDefaults rm_setCustomObject:value forKey:@"UserInfo"];
    [self saveSessionValues];
}

- (NSMutableArray *)getUserInfo {
    
    NSMutableArray *value = [NSMutableArray arrayWithArray:[self.userDefaults rm_customObjectForKey:@"UserInfo"]];
    return value;
}

#pragma mark - Vehicle Type

- (void)setVehicleType:(NSMutableArray *)value {
    
    [self.userDefaults rm_setCustomObject:value forKey:@"Vehicle"];
    [self saveSessionValues];
}

- (NSMutableArray *)getVehicleType {
    
    NSMutableArray *value = [NSMutableArray arrayWithArray:[self.userDefaults rm_customObjectForKey:@"Vehicle"]];
    return value;
}

#pragma mark - Service Type

- (void)setServiceType:(NSMutableArray *)value {
    
    [self.userDefaults rm_setCustomObject:value forKey:@"ServiceType"];
    [self saveSessionValues];
}

- (NSMutableArray *)getServiceType {
    
    NSMutableArray *value = [NSMutableArray arrayWithArray:[self.userDefaults rm_customObjectForKey:@"ServiceType"]];
    return value;
}

- (void)setSelectedServiceType:(NSMutableArray *)value {
    
    [self.userDefaults rm_setCustomObject:value forKey:@"SelectedServiceType"];
    [self saveSessionValues];
}

- (NSMutableArray *)getSelectedServiceType {
    
    NSMutableArray *value = [NSMutableArray arrayWithArray:[self.userDefaults rm_customObjectForKey:@"SelectedServiceType"]];
    return value;
}


#pragma mark - Bank Info

- (void)setBankInfo:(NSMutableArray *)value {
    
    [self.userDefaults rm_setCustomObject:value forKey:@"BankInfo"];
    [self saveSessionValues];
}

- (NSMutableArray *)getBankInfo {
    
    NSMutableArray *value = [NSMutableArray arrayWithArray:[self.userDefaults rm_customObjectForKey:@"BankInfo"]];
    return value;
}


#pragma mark - Current Country

- (void)setCurrentCountryDetails:(NSMutableArray *)value {
    
    [self.userDefaults rm_setCustomObject:value forKey:@"CurrentCountryDetails"];
    
    [self saveSessionValues];
}

- (NSMutableArray *)getCurrentCountryDetails {
    
    NSMutableArray *value = [NSMutableArray arrayWithArray:[self.userDefaults rm_customObjectForKey:@"CurrentCountryDetails"]];
    return value;
}

#pragma mark - Chat Info

- (void)setChatInfo:(NSMutableArray*)value {
    
    [self.userDefaults rm_setCustomObject:value forKey:@"ChatInfo"];
    [self saveSessionValues];
    
}

- (NSMutableArray *)getChatInfo {
    
    NSMutableArray *value = [NSMutableArray arrayWithArray:[self.userDefaults rm_customObjectForKey:@"ChatInfo"]];
    return value;
}


#pragma mark - Cancel reasion Info

- (void)setCancelReasionInfo:(NSMutableArray*)value {
    
    [self.userDefaults rm_setCustomObject:value forKey:@"CancelReasion"];
    [self saveSessionValues];
    
}

- (NSMutableArray *)getCancelReasionInfo {
    
    NSMutableArray *value = [NSMutableArray arrayWithArray:[self.userDefaults rm_customObjectForKey:@"CancelReasion"]];
    return value;
}

#pragma mark -Request is going


- (void)isRequested:(BOOL)aLoggedIn {
    
    [self.userDefaults setBool:aLoggedIn forKey:@"isRequested"];
    [self saveSessionValues];
}

- (BOOL)isRequested {
    
    return [self.userDefaults boolForKey:@"isRequested"];
}



#pragma mark - isSwipEnable

- (void)isSwipEnable:(BOOL)aLoggedIn {
    
    [self.userDefaults setBool:aLoggedIn forKey:@"isSwipEnable"];
    [self saveSessionValues];
}

- (BOOL)isSwipEnable {
    
    return [self.userDefaults boolForKey:@"isSwipEnable"];
}

#pragma mark - Alert Shown

- (void)isAlertShown:(BOOL)aLoggedIn {
    
    [self.userDefaults setBool:aLoggedIn forKey:@"AlertShown"];
    [self saveSessionValues];
}

- (BOOL)isAlertShown {
    
    return [self.userDefaults boolForKey:@"AlertShown"];
}

#pragma mark - Alert Shown

- (void)isInRequestScreen:(BOOL)aLoggedIn {
    
    [self.userDefaults setBool:aLoggedIn forKey:@"InRequestScreen"];
    [self saveSessionValues];
}

- (BOOL)isInRequestScreen {
    
    return [self.userDefaults boolForKey:@"InRequestScreen"];
}

#pragma mark - From OTP Screen

- (void)isFromOTPScreen:(BOOL)aLoggedIn {
    
    [self.userDefaults setBool:aLoggedIn forKey:@"FromOTPScreen"];
    [self saveSessionValues];
}

- (BOOL)isFromOTPScreen {
    
    return [self.userDefaults boolForKey:@"FromOTPScreen"];
}

#pragma mark -Vehicle Name

- (void)setVehicleName:(NSString*)aToken {
    
    [self.userDefaults setObject:aToken forKey:@"VehicleName"];
    [self saveSessionValues];
}

- (NSString *)getVehicleName {
    
    NSString *aToken = [self.userDefaults valueForKey:@"VehicleName"];
    
    if ([aToken length] == 0)
        aToken = @"";
    
    return aToken;
}

#pragma mark -Vehicle Id

- (void)setVehicleId:(NSString*)aToken {
    
    [self.userDefaults setObject:aToken forKey:@"VehicleId"];
    [self saveSessionValues];
}

- (NSString *)getVehicleId {
    
    NSString *aToken = [self.userDefaults valueForKey:@"VehicleId"];
    
    if ([aToken length] == 0)
        aToken = @"";
    
    return aToken;
}

#pragma mark -RequestTime

- (void)setRequestTime:(NSDate*)aToken {
    
    [self.userDefaults setObject:aToken forKey:@"RequestTime"];
    [self saveSessionValues];
}

- (NSDate *)getRequestTime {
    
    NSDate *aToken = [self.userDefaults valueForKey:@"RequestTime"];
    
    if (!aToken)
        aToken = nil;
    
    return aToken;
}

#pragma mark - Notification Badge

- (void)setNotificationBadge:(NSString *)notificationBadge {
    
    [self.userDefaults rm_setCustomObject:notificationBadge forKey:@"notificationBadge"];
    [self saveSessionValues];
}

- (NSString *)getNotificationBadge {
    
    NSString *lastUpdatedTime = [self.userDefaults rm_customObjectForKey:@"notificationBadge"];
    
    if ([lastUpdatedTime length] == 0)
        lastUpdatedTime = @"";
    
    return lastUpdatedTime;
}

#pragma mark - Connection Disconnect

- (void)isConnectionDisconnect:(BOOL)value {
    
    [self.userDefaults setObject:value ? @"YES" : @"NO" forKey:@"ConnectionDisconnect"];
    [self saveSessionValues];
}

- (BOOL)isConnectionDisconnect {
    
    if ([self.userDefaults objectForKey:@"ConnectionDisconnect"] == nil) {
        [self setColorValue:NO];
    }
    
    return [[self.userDefaults objectForKey:@"ConnectionDisconnect"] isEqualToString:@"YES"] ? YES : NO;
}

#pragma mark - Search Info

- (void)setSearchInfo:(NSMutableArray*)value {
    
    [self.userDefaults rm_setCustomObject:value forKey:@"SearchInfo"];
    [self saveSessionValues];
    
}

- (NSMutableArray *)getSearchInfo {
    
    NSMutableArray *value = [NSMutableArray arrayWithArray:[self.userDefaults rm_customObjectForKey:@"SearchInfo"]];
    return value;
}

@end



