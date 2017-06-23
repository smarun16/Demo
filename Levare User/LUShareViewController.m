//
//  LUShareViewController.m
//  Levare User
//
//  Created by Arun Prasad.S, ANGLER - EIT on 26/12/16.
//  Copyright © 2016 AngMac137. All rights reserved.
//

#import "LUShareViewController.h"

@interface LUShareViewController ()<MFMailComposeViewControllerDelegate,UIDocumentInteractionControllerDelegate, MFMessageComposeViewControllerDelegate>
{
    NSArray *myInfoArray;
    NSString *myPromoString;
}
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@end

@implementation LUShareViewController

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
    
    self.navigationController.navigationBarHidden = NO;
    [NAVIGATION setTitleWithBarButtonItems:TITLE_REFER forViewController:self showLeftBarButton:nil showRightBarButton:nil];
    [self setUpLeftBarButton];
    
    _myTableView.tableFooterView = [UIView new];
    
    myInfoArray = [NSArray new];
    
    myInfoArray = @[@{KEY_TEXT: FACEBOOK, KEY_IMAGE: @"icon_facebook"},
                    @{KEY_TEXT: TWITTER, KEY_IMAGE: @"icon_twitter"},
                    @{KEY_TEXT: WHATSAPP, KEY_IMAGE: @"icon_whatsapp"},
                    @{KEY_TEXT: MESSAGES, KEY_IMAGE: @"icon_message"},
                    @{KEY_TEXT: MAIL, KEY_IMAGE: @"icon_mail"}
                    ];
}

#pragma mark -Model

- (void)setupModel {
    
    
}

- (void)loadModel {
    
}


#pragma mark - UITable view Delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return myInfoArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellIdentifier =@"shareCell";
    
    UITableViewCell *aCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (aCell == nil) {
        
        aCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    UIImageView *gImageView = (UIImageView *)[aCell viewWithTag:1];
    UILabel *gTitleLabel = (UILabel *)[aCell viewWithTag:2];
    
    gImageView.image = [UIImage imageNamed:myInfoArray[indexPath.row][KEY_IMAGE]];
    gTitleLabel.text = myInfoArray[indexPath.row][KEY_TEXT];
    
    return aCell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 10)];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [cell setLayoutMargins:UIEdgeInsetsMake(0, 10, 0, 10)];
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
    
    if ([myInfoArray[indexPath.row][KEY_TEXT] isEqualToString:FACEBOOK]) {
        
        [self shareTapped:FACEBOOK];
    }
    else if ([myInfoArray[indexPath.row][KEY_TEXT] isEqualToString:TWITTER]) {
        
        [self shareTapped:TWITTER];
    }
    else if ([myInfoArray[indexPath.row][KEY_TEXT] isEqualToString:WHATSAPP]) {
        
        [self shareTapped:WHATSAPP];
    }
    else if ([myInfoArray[indexPath.row][KEY_TEXT] isEqualToString:MESSAGES]) {
        
        [self shareTapped:MESSAGES];
    }
    else if ([myInfoArray[indexPath.row][KEY_TEXT] isEqualToString:MAIL]) {
        
        [self shareTapped:MAIL];
    }
}

#pragma mark - UIButton methods -

-(void)leftBarButtonTapEvent {
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

-(void)rightBarButtonTapEvent {
    
}


#pragma mark - Private Method

-(void) setUpLeftBarButton {
    
    self.navigationItem.leftBarButtonItem  = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(leftBarButtonTapEvent)];
    self.navigationController.navigationBar.tintColor = WHITE_COLOUR;
}


-(void)shareTapped:(NSString *)actionTitle {
    
    NSString *aLongText = @"Welcome to levare app";
    
    NSString *aShortText = @"Welcome to levare app";
    
    if ([actionTitle isEqualToString:TWITTER]) {
        
        
        [self twitterShareUsingSubject:aShortText];
    }
    else if ([actionTitle isEqualToString:WHATSAPP]) {
        
        [self whatsAppShareUsingSubject:aLongText];
    }
    else if ([actionTitle isEqualToString:FACEBOOK]) {
        [self facebookShare];
    }
    
    else if ([actionTitle isEqualToString:MAIL]) {
        NSString *aSubjectString = @"Welcome to levare app";
        [self mailShareUsingSubject:aSubjectString content:aLongText];
    }
    else if ([actionTitle isEqualToString:MESSAGES]) {
        
        [self showSMS:aLongText];
    }
}

- (void)twitterShareUsingSubject:aSubjectString {
    
    if (![HTTPMANAGER isNetworkRechable]) {
        
        [HELPER showNotificationSuccessIn:self withMessage:ALERT_NO_INTERNET];
    }
    else {
        
        if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
            
            SLComposeViewController *aController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
            
            [aController setInitialText:aSubjectString];
            
            
            aController.completionHandler = ^(SLComposeViewControllerResult result) {
                switch(result) {
                        
                    case SLComposeViewControllerResultCancelled: {
                        
                        [self shareResult: @"Failed to post in twitter"];
                    }
                        break;
                        
                    case SLComposeViewControllerResultDone: {
                        
                        [self shareResult:@"Posted successfully in twitter"];
                    }
                        break;
                }
            };
            
            [self.navigationController presentViewController:aController animated:YES completion:nil];
            
        } else {
            
            [HELPER showNotificationSuccessIn:self withMessage:@"Please sign in twitter to post"];
        }
    }
}

