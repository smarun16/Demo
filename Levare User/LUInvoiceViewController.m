//
//  LUInvoiceViewController.m
//  Levare User
//
//  Created by Arun Prasad.S, ANGLER - EIT on 30/12/16.
//  Copyright © 2016 AngMac137. All rights reserved.
//

#import "LUInvoiceViewController.h"
#import "Session.h"

@interface LUInvoiceViewController ()<RatingViewDelegate, UITextViewDelegate, UITextFieldDelegate>
{
    NSString *myTipAmountString;
}


@end

@implementation LUInvoiceViewController

#pragma mark - View & Model -

#pragma mark -View Life Cycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // setup UI & Content
    [self setupUI];
    [self setupModel];
    
    // Load Contents
   // [self loadModel];
    
    APPDELEGATE.sideMenu.openDrawerGestureModeMask = MMOpenDrawerGestureModePanningNavigationBar;

}

-(void)viewDidDisappear:(BOOL)animated {
    
    APPDELEGATE.sideMenu.openDrawerGestureModeMask = MMOpenDrawerGestureModeAll;

}

#pragma mark -View Init

- (void)setupUI {
    
    [NAVIGATION setTitleWithBarButtonItems:TITLE_RATE_ME forViewController:self showLeftBarButton:nil showRightBarButton:nil];
    
    _myBookingIdLabel.text = _gTripIdString;
    _myAmountLabel.text = [NSString stringWithFormat:@"Your bill is $%@", _gInfoArray[0][@"Trip_Amount"]];
    _myRideTimeLabel.text = _gInfoArray[0][@"Start_Time"];
    _myRideTimePerKmLabel.text = [NSString stringWithFormat:@"%@ mins | %@ kms",_gInfoArray[0][@"Trip_Duration"],_gInfoArray[0][@"Distance"]];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [HELPER setURLProfileImageForImageView:_myDriverImageView URL:_myProfileUrl placeHolderImage:IMAGE_NO_PROFILE];
    });
    
    [HELPER roundCornerForView:_myDriverImageView];
    
    _myFeedbackTextView.returnKeyType = UIReturnKeyDone;
    
    
}

#pragma mark -Model

- (void)setupModel {
    
    [_myRateView setupSelectedImageName:RATE_WITH_GOLD_STAR unSelectedImage:RATE_WITH_NO_STAR minValue:0 maxValue:5 intervalValue:0.5 stepByStep:1];
    _myRateView.delegate = self;
    _myRateView.value = 0;
    
    _myTipAmountTextfield.delegate = self;
    _myFeedbackTextView.delegate = self;
    _myFeedbackTextView.tag = 1;
    _myFeedbackTextView.placeholder = @"Enter your Feedback";
    _myFeedbackTextView.text = @"";
    myTipAmountString = @"";
    
    [_myTipAmountTextfield becomeFirstResponder];
    
    UIScrollView *aScr;
    
    aScr.bounces = YES;
}

- (void)loadModel {
    
    if (!_myHubConnection) {
        
        _myHubConnection = [SRHubConnection connectionWithURLString:vHUB_URL];
        _myHubProxy = [_myHubConnection createHubProxy:vHUB_PROXY];
        [_myHubConnection start];
    }
}

#pragma mark - TextView Delegate -

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if ([text isEqualToString:@"\n"]) {
        
        [self.view endEditing:YES];
        return NO;
    }
    
    NSString *aText = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
    if (textView.tag == 1) {
        
        
    }
    
    
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    
    if (textView.tag == 210) {
        
    }
}


#pragma mark - TextField Delegates

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *aUpdateString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (aUpdateString.length <= 4) {
        
        myTipAmountString = aUpdateString;
        return YES;
    }
    
    return NO;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self.view endEditing:YES];
    
    return YES;
}


#pragma mark - UIButton Method -

- (IBAction)continueButtonTapped:(id)sender {
    
    [self continueButtonTapped];
}

-(void)leftBarButtonTapEvent {
    
    [self goOffline];
    
}

-(void)goOffline{
    
}
-(void)continueButtonTapped {
    
    if (_myRateView.value == 0) {
        
        [HELPER showNotificationSuccessIn:self withMessage:@"Please give a Rating"];
    }
    else if ([_myFeedbackTextView.text isEqualToString:@""]) {
        
        [HELPER showAlertView:self title:SCREEN_TITLE_RATE_ME message:@"Please give a Feedback" okButtonBlock:^(UIAlertAction *action) {
            [_myFeedbackTextView becomeFirstResponder];
        }];
    }
    else {
        
        [self.myContinueButton startActivityIndicator:self];
        [self callWebService];
    }
}

#pragma mark - RatingView Delegate -

- (void)rateChanged:(RatingView *)sender {
    
    [self.view endEditing:YES];
    _myRateView.value  = sender.value;
}


// Hide Keyboard
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
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
    
    NSMutableDictionary *aParameterMutableDict = [NSMutableDictionary new];
    
    aParameterMutableDict[@"StrTripId"] = _gTripIdString;
    aParameterMutableDict[@"StrUserId"] = [SESSION getUserInfo][0][K_CUSTOMER_ID];
    aParameterMutableDict[@"StrRating"] = [NSString stringWithFormat:@"%.01f",_myRateView.value];
    aParameterMutableDict[@"StrComments"] = _myFeedbackTextView.text;
    aParameterMutableDict[@"StrUserType"] = SR_CUSTOMER_TYPE;
    aParameterMutableDict[@"StrTipAmount"] = @"";
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:aParameterMutableDict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *string = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

    [HELPER showLoadingIn:self];
    
 /*
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?StrTripId=%@&=%@&StrRating=%@&StrComments=%@&StrUserType=%@&StrTipAmount=%@",WEB_SERVICE_STRING(WEB_SERVICE_URL, SR_UPDATE_RATING),_gTripIdString,[SESSION getUserInfo][0][K_CUSTOMER_ID],[NSString stringWithFormat:@"%.01f",_myRateView.value],_myFeedbackTextView.text,SR_CUSTOMER_TYPE,@""]];
    
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:queue completionHandler:^(NSURLResponse* response, NSData* data, NSError *error)
     {
         NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
         NSLog(@"%@",dictionary);
     }];
    */
    
    [HTTPMANAGER sendRating:aParameterMutableDict completedBlock:^(NSDictionary *response) {
        
        if ([response[kRESPONSE][kRESPONSE_CODE] intValue] == kSUCCESS_CODE) {
            
            [SESSION setChatInfo:[NSMutableArray new]];
            [SESSION_2 isRequested:NO];
            [SESSION_2 isAlertShown:NO];

            [self.myContinueButton stopActivityIndicatorWithResetTitle:@"Submit"];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self.navigationController popViewControllerAnimated:YES];
            });
            
        }
        
        else {
            
            [HELPER showNotificationSuccessIn:self withMessage:response[kRESPONSE][kRESPONSE_MESSAGE]];
        }
        
        [HELPER removeLoadingIn:self];
        
    } failedBlock:^(NSError *error) {
        
        [HELPER showNotificationSuccessIn:self withMessage:MESSAGE_SOMETHING_WENT_WRONG];
        [HELPER removeLoadingIn:self];
    }];
}


@end
