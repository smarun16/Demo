//
//  DbManager.m
//
//  Copyright (c) 2014 ANGLER EIT. All rights reserved.
//

#import "DbManager.h"
#import "FMDB.h"

//#define NSLog(...)

@implementation DbManager

static DbManager* sharedObject = nil;
static FMDatabase *fmDB;

+ (DbManager*)sharedObject {
    
    @synchronized([DbManager class]) {
        
        if (!sharedObject) {
            sharedObject = [[self alloc] init];
        }
        
        if (!fmDB) {
            [self copyDatabaseIfNeeded];
            fmDB = [FMDatabase databaseWithPath:[self getDbPath]];
            NSLog(@"path = %@",[self getDbPath]);
        }
        
        return sharedObject;
    }
    
    return nil;
}

#pragma mark - DB Methods

+ (void)copyDatabaseIfNeeded {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *dbPath = [self getDbPath];
    NSError *error;
    BOOL success = [fileManager fileExistsAtPath:dbPath];
    NSString *defaultDBPath;
    
    if(!success) {
        
        defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:DB_NAME];
        NSLog(@"DB:%@",defaultDBPath);
        success = [fileManager copyItemAtPath:defaultDBPath toPath:dbPath error:&error];
        
        if (!success)
            NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
    }
}

+ (NSString *)getDbPath {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *directory = [paths objectAtIndex:0];
    
    return [directory stringByAppendingPathComponent:DB_NAME];
}

#pragma mark - Common Methods

- (BOOL)insertIntoTable:(NSString *)tableName UsingValues:(NSDictionary *)dictColumnValues {
    
    NSArray *arrKeys = [dictColumnValues allKeys];
    NSString *values;
    NSString *columns;
    
    { // Creating column string i.e column1,column2....
        
        columns = arrKeys[0];
        for (int i = 1; i < arrKeys.count; i++)
            columns = [columns stringByAppendingString:[NSString stringWithFormat:@",%@",arrKeys[i]]];
    }
    
    {// Creating values string 'value1','value2'....
        
        values = [NSString stringWithFormat:@"'%@'",dictColumnValues[arrKeys[0]]];
        for (int i = 1; i < arrKeys.count; i++)
            values = [values stringByAppendingString:[NSString stringWithFormat:@",'%@'",dictColumnValues[arrKeys[i]]]];
    }
    
    NSLog(@"Insert Query - %@",QUERY_INSERT(tableName, columns, values));
    
    { // INSERT INTO TABLE
        [fmDB open];
        BOOL result = [fmDB executeUpdate:QUERY_INSERT(tableName, columns, values)];
        
        if (result)
            NSLog(@"Inserted values into %@",tableName);
        else
            NSLog(@"Insert Error in %@ - %@",tableName,[fmDB lastErrorMessage]);
        [fmDB close];
        
        return result;
    }
}

- (void)updateTable:(NSString *)tableName columnValues:(NSDictionary *)dictColumnValues whereCondition:(NSString *)whereCondition {
    
    NSArray *arrKeys = [dictColumnValues allKeys];
    NSString *strColumnsAndValues;
    
    { // Creating column string i.e column1='value1',column2='value2'....
        
        strColumnsAndValues = [NSString stringWithFormat:@"%@='%@'",arrKeys[0],dictColumnValues[arrKeys[0]]] ;
        for (int i = 1; i < arrKeys.count; i++)
            strColumnsAndValues = [strColumnsAndValues stringByAppendingString:[NSString stringWithFormat:@",%@='%@'",arrKeys[i],dictColumnValues[arrKeys[i]]]];
    }
    
    NSLog(@"Update Query - %@",QUERY_UPDATE(tableName, strColumnsAndValues, whereCondition));
    
    { // Update into Table
        [fmDB open];
        BOOL result = [fmDB executeUpdate:QUERY_UPDATE(tableName, strColumnsAndValues, whereCondition)];
        
        if (result)
            NSLog(@"Updated row/rows in %@",tableName);
        else
            NSLog(@"Update Error in %@ - %@",tableName,[fmDB lastErrorMessage]);
        [fmDB close];
    }
}

- (void)deleteTable:(NSString *)tableName whereCondition:(NSString *)whereCondition {
    
    NSLog(@"Delete Query - %@",QUERY_DELETE(tableName, whereCondition));
    
    { // Delete row/rows in Table
        [fmDB open];
        BOOL result = [fmDB executeUpdate:QUERY_DELETE(tableName, whereCondition.length == 0 ? @"1" : whereCondition)];
        
        if (result)
            NSLog(@"Deleted row/rows in %@",tableName);
        else
            NSLog(@"Delete Error in %@ - %@",tableName,[fmDB lastErrorMessage]);
        [fmDB close];
    }
}

#pragma mark - Sample Methods

- (void)insert {
    
    NSString *tableName = @"sample";
    NSDictionary *dictValues = @{@"name" : @"shyam",
                                 @"class" : @"III year"};
    
    [self insertIntoTable:tableName UsingValues:dictValues];
}

- (void)update {
    
    NSString *tableName = @"sample";
    NSDictionary *dictValues = @{@"name":@"shyam kumar",
                                 @"class":@"VI year"};
    
    [self updateTable:tableName columnValues:dictValues whereCondition:@"id='1'"];
}

- (void)delete {
    
    NSString *tableName = @"sample";
    [self deleteTable:tableName whereCondition:@"id='1'"];
}

- (NSArray *)getInfo:(NSString *)columns {
    
    [fmDB open];
    FMResultSet *resultSet = [fmDB executeQuery:QUERY_SELECT(@"sample", columns, @"1")];
    NSMutableArray *arrInfo = [NSMutableArray new];
    
    while ([resultSet next]) {
        
        [arrInfo addObject:[resultSet stringForColumn:@"column1"]];
    }
    
    [fmDB close];
    
    return arrInfo;
}


#pragma mark - Project Oriented Methods


@end
