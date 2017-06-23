//
//  LUForgotPasswordViewController.m
//  Levare User
//
//  Created by AngMac137 on 11/17/16.
//  Copyright © 2016 AngMac137. All rights reserved.
//

#import "LUForgotPasswordViewController.h"

@interface LUForgotPasswordViewController ()

@property (strong, nonatomic) IBOutlet UIView *myBgView;
@property (strong, nonatomic) IBOutlet UITextField *myEmailTextfield;
@property (strong, nonatomic) IBOutlet UIImageView *myEmailImageView;
@end

@implementation LUForgotPasswordViewController

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
    
    [HELPER roundCornerForView:_myBgView radius:2 borderColor:[UIColor blackColor]];
    
    [self setUpNavigationBar];
}

#pragma mark -Model

- (void)setupModel {
    
}

- (void)loadModel {
    
}

#pragma mark - UIButton methods -

- (void)leftBarButtonTapEvent {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)rightBarButtonTapEvent {
    
    if (_myEmailTextfield.text.length == 0) {
      
        [HELPER showAlertView:self title:SCREEN_TITLE_FORGOT_PASSWORD message:K_ALERT_EMAIL okButtonBlock:^(UIAlertAction *action) {
            [_myEmailTextfield becomeFirstResponder];
        }];
    }
    else if (![_myEmailTextfield.text isValidEmail]) {
       
        [HELPER showAlertView:self title:SCREEN_TITLE_FORGOT_PASSWORD message:K_ALERT_EMAIL_NOT_VALID okButtonBlock:^(UIAlertAction *action) {
          
            [_myEmailTextfield becomeFirstResponder];
        }];
    }
    else {
        
        [self.view endEditing:YES];
        [self callWebService];
    }
    
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
    
    [self.view endEditing:YES];
    [self callWebService];
    
    return YES;
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
    label.text = SCREEN_TITLE_FORGOT_PASSWORD;
    [label sizeToFit];

    self.navigationItem.leftBarButtonItem  = [[UIBarButtonItem alloc]initWithTitle:BACK style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonTapEvent)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonTapEvent)];
}
// Hide Keyboard
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
}

-(void)callWebService {
    
    if (![HTTPMANAGER isNetworkRechable]) {
        
        NSMutableDictionary *aDictAlert = [NSMutableDictionary new];
        
        aDictAlert[KEY_ALERT_TITLE]  = SCREEN_TITLE_FORGOT_PASSWORD;
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
     http://192.168.0.48/PPTCustomer/API/Login/GetForgotPassword?StrEmailId:arun@gmail.com
     */

    NSMutableDictionary *aParameterMutableDict = [NSMutableDictionary new];
    
    aParameterMutableDict[@"StrEmailId"] = _myEmailTextfield.text;
    
    [HELPER showLoadingIn:self];
    
    [HTTPMANAGER getForgotpassword:aParameterMutableDict completedBlock:^(NSDictionary *response) {
        
        if ([response[kRESPONSE][kRESPONSE_CODE] intValue] == kSUCCESS_CODE) {
            
            [HELPER showAlertView:self title:SCREEN_TITLE_FORGOT_PASSWORD message:response[kRESPONSE][kRESPONSE_MESSAGE] okButtonBlock:^(UIAlertAction *action) {
               
                [self.navigationController popViewControllerAnimated:YES];
            }];
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
