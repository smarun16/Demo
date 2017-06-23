//
//  AppDelegate.m
//  Levare User
//
//  Created by AngMac137 on 11/16/16.
//  Copyright © 2016 AngMac137. All rights reserved.
//

#import "AppDelegate.h"

//Library
#import "AFNetworkActivityIndicatorManager.h"
#import "AFNetworkReachabilityManager.h"
#import <GoogleMaps/GoogleMaps.h>
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import "NoInternetViewController.h"
#import "TestFairy.h"

@import GooglePlaces;

@interface AppDelegate ()<CLLocationManagerDelegate,CrashlyticsDelegate>
{
    NSString *myCountryNameString;
    NSString *myCountryCodeString;
    NSString *myCountryCode;
    UIImage *myCountryFlag;
    CLLocationManager *myLocationManager;
}

@property (nonatomic, strong) NoInternetViewController *aNoInternetViewController;

@end

@implementation AppDelegate

// Core data
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize aNoInternetViewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    { // SETUP AFNETWORKING'S NETWORK INDICATOR AND REACHABILITY
        [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    }
    
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -1200)
                                                         forBarMetrics:UIBarMetricsDefault];
    
    {
//        CrashlyticsKit.delegate = self;
//        [[Fabric sharedSDK] setDebug: YES];
//        [Fabric with:@[[Crashlytics class]]];
    }
    
    [SESSION setSearchInfo:[NSMutableArray new]];
    
    {
        [GMSPlacesClient provideAPIKey:KEY_GOOGLE_MAP_API_KEY];
        [GMSServices provideAPIKey:KEY_GOOGLE_MAP_API_KEY];
    }
    {
        //[TestFairy begin:KEY_TEST_FARY];
    }
        
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    NSString *countryCode = [[NSLocale currentLocale] objectForKey: NSLocaleCountryCode];
    NSString *country = [usLocale displayNameForKey: NSLocaleCountryCode value: countryCode];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;

    [self getCountryCodeDetailsFromCountyr:country];

    {
        if ([SESSION hasLoggedIn]) {
            
            [APPDELEGATE startMonitoringNetwork];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                if ([HTTPMANAGER isNetworkRechable] == NO) {
                    
                    [APPDELEGATE presentNoInternetViewController];
                }
            });
            
            [HELPER navigateToMenuDetailScreen];
        }
    }
    

    {
        [self registerForRemoteNotification];
    }
    
    {
#if (TARGET_OS_SIMULATOR)
        [SESSION setDeviceToken:@"669bb979c8b4dc06e574b8ba3b43a509cf952ccdaff5dc6665e778eb968085da"];
#endif
    }
    
    return YES;
}

