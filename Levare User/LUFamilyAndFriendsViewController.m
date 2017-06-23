//
//  LUFamilyAndFriendsViewController.m
//  Levare User
//
//  Created by angler133 on 08/12/16.
//  Copyright © 2016 AngMac137. All rights reserved.
//

#import "LUFamilyAndFriendsViewController.h"

// Controller
#import "LUAddFriendsViewController.h"

// Cell
#import "LUFriendListTableViewCell.h"

@interface LUFamilyAndFriendsViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UIView *myAlertView;
@property (strong, nonatomic) IBOutlet UILabel *myAlertLabel;
@property (strong, nonatomic) IBOutlet UIImageView *myAlertImageView;

@property (nonatomic, strong) NSMutableArray *myMAryInfo, *myContactInfo;

@end

@implementation LUFamilyAndFriendsViewController

@synthesize myMAryInfo, myContactInfo;
@synthesize gMAryExistingContactInfo;

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
    
    if (_isForFamilyFriendsScreen) {
        
        [HELPER fadeAnimationFor:_myBtnAddContacts alpha:1.0 duration:0.2];
        
        [self setUpNavigationBar];
    }
    else {
        
        [HELPER fadeAnimationFor:_myBtnAddContacts alpha:0.0 duration:0.2];
        
        [NAVIGATION setTitleWithBarButtonItems:TITLE_SEND_NOTIFICATION forViewController:self showLeftBarButton:nil showRightBarButton:nil];
        [self setUpLeftBarButton];
        
        [_myBtnAddContacts setTitle:@"Send" forState:UIControlStateNormal];
    }
    
    [HELPER roundCornerForView:self.myBtnAddContacts withRadius:3.0];
    
    [self.myTblView registerNib:[UINib nibWithNibName:NSStringFromClass([LUFriendListTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LUFriendListTableViewCell class])];
    
    _myTblView.dataSource = self;
    _myTblView.delegate = self;
    [_myTblView reloadDataWithAnimation];
}

#pragma mark -Model

- (void)setupModel {
    
    if (!_isForFamilyFriendsScreen)
        self.myTblView.allowsMultipleSelectionDuringEditing = NO;
    myMAryInfo = [NSMutableArray new];
    myContactInfo = [NSMutableArray new];
}

- (void)loadModel {
    
    [self getFriendListFromWebservice];
}


#pragma mark - UITable view Delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return myMAryInfo.count;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LUFriendListTableViewCell *aCell = (LUFriendListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LUFriendListTableViewCell class])];
    
    [HELPER roundCornerForView:aCell.gImgView withRadius:25];
    
    aCell.gImgView.image = [UIImage imageNamed:IMAGE_NO_PROFILE];
    
    aCell.gLblName.text = myMAryInfo[indexPath.row][@"Name"];
    aCell.gLblDescription.text = myMAryInfo[indexPath.row][@"Mobile_Number"];
    
    if ([myMAryInfo[indexPath.row][k_IS_ACTIVE] isEqualToString:@"1"])
        aCell.accessoryType = UITableViewCellAccessoryCheckmark;
    else
        aCell.accessoryType = UITableViewCellAccessoryNone;
    
    
    return aCell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        
        [HELPER showAlertControllerIn:self title:SCREEN_TITLE_FAMILY_FRIENDS message:@"Do you want delete this contact?" defaultFirstButtonTitle:@"Yes" defaultFirstActionBlock:^(UIAlertAction *action) {
            
            [self callDeleteWebService:myMAryInfo[indexPath.row][@"Family_Id"] indexPath:indexPath];
            
        } cancelButtonTitle:@"No" cancelActionBlock:^(UIAlertAction *action) {
            
        }];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (!_isForFamilyFriendsScreen) {
        
        if ([myMAryInfo[indexPath.row][k_IS_ACTIVE] isEqualToString:@"1"]) {
            
            [myContactInfo removeObject:myMAryInfo[indexPath.row]];
            myMAryInfo[indexPath.row][k_IS_ACTIVE] = @"0";
        }
        else {
            
            [myContactInfo addObject:myMAryInfo[indexPath.row]];
            myMAryInfo[indexPath.row][k_IS_ACTIVE] = @"1";
        }
        
        [_myTblView reloadDataWithAnimation];
    }
}

