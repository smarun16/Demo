//
//  LUFavouritePopViewController.m
//  Levare User
//
//  Created by AngMac137 on 12/8/16.
//  Copyright © 2016 AngMac137. All rights reserved.
//

#import "LUFavouritePopViewController.h"

@interface LUFavouritePopViewController ()<UITextFieldDelegate>
{
    NSString *myPrimaryLocationString;
}
@property (strong, nonatomic) IBOutlet UIView *myBgView;
@property (strong, nonatomic) IBOutlet UIButton *myHomeButton;
@property (strong, nonatomic) IBOutlet UIButton *myOfficeButton;
@property (strong, nonatomic) IBOutlet UIButton *myOtherButton;
@property (strong, nonatomic) IBOutlet UIImageView *myLocationImageView;
@property (strong, nonatomic) IBOutlet UILabel *myLocationLabel;
@property (strong, nonatomic) IBOutlet UITextField *myLocationTextfield;
@property (strong, nonatomic) IBOutlet UIView *myPromoView;
@property (strong, nonatomic) IBOutlet UIView *myPromoBgView;
@property (strong, nonatomic) IBOutlet UITextField *myPromoTextfield;
@property (strong, nonatomic) IBOutlet UIImageView *myPromoImageView;
@property (strong, nonatomic) IBOutlet UIButton *myPromoButton;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *myLocationTextfieldHeightConstraint;
@property (strong, nonatomic) IBOutlet UILabel *myBottomLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *myPromoCenterConstraint;
@property (strong, nonatomic) IBOutlet UIButton *myCancelButton;

@end

@implementation LUFavouritePopViewController

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
    
    self.navigationController.navigationBar.hidden = YES;
    // [HELPER roundCornerForView:_myPromoView withRadius:0.5];
    [HELPER getColorIgnoredImage:@"icon_menu_promotion" imageView:_myPromoImageView color:[UIColor grayColor]];
    _myPromoTextfield.placeholder = @"Promo code";
    
    if (_isForPromoCode) {
        
        [HELPER fadeAnimationFor:_myPromoView alpha:1 duration:0];
        [HELPER fadeAnimationFor:_myBgView alpha:0 duration:0];
        
        UITapGestureRecognizer *aGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundViewTapped)];
        aGesture.numberOfTapsRequired = 1;
        
        _myPromoBgView.userInteractionEnabled = YES;
        [_myPromoBgView addGestureRecognizer:aGesture];
        
        _myPromoCenterConstraint.constant = -28;
    }
    else {
        
        [HELPER fadeAnimationFor:_myPromoView alpha:0 duration:0];
        [HELPER fadeAnimationFor:_myBgView alpha:1 duration:0];
    }
}

#pragma mark -Model

- (void)setupModel {
    
    myPrimaryLocationString = @"1";
    
    _myHomeButton.selected = YES;
    _myOfficeButton.selected = NO;
    _myOtherButton.selected = NO;
    
    _myLocationLabel.text = _gMutableDictionary[K_FAVORITE_ADDRESS];
    
    _myLocationTextfieldHeightConstraint.constant = -20;
    _myBottomLabel.hidden = YES;
    _myPromoTextfield.delegate = self;
}

- (void)loadModel {
    
}

#pragma mark - TextField Delegates

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *aUpdateString=[textField.text stringByReplacingCharactersInRange:range withString:string];
    
    
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (_isForPromoCode) {
        
        [textField resignFirstResponder];
        return YES;
    }
    
    if (textField.returnKeyType == UIReturnKeyDone) {
        
        if ([_myLocationTextfield.text isEqualToString:@""] && [myPrimaryLocationString isEqualToString:@"0"])
            [HELPER showAlertView:self title:SCREEN_TITLE_FAVORITE_PLACES message:@"Pleaase enter the title" okButtonBlock:^(UIAlertAction *action) {
                
                [_myLocationTextfield becomeFirstResponder];
            }];
        else {
            _gMutableDictionary[K_FAVORITE_DISPLAY_NAME] = _myLocationTextfield.text;
            _gMutableDictionary[K_FAVORITE_PRIMARY_LOCATION] = myPrimaryLocationString;
            
            [_myLocationTextfield resignFirstResponder];
            [self callSaveOrUpdateWebService];
        }
    }
    return YES;
}

