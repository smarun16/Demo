//
//  TSBlurView.m
//  Pods
//
//  Created by Felix Krause on 20.08.13.
//
//

#import "TSBlurView.h"
#import <QuartzCore/QuartzCore.h>

@interface TSBlurView ()

@property (nonatomic, strong) UIView *toolbar;
@property (nonatomic, strong)  UIView *border;

@end

@implementation TSBlurView


- (UIView *)toolbar
{
    if (_toolbar == nil) {
        _toolbar = [[UIView alloc] initWithFrame:self.bounds];
        _toolbar.userInteractionEnabled = NO;
        _toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
       // [_toolbar setBackgroundImage:nil forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault]; // remove background set through the appearence proxy
#endif
        [self addSubview:_toolbar];
        
        _border = [[UIView alloc] init];
        _border.autoresizingMask = UIViewAutoresizingFlexibleWidth;

        [self addSubview:_border];
        
    }

    return _toolbar;
}

- (void)layoutSubviews {
    
    CGRect aFrame = _toolbar.bounds;
    aFrame.size.height = 6.0;
    aFrame.size.width = aFrame.size.height * 5;
    aFrame.origin.y = CGRectGetHeight(self.bounds) - (aFrame.size.height * 2);
    aFrame.origin.x = (CGRectGetWidth(self.bounds) * 0.5) - (CGRectGetWidth(aFrame) * 0.5);
    
    _border.frame = aFrame;
    _border.layer.cornerRadius = CGRectGetHeight(aFrame) * 0.5;
}

- (void)setBlurTintColor:(UIColor *)blurTintColor
{
    if ([self.toolbar respondsToSelector:@selector(setBackgroundColor:)]) {
        [self.toolbar performSelector:@selector(setBackgroundColor:) withObject:blurTintColor];
    }
    
    if ([self.toolbar respondsToSelector:@selector(setBarTintColor:)]) {
        [self.toolbar performSelector:@selector(setBarTintColor:) withObject:blurTintColor];
    }
}

- (void)setBorderColor:(UIColor *)aBorderColor
{
    if ([self.border respondsToSelector:@selector(setBackgroundColor:)]) {
        [self.border performSelector:@selector(setBackgroundColor:) withObject:aBorderColor];
    }
}

- (UIColor *)blurTintColor
{
    if ([self.toolbar respondsToSelector:@selector(barTintColor)]) {
        return [self.toolbar performSelector:@selector(barTintColor)];
    }
    
    if ([self.toolbar respondsToSelector:@selector(backgroundColor)]) {
       return [self.toolbar performSelector:@selector(backgroundColor)];
    }
    
    return nil;
}

@end
