//
//  LUTripHistoryDetailsViewController.m
//  Levare User
//
//  Created by Arun Prasad.S, ANGLER - EIT on 30/12/16.
//  Copyright © 2016 AngMac137. All rights reserved.
//

#import "LUTripHistoryDetailsViewController.h"

#define TITLE @"Title"
#define DETAIL @"Detail"

@interface LUTripHistoryDetailsViewController ()

@property (strong, nonatomic) IBOutlet UITableView *myTableView;

@end

@implementation LUTripHistoryDetailsViewController
@synthesize gInfoMutableArray;

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
    
    [NAVIGATION setTitleWithBarButtonItems:TITLE_TRIP_HISTORY forViewController:self showLeftBarButton:IMAGE_BACK showRightBarButton:nil];
    
    _myTableView.tableFooterView = [UIView new];
}

#pragma mark -Model

- (void)setupModel {
    
    
}

- (void)loadModel {
    
}

#pragma mark - UITable view Delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0)
        return 1;
    else
        return ((NSArray *) gInfoMutableArray[0][@"Payment_Details"]).count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return (indexPath.section == 0) ? ([[UIScreen mainScreen] bounds].size.height < 600) ? 470 : 460 : 45;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UILabel * sectionHeader = [[UILabel alloc] initWithFrame:CGRectZero];
    sectionHeader.backgroundColor = [HELPER getColorFromHexaDecimal:COLOR_APP_PRIMARY];
    sectionHeader.textAlignment = NSTextAlignmentCenter;
    sectionHeader.font = [UIFont boldSystemFontOfSize:14];
    sectionHeader.textColor = [UIColor whiteColor];
    
    if (section == 1) {
        
        sectionHeader.text = @"Fare Breakdown ($)";
        return sectionHeader;
    }
    
    return [UIView new];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return (section != 0) ? 40 : 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        NSString *cellIdentifier =@"TripHistoryDetails";
        
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
        // UIImageView *gLocationImageView = (UIImageView *)[aCell viewWithTag:9];
        UILabel *gSourseTimeLabel = (UILabel *)[aCell viewWithTag:10];
        UILabel *gSourseAddressLabel = (UILabel *)[aCell viewWithTag:11];
        UILabel *gDestinationTimeLabel = (UILabel *)[aCell viewWithTag:12];
        UILabel *gDestinationAddressLabel = (UILabel *)[aCell viewWithTag:13];
        UILabel *gServiceTypeLabel = (UILabel *)[aCell viewWithTag:14];
        UILabel *gKilometerLabel = (UILabel *)[aCell viewWithTag:15];
        UILabel *gTripTimeLabel = (UILabel *)[aCell viewWithTag:16];
        
        
        [HELPER addFloatingEffectToView:gProfileImageView];
        [HELPER roundCornerForView:gProfileImageView];
        
        [gRatingView setupSelectedImageName:RATE_WITH_GOLD_STAR unSelectedImage:RATE_WITH_NO_STAR minValue:0 maxValue:5 intervalValue:0.5 stepByStep:1];
        gRatingView.userInteractionEnabled = NO;
        
        [HELPER setURLProfileImageForImageView:gProfileImageView URL:gInfoMutableArray[indexPath.row][@"Driver_Image"] placeHolderImage:IMAGE_NO_PROFILE];
        
        gTimeLabel.text = ([gInfoMutableArray[indexPath.row][@"Trip_Start_Time"] isEqualToString:@""])? @"--" : gInfoMutableArray[indexPath.row][@"Trip_Start_Time"];
        gServiceNameLabel.text = ([gInfoMutableArray[indexPath.row][@"Service_Type"] isEqualToString:@""])? @"--" : gInfoMutableArray[indexPath.row][@"Service_Type"];
        gRateLabel.text = ([gInfoMutableArray[indexPath.row][@"Driver_Rating"] isEqualToString:@""])? @"--" : gInfoMutableArray[indexPath.row][@"Driver_Rating"];
        
        if ([gInfoMutableArray[indexPath.row][@"Driver_Rating"] isEqualToString:@""]) {
            gRatingView.value = 0;
        }
        else
            gRatingView.value = gRateLabel.text.integerValue;
        
        if ([gInfoMutableArray[indexPath.row][@"Trip_Amount"] containsString:@"FREE"]) {
            
            gAmountLabel.text = gInfoMutableArray[indexPath.row][@"Trip_Amount"];
        }
        else {
            
            float aAmountFloat = [gInfoMutableArray[indexPath.row][@"Trip_Amount"] floatValue];//%.0f
            gAmountLabel.text = ([gInfoMutableArray[indexPath.row][@"Trip_Amount"] isEqualToString:@""]) ? @"--" : [NSString stringWithFormat:@"$ %.0f",aAmountFloat];
        }
        gStatusLabel.text = ([gInfoMutableArray[indexPath.row][@"Trip_Status"] isEqualToString:@""])? @"--" : gInfoMutableArray[indexPath.row][@"Trip_Status"];
        
        if ([gInfoMutableArray[indexPath.row][SR_TRIP_STATUS_ID] integerValue] == TRIP_ACCEPTED) {
            
            gStatusLabel.textColor = [HELPER getColorFromHexaDecimal:COLOR_APP_PRIMARY];
            gStatusLabel.text = @"Trip Accepted";
            [HELPER setURLProfileImageForImageView:gBgImageView URL:gInfoMutableArray[indexPath.row][@"Trip_Route"] placeHolderImage:ICON_TRIP_HISTORY_PLACEHOLDER_INPROGRESS];
        }
        else if ([gInfoMutableArray[indexPath.row][SR_TRIP_STATUS_ID] integerValue] == TRIP_STARTED) {
            
            gStatusLabel.textColor = [HELPER getColorFromHexaDecimal:COLOR_APP_PRIMARY];
            gStatusLabel.text = @"Trip Started";
            [HELPER setURLProfileImageForImageView:gBgImageView URL:gInfoMutableArray[indexPath.row][@"Trip_Route"] placeHolderImage:ICON_TRIP_HISTORY_PLACEHOLDER_INPROGRESS];
            
        }
        else if ([gInfoMutableArray[indexPath.row][SR_TRIP_STATUS_ID] integerValue] == TRIP_ARRIVED) {
            
            gStatusLabel.textColor = [HELPER getColorFromHexaDecimal:COLOR_APP_PRIMARY];
            gStatusLabel.text = @"Driver arrived";
            [HELPER setURLProfileImageForImageView:gBgImageView URL:gInfoMutableArray[indexPath.row][@"Trip_Route"] placeHolderImage:ICON_TRIP_HISTORY_PLACEHOLDER_INPROGRESS];
            
        }
        else if ([gInfoMutableArray[indexPath.row][SR_TRIP_STATUS_ID] integerValue] == TRIP_DRIVER_CANCEL) {
            
            gStatusLabel.textColor = [UIColor redColor];
            gStatusLabel.text = @"Trip cancelled by Driver";
            [HELPER setURLProfileImageForImageView:gBgImageView URL:gInfoMutableArray[indexPath.row][@"Trip_Route"] placeHolderImage:ICON_TRIP_HISTORY_PLACEHOLDER_CANCEL];
        }
        else if ([gInfoMutableArray[indexPath.row][SR_TRIP_STATUS_ID] integerValue] == TRIP_USER_CANCEL) {
            
            gStatusLabel.textColor = [UIColor redColor];
            gStatusLabel.text = @"Trip cancelled by User";
            [HELPER setURLProfileImageForImageView:gBgImageView URL:gInfoMutableArray[indexPath.row][@"Trip_Route"] placeHolderImage:ICON_TRIP_HISTORY_PLACEHOLDER_CANCEL];
        }
        
        else if ([gInfoMutableArray[indexPath.row][SR_TRIP_STATUS_ID] integerValue] == TRIP_COMPLETED) {
            
            gStatusLabel.textColor = [UIColor greenColor];
            gStatusLabel.text = @"Trip Completed";
            [HELPER setURLProfileImageForImageView:gBgImageView URL:gInfoMutableArray[indexPath.row][@"Trip_Route"] placeHolderImage:ICON_TRIP_HISTORY_PLACEHOLDER_INPROGRESS];
        }
        else  {
            
            gStatusLabel.textColor = [HELPER getColorFromHexaDecimal:COLOR_APP_PRIMARY];
            gStatusLabel.text = @"User Requested for Trip";
            [HELPER setURLProfileImageForImageView:gBgImageView URL:gInfoMutableArray[indexPath.row][@"Trip_Route"] placeHolderImage:ICON_TRIP_HISTORY_PLACEHOLDER_INPROGRESS];
        }
        
        
        gSourseTimeLabel.text = ([gInfoMutableArray[indexPath.row][@"Trip_Start_Time"] isEqualToString:@""])? @"--" : [gInfoMutableArray[indexPath.row][@"Trip_Start_Time"] componentsSeparatedByString:@" "][1];
        gSourseAddressLabel.text = ([gInfoMutableArray[indexPath.row][@"Trip_From"] isEqualToString:@""])? @"--" : gInfoMutableArray[indexPath.row][@"Trip_From"];
        
        gDestinationTimeLabel.text = ([gInfoMutableArray[indexPath.row][@"Trip_End_Time"] isEqualToString:@""])? @"--" : [gInfoMutableArray[indexPath.row][@"Trip_End_Time"] componentsSeparatedByString:@" "][1];
        
        gDestinationAddressLabel.text = ([gInfoMutableArray[indexPath.row][@"Trip_To"] isEqualToString:@""])? @"--" : gInfoMutableArray[indexPath.row][@"Trip_To"];
        
        gServiceTypeLabel.text = ([gInfoMutableArray[indexPath.row][@"Service_Type"] isEqualToString:@""])? @"--" : gInfoMutableArray[indexPath.row][@"Service_Type"];
        gKilometerLabel.text = ([gInfoMutableArray[indexPath.row][@"Trip_Distance"] isEqualToString:@""])? @"--" : gInfoMutableArray[indexPath.row][@"Trip_Distance"];
        gTripTimeLabel.text = ([gInfoMutableArray[indexPath.row][@"Trip_Duration"] isEqualToString:@""])? @"--" : gInfoMutableArray[indexPath.row][@"Trip_Duration"];
        
        return aCell;
    }
    else {
        
        NSString *cellIdentifier =@"cell";
        
        UITableViewCell *aCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (aCell == nil) {
            
            aCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        }
        
        aCell.textLabel.font = [UIFont systemFontOfSize:14];
        aCell.detailTextLabel.font = [UIFont systemFontOfSize:14];
        
        aCell.textLabel.text = gInfoMutableArray[0][@"Payment_Details"][indexPath.row][TITLE];
        aCell.detailTextLabel.text = ([gInfoMutableArray[0][@"Payment_Details"][indexPath.row][DETAIL] isEqualToString:@""])? @"--" :gInfoMutableArray[0][@"Payment_Details"][indexPath.row][DETAIL];
        
        return aCell;
    }
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
}

#pragma mark - UIButton methods -

-(void)leftBarButtonTapEvent {
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightBarButtonTapEvent {
    
}

@end
