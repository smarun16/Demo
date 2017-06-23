//
//  LUDashBoardRequestViewController.m
//  Levare User
//
//  Created by AngMac137 on 11/24/16.
//  Copyright © 2016 AngMac137. All rights reserved.
//

#import "LUDashBoardRequestViewController.h"
#import "CRPSampleLayout.h"
#import "LUFareEstimationViewController.h"
#import "LUShareViewController.h"
#import "LUFamilyAndFriendsViewController.h"

// Libraries
#import "SignalR.h"
#import "DGActivityIndicatorView.h"
#import "M13ProgressViewRing.h"
#import "SRLongPollingTransport.h"
#import "SRKeepAliveData.h"


#define MERCATOR_RADIUS 85445659.44705395
#define MAX_GOOGLE_LEVELS 20

@interface LUDashBoardRequestViewController ()<GMSAutocompleteViewControllerDelegate,CLLocationManagerDelegate,
GMSMapViewDelegate, UITextFieldDelegate, UIScrollViewDelegate>

{
    BOOL gettingAddressFromLatLng, isSignalRSetUp, isForFavLocation, isForOnGoingRequest, isInChatScreen;
    BOOL isDriverRoutDrawn, isFavChanged,isConnectionSlow, isMoveToInvoiceScreen, isRequestDeclined;
    NSInteger myDeltingLocation, myRequestDeclinedInteger;
    NSInteger myServiceID, myCancelIndex, myTripStatusIdInteger;
    NSInteger myEstimatedValue, myCurrentRequest;
    
    CLLocationCoordinate2D myLocationCoordinate;
    CLLocationManager *myLocationManager;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
    GMSPolyline *myRoutePolyLine; //your line
    MKPolylineRenderer *myRoutePolyLineView; //overlay view
    DGActivityIndicatorView *myDGActivityIndicatorView;
    GMSMarker *myUserMarker;
}

@property (strong, nonatomic) IBOutlet UIImageView *myClockImageView;
@property (strong, nonatomic) IBOutlet UIImageView *myPromotionImageView;
@property (strong, nonatomic) IBOutlet UIImageView *myBidImageView;
@property (strong, nonatomic) IBOutlet UIImageView *myCardImageView;
@property (strong, nonatomic) IBOutlet UILabel *mytimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *myAmountLabel;
@property (strong, nonatomic) IBOutlet UILabel *myPromotionLabel;
@property (strong, nonatomic) IBOutlet UILabel *myBidLabel;
@property (strong, nonatomic) IBOutlet UIView *myBgView;
@property (strong, nonatomic) IBOutlet UIView *myActivityIndicatorView;


@property (strong, nonatomic) IBOutlet UIView *mySearchView;

@property (strong, nonatomic) IBOutlet UIView *mySearchSourceView;
@property (strong, nonatomic) IBOutlet UITextField *mySearchSourceTextfield;
@property (strong, nonatomic) IBOutlet UIImageView *mySearchSourceImageView;

@property (strong, nonatomic) IBOutlet UIView *mySearchDistinationView;
@property (strong, nonatomic) IBOutlet UITextField *mySearchDistinationTextfield;
@property (strong, nonatomic) IBOutlet UIImageView *mySearchDistinationImageView;

@property (strong, nonatomic) IBOutlet UILabel *mySearchSourceLabel;
@property (strong, nonatomic) IBOutlet UILabel *mySearchDistinationLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *mySearchSourceViewBottomConstraint;

@property (strong, nonatomic) IBOutlet UIButton *mySubmitButton;
@property (strong, nonatomic) IBOutlet UIImageView *myMapAnnotationImageView;

@property (strong, nonatomic) IBOutlet UIButton *myDestinationFavButton;
@property (strong, nonatomic) IBOutlet UIButton *mySourceFavButton;
@property (strong, nonatomic) IBOutlet UIScrollView *myScrollView;
@property (strong, nonatomic) IBOutlet UIView *myNVLoadingView;
@property (strong, nonatomic) IBOutlet UIView *myRequestLoadingView;
@property (strong, nonatomic) IBOutlet UILabel *myTimerLabel;

@property (strong, nonatomic) IBOutlet UILabel *myBidAmountAlert;
@property (strong, nonatomic) IBOutlet UIView *myOnGoingLoadingView;
@property (weak, nonatomic) IBOutlet UILabel *loadingLabel;
@property (strong, nonatomic) IBOutlet M13ProgressViewRing *progressRing;
@property (strong, nonatomic) IBOutlet UIButton *myRequestLoadingButton;
@property (strong, nonatomic) IBOutlet UILabel *myRequestCancelLabel;

// Model
@property (nonatomic, strong) NSMutableArray *myInfoMutableArray;
@property (nonatomic, strong) NSMutableArray *myMapInfoArray, *myMapLocationMutableArray, *mySignalRConnectionMutableArray;
@property (nonatomic, strong) NSMutableArray *myServiceTypeMutableArray, *myServiceLocationTypeMutableArray, *myRideResponseMutableArray, *myCancelReasonMutableArray, *mySearchMutableInfo , *myMapLatLongMutableArray;
@property (nonatomic, strong) NSMutableDictionary *myInfoMutableDict, *myFavSourseMutableDictionary, *myCurrentFavMutableDict;
@property (nonatomic, strong) NSMutableDictionary *myFavDestMutableDictionary;



@property (nonatomic, strong) NSString *myAddressString,*myFavoritePrimaryLocation, *myCancelIdString;
@property (nonatomic, strong) NSString *myTripIdString, *myMobileNumberString, *myCancelCharge;
@property (nonatomic, strong) NSString *myBidAmountString, *myNearestVehicleResponseString, *myPromoCodeIdString;

// SignalR

@property (strong, nonatomic) SRHubConnection *myHubConnection;
@property (strong, nonatomic)  SRHubProxy *myHubProxy;

@end

@implementation LUDashBoardRequestViewController
@synthesize myHubProxy;
@synthesize isFavDestination, isFavSource;
@synthesize myDriverRoutInfoMutableArray;
@synthesize gFavoriteDestinationIdString, gfavoriteIdString;
@synthesize myAddressString,myFavoritePrimaryLocation, myCancelIdString;
@synthesize myTripIdString, myMobileNumberString, myCancelCharge;
@synthesize myBidAmountString, myNearestVehicleResponseString, myPromoCodeIdString;
@synthesize myInfoMutableDict, myFavSourseMutableDictionary, myCurrentFavMutableDict;
@synthesize myFavDestMutableDictionary;

#pragma mark - View & Model -

#pragma mark -View Life Cycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // setup UI & Content
    [self setupUI];
    [self setupModel];
}

-(void)viewWillAppear:(BOOL)animated {
    
    if ([SESSION isRequested] && ![SESSION isAlertShown])
        [self getOnGoingRequest];
    
    isMoveToInvoiceScreen = NO;
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshRequestTimer) name:NOTIFICATION_VIEW_UPADTE_FOR_REQUEST_TIMER object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshScreenBasedOnStatus) name:NOTIFICATION_VIEW_UPADTE_BASED_ON_REQUEST_STATUS_FROM_BACKGROUND object:nil];
    
    
    //  [self.myMapView addObserver:self forKeyPath:@"myLocation" options:0 context:nil];
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -View Init

- (void)setupUI {
    
    // To set navigation bar to present with navigation
    [_mySubmitButton setTitle:TWO_STRING(@"Request for", _gServiceTag.service_type_name) forState:UIControlStateNormal];
    
    [self setUpTapActionForView];
    
    [HELPER roundCornerForView:_mySearchSourceImageView withRadius:6];
    [HELPER roundCornerForView:_mySearchDistinationImageView withRadius:6];
    [HELPER roundCornerForView:_myBidView withRadius:6];
    [HELPER roundCornerForView:_myCancelReasonView withRadius:6];
    [HELPER roundCornerForView:_myBidAmountView withRadius:4 andBorderColor:[UIColor blackColor]];
    [HELPER roundCornerForView:_myProfileImageView];
    
    [self hideRequestLoadingView];
    
    [HELPER fadeAnimationFor:_myBidBgView alpha:0];
    [HELPER fadeAnimationFor:_myRequestView alpha:0];
    [HELPER fadeAnimationFor:_myRequestLoadingView alpha:0];
    _myMapView.hidden = YES;
    
    
    _mySearchSourceTextfield.delegate = self;
    _mySearchDistinationTextfield.delegate = self;
    
    myCurrentFavMutableDict = [NSMutableDictionary new];
    _myMapLatLongMutableArray = [NSMutableArray new];
    _myMapInfoArray= [NSMutableArray new];
    _myMapLocationMutableArray = [NSMutableArray new];
    
    _mySearchMutableInfo = [NSMutableArray new];
    _mySignalRConnectionMutableArray = [NSMutableArray new];
    _myServiceLocationTypeMutableArray = [NSMutableArray new];
    _myServiceTypeMutableArray = [NSMutableArray new];
    _myRideResponseMutableArray = [NSMutableArray new];
    _myCancelReasonMutableArray = [NSMutableArray new];
    
    _mySearchSourceViewBottomConstraint.constant = 0;
    
    _mySearchSourceTextfield.text = _gSearchInfoArray[0];
    _mySearchDistinationTextfield.text = _gSearchInfoArray[1];
    _mySourceFavButton.selected = isFavSource;
    _myDestinationFavButton.selected = isFavDestination;
    [_myMapView clear];
    
    if (_gSearchInfoArray.count) {
        
        [_mySearchMutableInfo addObject:_gSearchInfoArray[0]];
        [_mySearchMutableInfo addObject:_gSearchInfoArray[1]];
    }
}


-(void)viewDidDisappear:(BOOL)animated {
    
}


#pragma mark -Model

- (void)setupModel {
    
    myPromoCodeIdString = @"";
    _myTimerLabel.text = @"00:00";
    myFavSourseMutableDictionary = [NSMutableDictionary new];
    myFavDestMutableDictionary = [NSMutableDictionary new];
    _mySearchTypeEnum = SEARCH_TYPE_SOURCE;
    _mySourceFavButton.selected = isFavSource;
    _myDestinationFavButton.selected = isFavDestination;
    
    // Set text in textfield based on the search
    if (_mySearchTypeEnum == SEARCH_TYPE_SOURCE) {
        
        _myDestinationFavButton.hidden = YES;
        _mySourceFavButton.hidden = NO;
        _myDestinationFavButton.userInteractionEnabled = NO;
        _mySourceFavButton.userInteractionEnabled = YES;
        _mySearchSourceView.userInteractionEnabled = YES;
        _mySearchDistinationView.userInteractionEnabled = NO;
        _mySearchSourceView.backgroundColor = [UIColor clearColor];
        _mySearchDistinationView.backgroundColor = [HELPER getColorFromHexaDecimal:COLOR_GROUP_TABLE_VIEW];
    }
    else {
        
        _myDestinationFavButton.hidden = NO;
        _myDestinationFavButton.userInteractionEnabled = YES;
        _mySourceFavButton.userInteractionEnabled = NO;
        _mySourceFavButton.hidden = YES;
        _mySearchSourceView.userInteractionEnabled = NO;
        _mySearchDistinationView.userInteractionEnabled = YES;
        _mySearchSourceView.backgroundColor = [HELPER getColorFromHexaDecimal:COLOR_GROUP_TABLE_VIEW];
        _mySearchDistinationView.backgroundColor = [UIColor clearColor];
    }
    
    _mySubmitButton.userInteractionEnabled = YES;
    _mySubmitButton.backgroundColor = [UIColor blackColor];
    _myRequestLoadingButton.hidden = YES;
    _myRequestCancelLabel.hidden = YES  ;
    
    self.myMapView.delegate = self;
    self.myMapView.myLocationEnabled = YES;
    self.myMapView.settings.myLocationButton = NO;
    [self.myMapView setMapType:kGMSTypeNormal];
    
    myUserMarker = [GMSMarker new];
    
    
    myFavoritePrimaryLocation = myCancelCharge = @"";
    myTripIdString = @"";
    myTripStatusIdInteger = 0;
    myCancelIdString = myBidAmountString = myMobileNumberString = @"";
    _myBidAmountTextfield.delegate = self;
    
    geocoder = [[CLGeocoder alloc] init];
    
    [CLLocationManager locationServicesEnabled];
    myLocationManager = [[CLLocationManager alloc] init];
    myLocationManager.delegate = self;
    myLocationManager.distanceFilter = 1;
    [myLocationManager requestAlwaysAuthorization];
    myLocationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [myLocationManager startUpdatingLocation];
    
    if ([SESSION isRequested]) {
        
        [NAVIGATION setTitleWithBarButtonItems:APP_NAME forViewController:self showLeftBarButton:nil showRightBarButton:nil];
        [self.view bringSubviewToFront:_myOnGoingLoadingView];
        [HELPER fadeAnimationFor:_myOnGoingLoadingView alpha:1];
        _progressRing.tintColor = [HELPER getColorFromHexaDecimal:COLOR_APP_PRIMARY];
        _progressRing.indeterminate = YES;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getOnGoingRequest) name:VIEW_UPADTE_BASED_ON_REQUEST_STATUS object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeViewBasedOnFav:) name:VIEW_UPADTE_BASED_ON_FAV_STATUS object:nil];
        
        
    }
    else {
        
        [NAVIGATION setTitleWithBarButtonItems:_gServiceTag.service_type_name forViewController:self showLeftBarButton:IMAGE_BACK showRightBarButton:nil];
        
        [HELPER fadeAnimationFor:_myOnGoingLoadingView alpha:0];
    }
    // start signalR
    [self setUpSignalR];
}


#pragma mark - UITable view Delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _myCancelReasonMutableArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellIdentifier = @"CancelCell";
    
    UITableViewCell *aCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (aCell == nil) {
        
        aCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    UIImageView *gImageView = (UIImageView *)[aCell viewWithTag:10];
    UILabel *gTitleLabel = (UILabel *)[aCell viewWithTag:20];
    
    gTitleLabel.text = _myCancelReasonMutableArray[indexPath.row][@"Reason"];
    
    if (indexPath.row == myCancelIndex) {
        
        gTitleLabel.textColor = [HELPER getColorFromHexaDecimal:COLOR_APP_PRIMARY];
        gImageView.image = [UIImage imageNamed:ICON_SELECT];
    }
    else {
        
        gTitleLabel.textColor = [UIColor blackColor];
        gImageView.image = [UIImage imageNamed:ICON_UN_SELECTE];
    }
    return aCell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 10)];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [cell setLayoutMargins:UIEdgeInsetsMake(0, 10, 0, 10)];
    }
}

-(void)viewDidLayoutSubviews {
    
    if ([self.myTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.myTableView setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 10)];
    }
    
    if ([self.myTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.myTableView setLayoutMargins:UIEdgeInsetsMake(0, 10, 0, 10)];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    myCancelIndex = indexPath.row;
    
    [_myTableView reloadDataWithAnimation];
}

#pragma mark - TextField Delegates

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *aUpdateString=[textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (textField.tag == 100) {
        
        if (aUpdateString.length > 5)
            return NO;
        
        _myBidAmountAlert.text = @"Your bid amount cannot be less than 50% of estimated fare";
        _myBidAmountAlert.textColor = [UIColor lightGrayColor];
        myBidAmountString = aUpdateString;
    }
    
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    
    if (textField == _mySearchSourceTextfield) {
        
        _mySearchTypeEnum = SEARCH_TYPE_SOURCE;
        
        if (_mySearchSourceView.userInteractionEnabled == NO) {
            
            _mySearchSourceView.userInteractionEnabled = YES;
            _mySearchDistinationView.userInteractionEnabled = NO;
            _mySearchSourceView.backgroundColor = [UIColor clearColor];
            _mySearchDistinationView.backgroundColor = [HELPER getColorFromHexaDecimal:COLOR_GROUP_TABLE_VIEW];
            
            [UIView transitionWithView:self.view duration:5 options:UIViewAnimationOptionCurveEaseOut animations:^{
                
                // Set your final view position here
                
                if (_mySearchSourceTextfield.text.length) {
                    
                    _mySourceFavButton.selected = isFavSource;
                    _mySourceFavButton.hidden = NO;
                    _myDestinationFavButton.userInteractionEnabled = NO;
                    _mySourceFavButton.userInteractionEnabled = YES;
                }
                
                _myDestinationFavButton.hidden = YES;
                //[HELPER setCardViewEfforForView:_mySearchSourceView];
                //[HELPER removeCardViewEfforFromView:_mySearchDistinationView];
                
                [_mySearchView bringSubviewToFront:_mySearchSourceView];
                [_mySearchView bringSubviewToFront:_mySearchSourceImageView];
                [_mySearchView bringSubviewToFront:_mySearchSourceTextfield];
                [_mySearchView bringSubviewToFront:_mySourceFavButton];
                
            } completion:^(BOOL finished) {
                
            }];
            
            
            if (_myMapInfoArray.count >= 1) {
                
                NSArray *aLocationArray = [_myMapInfoArray[0] componentsSeparatedByString:@","];
                
                if (aLocationArray.count == 2) {
                    
                    myCurrentFavMutableDict[K_FAVORITE_LATITUDE] = aLocationArray[0];
                    myCurrentFavMutableDict[K_FAVORITE_LONGITUDE] = aLocationArray[1];
                    
                    myLocationCoordinate = CLLocationCoordinate2DMake([aLocationArray[0] doubleValue], [aLocationArray[1] doubleValue]);
                }
                
                [_gMapMutableInfo replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"%f,%f",myLocationCoordinate.latitude,myLocationCoordinate.longitude]];
                
                isForFavLocation = YES;
            }
            return NO;
        }
        else {
            
            [self showGMSAutocompleteViewController];
        }
    }
    else if (textField == _myBidAmountTextfield) {
        
        CGPoint bottomOffset = CGPointMake(0, self.myScrollView.contentSize.height - self.myScrollView.bounds.size.height);
        [self.myScrollView setContentOffset:bottomOffset animated:YES];
        
        return YES;
    }
    else {
        
        _mySearchTypeEnum = SEARCH_TYPE_DESTINATION;
        
        
        if (_mySearchDistinationView.userInteractionEnabled == NO) {
            
            _mySearchSourceView.userInteractionEnabled = NO;
            _mySearchDistinationView.userInteractionEnabled = YES;
            _mySearchSourceView.backgroundColor = [HELPER getColorFromHexaDecimal:COLOR_GROUP_TABLE_VIEW];
            _mySearchDistinationView.backgroundColor = [UIColor clearColor];
            
            [UIView transitionWithView:self.view duration:5 options:UIViewAnimationOptionCurveEaseOut animations:^{
                
                // Set your final view position here
                
                if (_mySearchDistinationTextfield.text.length) {
                    
                    _myDestinationFavButton.selected = isFavDestination;
                    _myDestinationFavButton.hidden = NO;
                    _myDestinationFavButton.userInteractionEnabled = YES;
                    _mySourceFavButton.userInteractionEnabled = NO;
                }
                _mySourceFavButton.hidden = YES;
                // [HELPER setCardViewEfforForView:_mySearchDistinationView];
                // [HELPER removeCardViewEfforFromView:_mySearchSourceView];
                
                [_mySearchView bringSubviewToFront:_mySearchDistinationView];
                [_mySearchView bringSubviewToFront:_mySearchDistinationImageView];
                [_mySearchView bringSubviewToFront:_mySearchDistinationTextfield];
                [_mySearchView bringSubviewToFront:_myDestinationFavButton];
                
            } completion:^(BOOL finished) {
                
            }];
            
            if (_myMapInfoArray.count > 1) {
                
                NSArray *aLocationArray = [_myMapInfoArray[1] componentsSeparatedByString:@","];
                
                if (aLocationArray.count == 2) {
                    
                    myCurrentFavMutableDict[K_FAVORITE_LATITUDE] = aLocationArray[0];
                    myCurrentFavMutableDict[K_FAVORITE_LONGITUDE] = aLocationArray[1];
                    
                    myLocationCoordinate = CLLocationCoordinate2DMake([aLocationArray[0] doubleValue], [aLocationArray[1] doubleValue]);
                }
                
                [_gMapMutableInfo replaceObjectAtIndex:1 withObject:[NSString stringWithFormat:@"%f,%f",myLocationCoordinate.latitude,myLocationCoordinate.longitude]];
                
                isForFavLocation = YES;
                
            }
            return NO;
        }
        else {
            
            [self showGMSAutocompleteViewController];
        }
    }
    
    
    return NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField.returnKeyType == UIReturnKeyNext) {
        
    }
    else {
        
        [self.view endEditing:YES];
    }
    
    return YES;
}

