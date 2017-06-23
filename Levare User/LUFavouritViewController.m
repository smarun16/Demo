
//
//  LUFavouritViewController.m
//  Levare User
//
//  Created by AngMac137 on 12/5/16.
//  Copyright © 2016 AngMac137. All rights reserved.
//

#import "LUFavouritViewController.h"


@interface LUFavouritViewController ()<CLLocationManagerDelegate>
{
    NSInteger mySelectedRow;
    NSString *myFavoritePrimaryLocation;
    NSMutableDictionary *myUpdateMutableDictionary;
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
}
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) IBOutlet UIView *myAlertView;
@property (strong, nonatomic) IBOutlet UILabel *myAlertLabel;
@property (strong, nonatomic) IBOutlet UIImageView *myAlertImageView;
@property (strong, nonatomic)  GMSMapView *myMapView;

//Model
@property (strong, nonatomic) NSMutableArray *myInfoMutableArray, *myFavouriteInfoMArray;
@end

@implementation LUFavouritViewController

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
    
    _myFavouriteInfoMArray = [NSMutableArray new];
    
    [self setUpNavigationBar];
    _myTableView.sectionHeaderHeight = 0;
    _myTableView.contentInset = UIEdgeInsetsMake(-36, 0, 0, 0);
    _myTableView.tableFooterView = [UIView new];
}


#pragma mark -Model

- (void)setupModel {
    
    [self getValueFromDb];
}

- (void)loadModel {
    
    locationManager = [[CLLocationManager alloc] init];
    
    locationManager.delegate = self;
    
    NSUInteger code = [CLLocationManager authorizationStatus];
    if (code == kCLAuthorizationStatusNotDetermined && ([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)] || [locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])) {
        // choose one request according to your business.
        if([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationAlwaysUsageDescription"]){
            [locationManager requestAlwaysAuthorization];
        } else if([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationWhenInUseUsageDescription"]) {
            [locationManager  requestWhenInUseAuthorization];
        } else {
            NSLog(@"Info.plist does not contain NSLocationAlwaysUsageDescription or NSLocationWhenInUseUsageDescription");
        }
    }
    [locationManager startUpdatingLocation];
}



#pragma mark - UITable view Delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _myInfoMutableArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellIdentifier =@"favoriteCell";
    
    UITableViewCell *aCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (aCell == nil) {
        
        aCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    UIImageView *gImageView = (UIImageView *)[aCell viewWithTag:1];
    UILabel *gTitleLabel = (UILabel *)[aCell viewWithTag:2];
    UILabel *gAddressLabel = (UILabel *)[aCell viewWithTag:3];
    
    TagFavouriteType *aTag = [_myInfoMutableArray objectAtIndex:indexPath.row];
    
    NSLog(@"TagFavo%@", aTag);
    
    gAddressLabel.text = aTag.favourite_address;
    
    if ([aTag.favourite_primary_location isEqualToString:@"1"]) {
        
        gTitleLabel.text = HOME;
        gImageView.image = [UIImage imageNamed:@"icon_home"];
    }
    else if ([aTag.favourite_primary_location isEqualToString:@"2"]) {
        
        gTitleLabel.text = OFFICE;
        gImageView.image = [UIImage imageNamed:@"icon_work"];
    }
    else {
        
        gTitleLabel.text = aTag.favourite_display_name;
        
        // To set tint color & image in helper class
        [HELPER getColorIgnoredImage:IMAGE_MARKER_DESTINATION imageView:gImageView color:[UIColor lightGrayColor]];
    }
    
    if (indexPath.row == 0) {
        
        if (![gTitleLabel.text isEqualToString:HOME]) {
            
            gAddressLabel.text = ADD_HOME;
        }
    }
    
    if (indexPath.row == 1) {
        
        if (![gTitleLabel.text isEqualToString:OFFICE]) {
            
            gAddressLabel.text = ADD_OFFICE;
        }
    }
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

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row != 0 && indexPath.row != 1)
        return YES;
    else
        return NO;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TagFavouriteType *aTag = [_myInfoMutableArray objectAtIndex:indexPath.row];
    myFavoritePrimaryLocation = @"";
    
    
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        mySelectedRow = [aTag.favourite_type_id integerValue];
        myFavoritePrimaryLocation = aTag.favourite_primary_location;
        [self callDeleteWebService];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TagFavouriteType *aTag = [_myInfoMutableArray objectAtIndex:indexPath.row];
    myUpdateMutableDictionary = [NSMutableDictionary new];
    // This is set to update or add location
    
    if ([aTag.favourite_address isEqualToString:ADD_HOME] || [aTag.favourite_address isEqualToString:ADD_OFFICE]) {
        
        mySelectedRow = -2;
        myUpdateMutableDictionary[K_FAVORITE_DISPLAY_NAME] = @"";
        myUpdateMutableDictionary[K_FAVORITE_PRIMARY_LOCATION] = ([aTag.favourite_address isEqualToString:ADD_HOME]) ? @"1" : @"2";
        myUpdateMutableDictionary[K_FAVORITE_ID] = @"";
    }
    
    else {
        
        mySelectedRow = [aTag.favourite_type_id integerValue];
        
        myUpdateMutableDictionary[K_FAVORITE_ID] = [NSString stringWithFormat:@"%ld",(long)mySelectedRow];
        myUpdateMutableDictionary[K_FAVORITE_PRIMARY_LOCATION] = aTag.favourite_primary_location;
        myUpdateMutableDictionary[K_FAVORITE_DISPLAY_NAME] = aTag.favourite_display_name;
        
        [SESSION setFavTitle:myUpdateMutableDictionary[K_FAVORITE_DISPLAY_NAME]];
    }
    
    [self showGMSAutocompleteViewController];
}


