//
//  LUChatViewController.m
//  Levare User
//
//  Created by Arun Prasad.S, ANGLER - EIT on 26/12/16.
//  Copyright © 2016 AngMac137. All rights reserved.
//

#import "LUChatViewController.h"
#import "SignalR.h"

@interface LUChatViewController ()<UITextViewDelegate>
{
    //NSMutableArray *myInfoArray;
    NSString *myTextViewString;
    NSObject *myData;
    NSMutableArray *myChatInfoMutableArray;
    TagChatInfo *myTag;
    NSInteger myTripStatusIdInteger;
}

// SignalR

@property (strong, nonatomic) SRHubConnection *myHubConnection;
@property (strong, nonatomic)  SRHubProxy *myHubProxy;
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) IBOutlet UITextView *myTextView;
@property (strong, nonatomic) IBOutlet UIButton *mySendButton;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *myTextViewHeightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *myTextViewBottomConstraint;


@end

@implementation LUChatViewController

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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
}

#pragma mark -View Init

- (void)setupUI {
    
    [NAVIGATION setTitleWithBarButtonItems:TITLE_CHAT forViewController:self showLeftBarButton:nil showRightBarButton:nil];
    [self setUpLeftBarButton];
    
    myChatInfoMutableArray = [NSMutableArray new];
    myChatInfoMutableArray = [SESSION getChatInfo];
    myTextViewString = @"";
    myTripStatusIdInteger = 0;
    
    [HELPER roundCornerForView:_mySendButton withRadius:5];
    [HELPER roundCornerForView:_myTextView radius:5 borderColor:LIGHT_GRAY_COLOUR];
    
    _myTableView.estimatedRowHeight = 100;
    
    if (myChatInfoMutableArray.count) {
        
        [_myTableView reloadData];
        [_myTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:myChatInfoMutableArray.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

#pragma mark -Model

- (void)setupModel {
    
    if (!_myTextView.text.length) {
        
        _mySendButton.backgroundColor = LIGHT_GRAY_COLOUR;
        _mySendButton.userInteractionEnabled = NO;
    }
}

- (void)loadModel {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateViewForchatStatusChange:) name:NOTIFICATION_VIEW_UPADTE_BASED_ON_CHAT_STATUS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateRequestBasedOnStatusChange:) name:NOTIFICATION_VIEW_UPADTE_BASED_ON_REQUEST_STATUS object:nil];
    
    
}


-(void) setUpLeftBarButton {
    
    self.navigationItem.leftBarButtonItem  = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(leftBarButtonTapEvent)];
    self.navigationController.navigationBar.tintColor = WHITE_COLOUR;
}