#pragma mark - UIButton methods -

-(void)leftBarButtonTapEvent {
    
    if (_mySearchSourceTextfield.text.length == 0) {
        
        _mySearchSourceTextfield.text = _mySearchMutableInfo[0];
    }
    if (_mySearchDistinationTextfield.text.length == 0) {
        
        _mySearchDistinationTextfield.text = _mySearchMutableInfo[1];
    }
    
    if ([SESSION isRequested] && isRequestStarted) {
        
        [[NSNotificationCenter defaultCenter] removeObserver:self  name:NOTIFICATION_VIEW_UPADTE_BASED_ON_CHAT_STATUS object:nil];
        
        
        [APPDELEGATE.sideMenu toggleDrawerSide:MMDrawerSideLeft animated:YES completion:^(BOOL finished) {
            
            NSMutableArray * aMutableArray = [NSMutableArray new];
            
            [aMutableArray addObject:_mySearchSourceTextfield.text];
            [aMutableArray addObject:_mySearchDistinationTextfield.text];
            [aMutableArray addObject:(isFavSource) ? @"1" : @"0"];
            [aMutableArray addObject:(isFavDestination) ? @"1" : @"0"];
            [aMutableArray addObject:_gMapMutableInfo[0]];
            [aMutableArray addObject:_gMapMutableInfo[1]];
            
            [SESSION setSearchInfo:aMutableArray];
        }];
        
    }
    else {
        
        
        isRequestDeclined = NO;
        [myTimer invalidate];
        myRequestDeclinedInteger = 0;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            if (_mySignalRConnectionMutableArray.count)
                [self goOffline];
            
            [SESSION setChatInfo:[NSMutableArray new]];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [_myHubConnection stop];
            });
        });
        
        NSMutableArray * aMutableArray = [NSMutableArray new];
        
        [aMutableArray addObject:_mySearchSourceTextfield.text];
        [aMutableArray addObject:_mySearchDistinationTextfield.text];
        [aMutableArray addObject:(isFavSource) ? @"1" : @"0"];
        [aMutableArray addObject:(isFavDestination) ? @"1" : @"0"];
        [aMutableArray addObject:_gMapMutableInfo[0]];
        [aMutableArray addObject:_gMapMutableInfo[1]];
        
        [SESSION setSearchInfo:aMutableArray];
        
        [self hideRequestLoadingView];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)rightBarButtonTapEvent {
    
}

- (IBAction)popUpBidButtonTapped:(id)sender {
    
    if (_myBidAmountTextfield.text.length == 0) {
        
        _myBidAmountAlert.text = @"Please enter your Bid amount";
        _myBidAmountAlert.textColor = [UIColor redColor];
        [HELPER shakeAnimationFor:_myBidAmountAlert callBack:^{
            
            [_myBidAmountTextfield becomeFirstResponder];
        }];
        return;
    }
    else if (_myBidAmountTextfield.text.integerValue < myEstimatedValue/2) {
        //Your bid amount cannot be less than 50% of estimated fare
        _myBidAmountAlert.textColor = [UIColor redColor];
        [HELPER shakeAnimationFor:_myBidAmountAlert callBack:^{
            
            [_myBidAmountTextfield becomeFirstResponder];
        }];
    }
    
    else {
        
        
        if (!_myServiceTypeMutableArray.count) {
            
            [HELPER showAlertView:self title:APP_NAME message:@"Wait for a while! We are fetching your nearest vehicles"];
            return;
        }
        
        [HELPER fadeAnimationFor:_myActivityIndicatorView alpha:0];
        [HELPER fadeAnimationFor:_myBidBgView alpha:0];
        
        _myRequestLoadingButton.hidden = YES;
        _myRequestCancelLabel.hidden = YES;
        [SESSION setChatInfo:[NSMutableArray new]];
        [self showRequestLoadingView];
        [SESSION isRequested:YES];
        [self requestForRide];
    }
}


- (IBAction)addAmountButtonTapped:(id)sender {
    
    if (_myServiceTypeMutableArray.count) {
        
        LUFareEstimationViewController *aViewController = [STORY_BOARD instantiateViewControllerWithIdentifier:@"LUFareEstimationViewController"];
        aViewController.mySourseString = _mySearchSourceTextfield.text;
        aViewController.myDestinationString = _mySearchDistinationTextfield.text;
        aViewController.gServiceTypeMutableArray = _myServiceTypeMutableArray;
        aViewController.myServiceType = _gServiceTag.service_type_name;
        aViewController.gPeopleCountString = _gServiceTag.vehicle_max_range;
        
        [self.navigationController pushViewController:aViewController animated:YES];
    }
}

- (IBAction)addPromotionButton:(id)sender {
    
    LUFavouritePopViewController * aViewController = [STORY_BOARD instantiateViewControllerWithIdentifier:@"LUFavouritePopViewController"];
    [aViewController setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    aViewController.isForPromoCode = YES;
    aViewController.promoCodeCallBackBlock =^(BOOL isCallBack, NSString *aString, NSString *aProString) {
        
        if (isCallBack) {
            
            myPromoCodeIdString = aString;
            _myPromotionLabel.text = aProString;
        }
    };
    
    // To present view controller on the top of all view controller with clear background
    [APPDELEGATE.window.rootViewController presentViewController:aViewController animated:YES completion:^{
        
    }];
}

- (IBAction)customerBidButtonTapped:(id)sender {
    
    [self.view bringSubviewToFront:_myBidBgView];
    [HELPER fadeAnimationFor:_myActivityIndicatorView alpha:0];
    [HELPER fadeAnimationFor:_myBidBgView alpha:1];
    [HELPER fadeAnimationFor:_myRequestView alpha:0];
    [HELPER fadeAnimationFor:_myCancelReasonView alpha:0];
    [HELPER fadeAnimationFor:_myBidView alpha:1];
    _myBidAmountTextfield.text = @"";
    
    _myBidBgView.userInteractionEnabled = YES;
    UITapGestureRecognizer *aGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(BidBgViewTapped)];
    aGesture.numberOfTapsRequired = 1;
    [_myBidBgView  addGestureRecognizer:aGesture];
    
}

-(void)BidBgViewTapped {
    
    if ([_myBidAmountTextfield isFirstResponder]) {
        
        [_myBidAmountTextfield resignFirstResponder];
    }
    else {
        
        [HELPER fadeAnimationFor:_myActivityIndicatorView alpha:0];
        [HELPER fadeAnimationFor:_myBidBgView alpha:0];
    }
}

- (IBAction)requestButtonTapped:(id)sender {
    
    if (_mySearchSourceTextfield.text.length == 0) {
        
        [HELPER showNotificationSuccessIn:self withMessage:@"Please choose your from location"];
        return;
    }
    
    else if (_mySearchDistinationTextfield.text.length == 0) {
        
        [HELPER showNotificationSuccessIn:self withMessage:@"Please choose your to location"];
        return;
    }
    else {
        
        
        if (!_myServiceTypeMutableArray.count) {
            
            [HELPER showAlertView:self title:APP_NAME message:@"Wait for a while! We are fetching your nearest vehicles"];
            return;
        }
        
        _myRequestLoadingButton.hidden = YES;
        _myRequestCancelLabel.hidden = YES;
        [SESSION setChatInfo:[NSMutableArray new]];
        [self hideRequestLoadingView];
        [self showRequestLoadingView];
        [SESSION isRequested:YES];
        [self requestForRide];
    }
}


- (IBAction)favSourceButtonTapped:(id)sender {
    
    if (isFavSource) {
        
        [self callDeleteWebService];
    }
    else {
        
        // To add the location as favorite
        [self addOrDeletebasedOnTheButtonStatus:YES];
    }
}
- (IBAction)favDescButtonTapped:(id)sender {
    
    if (isFavDestination) {
        
        [self callDeleteWebService];
    }
    else {
        
        [self addOrDeletebasedOnTheButtonStatus:NO];
    }
}


- (IBAction)messageButtonTapped:(id)sender {
    
    LUChatViewController *aViewController = [STORY_BOARD instantiateViewControllerWithIdentifier:@"LUChatViewController"];
    aViewController.gTripIdString = myTripIdString;
    aViewController.gUserIdString = (_mySignalRConnectionMutableArray.count) ? _mySignalRConnectionMutableArray[0][SR_USER_ID] : @"";
   // aViewController.myHubProxy = myHubProxy;
   //aViewController.myHubConnection = _myHubConnection;
    
    aViewController.callBackBlock = ^(BOOL isCallBack , BOOL isreqUestCancel) {
        
        
        if (isCallBack)
            [self setUpSignalR];
        
        if (isreqUestCancel) {
            
            [NAVIGATION setTitleWithBarButtonItems:_gServiceTag.service_type_name forViewController:self showLeftBarButton:IMAGE_BACK showRightBarButton:nil];
            [_mySubmitButton setTitle:[NSString stringWithFormat:@"Request for %@",_gServiceTag.service_type_name] forState:UIControlStateNormal];
            
            if (isForOnGoingRequest) {
                
                NSMutableArray * aMutableArray = [NSMutableArray new];
                
                [aMutableArray addObject:_mySearchSourceTextfield.text];
                [aMutableArray addObject:_mySearchDistinationTextfield.text];
                [aMutableArray addObject:(isFavSource) ? @"1" : @"0"];
                [aMutableArray addObject:(isFavDestination) ? @"1" : @"0"];
                [aMutableArray addObject:_gMapMutableInfo[0]];
                [aMutableArray addObject:_gMapMutableInfo[1]];
                
                [SESSION setSearchInfo:aMutableArray];
                
                [SESSION isRequested:NO];
                [HELPER navigateToMenuDetailScreen];
            }
            
            else {
                
                [HELPER fadeAnimationFor:_myBidBgView alpha:0];
                [HELPER fadeAnimationFor:_myActivityIndicatorView alpha:0];
                [HELPER fadeAnimationFor:_myRequestView alpha:0];
                [HELPER fadeAnimationFor:_myBgView alpha:1];
                _myRequestButtonHeightConstraint.constant = 45;
                [self hideRequestLoadingView];
                isInChatScreen = NO;
            }
        }
    };
    
    [myNearestTripTimer invalidate];
    isInChatScreen = YES;
    UINavigationController *aNavigationController = [[UINavigationController alloc]initWithRootViewController:aViewController];
    [self.navigationController presentViewController:aNavigationController animated:YES completion:nil];
    
}

- (IBAction)callButtonTapped:(id)sender {
    
    BOOL canCall = [HELPER callToNumber:myMobileNumberString];
    
    if (!canCall) {
        
        [HELPER showNotificationSuccessIn:self withMessage:@"No SIM card present"];
    }
}

- (IBAction)cancelReasonSubmitButtonTapped:(id)sender {
    
}

- (IBAction)cancelReasonCancelButtonTapped:(id)sender {
    
    
}
- (IBAction)cancelRequestButtonTapped:(id)sender {
    
    [HELPER fadeAnimationFor:_myBidBgView alpha:0];
    [HELPER fadeAnimationFor:_myCancelReasonView alpha:0];
    [HELPER fadeAnimationFor:_myRequestLoadingView alpha:0];
    
    [NAVIGATION setTitleWithBarButtonItems:_gServiceTag.service_type_name forViewController:self showLeftBarButton:IMAGE_BACK showRightBarButton:nil];
    
    // This is to set request in bidding (or) normal requesst
    myBidAmountString = @"";
    _myBidAmountTextfield.text = @"";
    
    //  if (myTripStatusIdInteger < 5) {
    
    myTripStatusIdInteger = SR_TRIP_BEFORE_CANCEL;
    
    [self cancelTrip];
    //  }
}

#pragma mark - GMSAUTO COMPLETE -

- (void)showGMSAutocompleteViewController {
    
    // To change favorite id based on the field for delete action
    
    if (_mySearchTypeEnum == SEARCH_TYPE_SOURCE) {
        
        _mySourceFavButton.selected = isFavSource;
        _mySourceFavButton.hidden = NO;
        _myDestinationFavButton.userInteractionEnabled = NO;
        _mySourceFavButton.userInteractionEnabled = YES;
    }
    else {
        
        _myDestinationFavButton.selected = isFavDestination;
        _myDestinationFavButton.hidden = NO;
        _myDestinationFavButton.userInteractionEnabled = YES;
        _mySourceFavButton.userInteractionEnabled = NO;
    }
    
    
    LUFavouriteSearchViewController * aViewController = [STORY_BOARD instantiateViewControllerWithIdentifier:@"LUFavouriteSearchViewController"];
    aViewController.gLocationCoordinate = _myMapView.myLocation.coordinate;
    aViewController.callBackBlock =^(BOOL isCallBack, NSMutableArray *aMutableArray){
        
        if (isCallBack) {
            
            isFavChanged = YES;
            // Do something with the selected place
            myLocationCoordinate = CLLocationCoordinate2DMake([[aMutableArray objectAtIndex:0][K_FAVORITE_LATITUDE] doubleValue], [[aMutableArray objectAtIndex:0][K_FAVORITE_LONGITUDE] doubleValue]);
            
            NSMutableDictionary *aMDictionary = [NSMutableDictionary new];
            
            aMDictionary[K_FAVORITE_LATITUDE] = [aMutableArray objectAtIndex:0][K_FAVORITE_LATITUDE];
            aMDictionary[K_FAVORITE_LONGITUDE] = [aMutableArray objectAtIndex:0][K_FAVORITE_LONGITUDE];
            aMDictionary[K_FAVORITE_ADDRESS] = [aMutableArray objectAtIndex:0][K_FAVORITE_ADDRESS];
            aMDictionary[K_FAVORITE_DISPLAY_NAME] = @"";
            aMDictionary[K_FAVORITE_PRIMARY_LOCATION] = @"";
            aMDictionary[K_FAVORITE_ID] = @"";
            
            myCurrentFavMutableDict[K_FAVORITE_LATITUDE] = aMutableArray[0][K_FAVORITE_LATITUDE];
            myCurrentFavMutableDict[K_FAVORITE_LONGITUDE] = aMutableArray[0][K_FAVORITE_LONGITUDE];
            myCurrentFavMutableDict[K_FAVORITE_ADDRESS] = [aMutableArray objectAtIndex:0][K_FAVORITE_ADDRESS];
            
            // Set text in textfield based on the search
            if (_mySearchTypeEnum == SEARCH_TYPE_SOURCE) {
                
                myFavSourseMutableDictionary = aMDictionary;
                _myDestinationFavButton.hidden = YES;
                _mySourceFavButton.hidden = NO;
                _myDestinationFavButton.userInteractionEnabled = NO;
                _mySourceFavButton.userInteractionEnabled = YES;
                _mySearchSourceView.userInteractionEnabled = YES;
                _mySearchDistinationView.userInteractionEnabled = NO;
                _mySearchSourceView.backgroundColor = [UIColor clearColor];
                _mySearchDistinationView.backgroundColor = [HELPER getColorFromHexaDecimal:COLOR_GROUP_TABLE_VIEW];
                _mySearchSourceTextfield.text = [aMutableArray objectAtIndex:0][K_FAVORITE_ADDRESS];
                
                [_gMapMutableInfo replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"%f,%f",myLocationCoordinate.latitude,myLocationCoordinate.longitude]];
            }
            else {
                
                myFavDestMutableDictionary = aMDictionary;
                _myDestinationFavButton.hidden = NO;
                _mySourceFavButton.hidden = YES;
                _myDestinationFavButton.userInteractionEnabled = YES;
                _mySourceFavButton.userInteractionEnabled = NO;
                _mySearchSourceView.userInteractionEnabled = NO;
                _mySearchDistinationView.userInteractionEnabled = YES;
                _mySearchSourceView.backgroundColor = [HELPER getColorFromHexaDecimal:COLOR_GROUP_TABLE_VIEW];
                _mySearchDistinationView.backgroundColor = [UIColor clearColor];
                _mySearchDistinationTextfield.text = [aMutableArray objectAtIndex:0][K_FAVORITE_ADDRESS];
                
                [_gMapMutableInfo replaceObjectAtIndex:1 withObject:[NSString stringWithFormat:@"%f,%f",myLocationCoordinate.latitude,myLocationCoordinate.longitude]];
            }
            
            isForFavLocation = YES;
            [self showLoadingActivityIndicator];
            [self getAddressFromLocation];
            [self zoomToLocation];
            [self getFareEstimation];
        }
        else {
            
            if (_mySearchTypeEnum == SEARCH_TYPE_SOURCE) {
                
                if (_mySearchSourceTextfield.text.length) {
                    
                    _mySourceFavButton.selected = isFavSource;
                    _mySourceFavButton.hidden = NO;
                    _myDestinationFavButton.userInteractionEnabled = NO;
                    _mySourceFavButton.userInteractionEnabled = YES;
                }
                else
                    _mySourceFavButton.hidden = YES;
            }
            else {
                
                if (_mySearchDistinationTextfield.text.length) {
                    
                    _myDestinationFavButton.selected = isFavDestination;
                    _myDestinationFavButton.hidden = NO;
                    _myDestinationFavButton.userInteractionEnabled = YES;
                    _mySourceFavButton.userInteractionEnabled = NO;
                }
                else
                    _myDestinationFavButton.hidden = YES;
            }
        }
    };
    UINavigationController *aNavigationController = [[UINavigationController alloc]initWithRootViewController:aViewController];
    [self.navigationController presentViewController:aNavigationController animated:YES completion:nil];
    
    
}


#pragma mark - Map View Delegate -

-(BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker {
    
    return YES;
}

#pragma mark - Location Delegate -

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
    
    if (locations.count) {
        
        CLLocation *aLocation = locations[0];
        
        // This is method is getting called as soon as screen is loaded but the lat lng is incorrect, its not user location so below code is a workaround
        if (aLocation.coordinate.longitude == -40.0) {
            return;
        }
        
        [manager stopUpdatingLocation];
        
        isForFavLocation = YES;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self getAddressFromLocation];
            [self zoomToLocation];
            [HELPER removeLoadingIn:self];
        });
    }
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    
    NSLog(@"locationError - %@", [error description]);
    
    [manager stopUpdatingLocation];
    
    [self hideLoadingActivityIndicator];
    [HELPER removeLoadingIn:self];
    [HELPER showRetryAlertIn:self details:ALERT_UNABLE_TO_FETCH_LOCATION_DICT retryBlock:^{
        
        [HELPER showLoadingIn:self text:@"Fetching your location"];
        [HELPER removeRetryAlertIn:self];
        
        [manager startUpdatingLocation];
    }];
}

#pragma mark - Web Service -

- (void)callDeleteWebService {
    
    // http://192.168.0.48/PPTCustomer/API/CustomerFavourites/DeleteFavourites?StrJson={"Favourites_Info":{"Fav_Id":"11","Customer_Id":"49"} }
    
    if (![HTTPMANAGER isNetworkRechable]) {
        
        NSMutableDictionary *aDictAlert = [NSMutableDictionary new];
        
        aDictAlert[KEY_ALERT_TITLE]  = SCREEN_TITLE_DASHBOARD;
        aDictAlert[KEY_ALERT_DESC]  = [NSString stringWithFormat:@"%@. Tap to try again",ALERT_NO_INTERNET_DESC];
        aDictAlert[KEY_ALERT_IMAGE]  = @"icon_no_internet";
        
        // List is empty so show 'Tap to retry' view
        [HELPER showRetryAlertIn:self details:aDictAlert retryBlock:^{
            
            if ([HTTPMANAGER isNetworkRechable]) {
                
                [HELPER removeRetryAlertIn:self];
                [HELPER removeLoadingIn:self];
                [self callDeleteWebService];
            }
        }];
        return;
    }
    
    NSMutableDictionary *aMutableDict = [NSMutableDictionary new];
    NSMutableDictionary *aLoginMutableDict = [NSMutableDictionary new];
    NSMutableDictionary *aParameterMutableDict = [NSMutableDictionary new];
    
    aMutableDict[K_FAVORITE_ID] = (_mySearchTypeEnum == SEARCH_TYPE_SOURCE) ? gfavoriteIdString : gFavoriteDestinationIdString;
    aMutableDict[K_CUSTOMER_ID] = [SESSION getUserInfo][0][K_CUSTOMER_ID];
    
    aLoginMutableDict[@"Favourites_Info"] = aMutableDict;
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:aLoginMutableDict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *string = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    aParameterMutableDict[@"StrJson"] = string;
    
    [HELPER showLoadingIn:self];
    
    [HTTPMANAGER deleteFavoriteType:aParameterMutableDict primaryLocatio:myFavoritePrimaryLocation completedBlock:^(NSDictionary *response) {
        
        if ([response[kRESPONSE][kRESPONSE_CODE] intValue] == kSUCCESS_CODE) {
            
            if (_mySearchTypeEnum == SEARCH_TYPE_SOURCE) {
                
                isFavSource = NO;
                _mySourceFavButton.selected = isFavSource;
                _myDestinationFavButton.userInteractionEnabled = NO;
                _mySourceFavButton.userInteractionEnabled = YES;
            }
            else {
                
                isFavDestination = NO;
                _myDestinationFavButton.selected = isFavDestination;
                _myDestinationFavButton.userInteractionEnabled = YES;
                _mySourceFavButton.userInteractionEnabled = NO;
            }
        }
        else if ([response[kRESPONSE][kRESPONSE_CODE] intValue] == K_NO_DATA_CODE || [response[kRESPONSE][kRESPONSE_CODE] intValue] == k_BAD_REQUEST) {
            
            if (_mySearchTypeEnum == SEARCH_TYPE_SOURCE) {
                
                isFavSource = NO;
                _mySourceFavButton.selected = isFavSource;
                _myDestinationFavButton.userInteractionEnabled = NO;
                _mySourceFavButton.userInteractionEnabled = YES;
            }
            else {
                
                isFavDestination = NO;
                _myDestinationFavButton.selected = isFavDestination;
                _myDestinationFavButton.userInteractionEnabled = YES;
                _mySourceFavButton.userInteractionEnabled = NO;
            }
            
        }
        else
            [HELPER showNotificationSuccessIn:self withMessage:response[kRESPONSE][kRESPONSE_MESSAGE]];
        
        [HELPER removeLoadingIn:self];
        
    } failedBlock:^(NSError *error) {
        
        [HELPER showNotificationSuccessIn:self withMessage:MESSAGE_SOMETHING_WENT_WRONG];
        [HELPER removeLoadingIn:self];
    }];
}