#pragma mark - UIButton methods -

-(void)leftBarButtonTapEvent {
    
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
        if ([SESSION_2 isRequested] && ![SESSION_2 isAlertShown]) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:VIEW_UPADTE_BASED_ON_REQUEST_STATUS object:nil userInfo:nil];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:VIEW_UPADTE_BASED_ON_FAV_STATUS object:nil userInfo:nil];
    }];
}

-(void)rightBarButtonTapEvent {
    
}


- (IBAction)addLocationButtonTapped:(id)sender {
    
    [SESSION setFavTitle:@""];
    mySelectedRow = -1;
    [self showGMSAutocompleteViewController];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {

    [manager stopUpdatingLocation];
    
    [HELPER removeLoadingIn:self];
    [HELPER showRetryAlertIn:self details:ALERT_UNABLE_TO_FETCH_LOCATION_DICT retryBlock:^{
        
        [HELPER showLoadingIn:self text:@"Fetching your location"];
        [HELPER removeRetryAlertIn:self];
        
        [manager startUpdatingLocation];
    }];
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    NSLog(@"didUpdateToLocation: %@", newLocation);
    currentLocation = newLocation;
    
}

#pragma mark - GMSAUTO COMPLETE -

- (void)showGMSAutocompleteViewController {
    
    LUFavouriteSearchViewController * aViewController = [STORY_BOARD instantiateViewControllerWithIdentifier:@"LUFavouriteSearchViewController"];
    aViewController.gLocationCoordinate = currentLocation.coordinate;
    aViewController.callBackBlock =^(BOOL isCallBack, NSMutableArray *aMutableArray){
        
        if (isCallBack) {
            
            // Do something with the selected place
            if (mySelectedRow == -1) {
                
                NSMutableDictionary *aMDictionary = [NSMutableDictionary new];
                
                aMDictionary[K_FAVORITE_LATITUDE] = [aMutableArray objectAtIndex:0][K_FAVORITE_LATITUDE];
                aMDictionary[K_FAVORITE_LONGITUDE] = [aMutableArray objectAtIndex:0][K_FAVORITE_LONGITUDE];
                aMDictionary[K_FAVORITE_ADDRESS] = [aMutableArray objectAtIndex:0][K_FAVORITE_ADDRESS];
                aMDictionary[K_FAVORITE_DISPLAY_NAME] = @"";
                aMDictionary[K_FAVORITE_PRIMARY_LOCATION] = @"";
                aMDictionary[K_FAVORITE_ID] = @"";
                
                BOOL isAlreadyExist = false;
                
                for (int i = 0; i < _myInfoMutableArray.count; i++) {
                    
                    TagFavouriteType *aTag = [_myInfoMutableArray objectAtIndex:i];
                    
                    if ([[aMDictionary[K_FAVORITE_LATITUDE] substringToIndex:8] isEqualToString:aTag.favourite_latitude] && [[aMDictionary[K_FAVORITE_LONGITUDE] substringToIndex:8] isEqualToString:aTag.favourite_longitude]) {
                        
                        isAlreadyExist = YES;
                        [HELPER showNotificationSuccessIn:self withMessage:@"The location is already added to favourite list"];
                    }
                }
                
                if (!isAlreadyExist) {
                    
                    LUFavouritePopViewController * aViewController = [STORY_BOARD instantiateViewControllerWithIdentifier:@"LUFavouritePopViewController"];
                    [aViewController setModalPresentationStyle:UIModalPresentationOverCurrentContext];
                    aViewController.isForPromoCode = NO;
                    aViewController.gMutableDictionary = aMDictionary;
                    aViewController.callBackBlock = ^(BOOL isCallBack, NSMutableArray *aMArray) {
                        
                        if (isCallBack) {
                            
                            _myInfoMutableArray = aMArray;
                            [_myTableView reloadDataWithAnimation];
                        }
                    };
                    [self presentViewController:aViewController animated:YES completion:^{
                        
                    }];
                }
            }
            
            else {
                
                BOOL isAlreadyExist = false;
                
                for (int i = 0; i < _myInfoMutableArray.count; i++) {
                    
                    TagFavouriteType *aTag = [_myInfoMutableArray objectAtIndex:i];
                    
                    if ([[[aMutableArray objectAtIndex:0][K_FAVORITE_LATITUDE] substringToIndex:8] isEqualToString:aTag.favourite_latitude] &&[[[aMutableArray objectAtIndex:0][K_FAVORITE_LONGITUDE] substringToIndex:8]  isEqualToString:aTag.favourite_longitude]) {
                        
                        isAlreadyExist = YES;
                        [HELPER showNotificationSuccessIn:self withMessage:@"The location is already added to favourite list"];
                    }
                }
                
                if (!isAlreadyExist) {
                    
                    myUpdateMutableDictionary[K_FAVORITE_LATITUDE] = [aMutableArray objectAtIndex:0][K_FAVORITE_LATITUDE];
                    myUpdateMutableDictionary[K_FAVORITE_LONGITUDE] = [aMutableArray objectAtIndex:0][K_FAVORITE_LONGITUDE];
                    myUpdateMutableDictionary[K_FAVORITE_ADDRESS] = [aMutableArray objectAtIndex:0][K_FAVORITE_ADDRESS];
                    myUpdateMutableDictionary[K_FAVORITE_DISPLAY_NAME] = [aMutableArray objectAtIndex:0][K_FAVORITE_DISPLAY_NAME];
                    
                    [self callSaveOrUpdateWebService];
                }
            }
        }
        else {
            
        }
    };
    UINavigationController *aNavigationController = [[UINavigationController alloc]initWithRootViewController:aViewController];
    [self.navigationController presentViewController:aNavigationController animated:YES completion:nil];
}


/*
 
 */
#pragma mark - Web Service -

- (void)callFavoriteLocationWebService {
    
    if (![HTTPMANAGER isNetworkRechable]) {
        
        NSMutableDictionary *aDictAlert = [NSMutableDictionary new];
        
        aDictAlert[KEY_ALERT_TITLE]  = SCREEN_TITLE_FAVORITE_PLACES;
        aDictAlert[KEY_ALERT_DESC]  = [NSString stringWithFormat:@"%@. Tap to try again",ALERT_NO_INTERNET_DESC];
        aDictAlert[KEY_ALERT_IMAGE]  = @"icon_no_internet";
        
        // List is empty so show 'Tap to retry' view
        [HELPER showRetryAlertIn:self details:aDictAlert retryBlock:^{
            
            if ([HTTPMANAGER isNetworkRechable]) {
                
                [HELPER removeRetryAlertIn:self];
                [HELPER removeLoadingIn:self];
                [self callFavoriteLocationWebService];
            }
        }];
        return;
    }
    
    // http://192.168.0.48/PPTCustomer/API/CustomerFavourites/GetFavourites?Customer_Id=11
    NSMutableDictionary *aParameterMutableDict = [NSMutableDictionary new];
    
    aParameterMutableDict[K_CUSTOMER_ID] = [SESSION getUserInfo][0][K_CUSTOMER_ID];
    
    [HELPER showLoadingIn:self];
    
    [HTTPMANAGER getFavoriteType:aParameterMutableDict completedBlock:^(NSDictionary *response) {
        
        if ([response[kRESPONSE][kRESPONSE_CODE] intValue] == kSUCCESS_CODE) {
            
            NSMutableArray *aMainMutableArray = [NSMutableArray new];
            _myInfoMutableArray = [NSMutableArray new];
            
            // This to get the array position based on primary location
            
            aMainMutableArray = [[COREDATAMANAGER getFavouriteListInfo] mutableCopy];
            NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"favourite_filter" ascending:YES];
            NSArray *aArray = [aMainMutableArray sortedArrayUsingDescriptors:@[sortDescriptor]];
            
            _myInfoMutableArray = [aArray mutableCopy];
            
        }
        else if ([response[kRESPONSE][kRESPONSE_CODE] intValue] == k_BAD_REQUEST || [response[kRESPONSE][kRESPONSE_CODE] intValue] == K_NO_DATA_CODE) {
            
        }
        else {
            
            [HELPER showNotificationSuccessIn:self withMessage:response[kRESPONSE][kRESPONSE_MESSAGE]];
        }
        
        [HELPER removeRetryAlertIn:self];
        [self tableviewReloadDateWithContent];
        [HELPER removeLoadingIn:self];
        
    } failedBlock:^(NSError *error) {
        
        if (_myInfoMutableArray.count > 0) {
            
            [HELPER  showNotificationSuccessIn:self withMessage:MESSAGE_SOMETHING_WENT_WRONG];
        }
        else {
            
            [HELPER showRetryAlertIn:self details:ALERT_UNABLE_TO_REACH_DICT retryBlock:^{
                
                if ([HTTPMANAGER isNetworkRechable]) {
                    
                    [HELPER removeRetryAlertIn:self];
                    [HELPER showLoadingIn:self];
                    [self callFavoriteLocationWebService];
                }
            }];
        }
        
        [HELPER removeLoadingIn:self];
    }];
}

