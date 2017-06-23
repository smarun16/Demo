//
//  NoInternetViewController.m
//  MetroPark
//
//  Created by anglereit on 14/09/15.
//  Copyright (c) 2015 anglereit. All rights reserved.
//

#import "NoInternetViewController.h"

@interface NoInternetViewController ()

@end

@implementation NoInternetViewController

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
    
    [HELPER roundCornerForView:self.retryButton radius:8 borderColor:WHITE_COLOUR];
    
}

#pragma mark -Model

- (void)setupModel {
    
}

- (void)loadModel {
    
}


#pragma mark - Private Methods

- (IBAction)retryButtonTapped:(UIButton *)sender {
    
    if ([HTTPMANAGER isNetworkRechable]) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
