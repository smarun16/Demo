//
//  LUSignUpViewController.m
//  Levare User
//
//  Created by AngMac137 on 11/17/16.
//  Copyright © 2016 AngMac137. All rights reserved.
//

#import "LUSignUpViewController.h"
#import "LUProfileViewController.h"


@interface LUSignUpViewController ()< UITextFieldDelegate>
{
    NSString *myCountryNameString;
    NSString *myCountryCodeString;
    NSString *myCountryCode;
    UIImage *myCountryFlag;
    BOOL isSubmitButtonTapped;
    BOOL isEmailPresent;
    BOOL isMobilePresent;
}
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) IBOutlet UIView *myAlertView;
@property (strong, nonatomic) IBOutlet UILabel *myAlertTopLabel;
@property (strong, nonatomic) IBOutlet UILabel *myAlertBottomLabel;
@property (strong, nonatomic) IBOutlet UILabel *myBottomPwdLabel;

@property (strong, nonatomic) IBOutlet UILabel *mySeperateLabel;
@property (strong, nonatomic) IBOutlet UILabel *myBottomSeperateLabel;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *myAlertBottomConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *myAlertBottomPwdLabelConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *myAlertTopLabelConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *myAlertCenterLabelConstraint;

//Model
@property (strong, nonatomic) NSString *myEmailString, *myPasswordString, *myMobileNoString;


@end

@implementation LUSignUpViewController

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
    _myEmailString = _gEmailString;
    
    _myAlertView.hidden = YES;
    [HELPER roundCornerForView:_myAlertView radius:5 borderColor:[UIColor blackColor]];
}

- (void)loadModel {
    
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    NSString *countryCode = [[NSLocale currentLocale] objectForKey: NSLocaleCountryCode];
    NSString *country = [usLocale displayNameForKey: NSLocaleCountryCode value: countryCode];
    
    [self getCountryCodeDetailsFromCountyr:country];
}