#pragma mark - UITable view Delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return myChatInfoMutableArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellIdentifier =@"chatCell";
    
    UITableViewCell *aCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (aCell == nil) {
        
        aCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    UILabel *gRightLabel = (UILabel *)[aCell viewWithTag:1];
    UILabel *gLeftLabel = (UILabel *)[aCell viewWithTag:4];
    UIView *gRightView = (UIView *)[aCell viewWithTag:2];
    UIView *gLeftView = (UIView *)[aCell viewWithTag:3];
    
    if (![[myChatInfoMutableArray objectAtIndex:indexPath.row][@"Type"] isEqualToString:SR_CUSTOMER_TYPE]) {
        
        gLeftLabel.hidden = YES;
        gLeftView.hidden = YES;
        gRightLabel.hidden = gRightView.hidden = !gLeftLabel.hidden;
        /*
         CGSize maximumLabelSize = CGSizeMake(296, FLT_MAX);
         CGSize expectedLabelSize = [myChatInfoMutableArray[indexPath.row][@"Message"] sizeWithFont:gRightLabel.font constrainedToSize:maximumLabelSize lineBreakMode:gRightLabel.lineBreakMode];
         
         //adjust the label the the new height.
         CGRect newFrame = gRightLabel.frame;
         newFrame.size.height = expectedLabelSize.height;
         gRightLabel.frame = newFrame;*/
        gRightLabel.text = myChatInfoMutableArray[indexPath.row][@"Message"];
    }
    else {
        
        gRightLabel.hidden = YES;
        gRightView.hidden = YES;
        gLeftLabel.hidden = gLeftView.hidden = !gRightLabel.hidden;
        gLeftLabel.text = myChatInfoMutableArray[indexPath.row][@"Message"];
    }
    
    [HELPER roundCornerForView:gRightView withRadius:6];
    [HELPER roundCornerForView:gLeftView withRadius:6];
    return aCell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 10)];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [cell setLayoutMargins:UIEdgeInsetsMake(0, 10, 0, 10)];
    }
    
    if (indexPath.row == myChatInfoMutableArray.count -1) {
        
        // [_myTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

-(void)viewDidLayoutSubviews {
    
    if ([self.myTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.myTableView setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 10)];
    }
    
    if ([self.myTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.myTableView setLayoutMargins:UIEdgeInsetsMake(0, 10, 0, 10)];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - TextView Delegate -

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if ([text isEqualToString:@"\n"]) {
        return NO;
    }
    
    NSString *aText = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
    NSString *aStr = [aText stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if (aStr.length) {
        
        _mySendButton.backgroundColor = [UIColor blackColor];
        _mySendButton.userInteractionEnabled = YES;
    }
    else {
        
        _mySendButton.backgroundColor = LIGHT_GRAY_COLOUR;
        _mySendButton.userInteractionEnabled = NO;
    }
    _myTextViewHeightConstraint.constant =  textView.contentSize.height;
    
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    
    _myTextViewBottomConstraint.constant = 270;
}


- (void)textViewDidEndEditing:(UITextView *)textView{
    
    _myTextViewBottomConstraint.constant = 8;
}

- (void)textViewDidChange:(UITextView *)textView {
    
}


// Hide Keyboard
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - UIButton Title -

- (IBAction)sendButtonTapped:(id)sender {
    
    [self sendButtonTapped];
}

-(void)leftBarButtonTapEvent {
    
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
        [[NSNotificationCenter defaultCenter] removeObserver:self  name:NOTIFICATION_VIEW_UPADTE_BASED_ON_CHAT_STATUS object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self  name:NOTIFICATION_VIEW_UPADTE_BASED_ON_REQUEST_STATUS object:nil];
        
        if (self.callBackBlock) {
            
            self.callBackBlock(YES, NO);
        }
    }];
}

