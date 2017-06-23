//
//  LUTripHistoryViewController.m
//  Levare User
//
//  Created by AngMac137 on 11/21/16.
//  Copyright © 2016 AngMac137. All rights reserved.
//

#import "LUTripHistoryViewController.h"
#import "LUTripHistoryDetailsViewController.h"

@interface LUTripHistoryViewController ()
{
    NSMutableArray *myInfoMutableArray;
    
}
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@end

@implementation LUTripHistoryViewController

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
    
    [NAVIGATION setTitleWithBarButtonItems:TITLE_TRIP_HISTORY forViewController:self showLeftBarButton:nil showRightBarButton:nil];
    [self setUpLeftBarButton];
    _myTableView.tableFooterView = [UIView new];
}

#pragma mark -Model

- (void)setupModel {
    
    myInfoMutableArray = [NSMutableArray new];
    [self callWebService];
}

- (void)loadModel {
    
}

#pragma mark - UITable view Delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return myInfoMutableArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellIdentifier =@"TripHistory";
    
    UITableViewCell *aCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (aCell == nil) {
        
        aCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    UIImageView *gBgImageView = (UIImageView *)[aCell viewWithTag:1];
    UIImageView *gProfileImageView = (UIImageView *)[aCell viewWithTag:2];
    UILabel *gTimeLabel = (UILabel *)[aCell viewWithTag:3];
    UILabel *gServiceNameLabel = (UILabel *) [aCell viewWithTag:4];
    UILabel *gStatusLabel = (UILabel *)[aCell viewWithTag:5];
    UILabel *gRateLabel = (UILabel *)[aCell viewWithTag:6];
    RatingView *gRatingView = (RatingView *)[aCell viewWithTag:7];
    UILabel *gAmountLabel = (UILabel *)[aCell viewWithTag:8];
    
    [HELPER addFloatingEffectToView:gProfileImageView];
    [HELPER roundCornerForView:gProfileImageView];
    
    [gRatingView setupSelectedImageName:RATE_WITH_GOLD_STAR unSelectedImage:RATE_WITH_NO_STAR minValue:0 maxValue:5 intervalValue:0.5 stepByStep:1];
    gRatingView.value = indexPath.row;
    gRatingView.userInteractionEnabled = NO;
    
    
    [HELPER setURLProfileImageForImageView:gProfileImageView URL:myInfoMutableArray[indexPath.row][@"Driver_Image"] placeHolderImage:IMAGE_NO_PROFILE];
    
    gTimeLabel.text = ([myInfoMutableArray[indexPath.row][@"Trip_Start_Time"] isEqualToString:@""])? @"--" : myInfoMutableArray[indexPath.row][@"Trip_Start_Time"];
    gServiceNameLabel.text = ([myInfoMutableArray[indexPath.row][@"Service_Type"] isEqualToString:@""])? @"--" : myInfoMutableArray[indexPath.row][@"Service_Type"];
    gRateLabel.text = ([myInfoMutableArray[indexPath.row][@"Driver_Rating"] isEqualToString:@""])? @"--" : myInfoMutableArray[indexPath.row][@"Driver_Rating"];
    gRatingView.value = ([myInfoMutableArray[indexPath.row][@"Driver_Rating"] isEqualToString:@""])? 0 : gRateLabel.text.integerValue;
    
    if ([myInfoMutableArray[indexPath.row][@"Trip_Amount"] containsString:@"FREE"]) {
        
        gAmountLabel.text = myInfoMutableArray[indexPath.row][@"Trip_Amount"];
    }
    else {
        
        float aAmountFloat = [myInfoMutableArray[indexPath.row][@"Trip_Amount"] floatValue];//%.0f
        gAmountLabel.text = ([myInfoMutableArray[indexPath.row][@"Trip_Amount"] isEqualToString:@""])? @"--" :  [NSString stringWithFormat:@"$ %.0f",aAmountFloat];
    }
    
    if ([myInfoMutableArray[indexPath.row][SR_TRIP_STATUS_ID] integerValue] == TRIP_ACCEPTED) {
        
        gStatusLabel.textColor = [HELPER getColorFromHexaDecimal:COLOR_APP_PRIMARY];
        gStatusLabel.text = @"Trip Accepted";
        [HELPER setURLProfileImageForImageView:gBgImageView URL:myInfoMutableArray[indexPath.row][@"Trip_Route"] placeHolderImage:ICON_TRIP_HISTORY_PLACEHOLDER_INPROGRESS];
        
    }
    else if ([myInfoMutableArray[indexPath.row][SR_TRIP_STATUS_ID] integerValue] == TRIP_STARTED) {
        
        gStatusLabel.textColor = [HELPER getColorFromHexaDecimal:COLOR_APP_PRIMARY];
        gStatusLabel.text = @"Trip Started";
        [HELPER setURLProfileImageForImageView:gBgImageView URL:myInfoMutableArray[indexPath.row][@"Trip_Route"] placeHolderImage:ICON_TRIP_HISTORY_PLACEHOLDER_INPROGRESS];
        
        
    }
    else if ([myInfoMutableArray[indexPath.row][SR_TRIP_STATUS_ID] integerValue] == TRIP_ARRIVED) {
        
        gStatusLabel.textColor = [HELPER getColorFromHexaDecimal:COLOR_APP_PRIMARY];
        gStatusLabel.text = @"Driver arrived";
        [HELPER setURLProfileImageForImageView:gBgImageView URL:myInfoMutableArray[indexPath.row][@"Trip_Route"] placeHolderImage:ICON_TRIP_HISTORY_PLACEHOLDER_INPROGRESS];
        
    }
    else if ([myInfoMutableArray[indexPath.row][SR_TRIP_STATUS_ID] integerValue] == TRIP_DRIVER_CANCEL) {
        
        gStatusLabel.textColor = [UIColor redColor];
        gStatusLabel.text = @"Trip cancelled by Driver";
        [HELPER setURLProfileImageForImageView:gBgImageView URL:myInfoMutableArray[indexPath.row][@"Trip_Route"] placeHolderImage:ICON_TRIP_HISTORY_PLACEHOLDER_CANCEL];
        
    }
    else if ([myInfoMutableArray[indexPath.row][SR_TRIP_STATUS_ID] integerValue] == TRIP_USER_CANCEL) {
        
        gStatusLabel.textColor = [UIColor redColor];
        gStatusLabel.text = @"Trip cancelled by User";
        [HELPER setURLProfileImageForImageView:gBgImageView URL:myInfoMutableArray[indexPath.row][@"Trip_Route"] placeHolderImage:ICON_TRIP_HISTORY_PLACEHOLDER_CANCEL];
        
    }
    
    else if ([myInfoMutableArray[indexPath.row][SR_TRIP_STATUS_ID] integerValue] == TRIP_COMPLETED) {
        
        gStatusLabel.textColor = [UIColor greenColor];
        gStatusLabel.text = @"Trip Completed";
        [HELPER setURLProfileImageForImageView:gBgImageView URL:myInfoMutableArray[indexPath.row][@"Trip_Route"] placeHolderImage:ICON_TRIP_HISTORY_PLACEHOLDER_INPROGRESS];
    }
    else  {
        
        gStatusLabel.textColor = [HELPER getColorFromHexaDecimal:COLOR_APP_PRIMARY];
        gStatusLabel.text = @"User Requested for Trip";
        [HELPER setURLProfileImageForImageView:gBgImageView URL:myInfoMutableArray[indexPath.row][@"Trip_Route"] placeHolderImage:ICON_TRIP_HISTORY_PLACEHOLDER_INPROGRESS];
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
    
    LUTripHistoryDetailsViewController *aViewController = [STORY_BOARD instantiateViewControllerWithIdentifier:@"LUTripHistoryDetailsViewController"];
    aViewController.gInfoMutableArray = [NSMutableArray new];
    [aViewController.gInfoMutableArray addObject:myInfoMutableArray[indexPath.row]];
    
    [self.navigationController pushViewController:aViewController animated:YES];
}

#pragma mark - UIButton methods -

-(void)leftBarButtonTapEvent {
    
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
        if ([SESSION_2 isRequested] && ![SESSION_2 isAlertShown]) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:VIEW_UPADTE_BASED_ON_REQUEST_STATUS object:nil userInfo:nil];
            
        }
    }];
}

