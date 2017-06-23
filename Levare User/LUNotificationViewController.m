//
//  LUNotificationViewController.m
//  Levare User
//
//  Created by Arun Prasad.S, ANGLER - EIT on 26/12/16.
//  Copyright © 2016 AngMac137. All rights reserved.
//

#import "LUNotificationViewController.h"

@interface LUNotificationViewController ()
{
    NSArray *myInfoArray;
}

@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@end

@implementation LUNotificationViewController

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
    
    [NAVIGATION setTitleWithBarButtonItems:TITLE_SEND_NOTIFICATION forViewController:self showLeftBarButton:IMAGE_BACK showRightBarButton:nil];
    
    myInfoArray = [NSArray new];
    
    myInfoArray = @[@{KEY_TEXT: @"Email", KEY_IMAGE: @"icon_email"},
                    @{KEY_TEXT: @"SMS", KEY_IMAGE: @"icon_mobile"}
                    ];
    
    _myTableView.tableFooterView = [UIView new];
}

#pragma mark -Model

- (void)setupModel {
    
    
}

- (void)loadModel {
    
}


#pragma mark - UITable view Delegates


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return myInfoArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellIdentifier =@"NotificationCell";
    
    UITableViewCell *aCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (aCell == nil) {
        
        aCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    UIImageView *gImageView = (UIImageView *)[aCell viewWithTag:1];
    UILabel *gTitleLabel = (UILabel *)[aCell viewWithTag:2];
    
    gImageView.image = [UIImage imageNamed:myInfoArray[indexPath.row][KEY_IMAGE]];
    gTitleLabel.text = myInfoArray[indexPath.row][KEY_TEXT];
    
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
    
    UITableViewCell* aCell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (aCell.accessoryType == UITableViewCellAccessoryCheckmark) {
        aCell.accessoryType = UITableViewCellAccessoryNone;
    }
    else {
        aCell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    [_myTableView reloadDataWithAnimation];
}



#pragma mark - UIButton Method -

- (IBAction)sendNotificationButtonTapped:(id)sender {
    
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(void)leftBarButtonTapEvent {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Web Service -

- (void)callWebService {
    
    if (![HTTPMANAGER isNetworkRechable]) {
        
        NSMutableDictionary *aDictAlert = [NSMutableDictionary new];
        
        aDictAlert[KEY_ALERT_TITLE]  = SCREEN_TITLE_SEND_NOTIFICATION;
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
    
    aParameterMutableDict[K_CUSTOMER_ID] = [SESSION getUserInfo][0][K_CUSTOMER_ID];
    
    [HELPER showLoadingIn:self];
    
    [HTTPMANAGER getFavoriteType:aParameterMutableDict completedBlock:^(NSDictionary *response) {
        
        if ([response[kRESPONSE][kRESPONSE_CODE] intValue] == kSUCCESS_CODE) {
            
        }
        
        else {
            
            [HELPER showNotificationSuccessIn:self withMessage:response[kRESPONSE][kRESPONSE_MESSAGE]];
        }
        
        [HELPER removeLoadingIn:self];
        
    } failedBlock:^(NSError *error) {
        
        {
            
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
        }
        [HELPER removeLoadingIn:self];
    }];
}


@end
