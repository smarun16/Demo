//
//  LUMenuProfileViewController.m
//  Levare User
//
//  Created by AngMac137 on 11/19/16.
//  Copyright © 2016 AngMac137. All rights reserved.
//

#import "LUMenuProfileViewController.h"
#import "LUOTPViewController.h"

@interface LUMenuProfileViewController ()< UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    NSMutableDictionary *myCustomerMutableDictionary;
    NSString *myCountryNameString;
    NSString *myCountryCodeString;
    NSString *myCountryCode;
    UIImage *myCountryFlag;
    BOOL isSubmitButtonTapped;
    BOOL isEmailChanged, isPhoneChanged, isFlagChanged;
}
@property (strong, nonatomic) IBOutlet UIView *myBgView;
@property (strong, nonatomic) IBOutlet UIImageView *myProfileImageView;
@property (strong, nonatomic) IBOutlet UITextField *myFirstNameTextfield;
@property (strong, nonatomic) IBOutlet UITextField *myLastNameTextfield;
@property (strong, nonatomic) IBOutlet UIImageView *myFirstImageVIew;
@property (strong, nonatomic) IBOutlet UIImageView *myLastImageView;
@property (strong, nonatomic) IBOutlet UIView *myTextfieldBgView;

@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) IBOutlet UISwitch *myTripNotifySwitch;
@property (strong, nonatomic) IBOutlet UISwitch *myPushNotifySwitch;

//Model
@property (strong, nonatomic) NSString *myFirstNameString, *myLastNameString, *myProfileImageString;
@property (strong, nonatomic) NSString *myEmailString, *myMobileNoString;

@end

@implementation LUMenuProfileViewController

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
    
    _myProfileImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *aGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseImage)];
    aGesture.numberOfTapsRequired = 1;
    aGesture.numberOfTouchesRequired = 1;
    [_myProfileImageView addGestureRecognizer:aGesture];
}

#pragma mark -Model