- (void)fetchPolylineWithCompletionHandler:(void (^)(GMSPolyline *aGMSPolyline))completionHandler  failedBlock:(void (^)(NSError *error))failedBlock {
    
    if (![HTTPMANAGER isNetworkRechable]) {
        
        NSMutableDictionary *aDictAlert = [NSMutableDictionary new];
        
        aDictAlert[KEY_ALERT_TITLE]  = SCREEN_TITLE_DASHBOARD;
        aDictAlert[KEY_ALERT_DESC]  = [NSString stringWithFormat:@"%@. Tap to try again",ALERT_NO_INTERNET_DESC];
        aDictAlert[KEY_ALERT_IMAGE]  = @"icon_no_internet";
        
        // List is empty so show 'Tap to retry' view
        [HELPER showRetryAlertIn:self details:aDictAlert retryBlock:^{
            
            if ([HTTPMANAGER isNetworkRechable]) {
                
                [HELPER removeRetryAlertIn:self];
                [HELPER removeLoadingIn:self];
                [self fetchPolylineWithCompletionHandler:^(GMSPolyline *aGMSPolyline) {
                    
                    // To draw a Route
                    myRoutePolyLine = aGMSPolyline;
                    
                    myRoutePolyLine.strokeColor = [UIColor redColor];
                    myRoutePolyLine.strokeWidth = 2.0f;
                    myRoutePolyLine.map = self.myMapView;
                    
                    [_myMapView reloadInputViews];
                    
                } failedBlock:^(NSError *error) {
                    
                }];
            }
        }];
        return;
    }
    
    NSString *originString = [NSString stringWithFormat:@"%f,%f", [[_gMapMutableInfo[0] componentsSeparatedByString:@","][0] doubleValue], [[_gMapMutableInfo[0] componentsSeparatedByString:@","][1] doubleValue]];
    NSString *destinationString = [NSString stringWithFormat:@"%f,%f", [[_gMapMutableInfo[1] componentsSeparatedByString:@","][0] doubleValue], [[_gMapMutableInfo[1] componentsSeparatedByString:@","][1] doubleValue]];
    
    NSString *directionsAPI = @"https://maps.googleapis.com/maps/api/directions/json?";
    NSString *directionsUrlString = [NSString stringWithFormat:@"%@&origin=%@&destination=%@&mode=driving", directionsAPI, originString, destinationString];
    NSURL *directionsUrl = [NSURL URLWithString:directionsUrlString];
    
    
    NSURLSessionDataTask *fetchDirectionsTask = [[NSURLSession sharedSession] dataTaskWithURL:directionsUrl completionHandler:
                                                 ^(NSData *data, NSURLResponse *response, NSError *error)
                                                 {
                                                     NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                                                     
                                                     if(error) {
                                                         
                                                         if(completionHandler)
                                                             completionHandler(nil);
                                                         
                                                         failedBlock(error);
                                                         
                                                         return;
                                                     }
                                                     
                                                     NSArray *routesArray = [json objectForKey:@"routes"];
                                                     
                                                     __block GMSPolyline *polyline = nil;
                                                     if ([routesArray count] > 0)
                                                     {
                                                         NSDictionary *routeDict = [routesArray objectAtIndex:0];
                                                         NSDictionary *routeOverviewPolyline = [routeDict objectForKey:@"overview_polyline"];
                                                         NSString *points = [routeOverviewPolyline objectForKey:@"points"];
                                                         
                                                         dispatch_async(dispatch_get_main_queue(), ^{
                                                             
                                                             GMSPath *path = [GMSPath pathFromEncodedPath:points];
                                                             
                                                             polyline = [GMSPolyline polylineWithPath:path];
                                                             
                                                             NSLog(@"polyline %@", polyline);
                                                             
                                                             completionHandler(polyline);
                                                             
                                                         });
                                                         
                                                     }
                                                     
                                                     /*if(completionHandler)
                                                      completionHandler(polyline);*/
                                                 }];
    [fetchDirectionsTask resume];
}

- (void)fetchPolylineFromDriverLocationWithCompletionHandler:(void (^)(GMSPolyline *aGMSPolyline))completionHandler  failedBlock:(void (^)(NSError *error))failedBlock {
    
    if (![HTTPMANAGER isNetworkRechable]) {
        
        NSMutableDictionary *aDictAlert = [NSMutableDictionary new];
        
        aDictAlert[KEY_ALERT_TITLE]  = SCREEN_TITLE_DASHBOARD;
        aDictAlert[KEY_ALERT_DESC]  = [NSString stringWithFormat:@"%@. Tap to try again",ALERT_NO_INTERNET_DESC];
        aDictAlert[KEY_ALERT_IMAGE]  = @"icon_no_internet";
        
        // List is empty so show 'Tap to retry' view
        [HELPER showRetryAlertIn:self details:aDictAlert retryBlock:^{
            
            if ([HTTPMANAGER isNetworkRechable]) {
                
                [HELPER removeRetryAlertIn:self];
                [HELPER removeLoadingIn:self];
                [self fetchPolylineWithCompletionHandler:^(GMSPolyline *aGMSPolyline) {
                    
                    // To draw a Route
                    myRoutePolyLine = aGMSPolyline;
                    
                    myRoutePolyLine.strokeColor = [UIColor redColor];
                    myRoutePolyLine.strokeWidth = 2.0f;
                    myRoutePolyLine.map = self.myMapView;
                    
                    [_myMapView reloadInputViews];
                    
                } failedBlock:^(NSError *error) {
                    
                }];
            }
        }];
        return;
    }
    
    NSString *originString = [NSString stringWithFormat:@"%f,%f", [[myDriverRoutInfoMutableArray[0] componentsSeparatedByString:@","][0] doubleValue], [[myDriverRoutInfoMutableArray[0] componentsSeparatedByString:@","][1] doubleValue]];
    NSString *destinationString = [NSString stringWithFormat:@"%f,%f", [[myDriverRoutInfoMutableArray[1] componentsSeparatedByString:@","][1] doubleValue], [[myDriverRoutInfoMutableArray[1] componentsSeparatedByString:@","][0] doubleValue]];
    
    NSString *directionsAPI = @"https://maps.googleapis.com/maps/api/directions/json?";
    NSString *directionsUrlString = [NSString stringWithFormat:@"%@&origin=%@&destination=%@&mode=driving", directionsAPI, originString, destinationString];
    NSURL *directionsUrl = [NSURL URLWithString:directionsUrlString];
    
    
    NSURLSessionDataTask *fetchDirectionsTask = [[NSURLSession sharedSession] dataTaskWithURL:directionsUrl completionHandler:
                                                 ^(NSData *data, NSURLResponse *response, NSError *error)
                                                 {
                                                     NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                                                     if(error)
                                                     {
                                                         if(completionHandler)
                                                             completionHandler(nil);
                                                         
                                                         failedBlock(error);
                                                         
                                                         return;
                                                     }
                                                     
                                                     NSArray *routesArray = [json objectForKey:@"routes"];
                                                     
                                                     __block GMSPolyline *polyline = nil;
                                                     if ([routesArray count] > 0)
                                                     {
                                                         NSDictionary *routeDict = [routesArray objectAtIndex:0];
                                                         NSDictionary *routeOverviewPolyline = [routeDict objectForKey:@"overview_polyline"];
                                                         NSString *points = [routeOverviewPolyline objectForKey:@"points"];
                                                         
                                                         dispatch_async(dispatch_get_main_queue(), ^{
                                                             
                                                             GMSPath *path = [GMSPath pathFromEncodedPath:points];
                                                             
                                                             polyline = [GMSPolyline polylineWithPath:path];
                                                             
                                                             NSLog(@"polyline %@", polyline);
                                                             
                                                             completionHandler(polyline);
                                                             
                                                         });
                                                         
                                                     }
                                                     
                                                     /*if(completionHandler)
                                                      completionHandler(polyline);*/
                                                 }];
    [fetchDirectionsTask resume];
}


#pragma mark - SignalR -

static NSTimer *myNearestTripTimer, *connectionTimer;

-(void)setUpSignalR {
    
    if (_myHubConnection == nil) {
        
        // Connect to the service
        _myHubConnection = [SRHubConnection connectionWithURLString:vHUB_URL];
        // Create a proxy to the chat service
        myHubProxy = [_myHubConnection createHubProxy:vHUB_PROXY];
        _myHubConnection.transportConnectTimeout = [NSNumber numberWithInteger:36000];
        _myHubConnection.keepAliveData = [[SRKeepAliveData alloc] initWithTimeout:[NSNumber numberWithInteger:36000]];
        
        
        [_myHubConnection start:[[SRLongPollingTransport alloc] init]];
        
        [self initHubListeners];
        [self startHubConnection];
        isSignalRSetUp = YES;
        
        [myHubProxy on:@"receiveTripStatus" perform:self selector:@selector(changeStatusBasedOnRequest:)];
        [myHubProxy on:@"receiveTripId" perform:self selector:@selector(getTripId:)];
        [myHubProxy on:@"receiveCancelTrip" perform:self selector:@selector(receiveCancelTrip:)];
        [myHubProxy on:@"receiveChatMessage" perform:self selector:@selector(getChatList:)];
        [myHubProxy on:@"receiveDriverLocation" perform:self selector:@selector(getDriverLocation:)];
        
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            if ([SESSION isRequested] && isRequestStarted == NO)
                [self getOnGoingRequest];
            
            
            myNearestTripTimer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(getNearestVehiclesList) userInfo:nil repeats:YES];
        });
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startHubConnection) name:UIApplicationWillEnterForegroundNotification object:nil];
    }
}

-(void)initHubListeners {
    
    // Register for connection lifecycle events
    [_myHubConnection setStarted:^{
        
        NSLog(@"Connection Started");
        
        NSArray *aArray = [NSArray new];
        
        aArray = @[[SESSION getUserInfo][0][K_CUSTOMER_ID],SR_CUSTOMER_TYPE];
        
        
        __block SRHubProxy *aHub;
        
        aHub = myHubProxy;
        
        [aHub invoke:SR_GO_ONLINE withArgs:aArray completionHandler:^(id response, NSError *error) {
            
            if (!error) {
                
                if (![response isKindOfClass:[NSDictionary class]]) {
                    
                    NSData *data = [response dataUsingEncoding:NSUTF8StringEncoding];
                    id aJsonId = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                    
                    if ([aJsonId[kRESPONSE][kRESPONSE_CODE] intValue] == kSUCCESS_CODE) {
                        
                        _mySignalRConnectionMutableArray = [NSMutableArray new];
                        _mySignalRConnectionMutableArray = [aJsonId objectForKey:@"Connection_Info"];
                        
                        if (_gMapMutableInfo.count || _myMapLatLongMutableArray.count)
                            [self getFareEstimation];
                    }
                    
                    else if ([response[kRESPONSE][kRESPONSE_CODE] intValue] == k_BAD_REQUEST) {
                        
                        [HELPER showNotificationSuccessIn:self withMessage:aJsonId[kRESPONSE][kRESPONSE_MESSAGE]];
                    }
                    else {
                        
                        [HELPER showNotificationSuccessIn:self withMessage:aJsonId[kRESPONSE][kRESPONSE_MESSAGE]];
                        
                        [TestFairy sendUserFeedback:[NSString stringWithFormat:@"case --- %@ parameter --  %@ response -- %@",SR_GO_ONLINE,aArray ,aJsonId]];
                        
                    }
                }
            }
            else {
                
                [TestFairy sendUserFeedback:[NSString stringWithFormat:@"case --- %@ parameter --  %@ response -- %@",SR_GO_ONLINE,aArray ,error]];
                
                if (error.code == NSURLErrorTimedOut)
                    [HELPER showRetryAlertIn:self details:ALERT_SIGNALR_UNABLE_TO_REACH_DICT retryBlock:^{
                        
                        if ([HTTPMANAGER isNetworkRechable]) {
                            
                            [HELPER removeRetryAlertIn:self];
                            [HELPER showLoadingIn:self];
                            [self initHubListeners];
                        }
                    }];
                else {
                    
                    [HELPER showNotificationSuccessIn:self withMessage:MESSAGE_SOMETHING_WENT_WRONG];
                }
            }
        }];
    }];
    
    static NSInteger aStatusIdInteger;
    
    [_myHubConnection setReceived:^(NSString *message) {
        
        NSLog(@"Connection Received %@",message);
        
        
        if ([[message valueForKey:@"M"] isEqualToString:@"receiveTripStatus"]) {
            
            
            NSString *aDict = [message valueForKey:@"A"][0];
            
            NSData *data = [aDict dataUsingEncoding:NSUTF8StringEncoding];
            id aJsonId = [NSJSONSerialization JSONObjectWithData:[data copy] options:0 error:nil];
            
            if ([aJsonId[kRESPONSE][kRESPONSE_CODE] intValue] == kSUCCESS_CODE) {
                
                aStatusIdInteger = [[aJsonId objectForKey:SR_TRIP_STATUS_ID] integerValue];
            }
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                if (aStatusIdInteger < myTripStatusIdInteger) {
                    
                    [self getOnGoingRequest];
                }
            });
        }
    }];
    
    [_myHubConnection setConnectionSlow:^{
        NSLog(@"Connection Slow");
        
        if (!isConnectionSlow) {
            
            [HELPER showAlertView:self title:APP_NAME message:MESSAGE_SOMETHING_WENT_WRONG okButtonBlock:^(UIAlertAction *action) {
                isConnectionSlow = YES;
            }];
        }
    }];
    
    [_myHubConnection setReconnecting:^{
        NSLog(@"Connection Reconnecting");
    }];
    
    [_myHubConnection setReconnected:^{
        
        NSLog(@"Connection Reconnected");
    }];
    
    [_myHubConnection setClosed:^{
        NSLog(@"Connection Closed");
        
        [_myHubConnection setStarted:^{
            
            NSLog(@"Connection Started");
            
            NSArray *aArray = [NSArray new];
            
            aArray = @[[SESSION getUserInfo][0][K_CUSTOMER_ID],SR_CUSTOMER_TYPE];
            
            
            __block SRHubProxy *aHub;
            
            aHub = myHubProxy;
            
            [aHub invoke:SR_GO_ONLINE withArgs:aArray completionHandler:^(id response, NSError *error) {
                
                if (!error) {
                    
                    if (![response isKindOfClass:[NSDictionary class]]) {
                        
                        NSData *data = [response dataUsingEncoding:NSUTF8StringEncoding];
                        id aJsonId = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                        
                        if ([aJsonId[kRESPONSE][kRESPONSE_CODE] intValue] == kSUCCESS_CODE) {
                            
                            _mySignalRConnectionMutableArray = [NSMutableArray new];
                            _mySignalRConnectionMutableArray = [aJsonId objectForKey:@"Connection_Info"];
                        }
                        
                        else if ([response[kRESPONSE][kRESPONSE_CODE] intValue] == k_BAD_REQUEST) {
                            
                        }
                        else {
                            
                        }
                    }
                }
                else {
                    
                }
            }];
        }];
        
        if (myCurrentRequest == SR_ON_GOINIG_REQUEST) {
            
            [self getOnGoingRequest];
        }
        else if (myCurrentRequest == SR_RIDE_REQUEST) {
            
            
            if (!_myServiceTypeMutableArray.count) {
                
                [HELPER showAlertView:self title:APP_NAME message:@"Wait for a while! We are fetching your nearest vehicles"];
                return;
            }
            
            [self requestForRide];
        }
        else if (myCurrentRequest == SR_GET_FARE_ESTIMATION_REQUEST) {
            
            [self getFareEstimation];
        }
        else if (myCurrentRequest == SR_GET_NEAREST_VEHICLE_REQUEST) {
            
            [self getNearestVehiclesList];
        }
        else if (myCurrentRequest == SR_OFFLINE_REQUEST) {
            
            [self goOffline];
        }
        else if (myCurrentRequest == SR_CANCEL_TRIP_REQUEST) {
            
            [self cancelTrip];
        }
    }];
    
    [_myHubConnection setError:^(NSError *error) {
        
        NSLog(@"Connection Error %@",error);
    }];
}

- (void)startHubConnection {
    
    if (_myHubConnection) {
        // Start the connection
        [_myHubConnection start];
    }
    NSLog(@"Trying to start connection");
}


static bool isRequestStarted, isStatusChanged;

