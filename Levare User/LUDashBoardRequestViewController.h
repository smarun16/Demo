//
//  LUDashBoardRequestViewController.h
//  Levare User
//
//  Created by AngMac137 on 11/24/16.
//  Copyright © 2016 AngMac137. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LUDashBoardRequestViewController : UIViewController

@property (nonatomic) SearchTypeEnum  mySearchTypeEnum;
@property (nonatomic, strong) NSMutableArray *gMapMutableInfo, *myDriverInfoMutableArray, *myDriverRoutInfoMutableArray;
@property (nonatomic, strong) NSArray *gSearchInfoArray;
@property (nonatomic, strong) TagServiceType *gServiceTag;
@property (nonatomic) BOOL isFavSource, isFavDestination;

@property (strong, nonatomic) IBOutlet UIView *myBidBgView;
@property (strong, nonatomic) IBOutlet UIView *myBidView;
@property (strong, nonatomic) IBOutlet UILabel *myEstimatedfare;
@property (strong, nonatomic) IBOutlet UILabel *myBidTimeLabel;
@property (strong, nonatomic) IBOutlet UIView *myBidAmountView;
@property (strong, nonatomic) IBOutlet UIImageView *myBidPopImageView;
@property (strong, nonatomic) IBOutlet UITextField *myBidAmountTextfield;
@property (strong, nonatomic) IBOutlet UIButton *myBidSubmitButton;

@property (strong, nonatomic) IBOutlet UIView *myRequestView;
@property (strong, nonatomic) IBOutlet UIView *myRequestShareView;
@property (strong, nonatomic) IBOutlet UIImageView *myProfileImageView;
@property (strong, nonatomic) IBOutlet UILabel *myDriverNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *myRatingLabel;
@property (strong, nonatomic) IBOutlet UIView *myShareView;
@property (strong, nonatomic) IBOutlet UIView *myCancelView;
@property (strong, nonatomic) IBOutlet UIView *myCancelReasonView;
@property (strong, nonatomic) IBOutlet UIView *myNotificationView;
@property (strong, nonatomic) IBOutlet UIButton *myCallButton;
@property (strong, nonatomic) IBOutlet UIButton *myMessageButton;
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) IBOutlet UILabel *myCancelChargeLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *myRequestButtonHeightConstraint;
@property (strong, nonatomic) IBOutlet GMSMapView *myMapView;
@property (strong, nonatomic) NSString *gFavoriteDestinationIdString, *gfavoriteIdString;


@end