- (void)registerForRemoteNotification {
    
    if(SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(@"10.0")) {
        
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error){
            if( !error ){
                [[UIApplication sharedApplication] registerForRemoteNotifications];
            }
        }];
    }
    else {
        
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    
 //   [HELPER setNotificationBadgeCount];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_VIEW_UPADTE_FOR_REQUEST_TIMER object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_VIEW_UPADTE_BASED_ON_REQUEST_STATUS_FROM_BACKGROUND object:nil];

}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_VIEW_UPADTE_BASED_ON_REQUEST_STATUS_FROM_BACKGROUND object:nil];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Remote Notification -
#pragma mark - Remote Notification Delegate // <= iOS 9.x

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    
    if (notificationSettings.types != UIUserNotificationTypeNone)
        [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    NSString *trimmedToken = [[deviceToken description]
                              stringByTrimmingCharactersInSet:
                              [NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    trimmedToken =
    [trimmedToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSLog(@"didRegisterForRemoteNotificationsWithDeviceToken ==> %@",
          trimmedToken);
    
    if (trimmedToken != nil) {
        
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            
            [SESSION setDeviceToken:trimmedToken];
        });
    }
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    
    NSLog(@"Failed to get token, error: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    UIApplicationState state = [application applicationState];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    if (state == UIApplicationStateActive) {
        
    }
    else {
        
     //   [UIApplication sharedApplication].applicationIconBadgeNumber = [[userInfo valueForKeyPath:@"aps.badge"] intValue];
        //([[SESSION getNotificationBadge] intValue] > 1) ? [[SESSION getNotificationBadge] intValue] + [[userInfo valueForKeyPath:@"aps.badge"] intValue] : [[userInfo valueForKeyPath:@"aps.badge"] intValue];
        
      //  [HELPER setNotificationBadgeCount];
    }
}
#pragma mark - Remote Notification Delegate // >= iOS 10

-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler{
    
    //Called to let your app know which action was selected by the user for a given notification.
    
    NSLog(@"Userinfo %@",response.notification.request.content.userInfo);
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
  //  [UIApplication sharedApplication].applicationIconBadgeNumber = [[userInfo valueForKeyPath:@"aps.badge"] intValue];
    
    //([[SESSION getNotificationBadge] intValue] > 0) ? [[SESSION getNotificationBadge] intValue] + [[userInfo valueForKeyPath:@"aps.badge"] intValue] : [[userInfo valueForKeyPath:@"aps.badge"] intValue];
    
   // [HELPER setNotificationBadgeCount];
    
}

- (UIViewController*) topMostController
{
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    
    return topController;
}


#pragma mark -
#pragma mark - Core data
#pragma mark -

- (void)saveContext {
    
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (NSManagedObjectContext *)managedObjectContext {
    
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Levare_User" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:DB_NAME];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark -
#pragma mark - Application's Documents directory
#pragma mark -

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory{
    
    NSLog(@"NSDocumentDirectory %@", [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject]);
    
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark - Helper -

#pragma mark - To get Current Country

-(void)getCountryCodeDetailsFromCountyr:(NSString *)aCountryName {
    
    CountryListDataSource *dataSource = [[CountryListDataSource alloc] init];
    NSArray *aCountryListArray = [dataSource countries];
    
    for (int i = 0; i < aCountryListArray.count; i++) {
        
        if ([aCountryName isEqualToString:aCountryListArray[i][kCountryName]]) {
            
            NSString *imagePath = [NSString stringWithFormat:@"EMCCountryPickerController.bundle/%@", aCountryListArray[i][kCountryCode]];
            UIImage *image = [UIImage imageNamed:imagePath inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil];
            myCountryFlag = [image fitInSize:CGSizeMake(35,35)];
            myCountryCodeString = aCountryListArray[i][kCountryCallingCode]; //[aCountryListArray[i][kCountryCallingCode] componentsSeparatedByString:@" "][0];
            myCountryCode = aCountryListArray[i][kCountryCode];
            
            NSMutableArray *aMutableArray = [NSMutableArray new];
            NSMutableDictionary *aMDict = [NSMutableDictionary new];
            aMDict[kCountryflag] = myCountryFlag;
            aMDict[kCountryCallingCode] = myCountryCodeString;
            aMDict[kCountryCode] = myCountryCode;
            aMDict[kCountryName] = aCountryName;
            
            [aMutableArray addObject:aMDict];
            [SESSION setCurrentCountryDetails:aMutableArray];
        }
    }
}



#pragma mark - No Internet -

- (void)startMonitoringNetwork {
    
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:
            {
                NSLog(@"No Internet Connection");
                [self presentNoInternetViewController];
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
            {
                NSLog(@"WIFI");
                [self dismissNoInternetViewController];
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
            {
                NSLog(@"3G");
                [self dismissNoInternetViewController];
            }
                break;
            default:
            {
                NSLog(@"Unkown network status");
                [self presentNoInternetViewController];
            }
        }
    }];
    
}

- (void)presentNoInternetViewController {
    
    if(aNoInternetViewController == nil) {
        
        aNoInternetViewController = [NoInternetViewController new];
        
        
        UIViewController *aPresentedViewControlelr = [UIApplication sharedApplication].keyWindow.rootViewController.presentedViewController;
        
        if (aPresentedViewControlelr) {
            
            [aPresentedViewControlelr presentViewController:aNoInternetViewController animated:YES completion:nil];
        }
        else {
            
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:aNoInternetViewController animated:YES completion:nil];
        }
    }
}

- (void)dismissNoInternetViewController {
    
    if(aNoInternetViewController != nil) {
        
        UIViewController *aPresentedViewControlelr = [UIApplication sharedApplication].keyWindow.rootViewController.presentedViewController;
        
        if (aPresentedViewControlelr) {
            
            [aPresentedViewControlelr dismissViewControllerAnimated:YES completion:^{
                aNoInternetViewController = nil;
            }];
        }
        else {
            
            [[UIApplication sharedApplication].keyWindow.rootViewController dismissViewControllerAnimated:YES completion:^{
                aNoInternetViewController = nil;
            }];
        }
    }
}

@end
