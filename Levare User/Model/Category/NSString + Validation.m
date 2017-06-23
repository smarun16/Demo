//
//  NSString + Validation.m
//
//  Copyright (c) 2013 ANGLER EIT. All rights reserved.
//

#import "NSString + Validation.h"

@implementation NSString (Validation)

- (BOOL)isValidEmail {
    
    // Regular expression to check the email format.
	NSString *emailReg = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
	NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailReg];
	
    return [emailTest evaluateWithObject:self];
}

@end