- (void)setupModel {
    
    [HELPER roundCornerForView:_myProfileImageView radius:2 borderColor:COLOR_BLACK];
    [HELPER roundCornerForView:_myTextfieldBgView radius:2 borderColor:COLOR_BLACK];
    [HELPER roundCornerForView:_myTableView radius:2 borderColor:COLOR_BLACK];
    
    [HELPER setURLProfileImageForImageView:_myProfileImageView URL:[SESSION getUserInfo][0][@"Image"] placeHolderImage:@"icon_no_profile_big.png"];
    _myProfileImageView.backgroundColor = WHITE_COLOUR;
    
    _myFirstImageVIew.image = [[UIImage imageNamed:@"icon_user"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    _myFirstImageVIew.tintColor = [UIColor lightGrayColor];
    
    _myLastImageView.image = [[UIImage imageNamed:@"icon_user"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    _myLastImageView.tintColor = [UIColor lightGrayColor];
    
    isPhoneChanged = isEmailChanged = NO;
    
    _myFirstNameTextfield.tag = 10;
    _myLastNameTextfield.tag = 20;
    _myFirstNameTextfield.delegate = self;
    _myLastNameTextfield.delegate = self;
    
    _myFirstNameTextfield.text = [SESSION getUserInfo][0][@"First_Name"];
    _myLastNameTextfield.text = [SESSION getUserInfo][0][@"Last_Name"];
    _myEmailString =  [SESSION getUserInfo][0][@"Email_Id"];
    _myMobileNoString =  [SESSION getUserInfo][0][@"Mobile_Number"];
    myCountryCode =  [SESSION getUserInfo][0][@"Country"];
}

- (void)loadModel {
    
    myCustomerMutableDictionary = [NSMutableDictionary new];
    [self getCountryCodeDetailsFromCountry:myCountryCode];
    
    ([[SESSION getUserInfo][0][@"Trip_Notification"] isEqualToString:@"0"]) ? [_myTripNotifySwitch setOn:NO] : [_myTripNotifySwitch setOn:YES];
    ([[SESSION getUserInfo][0][@"Is_Notification_Enable"] isEqualToString:@"0"]) ? [_myPushNotifySwitch setOn:NO] : [_myPushNotifySwitch setOn:YES];
}


#pragma mark - UITable view Delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 2;
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
        
        gImageView.image = [[UIImage imageNamed:@"icon_email"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        gImageView.tintColor = [UIColor lightGrayColor];
        gTextfield.text = _myEmailString;
        gTextfield.tag = 100;
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
        
        gImageView.image = [[UIImage imageNamed:@"icon_mobile"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        gImageView.tintColor = [UIColor lightGrayColor];
        gTextfield.text = _myMobileNoString;
        gTextfield.tag = 101;
        gTextfield.placeholder = @"Mobile Number";
        gTextfield.secureTextEntry = NO;
        gTextfield.keyboardType = UIKeyboardTypePhonePad;
        gTextfield.returnKeyType = UIReturnKeyNext;
        
        gFlagButton.userInteractionEnabled = YES;
        [gFlagButton addTarget:self action:@selector(flagButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        
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
    
    if (textField.tag == 100) {
        
        if ([aUpdateString isEqualToString:@" "])
            return NO;
        
        if ([aUpdateString isEqualToString:[SESSION getUserInfo][0][@"Email_Id"]]) {
            
            isEmailChanged = NO;
        }
        else
            isEmailChanged = YES;
        
        _myEmailString = aUpdateString;
    }
    else if (textField.tag == 101) {
        
        if (aUpdateString.length > 10)
            return NO;
        
        if ([aUpdateString isEqualToString:[SESSION getUserInfo][0][@"Mobile_Number"]]) {
            
            isPhoneChanged = NO;
        }
        else
            isPhoneChanged = YES;
        
        _myMobileNoString = aUpdateString;
    }
    
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField.tag == 100) {
        
        [[self.myTableView viewWithTag:textField.tag + 1] becomeFirstResponder];
    }
    else if (textField.tag == 10) {
        [_myLastNameTextfield becomeFirstResponder];
    }
    else if (textField.tag == 20) {
        [_myLastNameTextfield resignFirstResponder];
    }
    else if (textField.tag == 101) {
        
        [self.view endEditing:YES];
        [self callWebService];
    }
    
    return YES;
}

#pragma mark - UIButton methods -

- (void)leftBarButtonTapEvent {
    
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
        if ([SESSION_2 isRequested] && ![SESSION_2 isAlertShown]) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:VIEW_UPADTE_BASED_ON_REQUEST_STATUS object:nil userInfo:nil];
            
        }
    }];
}

- (void)rightBarButtonTapEvent {
    
    if ([self validateTextFields]) {
        
        if (isPhoneChanged || [SESSION isFlagChanged]) {
            
            [self callValidateMobileWebService];
        }
        else {
            
            [self.view endEditing:YES];
            [self callWebService];
        }
    }
}

- (IBAction)ChangeNoticationState:(id)sender {
    
    [self callNotifyWebService: ([sender isOn]) ? @"1" : @"0"];
}
- (IBAction)changePushNotification:(id)sender {
    
    [self callPushNotificationWebService: ([sender isOn]) ? @"1" : @"0"];
}

-(void)flagButtonTapped:(id)sender {
    
    [self flagButtonTabAction];
}
- (IBAction)logOutButtonTapped:(id)sender {
    
    if ([SESSION_2 isRequested]) {
        
        [HELPER showAlertView:self title:APP_NAME message:@"You can't log out when your request is in progress" okButtonBlock:^(UIAlertAction *action) {
            
        }];
    }
    else {
        [HELPER showAlertViewWithCancel:self title:@"Are you sure to logout?" okButtonBlock:^(UIAlertAction *action) {
            
            [self callLogoutWebService];
            
        } cancelButtonBlock:^(UIAlertAction *action) {
            
        }];
    }
}

#pragma mark - choose Image -

-(void)chooseImage {
    
    UIAlertController *alertController  = [UIAlertController alertControllerWithTitle:@"Choose Photos via"  message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alertController addAction: [UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                                 {
                                     [self imagesFromCamera];
                                 }]];
    
    [alertController addAction: [UIAlertAction actionWithTitle:@"Gallery" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                                 {
                                     [self imagesFromGallary];
                                 }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action)
                                {
                                    
                                }]];
    
    [self presentViewController:alertController animated:YES completion:^{
    }];
}

-(void) imagesFromCamera {
    
    if ([UIImagePickerController  isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIImagePickerController * aImagePicker = [[UIImagePickerController alloc] init];
        aImagePicker.sourceType=UIImagePickerControllerSourceTypeCamera;
        aImagePicker.delegate = self;
        aImagePicker.allowsEditing=YES;
        
        [self.navigationController presentViewController:aImagePicker animated:YES completion:nil];
    }
    else
        [HELPER showAlertView:self title:SCREEN_TITLE_PROFILE message:@"Camera is not found" okButtonBlock:^(UIAlertAction *action) {
            
        }];
}

-(void)imagesFromGallary {
    
    if ([UIImagePickerController  isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        
        UIImagePickerController *aGalleryImagePicker = [[UIImagePickerController alloc]init];
        aGalleryImagePicker.navigationBar.barTintColor = [HELPER getColorFromHexaDecimal:COLOR_APP_PRIMARY];
        [aGalleryImagePicker.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]} ];
        aGalleryImagePicker.navigationBar.tintColor=[UIColor whiteColor];
        aGalleryImagePicker.navigationBar.translucent = NO;
        aGalleryImagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        aGalleryImagePicker.allowsEditing = YES;
        aGalleryImagePicker.delegate = self;
        
        aGalleryImagePicker.modalPresentationStyle = UIModalPresentationOverFullScreen;
        [self.navigationController presentViewController:aGalleryImagePicker animated:YES completion:NULL];
    }
    
    else
        [HELPER showAlertView:self title:SCREEN_TITLE_PROFILE message:@"No photos in gallery" okButtonBlock:^(UIAlertAction *action) {
            
        }];
}

#pragma mark - UIImage Picker Delegate -

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)aImagePickerController {
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)aImagePickerController didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [[aImagePickerController parentViewController] dismissViewControllerAnimated:NO completion:nil];
    
    UIImage *aChosenImage = info[UIImagePickerControllerEditedImage];
    
    UINavigationController* aNavigationController = self.navigationController;
    UIViewController* aHeaderImageViewController = [aNavigationController.viewControllers objectAtIndex:0];
    [aHeaderImageViewController dismissViewControllerAnimated:NO completion:nil];
    
    
    
    if (aImagePickerController.sourceType == UIImagePickerControllerSourceTypeCamera) {
        
        ALAssetsLibrary* aAssetslibrary = [[ALAssetsLibrary alloc] init];
        // Save photo to album
        [aAssetslibrary writeImageToSavedPhotosAlbum:[aChosenImage CGImage]
                                         orientation:(ALAssetOrientation)[aChosenImage imageOrientation]
                                     completionBlock:^(NSURL *assetURL, NSError *error){
                                         if (error) {
                                             NSLog(@"Error in saving image into Album");
                                         }
                                         else {
                                             myCustomerMutableDictionary[KEY_URL] = assetURL;
                                             [self parseImageFromPicker:aChosenImage];
                                         }
                                     }];
        
    }
    else {
        myCustomerMutableDictionary[KEY_URL] = [info valueForKey:UIImagePickerControllerReferenceURL];
        [self parseImageFromPicker:aChosenImage];
    }
    
}

- (void)parseImageFromPicker:(UIImage *)aChosenImage {
    
    if (myCustomerMutableDictionary[KEY_URL]) {
        
        ALAssetsLibrary* aAssetslibrary = [[ALAssetsLibrary alloc] init];
        
        // Get chosene file Name
        ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *imageAsset)
        {
            ALAssetRepresentation *imageRep = [imageAsset defaultRepresentation];
            myCustomerMutableDictionary[K_PROFILE_IMAGE] = [imageRep filename];
        };
        
        [aAssetslibrary assetForURL:myCustomerMutableDictionary[KEY_URL] resultBlock:resultblock failureBlock:nil];
        
        myCustomerMutableDictionary[K_PROFILE_DATA] = UIImagePNGRepresentation(aChosenImage);
        self.myProfileImageView.image = aChosenImage;
        
    }
}


