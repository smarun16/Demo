//
//  Helper.h
//
//  Copyright (c) 2015 ANGLER EIT. All rights reserved.
//

#import "MMDrawerVisualState.h"
#import <GoogleMaps/GoogleMaps.h>

typedef enum : NSUInteger {
    
    SEARCH_TYPE_SOURCE,
    SEARCH_TYPE_DESTINATION,
    SEARCH_TYPE_NONE
} SearchTypeEnum;

@interface Helper : NSObject <CLLocationManagerDelegate>
{
    NSString *myCountryNameString;
    NSString *myCountryCodeString;
    UIImage *myCountryFlag;
    CLLocationManager *myLocationManager;
    GMSGeocoder *geocoder;
}

+ (Helper *)sharedObject;


#pragma mark - Color and Image
- (UIColor *)getColorFromHexaDecimal:(NSString *)hexaDecimal;
- (UIColor *)getColorFromHexaDecimal:(NSString *)hexaDecimal alpha:(float)alpha;
- (UIImage *)getImageFromColor:(UIColor *)color;
- (void)setBackgroundImageFor:(UIViewController *)controller imageNamed:(NSString *)imageName;
- (void)setURLProfileImageForImageView:(UIImageView*)aImageView URL:(NSString*)aURLString placeHolderImage:(NSString*)aPlaceHolderImageString;

#pragma mark -Image Rendring mode
- (void) getColorIgnoredImage:(NSString *)aImageString imageView:(UIImageView *)aImageView color: (UIColor *)aColor;

#pragma mark - Navigation Animation
- (void) addAnimationFor:(UIViewController *)controller;


#pragma mark - Loading
- (void)showLoadingAnimation;
- (void)removeLoadingAnimation;


#pragma mark - Date
- (NSString *)getCurrentDateInFormat:(NSString *)format;
- (NSString *)getConvertedDateFormatFrom :(NSString *)oldFormat to:(NSString *)newFormat forDateTime: (NSString *)dateTime;
- (NSString *)getNextDateFrom:(NSString *)dateTime inFormat:(NSString *)dateFormat daysCount :(NSInteger)daysCount;
- (NSString *)getConvertedDateFormatFrom:(NSString *)oldFormat to:(NSString *)newFormat forDate: (NSDate *)date;
- (NSDate *)getConvertedDateStringFormatFrom:(NSString *)oldFormat to:(NSString *)newFormat forDate: (NSDate *)date;

#pragma mark - Call
- (BOOL)callToNumber:(NSString *)phoneNumber;

#pragma mark - change root View

- (void)changeRootViewController:(UIViewController*)viewController scaleIn:(BOOL)shouldScaleIn;

#pragma mark - Http Format
- (NSString *)addHttpIfNeedIn:(NSString *)httpUrl;
- (NSURL *)getYoutubeImageUrlFor:(NSString *)videoUrl;
- (void)rateUsFeatureUsingViewController:(UIViewController *)viewController;
- (NSURL *)URLPercentageDecode:(NSString*)url;


#pragma mark - Utilities
-(BOOL)isText:(NSString *)text;
- (BOOL)isDigit:(NSString*)text;
- (BOOL)isPhoneNumber:(NSString*)text;
- (NSString *) getAppVersion;
- (NSString *) getBuild;
- (NSString *) getVersionBuild;

- (void)changeRootViewController:(UIViewController*)viewController;

#pragma mark - Rounded Corner View
- (void)roundCornerForView:(UIView*)view radius:(float)radius borderColor:(UIColor*)color;
- (void)roundCornerForView:(UIView*)view andBorderColor:(UIColor*)color;
- (void)roundCornerForView:(UIView*)view withRadius:(float)radius;
- (void)roundCornerForView:(UIView*)view;
- (void)roundCornerForView:(UIView*)view withRadius:(float)radius andBorderColor:(UIColor*)color;

#pragma mark - Drop Shadow
- (void)addDropShadowToView:(UIView*)aView;
- (void)addDropShadowToView:(UIView*)aView withShadowColor:(UIColor*)aColor;
- (void)addDropShadowToView:(UIView*)aView cornerRadius:(float)aRadius;
- (void)addDropShadowToView:(UIView*)aView withShadowColor:(UIColor*)aColor cornerRadius:(float)aRadius;
- (void)addDropShadowToTableview:(UITableView *)aTableView;
- (void)addFloatingEffectToView:(UIView *)aView;