#pragma mark - UIButton methods -

-(void)leftBarButtonTapEvent {
    
}

-(void)rightBarButtonTapEvent {
    
}

- (IBAction)promoButtonTapped:(id)sender {
    
    [self.view endEditing:YES];
    
    if (_isForReferalCode) {
        if (_myPromoTextfield.text.length == 0)
            [HELPER showAlertView:self title:APP_NAME message:@"Please enter referral code"];
        else
            [self callReferalWebService];
        
    }
    else
        
        if (_myPromoTextfield.text.length == 0)
            [HELPER showAlertView:self title:APP_NAME message:@"Please enter a promo code"];
        else
            [self callWebService];
}
- (IBAction)promoCancelButtonTapped:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)homeButtonTapped:(id)sender {
    
    myPrimaryLocationString = @"1";
    _myHomeButton.selected = YES;
    _myOfficeButton.selected = NO;
    _myOtherButton.selected = NO;
    
    _myLocationTextfieldHeightConstraint.constant = -20;
    _myBottomLabel.hidden = YES;
}

- (IBAction)officeButtonTapped:(id)sender {
    
    myPrimaryLocationString = @"2";
    _myHomeButton.selected = NO;
    _myOfficeButton.selected = YES;
    _myOtherButton.selected = NO;
    
    _myLocationTextfieldHeightConstraint.constant = -20;
    _myBottomLabel.hidden = YES;
}

- (IBAction)otherButtonTapped:(id)sender {
    
    myPrimaryLocationString = @"0";
    _myHomeButton.selected = NO;
    _myOfficeButton.selected = NO;
    _myOtherButton.selected = YES;
    
    _myLocationTextfieldHeightConstraint.constant = 21;
    _myBottomLabel.hidden = NO;
}

- (IBAction)saveButtontapped:(id)sender {
    
    if ([_myLocationTextfield.text isEqualToString:@""] && [myPrimaryLocationString isEqualToString:@"0"])
        [HELPER showAlertView:self title:SCREEN_TITLE_FAVORITE_PLACES message:@"Pleaase enter location name" okButtonBlock:^(UIAlertAction *action) {
            
            [_myLocationTextfield becomeFirstResponder];
        }];
    else {
        
        _gMutableDictionary[K_FAVORITE_DISPLAY_NAME] = _myLocationTextfield.text;
        _gMutableDictionary[K_FAVORITE_PRIMARY_LOCATION] = myPrimaryLocationString;
        
        [self callSaveOrUpdateWebService];
    }
}

- (IBAction)cancelButtonTapped:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - helper -

