//
//  LUFareEstimationViewController.h
//  Levare User
//
//  Created by AngMac137 on 12/19/16.
//  Copyright © 2016 AngMac137. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LUFareEstimationViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIView *mySearchView;

@property (strong, nonatomic) IBOutlet UIView *mySearchSourceView;
@property (strong, nonatomic) IBOutlet UITextField *mySearchSourceTextfield;
@property (strong, nonatomic) IBOutlet UIImageView *mySearchSourceImageView;

@property (strong, nonatomic) IBOutlet UIView *mySearchDistinationView;
@property (strong, nonatomic) IBOutlet UITextField *mySearchDistinationTextfield;
@property (strong, nonatomic) IBOutlet UIImageView *mySearchDistinationImageView;

@property (nonatomic, strong) NSMutableArray *gServiceTypeMutableArray;

@property (nonatomic, strong) NSString *mySourseString, *myDestinationString, *myServiceType, *gPeopleCountString;
@end
