//
//  LUPaymentOptionViewController.m
//  Levare User
//
//  Created by AngMac137 on 11/19/16.
//  Copyright © 2016 AngMac137. All rights reserved.
//

#import "LUPaymentOptionViewController.h"

@interface LUPaymentOptionViewController ()<SWTableViewCellDelegate>
{
    NSString *myCreditCardString, *isActiveString, *myCardIdString;
    NSMutableArray *myCardInfo;
}
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) IBOutlet UILabel *myAgreeLabel;
@property (strong, nonatomic) IBOutlet UIButton *myPromButton;
@property (strong, nonatomic) IBOutlet UIButton *myLevareConditionButon;
@property (strong, nonatomic) IBOutlet UIButton *myPayButton;
@property (strong, nonatomic) IBOutlet UIImageView *myPlusImageView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *myTableheightConstraint;

@end

@implementation LUPaymentOptionViewController

#pragma mark - View & Model -

#pragma mark -View Life Cycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // setup UI & Content
    [self setupUI];    
}

-(void)viewWillAppear:(BOOL)animated {
    
    myCardInfo = [NSMutableArray new];
    [self setupModel];
    
    // Load Contents
    [self loadModel];

}

#pragma mark -View Init

- (void)setupUI {
    
    if (!_isFromOTPScreen) {
        [NAVIGATION setTitleWithBarButtonItems:@"PAYMENT OPTIONS" forViewController:self showLeftBarButton:nil showRightBarButton:nil];
        
        [self setUpLeftBarButton];
        
        [_myPromButton removeFromSuperview];
        [_myLevareConditionButon removeFromSuperview];
        [_myAgreeLabel removeFromSuperview];
        [_myPlusImageView removeFromSuperview];
    }
    else {
        [NAVIGATION setTitleWithBarButtonItems:@"PAYMENT OPTIONS" forViewController:self showLeftBarButton:nil showRightBarButton:@"Skip"];
        
        
    }
    
    _myTableView.tableFooterView = [UIView new];
    
    isActiveString = myCardIdString = @"0";
    
    _myPromButton.hidden = !_isFromOTPScreen;
    _myLevareConditionButon.hidden = !_isFromOTPScreen;
    _myAgreeLabel.hidden = !_isFromOTPScreen;
    _myPlusImageView.hidden = !_isFromOTPScreen;
    myCardInfo = [NSMutableArray new];
    
}

#pragma mark -Model

- (void)setupModel {
    
    myCardInfo = [SESSION getCardInfo];
    [_myTableView reloadDataWithAnimation];
    
}

- (void)loadModel {
    
    if (myCardInfo.count == 1) {
        
        if ([myCardInfo[0][@"Is_Active"] isEqualToString:@"1"]) {
            
            isActiveString = @"0";
        }
        else {
            
            isActiveString = @"1";
        }
        NSMutableDictionary *aMDict = [NSMutableDictionary new];
        
        aMDict = [myCardInfo[0] mutableCopy];
        aMDict[@"Is_Active"] = isActiveString;
        
        myCardIdString = myCardInfo[0][@"Card_Id"];
        
        
        if ([isActiveString isEqualToString:@"1"])
            [self callWebService];
        
    }
}


