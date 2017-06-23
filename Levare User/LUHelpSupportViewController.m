//
//  LUHelpSupportViewController.m
//  Levare User
//
//  Created by AngMac137 on 12/10/16.
//  Copyright © 2016 AngMac137. All rights reserved.
//

#import "LUHelpSupportViewController.h"

@interface LUHelpSupportViewController ()<UIWebViewDelegate>
{
    BOOL isFirstTime;
}
@property (strong, nonatomic) UIView *myAlertView;

@end

@implementation LUHelpSupportViewController
@synthesize myWebView, myAlertView;

#pragma mark-
#pragma mark- UIView init
#pragma mark-

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self setupUI];
    [self setupModel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupUI {
    
    [NAVIGATION setTitleWithBarButtonItems:TITLE_HELP forViewController:self showLeftBarButton:nil showRightBarButton:nil];
    [self setUpLeftBarButton];
}

-(void)setupModel
{
    isFirstTime = YES;
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    [self loadWebView];
}

#pragma mark-
#pragma mark- UIWeb View delegates
#pragma mark-

-(void)webViewDidStartLoad:(UIWebView *)webView {
    
    isFirstTime = NO;
    [HELPER showLoadingIn:self];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    NSString *navigatorUrl = webView.request.URL.absoluteString;
    
    if (navigatorUrl && ![navigatorUrl isEqualToString:@""]) {
        isFirstTime = YES;
        [HELPER removeLoadingIn:self];
    }
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    myAlertView = [HELPER showRetryAlertIn:self details:ALERT_UNABLE_TO_REACH_DICT retryBlock:^{
        
        [self loadWebView];
    }];
    return;
    
    [HELPER removeLoadingIn:self];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

#pragma mark-
#pragma mark- Private method
#pragma mark-

- (void)leftBarButtonTapEvent {
    
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
        if ([SESSION_2 isRequested] && ![SESSION_2 isAlertShown]) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:VIEW_UPADTE_BASED_ON_REQUEST_STATUS object:nil userInfo:nil];
            
        }
    }];
}

-(void) setUpLeftBarButton {
    
    self.navigationItem.leftBarButtonItem  = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(leftBarButtonTapEvent)];
    self.navigationController.navigationBar.tintColor = WHITE_COLOUR;
}


-(void)loadWebView
{
    if (![HTTPMANAGER isNetworkRechable])
    {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        if (isFirstTime == NO) {
            
            [HELPER showNotificationSuccessIn:self withMessage:ALERT_UNABLE_TO_REACH_DESC];
            return;
        }
        else {
            
            myAlertView = [HELPER showRetryAlertIn:self details:ALERT_UNABLE_TO_REACH_DICT retryBlock:^{
                
                [self loadWebView];
            }];
        }
        return;
    }
    NSString * aHtmlFile = [[NSBundle mainBundle] pathForResource: @"about" ofType : @"html"];
    
    NSURL * aLocalHTMLURL = [ NSURL URLWithString:[SESSION getUserInfo][0][@"Help_Url"]] ;
    
    [myWebView loadRequest:[NSURLRequest requestWithURL:aLocalHTMLURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60]];
}


@end
