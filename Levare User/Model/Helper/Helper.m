//
//  Helper.m
//
//  Copyright (c) 2015 ANGLER EIT. All rights reserved.
//

#import "Helper.h"

#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTCallCenter.h>
#import <CoreTelephony/CTCall.h>

#import "Loading.h"
#import "NetworkView.h"
#import "TSMessage.h"
#import "Levare-Swift.h"

@implementation Helper {
    
    Loading *myLoading;
    RetryCallBack myRetryCallBack;
    
    
}

+ (Helper *)sharedObject {
    
    static Helper *_sharedObject = nil;
    
    @synchronized (self) {
        if (!_sharedObject)
            _sharedObject = [[[self class] alloc] init];
    }
    
    return _sharedObject;
}

#pragma mark - Color and Image

- (UIColor *)getColorFromHexaDecimal:(NSString *)hexaDecimal {
    
    NSString *hexaDecimalColorCode = [[hexaDecimal stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    if ([hexaDecimalColorCode length] < 6) return [UIColor grayColor];
    
    if ([hexaDecimalColorCode hasPrefix:@"0X"]) hexaDecimalColorCode = [hexaDecimalColorCode substringFromIndex:2];
    
    if ([hexaDecimalColorCode length] != 6) return  [UIColor grayColor];
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *strR = [hexaDecimalColorCode substringWithRange:range];
    
    range.location = 2;
    NSString *strG = [hexaDecimalColorCode substringWithRange:range];
    
    range.location = 4;
    NSString *strB = [hexaDecimalColorCode substringWithRange:range];
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:strR] scanHexInt:&r];
    [[NSScanner scannerWithString:strG] scanHexInt:&g];
    [[NSScanner scannerWithString:strB] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

- (UIColor *)getColorFromHexaDecimal:(NSString *)hexaDecimal alpha:(float)alpha {
    
    NSString *hexaDecimalColorCode = [[hexaDecimal stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    if ([hexaDecimalColorCode length] < 6) return [UIColor grayColor];
    
    if ([hexaDecimalColorCode hasPrefix:@"0X"]) hexaDecimalColorCode = [hexaDecimalColorCode substringFromIndex:2];
    
    if ([hexaDecimalColorCode length] != 6) return  [UIColor grayColor];
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *strR = [hexaDecimalColorCode substringWithRange:range];
    
    range.location = 2;
    NSString *strG = [hexaDecimalColorCode substringWithRange:range];
    
    range.location = 4;
    NSString *strB = [hexaDecimalColorCode substringWithRange:range];
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:strR] scanHexInt:&r];
    [[NSScanner scannerWithString:strG] scanHexInt:&g];
    [[NSScanner scannerWithString:strB] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:alpha];
}

- (UIImage *)getImageFromColor:(UIColor *)color {
    
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)setBackgroundImageFor:(UIViewController *)controller imageNamed:(NSString *)imageName {
    
    UIGraphicsBeginImageContext(controller.view.frame.size);
    [[UIImage imageNamed:imageName] drawInRect:controller.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    controller.view.backgroundColor = [UIColor colorWithPatternImage:image];
}

- (void)setURLProfileImageForImageView:(UIImageView*)aImageView URL:(NSString*)aURLString placeHolderImage:(NSString*)aPlaceHolderImageString {
    
    aURLString = [aURLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *aURL = [NSURL URLWithString:aURLString];
    __weak UIImageView *imageView_ = aImageView;
    
    if (aPlaceHolderImageString == nil || aPlaceHolderImageString.length == 0) {
        
        [imageView_ sd_setImageWithURL:aURL placeholderImage:[UIImage imageNamed:IMAGE_NO_PROFILE] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image == NULL)
                imageView_.image = [UIImage imageNamed:IMAGE_NO_PROFILE];
            else
                imageView_.image = image;
        }];
    }
    else {
        [imageView_ sd_setImageWithURL:aURL placeholderImage:[UIImage imageNamed:aPlaceHolderImageString] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image == NULL)
                imageView_.image = [UIImage imageNamed:aPlaceHolderImageString];
            else
                imageView_.image = image;
        }];
    }
}

- (NSString *)prefixWithWhiteSpaceForText:(NSString*)aTextString numberOfWhileSpace:(int)aNumberOfWhileSpaceInt {
    
    for (int i = 0 ; i < aNumberOfWhileSpaceInt; i++) {
        aTextString = [NSString stringWithFormat:@" %@",aTextString];
    }
    
    return aTextString;
}

- (NSString *)resetCardNumberAsVisa:(NSString*)originalString {

    NSMutableString *resultString = [NSMutableString string];
    
    for(int i = 0; i<[originalString length]/4; i++)
    {
        NSUInteger fromIndex = i * 4;
        NSUInteger len = [originalString length] - fromIndex;
        if (len > 4) {
            len = 4;
        }
        
        
        if (i == 2 || i == 1) {
            
            [resultString appendFormat:@"**** "];
        }
        else if (i == 3)
            [resultString appendFormat:@"%@ ",[originalString substringFromIndex:12]];

        else
            [resultString appendFormat:@"%@ ",[originalString substringWithRange:NSMakeRange(fromIndex, len)]];
    }
    return resultString;
}

#pragma mark -Image Rendring mode

- (void) getColorIgnoredImage:(NSString *)aImageString imageView:(UIImageView *)aImageView color: (UIColor *)aColor {
    
    aImageView.image = [[UIImage imageNamed:aImageString] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    aImageView.tintColor = aColor;
}


#pragma mark - Navigation Animation

- (void) addAnimationFor:(UIViewController *)controller {
    
    CATransition *transition = [CATransition animation];
    transition.duration = 1;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
    
    [controller.navigationController.view.layer addAnimation:transition forKey:nil];
}

#pragma mark - Loading

- (void)showLoadingAnimation {
    
    myLoading = [[Loading alloc] init];
    [APPDELEGATE.window addSubview:myLoading];
    [myLoading show];
}

- (void)removeLoadingAnimation {
    
    [myLoading hide];
}

#pragma mark - Date

- (NSString *)getCurrentDateInFormat:(NSString *)format {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    NSString *currentDate = [dateFormatter stringFromDate:[NSDate date]];
    
    return currentDate;
}

- (NSString *)getConvertedDateFormatFrom:(NSString *)oldFormat to:(NSString *)newFormat forDateTime: (NSString *)dateTime {
    
    NSString *convertedDateTime;
    
    if (dateTime.length == 10 && oldFormat.length == 0)
        dateTime = [NSString stringWithFormat:@"%@ 00:00:00", dateTime];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    
    if (oldFormat.length != 0)
        [dateFormatter setDateFormat:oldFormat];
    else
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *orignalDate = [dateFormatter dateFromString:dateTime];
    
    
    if (newFormat.length != 0)
        [dateFormatter setDateFormat:newFormat];
    else
        [dateFormatter setDateFormat:@"MMM dd, yyyy hh:mm a"];
    
    convertedDateTime = [dateFormatter stringFromDate:orignalDate];
    
    return convertedDateTime;
}

- (NSString *)getNextDateFrom:(NSString *)dateTime inFormat:(NSString *)dateFormat daysCount :(NSInteger)daysCount {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [NSDateComponents new];
    components.day = daysCount;
    NSDate *nextDate = [calendar dateByAddingComponents:components toDate:[NSDate date] options:0];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    if (dateFormat.length != 0)
        [dateFormatter setDateFormat:dateFormat];
    else
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    [dateFormatter setDateFormat:dateFormat];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    NSString *formattedNextDate = [dateFormatter stringFromDate:nextDate];
    
    return formattedNextDate;
}

- (NSString *)getConvertedDateFormatFrom:(NSString *)oldFormat to:(NSString *)newFormat forDate: (NSDate *)date {
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    
    if (oldFormat.length != 0)
        [dateFormatter setDateFormat:oldFormat];
    else
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    if (newFormat.length != 0) {
        [dateFormatter setDateFormat:newFormat];
    }
    else
        [dateFormatter setDateFormat:@"MMM dd, yyyy hh:mm a"];
    
    return [dateFormatter stringFromDate:date];
}

- (NSDate *)getConvertedDateStringFormatFrom:(NSString *)oldFormat to:(NSString *)newFormat forDate: (NSDate *)date {
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    
    if (oldFormat.length != 0)
        [dateFormatter setDateFormat:oldFormat];
    else
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    if (newFormat.length != 0) {
        [dateFormatter setDateFormat:newFormat];
    }
    else
        [dateFormatter setDateFormat:@"MMM dd, yyyy hh:mm a"];
    
    return [dateFormatter dateFromString: [dateFormatter stringFromDate:date]];
}

#pragma mark - Call

- (BOOL)canDevicePlaceAPhoneCall {
    
    // Returns YES if the device can place a phone call
    
    // Check if the device can place a phone call
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tel://"]]) {
        
        // Device supports phone calls, lets confirm it can place one right now
        CTTelephonyNetworkInfo *netInfo = [[CTTelephonyNetworkInfo alloc] init];
        CTCarrier *carrier = [netInfo subscriberCellularProvider];
        NSString *mnc = [carrier mobileNetworkCode];
        
        if (([mnc length] == 0) || ([mnc isEqualToString:@"65535"])) {
            // Device cannot place a call at this time.  SIM might be removed.
            return NO;
        } else {
            // Device can place a phone call
            return YES;
        }
    } else {
        // Device does not support phone calls
        return  NO;
    }
}