- (void)callDeleteWebService {
    
    // http://192.168.0.48/PPTCustomer/API/CustomerFavourites/DeleteFavourites?StrJson={"Favourites_Info":{"Fav_Id":"11","Customer_Id":"49"} }
    
    if (![HTTPMANAGER isNetworkRechable]) {
        
        NSMutableDictionary *aDictAlert = [NSMutableDictionary new];
        
        aDictAlert[KEY_ALERT_TITLE]  = SCREEN_TITLE_FAVORITE_PLACES;
        aDictAlert[KEY_ALERT_DESC]  = [NSString stringWithFormat:@"%@. Tap to try again",ALERT_NO_INTERNET_DESC];
        aDictAlert[KEY_ALERT_IMAGE]  = @"icon_no_internet";
        
        // List is empty so show 'Tap to retry' view
        [HELPER showRetryAlertIn:self details:aDictAlert retryBlock:^{
            
            if ([HTTPMANAGER isNetworkRechable]) {
                
                [HELPER removeRetryAlertIn:self];
                [HELPER removeLoadingIn:self];
                [self callDeleteWebService];
            }
        }];
        return;
    }
    
    NSMutableDictionary *aMutableDict = [NSMutableDictionary new];
    NSMutableDictionary *aLoginMutableDict = [NSMutableDictionary new];
    NSMutableDictionary *aParameterMutableDict = [NSMutableDictionary new];
    
    aMutableDict[K_FAVORITE_ID] = [NSString stringWithFormat:@"%ld",(long)mySelectedRow];
    aMutableDict[K_CUSTOMER_ID] = [SESSION getUserInfo][0][K_CUSTOMER_ID];
    
    aLoginMutableDict[@"Favourites_Info"] = aMutableDict;
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:aLoginMutableDict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *string = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    aParameterMutableDict[@"StrJson"] = string;
    
    [HELPER showLoadingIn:self];
    
    [HTTPMANAGER deleteFavoriteType:aParameterMutableDict primaryLocatio:myFavoritePrimaryLocation completedBlock:^(NSDictionary *response) {
        
        if ([response[kRESPONSE][kRESPONSE_CODE] intValue] == kSUCCESS_CODE || [response[kRESPONSE][kRESPONSE_CODE] intValue] == K_NO_DATA_CODE) {
            
            NSMutableArray *aMainMutableArray = [NSMutableArray new];
            _myInfoMutableArray = [NSMutableArray new];
            
            // This to get the array position based on primary location
            aMainMutableArray = [[COREDATAMANAGER getFavouriteListInfo] mutableCopy];
            NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"favourite_filter" ascending:YES];
            NSArray *aArray = [aMainMutableArray sortedArrayUsingDescriptors:@[sortDescriptor]];
            
            _myInfoMutableArray = [aArray mutableCopy];
        }
        else
            [HELPER showNotificationSuccessIn:self withMessage:MESSAGE_SOMETHING_WENT_WRONG];
        
        mySelectedRow = -1;
        [self tableviewReloadDateWithContent];
        [HELPER removeLoadingIn:self];
        
    } failedBlock:^(NSError *error) {
        
        mySelectedRow = -1;
        if (error.code == NSURLErrorTimedOut)
            [HELPER showRetryAlertIn:self details:ALERT_UNABLE_TO_REACH_DICT retryBlock:^{
                
                if ([HTTPMANAGER isNetworkRechable]) {
                    
                    [HELPER removeRetryAlertIn:self];
                    [HELPER showLoadingIn:self];
                    [self callDeleteWebService];
                }
            }];
        else
            [HELPER showNotificationSuccessIn:self withMessage:MESSAGE_SOMETHING_WENT_WRONG];
        [HELPER removeLoadingIn:self];
    }];
}

