//
#pragma mark -  Session.h
//
#pragma mark -  Copyright (c) 2015 ANGLER EIT. All rights reserved.
//

#import "NSUserDefaults+RMSaveCustomObject.h"

@interface Session : NSObject

@property (strong, nonatomic) NSUserDefaults *userDefaults;

+ (Session *)sharedObject;
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

#pragma mark - Notification Badge

- (void)setNotificationBadge:(NSString *)notificationBadge;
- (NSString *)getNotificationBadge;


#pragma mark - UserInfo

- (void)setUserInfo:(NSMutableArray *)value;
- (NSMutableArray *)getUserInfo;

#pragma mark - Service Type

- (void)setServiceType:(NSMutableArray *)value;
- (NSMutableArray *)getServiceType;

#pragma mark - Current Country

- (void)setCurrentCountryDetails:(NSMutableArray *)value;
- (NSMutableArray *)getCurrentCountryDetails;

#pragma mark - Notification list Info

- (void)setNotificationInfo:(NSMutableArray*)value;
- (NSMutableArray *)getNotificationInfo;

#pragma mark - ServiceTag

- (void)setServiceTag:(TagServiceType *)value;
- (TagServiceType *)getServiceTag;

#pragma mark - FavoriteInfo

- (void)setFavoriteInfo:(TagFavouriteType *)value;
- (TagFavouriteType *)getFavoriteInfo;


#pragma mark - FavoriteInfoList

- (void)setFavoriteInfoList:(NSMutableArray *)value;
- (NSMutableArray *)getFavoriteInfoList;

#pragma mark - Chat Info

- (void)setChatInfo:(NSMutableArray*)value;
- (NSMutableArray *)getChatInfo;

#pragma mark - Save Card

- (void)setCardInfo:(NSMutableArray*)value;
- (NSMutableArray *)getCardInfo;

#pragma mark - Search Info

- (void)setSearchInfo:(NSMutableArray*)value;
- (NSMutableArray *)getSearchInfo;

#pragma mark -Request is going

- (void)isRequested:(BOOL)aLoggedIn;
- (BOOL)isRequested;

#pragma mark - Alert Shown

- (void)isAlertShown:(BOOL)aLoggedIn;
- (BOOL)isAlertShown;

#pragma mark - FavTitle

- (void)setFavTitle:(NSString *)notificationBadge;
- (NSString *)getFavTitle;

#pragma mark -FlagChanged

- (void)isFlagChanged:(BOOL)aLoggedIn;
- (BOOL)isFlagChanged;

#pragma mark -tripNotifyChanged

- (void)isTripNotifiChanged:(BOOL)aLoggedIn;
- (BOOL)isTripNotifiChanged;

#pragma mark -PushNotifyChanged

- (void)isPushNotifyChanged:(BOOL)aLoggedIn;
- (BOOL)isPushNotifyChanged;


#pragma mark -RequestTime

- (void)setRequestTime:(NSDate*)aToken;
- (NSDate *)getRequestTime;

- (void)setIntegerValue:(NSTimeInterval)value;
- (NSTimeInterval)getIntegerValue;


@end
