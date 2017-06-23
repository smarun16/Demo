//
//  LUMenuProfileViewController.h
//  Levare User
//
//  Created by AngMac137 on 11/19/16.
//  Copyright © 2016 AngMac137. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LUMenuViewController.h"

@interface LUMenuProfileViewController : LUMenuViewController <EMCCountryDelegate>

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *myAlertLableArray;

@end
