//
//  UIButton+Activity.m
//  MetroParkOfficer
//
//  Created by anglereit on 01/09/15.
//  Copyright (c) 2015 anglereit. All rights reserved.
//

#import "UIButton+Activity.h"

#define PADDING 10.0
#define TAG_ACTIVITY_INDICATOR 100

@implementation UIButton (Activity)

- (void)startActivityIndicatorWithTitle:(NSString*)aTitle {
    
    float aWidth = 20;
    float aHeight = 20;
    float aXPosition = CGRectGetWidth(self.frame) - aWidth - PADDING;
    float aYPosition = (CGRectGetHeight(self.frame) * 0.5) - (aHeight * 0.5);
    
    UIActivityIndicatorView *aActivityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    aActivityView.tag = TAG_ACTIVITY_INDICATOR;
    aActivityView.frame = CGRectMake(aXPosition,aYPosition,aWidth,aHeight);
    [aActivityView startAnimating];
    [self addSubview:aActivityView];
    
    [self setTitle:aTitle forState:UIControlStateNormal];
    self.userInteractionEnabled = NO;
}

- (void)startActivityIndicator {
    
    float aWidth = 20;
    float aHeight = 20;
    float aXPosition = (CGRectGetWidth(self.frame) * 0.5) - (aWidth * 0.5);
    float aYPosition = (CGRectGetHeight(self.frame) * 0.5) - (aHeight * 0.5);
    
    UIActivityIndicatorView *aActivityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    aActivityView.tag = TAG_ACTIVITY_INDICATOR;
    aActivityView.frame = CGRectMake(aXPosition,aYPosition,aWidth,aHeight);
    [aActivityView startAnimating];
    [self addSubview:aActivityView];
    
    [self setTitle:@"" forState:UIControlStateNormal];
    self.userInteractionEnabled = NO;
}

- (void)stopActivityIndicatorWithResetTitle:(NSString*)aTitle {
    
    [self setTitle:aTitle forState:UIControlStateNormal];
    [[self viewWithTag:TAG_ACTIVITY_INDICATOR] removeFromSuperview];
    self.userInteractionEnabled = YES;

}

- (void)startActivityIndicator:(UIViewController *)aViewController {
    
    float aWidth = 20;
    float aHeight = 20;
    float aXPosition = (CGRectGetWidth(self.frame) * 0.5) - (aWidth * 0.5);
    float aYPosition = (CGRectGetHeight(self.frame) * 0.5) - (aHeight * 0.5);
    
    UIActivityIndicatorView *aActivityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    aActivityView.tag = TAG_ACTIVITY_INDICATOR;
    aActivityView.color = self.titleLabel.textColor;
    aActivityView.frame = CGRectMake(aXPosition,aYPosition,aWidth,aHeight);
    [aActivityView startAnimating];
    [self addSubview:aActivityView];
    
    [self setTitle:@"" forState:UIControlStateNormal];
    
    aViewController.view.userInteractionEnabled = NO;
    self.userInteractionEnabled = NO;
}

- (void)startActivityIndicator:(UIViewController *)aViewController aActivityColor:(UIColor *)aActivityColor {
    
    float aWidth = 20;
    float aHeight = 20;
    float aXPosition = (CGRectGetWidth(self.frame) * 0.5) - (aWidth * 0.5);
    float aYPosition = (CGRectGetHeight(self.frame) * 0.5) - (aHeight * 0.5);
    
    UIActivityIndicatorView *aActivityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    aActivityView.tag = TAG_ACTIVITY_INDICATOR;
    aActivityView.color = aActivityColor;
    aActivityView.frame = CGRectMake(aXPosition,aYPosition,aWidth,aHeight);
    [aActivityView startAnimating];
    [self addSubview:aActivityView];
    
    [self setTitle:@"" forState:UIControlStateNormal];
    
    aViewController.view.userInteractionEnabled = NO;
    self.userInteractionEnabled = NO;
}
- (void)stopActivityIndicator:(UIViewController *)aViewController withResetTitle:(NSString*)aTitle {
    
    [self setTitle:aTitle forState:UIControlStateNormal];
    [[self viewWithTag:TAG_ACTIVITY_INDICATOR] removeFromSuperview];
    self.userInteractionEnabled = YES;
    aViewController.view.userInteractionEnabled = YES;
    
}


@end