- (BOOL)callToNumber:(NSString *)phoneNumber {
    
    if ([self canDevicePlaceAPhoneCall]) {
        
        NSString *telPrompt = [NSString stringWithFormat:@"telprompt://%@", [phoneNumber stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
        
        NSURL* callUrl = [NSURL URLWithString:telPrompt];
        
        if ([[UIApplication sharedApplication] canOpenURL:callUrl]) {
            
            [[UIApplication sharedApplication] openURL:callUrl];
            return YES;
        }
    }
    
    return NO;
}

#pragma mark - change root View

- (void)changeRootViewController:(UIViewController*)viewController scaleIn:(BOOL)shouldScaleIn {
    
    if (!APPDELEGATE.window.rootViewController) {
        APPDELEGATE.window.rootViewController = viewController;
        return;
    }
    
    UIView *snapShot = [APPDELEGATE.window snapshotViewAfterScreenUpdates:YES];
    
    [viewController.view addSubview:snapShot];
    
    APPDELEGATE.window.rootViewController = viewController;
    
    float scale = shouldScaleIn ? 0.5 : 1.5;
    
    [UIView animateWithDuration:0.5 animations:^{
        snapShot.layer.opacity = 0;
        snapShot.layer.transform = CATransform3DMakeScale(scale, scale, scale);
    } completion:^(BOOL finished) {
        [snapShot removeFromSuperview];
    }];
}


#pragma mark - Http Format

- (NSString *)addHttpIfNeedIn:(NSString *)httpUrl {
    
    NSString *aStrHttpUrl = httpUrl;
    NSRange aRangeHttpFormat = [aStrHttpUrl rangeOfString:@"http"];
    
    if (aRangeHttpFormat.location == NSNotFound) {
        
        NSString *aStrAddHttp = @"http://";
        aStrHttpUrl = [aStrAddHttp stringByAppendingString:httpUrl];
    }
    
    return aStrHttpUrl;
}

- (NSURL *)getYoutubeImageUrlFor:(NSString *)videoUrl {
    
    NSArray *aAry = [videoUrl componentsSeparatedByString:@"/"];
    NSString *aStrTemp = [aAry objectAtIndex:([aAry count] - 1)];
    NSArray *aAryTemp = [aStrTemp componentsSeparatedByString:@"="];
    
    if (aAryTemp.count != 0)
        aStrTemp = [aAryTemp objectAtIndex:([aAryTemp count] - 1)];
    
    NSString *aStrUrl = [NSString stringWithFormat:@"http://img.youtube.com/vi/%@/0.jpg", aStrTemp];
    NSURL *imageUrl = [NSURL URLWithString:aStrUrl];
    
    return imageUrl;
}

- (void)rateUsFeatureUsingViewController:(UIViewController *)viewController {
    
    if ([HTTPMANAGER isNetworkRechable]) {
        
        NSString *appName = [NSString stringWithString:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"]];
        NSURL *appStoreURL = [NSURL URLWithString:[NSString stringWithFormat:@"itms-apps://itunes.com/app/%@",[appName stringByReplacingOccurrencesOfString:@" " withString:@""]]];
        [[UIApplication sharedApplication] openURL:appStoreURL];
    }
    else {
        [HELPER showAlertView:viewController title:APP_NAME message:ALERT_NO_INTERNET];
    }
}

- (NSURL *)URLPercentageDecode:(NSString*)url {
    
    NSString *decodedUrlImage = [url stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    decodedUrlImage = [decodedUrlImage stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return [NSURL URLWithString:[decodedUrlImage stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
}

#pragma mark - Utilities

-(BOOL)isText:(NSString *)text {
    
    return [self isMatchInString:@"[a-zA-Z]" text:text];
}
- (BOOL)isDigit:(NSString*)text {
    
    return [self isMatchInString:KEY_FORMAT_DIGIT text:text];
}

- (BOOL)isPhoneNumber:(NSString*)text {
    
    return [self isMatchInString:KEY_FORMAT_PHONE text:text];
}

- (BOOL)isMatchInString: (NSString *)format text: (NSString *)text {
    
    NSRegularExpression *regExpression = [NSRegularExpression regularExpressionWithPattern:format options:0 error:nil];
    
    if ([regExpression numberOfMatchesInString:text options:0 range:NSMakeRange(0, text.length)] >= 1) {
        return YES;
    } else {
        return NO;
    }
}

- (NSString *) getAppVersion {
    
    return [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
}

- (NSString *) getBuild {
    
    return [[NSBundle mainBundle] objectForInfoDictionaryKey: (NSString *)kCFBundleVersionKey];
}

- (NSString *) getVersionBuild {
    
    NSString * version = [self getAppVersion];
    NSString * build = [self getBuild];
    
    NSString * versionBuild = [NSString stringWithFormat: @"v%@", version];
    
    if (![version isEqualToString: build]) {
        versionBuild = [NSString stringWithFormat: @"%@(%@)", versionBuild, build];
    }
    
    return versionBuild;
}

#pragma - Notification Count

- (void)setNotificationBadgeCount {
    
    NSInteger badgeCount = [UIApplication sharedApplication].applicationIconBadgeNumber;
    [SESSION setNotificationBadge:@(badgeCount).stringValue];
}


#pragma mark - Drop Shadow

- (void)addDropShadowToView:(UIView*)aView {
    [self addDropShadowToView:aView withShadowColor:[UIColor blackColor] cornerRadius:0.0];
}

- (void)addDropShadowToView:(UIView*)aView withShadowColor:(UIColor*)aColor {
    
    [self addDropShadowToView:aView withShadowColor:aColor cornerRadius:0.0];
}

- (void)addDropShadowToView:(UIView*)aView cornerRadius:(float)aRadius {
    
    [self addDropShadowToView:aView withShadowColor:[UIColor blackColor] cornerRadius:aRadius];
}

- (void)addDropShadowToView:(UIView*)aView withShadowColor:(UIColor*)aColor cornerRadius:(float)aRadius {
    
    // Add drop shadow to created view
    aView.layer.masksToBounds = NO;
    aView.layer.shadowColor = aColor.CGColor;
    aView.layer.shadowOffset = CGSizeMake(0.0f, 0.2f);
    aView.layer.shadowOpacity = 0.6f;
    
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRoundedRect:aView.bounds cornerRadius:aRadius];
    aView.layer.shadowPath = shadowPath.CGPath;
}

- (void)addFloatingEffectToView:(UIView *)aView {
    
    [self roundCornerForView:aView];
    [self addDropShadowToView:aView cornerRadius:CGRectGetWidth(aView.bounds) * 0.5];
}

- (void)addDropShadowToTableview:(UITableView *)aTableView {
    
    CALayer *sublayer = [CALayer layer];
    sublayer.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.6].CGColor;
    sublayer.shadowOffset = CGSizeMake(0, -3);
    sublayer.shadowRadius = 5.0;
    sublayer.shadowColor = [UIColor blackColor].CGColor;
    sublayer.shadowOpacity = 1.0;
    sublayer.cornerRadius = 5.0;
    sublayer.frame = CGRectMake(aTableView.frame.origin.x, aTableView.frame.origin.y, aTableView.frame.size.width, aTableView.frame.size.height);
    [aTableView.superview.layer addSublayer:sublayer];
    
    [aTableView.superview.layer addSublayer:aTableView.layer];
    
}

-(UIImageView *)imageWithRenderingMode:(NSString *)imageName color:(UIColor *)aColor imageView:(UIImageView *)aImageView {
    
    UIImage *aEventImage = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    aImageView.image = aEventImage;
    [aImageView setTintColor:aColor];
    
    return aImageView;
}

- (void)changeRootViewController:(UIViewController*)viewController {
    
    if (!APPDELEGATE.window.rootViewController) {
        APPDELEGATE.window.rootViewController = viewController;
        return;
    }
    
    UIView *snapShot = [APPDELEGATE.window snapshotViewAfterScreenUpdates:YES];
    
    [viewController.view addSubview:snapShot];
    
    APPDELEGATE.window.rootViewController = viewController;
    
    [UIView animateWithDuration:0.5 animations:^{
        snapShot.layer.opacity = 0;
    } completion:^(BOOL finished) {
        [snapShot removeFromSuperview];
    }];
}

#pragma mark - Rounded Corner View

- (void)roundCornerForView:(UIView*)view radius:(float)radius borderColor:(UIColor*)color {
    
    view.layer.cornerRadius = radius;
    view.layer.borderWidth = 1;
    view.layer.borderColor = color.CGColor;
    view.clipsToBounds = YES;
}



- (void)roundCornerForView:(UIView*)view andBorderColor:(UIColor*)color {
    
    [self roundCornerForView:view radius:CGRectGetHeight(view.frame) * 0.5 borderColor:color];
}

- (void)roundCornerForView:(UIView*)view withRadius:(float)radius {
    
    [self roundCornerForView:view radius:radius borderColor:[UIColor clearColor]];
}

- (void)roundCornerForView:(UIView*)view withRadius:(float)radius andBorderColor:(UIColor*)color {
    
    [self roundCornerForView:view radius:radius borderColor:color];
}

- (void)roundCornerForView:(UIView*)view {
    
    [self roundCornerForView:view radius:CGRectGetHeight(view.frame) * 0.5 borderColor:[UIColor clearColor]];
}



#pragma mark - TSMessage Notification Alert

- (void)showNotificationErrorIn:(UIViewController*)controller withMessage:(NSString*)message {
    
    [self showNavBarOverlayAlertForType:TSMessageNotificationTypeError controller:controller withTitle:message];
}

- (void)showNotificationSuccessIn:(UIViewController*)controller withMessage:(NSString*)message {
    
    [self showNavBarOverlayAlertForType:TSMessageNotificationTypeSuccess controller:controller withTitle:message];
}

- (void)showNotificationInfoIn:(UIViewController*)controller withMessage:(NSString*)message {
    
    [self showNavBarOverlayAlertForType:TSMessageNotificationTypeMessage controller:controller withTitle:message];
}

- (void)showNotificationWarningIn:(UIViewController*)controller withMessage:(NSString*)message {
    
    [self showNavBarOverlayAlertForType:TSMessageNotificationTypeWarning controller:controller withTitle:message];
}

- (void)showNavBarOverlayAlertForType:(TSMessageNotificationType)type controller:(UIViewController*)controller withTitle:(NSString*)title {
    
    [TSMessage addCustomDesignFromFileWithName:@"TSMessageDesign.json"];
    [TSMessage showNotificationInViewController:controller.navigationController
                                          title:APP_NAME
                                       subtitle:title
                                          image:nil
                                           type:type
                                       duration:TSMessageNotificationDurationAutomatic
                                       callback:nil
                                    buttonTitle:nil
                                 buttonCallback:nil
                                     atPosition:TSMessageNotificationPositionNavBarOverlay
                           canBeDismissedByUser:YES];
    
}

- (void)showFBStyleErrorAlertIn:(UIViewController*)controller withMessage:(NSString*)message {
    
    [TSMessage addCustomDesignFromFileWithName:@"TSMessageDesign.json"];
    [TSMessage showNotificationInViewController:controller
                                          title:@""
                                       subtitle:message
                                          image:nil
                                           type:TSMessageNotificationTypeError
                                       duration:TSMessageNotificationDurationEndless
                                       callback:nil
                                    buttonTitle:nil
                                 buttonCallback:nil
                                     atPosition:TSMessageNotificationPositionTop
                           canBeDismissedByUser:YES];
}

#pragma mark
#pragma mark - In-View Loading For Viewcontroller
#pragma mark

const int TAG_RETRY = 1000;
const int TAG_ALERT = 1001;
const int TAG_LOADING = 1002;

- (UIView *)showLoadingIn:(UIViewController *)aViewController {
    
    return [self showLoadingIn:aViewController text:@"Loading..."];
}

- (UIView *)showLoadingIn:(UIViewController *)aViewController text:(NSString *)aText {
    
    [self removeRetryAlertAndImageAlertIn:aViewController];
    
    NetworkView *aLoadingView = (NetworkView *)[aViewController.view viewWithTag:TAG_LOADING];
    
    if (aLoadingView) {
        
        [aViewController.view bringSubviewToFront:aLoadingView];
        return aLoadingView;
    }
    
    aLoadingView = [self createAlertViewIn:aViewController.view withTag:TAG_LOADING];
    aLoadingView.loadingLabel.text = aText;
    aLoadingView.loadingLabel.textColor = [HELPER getColorFromHexaDecimal:COLOR_APP_PRIMARY];
    
    [aViewController.view layoutIfNeeded];
    
    [UIView animateWithDuration:0.2 animations:^{
        
        aLoadingView.alpha = 1;
    } completion:nil];
    
    
    return aLoadingView;
}

- (void)removeLoadingIn:(UIViewController *)aViewController {
    
    UIView *aLoadingView = [aViewController.view viewWithTag:TAG_LOADING];
    
    if (aLoadingView) {
        
        [UIView animateWithDuration:0.1 animations:^{
            
            aLoadingView.alpha = 0;
        } completion:^(BOOL finished) {
            
            [aLoadingView removeFromSuperview];
        }];
    }
}


#pragma mark - In-View Loading For View

- (UIView *)showLoadingInView:(UIView *)aView text:(NSString *)aText {
    
    //[self removeRetryAlertAndImageAlertInView:aView];
    //[self removeAlertInView:aView];
    
    NetworkView *aLoadingView = (NetworkView *)[aView viewWithTag:TAG_LOADING];
    
    if (aLoadingView) {
        
        [aView bringSubviewToFront:aLoadingView];
        return aLoadingView;
    }
    
    aLoadingView = [self createAlertViewIn:aView withTag:TAG_LOADING];
    aLoadingView.loadingLabel.text = aText;
    aLoadingView.loadingLabel.textColor = [HELPER getColorFromHexaDecimal:COLOR_APP_PRIMARY];
    
    [aView layoutIfNeeded];
    
    [UIView animateWithDuration:0.2 animations:^{
        
        aLoadingView.alpha = 1;
    } completion:nil];
    
    return aLoadingView;
}

- (void)removeLoadingInView:(UIView *)aView {
    
    UIView *aLoadingView = [aView viewWithTag:TAG_LOADING];
    
    if (aLoadingView) {
        
        [UIView animateWithDuration:0.1 animations:^{
            
            aLoadingView.alpha = 0;
        } completion:^(BOOL finished) {
            
            [aLoadingView removeFromSuperview];
        }];
    }
}

- (void)removeRetryAlertAndImageAlertInView:(UIView*)aView {
    
    [self removeAlertInView:aView];
    [self removeRetryAlertInView:aView];
}


- (void)removeAlertInView:(UIView *)aView {
    
    UIView *aAlertView = [aView viewWithTag:TAG_ALERT];
    [self removeFromSuperviewWithAnimation:aAlertView];
}

- (void)removeRetryAlertInView:(UIView *)aView {
    
    UIView *aRetryAlertView = [aView viewWithTag:TAG_RETRY];
    [self removeFromSuperviewWithAnimation:aRetryAlertView];
}

#pragma mark - Navigation Bar for story Board -

-(void)setNavigationBarTitle:(NSString *)aTitle backButton:(NSString *)aBackButtonTitle {
    
    
}

#pragma mark - In-View Alert(With or Without retry)

- (UIView *)showRetryAlertIn:(UIViewController *)aViewController details:(NSDictionary *)aDetailsInfo retryBlock:(RetryCallBack)aRetryCallBack {
    
    [self removeAlertIn:aViewController];
    
    NetworkView *aRetryAlert = (NetworkView *)[aViewController.view viewWithTag:TAG_RETRY];
    
    if (aRetryAlert) {
        
        aRetryAlert.alertTitle.text = aDetailsInfo[KEY_ALERT_TITLE];
        aRetryAlert.alertDescription.text = aDetailsInfo[KEY_ALERT_DESC];
        aRetryAlert.alertImageView.image = [UIImage imageNamed:aDetailsInfo[KEY_ALERT_IMAGE]];
        
        [aViewController.view bringSubviewToFront:aRetryAlert];
        
        return aRetryAlert;
    }
    
    aRetryAlert = [self createAlertViewIn:aViewController.view withTag:TAG_RETRY];
    
    aRetryAlert.alertTitle.text = aDetailsInfo[KEY_ALERT_TITLE];
    aRetryAlert.alertDescription.text = aDetailsInfo[KEY_ALERT_DESC];
    aRetryAlert.alertImageView.image = [UIImage imageNamed:aDetailsInfo[KEY_ALERT_IMAGE]];
    
    myRetryCallBack = aRetryCallBack;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapEvent:)];
    [aRetryAlert addGestureRecognizer:tapGesture];
    
    [UIView animateWithDuration:0.2 animations:^{
        
        aRetryAlert.alpha = 1;
    } completion:nil];
    
    return aRetryAlert;
    
}

- (UIView *)showAlertIn:(UIViewController *)aViewController details:(NSDictionary *)aDetailsInfo colorCode:(NSString *)aStrColorCode {
    
    [self removeRetryAlertIn:aViewController];
    
    NetworkView *aAlert = (NetworkView *)[aViewController.view viewWithTag:TAG_ALERT];
    
    if (aAlert) {
        
        aAlert.alertTitle.text = aDetailsInfo[KEY_ALERT_TITLE];
        aAlert.alertDescription.text = aDetailsInfo[KEY_ALERT_DESC];
        
        if (aStrColorCode.length == 0)
            aAlert.alertImageView.image = [UIImage imageNamed:aDetailsInfo[KEY_ALERT_IMAGE]];
        
        else
            [self imageWithRenderingMode:aDetailsInfo[KEY_ALERT_IMAGE] color:[self getColorFromHexaDecimal:aStrColorCode] imageView:aAlert.alertImageView];
        
        [aViewController.view bringSubviewToFront:aAlert];
        
        return aAlert;
    }
    
    aAlert = [self createAlertViewIn:aViewController.view withTag:TAG_ALERT];
    
    aAlert.alertTitle.text = aDetailsInfo[KEY_ALERT_TITLE];
    aAlert.alertDescription.text = aDetailsInfo[KEY_ALERT_DESC];
    
    if (aStrColorCode.length == 0)
        aAlert.alertImageView.image = [UIImage imageNamed:aDetailsInfo[KEY_ALERT_IMAGE]];
    
    else
        [self imageWithRenderingMode:aDetailsInfo[KEY_ALERT_IMAGE] color:[self getColorFromHexaDecimal:aStrColorCode] imageView:aAlert.alertImageView];
    
    [UIView animateWithDuration:0.2 animations:^{
        
        aAlert.alpha = 1;
    } completion:nil];
    
    return aAlert;
}


- (void)tapEvent:(UIGestureRecognizer *)sender {
    
    NetworkView *aView = (NetworkView *) sender.view;
    
    [UIView animateWithDuration:0.2 animations:^{
        
        aView.alertContainer.transform = CGAffineTransformMakeScale(0.9, 0.9);
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.2 animations:^{
            
            aView.alertContainer.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            
            if (myRetryCallBack) {
                myRetryCallBack();
            }
        }];
    }];
}

- (void)removeAlertIn:(UIViewController *)aViewController {
    
    UIView *aAlertView = [aViewController.view viewWithTag:TAG_ALERT];
    [self removeFromSuperviewWithAnimation:aAlertView];
}

- (void)removeRetryAlertIn:(UIViewController *)aViewController {
    
    UIView *aRetryAlertView = [aViewController.view viewWithTag:TAG_RETRY];
    [self removeFromSuperviewWithAnimation:aRetryAlertView];
}

- (void)removeRetryAlertAndImageAlertIn:(UIViewController *)aViewController {
    
    [self removeAlertIn:aViewController];
    [self removeRetryAlertIn:aViewController];
}

- (void)removeFromSuperviewWithAnimation:(UIView *)aView {
    
    if (aView) {
        
        [UIView animateWithDuration:0.0 animations:^{
            
            aView.alpha = 0;
        } completion:^(BOOL finished) {
            
            [aView removeFromSuperview];
        }];
    }
}

- (NetworkView *)createAlertViewIn:(UIView *)aView withTag:(int)aTag {
    
    NetworkView *aAlert = [[NetworkView alloc] init];
    aAlert.backgroundColor = [UIColor whiteColor];
    aAlert.translatesAutoresizingMaskIntoConstraints = NO;
    aAlert.alpha = 0;
    aAlert.tag = aTag;
    
    [aView addSubview:aAlert];
    
    // Update Constraints
    {
        NSLayoutConstraint *aTopLayoutConstraint = [NSLayoutConstraint constraintWithItem:aAlert attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:aView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
        
        NSLayoutConstraint *aBottomLayoutConstraint = [NSLayoutConstraint constraintWithItem:aAlert attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:aView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
        
        NSLayoutConstraint *aLeftLayoutConstraint = [NSLayoutConstraint constraintWithItem:aAlert attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:aView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
        
        NSLayoutConstraint *aRightLayoutConstraint = [NSLayoutConstraint constraintWithItem:aAlert attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:aView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
        
        [aView addConstraints:@[aTopLayoutConstraint,aBottomLayoutConstraint,aLeftLayoutConstraint,aRightLayoutConstraint]];
    }
    
    switch (aTag) {
        case TAG_RETRY:
        {
            aAlert.alertContainer.hidden = NO;
            aAlert.loadingContainer.hidden = YES;
        }
            break;
        case TAG_LOADING:
        {
            aAlert.alertContainer.hidden = YES;
            aAlert.loadingContainer.hidden = NO;
            
            aAlert.progressRing.indeterminate = YES;
            aAlert.progressRing.secondaryColor = [HELPER getColorFromHexaDecimal:COLOR_APP_PRIMARY];
        }
            break;
        case TAG_ALERT:
        {
            aAlert.alertContainer.hidden = NO;
            aAlert.loadingContainer.hidden = YES;
        }
    }
    
    return aAlert;
}

#pragma mark - TransformMakeTranslationView
- (void)slideUpViewTransFormMakeTranslationView :(UIView *)aView {
    
    [UIView animateWithDuration:0.3 animations:^{
        
        aView.transform = CGAffineTransformMakeTranslation(0, -250);
        
    } completion:^(BOOL finished) {
        
    }];
}

- (void)slideDownViewTransFormMakeTranslationView :(UIView *)aView {
    
    [UIView animateWithDuration:0.3 animations:^{
        
        aView.transform = CGAffineTransformMakeTranslation(0, 0);
        
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - UIRefreshControl

- (void)setAttributedTextToRefreshController:(UIRefreshControl *)refreshControl message :(NSString *)message
{
    NSString *aStrMsg;
    
    /* if ([message isEqualToString:KEY_FIRSTTIME]) {
     
     aStrMsg = @"Loading..";
     }
     else {
     
     aStrMsg = message.length != 0 ? [NSString stringWithFormat:@"Last updated: %@", [RTCHELPER convertDateTimeFormatForUI:message]] : @"Loading..";
     }*/
    
    NSDictionary *aDictAttributes = [[NSDictionary alloc] initWithObjectsAndKeys:[UIColor grayColor],NSForegroundColorAttributeName, [UIFont systemFontOfSize:11], NSFontAttributeName, nil];
    
    NSAttributedString *aAttributedString = [[NSAttributedString alloc] initWithString:message attributes:aDictAttributes];
    
    refreshControl.attributedTitle = aAttributedString;
}

- (void)showAlertView:(UIViewController*)aViewController title:(NSString *)aTitle message:(NSString *)aMessage {
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:aTitle
                                  message:aMessage preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction * Ok = [UIAlertAction
                          actionWithTitle:@"Ok"
                          style:UIAlertActionStyleDefault
                          handler:^(UIAlertAction * action)
                          {
                              [alert dismissViewControllerAnimated:YES completion:^{
                                  
                              }];
                          }];
    [alert addAction:Ok];
    
    [aViewController presentViewController:alert animated:YES completion:nil];
}

- (void)showAlertView:(UIViewController*)aViewController title:(NSString *)aTitle message:(NSString *)aMessage okButtonBlock:(void (^)(UIAlertAction *action))okAction {
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:aTitle
                                  message:aMessage preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction * Ok = [UIAlertAction
                          actionWithTitle:@"Ok"
                          style:UIAlertActionStyleDefault
                          handler:^(UIAlertAction * action)
                          {
                              if (okAction) {
                                  okAction(action);
                              }
                          }];
    [alert addAction:Ok];
    
    [aViewController presentViewController:alert animated:YES completion:nil];
}


- (void)showAlertView:(UIViewController*)aViewController title:(NSString *)aTitle  message:(NSString *)aMessage okButton:(NSString *)aOkButton style:(UIAlertActionStyle )aStyle {
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:aTitle
                                  message:aMessage preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction * Ok = [UIAlertAction
                          actionWithTitle:aOkButton
                          style:aStyle
                          handler:^(UIAlertAction * action)
                          {
                              [aViewController dismissViewControllerAnimated:YES completion:^{
                                  
                              }];
                          }];
    [alert addAction:Ok];
    
    [aViewController presentViewController:alert animated:YES completion:nil];
}

- (void)showAlertViewWithTitle:(UIViewController*)aViewController title:(NSString *)aTitle  message:(NSString *)aMessage okButton:(NSString *)aOkButton cancelButton:(NSString *)aCancelButton style:(UIAlertActionStyle )aStyle okButtonBlock:(void (^)(UIAlertAction *action))okAction cancelButtonBlock:(void (^)(UIAlertAction * action))cancelAction isLeftAlign:(BOOL)isLeftAlign {
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:aTitle
                                  message:aMessage preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction * Ok = [UIAlertAction
                          actionWithTitle:aOkButton
                          style:aStyle
                          handler:^(UIAlertAction * action)
                          {
                              if (okAction)
                                  okAction(action);
                          }];
    UIAlertAction * cancel = [UIAlertAction
                              actionWithTitle:aCancelButton
                              style:UIAlertActionStyleDestructive
                              handler:^(UIAlertAction * action)
                              {
                                  if (cancelAction)
                                      cancelAction(action);
                              }];
    
    [alert addAction:Ok];
    [alert addAction:cancel];
    
    if (isLeftAlign) {
        NSArray *viewArray = [[[[[[[[[[[[alert view] subviews] firstObject] subviews] firstObject] subviews] firstObject] subviews] firstObject] subviews] firstObject] subviews];
        UILabel *alertMessage = viewArray[1];
        alertMessage.textAlignment = NSTextAlignmentLeft;
    }
    [aViewController presentViewController:alert animated:YES completion:nil];
}

- (void)showAlertViewWithLeftAlignement:(UIViewController*)aViewController title:(NSString *)aTitle  message:(NSString *)aMessage okButton:(NSString *)aOkButton style:(UIAlertActionStyle )aStyle {
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:aTitle
                                  message:aMessage preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction * Ok = [UIAlertAction
                          actionWithTitle:aOkButton
                          style:aStyle
                          handler:^(UIAlertAction * action) {
                              
                              [aViewController dismissViewControllerAnimated:YES completion:^{
                                  
                              }];
                          }];
    [alert addAction:Ok];
    
    NSArray *viewArray = [[[[[[[[[[[[alert view] subviews] firstObject] subviews] firstObject] subviews] firstObject] subviews] firstObject] subviews] firstObject] subviews];
    // UILabel *alertTitle = viewArray[0];
    UILabel *alertMessage = viewArray[1];
    alertMessage.textAlignment = NSTextAlignmentLeft;
    
    [aViewController presentViewController:alert animated:YES completion:nil];
}

- (void)showAlertViewWithCancel:(UIViewController*)aViewController title:(NSString *)aTitle okButtonBlock:(void (^)(UIAlertAction *action))okAction cancelButtonBlock:(void (^)(UIAlertAction * action))cancelAction {
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:APP_NAME
                                  message:aTitle preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction * Ok = [UIAlertAction
                          actionWithTitle:@"Cancel"
                          style:UIAlertActionStyleDefault
                          handler:^(UIAlertAction * action)
                          {
                              if (cancelAction)
                                  cancelAction(action);
                          }];
    UIAlertAction * cancel = [UIAlertAction
                              actionWithTitle:@"OK"
                              style:UIAlertActionStyleDestructive
                              handler:^(UIAlertAction * action)
                              {
                                  if (okAction)
                                      okAction(action);
                              }];
    [alert addAction:Ok];
    [alert addAction:cancel];
    
    [aViewController presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Project Oriented Methods

// Fade in-out animation
- (void)fadeAnimationFor:(UIView*)aView alpha:(float)aAlphaValue duration:(float)aDurationFloat {
    
    [UIView animateWithDuration:aDurationFloat delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        aView.alpha = aAlphaValue;
        
    } completion:^(BOOL finished) {
        
    }];
}

// Fade in-out animation with default duration of 0.3
- (void)fadeAnimationFor:(UIView*)aView alpha:(float)aAlphaValue {
    
    [self fadeAnimationFor:aView alpha:aAlphaValue duration:0.5];
}

- (void)addBubbleEffectForView:(UIView *)aView {
    
    aView.layer.cornerRadius = aView.frame.size.width / 2;
    
    //create an animation to follow a circular path
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    //interpolate the movement to be more smooth
    pathAnimation.calculationMode = kCAAnimationPaced;
    //apply transformation at the end of animation (not really needed since it runs forever)
    pathAnimation.fillMode = kCAFillModeForwards;
    pathAnimation.removedOnCompletion = NO;
    //run forever
    pathAnimation.repeatCount = INFINITY;
    //no ease in/out to have the same speed along the path
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    pathAnimation.duration = 5.0;
    
    int deltaHeight = CGRectGetHeight(aView.frame) * 0.55;
    int inset = [self getRandowNumberBetween:deltaHeight max:deltaHeight + 5];
    //The circle to follow will be inside the circleContainer frame.
    //it should be a frame around the center of your view to animate.
    //do not make it to large, a width/height of 3-4 will be enough.
    CGMutablePathRef curvedPath = CGPathCreateMutable();
    CGRect circleContainer = CGRectInset(aView.frame, inset, inset);
    CGPathAddEllipseInRect(curvedPath, NULL, circleContainer);
    
    //add the path to the animation
    pathAnimation.path = curvedPath;
    
    //release path
    CGPathRelease(curvedPath);
    //add animation to the view's layer
    [aView.layer addAnimation:pathAnimation forKey:@"myCircleAnimation"];
    
    
    //create an animation to scale the width of the view
    CAKeyframeAnimation *scaleX = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale.x"];
    //set the duration
    scaleX.duration = [self randomFloat:1.5 max:2.5];
    //it starts from scale factor 1, scales to 1.05 and back to 1
    scaleX.values = @[@1.0, @1.05, @1.0];
    //time percentage when the values above will be reached.
    //i.e. 1.05 will be reached just as half the duration has passed.
    scaleX.keyTimes = @[@0.0, @0.5, @1.0];
    //keep repeating
    scaleX.repeatCount = INFINITY;
    //play animation backwards on repeat (not really needed since it scales back to 1)
    scaleX.autoreverses = YES;
    //ease in/out animation for more natural look
    scaleX.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    //add the animation to the view's layer
    [aView.layer addAnimation:scaleX forKey:@"scaleXAnimation"];
    
    //create the height-scale animation just like the width one above
    //but slightly increased duration so they will not animate synchronously
    CAKeyframeAnimation *scaleY = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale.y"];
    scaleY.duration = 1.5;
    scaleY.values = @[@1.0, @1.05, @1.0];
    scaleY.keyTimes = @[@0.0, @0.5, @1.0];
    scaleY.repeatCount = INFINITY;
    scaleY.autoreverses = YES;
    scaleX.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [aView.layer addAnimation:scaleY forKey:@"scaleYAnimation"];
    
}

//! View Transition Animation (Text change, color change etc). Cross Dissolve animation
- (void)transitionAnimationFor:(UIView*)aView duration:(float)aDurationFloat withAnimationBlock:(void(^)())animationBlock {
    [UIView transitionWithView:aView duration:aDurationFloat options:UIViewAnimationOptionTransitionCrossDissolve | UIViewAnimationOptionAllowAnimatedContent animations:^{
        animationBlock();
    } completion:nil];
}


- (void)rotateAnimationFor:(UIView *)aView rotateInfiniteTime:(BOOL)isInfinite {
    
    if ([aView.layer animationForKey:@"SpinAnimation"] == nil) {
        CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        animation.fromValue = [NSNumber numberWithFloat:0.0f];
        animation.toValue = [NSNumber numberWithFloat: 2 * M_PI];
        animation.duration = 2.0;
        animation.repeatCount = isInfinite ? INFINITY : 1;
        [aView.layer addAnimation:animation forKey:@"SpinAnimation"];
    }
}

- (void)stopRotateAnimationFor:(UIView *)aView {
    
    [aView.layer removeAnimationForKey:@"SpinAnimation"];
}

- (int)getRandowNumberBetween:(int)min max:(int)max {
    
    return rand() % (max - min ) + min;
}

- (float)randomFloat:(float)min max:(float)max {
    
    return ((arc4random()%RAND_MAX) / (RAND_MAX*1.0)) * (max - min) + min;
}

#pragma mark - View Tap Animation

// Scale in-out Tap animation
- (void)tapAnimationFor:(UIView*)aView duration:(float)aDurationFloat withCallBack:(void (^)())callBack {
    
    [UIView animateKeyframesWithDuration:aDurationFloat delay:0.0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
        
        // Zoom out
        [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:aDurationFloat / 2 animations:^{
            
            aView.transform = CGAffineTransformScale(aView.transform, 0.9, 0.9);
            
        }];
        
        // Back to orginal size
        [UIView addKeyframeWithRelativeStartTime:aDurationFloat / 2 relativeDuration:aDurationFloat / 2 animations:^{
            
            aView.transform = CGAffineTransformIdentity;
            
        }];
        
    } completion:^(BOOL finished) {
        if(finished) {
            if (callBack) {
                callBack();
            }
        }
    }];
}

// Scale in-out Tap animation with default duration of 0.5
- (void)tapAnimationFor:(UIView*)aView withCallBack:(void (^)())callBack {
    [self tapAnimationFor:aView duration:0.5 withCallBack:callBack];
}

- (void)animateConstraintChangeForView:(UIView *)aView duration :(float)aDuration {
    
    [UIView animateWithDuration:aDuration delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [aView layoutIfNeeded];
    } completion:nil];
}

#pragma mark - Shake Animation

// Shake Tap animation with default duration of 0.5
-(void)shakeAnimationFor: (UIView *)aView callBack:(void (^)())callBack {
    [self shakeAnimationFor:aView duration:0.5 callBack:callBack];
}

// Shake Tap animation with custom duration
-(void)shakeAnimationFor: (UIView *)aView duration:(float)aDurationFloat callBack:(void (^)())callBack
{
    [UIView animateKeyframesWithDuration:aDurationFloat delay:0.0 options:UIViewKeyframeAnimationOptionBeginFromCurrentState animations:^{
        
        [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:aDurationFloat animations:^{
            aView.transform = CGAffineTransformRotate(aView.transform, DEGREES_TO_RADIANS(10));
        }];
        
        [UIView addKeyframeWithRelativeStartTime:aDurationFloat * 1 relativeDuration:aDurationFloat animations:^{
            aView.transform = CGAffineTransformRotate(aView.transform, DEGREES_TO_RADIANS(-20));
        }];
        
        [UIView addKeyframeWithRelativeStartTime:aDurationFloat * 2 relativeDuration:aDurationFloat animations:^{
            aView.transform = CGAffineTransformIdentity;
        }];
        
    } completion:^(BOOL finished) {
        
        if(finished) {
            if (callBack) {
                callBack();
            }
        }
    }];
}

#pragma mark - UITextField

- (void)textFieldPlaceHolderAlter:(UITextField*)textField placeHolderText:(NSString*)text andColor:(UIColor*)color {
    
    textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:text attributes:@{NSForegroundColorAttributeName: color}];
}

- (void)textViewPlaceHolderAlter:(UITextView*)textView placeHolderText:(NSString*)text andColor:(UIColor*)color {
    
    textView.attributedPlaceholder = [[NSAttributedString alloc] initWithString:text attributes:@{NSForegroundColorAttributeName: color}];
}

#pragma mark - Tool Bar

- (UIToolbar *)getToolbarWithTitle:(NSString *)aTitle target:(UIViewController *)aTarget titleAlignment:(TOOLBAR_TITLE_ALIGNMENT)aAlignment buttonTitle:(NSString *)aButtonTitle tag:(NSInteger)aTag {
    
    // Title
    UILabel *aTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    aTitleLabel.textAlignment = NSTextAlignmentLeft;
    aTitleLabel.shadowOffset = CGSizeMake(0, 1);
    aTitleLabel.textColor = [UIColor whiteColor];
    aTitleLabel.text = aTitle;
    aTitleLabel.font = [UIFont systemFontOfSize:16.0];
    [aTitleLabel sizeToFit];
    
    // Button
    UIBarButtonItem *aTitleItem = [[UIBarButtonItem alloc] initWithCustomView:aTitleLabel];
    
    UIBarButtonItem *aButtonItem = [[UIBarButtonItem alloc] initWithTitle:aButtonTitle style:UIBarButtonItemStyleDone target:aTarget action:@selector(toolbarButtonTapAction:)];
    aButtonItem.tintColor = [UIColor whiteColor];
    aButtonItem.tag = aTag;
    
    UIBarButtonItem *aFlexableItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL];
    
    // Toolbar
    CGRect aToolbarFrame = CGRectMake(0, 0, CGRectGetWidth( [UIScreen mainScreen].bounds),40);
    UIToolbar *aToolbar = [[UIToolbar alloc] initWithFrame:aToolbarFrame];
    
    NSArray *aItemsArray;
    
    if (aAlignment == ALIGN_LEFT) {
        aItemsArray = @[aTitleItem,aFlexableItem,aButtonItem];
    }
    else {
        aItemsArray = @[aFlexableItem,aTitleItem,aButtonItem];
    }
    
    [aToolbar setItems:aItemsArray];
    aToolbar.barStyle = UIBarStyleBlackTranslucent;
    
    return aToolbar;
}

#pragma MARK - UIACTION VIEW -
//For three actions

- (void)showAlertControllerIn:(UIViewController *)aViewController title:(NSString *)aTitle message:(NSString *)aMessage defaultFirstButtonTitle:(NSString *)aFirstButtonTitle defaultFirstActionBlock:(void (^)(UIAlertAction *action))aFirstActionBlock defaultSecondButtonTitle:(NSString *)aSecondButtonTitle defaultSecondActionBlock:(void (^)(UIAlertAction *action))aSecondActionBlock cancelButtonTitle:(NSString *)aCancelButtonTitle cancelActionBlock:(void (^)(UIAlertAction *action))aCancelActionBlock {
    
    UIAlertController *aAlertController = [UIAlertController alertControllerWithTitle:aTitle message:aMessage preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *aFirsttButtonAction = [UIAlertAction actionWithTitle:aFirstButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if (aFirstActionBlock) {
            aFirstActionBlock(action);
        }
        
    }];
    UIAlertAction *aSecondButtonAction = [UIAlertAction actionWithTitle:aSecondButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if (aSecondActionBlock) {
            aSecondActionBlock(action);
        }
        
    }];
    
    
    UIAlertAction *aCancelButtonAction = [UIAlertAction actionWithTitle:aCancelButtonTitle style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        if (aCancelActionBlock) {
            aCancelActionBlock(action);
        }
        
    }];
    
    [aAlertController addAction:aFirsttButtonAction];
    [aAlertController addAction:aSecondButtonAction];
    [aAlertController addAction:aCancelButtonAction];
    
    [aViewController presentViewController:aAlertController animated:YES completion:nil];
    
}

//For two actions

- (void)showAlertControllerIn:(UIViewController *)aViewController title:(NSString *)aTitle message:(NSString *)aMessage defaultFirstButtonTitle:(NSString *)aFirstButtonTitle defaultFirstActionBlock:(void (^)(UIAlertAction *action))aFirstActionBlock cancelButtonTitle:(NSString *)aCancelButtonTitle cancelActionBlock:(void (^)(UIAlertAction *action))aCancelActionBlock {
    
    UIAlertController *aAlertController = [UIAlertController alertControllerWithTitle:aTitle message:aMessage preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *aFirsttButtonAction = [UIAlertAction actionWithTitle:aFirstButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if (aFirstActionBlock) {
            aFirstActionBlock(action);
        }
        
    }];
    
    UIAlertAction *aCancelButtonAction = [UIAlertAction actionWithTitle:aCancelButtonTitle style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        if (aCancelActionBlock) {
            aCancelActionBlock(action);
        }
        
    }];
    
    [aAlertController addAction:aFirsttButtonAction];
    [aAlertController addAction:aCancelButtonAction];
    
    [aViewController presentViewController:aAlertController animated:YES completion:nil];
    
}


#pragma mark - Notification -
- (void)addObserverForMyQueryViewUpdatesIn:(UIViewController *)aViewController {
    
    [[NSNotificationCenter defaultCenter] addObserver:aViewController selector:@selector(updateViewForQuerytatusChange) name:NOTIFICATION_VIEW_UPADTE_BASED_ON_MY_QUERY_STATUS object:nil];
    
}

- (void)postMyQueryViewUpdateNotification {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_VIEW_UPADTE_BASED_ON_MY_QUERY_STATUS object:nil userInfo:nil];
}

- (void)removeObserverForMyQueryViewUpdatesIn:(UIViewController *)aViewController {
    
    [[NSNotificationCenter defaultCenter] removeObserver:aViewController name:NOTIFICATION_VIEW_UPADTE_BASED_ON_MY_QUERY_STATUS object:nil];
    
}

#pragma mark - kelvin to Celcius -
-(NSString *)convertKelvinToCelsius:(NSString *)aString {
    
    double kelvinTemperature = [aString doubleValue];
    double celsiusTemperature = kelvinTemperature - 273.15;
    
    NSString *aStr = [NSString stringWithFormat:@"%.2f", celsiusTemperature];
    
    if ([aStr containsString:@"."])
        aStr = [aStr componentsSeparatedByString:@"."][0];
    
    
    return aStr;
}

#pragma mark - Get Time from 6 PM to 6 AM

-(BOOL)getTimeDifference: (NSDate *)aDate {
    
    BOOL aBoolValue;
    
    NSDateComponents *openingTime = [[NSDateComponents alloc] init];
    openingTime.hour = 6;
    openingTime.minute = 00;
    
    NSDateComponents *closingTime = [[NSDateComponents alloc] init];
    closingTime.hour = 18;
    closingTime.minute = 0;
    
    NSDateComponents *currentTime = [[NSCalendar currentCalendar] components:NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:aDate];
    
    NSMutableArray *times = [@[openingTime, closingTime, currentTime] mutableCopy];
    [times sortUsingComparator:^NSComparisonResult(NSDateComponents *t1, NSDateComponents *t2) {
        
        if (t1.hour > t2.hour) {
            return NSOrderedDescending;
        }
        if (t1.hour < t2.hour) {
            return NSOrderedAscending;
        }
        // hour is the same
        if (t1.minute > t2.minute) {
            return NSOrderedDescending;
        }
        
        if (t1.minute < t2.minute) {
            return NSOrderedAscending;
        }
        // hour and minute are the same
        if (t1.second > t2.second) {
            return NSOrderedDescending;
        }
        
        if (t1.second < t2.second) {
            return NSOrderedAscending;
        }
        return NSOrderedSame;
    }];
    
    if ([times indexOfObject:currentTime] == 1) {
        aBoolValue = YES;
    } else {
        aBoolValue = NO;
    }
    return aBoolValue;
}

#pragma mark - Get Days Bt Two dates

- (BOOL)daysBetweenTwoDates:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime {
    
    NSDate *fromDate;
    NSDate *toDate;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&fromDate
                 interval:NULL forDate:fromDateTime];
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&toDate
                 interval:NULL forDate:toDateTime];
    
    NSDateComponents *difference = [calendar components:NSCalendarUnitDay
                                               fromDate:fromDate toDate:toDate options:0];
    
    if ([self isYearLeapYear:toDateTime]) {
        
        if([fromDateTime compare:toDateTime] == NSOrderedAscending || [fromDateTime compare:toDateTime] == NSOrderedSame)
            return YES;
        else
            return NO;
    }
    else {
        
        if([fromDateTime compare:toDateTime] == NSOrderedAscending || [fromDateTime compare:toDateTime] == NSOrderedSame)
            return YES;
        else
            return NO;
    }
}

- (NSUInteger)numberOfDaysInYear:(NSInteger)year {
    
    NSDate *firstDateOfYear = [self firstDateOfYear:year];
    NSDate *firstDateOfNextYear = [self firstDateOfYear:year + 1];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:firstDateOfYear toDate:firstDateOfNextYear options:0];
    return [components day];
}