- (void)callWebService {
    
    if (![HTTPMANAGER isNetworkRechable]) {
        
        NSMutableDictionary *aDictAlert = [NSMutableDictionary new];
        
        aDictAlert[KEY_ALERT_TITLE]  = SCREEN_TITLE_FAVORITE_PLACES;
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
    
    
    // http://192.168.0.65:66/API/PromoCode/ValidatePromoCode?StrCustomerID=1&StrPromoCode=TxtS
    
    NSMutableDictionary *aParameterMutableDict = [NSMutableDictionary new];
    
    aParameterMutableDict[@"StrCustomerID"] = [SESSION getUserInfo][0][K_CUSTOMER_ID];
    aParameterMutableDict[@"StrPromoCode"] = [_myPromoTextfield.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    [self.myPromoButton startActivityIndicator:self];
    
    [HTTPMANAGER sendPromoCode:aParameterMutableDict completedBlock:^(NSDictionary *response) {
        
        if ([response[kRESPONSE][kRESPONSE_CODE] intValue] == kSUCCESS_CODE) {
            
            [HELPER showAlertView:self title:APP_NAME message:response[kRESPONSE][kRESPONSE_MESSAGE] okButtonBlock:^(UIAlertAction *action) {
                
                [self dismissViewControllerAnimated:YES completion:^{
                    
                    if (_promoCodeCallBackBlock) {
                        
                        _promoCodeCallBackBlock(YES, response[@"PromoCode_Id"], _myPromoTextfield.text);
                    }
                }];
            }];
            
        }
        else if ([response[kRESPONSE][kRESPONSE_CODE] intValue] == K_NO_DATA_CODE){
            
            [HELPER showAlertView:self title:APP_NAME message:response[kRESPONSE][kRESPONSE_MESSAGE]];
        }
        else {
            
            [HELPER showAlertView:self title:APP_NAME message:MESSAGE_SOMETHING_WENT_WRONG];
        }
        
        [self.myPromoButton stopActivityIndicator:self withResetTitle:@"Submit"];
        [HELPER removeLoadingIn:self];
        
    } failedBlock:^(NSError *error) {
        
        [self.myPromoButton stopActivityIndicator:self withResetTitle:@"Submit"];
        [HELPER showAlertView:self title:APP_NAME message:MESSAGE_SOMETHING_WENT_WRONG];
        [HELPER removeLoadingIn:self];
    }];
}

- (void)callReferalWebService {
    
    if (![HTTPMANAGER isNetworkRechable]) {
        
        NSMutableDictionary *aDictAlert = [NSMutableDictionary new];
        
        aDictAlert[KEY_ALERT_TITLE]  = SCREEN_TITLE_FAVORITE_PLACES;
        aDictAlert[KEY_ALERT_DESC]  = [NSString stringWithFormat:@"%@. Tap to try again",ALERT_NO_INTERNET_DESC];
        aDictAlert[KEY_ALERT_IMAGE]  = @"icon_no_internet";
        
        // List is empty so show 'Tap to retry' view
        [HELPER showRetryAlertIn:self details:aDictAlert retryBlock:^{
            
            if ([HTTPMANAGER isNetworkRechable]) {
                
                [HELPER removeRetryAlertIn:self];
                [HELPER removeLoadingIn:self];
                [self callReferalWebService];
            }
        }];
        return;
    }
    
    NSMutableDictionary *aParameterMutableDict = [NSMutableDictionary new];
    NSMutableDictionary *aMutableDict = [NSMutableDictionary new];
    NSMutableDictionary *aLoginMutableDict = [NSMutableDictionary new];
    
    aMutableDict[@"StrCustomerID"] = [SESSION getUserInfo][0][K_CUSTOMER_ID];
    aMutableDict[@"StrPromoCode"] = _myPromoTextfield.text;
    
    aLoginMutableDict[@"PromoCode_Info"] = aMutableDict;
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:aLoginMutableDict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *string = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    aParameterMutableDict[@"StrJson"] = string;
    
    [self.myPromoButton startActivityIndicator:self];
    
    [HTTPMANAGER referalCode:aParameterMutableDict completedBlock:^(NSDictionary *response) {
        
        if ([response[kRESPONSE][kRESPONSE_CODE] intValue] == kSUCCESS_CODE) {
            
            [HELPER showAlertView:self title:APP_NAME message:response[kRESPONSE][kRESPONSE_MESSAGE] okButtonBlock:^(UIAlertAction *action) {
                
                [self dismissViewControllerAnimated:YES completion:^{
                    
                }];
            }];
            
        }
        else if ([response[kRESPONSE][kRESPONSE_CODE] intValue] == K_NO_DATA_CODE){
            
            [HELPER showAlertView:self title:APP_NAME message:response[kRESPONSE][kRESPONSE_MESSAGE]];
        }
        else {
            
            [HELPER showAlertView:self title:APP_NAME message:MESSAGE_SOMETHING_WENT_WRONG];
        }
        
        [self.myPromoButton stopActivityIndicator:self withResetTitle:@"Submit"];
        [HELPER removeLoadingIn:self];
        
    } failedBlock:^(NSError *error) {
        
        [self.myPromoButton stopActivityIndicator:self withResetTitle:@"Submit"];
        
        if (error.code == NSURLErrorTimedOut)
            [HELPER showRetryAlertIn:self details:ALERT_UNABLE_TO_REACH_DICT retryBlock:^{
                
                if ([HTTPMANAGER isNetworkRechable]) {
                    
                    [HELPER removeRetryAlertIn:self];
                    [HELPER showLoadingIn:self];
                    [self callReferalWebService];
                }
            }];
        else
            [HELPER showNotificationSuccessIn:self withMessage:MESSAGE_SOMETHING_WENT_WRONG];
        [HELPER removeLoadingIn:self];
    }];
}

- (void)callSaveOrUpdateWebService {
    
    /*
     http://192.168.0.48/PPTCustomer/API/CustomerFavourites/SaveFavourites?StrJson={ "Favourites_Info":{"Fav_Id":"",         "Customer_Id":"11","Latitude":"44.968046","Longitude":"-94.420307","Display_Name":"Siva","Address":"Coimbatore","Primary_Location":"1"} }
     */
    
    if (![HTTPMANAGER isNetworkRechable]) {
        
        NSMutableDictionary *aDictAlert = [NSMutableDictionary new];
        
        aDictAlert[KEY_ALERT_TITLE]  = SCREEN_TITLE_FAVORITE_PLACES;
        aDictAlert[KEY_ALERT_DESC]  = [NSString stringWithFormat:@"%@. Tap to try again",ALERT_NO_INTERNET_DESC];
        aDictAlert[KEY_ALERT_IMAGE]  = @"icon_no_internet";
        
        // List is empty so show 'Tap to retry' view
        [HELPER showRetryAlertIn:self details:aDictAlert retryBlock:^{
            
            if ([HTTPMANAGER isNetworkRechable]) {
                
                [HELPER removeRetryAlertIn:self];
                [HELPER removeLoadingIn:self];
                [self callSaveOrUpdateWebService];
            }
        }];
        return;
    }
    
    NSMutableDictionary *aMutableDict = [NSMutableDictionary new];
    NSMutableDictionary *aLoginMutableDict = [NSMutableDictionary new];
    NSMutableDictionary *aParameterMutableDict = [NSMutableDictionary new];
    
    _gMutableDictionary[K_FAVORITE_ID] = @"";
    
    aMutableDict = _gMutableDictionary;
    aMutableDict[K_CUSTOMER_ID] = [SESSION getUserInfo][0][K_CUSTOMER_ID];
    
    aLoginMutableDict[@"Favourites_Info"] = aMutableDict;
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:aLoginMutableDict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *string = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    aParameterMutableDict[@"StrJson"] = string;
    
    [HELPER showLoadingIn:self];
    
    [HTTPMANAGER saveOrUpdateFavoriteType:aParameterMutableDict completedBlock:^(NSDictionary *response) {
        
        if ([response[kRESPONSE][kRESPONSE_CODE] intValue] == kSUCCESS_CODE) {
            
            NSMutableArray *aMainMutableArray = [NSMutableArray new];
            
            // This to get the array position based on primary location
            
            aMainMutableArray = [[COREDATAMANAGER getFavouriteListInfo] mutableCopy];
            NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"favourite_filter" ascending:YES];
            NSArray *aArray = [aMainMutableArray sortedArrayUsingDescriptors:@[sortDescriptor]];
            
            if (self.isFromSwiftScreen)
                [self.gDelegate getSelectedAddressAsFavorite:[aArray mutableCopy] iscallBack:YES];
            
            [self dismissViewControllerAnimated:YES completion:^{
                
                if (!self.isFromSwiftScreen) {
                    
                    if (_callBackBlock)
                        _callBackBlock(YES, [aArray mutableCopy]);
                }
                
            }];
        }
        
        else {
            
            [HELPER showNotificationSuccessIn:self withMessage:response[kRESPONSE][kRESPONSE_MESSAGE]];
        }
        [HELPER removeLoadingIn:self];
        
    } failedBlock:^(NSError *error) {
        
        if (error.code == NSURLErrorTimedOut)
            [HELPER showRetryAlertIn:self details:ALERT_SIGNALR_UNABLE_TO_REACH_DICT retryBlock:^{
                
                if ([HTTPMANAGER isNetworkRechable]) {
                    
                    [HELPER removeRetryAlertIn:self];
                    [HELPER showLoadingIn:self];
                    [self callSaveOrUpdateWebService];
                }
            }];
        else
            [HELPER showNotificationSuccessIn:self withMessage:MESSAGE_SOMETHING_WENT_WRONG];
        [HELPER removeLoadingIn:self];
    }];
}


-(void)backgroundViewTapped {
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

// Hide Keyboard
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
