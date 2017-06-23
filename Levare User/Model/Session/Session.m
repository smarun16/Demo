 //
//  Session.m
//
//  Copyright (c) 2015 ANGLER EIT. All rights reserved.
//

#import "Session.h"

@implementation Session

+ (Session *)sharedObject {
    
    static Session *_sharedObject = nil;
    
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


- (void)setIntegerValue:(NSTimeInterval)value {
    
    [self.userDefaults setInteger:value forKey:@"IntegerValue"];
    [self saveSessionValues];
}

- (NSTimeInterval)getIntegerValue {
    
    NSTimeInterval value = [self.userDefaults integerForKey:@"IntegerValue"];
    
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

#pragma mark - Service Type

- (void)setServiceType:(NSMutableArray *)value {
    
    [self.userDefaults rm_setCustomObject:value forKey:@"ServiceType"];
    [self saveSessionValues];
}

- (NSMutableArray *)getServiceType {
    
    NSMutableArray *value = [NSMutableArray arrayWithArray:[self.userDefaults rm_customObjectForKey:@"ServiceType"]];
    return value;
}

#pragma mark - FavoriteInfo

- (void)setFavoriteInfo:(TagFavouriteType *)value {
    
    [self.userDefaults rm_setCustomObject:value forKey:@"FavoriteInfo"];
    [self saveSessionValues];
}

- (TagFavouriteType *)getFavoriteInfo {
    
    TagFavouriteType *value = [self.userDefaults rm_customObjectForKey:@"FavoriteInfo"];
    
    if(value == nil)
        value = [TagFavouriteType new];
    
    return value;
}

#pragma mark - ServiceTag

- (void)setServiceTag:(TagServiceType *)value {
    
    [self.userDefaults rm_setCustomObject:value forKey:@"ServiceTag"];
    [self saveSessionValues];
}

- (TagServiceType *)getServiceTag {
    
    TagServiceType *value = [self.userDefaults rm_customObjectForKey:@"ServiceTag"];
    
    if(value == nil)
        value = [TagServiceType new];
    
    return value;
}

#pragma mark - FavoriteInfoList

- (void)setFavoriteInfoList:(NSMutableArray *)value {
    
    [self.userDefaults rm_setCustomObject:value forKey:@"FavoriteInfoList"];
    [self saveSessionValues];
}

- (NSMutableArray *)getFavoriteInfoList {
    
    NSMutableArray *value = [NSMutableArray arrayWithArray:[self.userDefaults rm_customObjectForKey:@"FavoriteInfoList"]];
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

#pragma mark - FavTitle

- (void)setFavTitle:(NSString *)notificationBadge {
    
    [self.userDefaults rm_setCustomObject:notificationBadge forKey:@"FavTitle"];
    [self saveSessionValues];
}

- (NSString *)getFavTitle {
    
    NSString *lastUpdatedTime = [self.userDefaults rm_customObjectForKey:@"FavTitle"];
    
    if ([lastUpdatedTime length] == 0)
        lastUpdatedTime = @"";
    
    return lastUpdatedTime;
}


#pragma mark - Notification list Info

- (void)setNotificationInfo:(NSMutableArray*)value {
    
    [self.userDefaults rm_setCustomObject:value forKey:@"Notification"];
    [self saveSessionValues];
    
}

- (NSMutableArray *)getNotificationInfo {
    
    NSMutableArray *value = [NSMutableArray arrayWithArray:[self.userDefaults rm_customObjectForKey:@"Notification"]];
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

#pragma mark - Search Info

- (void)setSearchInfo:(NSMutableArray*)value {
    
    [self.userDefaults rm_setCustomObject:value forKey:@"SearchInfo"];
    [self saveSessionValues];
    
}

- (NSMutableArray *)getSearchInfo {
    
    NSMutableArray *value = [NSMutableArray arrayWithArray:[self.userDefaults rm_customObjectForKey:@"SearchInfo"]];
    return value;
}


#pragma mark - Save Card

- (void)setCardInfo:(NSMutableArray*)value {
    
    [self.userDefaults rm_setCustomObject:value forKey:@"Card"];
    [self saveSessionValues];
    
}

- (NSMutableArray *)getCardInfo {
    
    NSMutableArray *value = [NSMutableArray arrayWithArray:[self.userDefaults rm_customObjectForKey:@"Card"]];
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

#pragma mark -FlagChanged

- (void)isFlagChanged:(BOOL)aLoggedIn {
    
    [self.userDefaults setBool:aLoggedIn forKey:@"FlagChanged"];
    [self saveSessionValues];
}

- (BOOL)isFlagChanged {
    
    return [self.userDefaults boolForKey:@"FlagChanged"];
}


#pragma mark -tripNotifyChanged

- (void)isTripNotifiChanged:(BOOL)aLoggedIn {
    
    [self.userDefaults setBool:aLoggedIn forKey:@"TripNotifiChanged"];
    [self saveSessionValues];
}

- (BOOL)isTripNotifiChanged {
    
    return [self.userDefaults boolForKey:@"TripNotifiChanged"];
}


#pragma mark -PushNotifyChanged

- (void)isPushNotifyChanged:(BOOL)aLoggedIn {
    
    [self.userDefaults setBool:aLoggedIn forKey:@"PushNotifyChanged"];
    [self saveSessionValues];
}

- (BOOL)isPushNotifyChanged {
    
    return [self.userDefaults boolForKey:@"PushNotifyChanged"];
}


#pragma mark - Alert Shown

- (void)isAlertShown:(BOOL)aLoggedIn {
    
    [self.userDefaults setBool:aLoggedIn forKey:@"AlertShown"];
    [self saveSessionValues];
}

- (BOOL)isAlertShown {
    
    return [self.userDefaults boolForKey:@"AlertShown"];
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




@end
