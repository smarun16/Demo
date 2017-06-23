//
//  LUOTPViewController.m
//  Levare User
//
//  Created by AngMac137 on 11/17/16.
//  Copyright © 2016 AngMac137. All rights reserved.
//

#import "LUOTPViewController.h"

@interface LUOTPViewController ()<UITextFieldDelegate>
{
    
}
@property (strong, nonatomic) IBOutlet UILabel *myMobileNumberString;
@property (strong, nonatomic) IBOutlet UITextField *myFirstBoxTextfield;
@property (strong, nonatomic) IBOutlet UITextField *mySecondBoxTextfield;
@property (strong, nonatomic) IBOutlet UITextField *myThirdBoxTextfield;
@property (strong, nonatomic) IBOutlet UITextField *myFourthBoxTextfield;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *mysendAgainButtonBottomConstraint;
@property (strong, nonatomic) IBOutlet UILabel *myOtpLabel;


@end

@implementation LUOTPViewController

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
    
    
    // To set navigation bar to present with navigation
    [self setUpNavigationBar];
    
    [HELPER roundCornerForView:_myFirstBoxTextfield radius:2 borderColor:COLOR_BLACK];
    [HELPER roundCornerForView:_mySecondBoxTextfield radius:2 borderColor:COLOR_BLACK];
    [HELPER roundCornerForView:_myThirdBoxTextfield radius:2 borderColor:COLOR_BLACK];
    [HELPER roundCornerForView:_myFourthBoxTextfield radius:2 borderColor:COLOR_BLACK];
    
    NSString *aString = _gCustomerMutableDict[K_MOBILE_NUMBER];
    NSString *aMobileNumberString;
    
    if ([[aString substringToIndex:1] isEqualToString:@"0"]) {
        
        NSString *aNewString = _gCustomerMutableDict[K_MOBILE_NUMBER];
        aMobileNumberString = [aNewString substringFromIndex:1];
    }
    else
        aMobileNumberString = _gCustomerMutableDict[K_MOBILE_NUMBER];
    
    _myMobileNumberString.text = [NSString stringWithFormat:@"that was send to the number +%@%@",[_gCustomerMutableDict[K_COUNTRY_CODE] stringByReplacingOccurrencesOfString:@" " withString:@""],aMobileNumberString];
    
    _myOtpLabel.text = @"";
    [self callOTPWebService];
    
}

#pragma mark -Model

- (void)setupModel {
    
    _myFirstBoxTextfield.tag = 1;
    _mySecondBoxTextfield.tag = 2;
    _myThirdBoxTextfield.tag = 3;
    _myFourthBoxTextfield.tag = 4;
    
    // Set Toolbar For all the fields
    UIToolbar *aToolBar = [HELPER getToolbarWithTitle:@"" target:self titleAlignment:ALIGN_LEFT buttonTitle:@"Next" tag:50];
    aToolBar.barTintColor = [HELPER getColorFromHexaDecimal:COLOR_APP_PRIMARY];
    _myFirstBoxTextfield.inputAccessoryView = aToolBar;
    
    UIToolbar *aToolBar1 = [HELPER getToolbarWithTitle:@"" target:self titleAlignment:ALIGN_LEFT buttonTitle:@"Next" tag:60];
    aToolBar1.barTintColor = [HELPER getColorFromHexaDecimal:COLOR_APP_PRIMARY];
    _mySecondBoxTextfield.inputAccessoryView = aToolBar1;
    
    UIToolbar *aToolBar2 = [HELPER getToolbarWithTitle:@"" target:self titleAlignment:ALIGN_LEFT buttonTitle:@"Next" tag:70];
    aToolBar2.barTintColor = [HELPER getColorFromHexaDecimal:COLOR_APP_PRIMARY];
    _myThirdBoxTextfield.inputAccessoryView = aToolBar2;
    
    UIToolbar *aToolBar3 = [HELPER getToolbarWithTitle:@"" target:self titleAlignment:ALIGN_LEFT buttonTitle:@"Done" tag:80];
    aToolBar3.barTintColor = [HELPER getColorFromHexaDecimal:COLOR_APP_PRIMARY];
    _myFourthBoxTextfield.inputAccessoryView = aToolBar3;
    
}