#pragma mark - UITable view Delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return (myCardInfo.count) ? myCardInfo.count + 1: 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellIdentifier =@"MenuCell";
    
    SWTableViewCell *aCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (aCell == nil) {
        
        aCell = [[SWTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    UIImageView *gImageView = (UIImageView *)[aCell viewWithTag:1];
    UIButton *gButton = (UIButton *)[aCell viewWithTag:3];
    UILabel *gLabel = (UILabel *)[aCell viewWithTag:2];
    
    [HELPER getColorIgnoredImage:@"icon_card" imageView:gImageView color:[UIColor lightGrayColor]];
    
    if (!myCardInfo.count ) {
        
        aCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        gLabel.text = @"Credit/Debit Card";
        gButton.hidden = YES;
        aCell.rightUtilityButtons = nil;
        aCell.delegate = nil;
    }
    else {
        
        if (indexPath.row ==  myCardInfo.count) {
            
            
            aCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            gLabel.text = @"Credit/Debit Card";
            gButton.hidden = YES;
            aCell.rightUtilityButtons = nil;
            aCell.delegate = nil;
        }
        else {
            
            aCell.accessoryType = UITableViewCellAccessoryNone;
            gButton.hidden = NO;
            [gButton setImage:[myCardInfo[indexPath.row][@"Is_Active"]boolValue] ? [UIImage imageNamed:ICON_CHECKED] : [UIImage imageNamed:ICON_UNCHECKED] forState:UIControlStateNormal];
            NSString *aCardNoString = myCardInfo[indexPath.row][@"Credit_Card_Number"];
            gLabel.text = [HELPER resetCardNumberAsVisa:aCardNoString];
            
            aCell.rightUtilityButtons = [self swipeRightButtons];
            aCell.delegate = self;
        }
        
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
    
    if (!myCardInfo.count || indexPath.row ==  myCardInfo.count) {
        
        LUAddCardViewController *aViewController = [STORY_BOARD instantiateViewControllerWithIdentifier:@"LUAddCardViewController"];
        aViewController.isFromOTPScreen = _isFromOTPScreen;
        [self.navigationController pushViewController:aViewController animated:YES];
    }
    
    else {
        
        if ([myCardInfo[indexPath.row][@"Is_Active"] isEqualToString:@"1"]) {
            
            isActiveString = @"0";
        }
        else {
            
            isActiveString = @"1";
        }
        NSMutableDictionary *aMDict = [NSMutableDictionary new];
        
        aMDict = [myCardInfo[indexPath.row] mutableCopy];
        aMDict[@"Is_Active"] = isActiveString;
        
        myCardIdString = myCardInfo[indexPath.row][@"Card_Id"];
        
        
        if ([isActiveString isEqualToString:@"1"])
            [self callWebService];
    }
}

#pragma mark - SWTableViewDelegate -

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    
    NSIndexPath *cellIndexPath = [self.myTableView indexPathForCell:cell];
    
    switch (index) {
            
        case 0: {
            
            LUAddCardViewController *aViewController = [STORY_BOARD instantiateViewControllerWithIdentifier:@"LUAddCardViewController"];
            aViewController.aDictionary = myCardInfo[cellIndexPath.row];
            
            [self.navigationController pushViewController:aViewController animated:YES];
            
            break;
        }
            
        case 1: {
            
            [HELPER showAlertViewWithCancel:self title:@"Are you sure to delete?" okButtonBlock:^(UIAlertAction *action) {
                
                myCardIdString = myCardInfo[cellIndexPath.row][@"Card_Id"];
                [self callDeleteWebService];
                
            } cancelButtonBlock:^(UIAlertAction *action) {
                
            }];
            break;
        }
        default:
            break;
    }
}

- (NSArray *)swipeRightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0]
                                                title:@"Edit"];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
                                                title:@"Delete"];
    return rightUtilityButtons;
}


#pragma mark - UIButton methods -

-(void)leftBarButtonTapEvent {
    
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
        if ([SESSION_2 isRequested] && ![SESSION_2 isAlertShown]) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:VIEW_UPADTE_BASED_ON_REQUEST_STATUS object:nil userInfo:nil];
            
        }
        
        if (_callBackBlock) {
            
            NSMutableArray *aMutableArray = [NSMutableArray new];
            
            if (myCardInfo.count) {
                
                for (int i = 0; i < myCardInfo.count; i++) {
                    
                    if ([myCardInfo[i][@"Is_Active"] isEqualToString:@"1"]) {
                        
                        [aMutableArray addObject:myCardInfo[i]];
                        _callBackBlock(YES, aMutableArray);
                    }
                }
            }
            else
                _callBackBlock(NO, aMutableArray);
        }
    }];
}

- (IBAction)rightBarButtonTapEvent {
    
    [HELPER navigateToMenuDetailScreen];
}

- (IBAction)levareTermsCondition:(id)sender {
    
    [HELPER showAlertView:self title:APP_NAME message:@"Dashboard of the admin panel will have a MAP and a Refresh button, When the admin person clicks on Refresh button, the page will be refreshed by plotting the current location of all the drivers who are online with our app, Google Map would be free for 25,000 request and later we would need to purchase the MAP license for Web. As discussed this should be taken care by Client. The driver’s status will be shown on the map i.e. available, unavailable, on trip. The map should show all service types or be able to be filtered. Vehicles should be shown by respective service type icons." okButtonBlock:^(UIAlertAction *action) {
        
    }];
    
}

- (IBAction)payWithPaypal:(id)sender {
    
}

