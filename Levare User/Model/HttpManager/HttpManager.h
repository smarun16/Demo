//
#pragma mark -  HttpManager.h
//
#pragma mark -  Copyright (c) 2014 ANGLER EIT. All rights reserved.
//

#import "AFHTTPSessionManager.h"
#import "HttpMacro.h"

static NSMutableArray *myURLSessionTaskMutableArray;

@interface HttpManager : AFHTTPSessionManager

+ (HttpManager *) sharedObject;
- (instancetype)init;
- (BOOL)isNetworkRechable;
- (void)cancelAllURLSessionTask;

#pragma mark - Comman -

#pragma mark - Login

- (NSURLSessionDataTask *)getLoginDetails:(NSMutableDictionary *)parameters completedBlock :(void (^)(NSDictionary* response))completionBlock failedBlock:(void (^)(NSError *error))failedBlock;

#pragma mark - Registration

- (NSURLSessionDataTask *)getRegisterDetails:(NSMutableDictionary *)parameters completedBlock :(void (^)(NSDictionary* response))completionBlock failedBlock:(void (^)(NSError *error))failedBlock;

#pragma mark - OTP

- (NSURLSessionDataTask *)getOTP:(NSMutableDictionary *)parameters completedBlock :(void (^)(NSDictionary* response))completionBlock failedBlock:(void (^)(NSError *error))failedBlock;

#pragma mark - Get Customer Details

- (NSURLSessionDataTask *)getCustomerDetails:(NSMutableDictionary *)parameters path:(NSData *)aImageData imageName:(NSString *)aImageName completedBlock :(void (^)(NSDictionary* response))completionBlock failedBlock:(void (^)(NSError *error))failedBlock;

#pragma mark - Forgotpassword

- (NSURLSessionDataTask *)getForgotpassword:(NSMutableDictionary *)parameters completedBlock :(void (^)(NSDictionary* response))completionBlock failedBlock:(void (^)(NSError *error))failedBlock;

#pragma mark - Save Card

- (NSURLSessionDataTask *)saveCardDetails:(NSMutableDictionary *)aParameter completedBlock :(void (^)(NSDictionary* response))completionBlock failedBlock:(void (^)(NSError *error))failedBlock;

#pragma mark - Delete Card

- (NSURLSessionDataTask *)deleteCardDetails:(NSMutableDictionary *)aParameter completedBlock :(void (^)(NSDictionary* response))completionBlock failedBlock:(void (^)(NSError *error))failedBlock;
#pragma mark - Change Card Status


- (NSURLSessionDataTask *)ChangeCardStatus:(NSMutableDictionary *)aParameter completedBlock :(void (^)(NSDictionary* response))completionBlock failedBlock:(void (^)(NSError *error))failedBlock;

#pragma mark - Change Password Info

- (NSURLSessionDataTask *)getChangePasswordInfo:(NSMutableDictionary *)parameters completedBlock :(void (^)(NSDictionary* response))completionBlock failedBlock:(void (^)(NSError *error))failedBlock ;

#pragma mark - Service Types
- (NSURLSessionDataTask *)getServiceTypeWithcompletedBlock :(void (^)(NSDictionary* response))completionBlock failedBlock:(void (^)(NSError *error))failedBlock;

#pragma mark - get Trip History

- (NSURLSessionDataTask *)getTripHistory:(NSMutableDictionary *)aParameter completedBlock :(void (^)(NSDictionary* response))completionBlock failedBlock:(void (^)(NSError *error))failedBlock;

#pragma mark - send Promo

- (NSURLSessionDataTask *)sendPromoCode:(NSMutableDictionary *)aParameter completedBlock :(void (^)(NSDictionary* response))completionBlock failedBlock:(void (^)(NSError *error))failedBlock;

#pragma mark - referal Promo

- (NSURLSessionDataTask *)referalCode:(NSMutableDictionary *)aParameter completedBlock :(void (^)(NSDictionary* response))completionBlock failedBlock:(void (^)(NSError *error))failedBlock;

#pragma mark - send Notification

- (NSURLSessionDataTask *)sendNotification:(NSMutableDictionary *)aParameter completedBlock :(void (^)(NSDictionary* response))completionBlock failedBlock:(void (^)(NSError *error))failedBlock;

#pragma mark - update Notification

- (NSURLSessionDataTask *)updateNotification:(NSMutableDictionary *)aParameter completedBlock :(void (^)(NSDictionary* response))completionBlock failedBlock:(void (^)(NSError *error))failedBlock;

#pragma mark - update Push Notification

- (NSURLSessionDataTask *)updatePushNotification:(NSMutableDictionary *)aParameter completedBlock :(void (^)(NSDictionary* response))completionBlock failedBlock:(void (^)(NSError *error))failedBlock;

#pragma mark - FAVORITE -
- (NSURLSessionDataTask *)getFavoriteType:(NSMutableDictionary *)aParameter completedBlock :(void (^)(NSDictionary* response))completionBlock failedBlock:(void (^)(NSError *error))failedBlock;

- (NSURLSessionDataTask *)saveOrUpdateFavoriteType:(NSMutableDictionary *)aParameter completedBlock :(void (^)(NSDictionary* response))completionBlock failedBlock:(void (^)(NSError *error))failedBlock;

- (NSURLSessionDataTask *)deleteFavoriteType:(NSMutableDictionary *)aParameter primaryLocatio:(NSString *)aFavPrimaryLocation completedBlock :(void (^)(NSDictionary* response))completionBlock failedBlock:(void (^)(NSError *error))failedBlock;

#pragma mark - Get friend list

- (NSURLSessionDataTask *)getFriendListWithCompletedBlock :(void (^)(NSDictionary* response))completionBlock failedBlock:(void (^)(NSError *error))failedBlock;

#pragma mark - Delete Friend Contact

- (NSURLSessionDataTask *)deleteFriendsContact:(NSMutableDictionary *)parameters completedBlock :(void (^)(NSDictionary* response))completionBlock failedBlock:(void (^)(NSError *error))failedBlockp;


#pragma mark - Add Friend Contact
- (NSURLSessionDataTask *)addContactToWebservice:(NSMutableDictionary *)parameters completedBlock :(void (^)(NSDictionary* response))completionBlock failedBlock:(void (^)(NSError *error))failedBlock;

#pragma mark - Logout
- (NSURLSessionDataTask *)logout:(NSMutableDictionary *)parameters completedBlock :(void (^)(NSDictionary* response))completionBlock failedBlock:(void (^)(NSError *error))failedBlock;

#pragma mark - sendRating

- (NSURLSessionDataTask *)sendRating:(NSMutableDictionary *)aParameter completedBlock :(void (^)(NSDictionary* response))completionBlock failedBlock:(void (^)(NSError *error))failedBlock;

@end