- (void)loadModel {
    
}

#pragma mark - TextField Delegates

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *aUpdateString=[textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (aUpdateString.length == 1) {
        
        textField.text = string;
        
        if (textField == _myFourthBoxTextfield) {
            
            if (![aUpdateString isEqualToString:@""]) {
                
                [UIView animateWithDuration:.2 animations:^{
                    [self.view endEditing:YES];
                    _mysendAgainButtonBottomConstraint.constant = 0;
                    [self callWebService];
                }];
            }
        }
        else
            textField.text = aUpdateString;
    }
    else {
        
        if (textField == _myFirstBoxTextfield) {
            
            if (![aUpdateString isEqualToString:@""]) {
                
                [_mySecondBoxTextfield becomeFirstResponder];
                _mySecondBoxTextfield.text = string;
            }
            else
                textField.text = aUpdateString;
        }
        else  if (textField == _mySecondBoxTextfield) {
            
            if (![aUpdateString isEqualToString:@""]) {
                
                [_myThirdBoxTextfield becomeFirstResponder];
                _myThirdBoxTextfield.text = string;
            }
            else
                textField.text = aUpdateString;
        }
        else  if (textField == _myThirdBoxTextfield) {
            
            if (![aUpdateString isEqualToString:@""]) {
                
                [_myFourthBoxTextfield becomeFirstResponder];
                _myFourthBoxTextfield.text = string;
            }
            else
                textField.text = aUpdateString;
        }
        else  if (textField == _myFourthBoxTextfield) {
            
            if ([aUpdateString isEqualToString:@""]) {
                textField.text = aUpdateString;
            }
        }
    }
    return NO;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    [UIView animateWithDuration:.2 animations:^{
        _mysendAgainButtonBottomConstraint.constant = 250;
    }];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [UIView animateWithDuration:.2 animations:^{
        
        _mysendAgainButtonBottomConstraint.constant = 0;
    }];
    return YES;
}

#pragma mark - UIButton methods -

- (void)leftBarButtonTapEvent {
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (IBAction)sendAgainButtonTapped:(id)sender {
    
    [self callOTPWebService];
}

- (IBAction)changeAccountButtonTapped:(id)sender {
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Helper -

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
    label.text = TITLE_OTP;
    [label sizeToFit];
    
    self.navigationItem.leftBarButtonItem  = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemStop  target:self action:@selector(leftBarButtonTapEvent)];
}

// Hide Keyboard
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
   // [self.view endEditing:YES];
    
}

- (void)toolbarButtonTapAction:(id)sender {
    
    UIBarButtonItem *aButtonItem = (UIBarButtonItem*)sender;
    
    if (aButtonItem.tag == 50) {
        
        [_mySecondBoxTextfield becomeFirstResponder];
    }
    else if (aButtonItem.tag == 60) {
        
        [_myThirdBoxTextfield becomeFirstResponder];
    }
    else if (aButtonItem.tag == 70) {
        
        [_myFourthBoxTextfield becomeFirstResponder];
    }
    else {
        
        if (_myFirstBoxTextfield.text.length && _mySecondBoxTextfield.text.length && _myThirdBoxTextfield.text.length && _myFourthBoxTextfield.text .length) {
            
            _gCustomerMutableDict[K_OTP] = [NSString stringWithFormat:@"%@%@%@%@",_myFirstBoxTextfield.text, _mySecondBoxTextfield.text,_myThirdBoxTextfield.text,_myFourthBoxTextfield.text];
            
            [self callWebService];
        }
        else {
            
            [HELPER showNotificationSuccessIn:self withMessage:@"Please enter a valid OTP"];
        }
    }
}

