//
//  LUPaymentOptionViewController.h
//  Levare User
//
//  Created by AngMac137 on 11/19/16.
//  Copyright © 2016 AngMac137. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LUPaymentOptionViewController : UIViewController

@property (nonatomic) BOOL isFromOTPScreen, isForChangeCard;
@property (nonatomic, copy) void (^callBackBlock)(BOOL iscallBack, NSMutableArray *aMutableArray);


@end
