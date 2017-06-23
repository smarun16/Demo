
//
//  LUDashBoardViewController.h
//  Levare User
//
//  Created by AngMac137 on 11/22/16.
//  Copyright © 2016 AngMac137. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LUDashBoardViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView *myServiceImageView;
@property (strong, nonatomic) IBOutlet UILabel *myServiceNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *myServiceDetailLabel;
@property (strong, nonatomic) IBOutlet UIView *myServiceBgView;

@property (nonatomic) SearchTypeEnum  mySearchTypeEnum;

@end