-(void)rightBarButtonTapEvent {
    
}


#pragma mark - Web Service -

- (void)callWebService {
    
    if (![HTTPMANAGER isNetworkRechable]) {
        
        NSMutableDictionary *aDictAlert = [NSMutableDictionary new];
        
        aDictAlert[KEY_ALERT_TITLE]  = SCREEN_TITLE_TRIP_HISTORY;
        aDictAlert[KEY_ALERT_DESC]  = [NSString stringWithFormat:@"%@. Tap to try again",ALERT_NO_INTERNET_DESC];
        aDictAlert[KEY_ALERT_IMAGE]  = @"icon_no_internet";
        
        // List is empty so show 'Tap to retry' view
        [HELPER showRetryAlertIn:self details:aDictAlert retryBlock:^{
            
            if ([HTTPMANAGER isNetworkRechable]) {
                
                [HELPER removeRetryAlertIn:self];
                [HELPER removeLoadingIn:self];
                [self callWebService];
            }
        }];
        return;
    }
    
    // http://192.168.0.48/customer/API/Trip/GetTripHistory?StrCustomerID=1
    
    
    NSMutableDictionary *aParameterMutableDict = [NSMutableDictionary new];
    
    aParameterMutableDict[SR_CUSTOMER_ID] = [SESSION getUserInfo][0][K_CUSTOMER_ID];
    
    [HELPER showLoadingIn:self];
    
    [HTTPMANAGER getTripHistory:aParameterMutableDict completedBlock:^(NSDictionary *response) {
        
        if ([response[kRESPONSE][kRESPONSE_CODE] intValue] == kSUCCESS_CODE) {
            
            NSMutableArray *aMainMutableArray = [NSMutableArray new];
            myInfoMutableArray = [NSMutableArray new];
            
            aMainMutableArray = [response valueForKey:@"Trip_Info"];
            
            if (aMainMutableArray.count) {
                
                myInfoMutableArray = aMainMutableArray;
                [_myTableView reloadDataWithAnimation];
            }
        }
        
        else if ([response[kRESPONSE][kRESPONSE_CODE] intValue] == k_BAD_REQUEST || [response[kRESPONSE][kRESPONSE_CODE] intValue] == K_NO_DATA_CODE) {
            
            [HELPER showAlertIn:self details:ALERT_NO_DATA_DICT colorCode:COLOR_TABLE_VIEW_SEPERATOR];
            //  [HELPER showNotificationSuccessIn:self withMessage:response[kRESPONSE][kRESPONSE_MESSAGE]];
        }
        else {
            
            [HELPER showNotificationSuccessIn:self withMessage:MESSAGE_SOMETHING_WENT_WRONG];
        }
        
        
        [HELPER removeLoadingIn:self];
        
    } failedBlock:^(NSError *error) {
        
        if (error.code == NSURLErrorTimedOut)
            [HELPER showRetryAlertIn:self details:ALERT_UNABLE_TO_REACH_DICT retryBlock:^{
                
                if ([HTTPMANAGER isNetworkRechable]) {
                    
                    [HELPER removeRetryAlertIn:self];
                    [HELPER showLoadingIn:self];
                    [self callWebService];
                }
            }];
        else {
    
            if (myInfoMutableArray.count > 0) {
                
                [HELPER  showNotificationSuccessIn:self withMessage:MESSAGE_SOMETHING_WENT_WRONG];
            }
            else {
                
                [HELPER showRetryAlertIn:self details:ALERT_UNABLE_TO_REACH_DICT retryBlock:^{
                    
                    if ([HTTPMANAGER isNetworkRechable]) {
                        
                        [HELPER removeRetryAlertIn:self];
                        [HELPER showLoadingIn:self];
                        [self callWebService];
                    }
                }];
            }
        }
        
        [HELPER removeLoadingIn:self];
    }];
}

-(void) setUpLeftBarButton {
    
    self.navigationItem.leftBarButtonItem  = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(leftBarButtonTapEvent)];
    self.navigationController.navigationBar.tintColor = WHITE_COLOUR;
}

@end
