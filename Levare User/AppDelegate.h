//
//  AppDelegate.h
//  Levare User
//
//  Created by AngMac137 on 11/16/16.
//  Copyright © 2016 AngMac137. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "MMDrawerController.h"
#import <UserNotifications/UserNotifications.h>
#import "Levare User-Bridging-Header.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,UNUserNotificationCenterDelegate>

@property (strong, nonatomic) UIWindow *window;

// Core data
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (strong, nonatomic) MMDrawerController *sideMenu;

- (void)saveContext;


- (void)startMonitoringNetwork;
- (void)presentNoInternetViewController;
- (void)dismissNoInternetViewController;
-(void)getCountryCodeDetailsFromCountyr:(NSString *)aCountryName;
@end