- (void)callSaveOrUpdateWebService {
    
    /*
     http://192.168.0.48/PPTCustomer/API/CustomerFavourites/SaveFavourites?StrJson={ "Favourites_Info":{"Fav_Id":"",         "Customer_Id":"11","Latitude":"44.968046","Longitude":"-94.420307","Display_Name":"Siva","Address":"Coimbatore","Primary_Location":"1"} }
     */
    
    if (![HTTPMANAGER isNetworkRechable]) {
        
        NSMutableDictionary *aDictAlert = [NSMutableDictionary new];
        
        aDictAlert[KEY_ALERT_TITLE]  = SCREEN_TITLE_FAVORITE_PLACES;
        aDictAlert[KEY_ALERT_DESC]  = [NSString stringWithFormat:@"%@. Tap to try again",ALERT_NO_INTERNET_DESC];
        aDictAlert[KEY_ALERT_IMAGE]  = @"icon_no_internet";
        
        // List is empty so show 'Tap to retry' view
        [HELPER showRetryAlertIn:self details:aDictAlert retryBlock:^{
            
            if ([HTTPMANAGER isNetworkRechable]) {
                
                [HELPER removeRetryAlertIn:self];
                [HELPER removeLoadingIn:self];
                [self callSaveOrUpdateWebService];
            }
        }];
        return;
    }
    
    NSMutableDictionary *aMutableDict = [NSMutableDictionary new];
    NSMutableDictionary *aLoginMutableDict = [NSMutableDictionary new];
    NSMutableDictionary *aParameterMutableDict = [NSMutableDictionary new];
    
    aMutableDict = myUpdateMutableDictionary;
    aMutableDict[K_CUSTOMER_ID] = [SESSION getUserInfo][0][K_CUSTOMER_ID];
    
    aLoginMutableDict[@"Favourites_Info"] = aMutableDict;
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:aLoginMutableDict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *string = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    aParameterMutableDict[@"StrJson"] = string;
    
    [HELPER showLoadingIn:self];
    
    [HTTPMANAGER saveOrUpdateFavoriteType:aParameterMutableDict completedBlock:^(NSDictionary *response) {
        
        if ([response[kRESPONSE][kRESPONSE_CODE] intValue] == kSUCCESS_CODE) {
            
            NSMutableArray *aMainMutableArray = [NSMutableArray new];
            _myInfoMutableArray = [NSMutableArray new];
            
            // This to get the array position based on primary location
            aMainMutableArray = [[COREDATAMANAGER getFavouriteListInfo] mutableCopy];
            NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"favourite_filter" ascending:YES];
            NSArray *aArray = [aMainMutableArray sortedArrayUsingDescriptors:@[sortDescriptor]];
            
            _myInfoMutableArray = [aArray mutableCopy];
            
            [self tableviewReloadDateWithContent];
        }
        
        else {
            
            [HELPER showNotificationSuccessIn:self withMessage:response[kRESPONSE][kRESPONSE_MESSAGE]];
        }
        [HELPER removeLoadingIn:self];
        
    } failedBlock:^(NSError *error) {
        
        if (error.code == NSURLErrorTimedOut)
            [HELPER showRetryAlertIn:self details:ALERT_UNABLE_TO_REACH_DICT retryBlock:^{
                
                if ([HTTPMANAGER isNetworkRechable]) {
                    
                    [HELPER removeRetryAlertIn:self];
                    [HELPER showLoadingIn:self];
                    [self callSaveOrUpdateWebService];
                }
            }];
        else
            [HELPER showNotificationSuccessIn:self withMessage:MESSAGE_SOMETHING_WENT_WRONG];
        [HELPER removeLoadingIn:self];
    }];
}

