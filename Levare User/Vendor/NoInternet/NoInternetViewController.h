//
//  NoInternetViewController.h
//  MetroPark
//
//  Created by anglereit on 14/09/15.
//  Copyright (c) 2015 anglereit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoInternetViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *retryButton;
@property (weak, nonatomic) IBOutlet UILabel *alertLabel;
@property (weak, nonatomic) IBOutlet UIImageView *alertImageView;

@end
