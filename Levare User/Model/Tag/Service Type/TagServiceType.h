//
//  TagVacationInfo.h
//  365Tasker
//
//  Created by AngMac137 on 3/28/16.
//  Copyright © 2016 anglereit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface TagServiceType : NSManagedObject

@property (nonatomic, strong) NSString * service_type_icon;
@property (nonatomic, strong) NSString *service_type_name;
@property (nonatomic, strong) NSString * vehicle_max_range;
@property (nonatomic, strong) NSString * service_type_id, *last_updated_time;


@end
