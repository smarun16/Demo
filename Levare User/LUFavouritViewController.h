//
//  LUFavouritViewController.h
//  Levare User
//
//  Created by AngMac137 on 12/5/16.
//  Copyright © 2016 AngMac137. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LUFavouritViewController : UIViewController

@property (nonatomic, copy) void (^callBackBlock)(BOOL iscallBack);
@property (nonatomic) BOOL isForDashBoardScreen;

@end
