//
//  TagFavouriteType.h
//  Levare User
//
//  Created by AngMac137 on 12/7/16.
//  Copyright © 2016 AngMac137. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface TagFavouriteType : NSManagedObject

@property (nonatomic, strong) NSString *favourite_type_id, *favourite_filter;
@property (nonatomic, strong) NSString *customer_id;
@property (nonatomic, strong) NSString *favourite_latitude;
@property (nonatomic, strong) NSString *favourite_longitude;
@property (nonatomic, strong) NSString *favourite_address;
@property (nonatomic, strong) NSString *favourite_primary_location;
@property (nonatomic, strong) NSString *favourite_updated_on;
@property (nonatomic, strong) NSString *favourite_display_name;

@end
