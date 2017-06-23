//
//  DbMacro.h
//
//  Copyright (c) 2014 ANGLER EIT. All rights reserved.
//

#ifndef DbMacro_h
#define DbMacro_h

// QUERYS
#define QUERY_INSERT(tableName, columnNames, values) [NSString stringWithFormat:@"INSERT INTO %@(%@) VALUES(%@)", tableName, columnNames, values]
#define QUERY_SELECT(tableName, columnNames, condition) [NSString stringWithFormat:@"SELECT %@ FROM %@ WHERE %@ ", columnNames, tableName, condition]
#define QUERY_UPDATE(tableName, columnNameAndValue, condition) [NSString stringWithFormat:@"UPDATE %@ SET %@ WHERE %@", tableName, columnNameAndValue, condition]
#define QUERY_DELETE(tableName,condition) [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@", tableName, condition]

// TO VALIDATE IF NULL
#define VALIDATE(value) (value ? value : @"")



// TABLE NAME
#define TABLE_USER @"user_info"

#endif
