//
//  LUInvoiceViewController.h
//  Levare User
//
//  Created by Arun Prasad.S, ANGLER - EIT on 30/12/16.
//  Copyright © 2016 AngMac137. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RatingView.h"
//#import "SignalR.h"
@class SignalR;
@class SRHubConnection;
@class SRHubProxy;

@interface LUInvoiceViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *myPaymentLabel;
@property (strong, nonatomic) IBOutlet UILabel *myAmountLabel;
@property (strong, nonatomic) IBOutlet UILabel *myBookingIdLabel;
@property (strong, nonatomic) IBOutlet UILabel *myRideTimePerKmLabel;
@property (strong, nonatomic) IBOutlet UILabel *myRideTimeLabel;
@property (strong, nonatomic) IBOutlet UIImageView *myDriverImageView;
@property (strong, nonatomic) IBOutlet RatingView *myRateView;
@property (strong, nonatomic) IBOutlet UIView *myRatingBgView;
@property (strong, nonatomic) IBOutlet UITextView *myFeedbackTextView;
@property (strong, nonatomic) IBOutlet UIButton *myContinueButton;
@property (weak, nonatomic) IBOutlet UITextField *myTipAmountTextfield;


@property (nonatomic, strong) NSMutableArray *gInfoArray;


@property (nonatomic, strong) NSString *gTripIdString, *gUserIdString, *myProfileUrl;
// SignalR
@property (nonatomic, strong)  SRHubConnection  *myHubConnection;
@property (nonatomic, strong)  SRHubProxy *myHubProxy;

@end
