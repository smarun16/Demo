//
//  DbManager.h
//
//  Copyright (c) 2014 ANGLER EIT. All rights reserved.
//


#import "DbMacro.h"

@interface DbManager : NSObject

+(DbManager*)sharedObject;

- (void)deleteTable:(NSString*)tableName whereCondition:(NSString*)whereCondition;

#pragma mark - Project Oriented Methods



@end