-(void)getOnGoingRequest {
    
    
    myCurrentRequest = SR_ON_GOINIG_REQUEST;
    
    NSArray *aArray = [NSArray new];
    
    aArray = [NSArray arrayWithObjects:[SESSION getUserInfo][0][K_CUSTOMER_ID],SR_CUSTOMER_TYPE, nil];
    
    [myHubProxy invoke:SR_GET_ON_GOING_REQUEST withArgs:aArray completionHandler:^(id response, NSError *error) {
        
        if (!error) {
            
            if (![response isKindOfClass:[NSDictionary class]]) {
                
                NSData *data = [response dataUsingEncoding:NSUTF8StringEncoding];
                id aJsonId = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                
                if ([aJsonId[kRESPONSE][kRESPONSE_CODE] intValue] == kSUCCESS_CODE) {
                    
                    if (isInChatScreen)
                        [self dismissViewControllerAnimated:YES completion:nil];
                    
                    isRequestStarted = YES;
                    isForOnGoingRequest = YES;
                    myTripStatusIdInteger = [[aJsonId[@"Trip_Info"] objectForKey:SR_TRIP_STATUS_ID] integerValue];
                    
                    if (myTripStatusIdInteger != 8) {
                        
                        NSMutableDictionary *aMutableDict = [NSMutableDictionary new];
                        _gMapMutableInfo = [NSMutableArray new];
                        _myRideResponseMutableArray = [NSMutableArray new];
                        
                        aMutableDict = [aJsonId[@"Trip_Info"] objectForKey:@"Ride_Response"];
                        myTripIdString = [aMutableDict valueForKey:@"Request_Id"];
                        
                        if (_gServiceTag == nil) {
                            
                            _gServiceTag = [TagServiceType new];
                            _gServiceTag.service_type_name = aMutableDict[@"Service_Name"];
                            _gServiceTag.service_type_id = aMutableDict[@"Service_Id"];
                        }
                        
                        if (myTripIdString.length) {
                            
                            [self getAllChatList];
                            _myRequestLoadingButton.hidden = NO;
                            _myRequestCancelLabel.hidden = NO;
                        }
                        
                        myCancelCharge = [aJsonId[@"Trip_Info"] valueForKey:@"Cancellation_Msg"];
                        [SESSION isAlertShown:NO];
                        
                        if (aMutableDict.count)
                            [_myRideResponseMutableArray addObject:aMutableDict];
                        
                        if (_myRideResponseMutableArray.count) {
                            
                            [NAVIGATION setTitleWithBarButtonItems:_gServiceTag.service_type_name forViewController:self showLeftBarButton:IMAGE_BACK showRightBarButton:nil];
                            [_mySubmitButton setTitle:[NSString stringWithFormat:@"Request for %@",_gServiceTag.service_type_name] forState:UIControlStateNormal];
                            
                            // For ref. From_Longitude & From_Latitude are replaced as per the web service request
                            
                            [_gMapMutableInfo addObject:[NSString stringWithFormat:@"%@,%@",_myRideResponseMutableArray[0][@"From_Longitude"],_myRideResponseMutableArray[0][@"From_Latitude"]]];
                            [_gMapMutableInfo addObject:[NSString stringWithFormat:@"%@,%@",_myRideResponseMutableArray[0][@"To_Longitude"],_myRideResponseMutableArray[0][@"To_Latitude"]]];
                            
                            _mySearchSourceTextfield.text = _myRideResponseMutableArray[0][@"From_Location"];
                            _mySearchDistinationTextfield.text = _myRideResponseMutableArray[0][@"To_Location"];
                            
                            NSArray *aLocationArray = [_gMapMutableInfo[0] componentsSeparatedByString:@","];
                            
                            if (aLocationArray.count == 2) {
                                
                                myCurrentFavMutableDict[K_FAVORITE_LATITUDE] = aLocationArray[0];
                                myCurrentFavMutableDict[K_FAVORITE_LONGITUDE] = aLocationArray[1];
                                
                            }
                            
                            [self setFavoriteBasedOnSelectedAddress:nil];
                            
                            // The below method are done to clear the marker & add new marker with rout.
                            [_myMapView clear];
                            [_myMapView reloadInputViews];
                            self.myMapView.delegate = self;
                            self.myMapView.myLocationEnabled = YES;
                            self.myMapView.settings.myLocationButton = NO;
                            [self.myMapView setMapType:kGMSTypeNormal];
                            
                        }
                        
                        // {
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_VIEW_UPADTE_BASED_ON_REQUEST_STATUS object:nil userInfo:[NSDictionary dictionaryWithObject:response forKey:NOTIFICATION_REQUEST_STATUS_KEY]];
                        
                        [self hideRequestLoadingView];
                        
                        if (myTripStatusIdInteger == SR_TRIP_REQUEST) {
                            
                            //   [self.view bringSubviewToFront:_myBgView];
                            [HELPER fadeAnimationFor:_myBidBgView alpha:0];
                            [HELPER fadeAnimationFor:_myActivityIndicatorView alpha:0];
                            [HELPER fadeAnimationFor:_myRequestView alpha:0];
                            [HELPER fadeAnimationFor:_myBgView alpha:1];
                            _myRequestButtonHeightConstraint.constant = 45;
                            
                            [SESSION setChatInfo:[NSMutableArray new]];
                            isRequestStarted = YES;
                            [self showRequestLoadingView];
                            [SESSION isAlertShown:YES];
                            [self addCarLocation];
                        }
                        else if (myTripStatusIdInteger == -1) {
                            
                            // Change view Based On ride response
                            [self changeViewBasedOnRide];
                            [SESSION isAlertShown:YES];
                            [SESSION isRequested:NO];
                            [HELPER navigateToMenuDetailScreen];
                        }
                        
                        else if (myTripStatusIdInteger == SR_TRIP_BEFORE_CANCEL || myTripStatusIdInteger == SR_TRIP_AFTER_CANCEL) {
                            
                            [HELPER showAlertView:self title:SCREEN_TITLE_DASHBOARD message:aJsonId[@"Trip_Info"][@"Trip_Status_Message"] okButtonBlock:^(UIAlertAction *action) {
                                
                                // Change view Based On ride response
                                [self changeViewBasedOnRide];
                                [SESSION isAlertShown:YES];
                                [SESSION isRequested:NO];
                                [HELPER navigateToMenuDetailScreen];
                            }];
                        }
                        else if (myTripStatusIdInteger == SR_TRIP_ACCEPTED) {
                            
                            [myNearestTripTimer invalidate];
                            
                            [NAVIGATION setTitleWithBarButtonItems:@"Trip Confirmed" forViewController:self showLeftBarButton:IMAGE_MENU showRightBarButton:nil];
                            // self.navigationItem.leftBarButtonItem = nil;
                            
                            [HELPER showNotificationSuccessIn:self withMessage:aJsonId[@"Trip_Info"][@"Trip_Status_Message"]];
                            
                            self.mySearchView.userInteractionEnabled = NO;
                            _mySourceFavButton.hidden = YES;
                            _myDestinationFavButton.hidden = YES;
                            
                            // Change view Based On ride response
                            [HELPER fadeAnimationFor:_myCancelView alpha:1];
                            [HELPER fadeAnimationFor:_myCallButton alpha:1];
                            [HELPER fadeAnimationFor:_myMessageButton alpha:1];
                            [self changeViewBasedOnRide];
                            [SESSION isAlertShown:YES];
                            
                            /*   if (myDriverRoutInfoMutableArray.count) {
                             
                             [self addLocationAnddrawRouteBetweenDriverAndCustomer];
                             
                             if (!isDriverRoutDrawn) {
                             
                             [self zoomToLocationFromDriverLocation];
                             }
                             }*/
                            
                        }
                        else if (myTripStatusIdInteger == SR_TRIP_ARRIVED) {
                            
                            [myNearestTripTimer invalidate];
                            if (_gMapMutableInfo.count) {
                                
                                [self addLocationAnddrawRoute];
                                [self zoomToLocation];
                            }
                            
                            self.mySearchView.userInteractionEnabled = NO;
                            _mySourceFavButton.hidden = YES;
                            _myDestinationFavButton.hidden = YES;
                            
                            [NAVIGATION setTitleWithBarButtonItems:@"Driver Arrived" forViewController:self showLeftBarButton:IMAGE_MENU showRightBarButton:nil];
                            // self.navigationItem.leftBarButtonItem = nil;
                            
                            [HELPER showNotificationSuccessIn:self withMessage:aJsonId[@"Trip_Info"][@"Trip_Status_Message"]];
                            
                            // Change view Based On ride response
                            [HELPER fadeAnimationFor:_myCancelView alpha:1];
                            [HELPER fadeAnimationFor:_myCallButton alpha:1];
                            [HELPER fadeAnimationFor:_myMessageButton alpha:1];
                            [self changeViewBasedOnRide];
                            [SESSION isAlertShown:YES];
                            
                        }
                        
                        else  {
                            
                            [myNearestTripTimer invalidate];
                            
                            if (_gMapMutableInfo.count) {
                                
                                [self addLocationAnddrawRoute];
                                [self zoomToLocation];
                            }
                            
                            [HELPER fadeAnimationFor:_myCancelView alpha:0];
                            [HELPER fadeAnimationFor:_myCallButton alpha:0];
                            [HELPER fadeAnimationFor:_myMessageButton alpha:0];
                            
                            self.mySearchView.userInteractionEnabled = NO;
                            _mySourceFavButton.hidden = YES;
                            _myDestinationFavButton.hidden = YES;
                            
                            // Change view Based On ride response
                            [self changeViewBasedOnRide];
                            
                            if (myTripStatusIdInteger == SR_TRIP_STARTED) {
                                
                                [NAVIGATION setTitleWithBarButtonItems:@"Trip Started" forViewController:self showLeftBarButton:IMAGE_MENU showRightBarButton:nil];
                                //self.navigationItem.leftBarButtonItem = nil;
                                
                                [HELPER showNotificationSuccessIn:self withMessage:aJsonId[@"Trip_Info"][@"Trip_Status_Message"]];
                                
                                [SESSION isAlertShown:YES];
                                
                            }
                            else {
                                
                                [NAVIGATION setTitleWithBarButtonItems:@"Trip Completed" forViewController:self showLeftBarButton:IMAGE_MENU showRightBarButton:nil];
                                // self.navigationItem.leftBarButtonItem = nil;
                                
                                [HELPER showAlertView:self title:APP_NAME message:aJsonId[@"Trip_Info"][@"Trip_Status_Message"] okButtonBlock:^(UIAlertAction *action) {
                                    
                                    NSMutableArray *aMutableArray = [NSMutableArray new];
                                    [aMutableArray addObject:[aJsonId[@"Trip_Info"] valueForKey:@"Trip_Details"]];
                                    [SESSION isAlertShown:YES];
                                    
                                    if (aMutableArray.count) {
                                        
                                        [[NSNotificationCenter defaultCenter] removeObserver:self  name:VIEW_UPADTE_BASED_ON_REQUEST_STATUS object:nil];
                                        
                                        LUInvoiceViewController *aViewController = [STORY_BOARD instantiateViewControllerWithIdentifier:@"LUInvoiceViewController"];
                                        aViewController.gInfoArray = aMutableArray;
                                        aViewController.gTripIdString = myTripIdString;
                                        aViewController.myProfileUrl = _myRideResponseMutableArray[0][@"Driver_Image"];
                                        aViewController.gUserIdString = [SESSION getUserInfo][0][SR_USER_ID];
                                        aViewController.myHubProxy = myHubProxy;
                                        aViewController.myHubConnection = _myHubConnection;
                                        
                                        [self.navigationController pushViewController:aViewController animated:YES];
                                    }
                                }];
                            }
                        }
                        // }
                        
                        [HELPER fadeAnimationFor:_myOnGoingLoadingView alpha:0];
                        
                        
                    }
                    else {
                        
                    }
                }
                else if ([aJsonId[kRESPONSE][kRESPONSE_CODE] intValue] == k_BAD_REQUEST || [aJsonId[kRESPONSE][kRESPONSE_CODE] intValue] == K_NO_DATA_CODE) {
                    
                    
                }
                else {
                    
                    [HELPER showNotificationSuccessIn:self withMessage:aJsonId[kRESPONSE][kRESPONSE_MESSAGE]];
                    
                    [TestFairy sendUserFeedback:[NSString stringWithFormat:@"case --- %@ parameter --  %@ response -- %@",SR_GET_ON_GOING_REQUEST,aArray ,aJsonId]];
                }
            }
        }
        else {
            
            [TestFairy sendUserFeedback:[NSString stringWithFormat:@"case --- %@ parameter --  %@ response -- %@",SR_GET_ON_GOING_REQUEST,aArray ,error]];
            
            
            if (error.code == NSURLErrorTimedOut)
                [HELPER showRetryAlertIn:self details:ALERT_SIGNALR_UNABLE_TO_REACH_DICT retryBlock:^{
                    
                    if ([HTTPMANAGER isNetworkRechable]) {
                        
                        [HELPER removeRetryAlertIn:self];
                        [HELPER showLoadingIn:self];
                        [self getOnGoingRequest];
                    }
                }];
            else {
                
            }
        }
        
        [HELPER removeLoadingIn:self];
    }];
}

-(void)getNearestVehiclesList {
    
    myCurrentRequest = SR_GET_NEAREST_VEHICLE_REQUEST;
    
    NSString *originString = [NSString stringWithFormat:@"%f,%f", [[_gMapMutableInfo[0] componentsSeparatedByString:@","][0] doubleValue], [[_gMapMutableInfo[0] componentsSeparatedByString:@","][1] doubleValue]];
    NSString *destinationString = [NSString stringWithFormat:@"%f,%f", [[_gMapMutableInfo[1] componentsSeparatedByString:@","][0] doubleValue], [[_gMapMutableInfo[1] componentsSeparatedByString:@","][1] doubleValue]];
    NSString *aLatitude = [originString componentsSeparatedByString:@","][0];
    NSString *aLongitude = [originString componentsSeparatedByString:@","][1];
    NSString *aToLatitude = [destinationString componentsSeparatedByString:@","][0];
    NSString *aToLongitude = [destinationString componentsSeparatedByString:@","][1];
    
    NSArray *aArray = [NSArray new];
    
    aArray = [NSArray arrayWithObjects: aLatitude,aLongitude,aToLatitude,aToLongitude,[SESSION getUserInfo][0][K_CUSTOMER_ID], _gServiceTag.service_type_id, nil];
    
    [myHubProxy invoke:SR_GET_NEAREST_VEHICLE withArgs:aArray completionHandler:^(id response, NSError *error) {
        
        if (!error) {
            
            if (![response isKindOfClass:[NSDictionary class]]) {
                
                NSData *data = [response dataUsingEncoding:NSUTF8StringEncoding];
                id aJsonId = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                
                if ([aJsonId[kRESPONSE][kRESPONSE_CODE] intValue] == kSUCCESS_CODE) {
                    
                    
                    _myServiceLocationTypeMutableArray = [NSMutableArray new];
                    _myServiceLocationTypeMutableArray = [aJsonId objectForKey:@"Service_Types"];
                    
                    
                    if (_myServiceLocationTypeMutableArray.count) {
                        
                        [self addCarLocation];
                        
                        _mytimeLabel.text = _myServiceLocationTypeMutableArray[0][@"Estimation_Time"];
                        
                    }
                    myNearestVehicleResponseString = aJsonId[kRESPONSE][kRESPONSE_MESSAGE];
                    
                    
                }
                else if ([aJsonId[kRESPONSE][kRESPONSE_CODE] intValue] == k_BAD_REQUEST || [aJsonId[kRESPONSE][kRESPONSE_CODE] intValue] == K_NO_DATA_CODE) {
                    
                    [_myMapView clear];
                    [self addLocationAnddrawRoute];
                    
                }
                else {
                    
                    [TestFairy sendUserFeedback:[NSString stringWithFormat:@"case --- %@ parameter --  %@ response -- %@",SR_GET_NEAREST_VEHICLE,aArray ,aJsonId]];
                }
            }
        }
        else {
            
            //   [TestFairy sendUserFeedback:[NSString stringWithFormat:@"case --- %@ parameter --  %@ response -- %@",SR_GET_NEAREST_VEHICLE,aArray ,error]];
        }
        
    }];
}

-(void)getFareEstimation {
    
    myCurrentRequest = SR_GET_FARE_ESTIMATION_REQUEST;
    
    NSString *originString = [NSString stringWithFormat:@"%f,%f", [[_gMapMutableInfo[0] componentsSeparatedByString:@","][0] doubleValue], [[_gMapMutableInfo[0] componentsSeparatedByString:@","][1] doubleValue]];
    NSString *destinationString = [NSString stringWithFormat:@"%f,%f", [[_gMapMutableInfo[1] componentsSeparatedByString:@","][0] doubleValue], [[_gMapMutableInfo[1] componentsSeparatedByString:@","][1] doubleValue]];
    NSString *aLatitude = [originString componentsSeparatedByString:@","][0];
    NSString *aLongitude = [originString componentsSeparatedByString:@","][1];
    NSString *aToLatitude = [destinationString componentsSeparatedByString:@","][0];
    NSString *aToLongitude = [destinationString componentsSeparatedByString:@","][1];
    
    NSArray *aArray = [NSArray new];
    
    if ([originString isEqualToString:[NSString stringWithFormat:@"%@,%@",@"0.000000",@"0.000000"]] || [destinationString isEqualToString:[NSString stringWithFormat:@"%@,%@",@"0.000000",@"0.000000"]]) {
        
        if (_myMapLatLongMutableArray.count) {
            
            originString = [NSString stringWithFormat:@"%f,%f", [[_myMapLatLongMutableArray[0] componentsSeparatedByString:@","][0] doubleValue], [[_myMapLatLongMutableArray[0] componentsSeparatedByString:@","][1] doubleValue]];
            destinationString = [NSString stringWithFormat:@"%f,%f", [[_myMapLatLongMutableArray[1] componentsSeparatedByString:@","][0] doubleValue], [[_myMapLatLongMutableArray[1] componentsSeparatedByString:@","][1] doubleValue]];
            aLatitude = [originString componentsSeparatedByString:@","][0];
            aLongitude = [originString componentsSeparatedByString:@","][1];
            aToLatitude = [destinationString componentsSeparatedByString:@","][0];
            aToLongitude = [destinationString componentsSeparatedByString:@","][1];
            
            aArray = [NSArray arrayWithObjects: aLatitude,aLongitude,aToLatitude,aToLongitude,[SESSION getUserInfo][0][K_CUSTOMER_ID], _gServiceTag.service_type_id, nil];
        }
        else
            return;
    }
    else {
        
        aArray = [NSArray arrayWithObjects: aLatitude,aLongitude,aToLatitude,aToLongitude,[SESSION getUserInfo][0][K_CUSTOMER_ID], _gServiceTag.service_type_id, nil];
    }
    
    [TestFairy sendUserFeedback:[NSString stringWithFormat:@"case --- %@ and parameter --  %@",SR_GET_FARE_ESTIMATION,aArray]];
    
    
    [myHubProxy invoke:SR_GET_FARE_ESTIMATION withArgs:aArray completionHandler:^(id response, NSError *error) {
        
        if (!error) {
            
            if (![response isKindOfClass:[NSDictionary class]]) {
                
                NSData *data = [response dataUsingEncoding:NSUTF8StringEncoding];
                id aJsonId = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                
                if ([aJsonId[kRESPONSE][kRESPONSE_CODE] intValue] == kSUCCESS_CODE) {
                    
                    _myServiceTypeMutableArray = [NSMutableArray new];
                    _myServiceTypeMutableArray = [aJsonId objectForKey:@"Service_Types"];
                    
                    
                    if (_myServiceTypeMutableArray.count) {
                        
                        _myAmountLabel.text = ([_myServiceTypeMutableArray[0][@"Is_Fixed_Fare"] isEqualToString:@"0"]) ? _myServiceTypeMutableArray[0][@"Estimation_Cost"] : [NSString stringWithFormat:@"%@ (fixed fare)",_myServiceTypeMutableArray[0][@"Estimation_Cost"]];
                        _myEstimatedfare.text = ([_myServiceTypeMutableArray[0][@"Is_Fixed_Fare"] isEqualToString:@"0"]) ?_myServiceTypeMutableArray[0][@"Estimation_Cost"] : [NSString stringWithFormat:@"%@ fixed fare",_myServiceTypeMutableArray[0][@"Estimation_Cost"]];
                        
                        NSString *aString = ([_myServiceTypeMutableArray[0][@"Is_Fixed_Fare"] isEqualToString:@"0"]) ? [NSString stringWithFormat:@"%@", [[_myServiceTypeMutableArray[0][@"Estimation_Cost"] substringFromIndex:1] componentsSeparatedByString:@" - "][0]] : [_myServiceTypeMutableArray[0][@"Estimation_Cost"] substringFromIndex:1];
                        
                        myEstimatedValue = aString.integerValue;
                        
                        //_mytimeLabel.text = myServiceTypeMutableArray[0][@"Estimation_Time"];
                        
                    }
                }
                else if ([aJsonId[kRESPONSE][kRESPONSE_CODE] intValue] == k_BAD_REQUEST || [aJsonId[kRESPONSE][kRESPONSE_CODE] intValue] == K_NO_DATA_CODE) {
                    
                    [HELPER showNotificationSuccessIn:self withMessage:aJsonId[kRESPONSE][kRESPONSE_MESSAGE]];
                }
                else {
                    
                    [HELPER showNotificationSuccessIn:self withMessage:aJsonId[kRESPONSE][kRESPONSE_MESSAGE]];
                    
                    [TestFairy sendUserFeedback:[NSString stringWithFormat:@"case --- %@ parameter --  %@ response -- %@",SR_GET_FARE_ESTIMATION,aArray ,aJsonId]];
                    
                }
            }
            [self hideLoadingActivityIndicator];
        }
        else {
            
            [TestFairy sendUserFeedback:[NSString stringWithFormat:@"case --- %@ parameter --  %@ response -- %@",SR_GET_FARE_ESTIMATION,aArray ,error]];
            
            if (error.code == NSURLErrorTimedOut)
                [HELPER showRetryAlertIn:self details:ALERT_SIGNALR_UNABLE_TO_REACH_DICT retryBlock:^{
                    
                    if ([HTTPMANAGER isNetworkRechable]) {
                        
                        [HELPER removeRetryAlertIn:self];
                        [HELPER showLoadingIn:self];
                        [self getFareEstimation];
                    }
                }];
            else {
                
            }
        }
    }];
    
}

static NSTimer *myTimer;