- (NSDate *)firstDateOfYear:(NSInteger)year {
    
    NSDateComponents *dc = [[NSDateComponents alloc] init];
    dc.year = year;
    dc.month = 4;
    dc.day = 1;
    return [[NSCalendar currentCalendar] dateFromComponents:dc];
}

- (BOOL)isYearLeapYear:(NSDate *) aDate {
    NSInteger year = [self yearFromDate:aDate];
    return (( year%100 != 0) && (year%4 == 0)) || year%400 == 0;
}

- (NSInteger)yearFromDate:(NSDate *)aDate {
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"yyyy";
    NSInteger year = [[dateFormatter stringFromDate:aDate] integerValue];
    return year;
}

- (void)navigateToMenuDetailScreen {
    
    LUMenuViewController *aViewController = [LUMenuViewController new];
    UINavigationController *aLeftNavigationController = [[UINavigationController alloc] initWithRootViewController:aViewController];
    UINavigationController *aCenterNavigationController;
  
    if ([SESSION_2 isRequested]) {
       
        DashBoardRequestViewController *viewControllerCenter = [STORY_BOARD instantiateViewControllerWithIdentifier:@"DashBoardRequestViewController"];
        aCenterNavigationController = [[UINavigationController alloc] initWithRootViewController:viewControllerCenter];
    }
    else {
     
        LUDashBoardViewController *viewControllerCenter = [STORY_BOARD instantiateViewControllerWithIdentifier:@"LUDashBoardViewController"];
        aCenterNavigationController = [[UINavigationController alloc] initWithRootViewController:viewControllerCenter];
    }
    
    APPDELEGATE.sideMenu = [[MMDrawerController alloc]
                            initWithCenterViewController:aCenterNavigationController
                            leftDrawerViewController:aLeftNavigationController
                            rightDrawerViewController:nil];
    APPDELEGATE.sideMenu.view.backgroundColor = [UIColor whiteColor];
    
    [APPDELEGATE.sideMenu setMaximumLeftDrawerWidth:CGRectGetWidth([[UIScreen mainScreen] bounds]) - 50];
    [APPDELEGATE.sideMenu setShowsShadow:YES];
    [APPDELEGATE.sideMenu setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [APPDELEGATE.sideMenu setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    [APPDELEGATE.sideMenu
     setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
         MMDrawerControllerDrawerVisualStateBlock block;
         block = [MMDrawerVisualState parallaxVisualStateBlockWithParallaxFactor:5.0];
         if(block){
             block(drawerController, drawerSide, percentVisible);
         }
     }];
    
    [SESSION setSearchInfo:nil];

    [self changeRootViewController:APPDELEGATE.sideMenu scaleIn:NO];
    
}

- (BOOL)networkRechableForSwiftClass {
    
    if ([AFNetworkReachabilityManager sharedManager].reachable) {
        
        if ([AFNetworkReachabilityManager sharedManager].isReachableViaWiFi)
            NSLog(@"Network Reachable Via WWAN *****");
        else
            NSLog(@"Network Reachable Via WiFi *****");
        
        return YES;
    }
    else {
        
        NSLog(@"Network Not Reachable *****");
        return NO;
    }
    return NO;
}

- (BOOL)isLocationEnabled {
    
    return YES;//[CLLocationManager locationServicesEnabled];
}

- (BOOL)isLocationAccessAllowed {
    
    if ([self isLocationEnabled]) {
        return YES;//[CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied;
    }
    else {
        return NO;
    }
}

-(void)getCountryDailCode {
    
    CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [networkInfo subscriberCellularProvider];
    
    NSString *mnc = [carrier mobileNetworkCode];
    
    NSString *mcc = [carrier mobileCountryCode];
    
}

#pragma mark - To get Current Country

-(void)getCountryCodeDetailsFromCountyr:(NSString *)aCountryName {
    
    CountryListDataSource *dataSource = [[CountryListDataSource alloc] init];
    NSArray *aCountryListArray = [dataSource countries];
    
    for (int i = 0; i < aCountryListArray.count; i++) {
        
        if ([aCountryName isEqualToString:aCountryListArray[i][kCountryName]]) {
            
            NSString *imagePath = [NSString stringWithFormat:@"EMCCountryPickerController.bundle/%@", aCountryListArray[i][kCountryCode]];
            UIImage *image = [UIImage imageNamed:imagePath inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil];
            myCountryFlag = [image fitInSize:CGSizeMake(35,35)];
            myCountryCodeString = aCountryListArray[i][kCountryCallingCode];
            
            NSMutableArray *aMutableArray = [NSMutableArray new];
            NSMutableDictionary *aMDict = [NSMutableDictionary new];
            aMDict[kCountryflag] = myCountryFlag;
            aMDict[kCountryCode] = myCountryCodeString;
            aMDict[kCountryName] = myCountryNameString;
            
            [aMutableArray addObject:aMDict];
            [SESSION setCurrentCountryDetails:aMutableArray];
        }
    }
}

-(void)GetCurrentLocation_WithBlock:(void(^)())block {
    
    geocoder = [[GMSGeocoder alloc] init];
    
    [CLLocationManager locationServicesEnabled];
    myLocationManager = [[CLLocationManager alloc] init];
    myLocationManager.delegate = self;
    myLocationManager.distanceFilter = 1;
    [myLocationManager requestAlwaysAuthorization];
    myLocationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [myLocationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    if (locations.count) {
        
        CLLocation *aLocation = locations[0];
        // This is method is getting called as soon as screen is loaded but the lat lng is incorrect, its not user location so below code is a workaround
        if (aLocation.coordinate.longitude == -40.0) {
            return;
        }
        
        [manager stopUpdatingLocation];
        
        [geocoder reverseGeocodeCoordinate:aLocation.coordinate completionHandler:^(GMSReverseGeocodeResponse* response, NSError* error) {
            
            NSLog(@"reverse geocoding results:");
            for(GMSAddress* addressObj in [response results])
            {
                NSLog(@"coordinate.latitude=%f", addressObj.coordinate.latitude);
                NSLog(@"coordinate.longitude=%f", addressObj.coordinate.longitude);
                NSLog(@"thoroughfare=%@", addressObj.thoroughfare);
                NSLog(@"locality=%@", addressObj.locality);
                NSLog(@"subLocality=%@", addressObj.subLocality);
                NSLog(@"administrativeArea=%@", addressObj.administrativeArea);
                NSLog(@"postalCode=%@", addressObj.postalCode);
                NSLog(@"country=%@", addressObj.country);
                NSLog(@"lines=%@", addressObj.lines);
                
                myCountryNameString = addressObj.country;
                [self getCountryCodeDetailsFromCountyr:myCountryNameString];
            }
        }];
    }
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    
    
}

#pragma mark - Whatsapp subject -

- (NSString *)stringByEncodingString:(NSString *)string {
    
    CFStringRef encodedString = CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)string, NULL,
                                                                        (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8);
    return CFBridgingRelease(encodedString);
}

#pragma mark - Favorite Location

-(void)addFavoriteList: (int) i {

    NSMutableDictionary *aMutableDictionary = [NSMutableDictionary new];
    
    if (i == 1) {
        
        aMutableDictionary = [NSMutableDictionary new];
        aMutableDictionary[@"CF_Id"] = @"";
        aMutableDictionary[@"Customer_Id"] = [SESSION getUserInfo][0][K_CUSTOMER_ID];
        aMutableDictionary[@"PULatitude"] = @"";
        aMutableDictionary[@"PULongitude"] = @"";
        aMutableDictionary[@"PUAddress"] = ADD_HOME;
        aMutableDictionary[@"Created_On"] = @"";
        aMutableDictionary[@"Upddated_On"] = @"";
        aMutableDictionary[@"Display_Name"] = @"";
        aMutableDictionary[@"PrimaryLocation"] = @"1";
        aMutableDictionary[@"PrimaryLocation"] = @"1";
        
        [COREDATAMANAGER addFavouriteListInfo:[aMutableDictionary copy]];
    }
    
    else if (i == 2) {
        
        aMutableDictionary = [NSMutableDictionary new];
        aMutableDictionary[@"CF_Id"] = @"";
        aMutableDictionary[@"Customer_Id"] = [SESSION getUserInfo][0][K_CUSTOMER_ID];
        aMutableDictionary[@"PULatitude"] = @"";
        aMutableDictionary[@"PULongitude"] = @"";
        aMutableDictionary[@"PUAddress"] = ADD_OFFICE;
        aMutableDictionary[@"Created_On"] = @"";
        aMutableDictionary[@"Upddated_On"] = @"";
        aMutableDictionary[@"Display_Name"] = @"";
        aMutableDictionary[@"PrimaryLocation"] = @"2";
        
        [COREDATAMANAGER addFavouriteListInfo:[aMutableDictionary copy]];
    }
    else {
        
        aMutableDictionary = [NSMutableDictionary new];
        aMutableDictionary[@"CF_Id"] = @"";
        aMutableDictionary[@"Customer_Id"] = [SESSION getUserInfo][0][K_CUSTOMER_ID];
        aMutableDictionary[@"PULatitude"] = @"";
        aMutableDictionary[@"PULongitude"] = @"";
        aMutableDictionary[@"PUAddress"] = ADD_HOME;
        aMutableDictionary[@"Created_On"] = @"";
        aMutableDictionary[@"Upddated_On"] = @"";
        aMutableDictionary[@"Display_Name"] = @"";
        aMutableDictionary[@"PrimaryLocation"] = @"1";
        
        [COREDATAMANAGER addFavouriteListInfo:[aMutableDictionary copy]];
        
        
        aMutableDictionary = [NSMutableDictionary new];
        aMutableDictionary[@"CF_Id"] = @"";
        aMutableDictionary[@"Customer_Id"] = [SESSION getUserInfo][0][K_CUSTOMER_ID];
        aMutableDictionary[@"PULatitude"] = @"";
        aMutableDictionary[@"PULongitude"] = @"";
        aMutableDictionary[@"PUAddress"] = ADD_OFFICE;
        aMutableDictionary[@"Created_On"] = @"";
        aMutableDictionary[@"Upddated_On"] = @"";
        aMutableDictionary[@"Display_Name"] = @"";
        aMutableDictionary[@"PrimaryLocation"] = @"2";
        
        [COREDATAMANAGER addFavouriteListInfo:[aMutableDictionary copy]];
    }
}

- (NSString *)getHoursMinutesLeftBasedonTimeInterval:(NSTimeInterval)aTimeInterval isSecondsRequired:(BOOL)isSecondsRequired isShortForm:(BOOL)isShortForm {
    
    long seconds = lroundf(aTimeInterval); // Since modulo operator (%) below needs int or long
    
    int mins = (seconds % 3600) / 60;
    int secs = seconds % 60;
    
    
    NSString *aCustomTime = @"", *aMinString = @"", *aSecondString = @"";
    
    if (mins > 9) {
        aMinString = [NSString stringWithFormat:@"%d", mins];
    }
    else if (mins >= 0) {
        aMinString = [NSString stringWithFormat:@"0%d", mins];
    }
    
    if (isSecondsRequired) {
        if (secs > 9) {
            aSecondString = [NSString stringWithFormat:@"%d", secs];
        }
        else if(secs >= 0) {
            aSecondString = [NSString stringWithFormat:@"0%d", secs];
        }
    }
    
    if (aMinString.length) {
 
        if([aMinString intValue] > 0) {
            aCustomTime = aMinString;
        }
        else {
            
            aCustomTime = aMinString;
        }
    }
    
    if (isSecondsRequired) {
        if (aSecondString.length) {
            if (aCustomTime.length) {
                aCustomTime = [NSString stringWithFormat:@"%@:%@", aCustomTime, aSecondString];
            }
            else {
                aCustomTime = aSecondString;
            }
        }
    }
    
    return aCustomTime;
}

#pragma mark - set Card View Effor For View

- (void)setCardViewEfforForView:(UIView*)aView {
    
     static CGFloat radius = 2;
     
     static int shadowOffsetWidth = 0;
     static int shadowOffsetHeight = 3;
     static float shadowOpacity = 0.7;
     
     aView.layer.cornerRadius = radius;
     UIBezierPath *shadowPath = [UIBezierPath
     bezierPathWithRoundedRect: aView.bounds
     cornerRadius: radius];
     
     aView.layer.masksToBounds = false;
     aView.layer.shadowColor = [UIColor blackColor].CGColor;
     aView.layer.shadowOffset = CGSizeMake(shadowOffsetWidth, shadowOffsetHeight);
     aView.layer.shadowOpacity = shadowOpacity;
     aView.layer.shadowPath = shadowPath.CGPath;
}

- (void)removeCardViewEfforFromView:(UIView*)aView {
    
    static CGFloat radius = 2;
    
    static int shadowOffsetWidth = 0;
    static int shadowOffsetHeight = 0;
    static float shadowOpacity = 0;
    
    
    aView.layer.cornerRadius = radius;
    UIBezierPath *shadowPath = [UIBezierPath
                                bezierPathWithRoundedRect: aView.bounds
                                cornerRadius: radius];
    
    aView.layer.masksToBounds = false;
    aView.layer.shadowColor = [UIColor clearColor].CGColor;
    aView.layer.shadowOffset = CGSizeMake(shadowOffsetWidth, shadowOffsetHeight);
    aView.layer.shadowOpacity = shadowOpacity;
    aView.layer.shadowPath = shadowPath.CGPath;
}

- (NSString *)setZeroAfterValue:(NSString*)aTextString numberOfZero:(NSInteger)aNumberOfWhileSpaceInt {
    
    for (int i = 0 ; i < aNumberOfWhileSpaceInt; i++) {
        aTextString = [NSString stringWithFormat:@"%@0",aTextString];
    }
    
    return aTextString;
}

-(void)FavDeleteRequestHandler:(NSMutableDictionary *)dic withAPI : (NSString *)url andFavPrimaryLoc : (NSString *)favPrimaryLoc{
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *string = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSMutableDictionary *aParameterMutableDict = [[NSMutableDictionary alloc]init];
    aParameterMutableDict[@"StrJson"] = string;
    
    [HTTPMANAGER deleteFavoriteType:aParameterMutableDict primaryLocatio:favPrimaryLoc completedBlock:^(NSDictionary *response) {
        
        if ([response[kRESPONSE][kRESPONSE_CODE] intValue] == kSUCCESS_CODE || [response[kRESPONSE][kRESPONSE_CODE] intValue] == K_NO_DATA_CODE || [response[kRESPONSE][kRESPONSE_CODE] intValue] == k_BAD_REQUEST)
            [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_VIEW_UPADTE_FAV_DELETED object:nil userInfo:response];
        else
            [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_VIEW_UPADTE_FAV_DELETED object:nil userInfo:[NSDictionary new]];
        
        
        
    } failedBlock:^(NSError *error) {
        
        [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_VIEW_UPADTE_FAV_DELETED object:nil userInfo:[NSDictionary new]];
    }];
}


@end