#pragma mark - Call webservice -

- (void)getFriendListFromWebservice {
    
    if (![HTTPMANAGER isNetworkRechable]) {
        
        [self handleWebserviceResponseUsingMessage:ALERT_NO_INTERNET];
        return;
    }
    
    [HELPER showLoadingIn:self];
    
    [HTTPMANAGER getFriendListWithCompletedBlock:^(NSDictionary *response) {
        
        [HELPER removeLoadingIn:self];
        
        if ([response[kRESPONSE][kRESPONSE_CODE] intValue] == kSUCCESS_CODE) {
            
            NSMutableArray * aMutableArray = [NSMutableArray new];
            aMutableArray = response[@"Family_Info"];
            
            for (int i = 0 ; i < aMutableArray.count; i++) {
                
                NSMutableDictionary *aMutableDict = [NSMutableDictionary new];
                aMutableDict= [aMutableArray[i] mutableCopy];
                aMutableDict[k_IS_ACTIVE] = @"0";
                
                [myMAryInfo addObject:aMutableDict];
                
                if (!_isForFamilyFriendsScreen)
                    [HELPER fadeAnimationFor:_myBtnAddContacts alpha:1.0 duration:0.2];
            }
        }
        
        else if ([response[kRESPONSE][kRESPONSE_CODE] intValue] == k_BAD_REQUEST || [response[kRESPONSE][kRESPONSE_CODE] intValue] == K_NO_DATA_CODE) {
            
            myMAryInfo = [NSMutableArray new];
            
            if (!_isForFamilyFriendsScreen)
                [HELPER fadeAnimationFor:_myBtnAddContacts alpha:0.0 duration:0.2];
            
        }
        
        else {
            
            [HELPER showNotificationSuccessIn:self withMessage:MESSAGE_SOMETHING_WENT_WRONG];
        }
        
        [self tableviewReloadDateWithContent];
        [HELPER removeLoadingIn:self];
        
    } failedBlock:^(NSError *error) {
        
        if (error.code == NSURLErrorTimedOut)
            [HELPER showRetryAlertIn:self details:ALERT_UNABLE_TO_REACH_DICT retryBlock:^{
                
                if ([HTTPMANAGER isNetworkRechable]) {
                    
                    [HELPER removeRetryAlertIn:self];
                    [HELPER showLoadingIn:self];
                    [self getFriendListFromWebservice];
                }
            }];
        else
            [self handleWebserviceResponseUsingMessage:ALERT_NO_INTERNET_DESC];
        
        [HELPER removeLoadingIn:self];
    }];
}


#pragma mark -
#pragma mark Tap to retry
#pragma mark -

#pragma mark - Webservice Helper -

- (void)handleWebserviceResponseUsingMessage: (NSString *)message {
    
    if ([message isEqualToString:ALERT_NO_INTERNET]) {
        
        if (self.myMAryInfo.count > 0) {
            
            [HELPER showNotificationSuccessIn:self withMessage:message];
        }
        
        else {
            
            [HELPER showRetryAlertIn:self details:ALERT_NO_INTERNET_DICT retryBlock:^{
                
                if ([HTTPMANAGER isNetworkRechable]) {
                    
                    [HELPER removeRetryAlertIn:self];
                    [HELPER showLoadingIn:self];
                    [self getFriendListFromWebservice];
                }
            }];
        }
    }
    
    else if ([message isEqualToString:ALERT_NO_INTERNET_DESC]) {
        
        if (self.myMAryInfo.count > 0) {
            
            [HELPER  showNotificationSuccessIn:self withMessage:message];
        }
        else {
            
            [HELPER showRetryAlertIn:self details:ALERT_UNABLE_TO_REACH_DICT retryBlock:^{
                
                if ([HTTPMANAGER isNetworkRechable]) {
                    
                    [HELPER removeRetryAlertIn:self];
                    [HELPER showLoadingIn:self];
                    [self getFriendListFromWebservice];
                }
            }];
        }
    }
    
    else if ([message isEqualToString:MESSAGE_NO_DATA]) {
        
        if (!myMAryInfo.count)
            [HELPER showNotificationSuccessIn:self withMessage:MESSAGE_NO_DATA];
        
        else
            [HELPER removeAlertIn:self];
    }
    
    [HELPER removeLoadingIn:self];
    [self.myTblView reloadDataWithAnimation];
}