- (void)requestForRide {
    
    [self.view endEditing:YES];
    isRequestStarted = YES;
    
    myCurrentRequest = SR_RIDE_REQUEST;
    
    NSArray *aArray = [NSArray new];
    
    aArray = @[[_gMapMutableInfo[0] componentsSeparatedByString:@","][0],[_gMapMutableInfo[0] componentsSeparatedByString:@","][1],[_gMapMutableInfo[1] componentsSeparatedByString:@","][0],[_gMapMutableInfo[1] componentsSeparatedByString:@","][1],[SESSION getUserInfo][0][K_CUSTOMER_ID], _gServiceTag.service_type_id, @"",myBidAmountString, myPromoCodeIdString];
    
    _mySubmitButton.userInteractionEnabled = NO;
    
    __block SRHubProxy *aHub;
    aHub = myHubProxy;
    
    [aHub invoke:SR_REQUEST_RIDE withArgs:aArray completionHandler:^(id response, NSError *error) {
        
        if (!error) {
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            
            if (![response isKindOfClass:[NSDictionary class]]) {
                
                NSData *data = [response dataUsingEncoding:NSUTF8StringEncoding];
                id aJsonId = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                
                if ([aJsonId[kRESPONSE][kRESPONSE_CODE] intValue] == kSUCCESS_CODE) {
                    
                    NSMutableDictionary *aMutableDict = [NSMutableDictionary new];
                    aMutableDict = [aJsonId objectForKey:@"Ride_Response"];
                    
                    if (aMutableDict.count) {
                        
                        [myNearestTripTimer invalidate];
                        
                        _myRideResponseMutableArray = [NSMutableArray new];
                        
                        myCancelCharge = [aMutableDict valueForKey:@"Cancellation_Msg"];
                        
                        if (aMutableDict.count)
                            [_myRideResponseMutableArray addObject:aMutableDict];
                        
                        if (_myRideResponseMutableArray.count) {
                            
                            [_gMapMutableInfo arrayByAddingObject:[NSString stringWithFormat:@"%@,%@",_myRideResponseMutableArray[0][SR_FROM_LATITUDE],_myRideResponseMutableArray[0][SR_FROM_LONGITUDE]]];
                            [_gMapMutableInfo arrayByAddingObject:[NSString stringWithFormat:@"%@,%@",_myRideResponseMutableArray[0][SR_TO_LATITUDE],_myRideResponseMutableArray[0][SR_TO_LONGITUDE]]];
                            
                            // Change view Based On ride response
                            [self changeViewBasedOnRide];
                            
                            
                            // The below method are done to clear the marker & add new marker with rout.
                            [_myMapView clear];
                            [self addLocationAnddrawRoute];
                            [self addCarLocation];
                        }
                    }
                }
                else if ([aJsonId[kRESPONSE][kRESPONSE_CODE] intValue] == k_BAD_REQUEST || [aJsonId[kRESPONSE][kRESPONSE_CODE] intValue] == K_NO_DATA_CODE) {
                    
                    
                    if ([aJsonId[kRESPONSE][kRESPONSE_MESSAGE] isEqualToString:@"No car is available, Please try again later."]) {
                        
                        isRequestDeclined = YES;
                        myTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateIntegerConut) userInfo:nil repeats:YES];
                    }
                    
                    [SESSION isRequested:NO];
                    [HELPER showNotificationSuccessIn:self withMessage:aJsonId[kRESPONSE][kRESPONSE_MESSAGE]];
                }
                else {
                    
                    [SESSION isRequested:NO];
                    [HELPER showNotificationSuccessIn:self withMessage:aJsonId[kRESPONSE][kRESPONSE_MESSAGE]];
                    
                    [TestFairy sendUserFeedback:[NSString stringWithFormat:@"case --- %@ parameter --  %@ response -- %@",SR_REQUEST_RIDE,aArray ,aJsonId]];
                    
                }
                [self hideRequestLoadingView];
                _mySubmitButton.userInteractionEnabled = YES;
            }
        }
        else {
            [TestFairy sendUserFeedback:[NSString stringWithFormat:@"case --- %@ parameter --  %@ response -- %@",SR_REQUEST_RIDE,aArray ,error]];
            
            if (error.code == NSURLErrorTimedOut) {
                
            }
            else {
                [HELPER showNotificationSuccessIn:self withMessage:@"Sorry! Unable to request at this time. Please try again"];
                [self hideRequestLoadingView];
            }
            _mySubmitButton.userInteractionEnabled = YES;
        }
    }];
}


static bool isCanceled = false;

-(void)cancelTrip {// StrTripId,StrUserId,StrTripStatusId,StrCancelId,StrUserType
    
    myCurrentRequest = SR_CANCEL_TRIP_REQUEST;
    _mySubmitButton.userInteractionEnabled = NO;
    [_mySubmitButton startActivityIndicator:self];
    
    [myHubProxy invoke:SR_CANCEL_TRIP withArgs:@[myTripIdString,(_mySignalRConnectionMutableArray.count) ? _mySignalRConnectionMutableArray[0][SR_USER_ID] : [SESSION getUserInfo][0][K_CUSTOMER_ID],myCancelIdString,SR_CUSTOMER_TYPE] completionHandler:^(id response, NSError *error) {
        
        if (!error) {
            
            if (![response isKindOfClass:[NSDictionary class]]) {
                
                NSData *data = [response dataUsingEncoding:NSUTF8StringEncoding];
                id aJsonId = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                
                NSLog(@"Cancel Response %@",aJsonId);
                
                if (aJsonId) { //[kRESPONSE][kRESPONSE_CODE] intValue] == kSUCCESS_CODE) {
                    
                    isCanceled = YES;
                    
                    [HELPER showAlertView:self title:SCREEN_TITLE_DASHBOARD message:aJsonId[kRESPONSE][kRESPONSE_MESSAGE] okButtonBlock:^(UIAlertAction *action) {
                        
                        if (isForOnGoingRequest) {
                            
                            [NAVIGATION setTitleWithBarButtonItems:_gServiceTag.service_type_name forViewController:self showLeftBarButton:IMAGE_BACK showRightBarButton:nil];
                            [_mySubmitButton setTitle:[NSString stringWithFormat:@"Request for %@",_gServiceTag.service_type_name] forState:UIControlStateNormal];
                            
                            NSMutableArray * aMutableArray = [NSMutableArray new];
                            
                            [aMutableArray addObject:_mySearchSourceTextfield.text];
                            [aMutableArray addObject:_mySearchDistinationTextfield.text];
                            [aMutableArray addObject:(isFavSource) ? @"1" : @"0"];
                            [aMutableArray addObject:(isFavDestination) ? @"1" : @"0"];
                            [aMutableArray addObject:_gMapMutableInfo[0]];
                            [aMutableArray addObject:_gMapMutableInfo[1]];
                            
                            [SESSION setSearchInfo:aMutableArray];
                            
                            [SESSION isRequested:NO];
                            [HELPER navigateToMenuDetailScreen];
                        }
                        else {
                            
                            [NAVIGATION setTitleWithBarButtonItems:_gServiceTag.service_type_name forViewController:self showLeftBarButton:IMAGE_BACK showRightBarButton:nil];
                        }
                        
                        [HELPER fadeAnimationFor:_myBidBgView alpha:0];
                        [HELPER fadeAnimationFor:_myActivityIndicatorView alpha:0];
                        [HELPER fadeAnimationFor:_myRequestView alpha:0];
                        [HELPER fadeAnimationFor:_myBgView alpha:1];
                        _myRequestButtonHeightConstraint.constant = 45;
                        myNearestTripTimer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(getNearestVehiclesList) userInfo:nil repeats:YES];
                        
                        [SESSION isRequested:NO];
                        
                        {
                            _mySearchView.userInteractionEnabled = YES;
                        }
                        
                        myCancelIdString = @"";
                        isRequestStarted = NO;
                        
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            
                            //[self getAddressFromLocation];
                            [self addLocationAnddrawRoute];
                            [self zoomToLocation];
                            [self getFareEstimation];
                            
                            
                        });
                    }];
                }
                /*else if ([aJsonId[kRESPONSE][kRESPONSE_CODE] intValue] == k_BAD_REQUEST || [aJsonId[kRESPONSE][kRESPONSE_CODE] intValue] == K_NO_DATA_CODE) {
                 
                 }*/
                else if([aJsonId[kRESPONSE][kRESPONSE_CODE] intValue] == -2) {
                    
                    [TestFairy sendUserFeedback:[NSString stringWithFormat:@"case --- %@ parameter --  %@ response -- %@",SR_CANCEL_TRIP,@[myTripIdString,(_mySignalRConnectionMutableArray.count) ? _mySignalRConnectionMutableArray[0][SR_USER_ID] : [SESSION getUserInfo][0][K_CUSTOMER_ID],myCancelIdString,SR_CUSTOMER_TYPE] ,aJsonId]];
                }
                
                [self hideRequestLoadingView];
                [_mySubmitButton stopActivityIndicatorWithResetTitle:[NSString stringWithFormat:@"Request for %@",_gServiceTag.service_type_name]];
                self.view.userInteractionEnabled = YES;
                [HELPER removeLoadingIn:self];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    _mySubmitButton.userInteractionEnabled = YES;
                });
            }
        }
        else {
            
            [TestFairy sendUserFeedback:[NSString stringWithFormat:@"case --- %@ parameter --  %@ response -- %@",SR_CANCEL_TRIP,@[myTripIdString,(_mySignalRConnectionMutableArray.count) ? _mySignalRConnectionMutableArray[0][SR_USER_ID] : [SESSION getUserInfo][0][K_CUSTOMER_ID],myCancelIdString,SR_CUSTOMER_TYPE] ,error]];
            
            NSLog(@"Cancel Error %@",error);
            
            if (error.code == NSURLErrorTimedOut)
                
                [HELPER showRetryAlertIn:self details:ALERT_SIGNALR_UNABLE_TO_REACH_DICT retryBlock:^{
                    
                    if ([HTTPMANAGER isNetworkRechable]) {
                        
                        [HELPER removeRetryAlertIn:self];
                        [HELPER showLoadingIn:self];
                        [self cancelTrip];
                    }
                }];
            else
                [HELPER showNotificationSuccessIn:self withMessage:MESSAGE_SOMETHING_WENT_WRONG];
            
            [_mySubmitButton stopActivityIndicatorWithResetTitle:[NSString stringWithFormat:@"Request for %@",_gServiceTag.service_type_name]];
            [HELPER removeLoadingIn:self];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                _mySubmitButton.userInteractionEnabled = YES;
                
            });
        }
        
        
        
    }];
}


-(void)goOffline {
    
    myCurrentRequest = SR_OFFLINE_REQUEST;
    
    [myHubProxy invoke:SR_GO_OFFLINE withArgs:@[_mySignalRConnectionMutableArray[0][SR_USER_ID],SR_CUSTOMER_TYPE] completionHandler:^(id response, NSError *error) {
        
        if (!error) {
            
            if (![response isKindOfClass:[NSDictionary class]]) {
                
                NSData *data = [response dataUsingEncoding:NSUTF8StringEncoding];
                id aJsonId = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                
                if ([aJsonId[kRESPONSE][kRESPONSE_CODE] intValue] == kSUCCESS_CODE) {
                    
                }
                else if ([aJsonId[kRESPONSE][kRESPONSE_CODE] intValue] == k_BAD_REQUEST || [aJsonId[kRESPONSE][kRESPONSE_CODE] intValue] == K_NO_DATA_CODE) {
                    
                    [HELPER showNotificationSuccessIn:self withMessage:aJsonId[kRESPONSE][kRESPONSE_MESSAGE]];
                }
                else {
                    
                    [HELPER showNotificationSuccessIn:self withMessage:aJsonId[kRESPONSE][kRESPONSE_MESSAGE]];
                    
                    [TestFairy sendUserFeedback:[NSString stringWithFormat:@"case --- %@ parameter --  %@ response -- %@",SR_GO_OFFLINE,@[_mySignalRConnectionMutableArray[0][SR_USER_ID],SR_CUSTOMER_TYPE],aJsonId]];
                    
                }
            }
        }
        else {
            
            
            if (error.code == NSURLErrorTimedOut) {
                
                [TestFairy sendUserFeedback:[NSString stringWithFormat:@"case --- %@ parameter --  %@ response -- %@",SR_GO_OFFLINE,@[_mySignalRConnectionMutableArray[0][SR_USER_ID],SR_CUSTOMER_TYPE],error]];
                
                [HELPER showRetryAlertIn:self details:ALERT_SIGNALR_UNABLE_TO_REACH_DICT retryBlock:^{
                    
                    if ([HTTPMANAGER isNetworkRechable]) {
                        
                        [HELPER removeRetryAlertIn:self];
                        [HELPER showLoadingIn:self];
                        [self goOffline];
                    }
                }];
            }
            else
                [HELPER showNotificationSuccessIn:self withMessage:MESSAGE_SOMETHING_WENT_WRONG];
        }
    }];
}