- (IBAction)enterPromCodeTapped:(id)sender {
    
    LUFavouritePopViewController * aViewController = [STORY_BOARD instantiateViewControllerWithIdentifier:@"LUFavouritePopViewController"];
    [aViewController setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    aViewController.isForPromoCode = YES;
    
    // To present view controller on the top of all view controller with clear background
    [self presentViewController:aViewController animated:YES completion:^{
        
    }];
}

-(void) setUpLeftBarButton {
    
    self.navigationItem.leftBarButtonItem  = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(leftBarButtonTapEvent)];
    self.navigationController.navigationBar.tintColor = WHITE_COLOUR;
}

#pragma mark - Helper -

-(void)callWebService {
    
    if (![HTTPMANAGER isNetworkRechable]) {
        
        NSMutableDictionary *aDictAlert = [NSMutableDictionary new];
        
        aDictAlert[KEY_ALERT_TITLE]  = SCREEN_TITLE_MANAGE_CARD;
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
    
    NSMutableDictionary *aParameterMutableDict = [NSMutableDictionary new];
    
    aParameterMutableDict[SR_CUSTOMER_ID] = [SESSION getUserInfo][0][K_CUSTOMER_ID];
    aParameterMutableDict[@"StrCardID"] = myCardIdString;
    aParameterMutableDict[@"StrStatus"] = isActiveString;
    
    [HELPER showLoadingIn:self];
    
    [HTTPMANAGER ChangeCardStatus:aParameterMutableDict completedBlock:^(NSDictionary *response) {
        
        if ([response[kRESPONSE][kRESPONSE_CODE] intValue] == kSUCCESS_CODE) {
            
            NSMutableArray *aMutableArray = [NSMutableArray new];
            aMutableArray = [response valueForKey:@"Card_Info"];
            
            [SESSION setCardInfo:aMutableArray];
            [self setupModel];
            
            if (_isForChangeCard) {
                
            }
            else {
                
                //[HELPER navigateToMenuDetailScreen];
            }
        }
        
        else if ( [response[kRESPONSE][kRESPONSE_CODE] intValue] == K_NO_DATA_CODE) {
            
            NSMutableArray *aMutableArray = [NSMutableArray new];
            [SESSION setCardInfo:aMutableArray];
            
            [self setupModel];
        }
        else if ([response[kRESPONSE][kRESPONSE_CODE] intValue] == k_BAD_REQUEST) {
            
            [self setupModel];
            [HELPER showNotificationSuccessIn:self withMessage:response[kRESPONSE][kRESPONSE_MESSAGE]];
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
        else
            [HELPER showNotificationSuccessIn:self withMessage:MESSAGE_SOMETHING_WENT_WRONG];
        
        [HELPER removeLoadingIn:self];
    }];
}

-(void)callDeleteWebService {
    
    if (![HTTPMANAGER isNetworkRechable]) {
        
        NSMutableDictionary *aDictAlert = [NSMutableDictionary new];
        
        aDictAlert[KEY_ALERT_TITLE]  = SCREEN_TITLE_MANAGE_CARD;
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
    
    NSMutableDictionary *aParameterMutableDict = [NSMutableDictionary new];
    
    aParameterMutableDict[SR_CUSTOMER_ID] = [SESSION getUserInfo][0][K_CUSTOMER_ID];
    aParameterMutableDict[@"StrCardID"] = myCardIdString;
    
    [HELPER showLoadingIn:self];
    
    [HTTPMANAGER deleteCardDetails:aParameterMutableDict completedBlock:^(NSDictionary *response) {
        
        if ([response[kRESPONSE][kRESPONSE_CODE] intValue] == kSUCCESS_CODE) {
            
            NSMutableArray *aMutableArray = [NSMutableArray new];
            aMutableArray = [response valueForKey:@"Card_Info"];
            
            [SESSION setCardInfo:aMutableArray];
            [self setupModel];
        }
        
        else if ( [response[kRESPONSE][kRESPONSE_CODE] intValue] == K_NO_DATA_CODE) {
            
            NSMutableArray *aMutableArray = [NSMutableArray new];
            [SESSION setCardInfo:aMutableArray];
            
            [self setupModel];
        }
        else if ([response[kRESPONSE][kRESPONSE_CODE] intValue] == k_BAD_REQUEST) {
            
            [self setupModel];
            [HELPER showNotificationSuccessIn:self withMessage:response[kRESPONSE][kRESPONSE_MESSAGE]];
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
                    [self callDeleteWebService];
                }
            }];
        else
            [HELPER showNotificationSuccessIn:self withMessage:MESSAGE_SOMETHING_WENT_WRONG];
        
        [HELPER removeLoadingIn:self];
    }];
}

@end