- (void)callDeleteWebService:(NSString*)aStrDeleteContactId indexPath:(NSIndexPath*)aIndexPath {
    
    if (![HTTPMANAGER isNetworkRechable]) {
        
        [HELPER  showNotificationSuccessIn:self withMessage:ALERT_NO_INTERNET];
        return;
    }
    
    NSMutableDictionary *aMutableDict = [NSMutableDictionary new];
    NSMutableDictionary *aMutableDictJsonTitle = [NSMutableDictionary new];
    NSMutableDictionary *aParameterMutableDict = [NSMutableDictionary new];
    
    aMutableDict[@"Family_Id"] = aStrDeleteContactId;
    aMutableDict[@"Customer_Id"] =  [SESSION getUserInfo][0][K_CUSTOMER_ID];
    aMutableDictJsonTitle[@"Family_Info"] = aMutableDict;
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:aMutableDictJsonTitle options:NSJSONWritingPrettyPrinted error:&error];
    NSString *string = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    aParameterMutableDict[@"StrJson"] = string;
    
    [self.view endEditing:YES];
    
    [HELPER showLoadingIn:self];
    
    [HTTPMANAGER deleteFriendsContact:aParameterMutableDict completedBlock:^(NSDictionary *response) {
        
        if ([response[kRESPONSE][kRESPONSE_CODE] intValue] == kSUCCESS_CODE) {
            
            myMAryInfo = response[@"Family_Info"];
        }
        else if ([response[kRESPONSE][kRESPONSE_CODE] intValue] == k_BAD_REQUEST || [response[kRESPONSE][kRESPONSE_CODE] intValue] == K_NO_DATA_CODE) {
            
            myMAryInfo = [NSMutableArray new];
            if (!_isForFamilyFriendsScreen)
                [HELPER fadeAnimationFor:_myBtnAddContacts alpha:0.0 duration:0.2];
        }
        else {
            
            [HELPER showNotificationSuccessIn:self withMessage:response[kRESPONSE][kRESPONSE_MESSAGE]];
        }
        
        [self tableviewReloadDateWithContent];
        [HELPER removeLoadingIn:self];
        
    } failedBlock:^(NSError *error) {
        
        [HELPER showNotificationSuccessIn:self withMessage:MESSAGE_SOMETHING_WENT_WRONG];
        [HELPER removeLoadingIn:self];
    }];
}

#pragma mark - Helper -

- (void)setUpNavigationBar {
    
    self.navigationController.navigationBar.barTintColor = COLOR_NAVIGATION_COLOR;
    self.navigationController.navigationBar.tintColor = WHITE_COLOUR;
    [self.navigationController.navigationBar setTranslucent:NO];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    self.navigationController.navigationBar.layer.shadowColor = (__bridge CGColorRef _Nullable)(WHITE_COLOUR);
    
    // TO SET TILE COLOR & FONT
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:FONT_HELVETICA_NEUE size:14.0];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = WHITE_COLOUR;
    self.navigationItem.titleView = label;
    label.text = TITLE_FAMILY_FRIENDS;
    [label sizeToFit];
    
    
    self.navigationItem.leftBarButtonItem  = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(leftBarButtonTapEvent)];
}

-(void)tableviewReloadDateWithContent {
    
    if (myMAryInfo.count) {
        
        [self removeAlertView];
        [_myTblView reloadDataWithAnimation];
    }
    else {
        
        [self showAlertView];
    }
}