-(void)changeStatusBasedOnRequest:(NSString *)aMessage {
    
    if (_myOnGoingLoadingView.alpha == 0) {
        
        NSData *data = [aMessage dataUsingEncoding:NSUTF8StringEncoding];
        id aJsonId = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        if ([aJsonId[kRESPONSE][kRESPONSE_CODE] intValue] == kSUCCESS_CODE) {
            
            if (isRequestDeclined && myRequestDeclinedInteger < 30) {
                
                isRequestDeclined = NO;
                [myTimer invalidate];
                myRequestDeclinedInteger = 0;
                
                [HELPER showAlertView:self title:APP_NAME message:@"We value your request and we have allocated you with a special driver at the same cost who will reach you soon. \n Thank you!" okButtonBlock:^(UIAlertAction *action) {
                    
                    NSString *aStatusString;
                    NSMutableArray *aMutableArray = [NSMutableArray new];
                    
                    _mySubmitButton.userInteractionEnabled = YES;
                    _mySubmitButton.backgroundColor = [UIColor blackColor];
                    
                    if (_myRideResponseMutableArray.count)
                        [self changeViewBasedOnRide];
                    
                    [SESSION isAlertShown:NO];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_VIEW_UPADTE_BASED_ON_REQUEST_STATUS object:nil userInfo:[NSDictionary dictionaryWithObject:aMessage forKey:NOTIFICATION_REQUEST_STATUS_KEY]];
                    
                    myTripStatusIdInteger = [[aJsonId objectForKey:SR_TRIP_STATUS_ID] integerValue];
                    [self hideRequestLoadingView];
                    
                    if (myTripStatusIdInteger == SR_TRIP_REQUEST) {
                        
                        [HELPER showNotificationSuccessIn:self withMessage:aJsonId[kRESPONSE][kRESPONSE_MESSAGE]];
                        aStatusString = aJsonId[kRESPONSE][kRESPONSE_MESSAGE];
                        [SESSION isAlertShown:YES];
                    }
                    else if (myTripStatusIdInteger == SR_TRIP_BEFORE_CANCEL || myTripStatusIdInteger == SR_TRIP_AFTER_CANCEL) {
                        
                        aStatusString = @"Trip cancelled";
                        [HELPER showAlertView:self title:SCREEN_TITLE_DASHBOARD message:@"Trip cancelled" okButtonBlock:^(UIAlertAction *action) {
                            
                            if (isForOnGoingRequest) {
                                
                                [NAVIGATION setTitleWithBarButtonItems:_gServiceTag.service_type_name forViewController:self showLeftBarButton:IMAGE_BACK showRightBarButton:nil];
                                [_mySubmitButton setTitle:[NSString stringWithFormat:@"Request for %@",_gServiceTag.service_type_name] forState:UIControlStateNormal];
                                
                                NSMutableArray * aMutableArray = [NSMutableArray new];
                                
                                [aMutableArray addObject:_mySearchSourceTextfield.text];
                                [aMutableArray addObject:_mySearchDistinationTextfield.text];
                                [aMutableArray addObject:(isFavSource) ? @"1" : @"0"];
                                [aMutableArray addObject:(isFavDestination) ? @"1" : @"0"];
                                [aMutableArray addObject:_gMapMutableInfo[0]];
                                [aMutableArray addObject:_gMapMutableInfo[1]];
                                
                                [SESSION setSearchInfo:aMutableArray];
                                
                                [SESSION isRequested:NO];
                                [HELPER navigateToMenuDetailScreen];
                                
                            }
                            else {
                                
                                //   [self.view bringSubviewToFront:_myBgView];
                                [HELPER fadeAnimationFor:_myBidBgView alpha:0];
                                [HELPER fadeAnimationFor:_myActivityIndicatorView alpha:0];
                                [HELPER fadeAnimationFor:_myRequestView alpha:0];
                                [HELPER fadeAnimationFor:_myBgView alpha:1];
                                _myRequestButtonHeightConstraint.constant = 45;
                                
                                [SESSION isAlertShown:YES];
                                [SESSION isRequested:NO];
                                
                                [NAVIGATION setTitleWithBarButtonItems:_gServiceTag.service_type_name forViewController:self showLeftBarButton:IMAGE_BACK showRightBarButton:nil];
                                [_mySubmitButton setTitle:[NSString stringWithFormat:@"Request for %@",_gServiceTag.service_type_name] forState:UIControlStateNormal];
                                
                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                    
                                    //  [self getAddressFromLocation];
                                    [self addLocationAnddrawRoute];
                                    [self zoomToLocation];
                                });
                            }
                            
                        }];
                    }
                    else if (myTripStatusIdInteger == SR_TRIP_ACCEPTED) {
                        
                        self.mySearchView.userInteractionEnabled = NO;
                        _mySourceFavButton.hidden = YES;
                        _myDestinationFavButton.hidden = YES;
                        
                        aStatusString = @"Trip Confirmed";
                        NSMutableDictionary *aMutableDict = [NSMutableDictionary new];
                        aMutableDict = [aJsonId objectForKey:@"Ride_Response"];
                        _myRideResponseMutableArray = [NSMutableArray new];
                        
                        myCancelCharge = [aMutableDict valueForKey:@"Cancellation_Msg"];
                        
                        if (aMutableDict.count)
                            [_myRideResponseMutableArray addObject:aMutableDict];
                        
                        [NAVIGATION setTitleWithBarButtonItems:@"Trip Confirmed" forViewController:self showLeftBarButton:IMAGE_MENU showRightBarButton:nil];
                        //  self.navigationItem.leftBarButtonItem = nil;
                        
                        [HELPER showNotificationSuccessIn:self withMessage:aJsonId[kRESPONSE][kRESPONSE_MESSAGE]];
                        [SESSION isAlertShown:YES];
                        isDriverRoutDrawn = NO;
                        
                        if (_myRideResponseMutableArray.count) {
                            
                            [HELPER fadeAnimationFor:_myCancelView alpha:1];
                            [HELPER fadeAnimationFor:_myCallButton alpha:1];
                            [HELPER fadeAnimationFor:_myMessageButton alpha:1];
                            [self changeViewBasedOnRide];
                        }
                        
                    }
                    else if (myTripStatusIdInteger == SR_TRIP_ARRIVED) {
                        
                        aStatusString = @"Driver Arrived";
                        self.mySearchView.userInteractionEnabled = NO;
                        _mySourceFavButton.hidden = YES;
                        _myDestinationFavButton.hidden = YES;
                        
                        [_myMapView clear];
                        [self addLocationAnddrawRoute];
                        [self zoomToLocation];
                        
                        NSMutableDictionary *aMutableDict = [NSMutableDictionary new];
                        aMutableDict = [aJsonId objectForKey:@"Ride_Response"];
                        _myRideResponseMutableArray = [NSMutableArray new];
                        
                        myCancelCharge = [aMutableDict valueForKey:@"Cancellation_Msg"];
                        
                        if (aMutableDict.count)
                            [_myRideResponseMutableArray addObject:aMutableDict];
                        
                        [NAVIGATION setTitleWithBarButtonItems:@"Driver Arrived" forViewController:self showLeftBarButton:IMAGE_MENU showRightBarButton:nil];
                        //  self.navigationItem.leftBarButtonItem = nil;
                        
                        [HELPER showNotificationSuccessIn:self withMessage:aJsonId[kRESPONSE][kRESPONSE_MESSAGE]];
                        [SESSION isAlertShown:YES];
                        
                        if (_myRideResponseMutableArray.count) {
                            
                            [self changeViewBasedOnRide];
                        }
                        
                    }
                    
                    else  {
                        
                        [HELPER fadeAnimationFor:_myCancelView alpha:0];
                        [HELPER fadeAnimationFor:_myCallButton alpha:0];
                        [HELPER fadeAnimationFor:_myMessageButton alpha:0];
                        self.mySearchView.userInteractionEnabled = NO;
                        _mySourceFavButton.hidden = YES;
                        _myDestinationFavButton.hidden = YES;
                        
                        if (myTripStatusIdInteger == SR_TRIP_STARTED) {
                            
                            aStatusString = @"Trip Started";
                            
                            NSMutableDictionary *aMutableDict = [NSMutableDictionary new];
                            aMutableDict = [aJsonId objectForKey:@"Ride_Response"];
                            _myRideResponseMutableArray = [NSMutableArray new];
                            
                            myCancelCharge = [aMutableDict valueForKey:@"Cancellation_Msg"];
                            
                            if (aMutableDict.count)
                                [_myRideResponseMutableArray addObject:aMutableDict];
                            
                            [NAVIGATION setTitleWithBarButtonItems:@"Trip Started" forViewController:self showLeftBarButton:IMAGE_MENU showRightBarButton:nil];
                            // self.navigationItem.leftBarButtonItem = nil;
                            
                            [HELPER showNotificationSuccessIn:self withMessage:aJsonId[kRESPONSE][kRESPONSE_MESSAGE]];
                            [SESSION isAlertShown:YES];
                            
                            if (_myRideResponseMutableArray.count)
                                [self changeViewBasedOnRide];
                            
                        }
                        else {
                            
                            aStatusString = @"Trip Completed";
                            
                            [NAVIGATION setTitleWithBarButtonItems:@"Trip Completed" forViewController:self showLeftBarButton:nil showRightBarButton:nil];
                            self.navigationItem.leftBarButtonItem = nil;
                            
                            aMutableArray = [aJsonId valueForKey:@"Trip_Details"];
                            
                            [HELPER showAlertView:self title:APP_NAME message:aJsonId[kRESPONSE][kRESPONSE_MESSAGE] okButtonBlock:^(UIAlertAction *action) {
                                
                                if (_myRideResponseMutableArray.count)
                                    [self changeViewBasedOnRide];
                                
                                [SESSION isAlertShown:YES];
                                
                                if (aMutableArray.count) {
                                    
                                    isMoveToInvoiceScreen = YES;
                                    
                                    [[NSNotificationCenter defaultCenter] removeObserver:self  name:VIEW_UPADTE_BASED_ON_REQUEST_STATUS object:nil];
                                    
                                    LUInvoiceViewController *aViewController = [STORY_BOARD instantiateViewControllerWithIdentifier:@"LUInvoiceViewController"];
                                    aViewController.gInfoArray = aMutableArray;
                                    aViewController.gTripIdString = myTripIdString;
                                    aViewController.gUserIdString = [SESSION getUserInfo][0][K_CUSTOMER_ID];
                                    aViewController.myHubProxy = myHubProxy;
                                    aViewController.myHubConnection = _myHubConnection;
                                    aViewController.myProfileUrl = _myRideResponseMutableArray[0][@"Driver_Image"];
                                    
                                    [self.navigationController pushViewController:aViewController animated:YES];
                                }
                            }];
                        }
                    }
                    
                    if (myTripStatusIdInteger == SR_TRIP_ACCEPTED) {
                        
                    }
                }];
            }
            else {
                
                NSString *aStatusString;
                NSMutableArray *aMutableArray = [NSMutableArray new];
                
                _mySubmitButton.userInteractionEnabled = YES;
                _mySubmitButton.backgroundColor = [UIColor blackColor];
                
                if (_myRideResponseMutableArray.count)
                    [self changeViewBasedOnRide];
                
                [SESSION isAlertShown:NO];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_VIEW_UPADTE_BASED_ON_REQUEST_STATUS object:nil userInfo:[NSDictionary dictionaryWithObject:aMessage forKey:NOTIFICATION_REQUEST_STATUS_KEY]];
                
                myTripStatusIdInteger = [[aJsonId objectForKey:SR_TRIP_STATUS_ID] integerValue];
                [self hideRequestLoadingView];
                
                if (myTripStatusIdInteger == SR_TRIP_REQUEST) {
                    
                    [HELPER showNotificationSuccessIn:self withMessage:aJsonId[kRESPONSE][kRESPONSE_MESSAGE]];
                    aStatusString = aJsonId[kRESPONSE][kRESPONSE_MESSAGE];
                    [SESSION isAlertShown:YES];
                }
                else if (myTripStatusIdInteger == SR_TRIP_BEFORE_CANCEL || myTripStatusIdInteger == SR_TRIP_AFTER_CANCEL) {
                    
                    aStatusString = @"Trip cancelled";
                    [HELPER showAlertView:self title:SCREEN_TITLE_DASHBOARD message:@"Trip cancelled" okButtonBlock:^(UIAlertAction *action) {
                        
                        if (isForOnGoingRequest) {
                            
                            [NAVIGATION setTitleWithBarButtonItems:_gServiceTag.service_type_name forViewController:self showLeftBarButton:IMAGE_BACK showRightBarButton:nil];
                            [_mySubmitButton setTitle:[NSString stringWithFormat:@"Request for %@",_gServiceTag.service_type_name] forState:UIControlStateNormal];
                            
                            NSMutableArray * aMutableArray = [NSMutableArray new];
                            
                            [aMutableArray addObject:_mySearchSourceTextfield.text];
                            [aMutableArray addObject:_mySearchDistinationTextfield.text];
                            [aMutableArray addObject:(isFavSource) ? @"1" : @"0"];
                            [aMutableArray addObject:(isFavDestination) ? @"1" : @"0"];
                            [aMutableArray addObject:_gMapMutableInfo[0]];
                            [aMutableArray addObject:_gMapMutableInfo[1]];
                            
                            [SESSION setSearchInfo:aMutableArray];
                            
                            [SESSION isRequested:NO];
                            [HELPER navigateToMenuDetailScreen];
                            
                        }
                        else {
                            
                            //   [self.view bringSubviewToFront:_myBgView];
                            [HELPER fadeAnimationFor:_myBidBgView alpha:0];
                            [HELPER fadeAnimationFor:_myActivityIndicatorView alpha:0];
                            [HELPER fadeAnimationFor:_myRequestView alpha:0];
                            [HELPER fadeAnimationFor:_myBgView alpha:1];
                            _myRequestButtonHeightConstraint.constant = 45;
                            
                            [SESSION isAlertShown:YES];
                            [SESSION isRequested:NO];
                            
                            [NAVIGATION setTitleWithBarButtonItems:_gServiceTag.service_type_name forViewController:self showLeftBarButton:IMAGE_BACK showRightBarButton:nil];
                            [_mySubmitButton setTitle:[NSString stringWithFormat:@"Request for %@",_gServiceTag.service_type_name] forState:UIControlStateNormal];
                            
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                
                                //  [self getAddressFromLocation];
                                [self addLocationAnddrawRoute];
                                [self zoomToLocation];
                            });
                        }
                        
                    }];
                }
                else if (myTripStatusIdInteger == SR_TRIP_ACCEPTED) {
                    
                    self.mySearchView.userInteractionEnabled = NO;
                    _mySourceFavButton.hidden = YES;
                    _myDestinationFavButton.hidden = YES;
                    
                    aStatusString = @"Trip Confirmed";
                    NSMutableDictionary *aMutableDict = [NSMutableDictionary new];
                    aMutableDict = [aJsonId objectForKey:@"Ride_Response"];
                    _myRideResponseMutableArray = [NSMutableArray new];
                    
                    myCancelCharge = [aMutableDict valueForKey:@"Cancellation_Msg"];
                    
                    if (aMutableDict.count)
                        [_myRideResponseMutableArray addObject:aMutableDict];
                    
                    [NAVIGATION setTitleWithBarButtonItems:@"Trip Confirmed" forViewController:self showLeftBarButton:IMAGE_MENU showRightBarButton:nil];
                    //  self.navigationItem.leftBarButtonItem = nil;
                    
                    [HELPER showNotificationSuccessIn:self withMessage:aJsonId[kRESPONSE][kRESPONSE_MESSAGE]];
                    [SESSION isAlertShown:YES];
                    isDriverRoutDrawn = NO;
                    
                    if (_myRideResponseMutableArray.count) {
                        
                        [HELPER fadeAnimationFor:_myCancelView alpha:1];
                        [HELPER fadeAnimationFor:_myCallButton alpha:1];
                        [HELPER fadeAnimationFor:_myMessageButton alpha:1];
                        [self changeViewBasedOnRide];
                    }
                    
                }
                else if (myTripStatusIdInteger == SR_TRIP_ARRIVED) {
                    
                    aStatusString = @"Driver Arrived";
                    self.mySearchView.userInteractionEnabled = NO;
                    _mySourceFavButton.hidden = YES;
                    _myDestinationFavButton.hidden = YES;
                    
                    [_myMapView clear];
                    [self addLocationAnddrawRoute];
                    [self zoomToLocation];
                    
                    NSMutableDictionary *aMutableDict = [NSMutableDictionary new];
                    aMutableDict = [aJsonId objectForKey:@"Ride_Response"];
                    _myRideResponseMutableArray = [NSMutableArray new];
                    
                    myCancelCharge = [aMutableDict valueForKey:@"Cancellation_Msg"];
                    
                    if (aMutableDict.count)
                        [_myRideResponseMutableArray addObject:aMutableDict];
                    
                    [NAVIGATION setTitleWithBarButtonItems:@"Driver Arrived" forViewController:self showLeftBarButton:IMAGE_MENU showRightBarButton:nil];
                    //  self.navigationItem.leftBarButtonItem = nil;
                    
                    [HELPER showNotificationSuccessIn:self withMessage:aJsonId[kRESPONSE][kRESPONSE_MESSAGE]];
                    [SESSION isAlertShown:YES];
                    
                    if (_myRideResponseMutableArray.count) {
                        
                        [self changeViewBasedOnRide];
                    }
                    
                }
                
                else  {
                    
                    [HELPER fadeAnimationFor:_myCancelView alpha:0];
                    [HELPER fadeAnimationFor:_myCallButton alpha:0];
                    [HELPER fadeAnimationFor:_myMessageButton alpha:0];
                    self.mySearchView.userInteractionEnabled = NO;
                    _mySourceFavButton.hidden = YES;
                    _myDestinationFavButton.hidden = YES;
                    
                    if (myTripStatusIdInteger == SR_TRIP_STARTED) {
                        
                        aStatusString = @"Trip Started";
                        
                        NSMutableDictionary *aMutableDict = [NSMutableDictionary new];
                        aMutableDict = [aJsonId objectForKey:@"Ride_Response"];
                        _myRideResponseMutableArray = [NSMutableArray new];
                        
                        myCancelCharge = [aMutableDict valueForKey:@"Cancellation_Msg"];
                        
                        if (aMutableDict.count)
                            [_myRideResponseMutableArray addObject:aMutableDict];
                        
                        [NAVIGATION setTitleWithBarButtonItems:@"Trip Started" forViewController:self showLeftBarButton:IMAGE_MENU showRightBarButton:nil];
                        // self.navigationItem.leftBarButtonItem = nil;
                        
                        [HELPER showNotificationSuccessIn:self withMessage:aJsonId[kRESPONSE][kRESPONSE_MESSAGE]];
                        [SESSION isAlertShown:YES];
                        
                        if (_myRideResponseMutableArray.count)
                            [self changeViewBasedOnRide];
                        
                    }
                    else {
                        
                        aStatusString = @"Trip Completed";
                        
                        [NAVIGATION setTitleWithBarButtonItems:@"Trip Completed" forViewController:self showLeftBarButton:nil showRightBarButton:nil];
                        self.navigationItem.leftBarButtonItem = nil;
                        
                        aMutableArray = [aJsonId valueForKey:@"Trip_Details"];
                        
                        [HELPER showAlertView:self title:APP_NAME message:aJsonId[kRESPONSE][kRESPONSE_MESSAGE] okButtonBlock:^(UIAlertAction *action) {
                            
                            if (_myRideResponseMutableArray.count)
                                [self changeViewBasedOnRide];
                            
                            [SESSION isAlertShown:YES];
                            
                            if (aMutableArray.count) {
                                
                                isMoveToInvoiceScreen = YES;
                                
                                [[NSNotificationCenter defaultCenter] removeObserver:self  name:VIEW_UPADTE_BASED_ON_REQUEST_STATUS object:nil];
                                
                                LUInvoiceViewController *aViewController = [STORY_BOARD instantiateViewControllerWithIdentifier:@"LUInvoiceViewController"];
                                aViewController.gInfoArray = aMutableArray;
                                aViewController.gTripIdString = myTripIdString;
                                aViewController.gUserIdString = [SESSION getUserInfo][0][K_CUSTOMER_ID];
                                aViewController.myHubProxy = myHubProxy;
                                aViewController.myHubConnection = _myHubConnection;
                                aViewController.myProfileUrl = _myRideResponseMutableArray[0][@"Driver_Image"];
                                
                                [self.navigationController pushViewController:aViewController animated:YES];
                            }
                        }];
                    }
                }
                
                if (myTripStatusIdInteger == SR_TRIP_ACCEPTED) {
                    
                }
            }
        }
        
        else if ([aJsonId[kRESPONSE][kRESPONSE_CODE] intValue] == k_BAD_REQUEST || [aJsonId[kRESPONSE][kRESPONSE_CODE] intValue] == K_NO_DATA_CODE) {
            
            [HELPER showNotificationSuccessIn:self withMessage:aJsonId[kRESPONSE][kRESPONSE_MESSAGE]];
        }
        else {
            
            [TestFairy sendUserFeedback:[NSString stringWithFormat:@"case --- changeStatusBasedOnRequest, response -- %@",aJsonId]];
            
        }
    }
}

-(void)getTripId:(NSString *)aMessage {
    
    NSData *data = [aMessage dataUsingEncoding:NSUTF8StringEncoding];
    id aJsonId = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    if (aJsonId)
        myTripIdString = [aJsonId objectForKey:@"Trip_Id"];
    
    if (myTripIdString.length && _myServiceTypeMutableArray.count) {
        
        [self getAllChatList];
        _myRequestLoadingButton.hidden = NO;
        _myRequestCancelLabel.hidden = NO;
    }
    if ([aJsonId[kRESPONSE][kRESPONSE_CODE] intValue] == -2)
        [TestFairy sendUserFeedback:[NSString stringWithFormat:@"case --- receivetripid, response -- %@",aJsonId]];
    
}

-(void)receiveCancelTrip:(NSString *)aMessage {
    
    NSData *data = [aMessage dataUsingEncoding:NSUTF8StringEncoding];
    id aJsonId = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSString *aStatusString;
    
    if (aJsonId) {
        
        if (isInChatScreen)
            [self dismissViewControllerAnimated:YES completion:nil];
        
        if (myTripStatusIdInteger != 2)
            [HELPER showNotificationSuccessIn:self withMessage:aJsonId[kRESPONSE][kRESPONSE_MESSAGE]];
        
        aStatusString = aJsonId[kRESPONSE][kRESPONSE_MESSAGE];
        
        
        [HELPER fadeAnimationFor:_myBidBgView alpha:0];
        [HELPER fadeAnimationFor:_myActivityIndicatorView alpha:0];
        [HELPER fadeAnimationFor:_myRequestView alpha:0];
        [HELPER fadeAnimationFor:_myBgView alpha:1];
        _myRequestButtonHeightConstraint.constant = 45;
        
    }
    else {
        
        [HELPER fadeAnimationFor:_myBidBgView alpha:0];
        [HELPER fadeAnimationFor:_myActivityIndicatorView alpha:0];
        [HELPER fadeAnimationFor:_myRequestView alpha:0];
        [HELPER fadeAnimationFor:_myBgView alpha:1];
        _myRequestButtonHeightConstraint.constant = 45;
    }
    
    {
        _mySearchView.userInteractionEnabled = YES;
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [HELPER fadeAnimationFor:_myRequestView alpha:0];
        myNearestTripTimer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(getNearestVehiclesList) userInfo:nil repeats:YES];
        
        [self getAddressFromLocation];
        [self zoomToLocation];
        [self getFareEstimation];
    });
    
    [NAVIGATION setTitleWithBarButtonItems:_gServiceTag.service_type_name forViewController:self showLeftBarButton:IMAGE_BACK showRightBarButton:nil];
    [_mySubmitButton setTitle:[NSString stringWithFormat:@"Request for %@",_gServiceTag.service_type_name] forState:UIControlStateNormal];
    [SESSION isRequested:NO];
    myCancelIdString = @"";
    isRequestStarted = NO;
    
    if ([aJsonId[kRESPONSE][kRESPONSE_CODE] intValue] == -2)
        [TestFairy sendUserFeedback:[NSString stringWithFormat:@"case --- receiveCancelrequest, response -- %@",aJsonId]];
    
}


-(void)getChatList:(NSString *)response {
    
    if (![response isKindOfClass:[NSDictionary class]]) {
        
        NSData *data = [response dataUsingEncoding:NSUTF8StringEncoding];
        id aJsonId = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        if ([aJsonId[kRESPONSE][kRESPONSE_CODE] intValue] == kSUCCESS_CODE) {
            
            if (self.isViewLoaded && self.view.window)
                
                [HELPER showNotificationSuccessIn:self withMessage:@"You have a new message"];
            
            [self getAllChatList];
        }
        
        else if ([aJsonId[kRESPONSE][kRESPONSE_CODE] intValue] == k_BAD_REQUEST || [aJsonId[kRESPONSE][kRESPONSE_CODE] intValue] == K_NO_DATA_CODE) {
            
            [HELPER showNotificationSuccessIn:self withMessage:aJsonId[kRESPONSE][kRESPONSE_MESSAGE]];
        }
        else {
            
            [TestFairy sendUserFeedback:[NSString stringWithFormat:@"case --- receiveChat, response -- %@",aJsonId]];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_VIEW_UPADTE_BASED_ON_CHAT_STATUS object:nil userInfo:[NSDictionary dictionaryWithObject:response forKey:NOTIFICATION_CHAT_STATUS_KEY]];
    }
    else {
        
        
    }
}


-(void)getAllChatList {
    
    myCurrentRequest = SR_RECEIVE_CHAT_MESSAGE_REQUEST;
    
    [myHubProxy invoke:SR_GET_ALL_CHAT_MESSAGE withArgs:@[myTripIdString] completionHandler:^(id response, NSError *error) {
        
        if (!error) {
            
            if (![response isKindOfClass:[NSDictionary class]]) {
                
                NSData *data = [response dataUsingEncoding:NSUTF8StringEncoding];
                id aJsonId = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                NSMutableArray * aChatInfoMutableArray = [NSMutableArray new];
                
                if ([aJsonId[kRESPONSE][kRESPONSE_CODE] intValue] == kSUCCESS_CODE) {
                    
                    aChatInfoMutableArray = [aJsonId objectForKey:@"Chat_Info"];
                    [SESSION setChatInfo:aChatInfoMutableArray];
                    
                }
                else if ([aJsonId[kRESPONSE][kRESPONSE_CODE] intValue] == k_BAD_REQUEST || [aJsonId[kRESPONSE][kRESPONSE_CODE] intValue] == K_NO_DATA_CODE) {
                    
                    if (![SESSION getChatInfo].count)
                        [SESSION setChatInfo:aChatInfoMutableArray];
                }
                else {
                    [TestFairy sendUserFeedback:[NSString stringWithFormat:@"case --- receiveAllChat, response -- %@",aJsonId]];
                    
                }
            }
        }
        else {
            
            [TestFairy sendUserFeedback:[NSString stringWithFormat:@"case --- receiveAllChat, response -- %@",error]];
            
            if (error.code == NSURLErrorTimedOut)
                [HELPER showRetryAlertIn:self details:ALERT_SIGNALR_UNABLE_TO_REACH_DICT retryBlock:^{
                    
                    if ([HTTPMANAGER isNetworkRechable]) {
                        
                        [HELPER removeRetryAlertIn:self];
                        [HELPER showLoadingIn:self];
                        [self getAllChatList];
                    }
                }];
            else
                [HELPER showNotificationSuccessIn:self withMessage:MESSAGE_SOMETHING_WENT_WRONG];
        }
    }];
}

-(void)getDriverLocation:(NSString *)response {
    
    if (myTripStatusIdInteger == SR_TRIP_ACCEPTED) {
        
        if (![response isKindOfClass:[NSDictionary class]]) {
            
            NSData *data = [response dataUsingEncoding:NSUTF8StringEncoding];
            id aJsonId = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            if ([aJsonId[kRESPONSE][kRESPONSE_CODE] intValue] == kSUCCESS_CODE) {
                
                NSMutableDictionary * aInfoMutableDict = [NSMutableDictionary new];
                aInfoMutableDict = [aJsonId objectForKey:@"Driver_Info"][0];
                
                NSString *aString = [NSString stringWithFormat:@"%@,%@", aInfoMutableDict[K_FAVORITE_LATITUDE],aInfoMutableDict[K_FAVORITE_LONGITUDE]];
                
                _myDriverInfoMutableArray = [NSMutableArray new];
                [_myDriverInfoMutableArray addObject:aString];
                
                if (_myDriverInfoMutableArray.count) {
                    
                    [self addLocationAnddrawRouteBetweenDriverAndCustomer];
                    
                    if (!isDriverRoutDrawn) {
                        
                        [self zoomToLocationFromDriverLocation];
                    }
                }
            }
            
            else if ([aJsonId[kRESPONSE][kRESPONSE_CODE] intValue] == k_BAD_REQUEST || [aJsonId[kRESPONSE][kRESPONSE_CODE] intValue] == K_NO_DATA_CODE) {
                
                [HELPER showNotificationSuccessIn:self withMessage:aJsonId[kRESPONSE][kRESPONSE_MESSAGE]];
            }
            else {
                
                [TestFairy sendUserFeedback:[NSString stringWithFormat:@"case --- receivedriverlocation, response -- %@",aJsonId]];
            }
        }
        else {
            
            
        }
    }
}

