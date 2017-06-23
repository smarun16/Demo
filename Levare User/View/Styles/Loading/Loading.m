//
//  Loading.m
//
//  Copyright (c) 2015 ANGLER EIT. All rights reserved.
//

#import "Loading.h"

#import "RTSpinKitView.h"

@interface Loading()

@property (nonatomic, strong) RTSpinKitView *spriteView;

@end

@implementation Loading

@synthesize spriteView;

- (id)init {
    
    self = [super initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
    
    if (self) {
        
        self.alpha = 0.0;
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        bgView.backgroundColor = [UIColor blackColor];
        bgView.alpha = 0.7f;
        [self addSubview:bgView];
        
        self.spriteView = [[RTSpinKitView alloc] initWithStyle:RTSpinKitViewStyleWave color:[HELPER getColorFromHexaDecimal:COLOR_APP_PRIMARY]];
        self.spriteView.frame = CGRectMake((self.frame.size.width / 2) - 17.5 , (([[UIScreen mainScreen] bounds].size.height)/ 2) - 20, 40, 40);
        [self addSubview:self.spriteView];
    }
    
    return self;
}

- (void)show {
    
    [self.spriteView startAnimating];
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 1.0;
    }];
}

- (void)hide {
    
    [self.spriteView stopAnimating];
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0.0;
    }];
}

@end
