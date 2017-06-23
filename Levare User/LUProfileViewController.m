//
//  LUProfileViewController.m
//  Levare User
//
//  Created by AngMac137 on 11/17/16.
//  Copyright © 2016 AngMac137. All rights reserved.
//

#import "LUProfileViewController.h"
#import "LUOTPViewController.h"

@interface LUProfileViewController ()< UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    NSMutableDictionary *myCustomerMutableDictionary;
}
@property (strong, nonatomic) IBOutlet UIView *myBgView;
@property (strong, nonatomic) IBOutlet UIImageView *myProfileImageView;
@property (strong, nonatomic) IBOutlet UITextField *myFirstNameTextfield;
@property (strong, nonatomic) IBOutlet UITextField *myLastNameTextfield;
@property (strong, nonatomic) IBOutlet UIImageView *myFirstImageVIew;
@property (strong, nonatomic) IBOutlet UIImageView *myLastImageView;
@property (strong, nonatomic) IBOutlet UIView *myTextfieldBgView;


//Model
@property (strong, nonatomic) NSString *myFirstNameString, *myLastNameString, *myProfileImageString;


@end

@implementation LUProfileViewController

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
    
    [self setUpNavigationBar];
    myCustomerMutableDictionary = [NSMutableDictionary new];
    
    myCustomerMutableDictionary = _gCustomerMutableDict;
    [HELPER roundCornerForView:_myProfileImageView radius:2 borderColor:COLOR_BLACK];
    [HELPER roundCornerForView:_myTextfieldBgView radius:2 borderColor:COLOR_BLACK];
    
    _myProfileImageView.image =[[UIImage imageNamed:IMAGE_NO_PROFILE] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    _myProfileImageView.tintColor = [UIColor lightGrayColor];
    _myProfileImageView.backgroundColor = WHITE_COLOUR;
    
    _myFirstImageVIew.image = [[UIImage imageNamed:@"icon_user"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    _myFirstImageVIew.tintColor = [UIColor lightGrayColor];
    
    _myLastImageView.image = [[UIImage imageNamed:@"icon_user"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    _myLastImageView.tintColor = [UIColor lightGrayColor];
    
    _myFirstNameTextfield.tag = 1;
    _myLastNameTextfield.tag = 2;
    _myFirstNameTextfield.delegate = self;
    _myLastNameTextfield.delegate = self;
}

#pragma mark -Model

- (void)setupModel {
    
    _myProfileImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *aGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseImage)];
    aGesture.numberOfTapsRequired = 1;
    aGesture.numberOfTouchesRequired = 1;
    [_myProfileImageView addGestureRecognizer:aGesture];
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
    
    if (textField.tag == 1) {
        
        [_myLastNameTextfield becomeFirstResponder];
    }
    else {
        
        [self validateTextFields];
    }
    
    return YES;
}


#pragma mark - UIButton methods -

- (void)leftBarButtonTapEvent {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)rightBarButtonTapEvent {
    
    [self validateTextFields];
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
    label.text = TITLE_PROFILE;
    [label sizeToFit];
    
    self.navigationItem.leftBarButtonItem  = [[UIBarButtonItem alloc]initWithTitle:CANCEL style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonTapEvent)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:NEXT style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonTapEvent)];
}

// Hide Keyboard
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

-(void)moveToOTPScreen {
    
    LUOTPViewController *aViewController = [STORY_BOARD instantiateViewControllerWithIdentifier:@"LUOTPViewController"];
    aViewController.gCustomerMutableDict = myCustomerMutableDictionary;
    UINavigationController *aNavigationController = [[UINavigationController alloc] initWithRootViewController:aViewController];
    [self.navigationController presentViewController:aNavigationController animated:YES completion:nil];
}

-(void)validateTextFields {
    
    if (_myFirstNameTextfield.text.length == 0) {
        
        [HELPER showAlertView:self title:SCREEN_TITLE_PROFILE message:K_ALERT_FIRST_NAME okButtonBlock:^(UIAlertAction *action) {
            [_myFirstNameTextfield becomeFirstResponder];
        }];
    }
    
    else if (_myLastNameTextfield.text.length == 0) {
        
        [HELPER showAlertView:self title:SCREEN_TITLE_PROFILE message:K_ALERT_LAST_NAME okButtonBlock:^(UIAlertAction *action) {
            [_myLastNameTextfield becomeFirstResponder];
        }];
    }
    
    else {
        
        [self.view endEditing:YES];
        
        myCustomerMutableDictionary[K_FIRST_NAME] = _myFirstNameTextfield.text;
        myCustomerMutableDictionary[K_LAST_NAME] = _myLastNameTextfield.text;
        
        [self moveToOTPScreen];
    }
}

@end
