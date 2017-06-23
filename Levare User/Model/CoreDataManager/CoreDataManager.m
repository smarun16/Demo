//
//  CoreDataManager.m
//  ESIPlan
//
//  Created by ANGLEREIT on 26/09/15.
//  Copyright © 2015 anglereit. All rights reserved.
//

#import "CoreDataManager.h"

@implementation CoreDataManager

static CoreDataManager* sharedObject = nil;

+ (CoreDataManager*)sharedObject {
    
    @synchronized([DbManager class]) {
        
        if (!sharedObject) {
            sharedObject = [[self alloc] init];
        }
        
        return sharedObject;
    }
    
    return nil;
}

NSManagedObject *myLoginManagedObject;

#pragma mark - Add and Fetch -

#pragma mark -Service Info

- (void)addServiceListInfo:(NSDictionary *)aDictionary {
    
    NSManagedObjectContext *context = [APPDELEGATE managedObjectContext];
    
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:TABEL_SERVICE_TYPE inManagedObjectContext:context];
    TagServiceType *aTag = [[TagServiceType alloc]initWithEntity:entityDescription insertIntoManagedObjectContext:context];
    
    aTag.service_type_id = [aDictionary valueForKey:@"ServiceType_Id"];
    aTag.service_type_name = [aDictionary valueForKey:@"ServiceType_Name"];
    aTag.service_type_icon = [aDictionary valueForKey:@"ServiceType_Icon"];
    aTag.vehicle_max_range = [aDictionary valueForKey:@"Vehicle_Max_Range"];
    
    NSError *error = nil;
    
    if (![aTag.managedObjectContext save:&error]) {
        NSLog(@"Unable to save managed object context.");
        NSLog(@"%@, %@", error, error.localizedDescription);
    }
}


- (NSArray *)getServiceListInfo {
    
    NSFetchRequest *afetchReguest = [[NSFetchRequest alloc]init];
    
    NSEntityDescription * entity = [NSEntityDescription entityForName:TABEL_SERVICE_TYPE inManagedObjectContext:[APPDELEGATE managedObjectContext]];
    [afetchReguest setEntity:entity];
    
    NSError *aError = nil;
    NSArray *aResultArray = [[APPDELEGATE managedObjectContext] executeFetchRequest:afetchReguest error:&aError];
    
    if (!aError)
    {
        NSLog(@"Unable to execute fetch request.");
        NSLog(@"%@, %@", aError, aError.localizedDescription);
    }
    
    return aResultArray;
}

#pragma mark - FavouriteList

- (void)addFavouriteListInfo:(NSDictionary *)aDictionary {
    
    NSManagedObjectContext *context = [APPDELEGATE managedObjectContext];
    
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:TABEL_FAVOURITE_TYPE inManagedObjectContext:context];
    
    TagFavouriteType *aTag = [[TagFavouriteType alloc]initWithEntity:entityDescription insertIntoManagedObjectContext:context];
    
    aTag.favourite_type_id = [aDictionary valueForKey:@"CF_Id"];
    aTag.customer_id = [aDictionary valueForKey:@"Customer_Id"];
    aTag.favourite_latitude = [aDictionary valueForKey:@"PULatitude"];
    aTag.favourite_longitude = [aDictionary valueForKey:@"PULongitude"];
    aTag.favourite_address = [aDictionary valueForKey:@"PUAddress"];
    aTag.favourite_primary_location = [aDictionary valueForKey:@"PrimaryLocation"];
    aTag.favourite_updated_on = [aDictionary valueForKey:@"Upddated_On"];
    
    if ([[aDictionary valueForKey:@"PrimaryLocation"] isEqualToString:@"1"])
        aTag.favourite_filter = @"0";
    else if ([[aDictionary valueForKey:@"PrimaryLocation"] isEqualToString:@"2"])
        aTag.favourite_filter = @"1";
    else
        aTag.favourite_filter = @"2";
    
    aTag.favourite_display_name = VALIDATE_WITH_DEFAULT_VALUE([aDictionary valueForKey:@"Display_Name"], @"");
    
    
    /////////////////////////
    /// This to add zero at the end lat & long if length is less than 6
    /// This is done for checking the condition to set as fav location
    /////////////////////////
    aTag.favourite_latitude = (aTag.favourite_latitude.length < 8) ? [HELPER setZeroAfterValue:aTag.favourite_latitude numberOfZero: 8 - aTag.favourite_latitude.length] : [aDictionary valueForKey:@"PULatitude"];
    /////////////////////////
    aTag.favourite_longitude = (aTag.favourite_longitude.length < 8) ? [HELPER setZeroAfterValue:aTag.favourite_longitude numberOfZero: 8 - aTag.favourite_longitude.length]  : [aDictionary valueForKey:@"PULongitude"];
   
    aTag.favourite_latitude = (aTag.favourite_latitude.length > 8) ? [[aDictionary valueForKey:@"PULatitude"] substringToIndex:8] : [aDictionary valueForKey:@"PULatitude"];
    /////////////////////////
    aTag.favourite_longitude = (aTag.favourite_longitude.length > 8) ? [[aDictionary valueForKey:@"PULongitude"] substringToIndex:8]  : [aDictionary valueForKey:@"PULongitude"];
    NSError *error = nil;
    
    if (aTag != nil) {
        
    }
    
    if (![aTag.managedObjectContext save:&error]) {
        
        NSLog(@"Unable to save managed object context.");
        NSLog(@"%@, %@", error, error.localizedDescription);
    }
}


