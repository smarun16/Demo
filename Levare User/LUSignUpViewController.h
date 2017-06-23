//
//  LUSignUpViewController.h
//  Levare User
//
//  Created by AngMac137 on 11/17/16.
//  Copyright © 2016 AngMac137. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LUSignUpViewController : UIViewController<EMCCountryDelegate>

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *myAlertLableArray;
@property (strong, nonatomic) NSString *gEmailString;
@end