- (NSString *)prefixWithWhiteSpaceForText:(NSString*)aTextString numberOfWhileSpace:(int)aNumberOfWhileSpaceInt;
- (NSString *)resetCardNumberAsVisa:(NSString*)originalString;

#pragma mark - In-View Loading

- (UIView *)showLoadingIn:(UIViewController *)aViewController;
- (UIView *)showLoadingIn:(UIViewController *)aViewController text:(NSString *)aText;
- (void)removeLoadingIn:(UIViewController *)aViewController;

#pragma mark - TSMessage Notification Alert

- (void)showNotificationErrorIn:(UIViewController*)controller withMessage:(NSString*)message;
- (void)showNotificationSuccessIn:(UIViewController*)controller withMessage:(NSString*)message;
- (void)showNotificationInfoIn:(UIViewController*)controller withMessage:(NSString*)message;
- (void)showNotificationWarningIn:(UIViewController*)controller withMessage:(NSString*)message;
- (void)showFBStyleErrorAlertIn:(UIViewController*)controller withMessage:(NSString*)message;

#pragma mark - In-View Alert

typedef void (^RetryCallBack)();

- (UIView *)showRetryAlertIn:(UIViewController *)aViewController details:(NSDictionary *)aDetailsInfo retryBlock:(RetryCallBack)aRetryCallBack;
//- (UIView *)showAlertIn:(UIViewController *)aViewController details:(NSDictionary *)aDetailsInfo;
- (UIView *)showAlertIn:(UIViewController *)aViewController details:(NSDictionary *)aDetailsInfo colorCode:(NSString *)aStrColorCode;
- (void)removeAlertIn:(UIViewController *)aViewController;
- (void)removeRetryAlertIn:(UIViewController *)aViewController;
- (void)removeRetryAlertAndImageAlertIn:(UIViewController *)aViewController;

- (void)setAttributedTextToRefreshController:(UIRefreshControl *)refreshControl message :(NSString *)message;

#pragma Alert View

- (void)showAlertView:(UIViewController*)aViewController title:(NSString *)aTitle message:(NSString *)aMessage;
- (void)showAlertView:(UIViewController*)aViewController title:(NSString *)aTitle message:(NSString *)aMessage okButtonBlock:(void (^)(UIAlertAction *action))okAction;

- (void)showAlertView:(UIViewController*)aViewController title:(NSString *)aTitle  message:(NSString *)aMessage okButton:(NSString *)aOkButton style:(UIAlertActionStyle )aStyle;
- (void)showAlertViewWithTitle:(UIViewController*)aViewController title:(NSString *)aTitle  message:(NSString *)aMessage okButton:(NSString *)aOkButton cancelButton:(NSString *)aCancelButton style:(UIAlertActionStyle )aStyle okButtonBlock:(void (^)(UIAlertAction *action))okAction cancelButtonBlock:(void (^)(UIAlertAction * action))cancelAction isLeftAlign:(BOOL)isLeftAlign;
- (void)showAlertViewWithLeftAlignement:(UIViewController*)aViewController title:(NSString *)aTitle  message:(NSString *)aMessage okButton:(NSString *)aOkButton style:(UIAlertActionStyle )aStyle;

- (void)showAlertViewWithCancel:(UIViewController*)aViewController title:(NSString *)aTitle okButtonBlock:(void (^)(UIAlertAction *action))okAction cancelButtonBlock:(void (^)(UIAlertAction * action))cancelAction;

#pragma MARK - UIACTION VIEW 
//For three actions
- (void)showAlertControllerIn:(UIViewController *)aViewController title:(NSString *)aTitle message:(NSString *)aMessage defaultFirstButtonTitle:(NSString *)aFirstButtonTitle defaultFirstActionBlock:(void (^)(UIAlertAction *action))aFirstActionBlock defaultSecondButtonTitle:(NSString *)aSecondButtonTitle defaultSecondActionBlock:(void (^)(UIAlertAction *action))aSecondActionBlock cancelButtonTitle:(NSString *)aCancelButtonTitle cancelActionBlock:(void (^)(UIAlertAction *action))aCancelActionBlock;

//For two actions
- (void)showAlertControllerIn:(UIViewController *)aViewController title:(NSString *)aTitle message:(NSString *)aMessage defaultFirstButtonTitle:(NSString *)aFirstButtonTitle defaultFirstActionBlock:(void (^)(UIAlertAction *action))aFirstActionBlock cancelButtonTitle:(NSString *)aCancelButtonTitle cancelActionBlock:(void (^)(UIAlertAction *action))aCancelActionBlock;

