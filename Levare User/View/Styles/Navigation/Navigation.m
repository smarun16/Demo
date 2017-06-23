//
//  Navigation.m
//
//  Copyright (c) 2015 ANGLER EIT. All rights reserved.
//

#import "Navigation.h"

@implementation Navigation {
    
    UIViewController *viewControllerForBackButton;
}

+ (Navigation *)sharedObject {
    
    static Navigation *_sharedObject = nil;
    
    @synchronized (self) {
        if (!_sharedObject)
            _sharedObject = [[[self class] alloc] init];
    }
    
    return _sharedObject;
}

- (void)setTitle:(NSString *)title forViewController :(UIViewController *)controller {
    
    controller.navigationItem.titleView = [self getTitleLabel:title];
    [self setNavigationBarProperties:controller];
}

- (void)setTitleWithBackButton:(NSString *)title forViewController:(UIViewController *)controller {
    
    controller.navigationItem.titleView = [self getTitleLabel:title];
    [self setBarButtonFor:controller isLeftBarButton:YES image:IMAGE_BACK];
    [self setNavigationBarProperties:controller];
}

- (void)setTitleWithBarButtons:(NSString *)title forViewController :(UIViewController *)controller showLeftBarButtonIcon:(NSString *)leftBarButtonIcon showRightBarButtonIcon:(NSString *)rightBarButtonIcon {
    
    controller.navigationItem.titleView = [self getTitleLabel:title];
    
    if ([leftBarButtonIcon length] != 0) {
        [self setBarButtonFor:controller isLeftBarButton:YES image:leftBarButtonIcon];
    }
    
    if ([rightBarButtonIcon length] != 0) {
        [self setBarButtonFor:controller isLeftBarButton:NO image:rightBarButtonIcon];
    }
    
    [self setNavigationBarProperties:controller];
}

- (void)hideNavigationBar :(UIViewController *)controller {
    
    [self setNavigationBarProperties:controller];
    [controller.navigationController.navigationBar setHidden:YES];
}

#pragma mark - Private Methods

- (UILabel *)getTitleLabel:(NSString *)text {
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.text = text;
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    [label setFont:[UIFont boldSystemFontOfSize:15.0]];
    [label sizeToFit];
    
    return label;
}

- (void)setBarButtonFor:(UIViewController *)controller isLeftBarButton:(BOOL)isLeftBarButton image:(NSString *)imageName {
    
    UIImage *image = [UIImage imageNamed:imageName];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    [button setImage:image forState:UIControlStateNormal];
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    UIBarButtonItem *space = [[UIBarButtonItem alloc]
                              initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                              target:nil action:nil];
    space.width = -10;
    
    if (isLeftBarButton) {
        
        [button addTarget:controller action:@selector(leftBarButtonTapEvent) forControlEvents:UIControlEventTouchUpInside];
        [controller.navigationItem setLeftBarButtonItems:@[space, barButtonItem] animated:YES];
    }
    else {
        
        [button addTarget:controller action:@selector(rightBarButtonTapEvent) forControlEvents:UIControlEventTouchUpInside];
        [controller.navigationItem setRightBarButtonItems:@[space, barButtonItem] animated:YES];
    }
}

- (void)setNavigationBarProperties :(UIViewController *)controller {
    
    [controller.navigationController.navigationBar setHidden:NO];
    controller.navigationController.navigationBar.barTintColor = [HELPER getColorFromHexaDecimal:COLOR_APP_PRIMARY];
    [controller.navigationController.navigationBar setTranslucent:NO];
    
   /* CGRect frame = controller.view.frame;
    frame.size.height = frame.size.height - 64;
    controller.view.frame = frame;*/
}

