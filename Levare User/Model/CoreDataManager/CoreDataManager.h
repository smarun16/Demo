//
//  CoreDataManager.h
//  ESIPlan
//
//  Created by ANGLEREIT on 26/09/15.
//  Copyright © 2015 anglereit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreDataMacro.h"

@interface CoreDataManager : NSObject

+(CoreDataManager*)sharedObject;

#pragma mark - Service Type

- (void)addServiceListInfo:(NSDictionary *)aDictionary;
- (NSArray *)getServiceListInfo;


#pragma mark - FavouriteList

- (void)addFavouriteListInfo:(NSDictionary *)aDictionary;
- (NSArray *)getFavouriteListInfo;
- (NSArray *)getFavouriteListInfo: (NSPredicate *)aPredicate; 

//Backgrounfetch
- (void)addBackgroundFetch:(NSString *)aBackgroundFetch ;


#pragma mark - Delete

// Delete all records
- (void)deleteAllEntities:(NSString *)aStrNameEntity;

// Delete specific records
- (void)deleteSpecificEntities:(NSString *)aStrNameEntity attriputesNameAndValue:(NSPredicate *)aPredicate;

// Delete specific ManagedObject
- (BOOL)deleteManagedObject:(NSManagedObject *)aManagedObject;

#pragma mark - Update FavouriteListInfo

- (void)updateFavouriteListInfo: (NSMutableDictionary *)aDictionary;

@end