-(void)callOTPWebService {
    
    if (![HTTPMANAGER isNetworkRechable]) {
        
        NSMutableDictionary *aDictAlert = [NSMutableDictionary new];
        
        aDictAlert[KEY_ALERT_TITLE]  = SCREEN_TITLE_OTP;
        aDictAlert[KEY_ALERT_DESC]  = [NSString stringWithFormat:@"%@. Tap to try again",ALERT_NO_INTERNET_DESC];
        aDictAlert[KEY_ALERT_IMAGE]  = @"icon_no_internet";
        
        // List is empty so show 'Tap to retry' view
        [HELPER showRetryAlertIn:self details:aDictAlert retryBlock:^{
            
            if ([HTTPMANAGER isNetworkRechable]) {
                
                [HELPER removeRetryAlertIn:self];
                [HELPER removeLoadingIn:self];
                [self callOTPWebService];
            }
        }];
        return;
    }
    
    NSMutableDictionary *aParameterMutableDict = [NSMutableDictionary new];
    
    aParameterMutableDict[@"StrPhoneNumber"] = _gCustomerMutableDict[K_MOBILE_NUMBER];
    aParameterMutableDict[@"StrCountryCode"] = [_gCustomerMutableDict[K_COUNTRY_CODE] stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    [HELPER showLoadingIn:self];
    
    [HTTPMANAGER getOTP:aParameterMutableDict completedBlock:^(NSDictionary *response) {
        
        if ([response[kRESPONSE][kRESPONSE_CODE] intValue] == kSUCCESS_CODE) {
            
            NSLog(@"OTP ----- %@", response[kRESPONSE][@"OTP"]);
            _myOtpLabel.text = response[kRESPONSE][@"OTP"];
            [_myFirstBoxTextfield becomeFirstResponder];
        }
        else if([response[kRESPONSE][kRESPONSE_CODE] intValue] == K_NO_DATA_CODE) {
            
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
                    [self callOTPWebService];
                }
            }];
        else
            [HELPER showNotificationSuccessIn:self withMessage:MESSAGE_SOMETHING_WENT_WRONG];
        [HELPER removeLoadingIn:self];
    }];
}