#pragma mark - Tap Gesture -

-(void)setUpTapActionForView {
    
    UITapGestureRecognizer *aShareGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shareButtonTapped)];
    aShareGesture.numberOfTapsRequired = 1;
    _myShareView.userInteractionEnabled = YES;
    [_myShareView addGestureRecognizer:aShareGesture];
    
    UITapGestureRecognizer *aNotificationGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(notificationButtonTapped)];
    aNotificationGesture.numberOfTapsRequired = 1;
    _myNotificationView.userInteractionEnabled = YES;
    [_myNotificationView addGestureRecognizer:aNotificationGesture];
    
    
    UITapGestureRecognizer *aCancelGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelButtonTapped)];
    aCancelGesture.numberOfTapsRequired = 1;
    _myCancelView.userInteractionEnabled = YES;
    [_myCancelView addGestureRecognizer:aCancelGesture];
}

-(void)shareButtonTapped {
    
    LUShareViewController *aViewController = [STORY_BOARD instantiateViewControllerWithIdentifier:@"LUShareViewController"];
    
    UINavigationController *aNavigationController = [[UINavigationController alloc]initWithRootViewController:aViewController];
    [self.navigationController presentViewController:aNavigationController animated:YES completion:^{
        
    }];
}

-(void)notificationButtonTapped {
    
    NSArray *aArray = [NSArray new];// StrCustomerId , StrFamilyIDs -(family id's with comma separated), StrFromLatitude, StrFromlongitude, StrTripId
    aArray = @[[SESSION getUserInfo][0][K_CUSTOMER_ID],[_gMapMutableInfo[0] componentsSeparatedByString:@","][0],[_gMapMutableInfo[0] componentsSeparatedByString:@","][1],myTripIdString];
    
    LUFamilyAndFriendsViewController *aViewController = [LUFamilyAndFriendsViewController new];
    aViewController.isForFamilyFriendsScreen = NO;
    aViewController.gInfoArray = aArray;
    UINavigationController *aNavigationController = [[UINavigationController alloc] initWithRootViewController:aViewController];
    [self.navigationController presentViewController:aNavigationController animated:YES completion:nil];
}

-(void)cancelButtonTapped {
    
    /*  [self.view bringSubviewToFront:_myBidBgView];
     
     [HELPER fadeAnimationFor:_myBidBgView alpha:1];
     [HELPER fadeAnimationFor:_myCancelReasonView alpha:1];
     [HELPER fadeAnimationFor:_myBidView alpha:0];
     [HELPER fadeAnimationFor:_myActivityIndicatorView alpha:0];*/
    
    if (!myCancelCharge.length)
        myCancelCharge = @"You may charged Cancellation fee of $10.0";
    
    myTripStatusIdInteger = SR_TRIP_BEFORE_CANCEL;
    
    [HELPER showAlertViewWithTitle:self title:SCREEN_TITLE_DASHBOARD message:myCancelCharge okButton:@"Yes" cancelButton:@"No" style:UIAlertActionStyleDefault okButtonBlock:^(UIAlertAction *action) {
        
        [HELPER showLoadingIn:self];
        [self cancelTrip];
        
    } cancelButtonBlock:^(UIAlertAction *action) {
        
        
    } isLeftAlign:NO];
}


#pragma mark - Helper -

#pragma mark -Acitivity Indicator

- (void)showLoadingActivityIndicator {
    
    [self.view bringSubviewToFront:self.myActivityIndicatorView];
    [HELPER fadeAnimationFor:self.myActivityIndicatorView alpha:1.0];
}

- (void)hideLoadingActivityIndicator {
    
    [HELPER fadeAnimationFor:self.myActivityIndicatorView alpha:0.0];
}


- (void)zoomToLocation {
    
    // Set Zoom Level
    
    CLLocationCoordinate2D aSourseCoord;
    CLLocationCoordinate2D aDestCoord;
    
    aSourseCoord.latitude = [[_gMapMutableInfo[0] componentsSeparatedByString:@","][0] doubleValue];
    aSourseCoord.longitude = [_gMapMutableInfo[0] componentsSeparatedByString:@","][1].doubleValue;
    
    aDestCoord.latitude = [[_gMapMutableInfo[1] componentsSeparatedByString:@","][0] doubleValue];
    aDestCoord.longitude = [_gMapMutableInfo[1] componentsSeparatedByString:@","][1].doubleValue;
    
    if (_gMapMutableInfo.count) {
        
        [_myMapLatLongMutableArray addObject:_gMapMutableInfo[0]];
        [_myMapLatLongMutableArray addObject:_gMapMutableInfo[1]];
        
    }
    
    
    GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] initWithCoordinate:aSourseCoord coordinate:aDestCoord];
    GMSCameraPosition *aCamera = [_myMapView cameraForBounds:bounds insets:UIEdgeInsetsMake(160, 100, 160, 100)];
    _myMapView.camera = aCamera;
    
    [self.myMapView animateToCameraPosition:aCamera];
}

- (void)zoomToLocationFromDriverLocation {
    
    // Set Zoom Level
    
    CLLocationCoordinate2D aSourseCoord;
    CLLocationCoordinate2D aDestCoord;
    
    aSourseCoord.latitude = [[myDriverRoutInfoMutableArray[0] componentsSeparatedByString:@","][0] doubleValue];
    aSourseCoord.longitude = [myDriverRoutInfoMutableArray[0] componentsSeparatedByString:@","][1].doubleValue;
    
    aDestCoord.latitude = [[myDriverRoutInfoMutableArray[1] componentsSeparatedByString:@","][1] doubleValue];
    aDestCoord.longitude = [myDriverRoutInfoMutableArray[1] componentsSeparatedByString:@","][0].doubleValue;
    
    GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] initWithCoordinate:aSourseCoord coordinate:aDestCoord];
    GMSCameraPosition *aCamera = [_myMapView cameraForBounds:bounds insets:UIEdgeInsetsMake(160, 100, 160, 100)];
    _myMapView.camera = aCamera;
    isDriverRoutDrawn = YES;
    
    [self.myMapView animateToCameraPosition:aCamera];
}

- (void)checkLocationAccessibilityAndStartUpdatingLocation {
    
    if ([HELPER isLocationAccessAllowed]) {
        
        [HELPER removeRetryAlertIn:self];
        [myLocationManager startUpdatingLocation];
    }
    
    else {
        
        [HELPER removeAlertIn:self];
        [HELPER showRetryAlertIn:self details:@{KEY_ALERT_TITLE:ALERT_RETRY_TITLE,KEY_ALERT_DESC:ALERT_UNABLE_TO_FETCH_LOCATION@". Please make sure that 'Location Service' is enabled and 'location is allowed to access' in Settings.",KEY_ALERT_IMAGE:ALERT_NO_LOCATION} retryBlock:^{
            
            if ([HELPER isLocationAccessAllowed]) {
                
                [HELPER showLoadingIn:self text:@"Fetching your location"];
                [HELPER removeRetryAlertIn:self];
                
                [myLocationManager startUpdatingLocation];
            }
            else {
                
                // Goto settings
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            }
        }];
    }
}

- (void)getAddressFromLocation {
    
    NSString *alatitude;
    NSString *alongitude;
    
    if (_mySearchTypeEnum == SEARCH_TYPE_SOURCE) {
        
        alatitude = [_gMapMutableInfo[0] componentsSeparatedByString:@","][0];
        alongitude = [_gMapMutableInfo[0] componentsSeparatedByString:@","][1];
    }
    else {
        
        alatitude = [_gMapMutableInfo[1] componentsSeparatedByString:@","][0];
        alongitude = [_gMapMutableInfo[1] componentsSeparatedByString:@","][1];
    }
    
    CLLocationCoordinate2D newLocation;
    newLocation.latitude = alatitude.doubleValue;
    newLocation.longitude = alongitude.doubleValue;
    
    if (gettingAddressFromLatLng == NO) {
        
        if (![HTTPMANAGER isNetworkRechable]) {
            
            [HELPER showAlertViewWithCancel:self title:ALERT_NO_INTERNET_DESC okButtonBlock:^(UIAlertAction *action) {
                
                [self getAddressFromLocation];
                
            } cancelButtonBlock:^(UIAlertAction *action) {
                
            }];
            return;
        }
        
        NSString *aString = [NSString stringWithFormat:@"%f,%f", newLocation .latitude, newLocation .longitude];
        
        gettingAddressFromLatLng = YES;
        
        if (_mySearchTypeEnum == SEARCH_TYPE_SOURCE) {
            
            if (!isForFavLocation)
                _mySearchSourceTextfield.text = @"";
            
            _mySearchSourceTextfield.placeholder = @"Finding location...";
            
        }
        else {
            
            if (!isForFavLocation)
                _mySearchDistinationTextfield.text = @"";
            
            _mySearchDistinationTextfield.placeholder = @"Finding location...";
        }
        
        [[GMSGeocoder geocoder] reverseGeocodeCoordinate:newLocation completionHandler:^(GMSReverseGeocodeResponse *aResponse, NSError *aError) {
            
            BOOL aSuccess = NO;
            
            if (aError == nil) {
                
                GMSAddress *aAddress = aResponse.firstResult;
                
                NSMutableDictionary *aMDictionary = [NSMutableDictionary new];
                
                aMDictionary[K_FAVORITE_LATITUDE] = [NSString stringWithFormat:@"%f",aResponse.firstResult.coordinate.latitude];
                aMDictionary[K_FAVORITE_LONGITUDE] = [NSString stringWithFormat:@"%f",aResponse.firstResult.coordinate.longitude];
                aMDictionary[K_FAVORITE_ADDRESS] = aAddress.lines[0];
                aMDictionary[K_FAVORITE_DISPLAY_NAME] = @"";
                aMDictionary[K_FAVORITE_PRIMARY_LOCATION] = @"";
                aMDictionary[K_FAVORITE_ID] = @"";
                
                if (aAddress) {
                    
                    aSuccess = YES;
                    
                    // Set text in textfield based on the search
                    if (_mySearchTypeEnum == SEARCH_TYPE_SOURCE) {
                        
                        myFavSourseMutableDictionary = aMDictionary;
                        
                        myFavSourseMutableDictionary[K_FAVORITE_LATITUDE] = alatitude;
                        myFavSourseMutableDictionary[K_FAVORITE_LONGITUDE] = alongitude;
                        
                        if (isFavChanged)
                            [self setFavoriteBasedOnSelectedAddress:myFavSourseMutableDictionary];
                        
                        _mySearchSourceTextfield.placeholder = @"Search location...";
                    }
                    else if (_mySearchTypeEnum == SEARCH_TYPE_DESTINATION) {
                        
                        myFavDestMutableDictionary = aMDictionary;
                        
                        myFavDestMutableDictionary[K_FAVORITE_LATITUDE] = alatitude;
                        myFavDestMutableDictionary[K_FAVORITE_LONGITUDE] = alongitude;
                        
                        if (isFavChanged)
                            [self setFavoriteBasedOnSelectedAddress:myFavDestMutableDictionary];
                        
                        _mySearchSourceTextfield.placeholder = @"Search location...";
                    }
                    
                    
                    // Set text in textfield based on the search
                    if (_mySearchTypeEnum == SEARCH_TYPE_SOURCE) {
                        
                        if (_myMapLocationMutableArray.count)
                            [_myMapLocationMutableArray replaceObjectAtIndex:0 withObject:aString];
                        else
                            [_myMapLocationMutableArray insertObject:aString atIndex:0];
                        
                        if (!isForFavLocation) {
                            
                            myAddressString = aAddress.lines[0];
                            _mySearchSourceTextfield.text = myAddressString;
                            
                            if (myAddressString.length) {
                                if (_mySearchMutableInfo.count)
                                    [_mySearchMutableInfo replaceObjectAtIndex:0 withObject:myAddressString];
                                else
                                    [_mySearchMutableInfo insertObject:myAddressString atIndex:0];
                            }
                        }
                    }
                    else if (_mySearchTypeEnum == SEARCH_TYPE_DESTINATION) {
                        
                        if (_myMapLocationMutableArray.count)
                            if ( _myMapLocationMutableArray.count > 1)
                                [_myMapLocationMutableArray replaceObjectAtIndex:1 withObject:aString];
                            else
                                [_myMapLocationMutableArray addObject:aString];
                            else
                                [_myMapLocationMutableArray insertObject:aString atIndex:1];
                        
                        if (!isForFavLocation) {
                            
                            myAddressString = aAddress.lines[0];
                            _mySearchDistinationTextfield.text = myAddressString;
                            
                            if (myAddressString.length) {
                                if (_mySearchMutableInfo.count) {
                                    
                                    if ( _mySearchMutableInfo.count > 1)
                                        [_mySearchMutableInfo replaceObjectAtIndex:1 withObject:myAddressString];
                                    else
                                        [_mySearchMutableInfo addObject:myAddressString];
                                }
                                else
                                    [_mySearchMutableInfo insertObject:myAddressString atIndex:1];
                            }
                        }
                        
                    }
                    if (_myServiceTypeMutableArray.count) {
                        
                        _mySubmitButton.userInteractionEnabled = YES;
                        _mySubmitButton.backgroundColor = [UIColor blackColor];
                    }
                    
                    _myMapInfoArray = _myMapLocationMutableArray;
                }
                if (isForFavLocation)
                    isForFavLocation = NO;
            }
            
            if (aSuccess == NO) {
                // Unable to get user locality so display error
                myAddressString = ALERT_UNABLE_TO_FETCH_LOCATION@". Move the map to try again";
            }
            else {
                
                myLocationCoordinate = newLocation;
            }
            
            gettingAddressFromLatLng = NO;
        }];
        
        [self hideLoadingActivityIndicator];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        /* if (_mySearchTypeEnum == SEARCH_TYPE_SOURCE) {
         
         if ([_mySearchSourceTextfield.text isEqualToString:@""])
         _mySearchSourceTextfield.text = (myCurrentFavMutableDict.count) ? myCurrentFavMutableDict[K_FAVORITE_ADDRESS] :  @"";
         }
         else if (_mySearchTypeEnum == SEARCH_TYPE_DESTINATION) {
         
         if ([_mySearchSourceTextfield.text isEqualToString:@""])
         _mySearchDistinationTextfield.text = (myCurrentFavMutableDict.count) ? myCurrentFavMutableDict[K_FAVORITE_ADDRESS] : @"";
         }*/
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self addLocationAnddrawRoute];
    });
}


// Remove Pin Annotation
- (void)removePinAnnotation {
    
    [_myMapView clear];
}

-(void)setUpNavigationBar {
    
    self.navigationController.navigationBar.barTintColor = COLOR_NAVIGATION_COLOR;
    self.navigationController.navigationBar.tintColor = WHITE_COLOUR;
    [self.navigationController.navigationBar setTranslucent:YES];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    self.navigationController.navigationBar.layer.shadowColor = (__bridge CGColorRef _Nullable)(WHITE_COLOUR);
    
    // TO SET TILE COLOR & FONT
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:FONT_HELVETICA_NEUE size:14.0];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = WHITE_COLOUR;
    self.navigationItem.titleView = label;
    label.text = TITLE_DASHBOARD;
    [label sizeToFit];
    
    self.navigationItem.leftBarButtonItem  = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:IMAGE_BACK] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonTapEvent)];
}

// Hide Keyboard
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
}