-(void)updateViewForchatStatusChange:(NSNotification *)notification {
    
    NSDictionary *dictionary = [notification userInfo];
    NSString *response = [dictionary valueForKey:NOTIFICATION_CHAT_STATUS_KEY];
    
    NSData *data = [response dataUsingEncoding:NSUTF8StringEncoding];
    id aJsonId = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    if ([aJsonId[kRESPONSE][kRESPONSE_CODE] intValue] == kSUCCESS_CODE) {
        
        
        [myChatInfoMutableArray addObject:[aJsonId objectForKey:@"Chat_Info"][0]];
        
        NSLog(@"aJsonId -- %@", aJsonId);
        NSLog(@"myChatInfoMutableArray -- %lu", (unsigned long)myChatInfoMutableArray.count);
        [SESSION setChatInfo:myChatInfoMutableArray];
        [_myTableView reloadData];
        
        NSInteger lastRowNumber = ( [_myTableView numberOfRowsInSection:0] == 0) ? 0 : [_myTableView numberOfRowsInSection:0] - 1;
        
        if (lastRowNumber > 0 && ![_myTextView isFirstResponder]) {
            
            
            [_myTextView resignFirstResponder];
            _myTextView.text = @"";
            _myTextViewHeightConstraint.constant = 30;
            _myTextViewBottomConstraint.constant = 8;
            
            NSIndexPath* indexpath = [NSIndexPath indexPathForRow:myChatInfoMutableArray.count-1 inSection:0];
            [_myTableView scrollToRowAtIndexPath:indexpath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
    }
    
    else if ([aJsonId[kRESPONSE][kRESPONSE_CODE] intValue] == k_BAD_REQUEST || [aJsonId[kRESPONSE][kRESPONSE_CODE] intValue] == K_NO_DATA_CODE) {
        
        [HELPER showNotificationSuccessIn:self withMessage:aJsonId[kRESPONSE][kRESPONSE_MESSAGE]];
    }
    else {
        
        [HELPER showNotificationSuccessIn:self withMessage:MESSAGE_SOMETHING_WENT_WRONG];
    }
    
}

-(void)updateRequestBasedOnStatusChange:(NSNotification *)notification {
    
    NSDictionary *dictionary = [notification userInfo];
    NSString *response = [dictionary valueForKey:NOTIFICATION_REQUEST_STATUS_KEY];
    
    NSData *data = [response dataUsingEncoding:NSUTF8StringEncoding];
    id aJsonId = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    if ([aJsonId[kRESPONSE][kRESPONSE_CODE] intValue] == kSUCCESS_CODE) {
        
        myTripStatusIdInteger = [[aJsonId objectForKey:SR_TRIP_STATUS_ID] integerValue];
        
        if (myTripStatusIdInteger == SR_TRIP_REQUEST) {
            
            [HELPER showNotificationSuccessIn:self withMessage:aJsonId[kRESPONSE][kRESPONSE_MESSAGE]];
            
        }
        else if (myTripStatusIdInteger == SR_TRIP_BEFORE_CANCEL || myTripStatusIdInteger == SR_TRIP_AFTER_CANCEL) {
            
            [HELPER showNotificationSuccessIn:self withMessage:@"Trip cancelled"];
            
            [self leftBarButtonTapEvent];
            
        }
        else if (myTripStatusIdInteger == SR_TRIP_ACCEPTED) {
            
            [HELPER showNotificationSuccessIn:self withMessage:aJsonId[kRESPONSE][kRESPONSE_MESSAGE]];
        }
        else if (myTripStatusIdInteger == SR_TRIP_ARRIVED) {
            
            [HELPER showNotificationSuccessIn:self withMessage:aJsonId[kRESPONSE][kRESPONSE_MESSAGE]];
        }
        else  {
            
            if (myTripStatusIdInteger == SR_TRIP_STARTED) {
                
                [HELPER showNotificationSuccessIn:self withMessage:aJsonId[kRESPONSE][kRESPONSE_MESSAGE]];
                
            }
            else {
                
                [HELPER showNotificationSuccessIn:self withMessage:aJsonId[kRESPONSE][kRESPONSE_MESSAGE]];
            }
            
            [self leftBarButtonTapEvent];
        }
    }
    else if ([aJsonId[kRESPONSE][kRESPONSE_CODE] intValue] == k_BAD_REQUEST || [aJsonId[kRESPONSE][kRESPONSE_CODE] intValue] == K_NO_DATA_CODE) {
        
        [HELPER showNotificationSuccessIn:self withMessage:aJsonId[kRESPONSE][kRESPONSE_MESSAGE]];
    }
    else {
        
        [HELPER showNotificationSuccessIn:self withMessage:MESSAGE_SOMETHING_WENT_WRONG];
    }
    
}

-(void)sendButtonTapped {
    
    _mySendButton.userInteractionEnabled = NO;
    if (!_myHubConnection) {
        
        [_myHubConnection setStarted:^{
            
            NSLog(@"Connection Started");
            
            NSArray *aArray = [NSArray new];
            
            aArray = @[[SESSION getUserInfo][0][K_CUSTOMER_ID],SR_CUSTOMER_TYPE];
            
            
            __block SRHubProxy *aHub;
            
            aHub = _myHubProxy;
            
            [aHub invoke:SR_GO_ONLINE withArgs:aArray completionHandler:^(id response, NSError *error) {
                
                if (!error) {
                    
                    if (![response isKindOfClass:[NSDictionary class]]) {
                        
                        NSData *data = [response dataUsingEncoding:NSUTF8StringEncoding];
                        id aJsonId = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                        
                        if ([aJsonId[kRESPONSE][kRESPONSE_CODE] intValue] == kSUCCESS_CODE) {
                            
                        }
                        
                        else if ([response[kRESPONSE][kRESPONSE_CODE] intValue] == k_BAD_REQUEST) {
                            
                        }
                        else {
                            
                        }
                    }
                }
                else {
                    
                }
            }];
        }];
    }
    
    NSArray *aArray = [NSArray new];
    
    aArray = [NSArray arrayWithObjects: _gTripIdString,_gUserIdString,SR_CUSTOMER_TYPE,_myTextView.text, nil];
    
    [_myHubProxy invoke:SR_SEND_CHAT_MESSAGE withArgs:aArray completionHandler:^(id response, NSError *error) {
        
        if (!error) {
            
            if (![response isKindOfClass:[NSDictionary class]]) {
                
                NSData *data = [response dataUsingEncoding:NSUTF8StringEncoding];
                id aJsonId = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                
                if ([aJsonId[kRESPONSE][kRESPONSE_CODE] intValue] == kSUCCESS_CODE) {
                    
                    [_myTableView reloadDataWithAnimation];
                    [_myTextView resignFirstResponder];
                    _myTextView.text = @"";
                    _myTextViewBottomConstraint.constant = 8;
                    _myTextViewHeightConstraint.constant = 30;
                }
                
                else if ([aJsonId[kRESPONSE][kRESPONSE_CODE] intValue] == k_BAD_REQUEST) {
                    
                    [HELPER showNotificationSuccessIn:self withMessage:aJsonId[kRESPONSE][kRESPONSE_MESSAGE]];
                }
                else if ([aJsonId[kRESPONSE][kRESPONSE_CODE] intValue] == K_NO_DATA_CODE) {
                    
                    [HELPER showAlertView:self title:SCREEN_TITLE_CHAT message:aJsonId[kRESPONSE][kRESPONSE_MESSAGE] okButtonBlock:^(UIAlertAction *action) {
                        
                        [self.navigationController dismissViewControllerAnimated:YES completion:^{
                            
                            [[NSNotificationCenter defaultCenter] removeObserver:self  name:NOTIFICATION_VIEW_UPADTE_BASED_ON_CHAT_STATUS object:nil];
                            
                            [_myTextView resignFirstResponder];
                            _myTextView.text = @"";
                            _myTextViewBottomConstraint.constant = 8;
                            _myTextViewHeightConstraint.constant = 30;
                            
                            if (self.callBackBlock) {
                                
                                self.callBackBlock(NO, YES);
                            }
                        }];
                    }];
                }
                else {
                    
                    [HELPER showNotificationSuccessIn:self withMessage:MESSAGE_SOMETHING_WENT_WRONG];
                }
                _mySendButton.backgroundColor = LIGHT_GRAY_COLOUR;
                _mySendButton.userInteractionEnabled = NO;
            }
        }
        else {
            
            if (error.code == NSURLErrorTimedOut)
                [HELPER showRetryAlertIn:self details:ALERT_SIGNALR_UNABLE_TO_REACH_DICT retryBlock:^{
                    
                    if ([HTTPMANAGER isNetworkRechable]) {
                        
                        [HELPER removeRetryAlertIn:self];
                        [HELPER showLoadingIn:self];
                        [self sendButtonTapped];
                    }
                }];
            else
                [HELPER showNotificationSuccessIn:self withMessage:MESSAGE_SOMETHING_WENT_WRONG];
        }
        
        _mySendButton.userInteractionEnabled = YES;
    }];
}

@end