- (void)backButtonTapEvent {
    
    [viewControllerForBackButton.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Project Oriented Methods

- (void)setTitleWithBarButtonItems:(NSString *)title forViewController :(UIViewController *)controller showLeftBarButton:(NSString *)leftBarButton showRightBarButton:(NSString *)rightBarButton {
    
    controller.navigationItem.titleView = [self getTitleLabel:title];
    
    if ([leftBarButton length] != 0) {
        [self setBarButtonItemsFor:controller isLeftBarButton:YES withTitle:leftBarButton];
    }
    else {
        [controller.navigationItem setHidesBackButton:YES animated:NO];
    }
    
    if ([rightBarButton length] != 0) {
        [self setBarButtonItemsFor:controller isLeftBarButton:NO withTitle:rightBarButton];
    }
    
    [self setNavigationBarProperties:controller];
}

- (void)setBarButtonItemsFor:(UIViewController *)controller isLeftBarButton:(BOOL)isLeftBarButton withTitle:(NSString *)barButtonItem {
    
    NSArray *array = [barButtonItem componentsSeparatedByString:TEXT_SEPARATOR];
    
    if ([array count] == 1) {
        
        UIButton *buttonItemOne = [UIButton buttonWithType:UIButtonTypeCustom];
        
        if ([array[0] rangeOfString:@"."].location == NSNotFound) {
            
            [buttonItemOne setTitle:array[0] forState:UIControlStateNormal];
            [buttonItemOne setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            buttonItemOne.titleLabel.font = [UIFont systemFontOfSize:14.0];
            buttonItemOne.frame = CGRectMake(0, 0, 60, 30);
        }
        else {
            
            UIImage *image = [UIImage imageNamed:array[0]];
            [buttonItemOne setImage:image forState:UIControlStateNormal];
            buttonItemOne.frame = CGRectMake(10, 0, 25, 25);
        }
        
        UIBarButtonItem *barButtonItemOne = [[UIBarButtonItem alloc] initWithCustomView:buttonItemOne];
        
        UIBarButtonItem *space = [[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                  target:nil action:nil];
        
        if ([array[0] isEqualToString:IMAGE_MENU] || [array[0] isEqualToString:@""])
            space.width = 0;
        else
            space.width = -6;
        
        if (isLeftBarButton) {
            
            [buttonItemOne addTarget:controller action:@selector(leftBarButtonTapEvent) forControlEvents:UIControlEventTouchUpInside];
            [controller.navigationItem setLeftBarButtonItems:@[space,barButtonItemOne] animated:YES];
        }
        else {
            
            [buttonItemOne addTarget:controller action:@selector(rightBarButtonTapEvent) forControlEvents:UIControlEventTouchUpInside];
            [controller.navigationItem setRightBarButtonItems:@[space,barButtonItemOne] animated:YES];
        }
    }
    
    else if ([array count] == 2) {
        
        UIImage *image = [UIImage imageNamed:array[0]];
        UIButton *buttonItemOne = [UIButton buttonWithType:UIButtonTypeCustom];
        buttonItemOne.frame = CGRectMake(0, 0, 20, 20);
        [buttonItemOne setImage:image forState:UIControlStateNormal];
        UIBarButtonItem *barButtonItemOne = [[UIBarButtonItem alloc] initWithCustomView:buttonItemOne];
        
        image = [UIImage imageNamed:array[1]];
        UIButton *buttonItemTwo = [UIButton buttonWithType:UIButtonTypeCustom];
        buttonItemTwo.frame = CGRectMake(0, 0, 20, 20);
        [buttonItemTwo setImage:image forState:UIControlStateNormal];
        UIBarButtonItem *barButtonItemTwo = [[UIBarButtonItem alloc] initWithCustomView:buttonItemTwo];
        
        UIBarButtonItem *space = [[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                  target:nil action:nil];
        space.width = 15;
        
        if (isLeftBarButton) {
            
            [buttonItemOne addTarget:controller action:@selector(leftButtonItemOneTapEvent) forControlEvents:UIControlEventTouchUpInside];
            [buttonItemTwo addTarget:controller action:@selector(leftButtonItemTwoTapEvent) forControlEvents:UIControlEventTouchUpInside];
            [controller.navigationItem setLeftBarButtonItems:@[barButtonItemTwo, barButtonItemOne, space] animated:YES];
        }
        else {
            
            [buttonItemOne addTarget:controller action:@selector(rightButtonItemOneTapEvent) forControlEvents:UIControlEventTouchUpInside];
            [buttonItemTwo addTarget:controller action:@selector(rightButtonItemTwoTapEvent) forControlEvents:UIControlEventTouchUpInside];
            [controller.navigationItem setRightBarButtonItems:@[barButtonItemTwo, space, barButtonItemOne] animated:YES];
        }
    }
}


@end
