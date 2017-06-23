//
//  Navigation.h
//
//  Copyright (c) 2015 ANGLER EIT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Navigation : NSObject

+ (Navigation *)sharedObject;

- (void)setTitle:(NSString *)title forViewController :(UIViewController *)controller;
- (void)setTitleWithBackButton:(NSString *)title forViewController:(UIViewController *)controller;
- (void)setTitleWithBarButtons:(NSString *)title forViewController :(UIViewController *)controller showLeftBarButtonIcon:(NSString *)leftBarButtonIcon showRightBarButtonIcon:(NSString *)rightBarButtonIcon;
- (void)hideNavigationBar :(UIViewController *)controller;

#pragma mark - Project Oriented Methods

- (void)setTitleWithBarButtonItems:(NSString *)title forViewController :(UIViewController *)controller showLeftBarButton:(NSString *)leftBarButton showRightBarButton:(NSString *)rightBarButton;

@end