-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
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
    label.text = TITLE_EDIT_PROFILE;
    [label sizeToFit];
    
    self.navigationItem.leftBarButtonItem  = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(leftBarButtonTapEvent)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:SAVE style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonTapEvent)];
}

-(void)moveToOTPScreen {
    
    LUOTPViewController *aViewController = [STORY_BOARD instantiateViewControllerWithIdentifier:@"LUOTPViewController"];
    aViewController.gCustomerMutableDict = myCustomerMutableDictionary;
    UINavigationController *aNavigationController = [[UINavigationController alloc] initWithRootViewController:aViewController];
    [self.navigationController presentViewController:aNavigationController animated:YES completion:nil];
}

-(BOOL)validateTextFields {
    
    if (_myFirstNameTextfield.text.length == 0) {
        
        [HELPER showAlertView:self title:SCREEN_TITLE_PROFILE message:K_ALERT_FIRST_NAME okButtonBlock:^(UIAlertAction *action) {
            [_myFirstNameTextfield becomeFirstResponder];
        }];
        return NO;
    }
    
    else if (_myLastNameTextfield.text.length == 0) {
        
        [HELPER showAlertView:self title:SCREEN_TITLE_PROFILE message:K_ALERT_LAST_NAME okButtonBlock:^(UIAlertAction *action) {
            [_myLastNameTextfield becomeFirstResponder];
        }];
        return NO;
    }
    else if (_myEmailString.length == 0) {
        
        [HELPER showAlertView:self title:SCREEN_TITLE_PROFILE message:K_ALERT_EMAIL okButtonBlock:^(UIAlertAction *action) {
            [[_myTableView viewWithTag:1] becomeFirstResponder];
        }];
        return NO;
    }
    else if (![_myEmailString isValidEmail]) {
        
        [HELPER showAlertView:self title:SCREEN_TITLE_PROFILE message:K_ALERT_EMAIL_NOT_VALID okButtonBlock:^(UIAlertAction *action) {
            [[_myTableView viewWithTag:1] becomeFirstResponder];
        }];
        return NO;
    }
    else if (_myMobileNoString.length == 0) {
        
        [HELPER showAlertView:self title:SCREEN_TITLE_PROFILE message:K_ALERT_MOBILE_NO okButtonBlock:^(UIAlertAction *action) {
            [[_myTableView viewWithTag:2] becomeFirstResponder];
        }];
        return NO;
    }
    else if ([_myMobileNoString substringFromIndex:4].length > 10 || [_myMobileNoString  substringFromIndex:4].length < 5) {
        
        [HELPER showAlertView:self title:SCREEN_TITLE_PROFILE message:K_ALERT_VALIDATE_MOBILE_NO okButtonBlock:^(UIAlertAction *action) {
            [[_myTableView viewWithTag:2] becomeFirstResponder];
        }];
        return NO;
    }
    
    else {
        
        [self.view endEditing:YES];
        
        myCustomerMutableDictionary[K_FIRST_NAME] = _myFirstNameTextfield.text;
        myCustomerMutableDictionary[K_LAST_NAME] = _myLastNameTextfield.text;
        myCustomerMutableDictionary[@"Email_Id"] = _myEmailString;
        myCustomerMutableDictionary[K_MOBILE_NUMBER] =_myMobileNoString;
        myCustomerMutableDictionary[@"Customer_Id"] = [SESSION getUserInfo][0][@"Customer_Id"];
        myCustomerMutableDictionary[K_COUNTRY_CODE] = [myCountryCodeString substringFromIndex:1];
        myCustomerMutableDictionary[K_COUNTRY] = (myCountryCode.length == 0) ?[SESSION getUserInfo][0][@"Country"] : myCountryCode ;
        myCustomerMutableDictionary[K_PASSWORD] = [SESSION getUserInfo][0][@"Password"];
        
    }
    return YES;
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
    
    [self getCountryCodeDetailsFromCountry:chosenCity.countryCode];
    
    [self dismissViewControllerAnimated:YES completion:^{
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            if ([SESSION getCurrentCountryDetails].count) {
                
                if (![[SESSION getUserInfo][0][@"Country_Code"] isEqualToString:[SESSION getCurrentCountryDetails][0][kCountryCallingCode]]) {
                    
                    myCustomerMutableDictionary[K_FIRST_NAME] = _myFirstNameTextfield.text;
                    myCustomerMutableDictionary[K_LAST_NAME] = _myLastNameTextfield.text;
                    myCustomerMutableDictionary[@"Email_Id"] = _myEmailString;
                    myCustomerMutableDictionary[K_MOBILE_NUMBER] =_myMobileNoString;
                    myCustomerMutableDictionary[@"Customer_Id"] = [SESSION getUserInfo][0][@"Customer_Id"];
                    myCustomerMutableDictionary[K_COUNTRY_CODE] = [myCountryCodeString substringFromIndex:1];
                    myCustomerMutableDictionary[K_COUNTRY] = (myCountryCode.length == 0) ?[SESSION getUserInfo][0][@"Country"] : myCountryCode ;
                    myCustomerMutableDictionary[K_PASSWORD] = [SESSION getUserInfo][0][@"Password"];
                    
                }
                else {
                    
                }
            }
            else {
                
            }
        });
    }];
}