#pragma mark - Project Oriented Methods

#pragma mark - Animation

- (void)fadeAnimationFor:(UIView*)aView alpha:(float)aAlphaValue duration:(float)aDurationFloat;
- (void)fadeAnimationFor:(UIView*)aView alpha:(float)aAlphaValue;
- (void)addBubbleEffectForView:(UIView *)aView;
- (void)rotateAnimationFor:(UIView *)aView rotateInfiniteTime:(BOOL)isInfinite;
- (void)stopRotateAnimationFor:(UIView *)aView;
- (void)transitionAnimationFor:(UIView*)aView duration:(float)aDurationFloat withAnimationBlock:(void(^)())animationBlock;

#pragma mark - Tap Animation
// Scale in-out Tap animation
- (void)tapAnimationFor:(UIView*)aView duration:(float)aDurationFloat withCallBack:(void (^)())callBack;
// Scale in-out Tap animation with default duration of 0.5
- (void)tapAnimationFor:(UIView*)aView withCallBack:(void (^)())callBack;

#pragma mark - Shake Animation
-(void)shakeAnimationFor: (UIView *)aView callBack:(void (^)())callBack;
-(void)shakeAnimationFor: (UIView *)aView duration:(float)aDurationFloat callBack:(void (^)())callBack;
#pragma mark - Constraint changes Animation

- (void)animateConstraintChangeForView:(UIView *)aView duration :(float)aDuration ;

#pragma mark - UITextField

- (void)textFieldPlaceHolderAlter:(UITextField*)textField placeHolderText:(NSString*)text andColor:(UIColor*)color;

- (void)textViewPlaceHolderAlter:(UITextView*)textView placeHolderText:(NSString*)text andColor:(UIColor*)color;

#pragma mark - Toolbar

typedef enum : NSUInteger {
    ALIGN_LEFT,
    ALIGN_CENTER,
} TOOLBAR_TITLE_ALIGNMENT;

- (UIToolbar *)getToolbarWithTitle:(NSString *)aTitle target:(UIViewController *)aTarget titleAlignment:(TOOLBAR_TITLE_ALIGNMENT)aAlignment buttonTitle:(NSString *)aButtonTitle tag:(NSInteger)aTag;

#pragma mark - Days & Time -

//  Get Time from 6 PM to 6 AM
-(BOOL)getTimeDifference: (NSDate *)aDate;

// Get Days Bt Two dates
- (BOOL)daysBetweenTwoDates:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime;

- (NSDate *)firstDateOfYear:(NSInteger)year;


#pragma mark - Notifications -

- (void)addObserverForMyQueryViewUpdatesIn:(UIViewController *)aViewController;
- (void)postMyQueryViewUpdateNotification;
- (void)removeObserverForMyQueryViewUpdatesIn:(UIViewController *)aViewController;

// Notification Count
- (void)setNotificationBadgeCount;

#pragma mark - kelvin to Celcius -
-(NSString *)convertKelvinToCelsius:(NSString *)aString;

#pragma mark - Menu Screen -

-(void)navigateToMenuDetailScreen;
- (BOOL)isLocationAccessAllowed;

#pragma mark - dail Code

-(void)getCountryDailCode;
-(void)GetCurrentLocation_WithBlock:(void(^)())block;

#pragma mark - Whatsapp subject -

- (NSString *)stringByEncodingString:(NSString *)string;


#pragma mark - Favorite Location
-(void)addFavoriteList : (int) i;

- (NSString *)getHoursMinutesLeftBasedonTimeInterval:(NSTimeInterval)aTimeInterval isSecondsRequired:(BOOL)isSecondsRequired isShortForm:(BOOL)isShortForm;

- (void)setCardViewEfforForView:(UIView*)aView;
- (void)removeCardViewEfforFromView:(UIView*)aView;

- (NSString *)setZeroAfterValue:(NSString*)aTextString numberOfZero:(NSInteger)aNumberOfWhileSpaceInt;

//Netweok Check
- (BOOL)networkRechableForSwiftClass;

#pragma mark - TransformMakeTranslationView

- (void)slideUpViewTransFormMakeTranslationView :(UIView *)aView;
- (void)slideDownViewTransFormMakeTranslationView :(UIView *)aView;

-(void)FavDeleteRequestHandler:(NSMutableDictionary *)dic withAPI : (NSString *)url andFavPrimaryLoc : (NSString *)favPrimaryLoc;

@end
