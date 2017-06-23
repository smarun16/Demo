//
//  LULoginViewController.m
//  Levare User
//
//  Created by AngMac137 on 11/16/16.
//  Copyright © 2016 AngMac137. All rights reserved.
//

#import "LULoginViewController.h"
#import "LUSignUpViewController.h"
#import "LUForgotPasswordViewController.h"

@interface LULoginViewController ()< UITextFieldDelegate>
{
    NSString *myCountryNameString;
    NSString *myCountryCodeString;
    UIImage *myCountryFlag;
}
@property (strong, nonatomic) IBOutlet UITableView *myTableView;

//Model
@property (strong, nonatomic) NSString *myUserNameString, *myPasswordString;

@end

@implementation LULoginViewController

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
    
    self.navigationController.navigationBarHidden = NO;
    _myTableView.tableFooterView = [UIView new];
    _myTableView.sectionHeaderHeight = 0;
    _myTableView.sectionFooterHeight = 0;
    
    [HELPER roundCornerForView:_myTableView radius:5 borderColor:[UIColor blackColor]];
}

#pragma mark -Model

- (void)setupModel {
    
    [self setUpNavigationBar];
}

- (void)loadModel {
    
    // FIXME : Remove below line
    // _myUserNameString = @"arun@gmail.com";
    // _myPasswordString = @"123123";
}



