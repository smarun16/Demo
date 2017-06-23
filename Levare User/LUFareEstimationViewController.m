//
//  LUFareEstimationViewController.m
//  Levare User
//
//  Created by AngMac137 on 12/19/16.
//  Copyright © 2016 AngMac137. All rights reserved.
//

#import "LUFareEstimationViewController.h"
#import "LUPaymentOptionViewController.h"

@interface LUFareEstimationViewController ()

@property (strong, nonatomic) IBOutlet UIButton *myServiceButton;
@property (strong, nonatomic) IBOutlet UIView *myDetailsView;
@property (strong, nonatomic) IBOutlet UIImageView *myCarImageView;
@property (strong, nonatomic) IBOutlet UILabel *myAmountLabel;
@property (strong, nonatomic) IBOutlet UILabel *myKilometerLabel;
@property (strong, nonatomic) IBOutlet UILabel *myTimelabel;
@property (strong, nonatomic) IBOutlet UILabel *myCarCapacityLabel;

@property (strong, nonatomic) IBOutlet UIView *mySaveCardView;
@property (strong, nonatomic) IBOutlet UIButton *myChangeButton;
@property (strong, nonatomic) IBOutlet UILabel *myCardNoLabel;


@end

@implementation LUFareEstimationViewController

#pragma mark - View & Model -

#pragma mark -View Life Cycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // setup UI & Content
    [self setupUI];
    [self setupModel];
    
    // Load Contents
    [self loadModel];
}

#pragma mark -View Init

- (void)setupUI {
    
    [NAVIGATION setTitleWithBackButton:TITLE_FARE_ESTIMATE forViewController:self];
}

#pragma mark -Model

- (void)setupModel {
    
    [HELPER roundCornerForView:_mySearchSourceView withRadius:6 andBorderColor:LIGHT_GRAY_COLOUR];
    [HELPER roundCornerForView:_mySearchDistinationView withRadius:6 andBorderColor:LIGHT_GRAY_COLOUR];
    [HELPER roundCornerForView:_myDetailsView withRadius:6 andBorderColor:LIGHT_GRAY_COLOUR];
    [HELPER roundCornerForView:_mySaveCardView withRadius:6 andBorderColor:LIGHT_GRAY_COLOUR];
    [HELPER roundCornerForView:_mySearchSourceImageView withRadius:6];
    [HELPER roundCornerForView:_mySearchDistinationImageView withRadius:6];
    
    [HELPER getColorIgnoredImage:@"icon_fare_car" imageView:_myCarImageView color:[HELPER getColorFromHexaDecimal:COLOR_APP_PRIMARY]];
}

- (void)loadModel {
    
    _myAmountLabel.text = ([_gServiceTypeMutableArray[0][@"Is_Fixed_Fare"] isEqualToString:@"0"]) ? [_gServiceTypeMutableArray[0] valueForKey:@"Estimation_Cost"] :[NSString stringWithFormat:@"%@ (fixed fare)",_gServiceTypeMutableArray[0][@"Estimation_Cost"]];
    _myKilometerLabel.text = [_gServiceTypeMutableArray[0] valueForKey:@"Kilometer"];
    _myTimelabel.text = [_gServiceTypeMutableArray[0] valueForKey:@"Estimation_Time"];
    _myCarCapacityLabel.text = [NSString stringWithFormat:@"Max Size: %@ Peoples & min fare : $%@",_gPeopleCountString,[_gServiceTypeMutableArray[0] valueForKey:@"Minimum_Fare"]];
    [_myServiceButton setTitle:_myServiceType forState:UIControlStateNormal];
    
    
    if ([SESSION getCardInfo].count) {
        for (int i = 0; i < [SESSION getCardInfo].count; i++) {
            
            if ([[SESSION getCardInfo][i][@"Is_Active"] isEqualToString:@"1"]) {
                
                _myCardNoLabel.text = [HELPER resetCardNumberAsVisa:[SESSION getCardInfo][i][@"Credit_Card_Number"]];
            }
        }
        [_myChangeButton setTitle:@"Change" forState:UIControlStateNormal];
        
    }
    else {
        
        _myCardNoLabel.text  = @"Add Card";
        [_myChangeButton setTitle:@"Add" forState:UIControlStateNormal];
    }
    
    _mySearchSourceTextfield.text = _mySourseString;
    _mySearchDistinationTextfield.text = _myDestinationString;
    
    _mySearchSourceTextfield.userInteractionEnabled = NO;
    _mySearchDistinationTextfield.userInteractionEnabled = NO;
    
}

#pragma mark - UIButton methods -

-(void)leftBarButtonTapEvent {
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightBarButtonTapEvent {
    
}

- (IBAction)serviceButtonTapped:(id)sender {
    
}

- (IBAction)changeCardButtonTapped:(id)sender {
    
    LUPaymentOptionViewController *aViewController = [STORY_BOARD instantiateViewControllerWithIdentifier:@"LUPaymentOptionViewController"];
    aViewController.isForChangeCard = YES;
    aViewController.callBackBlock = ^(BOOL isCallBack, NSMutableArray * aMutableArray) {
        
        if (isCallBack) {
            
            _myCardNoLabel.text = [HELPER resetCardNumberAsVisa:aMutableArray[0][@"Credit_Card_Number"]];
            [_myChangeButton setTitle:@"Change" forState:UIControlStateNormal];
        }
        else {
            
            _myCardNoLabel.text  = @"Add Card";
            [_myChangeButton setTitle:@"Add" forState:UIControlStateNormal];
        }
    };
    UINavigationController *aNavigationController = [[UINavigationController alloc]initWithRootViewController:aViewController];
    [self.navigationController presentViewController:aNavigationController animated:YES completion:nil];
    
}

@end