- (void)callWebService {
    
    if (![HTTPMANAGER isNetworkRechable]) {
        
        NSMutableDictionary *aDictAlert = [NSMutableDictionary new];
        
        aDictAlert[KEY_ALERT_TITLE]  = SCREEN_TITLE_OTP;
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
    /*
     http://192.168.0.48/PPTCustomer/API/Register/SaveCustomer?StrJson={"Registration_Info":                    {"Mobile_Number":"+919677892277","Email_ID":"sivakuma@angleritech.com","First_Name":"Sivakumar","Last_Name":"R","OTP":"1232","Customer_Id":"11" ,"Password":"Siva","Gcm_Reg_Id":"Addfh5765fsdfjaklf","IMEI_No":"ABR144DDSS","Device_Type":"A", "Version_Number":"1.0.0"}}*/
    
    NSMutableDictionary *aMutableDict = [NSMutableDictionary new];
    NSMutableDictionary *aLoginMutableDict = [NSMutableDictionary new];
    NSMutableDictionary *aParameterMutableDict = [NSMutableDictionary new];
    
    aMutableDict[@"Email_ID"] = _gCustomerMutableDict[@"Email_Id"];
    aMutableDict[@"Mobile_Number"] = _gCustomerMutableDict[K_MOBILE_NUMBER];
    aMutableDict[@"First_Name"] = _gCustomerMutableDict[K_FIRST_NAME];
    aMutableDict[@"Last_Name"] = _gCustomerMutableDict[K_LAST_NAME];
    aMutableDict[@"OTP"] = [_gCustomerMutableDict[K_OTP] isEqualToString:@""] ? @"" : _gCustomerMutableDict[K_OTP];
    aMutableDict[@"Password"] = _gCustomerMutableDict[K_PASSWORD];
    aMutableDict[@"Gcm_Reg_Id"] = [SESSION getDeviceToken];
    aMutableDict[@"IMEI_No"] = [SESSION getDeviceToken];
    aMutableDict[@"Device_Type"] = @"I";
    aMutableDict[@"Version_Number"] = [HELPER getAppVersion];
    aMutableDict[@"Customer_Id"] = ([_gCustomerMutableDict[@"Customer_Id"] isEqualToString:@""]) ? @"":_gCustomerMutableDict[@"Customer_Id"];
    aMutableDict[K_COUNTRY_CODE] = [_gCustomerMutableDict[K_COUNTRY_CODE] stringByReplacingOccurrencesOfString:@" " withString:@""];
    aMutableDict[K_COUNTRY] = _gCustomerMutableDict[K_COUNTRY];
    
    aLoginMutableDict[@"Registration_Info"] = aMutableDict;
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:aLoginMutableDict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *string = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    aParameterMutableDict[@"StrJson"] = string;
    
    [self.view endEditing:YES];
    [HELPER showLoadingIn:self];
    
    [HTTPMANAGER getCustomerDetails:aParameterMutableDict path:_gCustomerMutableDict[K_PROFILE_DATA] imageName:_gCustomerMutableDict[K_PROFILE_IMAGE] completedBlock:^(NSDictionary *response) {
        
        if ([response[kRESPONSE][kRESPONSE_CODE] intValue] == kSUCCESS_CODE) {
            
            NSMutableArray *aMutableArray = [NSMutableArray new];
            
            [aMutableArray addObject:[response valueForKey:@"User_Info"]];
            [SESSION setUserInfo:aMutableArray];
            [SESSION isFlagChanged:NO];
            
            NSMutableArray *aChatMutableArray = [NSMutableArray new];
            NSMutableDictionary *aChatMutableDict = [NSMutableDictionary new];
            NSMutableArray *aChatMArray = [NSMutableArray new];
            
            [SESSION_2 isRequested:([[aMutableArray[0] valueForKey:@"Is_Requested"] isEqualToString:@"1"]) ? YES : NO];

            aChatMArray = [aMutableArray valueForKey:@"Card_Info"];
            aChatMArray = aChatMArray[0];
            
            for (int i = 0; i < aChatMArray.count; i++) {
                
                aChatMutableDict[@"Credit_Card_Number"] = [aChatMArray[i] valueForKey:@"Credit_Card_Number"];
                aChatMutableDict[@"CVN"] = [aChatMArray[i] valueForKey:@"CVN"];
                aChatMutableDict[@"Expiry_Date"] = [aChatMArray[i] valueForKey:@"Expiry_Date"];
                aChatMutableDict[@"Card_Holder_Name"] = [aChatMArray[i] valueForKey:@"Card_Holder_Name"];
                
                if (![aChatMutableDict[@"Credit_Card_Number"] isEqualToString:@""]) {
                    
                    [aChatMutableArray addObject:aChatMutableDict];
                }
            }
            [SESSION setCardInfo:aChatMArray];
            
            if ([_gCustomerMutableDict objectForKey:@"Customer_Id"] && ![_gCustomerMutableDict[@"Customer_Id"] isEqualToString:@""]) {
                
                [HELPER showAlertView:self title:APP_NAME message:response[kRESPONSE][kRESPONSE_MESSAGE] okButtonBlock:^(UIAlertAction *action) {
                    
                    [self.navigationController dismissViewControllerAnimated:YES completion:^{
                        
                    }];
                }];
            }
            else {
           
                [HELPER showAlertView:self title:APP_NAME message:response[kRESPONSE][kRESPONSE_MESSAGE] okButtonBlock:^(UIAlertAction *action) {
                    
                    NSMutableArray *aChatMutableArray = [NSMutableArray new];
                    [SESSION setCardInfo:aChatMutableArray];
                    
                    [SESSION hasLoggedIn:YES];
                    LUPaymentOptionViewController *aViewController = [STORY_BOARD instantiateViewControllerWithIdentifier:@"LUPaymentOptionViewController"];
                    aViewController.isFromOTPScreen = YES;
                    
                    UINavigationController *aNavigationController = [[UINavigationController alloc]initWithRootViewController:aViewController];
                    [self.navigationController presentViewController:aNavigationController animated:YES completion:^{
                    }];
                }];
            }
        }
        else if([response[kRESPONSE][kRESPONSE_CODE] intValue] == K_NO_DATA_CODE) {
            
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

@end