#pragma mark - Helper -

- (void)setUpNavigationBar {
    
    self.navigationController.navigationBar.barTintColor = COLOR_NAVIGATION_COLOR;
    self.navigationController.navigationBar.tintColor = WHITE_COLOUR;
    [self.navigationController.navigationBar setTranslucent:YES];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    self.navigationController.navigationBar.layer.shadowColor = (__bridge CGColorRef _Nullable)(WHITE_COLOUR);
    
    // TO SET TILE COLOR & FONT
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:FONT_HELVETICA_NEUE size:14.0];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = WHITE_COLOUR;
    self.navigationItem.titleView = label;
    label.text = TITLE_FAVORITE_PLACES;
    [label sizeToFit];
    
    
    self.navigationItem.leftBarButtonItem  = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(leftBarButtonTapEvent)];
    self.navigationController.navigationBar.tintColor = WHITE_COLOUR;
    
    // self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonTapEvent)];
}

// Hide Keyboard
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
}

-(void)getValueFromDb {
    
    mySelectedRow = -1;
    _myInfoMutableArray = [[COREDATAMANAGER getFavouriteListInfo] mutableCopy];
    
    [self tableviewReloadDateWithContent];
    [self callFavoriteLocationWebService];
}

-(void)tableviewReloadDateWithContent {
    
    if (_myInfoMutableArray.count) {
        
        [self removeAlertView];
        [_myTableView reloadDataWithAnimation];
    }
    else {
        
        [self showAlertView];
    }
}

-(void)removeAlertView {
    
    [HELPER fadeAnimationFor:self.myAlertView alpha:0.0 duration:0.2];
    [HELPER fadeAnimationFor:self.myTableView alpha:1.0 duration:0.2];
}

-(void)showAlertView {
    
    [HELPER fadeAnimationFor:self.myAlertView alpha:1.0 duration:0.2];
    [HELPER fadeAnimationFor:self.myTableView alpha:0.0 duration:0.2];
}


@end