-(void)getCountryCodeDetailsFromCountry:(NSString *)aCountryName {
    
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
            aMDict[kCountryCallingCode] = myCountryCodeString;
            aMDict[kCountryCode] = myCountryCode;
            aMDict[kCountryName] = myCountryNameString;
            
            [aMutableArray addObject:aMDict];
            [SESSION setCurrentCountryDetails:aMutableArray];
            
            isFlagChanged = (![aMDict[kCountryCallingCode] isEqualToString:[SESSION getUserInfo][0][K_COUNTRY_CODE]]) ? YES : NO;
            [SESSION isFlagChanged: isFlagChanged];
            
            [_myTableView reloadDataWithAnimation];
        }
    }
}

// Hide Keyboard
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - Webservice -

-(void)callWebService {
    
    if (![HTTPMANAGER isNetworkRechable]) {
        
        NSMutableDictionary *aDictAlert = [NSMutableDictionary new];
        
        aDictAlert[KEY_ALERT_TITLE]  = SCREEN_TITLE_EDIT_PROFILE;
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
    
    aMutableDict[@"Email_ID"] = _myEmailString;
    aMutableDict[@"Mobile_Number"] = _myMobileNoString;
    aMutableDict[@"First_Name"] = _myFirstNameTextfield.text;
    aMutableDict[@"Last_Name"] = _myLastNameTextfield.text;
    aMutableDict[@"OTP"] = @"";
    aMutableDict[@"Password"] = [SESSION getUserInfo][0][@"Password"];
    aMutableDict[@"Gcm_Reg_Id"] = [SESSION getDeviceToken];
    aMutableDict[@"IMEI_No"] = [SESSION getDeviceToken];
    aMutableDict[@"Device_Type"] = @"I";
    aMutableDict[@"Version_Number"] = [HELPER getAppVersion];
    aMutableDict[@"Customer_Id"] = [SESSION getUserInfo][0][@"Customer_Id"];
    aMutableDict[K_COUNTRY_CODE] = [[myCountryCodeString substringFromIndex:1] stringByReplacingOccurrencesOfString:@" " withString:@""];
    aMutableDict[K_COUNTRY] = myCountryCode;
    
    aLoginMutableDict[@"Registration_Info"] = aMutableDict;
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:aLoginMutableDict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *string = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    aParameterMutableDict[@"StrJson"] = string;
    
    [self.view endEditing:YES];
    [HELPER showLoadingIn:self];
    
    [HTTPMANAGER getCustomerDetails:aParameterMutableDict path:myCustomerMutableDictionary[K_PROFILE_DATA] imageName:myCustomerMutableDictionary[K_PROFILE_IMAGE] completedBlock:^(NSDictionary *response) {
        
        if ([response[kRESPONSE][kRESPONSE_CODE] intValue] == kSUCCESS_CODE) {
            
            NSMutableArray *aMutableArray = [NSMutableArray new];
            
            [aMutableArray addObject:[response valueForKey:@"User_Info"]];
            [SESSION setUserInfo:aMutableArray];
            
            NSMutableArray *aChatMutableArray = [NSMutableArray new];
            NSMutableArray *aChatMArray = [NSMutableArray new];
            NSMutableDictionary *aChatMutableDict = [NSMutableDictionary new];
            
            [SESSION_2 isRequested:([[aMutableArray[0] valueForKey:@"Is_Requested"] isEqualToString:@"1"]) ? YES : NO];
            aChatMArray = [[aMutableArray valueForKey:@"Card_Info"] mutableCopy];
            aChatMArray = aChatMArray[0];
            
            for (int i = 0; i < aChatMArray.count; i++) {
                
                aChatMutableDict[@"Credit_Card_Number"] = [aChatMArray[i] valueForKey:@"Credit_Card_Number"];
                aChatMutableDict[@"CVN"] = [aChatMArray[i] valueForKey:@"CVN"];
                aChatMutableDict[@"Expiry_Date"] = [aChatMArray[i] valueForKey:@"Expiry_Date"];
                aChatMutableDict[@"Card_Holder_Name"] = [aChatMArray[i] valueForKey:@"Card_Holder_Name"];
                
                if (![[aChatMArray[i] valueForKey:@"Credit_Card_Number"] isEqualToString:@""]) {
                    
                    [aChatMutableArray addObject:aChatMArray[i]];
                }
            }
            
            [SESSION setCardInfo:aChatMArray];
            
            [self setupModel];
            [HELPER postMyQueryViewUpdateNotification];
            
            
            [HELPER showAlertView:self title:SCREEN_TITLE_EDIT_PROFILE message:response[kRESPONSE][kRESPONSE_MESSAGE] okButtonBlock:^(UIAlertAction *action) {
                
                
            } ];
            
        }
        else if( [response[kRESPONSE][kRESPONSE_CODE] intValue] == k_BAD_REQUEST ) {
            
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

-(void)callValidateMobileWebService {
    
    if (![HTTPMANAGER isNetworkRechable]) {
        
        NSMutableDictionary *aDictAlert = [NSMutableDictionary new];
        
        aDictAlert[KEY_ALERT_TITLE]  = SCREEN_TITLE_EDIT_PROFILE;
        aDictAlert[KEY_ALERT_DESC]  = [NSString stringWithFormat:@"%@. Tap to try again",ALERT_NO_INTERNET_DESC];
        aDictAlert[KEY_ALERT_IMAGE]  = @"icon_no_internet";
        
        // List is empty so show 'Tap to retry' view
        [HELPER showRetryAlertIn:self details:aDictAlert retryBlock:^{
            
            if ([HTTPMANAGER isNetworkRechable]) {
                
                [HELPER removeRetryAlertIn:self];
                [HELPER removeLoadingIn:self];
                [self callValidateMobileWebService];
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
    aMutableDict[@"Customer_Id"] = [SESSION getUserInfo][0][@"Customer_Id"];
    aMutableDict[K_COUNTRY_CODE] = [[myCountryCodeString substringFromIndex:1] stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    aLoginMutableDict[@"Registration_Info"] = aMutableDict;
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:aLoginMutableDict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *string = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    aParameterMutableDict[@"StrJson"] = string;
    
    [HELPER showLoadingIn:self];
    
    [HTTPMANAGER getRegisterDetails:aParameterMutableDict completedBlock:^(NSDictionary *response) {
        
        if ([response[kRESPONSE][kRESPONSE_CODE] intValue] == kSUCCESS_CODE) {
            
            [self moveToOTPScreen];
            
        }
        else if ([response[kRESPONSE][kRESPONSE_CODE] intValue] == K_NO_DATA_CODE || [response[kRESPONSE][kRESPONSE_CODE] intValue] == k_BAD_REQUEST || [response[kRESPONSE][kRESPONSE_CODE] intValue] == -3) {
            
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
                    [self callValidateMobileWebService];
                }
            }];
        else
            [HELPER showNotificationSuccessIn:self withMessage:MESSAGE_SOMETHING_WENT_WRONG];
        [HELPER removeLoadingIn:self];
    }];
    
}

-(void)callNotifyWebService:(NSString *)aStatus {
    
    if (![HTTPMANAGER isNetworkRechable]) {
        
        NSMutableDictionary *aDictAlert = [NSMutableDictionary new];
        
        aDictAlert[KEY_ALERT_TITLE]  = SCREEN_TITLE_EDIT_PROFILE;
        aDictAlert[KEY_ALERT_DESC]  = [NSString stringWithFormat:@"%@. Tap to try again",ALERT_NO_INTERNET_DESC];
        aDictAlert[KEY_ALERT_IMAGE]  = @"icon_no_internet";
        
        // List is empty so show 'Tap to retry' view
        [HELPER showRetryAlertIn:self details:aDictAlert retryBlock:^{
            
            if ([HTTPMANAGER isNetworkRechable]) {
                
                [HELPER removeRetryAlertIn:self];
                [HELPER removeLoadingIn:self];
                [self callNotifyWebService: aStatus];
            }
        }];
        
        return;
    }
    
    //  http://116.212.240.36/SuburbanAPI/API/FamilyandFriends/UpdateNotificationStatus?StrCustomerId=87&StrStatus=1
    
    NSMutableDictionary *aMutableDict = [NSMutableDictionary new];
    
    aMutableDict[@"StrCustomerId"] = [SESSION getUserInfo][0][@"Customer_Id"];
    aMutableDict[@"StrStatus"] = aStatus;
    
    [HELPER showLoadingIn:self];
    
    [HTTPMANAGER updateNotification:aMutableDict completedBlock:^(NSDictionary *response) {
        
        if ([response[kRESPONSE][kRESPONSE_CODE] intValue] == kSUCCESS_CODE) {
            
            [HELPER showNotificationSuccessIn:self withMessage:response[kRESPONSE][kRESPONSE_MESSAGE]];
            ([aStatus isEqualToString:@"0"]) ? [_myTripNotifySwitch setOn:NO] : [_myTripNotifySwitch setOn:YES];
            
            
        }
        else if ([response[kRESPONSE][kRESPONSE_CODE] intValue] == k_BAD_REQUEST) {
            
            [HELPER showNotificationSuccessIn:self withMessage:response[kRESPONSE][kRESPONSE_MESSAGE]];
        }
        else {
            
            [HELPER showNotificationSuccessIn:self withMessage:MESSAGE_SOMETHING_WENT_WRONG];
        }
        
        (![_myTripNotifySwitch isOn]) ? [_myTripNotifySwitch setOn:NO] : [_myTripNotifySwitch setOn:YES];
        [HELPER removeLoadingIn:self];
        
    } failedBlock:^(NSError *error) {
        
        (![_myTripNotifySwitch isOn]) ? [_myTripNotifySwitch setOn:NO] : [_myTripNotifySwitch setOn:YES];
        [HELPER showNotificationSuccessIn:self withMessage:MESSAGE_SOMETHING_WENT_WRONG];
        [HELPER removeLoadingIn:self];
    }];
    NSMutableDictionary *aMDict = [[SESSION getUserInfo][0] mutableCopy];
    
    if ([_myTripNotifySwitch isOn]) {
        aMDict[@"Trip_Notification"] = @"1";
    }
    else {
        
        aMDict[@"Trip_Notification"] = @"0";
    }
    
    NSMutableArray *aMarray = [NSMutableArray new];
    [aMarray addObject:[aMDict copy]];
    [SESSION setUserInfo:aMarray];
}


-(void)callPushNotificationWebService:(NSString *)aStatus {
    
    if (![HTTPMANAGER isNetworkRechable]) {
        
        NSMutableDictionary *aDictAlert = [NSMutableDictionary new];
        
        aDictAlert[KEY_ALERT_TITLE]  = SCREEN_TITLE_EDIT_PROFILE;
        aDictAlert[KEY_ALERT_DESC]  = [NSString stringWithFormat:@"%@. Tap to try again",ALERT_NO_INTERNET_DESC];
        aDictAlert[KEY_ALERT_IMAGE]  = @"icon_no_internet";
        
        // List is empty so show 'Tap to retry' view
        [HELPER showRetryAlertIn:self details:aDictAlert retryBlock:^{
            
            if ([HTTPMANAGER isNetworkRechable]) {
                
                [HELPER removeRetryAlertIn:self];
                [HELPER removeLoadingIn:self];
                [self callNotifyWebService: aStatus];
            }
        }];
        
        return;
    }
    
    // http://116.212.240.36/SuburbanAPI/API/Register/UpdateTripNotificationStatus?StrCustomerId=54&StrStatus=1
    
    NSMutableDictionary *aMutableDict = [NSMutableDictionary new];
    
    aMutableDict[@"StrCustomerId"] = [SESSION getUserInfo][0][@"Customer_Id"];
    aMutableDict[@"StrStatus"] = aStatus;
    
    [HELPER showLoadingIn:self];
    
    [HTTPMANAGER updatePushNotification:aMutableDict completedBlock:^(NSDictionary *response) {
        
        if ([response[kRESPONSE][kRESPONSE_CODE] intValue] == kSUCCESS_CODE) {
            
            [HELPER showNotificationSuccessIn:self withMessage:response[kRESPONSE][kRESPONSE_MESSAGE]];
            ([aStatus isEqualToString:@"0"]) ? [_myPushNotifySwitch setOn:NO] : [_myPushNotifySwitch setOn:YES];
        }
        else if ([response[kRESPONSE][kRESPONSE_CODE] intValue] == k_BAD_REQUEST) {
            
            [HELPER showNotificationSuccessIn:self withMessage:response[kRESPONSE][kRESPONSE_MESSAGE]];
        }
        else {
            
            [HELPER showNotificationSuccessIn:self withMessage:MESSAGE_SOMETHING_WENT_WRONG];
        }
        
        (![_myPushNotifySwitch isOn]) ? [_myPushNotifySwitch setOn:NO] : [_myPushNotifySwitch setOn:YES];
        [HELPER removeLoadingIn:self];
        
    } failedBlock:^(NSError *error) {
        
        (![_myPushNotifySwitch isOn]) ? [_myPushNotifySwitch setOn:NO] : [_myPushNotifySwitch setOn:YES];
        [HELPER showNotificationSuccessIn:self withMessage:MESSAGE_SOMETHING_WENT_WRONG];
        [HELPER removeLoadingIn:self];
    }];
    
    NSMutableDictionary *aMDict = [[SESSION getUserInfo][0] mutableCopy];
    
    if ([_myPushNotifySwitch isOn]) {
        aMDict[@"Is_Notification_Enable"] = @"1";
    }
    else {
        
        aMDict[@"Is_Notification_Enable"] = @"0";
    }
    
    NSMutableArray *aMarray = [NSMutableArray new];
    [aMarray addObject:[aMDict copy]];
    [SESSION setUserInfo:aMarray];
}


-(void)callLogoutWebService {
    
    if (![HTTPMANAGER isNetworkRechable]) {
        
        NSMutableDictionary *aDictAlert = [NSMutableDictionary new];
        
        aDictAlert[KEY_ALERT_TITLE]  = APP_NAME;
        aDictAlert[KEY_ALERT_DESC]  = [NSString stringWithFormat:@"%@. Tap to try again",ALERT_NO_INTERNET_DESC];
        aDictAlert[KEY_ALERT_IMAGE]  = @"icon_no_internet";
        
        // List is empty so show 'Tap to retry' view
        [HELPER showRetryAlertIn:self details:aDictAlert retryBlock:^{
            
            if ([HTTPMANAGER isNetworkRechable]) {
                
                [HELPER removeRetryAlertIn:self];
                [HELPER removeLoadingIn:self];
                [self callLogoutWebService];
            }
        }];
        return;
    }
    
    NSMutableDictionary *aMutableDict = [NSMutableDictionary new];
    aMutableDict[SR_CUSTOMER_ID] = [SESSION getUserInfo][0][K_CUSTOMER_ID];
    
    
    [self.view endEditing:YES];
    [HELPER showLoadingIn:self];
    
    
    [HTTPMANAGER logout:aMutableDict completedBlock:^(NSDictionary *response) {
        
        if ([response[kRESPONSE][kRESPONSE_CODE] intValue] == kSUCCESS_CODE) {
            
            [SESSION setUserInfo:nil];
            [SESSION hasLoggedIn:NO];
            [SESSION setCardInfo:[NSMutableArray new]];
            [SESSION setChatInfo:[NSMutableArray new]];
            [SESSION setServiceType:[NSMutableArray new]];
            [SESSION setCurrentCountryDetails:[NSMutableArray new]];
            [SESSION setSearchInfo:[NSMutableArray new]];
            [SESSION setFavoriteInfoList:[NSMutableArray new]];
            [SESSION_2 isRequested:NO];
            [SESSION setDeviceToken:@""];
            [SESSION isFlagChanged:NO];

            [COREDATAMANAGER deleteAllEntities:TABEL_FAVOURITE_TYPE];
            [COREDATAMANAGER deleteAllEntities:TABEL_SERVICE_TYPE];
            
            
            LUHomeViewController *aViewController = [STORY_BOARD instantiateViewControllerWithIdentifier:@"LUHomeViewController"];
            UINavigationController *aNavigationController = [[UINavigationController alloc] initWithRootViewController:aViewController];
            
            [HELPER changeRootViewController:aNavigationController scaleIn:YES];
            
            
            
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
                    [self callLogoutWebService];
                }
            }];
        else
            [HELPER showNotificationSuccessIn:self withMessage:MESSAGE_SOMETHING_WENT_WRONG];

        [HELPER removeLoadingIn:self];
    }];
}

@end