-(void)removeAlertView {
    
    [HELPER fadeAnimationFor:self.myAlertView alpha:0.0 duration:0.2];
    [HELPER fadeAnimationFor:self.myTblView alpha:1.0 duration:0.2];
}

-(void)showAlertView {
    
    [HELPER fadeAnimationFor:self.myAlertView alpha:1.0 duration:0.2];
    [HELPER fadeAnimationFor:self.myTblView alpha:0.0 duration:0.2];
}



#pragma mark - UIButton methods -

- (IBAction)addContactsBtnTapped:(id)sender {
    
    if (_isForFamilyFriendsScreen) {
        
        LUAddFriendsViewController * aViewController = [LUAddFriendsViewController new];
        aViewController.gMAryInfo = myMAryInfo;
        
        aViewController.callBackBlock = ^(BOOL isCallBack, NSMutableArray *aMArray) {
            
            if (isCallBack) {
                
                if (aMArray.count) {
                    
                    myMAryInfo = aMArray;
                    [_myTblView reloadDataWithAnimation];
                    [self removeAlertView];
                }
                else {
                    
                    myMAryInfo = [NSMutableArray new];
                    [self showAlertView];
                }
            }
        };
        UINavigationController *aNavigationController = [[UINavigationController alloc]initWithRootViewController:aViewController];
        [self.navigationController presentViewController:aNavigationController animated:YES completion:nil];
    }
    
    else {
        
        if (myContactInfo.count == 0) {
            
            [HELPER showNotificationSuccessIn:self withMessage:@"Please add  one of your contact"];
            return;
        }
        
        else {
            
            [self callWebService];
        }
        
    }
}

- (void)leftBarButtonTapEvent {
    
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
        if ([SESSION_2 isRequested] && ![SESSION_2 isAlertShown]) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:VIEW_UPADTE_BASED_ON_REQUEST_STATUS object:nil userInfo:nil];
            
        }
    }];
}

- (void)rightBarButtonTapEvent {
    
    [self callWebService];
    
}

-(void) setUpLeftBarButton {
    
    self.navigationItem.leftBarButtonItem  = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(leftBarButtonTapEvent)];
    self.navigationController.navigationBar.tintColor = WHITE_COLOUR;
}


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
    
    //  http://116.212.240.36/SuburbanAPI/API/FamilyandFriends/SendNotification?StrCustomerId=61&StrFamilyIDs=27,31,28&StrFromLatitude=11.020907&StrFromlongitude=76.952951&StrTripId=4
    
    
    NSMutableDictionary *aParameterMutableDict = [NSMutableDictionary new];
    NSString *string = @"";
    
    for (NSDictionary *aDictInfo in myContactInfo) {
        
        if ([string isEqualToString:@""])
            string = aDictInfo[@"Family_Id"];
        else
            string = [string stringByAppendingString:[NSString stringWithFormat:@",%@",aDictInfo[@"Family_Id"]]];
    }
    
    aParameterMutableDict[SR_CUSTOMER_ID] = _gInfoArray[0];
    aParameterMutableDict[@"StrFamilyIDs"] = string;
    aParameterMutableDict[SR_FROM_LATITUDE] = _gInfoArray[1];
    aParameterMutableDict[SR_FROM_LONGITUDE] = _gInfoArray[2];
    aParameterMutableDict[SR_TRIP_ID] = _gInfoArray[3];
    
    [HELPER showLoadingIn:self];
    
    [HTTPMANAGER sendNotification:aParameterMutableDict completedBlock:^(NSDictionary *response) {
        
        if ([response[kRESPONSE][kRESPONSE_CODE] intValue] == kSUCCESS_CODE) {
            
            [HELPER showAlertView:self title:APP_NAME message:response[kRESPONSE][kRESPONSE_MESSAGE] okButtonBlock:^(UIAlertAction *action) {
               
                [self leftBarButtonTapEvent];
            }];
        }
        
        else {
            
            [HELPER showNotificationSuccessIn:self withMessage:response[kRESPONSE][kRESPONSE_MESSAGE]];
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


@end
