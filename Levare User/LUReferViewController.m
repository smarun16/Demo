

//
//  LUReferViewController.m
//  Levare User
//
//  Created by AngMac137 on 12/10/16.
//  Copyright © 2016 AngMac137. All rights reserved.
//

#import "LUReferViewController.h"

@interface LUReferViewController ()<MFMailComposeViewControllerDelegate,UIDocumentInteractionControllerDelegate, MFMessageComposeViewControllerDelegate>
{
    NSArray *myInfoArray;
    NSString *myPromoString;
}
@property (strong, nonatomic) IBOutlet UIImageView *myReferImageView;
@property (strong, nonatomic) IBOutlet UILabel *myReferLabel;
@property (strong, nonatomic) IBOutlet UICollectionView *myCollectionView;


@end

@implementation LUReferViewController

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
    
    [NAVIGATION setTitleWithBarButtonItems:TITLE_REFER forViewController:self showLeftBarButton:nil showRightBarButton:nil];
    [self setUpLeftBarButton];
    
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
    
    myPromoString = [SESSION getUserInfo][0][@"Promo_Code"];
    
    NSString *aString = [NSString stringWithFormat:@"Share your promo code %@ with friends and they will get their first ride free(upto $2). Once they have tried levare you will automatically get free ride(upto $2)next time you use levare",myPromoString];
    
    NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:aString];

    [mutableAttributedString addAttributes:@{NSForegroundColorAttributeName: [HELPER getColorFromHexaDecimal:COLOR_APP_PRIMARY],
                                             NSFontAttributeName: [UIFont boldSystemFontOfSize:15] } range:NSMakeRange(22, myPromoString.length)];
    
    _myReferLabel.attributedText = mutableAttributedString;
}

- (void)loadModel {
    
}

#pragma mark - CollectionView Methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (section == 0)
        return 3;
    else
        return 2;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellIdentifier =@"shareCell";
    
    UICollectionViewCell* aCell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    UIImageView *aImageView = [aCell viewWithTag:1];
    UILabel * aLabel = [aCell viewWithTag:2];
    
    if (indexPath.section == 0) {
        aImageView.image = [UIImage imageNamed:myInfoArray[indexPath.row][KEY_IMAGE]];
        aLabel.text = myInfoArray[indexPath.row][KEY_TEXT];
    }
    else {
        
        aImageView.image = [UIImage imageNamed:myInfoArray[indexPath.row + 3][KEY_IMAGE]];
        aLabel.text = myInfoArray[indexPath.row + 3][KEY_TEXT];
    }
    return aCell;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(4, 0, 4, 0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return (indexPath.section == 0) ? CGSizeMake((collectionView.frame.size.width/3)-10, (collectionView.frame.size.width/3)-10) : CGSizeMake((collectionView.frame.size.width/2)-10, (collectionView.frame.size.width/2)-10);
    
}

-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        if ([myInfoArray[indexPath.row][KEY_TEXT] isEqualToString:FACEBOOK]) {
            
            [self shareTapped:FACEBOOK];
        }
        else if ([myInfoArray[indexPath.row][KEY_TEXT] isEqualToString:TWITTER]) {
            
            [self shareTapped:TWITTER];
        }
        else if ([myInfoArray[indexPath.row][KEY_TEXT] isEqualToString:WHATSAPP]) {
            
            [self shareTapped:WHATSAPP];
        }
    }
    else {
        
        if ([myInfoArray[indexPath.row + 3][KEY_TEXT] isEqualToString:MESSAGES]) {
            
            [self shareTapped:MESSAGES];
        }
        else if ([myInfoArray[indexPath.row + 3][KEY_TEXT] isEqualToString:MAIL]) {
            
            [self shareTapped:MAIL];
        }
    }
}


#pragma mark - UIButton methods -

-(void)leftBarButtonTapEvent {
    
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
        if ([SESSION_2 isRequested] && ![SESSION_2 isAlertShown]) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:VIEW_UPADTE_BASED_ON_REQUEST_STATUS object:nil userInfo:nil];
            
        }
    }];
}

-(void)rightBarButtonTapEvent {
    
}

-(void) setUpLeftBarButton {
    
    self.navigationItem.leftBarButtonItem  = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(leftBarButtonTapEvent)];
    self.navigationController.navigationBar.tintColor = WHITE_COLOUR;
}

#pragma mark - Private Method

-(void)shareTapped:(NSString *)actionTitle {
    
    
    
    
   NSString *aLongText = [NSString stringWithFormat:@"Hi!\nYour friend %@ has sent you a promotion code that you can redeem with Levare!\n\nPlease use this promocode: %@\n\nIf you don’t already have the Levare Ride Share App then you can find it here:\n\nBest regards the Levare Team\n\nCourtesy of your friend:%@",[NSString stringWithFormat:@"%@%@",[SESSION getUserInfo][0][@"First_Name"],[SESSION getUserInfo][0][@"Last_Name"]],myPromoString,[NSString stringWithFormat:@"%@%@",[SESSION getUserInfo][0][@"First_Name"],[SESSION getUserInfo][0][@"Last_Name"]]];
    
    NSString *aShortText = [NSString stringWithFormat:@"Hi!\nYour friend %@ has sent you a promotion code that you can redeem with Levare!\nPlease use this promocode: %@",[NSString stringWithFormat:@"%@%@",[SESSION getUserInfo][0][@"First_Name"],[SESSION getUserInfo][0][@"Last_Name"]],myPromoString];
    
    
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
        NSString *aSubjectString = @"Levare App";
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