- (void)whatsAppShareUsingSubject:aSubjectString
{
    if (![HTTPMANAGER isNetworkRechable]) {
        
        [HELPER showNotificationSuccessIn:self withMessage:ALERT_NO_INTERNET];
    }
    else {
        
        NSString * urlWhats = [NSString stringWithFormat:@"whatsapp://send?text=%@",[HELPER stringByEncodingString:aSubjectString]];
        
        NSURL * whatsappURL = [NSURL URLWithString:urlWhats ];
        
        if ([[UIApplication sharedApplication] respondsToSelector:@selector(openURL:options:completionHandler:)]) {
            [[UIApplication sharedApplication] openURL:whatsappURL options:@{} completionHandler:^(BOOL success) {
                //  NSLog(@"Open %@: %d",scheme,success);
                if (!success) {
                    [HELPER showNotificationSuccessIn:self withMessage:@"Please sign in whatApp to post"];
                }
            }];
        }
        else if ([[UIApplication sharedApplication] canOpenURL: whatsappURL])
            [[UIApplication sharedApplication] openURL:whatsappURL];
        
        else
            [HELPER showNotificationSuccessIn:self withMessage:@"Please sign in whatApp to post"];
    }
}

- (void)mailShareUsingSubject:(NSString*)aSubjectString content:(NSString*)aContentString
{
    
    if (![HTTPMANAGER isNetworkRechable])
    {
        [HELPER showNotificationSuccessIn:self withMessage:ALERT_NO_INTERNET_DESC];
        
    }
    else
    {
        if ([MFMailComposeViewController canSendMail])
        {
            MFMailComposeViewController *composeViewController = [[MFMailComposeViewController alloc] init];
            [composeViewController setMailComposeDelegate:self];
            //[composeViewController setToRecipients:@[@"anglermobile2014@gmail.com"]];
            [composeViewController setSubject:aSubjectString];
            [composeViewController  setMessageBody:aContentString isHTML:YES];
            
            [self presentViewController:composeViewController animated:YES completion:nil];
            [[composeViewController navigationBar]setTintColor:[HELPER getColorFromHexaDecimal:COLOR_APP_PRIMARY]];
        }
        else
        {
            [HELPER showNotificationSuccessIn:self withMessage:@"Please configure your device for sending email"];
            
        }
    }
}

- (void)showSMS:(NSString*)aWishBody {
    
    if([MFMessageComposeViewController canSendText]) {
        NSArray *recipents;
        
        //recipents = @[@"9942747281"];
        
        MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
        messageController.messageComposeDelegate = self;
        [messageController setRecipients:recipents];
        [messageController setBody:aWishBody];
        [messageController setSubject:@"Send fulltank app feedback to"];
        
        // Present message view controller on screen
        [self presentViewController:messageController animated:YES completion:nil];
    }
    else
    {
        [HELPER showNotificationSuccessIn:self withMessage:@"Please insert a SIM to send SMS"];
    }
}


- (void)facebookShare {
    
    if (![HTTPMANAGER isNetworkRechable]) {
        
        [HELPER showNotificationSuccessIn:self withMessage:ALERT_NO_INTERNET];
    }
    else {
        
        if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
            
            SLComposeViewController *aController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
            
            //   [aController addImage:[UIImage imageNamed:IMAGE_LOGO]];
            aController.completionHandler = ^(SLComposeViewControllerResult result) {
                switch(result) {
                        
                    case SLComposeViewControllerResultCancelled: {
                        
                        [self shareResult: @"Failed to post in facebook"];
                    }
                        break;
                        
                    case SLComposeViewControllerResultDone: {
                        
                        [self shareResult:@"Posted successfully in facebook"];
                    }
                        break;
                }
            };
            
            [self.navigationController presentViewController:aController animated:YES completion:nil];
            
        } else {
            
            [HELPER showNotificationSuccessIn:self withMessage:@"Please sign in facebook to post"];
        }
    }
    
}

-(void)shareResult :(NSString *)aString {
    
    UIAlertController *alertController  = [UIAlertController alertControllerWithTitle:aString  message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction: [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        [self leftBarButtonTapEvent];
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - MFMailComposeDelegate -

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent: {
            
            if (result == MFMailComposeResultSent) {
                
                [self shareResult: @"mail send successfully"];
            }
            
            
            break;
        }
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            
            [self shareResult:@"Failed to send mail"];
            break;
            
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:^{
        
        if (result == MFMailComposeResultSent) {
            
            [self shareResult:@"Mail Send Successfully"];
            
        }
    }];
}

#pragma mark - MFMessageComposeDelegate -

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult) result
{
    switch (result) {
        case MessageComposeResultCancelled:
            break;
            
        case MessageComposeResultFailed:
        {
            [self shareResult:@"Failed to send SMS!"];
            break;
        }
            
        case MessageComposeResultSent:
            [self shareResult:@"SMS send successfully"];
            
            break;
            
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