#pragma mark - UITable view Delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellIdentifier =@"LoginCell";
    
    UITableViewCell *aCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (aCell == nil) {
        
        aCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    UIImageView *gImageView = (UIImageView *)[aCell viewWithTag:1];
    UITextField *gTextfield = (UITextField *)[aCell viewWithTag:2];
    
    gTextfield.delegate = self;
    
    if (indexPath.row == 0) {
        
        gImageView.image = [[UIImage imageNamed:@"icon_email"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        gImageView.tintColor = [UIColor lightGrayColor];
        gTextfield.text = _myUserNameString;
        gTextfield.tag = 10;
        gTextfield.placeholder = @"Email";
        gTextfield.secureTextEntry = NO;
        gTextfield.keyboardType = UIKeyboardTypeEmailAddress;
        gTextfield.returnKeyType = UIReturnKeyNext;
        
    }
    else {
        
        gImageView.image = [[UIImage imageNamed:@"icon_password"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        gImageView.tintColor = [UIColor lightGrayColor];
        gTextfield.text = _myPasswordString;
        gTextfield.tag = 11;
        gTextfield.placeholder = @"Password";
        gTextfield.secureTextEntry = YES;
        gTextfield.keyboardType = UIKeyboardTypeDefault;
        gTextfield.returnKeyType = UIReturnKeyDone;
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
}

#pragma mark - TextField Delegates

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *aUpdateString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (textField.tag == 10) {
        
        if (![HELPER isText:aUpdateString]) {
            if (aUpdateString.length > 10)
                return NO;
        }
        else
            if ([aUpdateString isEqualToString:@" "])
                return NO;
        
        _myUserNameString = aUpdateString;
    }
    else if (textField.tag == 11) {
        
        _myPasswordString = aUpdateString;
    }
    
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField.returnKeyType == UIReturnKeyNext) {
        
        [[self.myTableView viewWithTag:textField.tag + 1] becomeFirstResponder];
    }
    else {
        
        if (_myUserNameString.length == 0) {
            
            [HELPER showAlertView:self title:SCREEN_TITLE_LOGIN message:K_ALERT_EMAIL okButtonBlock:^(UIAlertAction *action) {
                
                [[_myTableView viewWithTag:10] becomeFirstResponder];
            }];
        }
        else if ([HELPER isText:_myUserNameString] && ![_myUserNameString isValidEmail]) {
            [HELPER showAlertView:self title:SCREEN_TITLE_LOGIN message:K_ALERT_EMAIL_NOT_VALID okButtonBlock:^(UIAlertAction *action) {
                [[_myTableView viewWithTag:10] becomeFirstResponder];
            }];
        }
        else if (![HELPER isText:_myUserNameString] && _myUserNameString.length < 10) {
            [HELPER showAlertView:self title:SCREEN_TITLE_LOGIN message:K_ALERT_VALIDATE_MOBILE_NO okButtonBlock:^(UIAlertAction *action) {
                [[_myTableView viewWithTag:10] becomeFirstResponder];
            }];
        }
        else if (_myPasswordString.length == 0) {
            [HELPER showAlertView:self title:SCREEN_TITLE_LOGIN message:K_ALERT_PASSWORD okButtonBlock:^(UIAlertAction *action) {
                
                [[_myTableView viewWithTag:11] becomeFirstResponder];
            }];
        }
        else if (_myPasswordString.length < 6) {
            [HELPER showAlertView:self title:SCREEN_TITLE_LOGIN message:K_ALERT_PASSWORD_LENGTH okButtonBlock:^(UIAlertAction *action){
                [[_myTableView viewWithTag:11] becomeFirstResponder];
            }];
        }
        else {
            
            [self.view endEditing:YES];
            [self callWebService];
        }
    }
    
    return YES;
}


#pragma mark - UIButton methods -


- (void)leftBarButtonTapEvent {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)rightBarButtonTapEvent {
    
    if (_myUserNameString.length == 0) {
        
        [HELPER showAlertView:self title:SCREEN_TITLE_LOGIN message:K_ALERT_EMAIL okButtonBlock:^(UIAlertAction *action) {
            
            [[_myTableView viewWithTag:10] becomeFirstResponder];
        }];
    }
    else if ([HELPER isText:_myUserNameString] && ![_myUserNameString isValidEmail]) {
        
        [HELPER showAlertView:self title:SCREEN_TITLE_LOGIN message:K_ALERT_EMAIL_NOT_VALID okButtonBlock:^(UIAlertAction *action) {
            [[_myTableView viewWithTag:10] becomeFirstResponder];
        }];
    }
    else if (![HELPER isText:_myUserNameString] && _myUserNameString.length < 10) {
        
        [HELPER showAlertView:self title:SCREEN_TITLE_LOGIN message:K_ALERT_VALIDATE_MOBILE_NO okButtonBlock:^(UIAlertAction *action) {
            [[_myTableView viewWithTag:10] becomeFirstResponder];
        }];
    }
    else if (_myPasswordString.length == 0) {
        
        [HELPER showAlertView:self title:SCREEN_TITLE_LOGIN message:K_ALERT_PASSWORD okButtonBlock:^(UIAlertAction *action) {
            
            [[_myTableView viewWithTag:11] becomeFirstResponder];
        }];
    }
    else if (_myPasswordString.length < 6) {
        
        [HELPER showAlertView:self title:SCREEN_TITLE_LOGIN message:K_ALERT_PASSWORD_LENGTH okButtonBlock:^(UIAlertAction *action){
            [[_myTableView viewWithTag:11] becomeFirstResponder];
        }];
    }
    else {
        
        [self.view endEditing:YES];
        [self callWebService];
    }
}

- (IBAction)forgotPasswordButtonTapped:(id)sender {
    
    LUForgotPasswordViewController *aViewController = [STORY_BOARD instantiateViewControllerWithIdentifier:@"LUForgotPasswordViewController"];
    
    [self.navigationController pushViewController:aViewController animated:YES];
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
    label.text = TITLE_LOGIN;
    [label sizeToFit];
    
    self.navigationItem.leftBarButtonItem  = [[UIBarButtonItem alloc]initWithTitle:CANCEL style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonTapEvent)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:NEXT style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonTapEvent)];
}

- (void)countryController:(id)sender didSelectCountry:(EMCCountry *)chosenCity
{
    myCountryNameString = chosenCity.countryName;
    
    CountryListDataSource *dataSource = [[CountryListDataSource alloc] init];
    NSArray *aCountryListArray = [dataSource countries];
    
    for (int i = 0; i < aCountryListArray.count; i++) {
        
        if ([myCountryNameString isEqualToString:aCountryListArray[i][kCountryName]]) {
            
            NSString *imagePath = [NSString stringWithFormat:@"EMCCountryPickerController.bundle/%@", myCountryCodeString];
            UIImage *image = [UIImage imageNamed:imagePath inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil];
            myCountryFlag = [image fitInSize:CGSizeMake(35,35)];
            myCountryCodeString = aCountryListArray[i][kCountryCallingCode]; //[aCountryListArray[i][kCountryCallingCode] componentsSeparatedByString:@" "][0];
            
            NSMutableArray *aMutableArray = [NSMutableArray new];
            NSMutableDictionary *aMDict = [NSMutableDictionary new];
            aMDict[kCountryflag] = myCountryFlag;
            aMDict[kCountryCode] = myCountryCodeString;
            aMDict[kCountryName] = myCountryNameString;
            
            [aMutableArray addObject:aMDict];
            [SESSION setCurrentCountryDetails:aMutableArray];
            
            [_myTableView reloadDataWithAnimation];
        }
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

// Hide Keyboard
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
}

-(void)callWebService {
    
    if (![HTTPMANAGER isNetworkRechable]) {
        
        NSMutableDictionary *aDictAlert = [NSMutableDictionary new];
        
        aDictAlert[KEY_ALERT_TITLE]  = SCREEN_TITLE_LOGIN;
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
     http://192.168.0.48/PPTCustomer/API/Login/ValidateLogin?StrJson={
     "Login_Info": {
     "User_Name": "sivakumar.r@angleritech.com",
     "Password": "Siva",
     "Gcm_Reg_Id": "dfgdfgdfg",
     "IMEI_No": "fgfgfg",
     "Device_Type": "A",
     "Version_Number": "1.0.0"
     }
     }*/
    NSMutableDictionary *aMutableDict = [NSMutableDictionary new];
    NSMutableDictionary *aLoginMutableDict = [NSMutableDictionary new];
    NSMutableDictionary *aParameterMutableDict = [NSMutableDictionary new];
    
    aMutableDict[@"User_Name"] = _myUserNameString;
    aMutableDict[@"Password"] = _myPasswordString;
    aMutableDict[@"Gcm_Reg_Id"] = [SESSION getDeviceToken];
    aMutableDict[@"IMEI_No"] = [SESSION getDeviceToken];
    aMutableDict[@"Device_Type"] = @"I";
    aMutableDict[@"Version_Number"] = [HELPER getAppVersion];
    aMutableDict[@"Country_Code"] = @"";
    
    aLoginMutableDict[@"Login_Info"] = aMutableDict;
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:aLoginMutableDict options:NSJSONWritingPrettyPrinted error:&error];;
    NSString *string = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    aParameterMutableDict[@"StrJson"] = string;
    
    [HELPER showLoadingIn:self];
    
    [HTTPMANAGER getLoginDetails:aParameterMutableDict completedBlock:^(NSDictionary *response) {
        
        if ([response[kRESPONSE][kRESPONSE_CODE] intValue] == kSUCCESS_CODE) {
            
            NSMutableArray *aMutableArray = [NSMutableArray new];
            NSMutableDictionary *aMutableDict = [NSMutableDictionary new];
            
            aMutableDict = [response valueForKey:@"User_Info"];
            
            [aMutableArray addObject:aMutableDict];
            [SESSION setUserInfo:aMutableArray];
            
            NSMutableArray *aChatMutableArray = [NSMutableArray new];
            NSMutableArray *aChatMArray = [NSMutableArray new];
            
            [SESSION_2 isRequested:([[aMutableArray[0] valueForKey:@"Is_Requested"] isEqualToString:@"1"]) ? YES : NO];
            
            aChatMArray = [aMutableArray valueForKey:@"Card_Info"];
            aChatMArray = aChatMArray[0];
            
            for (int i = 0; i < aChatMArray.count; i++) {
                
                NSMutableDictionary *aChatMutableDict = [NSMutableDictionary new];
                
                aChatMutableDict[@"Credit_Card_Number"] = [aChatMArray[i] valueForKey:@"Credit_Card_Number"];
                aChatMutableDict[@"CVN"] = [aChatMArray[i] valueForKey:@"CVN"];
                aChatMutableDict[@"Expiry_Date"] = [aChatMArray[i] valueForKey:@"Expiry_Date"];
                aChatMutableDict[@"Card_Holder_Name"] = [aChatMArray[i] valueForKey:@"Card_Holder_Name"];
                
                if (![aChatMutableDict[@"Credit_Card_Number"] isEqualToString:@""]) {
                    
                    [aChatMutableArray addObject:aChatMutableDict];
                }
            }
            
            [SESSION setCardInfo:aChatMArray];
            [SESSION hasLoggedIn:YES];
            [HELPER navigateToMenuDetailScreen];
        }
        else if ([response[kRESPONSE][kRESPONSE_CODE] intValue] == -11) {
            
            [HELPER showAlertViewWithCancel:self title:[NSString stringWithFormat:@"%@\n%@",@"The username is not registered yet." ,@"Do you want to register?"] okButtonBlock:^(UIAlertAction *action) {
                
                LUSignUpViewController *aViewController = [STORY_BOARD instantiateViewControllerWithIdentifier:@"LUSignUpViewController"];
                aViewController.gEmailString = _myUserNameString;
                [self.navigationController pushViewController:aViewController animated:YES];
                
            } cancelButtonBlock:^(UIAlertAction *action) {
                
            }];
            
        }
        else if([response[kRESPONSE][kRESPONSE_CODE] intValue] == K_NO_DATA_CODE) {
            
            [HELPER showNotificationSuccessIn:self withMessage:response[kRESPONSE][kRESPONSE_MESSAGE]];
            _myPasswordString = @"";
            UITextField *aTextfield = (UITextField *)[_myTableView viewWithTag:11];
            aTextfield.text = _myPasswordString;
            [aTextfield becomeFirstResponder];
        }
        
        else {
            
            [HELPER showNotificationSuccessIn:self withMessage:MESSAGE_SOMETHING_WENT_WRONG];
            
            _myPasswordString = @"";
            UITextField *aTextfield = (UITextField *)[_myTableView viewWithTag:11];
            aTextfield.text = _myPasswordString;
            [aTextfield becomeFirstResponder];
            
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
