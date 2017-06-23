//
//  UIButton+Activity.h
//  MetroParkOfficer
//
//  Created by anglereit on 01/09/15.
//  Copyright (c) 2015 anglereit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Activity)

- (void)startActivityIndicatorWithTitle:(NSString*)aTitle;
- (void)stopActivityIndicatorWithResetTitle:(NSString*)aTitle;
- (void)startActivityIndicator;

- (void)startActivityIndicator:(UIViewController *)aViewController;
- (void)stopActivityIndicator:(UIViewController *)aViewController withResetTitle:(NSString*)aTitle;
- (void)startActivityIndicator:(UIViewController *)aViewController aActivityColor:(UIColor *)aActivityColor;

@end
