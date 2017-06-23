//
//  LUHomeViewController.m
//  Levare User
//
//  Created by AngMac137 on 11/17/16.
//  Copyright © 2016 AngMac137. All rights reserved.
//

#import "LUHomeViewController.h"
#import "LULoginViewController.h"
#import "LUSignUpViewController.h"

@interface LUHomeViewController ()

@property (strong, nonatomic) IBOutlet UIButton *mySigninButton;
@property (strong, nonatomic) IBOutlet UIButton *myRegisterButton;
@end

@implementation LUHomeViewController

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

-(void)viewWillAppear:(BOOL)animated {
    
    if (![SESSION getCurrentCountryDetails].count) {
        
        NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        NSString *countryCode = [[NSLocale currentLocale] objectForKey: NSLocaleCountryCode];
        NSString *country = [usLocale displayNameForKey: NSLocaleCountryCode value: countryCode];
        
        [APPDELEGATE getCountryCodeDetailsFromCountyr:country];
    }

    self.navigationController.navigationBarHidden = YES;
}

#pragma mark -View Init

- (void)setupUI {
    
    
    self.navigationController.navigationBarHidden = YES;
    
    [APPDELEGATE startMonitoringNetwork];
    [HELPER roundCornerForView:_mySigninButton radius:2 borderColor:[UIColor blackColor]];
    [HELPER roundCornerForView:_myRegisterButton withRadius:2];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
       
        if ([HTTPMANAGER isNetworkRechable] == NO) {
            
            [APPDELEGATE presentNoInternetViewController];
        }
    });
}

#pragma mark -Model

- (void)setupModel {
    
}

- (void)loadModel {
    
}


#pragma mark - UIButton methods -

-(void)leftBarButtonTapEvent {
    
}

-(void)rightBarButtonTapEvent {
    
}

- (IBAction)registerButtonTapped:(id)sender {
    
    LUSignUpViewController *aViewController = [STORY_BOARD instantiateViewControllerWithIdentifier:@"LUSignUpViewController"];
    [self.navigationController pushViewController:aViewController animated:YES];
}

- (IBAction)siginButtonTapped:(id)sender {
    
   // [[Crashlytics sharedInstance] crash];

    LULoginViewController *aViewController = [STORY_BOARD instantiateViewControllerWithIdentifier:@"LULoginViewController"];
    [self.navigationController pushViewController:aViewController animated:YES];
}

@end