- (NSArray *)getFavouriteListInfo {
    
    NSFetchRequest *afetchReguest = [[NSFetchRequest alloc]init];
    
    NSEntityDescription * entity = [NSEntityDescription entityForName:TABEL_FAVOURITE_TYPE inManagedObjectContext:[APPDELEGATE managedObjectContext]];
    [afetchReguest setEntity:entity];
    
    NSError *aError = nil;
    NSArray *aResultArray = [[APPDELEGATE managedObjectContext] executeFetchRequest:afetchReguest error:&aError];
    
    if (!aError)
    {
        NSLog(@"Unable to execute fetch request.");
        NSLog(@"%@, %@", aError, aError.localizedDescription);
    }
    
    return aResultArray;
}

- (NSArray *)getFavouriteListInfo: (NSPredicate *)aPredicate  {
    
    NSFetchRequest *afetchReguest = [[NSFetchRequest alloc]init];
    
    NSEntityDescription * entity = [NSEntityDescription entityForName:TABEL_FAVOURITE_TYPE inManagedObjectContext:[APPDELEGATE managedObjectContext]];
    [afetchReguest setEntity:entity];
    [afetchReguest setPredicate:aPredicate];
    
    NSError *aError = nil;
    NSArray *aResultArray = [[APPDELEGATE managedObjectContext] executeFetchRequest:afetchReguest error:&aError];
    
    if (!aError)
    {
        NSLog(@"Unable to execute fetch request.");
        NSLog(@"%@, %@", aError, aError.localizedDescription);
    }
    
    return aResultArray;
}

#pragma mark - Delete records -

#pragma mark -Delete specific records

- (void)deleteSpecificEntities:(NSString *)aStrNameEntity attriputesNameAndValue:(NSPredicate *)aPredicate
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSFetchRequest *fetch=[[NSFetchRequest alloc] init];
    
    NSEntityDescription *productEntity=[NSEntityDescription entityForName:aStrNameEntity inManagedObjectContext:context];
    [fetch setEntity:productEntity];
    
    [fetch setPredicate:aPredicate];
    
    NSError *fetchError;
    NSError *error;
    
    NSArray *fetchedProducts = [NSArray new];
    fetchedProducts =[context executeFetchRequest:fetch error:&fetchError];
    
    for (NSManagedObject *product in fetchedProducts) {
        [context deleteObject:product];
    }
    
    [context save:&error];
}

#pragma mark -Delete all records

- (void)deleteAllEntities:(NSString *)aStrNameEntity
{
    NSManagedObjectContext *context = [APPDELEGATE managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:aStrNameEntity];
    [fetchRequest setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *object in fetchedObjects)
    {
        [context deleteObject:object];
    }
    
    error = nil;
    [context save:&error];
}

#pragma mark - Update records -

#pragma mark - Update FavouriteListInfo

- (void)updateFavouriteListInfo: (NSMutableDictionary *)aDictionary {
    
    NSManagedObjectContext *context = [APPDELEGATE managedObjectContext];
    
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:TABEL_FAVOURITE_TYPE inManagedObjectContext:context];
    
    NSFetchRequest *afetchReguest = [[NSFetchRequest alloc]init];
    [afetchReguest setEntity:entityDescription];
    [afetchReguest setPredicate:[NSPredicate predicateWithFormat:@"%@ == %@",@"favourite_type_id",aDictionary[@"CF_Id"]]];
    
    TagFavouriteType *aTag = [[TagFavouriteType alloc]initWithEntity:entityDescription insertIntoManagedObjectContext:context];
    
    aTag.favourite_type_id = [aDictionary valueForKey:@"CF_Id"];
    aTag.customer_id = [aDictionary valueForKey:@"Customer_Id"];
    aTag.favourite_latitude = [aDictionary valueForKey:@"PULatitude"];
    aTag.favourite_longitude = [aDictionary valueForKey:@"PULongitude"];
    aTag.favourite_address = [aDictionary valueForKey:@"PUAddress"];
    aTag.favourite_primary_location = [aDictionary valueForKey:@"PrimaryLocation"];
    aTag.favourite_updated_on = [aDictionary valueForKey:@"Upddated_On"];
    aTag.favourite_display_name = [aDictionary valueForKey:@"Display_Name"];
    
    NSError *error = nil;
    
    if (![context save:&error])
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
}

@end