#pragma mark - UITable view Delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellIdentifier =@"RegisterCell";
    
    UITableViewCell *aCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (aCell == nil) {
        
        aCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    UIButton *gFlagButton = (UIButton *)[aCell viewWithTag:15];
    UIImageView *gImageView = (UIImageView *)[aCell viewWithTag:1];
    UITextField *gTextfield = (UITextField *)[aCell viewWithTag:2];
    UIImageView *gFlagImageView = (UIImageView *)[aCell viewWithTag:3];
    UIImageView *gAlertImageView = (UIImageView *)[aCell viewWithTag:4];
    gAlertImageView.image = [UIImage imageNamed:IMAGE_RED_ALERT];
    gAlertImageView.hidden = YES;
    
    gTextfield.delegate = self;
    
    gFlagImageView.image = myCountryFlag;
    
    NSArray *constraints = [gFlagImageView constraints];
    int index = 0;
    BOOL found = NO;
    
    while (!found && index < [constraints count]) {
        
        NSLayoutConstraint *constraint = constraints[index];
        if ( [constraint.identifier isEqualToString:@"flag_width"] ) {
            
            if (indexPath.row == 1)
                constraint.constant = 30;
            else
                constraint.constant = 0;
            
            found = YES;
        }
        index++;
    }
    
    
    if (indexPath.row == 0) {
        
        if (isSubmitButtonTapped) {
            
            if (_myEmailString.length == 0 || ![_myEmailString isValidEmail])
                gAlertImageView.hidden = NO;
            else
                gAlertImageView.hidden = YES;
        }
        else {
            
            if (isEmailPresent)
                gAlertImageView.hidden = NO;
            else
                gAlertImageView.hidden = YES;
            
        }
        
        gImageView.image = [[UIImage imageNamed:@"icon_email"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        gImageView.tintColor = [UIColor lightGrayColor];
        gTextfield.text = _myEmailString;
        gTextfield.tag = 10;
        gTextfield.placeholder = @"Email Id";
        gTextfield.secureTextEntry = NO;
        gTextfield.keyboardType = UIKeyboardTypeEmailAddress;
        gTextfield.returnKeyType = UIReturnKeyNext;
        gFlagButton.userInteractionEnabled = NO;
        
    }
    else if (indexPath.row == 1) {
        
        if (isSubmitButtonTapped) {
            
            if (_myMobileNoString.length == 0 || (_myMobileNoString.length < 5 && _myMobileNoString.length > 10) )                 gAlertImageView.hidden = NO;
            else
                gAlertImageView.hidden = YES;
        }
        else {
            
            if (isMobilePresent)
                gAlertImageView.hidden = NO;
            else
                gAlertImageView.hidden = YES;
            
        }
        gImageView.image = [[UIImage imageNamed:@"icon_mobile"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        gImageView.tintColor = [UIColor lightGrayColor];
        gTextfield.text = _myMobileNoString;
        gTextfield.tag = 11;
        gTextfield.placeholder = @"Mobile Number";
        gTextfield.secureTextEntry = NO;
        gTextfield.keyboardType = UIKeyboardTypePhonePad;
        gTextfield.returnKeyType = UIReturnKeyNext;
        
        gFlagButton.userInteractionEnabled = YES;
        [gFlagButton addTarget:self action:@selector(flagButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    else {
        
        if (isSubmitButtonTapped) {
            
            if (_myPasswordString.length == 0 || _myPasswordString.length < 6 )
                gAlertImageView.hidden = NO;
            else
                gAlertImageView.hidden = YES;
        }
        
        gImageView.image = [[UIImage imageNamed:@"icon_password"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        gImageView.tintColor = [UIColor lightGrayColor];
        gTextfield.text = _myPasswordString;
        gTextfield.tag = 12;
        gTextfield.placeholder = @"Password";
        gTextfield.secureTextEntry = YES;
        gTextfield.keyboardType = UIKeyboardTypeDefault;
        gTextfield.returnKeyType = UIReturnKeyDone;        gFlagButton.userInteractionEnabled = NO;
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
    
    NSString *aUpdateString=[textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (textField.tag == 10) {
        
        if ([aUpdateString isEqualToString:@" "])
            return NO;
        
        _myEmailString = aUpdateString;
    }
    else if (textField.tag == 11) {
        
        if (aUpdateString.length > 10)
            return NO;
        
        _myMobileNoString = aUpdateString;
    }
    else if (textField.tag == 12) {

            _myPasswordString = aUpdateString;
    }
    
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    _myAlertView.hidden = YES;
    // UIImageView *aImageView =  (UIImageView *)[_myTableView viewWithTag:4];
    // aImageView.hidden = YES;
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField.returnKeyType == UIReturnKeyNext) {
        
        [[self.myTableView viewWithTag:textField.tag + 1] becomeFirstResponder];
    }
    else {
        
        [self.view endEditing:YES];
        if (_myPasswordString.length > 5)
            [self callWebService];
    }
    
    return YES;
}

#pragma mark - UIButton methods -

-(void)flagButtonTapped:(id)sender {
    
    [self flagButtonTabAction];
}

- (void)leftBarButtonTapEvent {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)rightBarButtonTapEvent {
    
    [self.view endEditing:YES];
    isSubmitButtonTapped = YES;
    isMobilePresent = NO;
    isEmailPresent = NO;
    
    if (_myEmailString.length == 0 && _myMobileNoString.length == 0 && _myPasswordString.length == 0) {
        
        _myAlertView.hidden = NO;
        
        // Using IBOutletCollection the lable values are set all the lable are set to the IBOutletCollection & taken as array
        for (int i = 0; i < _myAlertLableArray.count; i++) {
            
            UILabel *aLable = CAST_OBJECT(_myAlertLableArray[i], UILabel);
            
            if (i == 0)
                aLable.text = K_ALERT_EMAIL;
            else if (i == 1)
                aLable.text = K_ALERT_MOBILE_NO;
            else if (i == 2)
                aLable.text = K_ALERT_PASSWORD;
        }
        
        _myBottomSeperateLabel.hidden = NO;
        _mySeperateLabel.hidden = NO;
        _myAlertBottomConstraint.constant = 25;
        _myAlertBottomPwdLabelConstraint.constant = 25;
    }
    
    else if ((![_myEmailString isValidEmail]) && _myMobileNoString.length == 0 && _myPasswordString.length == 0) {
        
        _myAlertView.hidden = NO;
        
        // Using IBOutletCollection the lable values are set all the lable are set to the IBOutletCollection & taken as array
        for (int i = 0; i < _myAlertLableArray.count; i++) {
            
            UILabel *aLable = CAST_OBJECT(_myAlertLableArray[i], UILabel);
            
            if (i == 0)
                aLable.text = K_ALERT_EMAIL_NOT_VALID;
            else if (i == 1)
                aLable.text = K_ALERT_MOBILE_NO;
            else if (i == 2)
                aLable.text = K_ALERT_PASSWORD;
        }
        _myBottomSeperateLabel.hidden = NO;
        _mySeperateLabel.hidden = NO;
        _myAlertBottomConstraint.constant = 25;
        _myAlertBottomPwdLabelConstraint.constant = 25;
    }
    
    else if (_myMobileNoString.length == 0 && _myPasswordString.length == 0) {
        
        _myAlertView.hidden = NO;
        
        // Using IBOutletCollection the lable values are set all the lable are set to the IBOutletCollection & taken as array
        for (int i = 0; i < _myAlertLableArray.count; i++) {
            
            UILabel *aLable = CAST_OBJECT(_myAlertLableArray[i], UILabel);
            
            if (i == 0)
                aLable.text = K_ALERT_MOBILE_NO;
            else if (i == 1)
                aLable.text = K_ALERT_PASSWORD;
            else if (i == 2) {
                aLable.text = @"";
            }
        }
        _myBottomSeperateLabel.hidden = YES;
        _mySeperateLabel.hidden = NO;
        _myAlertBottomConstraint.constant = 25;
        _myAlertBottomPwdLabelConstraint.constant = 0;
        _myAlertCenterLabelConstraint.constant = -8;
    }
    
    else if (_myMobileNoString.length > 10 && _myMobileNoString.length < 5 && _myPasswordString.length == 0) {
        
        _myAlertView.hidden = NO;
        
        // Using IBOutletCollection the lable values are set all the lable are set to the IBOutletCollection & taken as array
        for (int i = 0; i < _myAlertLableArray.count; i++) {
            
            UILabel *aLable = CAST_OBJECT(_myAlertLableArray[i], UILabel);
            
            if (i == 0)
                aLable.text = K_ALERT_VALIDATE_MOBILE_NO;
            else if (i == 1)
                aLable.text = K_ALERT_PASSWORD;
            else if (i == 2) {
                aLable.text = @"";
            }
        }
        _myBottomSeperateLabel.hidden = YES;
        _mySeperateLabel.hidden = NO;
        _myAlertBottomConstraint.constant = 25;
        _myAlertBottomPwdLabelConstraint.constant = 0;
        _myAlertCenterLabelConstraint.constant = -8;
    }
    
    else if (_myPasswordString.length == 0) {
        
        _myAlertView.hidden = NO;
        
        // Using IBOutletCollection the lable values are set all the lable are set to the IBOutletCollection & taken as array
        for (int i = 0; i < _myAlertLableArray.count; i++) {
            
            UILabel *aLable = CAST_OBJECT(_myAlertLableArray[i], UILabel);
            
            if (i == 0)
                aLable.text = K_ALERT_PASSWORD;
            else if (i == 1)
                aLable.text = @"";
            else if (i == 2) {
                aLable.text = @"";
            }
        }
        _myBottomSeperateLabel.hidden = YES;
        _mySeperateLabel.hidden = YES;
        _myAlertBottomConstraint.constant = 0;
        _myAlertBottomPwdLabelConstraint.constant = 0;
        _myAlertTopLabelConstraint.constant = -12;
    }
    else if (_myPasswordString.length < 6) {
        
        _myAlertView.hidden = NO;
        // Using IBOutletCollection the lable values are set all the lable are set to the IBOutletCollection & taken as array
        for (int i = 0; i < _myAlertLableArray.count; i++) {
            
            UILabel *aLable = CAST_OBJECT(_myAlertLableArray[i], UILabel);
            
            if (i == 0)
                aLable.text = K_ALERT_PASSWORD_LENGTH;
            else if (i == 1)
                aLable.text = @"";
            else if (i == 2) {
                aLable.text = @"";
            }
        }
        _myBottomSeperateLabel.hidden = YES;
        _mySeperateLabel.hidden = YES;
        _myAlertBottomConstraint.constant = 0;
        _myAlertBottomPwdLabelConstraint.constant = 0;
        _myAlertTopLabelConstraint.constant = -12;
    }
    else {
        
        if (_myEmailString.length == 0) {
            
            _myAlertView.hidden = NO;
            
            // Using IBOutletCollection the lable values are set all the lable are set to the IBOutletCollection & taken as array
            for (int i = 0; i < _myAlertLableArray.count; i++) {
                
                UILabel *aLable = CAST_OBJECT(_myAlertLableArray[i], UILabel);
                
                if (i == 0)
                    aLable.text = K_ALERT_EMAIL;
                else if (i == 1)
                    aLable.text = @"";
                else if (i == 2) {
                    aLable.text = @"";
                }
            }
            _myBottomSeperateLabel.hidden = YES;
            _mySeperateLabel.hidden = YES;
            _myAlertBottomConstraint.constant = 0;
            _myAlertBottomPwdLabelConstraint.constant = 0;
            _myAlertTopLabelConstraint.constant = -12;
        }
        else if (![_myEmailString isValidEmail]) {
            
            _myAlertView.hidden = NO;
            
            // Using IBOutletCollection the lable values are set all the lable are set to the IBOutletCollection & taken as array
            for (int i = 0; i < _myAlertLableArray.count; i++) {
                
                UILabel *aLable = CAST_OBJECT(_myAlertLableArray[i], UILabel);
                
                if (i == 0)
                    aLable.text = K_ALERT_EMAIL_NOT_VALID;
                else if (i == 1)
                    aLable.text = @"";
                else if (i == 2) {
                    aLable.text = @"";
                }
            }
            _myBottomSeperateLabel.hidden = YES;
            _mySeperateLabel.hidden = YES;
            _myAlertBottomConstraint.constant = 0;
            _myAlertBottomPwdLabelConstraint.constant = 0;
            _myAlertTopLabelConstraint.constant = -12;
        }
        else if (_myMobileNoString.length == 0) {
            
            _myAlertView.hidden = NO;
            
            // Using IBOutletCollection the lable values are set all the lable are set to the IBOutletCollection & taken as array
            for (int i = 0; i < _myAlertLableArray.count; i++) {
                
                UILabel *aLable = CAST_OBJECT(_myAlertLableArray[i], UILabel);
                
                if (i == 0)
                    aLable.text = K_ALERT_MOBILE_NO;
                else if (i == 1)
                    aLable.text = @"";
                else if (i == 2) {
                    aLable.text = @"";
                }
            }
            _myBottomSeperateLabel.hidden = YES;
            _mySeperateLabel.hidden = YES;
            _myAlertBottomConstraint.constant = 0;
            _myAlertBottomPwdLabelConstraint.constant = 0;
            _myAlertTopLabelConstraint.constant = -12;
        }
        else if (_myMobileNoString.length > 10 && _myMobileNoString.length < 5) {
            
            _myAlertView.hidden = NO;
            // Using IBOutletCollection the lable values are set all the lable are set to the IBOutletCollection & taken as array
            for (int i = 0; i < _myAlertLableArray.count; i++) {
                
                UILabel *aLable = CAST_OBJECT(_myAlertLableArray[i], UILabel);
                
                if (i == 0)
                    aLable.text = K_ALERT_VALIDATE_MOBILE_NO;
                else if (i == 1)
                    aLable.text = @"";
                else if (i == 2) {
                    aLable.text = @"";
                }
            }
            _myBottomSeperateLabel.hidden = YES;
            _mySeperateLabel.hidden = YES;
            _myAlertBottomConstraint.constant = 0;
            _myAlertBottomPwdLabelConstraint.constant = 0;
            _myAlertTopLabelConstraint.constant = -12;
        }
        else {
            
            [self.view endEditing:YES];
            [self callWebService];
        }
    }
    [self.myTableView reloadDataWithAnimation];
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
    label.text = TITLE_SIGNUP;
    [label sizeToFit];
    
    self.navigationItem.leftBarButtonItem  = [[UIBarButtonItem alloc]initWithTitle:CANCEL style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonTapEvent)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:NEXT style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonTapEvent)];
}

-(void)flagButtonTabAction {
    
    EMCCountryPickerController *aViewController = [STORY_BOARD instantiateViewControllerWithIdentifier:@"EMCCountryPickerController"];
    // default values
    aViewController.showFlags = true;
    aViewController.countryDelegate = self;
    aViewController.drawFlagBorder = true;
    aViewController.flagBorderColor = [UIColor grayColor];
    aViewController.flagBorderWidth = 0.5f;
    aViewController.flagSize = 20;
    
    UINavigationController *aNavigationController = [[UINavigationController alloc] initWithRootViewController:aViewController];
    [self.navigationController presentViewController:aNavigationController animated:YES completion:nil];
}

- (void)countryController:(id)sender didSelectCountry:(EMCCountry *)chosenCity {
    
    [self getCountryCodeDetailsFromCountyr:chosenCity.countryCode];
    [_myTableView reloadDataWithAnimation];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)getCountryCodeDetailsFromCountyr:(NSString *)aCountryName {
    
    myCountryNameString = aCountryName;
    
    CountryListDataSource *dataSource = [[CountryListDataSource alloc] init];
    NSArray *aCountryListArray = [dataSource countries];
    
    for (int i = 0; i < aCountryListArray.count; i++) {
        
        if ([myCountryNameString isEqualToString:aCountryListArray[i][kCountryCode]]) {
            
            NSString *imagePath = [NSString stringWithFormat:@"EMCCountryPickerController.bundle/%@", aCountryListArray[i][kCountryCode]];
            UIImage *image = [UIImage imageNamed:imagePath inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil];
            myCountryFlag = [image fitInSize:CGSizeMake(30,15)];
            myCountryCodeString = aCountryListArray[i][kCountryCallingCode]; //[aCountryListArray[i][kCountryCallingCode] componentsSeparatedByString:@" "][0];
            myCountryCode = aCountryListArray[i][kCountryCode];
            
            NSMutableArray *aMutableArray = [NSMutableArray new];
            NSMutableDictionary *aMDict = [NSMutableDictionary new];
            aMDict[kCountryflag] = myCountryFlag;
            aMDict[kCountryCode] = myCountryCode;
            aMDict[kCountryCallingCode] = myCountryCodeString;
            aMDict[kCountryName] = myCountryNameString;
            
            [aMutableArray addObject:aMDict];
            [SESSION setCurrentCountryDetails:aMutableArray];
            
            [_myTableView reloadDataWithAnimation];
        }
    }
    
    if ([SESSION getCurrentCountryDetails].count) {
        
        myCountryFlag = [SESSION getCurrentCountryDetails][0][kCountryflag];
        myCountryNameString = [SESSION getCurrentCountryDetails][0][kCountryName];
        myCountryCodeString = [SESSION getCurrentCountryDetails][0][kCountryCallingCode];
        myCountryCode = [SESSION getCurrentCountryDetails][0][kCountryCode];
    }
    else {
        
        [self flagButtonTabAction];
    }

}

// Hide Keyboard
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

-(void)callWebService {
    
    if (![HTTPMANAGER isNetworkRechable]) {
        
        NSMutableDictionary *aDictAlert = [NSMutableDictionary new];
        
        aDictAlert[KEY_ALERT_TITLE]  = SCREEN_TITLE_SIGNUP;
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
     //  http://192.168.0.48/PPTCustomer/API/Register/ValidateMobileNo?StrJson={"Registration_Info":{"Mobile_Number":"%2B919677892277","Email_Id":"sivakuma@angleritech.com"," Customer_Id ":""}}
     */
    NSMutableDictionary *aMutableDict = [NSMutableDictionary new];
    NSMutableDictionary *aLoginMutableDict = [NSMutableDictionary new];
    NSMutableDictionary *aParameterMutableDict = [NSMutableDictionary new];
    
    aMutableDict[@"Email_Id"] = _myEmailString;
    aMutableDict[@"Mobile_Number"] = [NSString stringWithFormat:@"%@",_myMobileNoString];
    aMutableDict[@"Customer_Id"] = @"";
    aMutableDict[K_COUNTRY_CODE] = [myCountryCodeString substringFromIndex:1];
    
    aLoginMutableDict[@"Registration_Info"] = aMutableDict;
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:aLoginMutableDict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *string = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    aParameterMutableDict[@"StrJson"] = string;
    
    [HELPER showLoadingIn:self];
    
    [HTTPMANAGER getRegisterDetails:aParameterMutableDict completedBlock:^(NSDictionary *response) {
        
        if ([response[kRESPONSE][kRESPONSE_CODE] intValue] == kSUCCESS_CODE) {
            
            aMutableDict[K_PASSWORD] = _myPasswordString;
            aMutableDict[K_COUNTRY] = myCountryCode;
            
            LUProfileViewController *aViewController = [STORY_BOARD instantiateViewControllerWithIdentifier:@"LUProfileViewController"];
            aViewController.gCustomerMutableDict = aMutableDict;
            [self.navigationController pushViewController:aViewController animated:YES];
        }
        else if ([response[kRESPONSE][kRESPONSE_CODE] intValue] == K_NO_DATA_CODE) {
            
            _myAlertView.hidden = NO;
            _myAlertTopLabel.text = response[kRESPONSE][kRESPONSE_MESSAGE];
            _myBottomSeperateLabel.hidden = YES;
            _mySeperateLabel.hidden = YES;
            _myAlertBottomConstraint.constant = 0;
            _myAlertBottomPwdLabelConstraint.constant = 0;
            _myAlertTopLabelConstraint.constant = -12;
            
            if ([response[kRESPONSE][kRESPONSE_MESSAGE] containsString:@"Email"])
                isEmailPresent = YES;
            else
                isMobilePresent = YES;
        }
        else if ([response[kRESPONSE][kRESPONSE_CODE] intValue] == -3) {
            
            _myAlertView.hidden = NO;
            _mySeperateLabel.hidden = NO;
            _myAlertTopLabel.text = @"Email Id is already registered.";
            _myAlertBottomLabel.text = @"Mobile number is already registered.";
            _myAlertBottomConstraint.constant = 25;
            _myAlertBottomPwdLabelConstraint.constant = 0;
            _myAlertCenterLabelConstraint.constant = 0;
            isMobilePresent = YES;
            isEmailPresent = YES;
        }
        else {
            
            _myAlertView.hidden = YES;
            _myAlertBottomConstraint.constant = 0;
            [HELPER showNotificationSuccessIn:self withMessage:response[kRESPONSE][kRESPONSE_MESSAGE]];
        }
        
        isSubmitButtonTapped = NO;
        [_myTableView reloadDataWithAnimation];
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