-(void)addOrDeletebasedOnTheButtonStatus:(BOOL)isSource  {
    
    NSMutableDictionary *aMutableDict = [NSMutableDictionary new];
    
    if (_mySearchTypeEnum == SEARCH_TYPE_SOURCE) {
        
        aMutableDict[K_FAVORITE_LATITUDE] = [_gMapMutableInfo[0] componentsSeparatedByString:@","][0];
        aMutableDict[K_FAVORITE_LONGITUDE] = [_gMapMutableInfo[0] componentsSeparatedByString:@","][1];
        aMutableDict[K_FAVORITE_ADDRESS] = _mySearchSourceTextfield.text;
    }
    else {
        
        aMutableDict[K_FAVORITE_LATITUDE] = [_gMapMutableInfo[1] componentsSeparatedByString:@","][0];
        aMutableDict[K_FAVORITE_LONGITUDE] = [_gMapMutableInfo[1] componentsSeparatedByString:@","][1];
        aMutableDict[K_FAVORITE_ADDRESS] = _mySearchDistinationTextfield.text;
    }
    
    // To add  the location as favorite
    LUFavouritePopViewController * aViewController = [STORY_BOARD instantiateViewControllerWithIdentifier:@"LUFavouritePopViewController"];
    [aViewController setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    aViewController.isForPromoCode = NO;
    aViewController.gMutableDictionary = aMutableDict;
    aViewController.callBackBlock = ^(BOOL isCallBack, NSMutableArray *aMArray) {
        
        if (isCallBack) {
            
            for (int i = 0; i < aMArray.count ; i++) {
                
                TagFavouriteType *aTag = [aMArray objectAtIndex:i];
                
                
                NSString *aLatitude = [NSString stringWithFormat:@"%@",aTag.favourite_latitude];
                NSString *aLongitude = [NSString stringWithFormat:@"%@",aTag.favourite_longitude];
                NSString *aCurrentLongitude = @"";
                NSString *aCurrentLatitude = @"";
                
                if (myCurrentFavMutableDict.count) {
                    
                    aCurrentLatitude = [NSString stringWithFormat:@"%@",myCurrentFavMutableDict[K_FAVORITE_LATITUDE]];
                    aCurrentLongitude = [NSString stringWithFormat:@"%@",myCurrentFavMutableDict[K_FAVORITE_LONGITUDE]];
                }
                
                if (_mySearchTypeEnum == SEARCH_TYPE_SOURCE) {
                    
                    if (!myCurrentFavMutableDict.count) {
                        
                        aCurrentLatitude = [NSString stringWithFormat:@"%@",myFavSourseMutableDictionary[K_FAVORITE_LATITUDE]];
                        aCurrentLongitude = [NSString stringWithFormat:@"%@",myFavSourseMutableDictionary[K_FAVORITE_LONGITUDE]];
                    }
                }
                else {
                    
                    if (!myCurrentFavMutableDict.count) {
                        
                        aCurrentLatitude = [NSString stringWithFormat:@"%@",myFavDestMutableDictionary[K_FAVORITE_LATITUDE]];
                        aCurrentLongitude = [NSString stringWithFormat:@"%@",myFavDestMutableDictionary[K_FAVORITE_LONGITUDE]];
                    }
                }
                
                if (_mySearchTypeEnum == SEARCH_TYPE_SOURCE) {
                    
                    if (myFavSourseMutableDictionary.count == 0) {
                        
                        aCurrentLatitude = [NSString stringWithFormat:@"%@",aMutableDict[K_FAVORITE_LATITUDE]];
                        aCurrentLongitude = [NSString stringWithFormat:@"%@",aMutableDict[K_FAVORITE_LONGITUDE]];
                    }
                    
                    if ([[aCurrentLatitude substringToIndex:8] isEqualToString:aLatitude] && [[aCurrentLongitude substringToIndex:8] isEqualToString:aLongitude]) {
                        
                        myFavSourseMutableDictionary[K_FAVORITE_ID] = aTag.favourite_type_id;
                        
                        if (_mySearchTypeEnum == SEARCH_TYPE_SOURCE) {
                            
                            gfavoriteIdString  = aTag.favourite_type_id;
                            isFavSource = YES;
                            _mySourceFavButton.selected = isFavSource;
                            _myDestinationFavButton.userInteractionEnabled = NO;
                            _mySourceFavButton.userInteractionEnabled = YES;
                        }
                        else {
                            
                            gFavoriteDestinationIdString  = aTag.favourite_type_id;
                            isFavDestination = YES;
                            _myDestinationFavButton.selected = isFavDestination;
                            _myDestinationFavButton.userInteractionEnabled = YES;
                            _mySourceFavButton.userInteractionEnabled = NO;
                        }
                    }
                }
                else {
                    
                    if (myFavDestMutableDictionary.count == 0) {
                        
                        aCurrentLatitude = [NSString stringWithFormat:@"%@",aMutableDict[K_FAVORITE_LATITUDE]];
                        aCurrentLongitude = [NSString stringWithFormat:@"%@",aMutableDict[K_FAVORITE_LONGITUDE]];
                    }
                    
                    if ([[aCurrentLatitude substringToIndex:8] isEqualToString:aLatitude] && [[aCurrentLongitude substringToIndex:8] isEqualToString:aLongitude]) {
                        
                        
                        myFavDestMutableDictionary[K_FAVORITE_ID] = aTag.favourite_type_id;
                        
                        if (_mySearchTypeEnum == SEARCH_TYPE_SOURCE) {
                            
                            gfavoriteIdString  = aTag.favourite_type_id;
                            isFavSource = YES;
                            _mySourceFavButton.selected = isFavSource;
                            _myDestinationFavButton.userInteractionEnabled = NO;
                            _mySourceFavButton.userInteractionEnabled = YES;
                        }
                        else {
                            
                            gFavoriteDestinationIdString  = aTag.favourite_type_id;
                            isFavDestination = YES;
                            _myDestinationFavButton.selected = isFavDestination;
                            _myDestinationFavButton.userInteractionEnabled = YES;
                            _mySourceFavButton.userInteractionEnabled = NO;
                        }
                    }
                }
            }
        }
    };
    
    [self presentViewController:aViewController animated:YES completion:^{
        
    }];
}

- (void)addCarLocation {
    
    NSString *alatitude;
    NSString *alongitude;
    NSMutableArray *aCarInfo = [NSMutableArray new];
    
    [_myMapView clear];
    [self addLocationAnddrawRoute];
    
    if (_myServiceLocationTypeMutableArray.count)
        aCarInfo = _myServiceLocationTypeMutableArray[0][@"Carslocations"];
    
    for (int i = 0; i < aCarInfo.count; i++) {
        
        // This is set based on web service in werb servcice they retnru the lat as long & long as lat
        alatitude = aCarInfo[i] [SR_CAR_LOCATION_LONGITUDE];
        alongitude = aCarInfo[i] [SR_CAR_LOCATION_LATITUDE];
        
        CLLocationCoordinate2D aCoordination2D;
        aCoordination2D.latitude = alatitude.doubleValue;
        aCoordination2D.longitude = alongitude.doubleValue;
        
        
        // Add User Marker
        
        [UIView animateWithDuration:1.0 delay:2.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            GMSMarker *aUserMarker = [[GMSMarker alloc]init];
            aUserMarker.title = @"";
            aUserMarker.position = aCoordination2D;
            aUserMarker.map = _myMapView;
            aUserMarker.appearAnimation = kGMSMarkerAnimationNone;
            aUserMarker.icon = [UIImage imageNamed:IMAGE_CAR_MARKER];
            
        } completion:nil];
        
  
        
    }
}
- (void)addLocationAnddrawRoute {
    
    [self removePinAnnotation];
    
    NSString *alatitude;
    NSString *alongitude;
    
    
    for (int i = 0; i < _gMapMutableInfo.count; i++) {
        
        alatitude = [_gMapMutableInfo[i] componentsSeparatedByString:@","][0];
        alongitude = [_gMapMutableInfo[i] componentsSeparatedByString:@","][1];
        
        CLLocationCoordinate2D aCoordination2D;
        aCoordination2D.latitude = alatitude.doubleValue;
        aCoordination2D.longitude = alongitude.doubleValue;
        
        
        // Add User Marker
        [UIView animateWithDuration:1.0 delay:2.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            GMSMarker *aUserMarker = [GMSMarker new];
            aUserMarker.title = @"";
            aUserMarker.position = aCoordination2D;
            aUserMarker.map = self.myMapView;
            aUserMarker.appearAnimation = kGMSMarkerAnimationPop;
            
            if (i == 0) {
                
                aUserMarker.icon = [UIImage imageNamed:IMAGE_FROM_MARKER];
            }
            else
                aUserMarker.icon = [UIImage imageNamed:IMAGE_TO_MARKER];
            
        } completion:nil];
    }
    
    if (myRoutePolyLine) {
        // Remove existing Route
        myRoutePolyLine.map = nil;
    }
    
    [self fetchPolylineWithCompletionHandler:^(GMSPolyline *aGMSPolyline) {
        
        // To draw a Route
        myRoutePolyLine = aGMSPolyline;
        _myMapView.hidden = NO;
        
        myRoutePolyLine.strokeColor = [UIColor redColor];
        myRoutePolyLine.strokeWidth = 2.0f;
        myRoutePolyLine.map = self.myMapView;
        
    } failedBlock:^(NSError *error) {
        
        
    }];
    
    [_myMapView reloadInputViews];
}

- (void)addLocationAnddrawRouteBetweenDriverAndCustomer {
    
    [self removePinAnnotation];
    
    NSString *alatitude;
    NSString *alongitude;
    
    myDriverRoutInfoMutableArray = [NSMutableArray new];
    
    if (_gMapMutableInfo.count && _myDriverInfoMutableArray.count) {
        
        [myDriverRoutInfoMutableArray addObject: _gMapMutableInfo[0]];
        [myDriverRoutInfoMutableArray addObject: _myDriverInfoMutableArray[0]];
        
    }
    
    for (int i = 0; i < myDriverRoutInfoMutableArray.count; i++) {
        
        if (i == 0) {
            
            alatitude = [myDriverRoutInfoMutableArray[0] componentsSeparatedByString:@","][0];
            alongitude = [myDriverRoutInfoMutableArray[0] componentsSeparatedByString:@","][1];
        }
        else {
            
            alatitude = [myDriverRoutInfoMutableArray[1] componentsSeparatedByString:@","][1];
            alongitude = [myDriverRoutInfoMutableArray[1] componentsSeparatedByString:@","][0];
        }
        
        CLLocationCoordinate2D aCoordination2D;
        aCoordination2D.latitude = alatitude.doubleValue;
        aCoordination2D.longitude = alongitude.doubleValue;
        
        
        
        // Add User Marker
        [UIView animateWithDuration:1.0 delay:2.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            GMSMarker *aUserMarker = [GMSMarker new];
            aUserMarker.title = @"";
            aUserMarker.position = aCoordination2D;
            aUserMarker.map = self.myMapView;
            aUserMarker.appearAnimation = kGMSMarkerAnimationPop;
            
            if (i == 0) {
                
                aUserMarker.icon = [UIImage imageNamed:IMAGE_FROM_MARKER];
            }
            else
                aUserMarker.icon = [UIImage imageNamed:IMAGE_CAR_MARKER];
            
        } completion:nil];
    }
    if (myDriverRoutInfoMutableArray.count) {
        
        if (myRoutePolyLine) {
            // Remove existing Route
            myRoutePolyLine.map = nil;
        }
        
        [self fetchPolylineFromDriverLocationWithCompletionHandler:^(GMSPolyline *aGMSPolyline) {
            
            // To draw a Route
            myRoutePolyLine = aGMSPolyline;
            _myMapView.hidden = NO;
            [HELPER fadeAnimationFor:_myMapView alpha:1];
            //            isDriverRoutDrawn = YES;
            
            myRoutePolyLine.strokeColor = [UIColor redColor];
            myRoutePolyLine.strokeWidth = 2.0f;
            myRoutePolyLine.map = self.myMapView;
            
        } failedBlock:^(NSError *error) {
            
            
        }];
        
        [_myMapView reloadInputViews];
    }
}


-(UIImage *)image:(UIImage*)originalImage scaledToSize:(CGSize)size {
    
    //avoid redundant drawing
    if (CGSizeEqualToSize(originalImage.size, size))
    {
        return originalImage;
    }
    
    //create drawing context
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0f);
    
    //draw
    [originalImage drawInRect:CGRectMake(0.0f, 0.0f, size.width, size.height)];
    
    //capture resultant image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //return image
    return image;
}

-(void)setFavoriteBasedOnRequest:(NSMutableDictionary *)aMDictionary {
    
    NSMutableArray *aMainMutableArray = [NSMutableArray new];
    aMainMutableArray = [[COREDATAMANAGER getFavouriteListInfo] mutableCopy];
    
    for (int i = 0; i < aMainMutableArray.count; i++) {
        
        TagFavouriteType *aTag = [aMainMutableArray objectAtIndex:i];
        
        BOOL isFavrite;
        
        if (aMDictionary == nil) {
            
            if([_gMapMutableInfo[0][K_FAVORITE_LATITUDE] isEqualToString:aTag.favourite_latitude] && [_gMapMutableInfo[0][K_FAVORITE_LONGITUDE] isEqualToString:aTag.favourite_longitude]) {
                
                isFavrite = YES;
                
                if (_mySearchTypeEnum == SEARCH_TYPE_SOURCE) {
                    
                    _mySourceFavButton.selected = YES;
                    isFavSource = YES;
                    myFavSourseMutableDictionary[K_FAVORITE_ID] = aTag.favourite_type_id;
                    gfavoriteIdString = aTag.favourite_type_id;
                    myFavoritePrimaryLocation = aTag.favourite_primary_location;
                }
                else {
                    
                    _myDestinationFavButton.selected = YES;
                    isFavDestination = YES;
                    myFavDestMutableDictionary[K_FAVORITE_ID] = aTag.favourite_type_id;
                    gFavoriteDestinationIdString = aTag.favourite_type_id;
                    myFavoritePrimaryLocation = aTag.favourite_primary_location;
                }
            }
            else {
                
                if (!isFavrite) {
                    
                    if (_mySearchTypeEnum == SEARCH_TYPE_SOURCE) {
                        
                        _mySourceFavButton.selected = NO;
                        isFavSource = NO;
                    }
                    else {
                        
                        _myDestinationFavButton.selected = NO;
                        isFavDestination = NO;
                    }
                }
            }
        }
        else {
            if([aMDictionary[K_FAVORITE_LATITUDE] isEqualToString:aTag.favourite_latitude] && [aMDictionary[K_FAVORITE_LONGITUDE] isEqualToString:aTag.favourite_longitude]) {
                
                isFavrite = YES;
                
                if (_mySearchTypeEnum == SEARCH_TYPE_SOURCE) {
                    
                    _mySourceFavButton.selected = YES;
                    isFavSource = YES;
                    myFavSourseMutableDictionary[K_FAVORITE_ID] = aTag.favourite_type_id;
                    gfavoriteIdString = aTag.favourite_type_id;
                    myFavoritePrimaryLocation = aTag.favourite_primary_location;
                }
                else {
                    
                    _myDestinationFavButton.selected = YES;
                    isFavDestination = YES;
                    myFavDestMutableDictionary[K_FAVORITE_ID] = aTag.favourite_type_id;
                    gFavoriteDestinationIdString = aTag.favourite_type_id;
                    myFavoritePrimaryLocation = aTag.favourite_primary_location;
                }
            }
            else {
                
                if (!isFavrite) {
                    
                    if (_mySearchTypeEnum == SEARCH_TYPE_SOURCE) {
                        
                        _mySourceFavButton.selected = NO;
                        isFavSource = NO;
                    }
                    else {
                        
                        _myDestinationFavButton.selected = NO;
                        isFavDestination = NO;
                    }
                }
            }
        }
    }
}

-(void)setFavoriteBasedOnSelectedAddress:(NSMutableDictionary *)aMDictionary {
    
    NSMutableArray *aMainMutableArray = [NSMutableArray new];
    aMainMutableArray = [[COREDATAMANAGER getFavouriteListInfo] mutableCopy];
    
    for (int i = 0; i < aMainMutableArray.count; i++) {
        
        TagFavouriteType *aTag = [aMainMutableArray objectAtIndex:i];
        
        
        BOOL isFavrite;
        
        NSString *aLatitude = [NSString stringWithFormat:@"%@",aTag.favourite_latitude];
        NSString *aLongitude = [NSString stringWithFormat:@"%@",aTag.favourite_longitude];
        
        
        NSString *aCurrentLatitude = [NSString stringWithFormat:@"%@",myCurrentFavMutableDict[K_FAVORITE_LATITUDE]];
        NSString *aCurrentLongitude = [NSString stringWithFormat:@"%@",myCurrentFavMutableDict[K_FAVORITE_LONGITUDE]];
        
        if (aCurrentLatitude.length < 8) {
            
            aCurrentLatitude = [HELPER setZeroAfterValue:aCurrentLatitude numberOfZero:8 - aCurrentLatitude.length];
        }
        if (aCurrentLongitude.length < 8) {
            
            aCurrentLongitude = [HELPER setZeroAfterValue:aCurrentLongitude numberOfZero:8 - aCurrentLongitude.length];
        }
        
        if (_mySearchTypeEnum == SEARCH_TYPE_SOURCE) {
            
            if (!myCurrentFavMutableDict.count) {
                
                aCurrentLatitude = [NSString stringWithFormat:@"%@",myFavSourseMutableDictionary[K_FAVORITE_LATITUDE]];
                aCurrentLongitude = [NSString stringWithFormat:@"%@",myFavSourseMutableDictionary[K_FAVORITE_LONGITUDE]];
            }
        }
        else {
            
            if (!myCurrentFavMutableDict.count) {
                
                aCurrentLatitude = [NSString stringWithFormat:@"%@",myFavDestMutableDictionary[K_FAVORITE_LATITUDE]];
                aCurrentLongitude = [NSString stringWithFormat:@"%@",myFavDestMutableDictionary[K_FAVORITE_LONGITUDE]];
            }
        }
        
        if (aMDictionary == nil) {
            
            for (int i = 0; i < _gMapMutableInfo.count; i++) {
                
                if([[aCurrentLatitude substringToIndex:8] isEqualToString:aLatitude] && [[aCurrentLongitude substringToIndex:8] isEqualToString:aLongitude]) {
                    
                    isFavrite = YES;
                    
                    if (_mySearchTypeEnum == SEARCH_TYPE_SOURCE) {
                        
                        _mySourceFavButton.selected = YES;
                        isFavSource = YES;
                        myFavSourseMutableDictionary[K_FAVORITE_ID] = aTag.favourite_type_id;
                        gfavoriteIdString = aTag.favourite_type_id;
                        myFavoritePrimaryLocation = aTag.favourite_primary_location;
                    }
                    else {
                        
                        _myDestinationFavButton.selected = YES;
                        isFavDestination = YES;
                        myFavDestMutableDictionary[K_FAVORITE_ID] = aTag.favourite_type_id;
                        gFavoriteDestinationIdString = aTag.favourite_type_id;
                        myFavoritePrimaryLocation = aTag.favourite_primary_location;
                    }
                }
                else {
                    
                    if (!isFavrite) {
                        
                        if (_mySearchTypeEnum == SEARCH_TYPE_SOURCE) {
                            
                            _mySourceFavButton.selected = NO;
                            isFavSource = NO;
                        }
                        else {
                            
                            _myDestinationFavButton.selected = NO;
                            isFavDestination = NO;
                        }
                    }
                }
            }
        }
        else {
            
            if([[aCurrentLatitude substringToIndex:8] isEqualToString:aLatitude] && [[aCurrentLongitude substringToIndex:8] isEqualToString:aLongitude]) {
                
                isFavrite = YES;
                
                if (_mySearchTypeEnum == SEARCH_TYPE_SOURCE) {
                    
                    _mySourceFavButton.selected = YES;
                    isFavSource = YES;
                    myFavSourseMutableDictionary[K_FAVORITE_ID] = aTag.favourite_type_id;
                    gfavoriteIdString = aTag.favourite_type_id;
                    myFavoritePrimaryLocation = aTag.favourite_primary_location;
                }
                else {
                    
                    _myDestinationFavButton.selected = YES;
                    isFavDestination = YES;
                    myFavDestMutableDictionary[K_FAVORITE_ID] = aTag.favourite_type_id;
                    gFavoriteDestinationIdString = aTag.favourite_type_id;
                    myFavoritePrimaryLocation = aTag.favourite_primary_location;
                }
            }
            else {
                
                if (!isFavrite) {
                    
                    if (_mySearchTypeEnum == SEARCH_TYPE_SOURCE) {
                        
                        _mySourceFavButton.selected = NO;
                        isFavSource = NO;
                    }
                    else {
                        
                        _myDestinationFavButton.selected = NO;
                        isFavDestination = NO;
                    }
                }
            }
        }
    }
}


-(void)changeViewBasedOnRide {
    
    [HELPER fadeAnimationFor:_myActivityIndicatorView alpha:0];
    [HELPER fadeAnimationFor:_myBgView alpha:0];
    [HELPER fadeAnimationFor:_myRequestView alpha:1];
    
    _myRequestButtonHeightConstraint.constant = 0;
    [self hideRequestLoadingView];
    
    [HELPER setURLProfileImageForImageView:_myProfileImageView URL:_myRideResponseMutableArray[0][@"Driver_Image"] placeHolderImage:IMAGE_NO_PROFILE];
    _myDriverNameLabel.text = _myRideResponseMutableArray[0][@"Driver_Name"];
    _myRatingLabel.text = [NSString stringWithFormat:@"%@ %@",_myRideResponseMutableArray[0][@"Driver_rating"], @"Rating"];
    myMobileNumberString = _myRideResponseMutableArray[0][@"Mobile_Number"];
    
}

static NSTimeInterval aInterval = -1;
static NSTimer *myTimer;
static NSTimeInterval myDifferenceInterval = 0;

-(void)showRequestLoadingView {
    
    myTripStatusIdInteger = SR_TRIP_BEFORE_CANCEL;
    [self.view bringSubviewToFront:_myRequestLoadingView];
    [HELPER fadeAnimationFor:_myRequestLoadingView alpha:1];
    [HELPER fadeAnimationFor:_myNVLoadingView alpha:1];
    
    myDGActivityIndicatorView = [[DGActivityIndicatorView alloc] initWithType:DGActivityIndicatorAnimationTypeBallSpinFadeLoader tintColor:[HELPER getColorFromHexaDecimal:COLOR_APP_PRIMARY] size:150];
    myDGActivityIndicatorView.myLoadingView = _myNVLoadingView;
    [myDGActivityIndicatorView startAnimating];
    [SESSION setRequestTime:[NSDate date]];
    [SESSION setIntegerValue:myDifferenceInterval];
    
    myTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateCountdown) userInfo:nil repeats:YES];
}

-(void)hideRequestLoadingView {
    
    aInterval = -1;
    [myTimer invalidate];
    _myTimerLabel.text = @"00:00";
    [myDGActivityIndicatorView stopAnimating];
    
    [HELPER fadeAnimationFor:_myNVLoadingView alpha:0];
    [HELPER fadeAnimationFor:_myRequestLoadingView alpha:0];
    
}


-(void) updateCountdown {
    
    aInterval = aInterval + 1;
    
    NSTimeInterval aWaitingTime = 1.0 /* This extra 1 sec is a workaround, remove it and try to know what the bug is :P */;
    
    myDifferenceInterval = aWaitingTime + aInterval;
    [SESSION setIntegerValue:myDifferenceInterval];
    
    _myTimerLabel.text = [HELPER getHoursMinutesLeftBasedonTimeInterval:myDifferenceInterval isSecondsRequired:YES isShortForm:NO];
}

static bool isAdded = NO;

// This method is done to reload the time with current value
-(void)refreshRequestTimer {
    
    if (!isAdded) {
        
        NSDate *aDate = [SESSION getRequestTime];
        //        NSDateComponents *aComponent = [[NSCalendar currentCalendar] components:NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:aDate toDate:[NSDate date] options:NSCalendarMatchStrictly];
        
        NSTimeInterval distanceBetweenDates = [[NSDate date] timeIntervalSinceDate:aDate];
        double secondsInAnHour = 3600;
        NSInteger aInteger = distanceBetweenDates ;/// secondsInAnHour;
        
        // NSInteger aInteger = [aComponent second];
        
        NSTimeInterval currentInterval = [[NSNumber numberWithInteger:aInteger - 2] doubleValue];
        
        aInterval = currentInterval;
    }
}

-(void)refreshScreenBasedOnStatus {
    
    if (myTripStatusIdInteger > SR_TRIP_ACCEPTED)
        if (!isMoveToInvoiceScreen)
            [self getOnGoingRequest];
}

-(void)changeViewBasedOnFav:(NSNotification *)notification {
    
    [self setFavoriteBasedOnSelectedAddress:nil];
}

-(void)updateIntegerConut {
    
    myRequestDeclinedInteger = myRequestDeclinedInteger + 1;
}
@end
