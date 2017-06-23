//
//  LUFavouriteSearchViewController.m
//  Levare
//
//  Created by Arun Prasad.S, ANGLER - EIT on 11/01/17.
//  Copyright © 2017 AngMac137. All rights reserved.
//

#import "LUFavouriteSearchViewController.h"

@interface LUFavouriteSearchViewController ()<UISearchResultsUpdating,UISearchBarDelegate>
{
    BOOL isSearching;
    GMSPlacesClient *myPlaceClient;
}

//Outlet
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) IBOutlet UIImageView *myAlertImageView;
@property (strong, nonatomic) IBOutlet UIView *myAlertBgView;
@property (strong, nonatomic) IBOutlet UIImageView *myFooterImageView;
@property (strong, nonatomic) IBOutlet UIView *myFooterView;

//Model
@property (strong, nonatomic) NSMutableArray *myInfoArray;
@property (strong, nonatomic) UISearchController *mySearchController;
@property (nonatomic, strong)NSMutableArray *myMArySearchResultsInfo;

@end

@implementation LUFavouriteSearchViewController
@synthesize myTableView,myInfoArray;
@synthesize myMArySearchResultsInfo;

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

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    [self.mySearchController setActive:YES];
    [self.mySearchController.searchBar becomeFirstResponder];
}

#pragma mark -View Init

- (void)setupUI {
    
    [NAVIGATION setTitleWithBarButtonItems:@"" forViewController:self showLeftBarButton:nil showRightBarButton:nil];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    myTableView.tableFooterView = [UIView new];
    myInfoArray = [NSMutableArray new];
    myMArySearchResultsInfo = [NSMutableArray new];
    myPlaceClient = [GMSPlacesClient sharedClient];
}

#pragma mark -Model

- (void)setupModel {
    
    // Search Controller init
    self.mySearchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.mySearchController.searchBar.delegate = self;
    self.mySearchController.searchBar.placeholder = @"Search...";
    self.mySearchController.searchResultsUpdater = self;
    self.mySearchController.hidesNavigationBarDuringPresentation = NO;
    self.mySearchController.dimsBackgroundDuringPresentation = NO;
    self.mySearchController.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    self.mySearchController.searchBar.barTintColor = WHITE_COLOUR;
    self.mySearchController.searchBar.translucent = YES;
    
    [HELPER getColorIgnoredImage:@"icon_power_by_google" imageView:_myFooterImageView color:[UIColor grayColor]];
    myTableView.sectionFooterHeight = 100;
    myTableView.tableFooterView = _myFooterView;
}

- (void)loadModel {
    
    myInfoArray = [SESSION getFavoriteInfoList];
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"favourite_filter" ascending:YES];
    NSArray *aArray = [myInfoArray sortedArrayUsingDescriptors:@[sortDescriptor]];
    
    myInfoArray = [aArray mutableCopy];
    
    /*
     {      "CF_Id": "5",      "Customer_Id": "11",      "PULatitude": "44.968046",      "PULongitude": "-94.420307",      "PUAddress": "Coimbatore",      "Created_On": "09-Nov-2016 15:36:03",      "Upddated_On": "09-Nov-2016 15:36:20",      "Display_Name": "Siva",      "PrimaryLocation": "2"    }  ],  "Response": {    "Response_code": "1",    "Response_Message": "Saved successfully"  }}
     
     */
    
    [self reloadTableViewWithCompleteModel];
    [self startSearching];
}


#pragma mark - UITable view Delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return myMArySearchResultsInfo.count;
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
    
    if ([[myMArySearchResultsInfo objectAtIndex:indexPath.row][@"PrimaryLocation"] isEqualToString:@"1"]) {
        
        gTitleLabel.text = HOME;
        gAddressLabel.text = [myMArySearchResultsInfo objectAtIndex:indexPath.row][@"PUAddress"];
        gImageView.image = [UIImage imageNamed:@"icon_home"];
    }
    else if ([[myMArySearchResultsInfo objectAtIndex:indexPath.row][@"PrimaryLocation"] isEqualToString:@"2"]) {
        
        gTitleLabel.text = OFFICE;
        gAddressLabel.text = [myMArySearchResultsInfo objectAtIndex:indexPath.row][@"PUAddress"];
        gImageView.image = [UIImage imageNamed:@"icon_work"];
    }
    else {
        
        if ([myMArySearchResultsInfo[indexPath.row] objectForKey:@"placeID"]) {
            
            gAddressLabel.text = [myMArySearchResultsInfo objectAtIndex:indexPath.row][@"Display_Name"];// title comes here befor search
            gTitleLabel.text = [myMArySearchResultsInfo objectAtIndex:indexPath.row][@"PUAddress"];// address comes here before search
            
            
        }
        else {
            
            gTitleLabel.text = [myMArySearchResultsInfo objectAtIndex:indexPath.row][@"Display_Name"];// address comes here while search
            gAddressLabel.text = [myMArySearchResultsInfo objectAtIndex:indexPath.row][@"PUAddress"];// title comes here while search
        }
        
        // To set tint color & image in helper class
        [HELPER getColorIgnoredImage:IMAGE_MARKER_DESTINATION imageView:gImageView color:[UIColor lightGrayColor]];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSMutableDictionary *aMDictionary = [NSMutableDictionary new];
    NSMutableArray *aSearchResultMutableArray = [NSMutableArray new];
    
    if ([myMArySearchResultsInfo[indexPath.row] objectForKey:@"placeID"]) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.navigationController dismissViewControllerAnimated:YES completion:^{
                
                [self.navigationController dismissViewControllerAnimated:YES completion:^{
                    
                    if (_isFromSwiftDasbordScreen) {
                        
                        GMSPlacesClient *placeClient = [GMSPlacesClient sharedClient];
                        [placeClient lookUpPlaceID:myMArySearchResultsInfo[indexPath.row][@"placeID"] callback:^(GMSPlace * _Nullable result, NSError * _Nullable error) {
                            
                            if(!error) {
                                
                                NSLog(@"place : %f,%f",result.coordinate.latitude, result.coordinate.longitude);
                                
                                aMDictionary[K_FAVORITE_LATITUDE] = [NSString stringWithFormat:@"%f",result.coordinate.latitude];
                                aMDictionary[K_FAVORITE_LONGITUDE] = [NSString stringWithFormat:@"%f",result.coordinate.longitude];
                                aMDictionary[K_FAVORITE_ADDRESS] = result.formattedAddress;
                                aMDictionary[K_FAVORITE_DISPLAY_NAME] = ([SESSION getFavTitle].length) ? [SESSION getFavTitle] : [myMArySearchResultsInfo objectAtIndex:indexPath.row][@"PUAddress"];
                                aMDictionary[K_FAVORITE_PRIMARY_LOCATION] = @"";
                                aMDictionary[K_FAVORITE_ID] = @"";
                                
                                [aSearchResultMutableArray addObject:aMDictionary];
                                
                                [self.gDelegate getSelectedAddressFromGMSList:aMDictionary iscallBack:YES];
                                
                            } else {
                                
                                NSLog(@"Error : %@",error.localizedDescription);
                            }
                        }];
                    }
                    
                    else {
                        
                        if (_callBackBlock) {
                            
                            GMSPlacesClient *placeClient = [GMSPlacesClient sharedClient];
                            [placeClient lookUpPlaceID:myMArySearchResultsInfo[indexPath.row][@"placeID"] callback:^(GMSPlace * _Nullable result, NSError * _Nullable error) {
                                
                                if(!error) {
                                    
                                    NSLog(@"place : %f,%f",result.coordinate.latitude, result.coordinate.longitude);
                                    
                                    aMDictionary[K_FAVORITE_LATITUDE] = [NSString stringWithFormat:@"%f",result.coordinate.latitude];
                                    aMDictionary[K_FAVORITE_LONGITUDE] = [NSString stringWithFormat:@"%f",result.coordinate.longitude];
                                    aMDictionary[K_FAVORITE_ADDRESS] = result.formattedAddress;
                                    aMDictionary[K_FAVORITE_DISPLAY_NAME] = ([SESSION getFavTitle].length) ? [SESSION getFavTitle] : [myMArySearchResultsInfo objectAtIndex:indexPath.row][@"PUAddress"];
                                    aMDictionary[K_FAVORITE_PRIMARY_LOCATION] = @"";
                                    aMDictionary[K_FAVORITE_ID] = @"";
                                    
                                    [aSearchResultMutableArray addObject:aMDictionary];
                                    
                                    _callBackBlock(YES, aSearchResultMutableArray);
                                    
                                } else {
                                    
                                    NSLog(@"Error : %@",error.localizedDescription);
                                }
                            }];
                        }
                    }
                }];
            }];
        });
    }
    else {
        
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
            
            [self.navigationController dismissViewControllerAnimated:YES completion:^{
                
                if (_isFromSwiftDasbordScreen) {
                    
                    NSMutableArray *aMarray = [NSMutableArray new];
                    
                    aMDictionary[K_FAVORITE_LATITUDE] = myMArySearchResultsInfo[indexPath.row][@"PULatitude"];
                    aMDictionary[K_FAVORITE_LONGITUDE] = myMArySearchResultsInfo[indexPath.row][@"PULongitude"];
                    aMDictionary[K_FAVORITE_ADDRESS] = myMArySearchResultsInfo[indexPath.row][@"PUAddress"];
                    aMDictionary[K_FAVORITE_DISPLAY_NAME] = myMArySearchResultsInfo[indexPath.row][@"Display_Name"];
                    aMDictionary[K_FAVORITE_PRIMARY_LOCATION] = @"";
                    aMDictionary[K_FAVORITE_ID] = @"";
                    
                    [aMarray addObject:aMDictionary];
                    
                    [self.gDelegate getSelectedAddressFromGMSList:aMDictionary iscallBack:YES];
                }
                
                else {
                    
                    if (_callBackBlock) {
                        NSMutableArray *aMarray = [NSMutableArray new];
                        
                        aMDictionary[K_FAVORITE_LATITUDE] = myMArySearchResultsInfo[indexPath.row][@"PULatitude"];
                        aMDictionary[K_FAVORITE_LONGITUDE] = myMArySearchResultsInfo[indexPath.row][@"PULongitude"];
                        aMDictionary[K_FAVORITE_ADDRESS] = myMArySearchResultsInfo[indexPath.row][@"PUAddress"];
                        aMDictionary[K_FAVORITE_DISPLAY_NAME] = myMArySearchResultsInfo[indexPath.row][@"Display_Name"];
                        aMDictionary[K_FAVORITE_PRIMARY_LOCATION] = @"";
                        aMDictionary[K_FAVORITE_ID] = @"";
                        
                        [aMarray addObject:aMDictionary];
                        
                        _callBackBlock(YES, aMarray);
                    }
                }
            }];
        }];
    }
}


#pragma mark - UIButton methods -

-(void)leftBarButtonTapEvent {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)rightBarButtonTapEvent {
    
}
- (IBAction)tryAgainButtonTapped:(id)sender {
    
    NSString *aSearchString = _mySearchController.searchBar.text;
    NSMutableArray *aSearchResultMutableArray = [NSMutableArray new];
    NSMutableDictionary *aMutableDict = [NSMutableDictionary new];
    
    
    if (aSearchString.length) {
        
        NSString *aCountryString = [SESSION getCurrentCountryDetails][0][kCountryCode];
        
        GMSAutocompleteFilter *filter = [[GMSAutocompleteFilter alloc] init];
        filter.type = kGMSPlacesAutocompleteTypeFilterRegion;
        
        if (aCountryString.length)
            filter.country = aCountryString;
        
        [myPlaceClient autocompleteQuery:aSearchString
                                  bounds:nil
                                  filter:filter
                                callback:^(NSArray *results, NSError *error) {
                                    
                                    if (error != nil) {
                                        NSLog(@"Autocomplete error %@", [error localizedDescription]);
                                        return;
                                    }
                                    
                                    for (GMSAutocompletePrediction* result in results) {
                                        
                                        aMutableDict[@"PUAddress"] = [result.attributedPrimaryText string];
                                        aMutableDict[@"Display_Name"] = [result.attributedSecondaryText  string];
                                        aMutableDict[@"placeID"] = result.placeID;
                                        aMutableDict[@"PrimaryLocation"] = @"0";
                                        
                                        [aSearchResultMutableArray addObject:aMutableDict];
                                    }
                                }];
    }
    
    if (aSearchResultMutableArray.count) {
        
        [self removeNoRecordsAlert];
        self.myMArySearchResultsInfo = aSearchResultMutableArray;
        [self.myTableView reloadDataWithAnimation];
    }
    else if(_mySearchController.searchBar.text.length == 0) {
        
        [self removeNoRecordsAlert];
        [self reloadTableViewWithCompleteModel];
    }
    else {
        // No result found alert
        self.myMArySearchResultsInfo = aSearchResultMutableArray;
        [self.myTableView reloadDataWithAnimation];
        [self showNoRecordsAlert];
    }
    
    
}

#pragma mark - Navigation Bar -

#pragma mark - setup Navigation Items

- (void)setupSearchNavigationItem {
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchBarItemTapped)];
    self.navigationItem.rightBarButtonItem.tintColor = WHITE_COLOUR;
}

#pragma mark -Tap event

- (void)searchBarItemTapped {
    
    if (myInfoArray.count == 0) {
        // do nothing if list is empty
        self.navigationItem.rightBarButtonItem = nil;
        return;
    }
    
    [self startSearching];
}


#pragma mark - Search Methods -

#pragma mark -Search Bar

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
    [self stopSearching];
}

#pragma mark -Search Result Updating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    NSString *aSearchString = searchController.searchBar.text;
    NSMutableArray *aSearchResultMutableArray = [NSMutableArray new];
    
    // Filter for array index
    
    if (aSearchString.length) {
        
        NSString *aCountryString = [SESSION getCurrentCountryDetails][0][kCountryCode];
        
        GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] initWithCoordinate:_gLocationCoordinate coordinate:_gLocationCoordinate];
        
        GMSAutocompleteFilter *filter = [[GMSAutocompleteFilter alloc] init];
        filter.type = kGMSPlacesAutocompleteTypeFilterNoFilter;
        if (aCountryString.length)
            filter.country = aCountryString;
        
        
        [myPlaceClient autocompleteQuery:aSearchString
                                  bounds:bounds
                                  filter:nil
                                callback:^(NSArray *results, NSError *error) {
                                    
                                    if (error != nil) {
                                        NSLog(@"Autocomplete error %@", [error localizedDescription]);
                                        return;
                                    }
                                    
                                    for (GMSAutocompletePrediction* result in results) {
                                        
                                        NSMutableDictionary *aMutableDict = [NSMutableDictionary new];
                                        
                                        aMutableDict[@"PUAddress"] = [result.attributedPrimaryText string];
                                        aMutableDict[@"Display_Name"] = [result.attributedSecondaryText  string];
                                        aMutableDict[@"placeID"] = result.placeID;
                                        aMutableDict[@"PrimaryLocation"] = @"0";
                                        
                                        [aSearchResultMutableArray addObject:aMutableDict];
                                    }
                                    
                                    if (aSearchResultMutableArray.count) {
                                        
                                        [self removeNoRecordsAlert];
                                        self.myMArySearchResultsInfo = aSearchResultMutableArray;
                                        [self.myTableView reloadDataWithAnimation];
                                    }
                                    else if(searchController.searchBar.text.length == 0) {
                                        
                                        [self removeNoRecordsAlert];
                                        [self reloadTableViewWithCompleteModel];
                                    }
                                    else {
                                        // No result found alert
                                        self.myMArySearchResultsInfo = aSearchResultMutableArray;
                                        [self.myTableView reloadDataWithAnimation];
                                        [self showNoRecordsAlert];
                                    }
                                }];
    }
    else {
        
        if(searchController.searchBar.text.length == 0) {
            
            [self removeNoRecordsAlert];
            [self reloadTableViewWithCompleteModel];
        }
        else {
            // No result found alert
            self.myMArySearchResultsInfo = aSearchResultMutableArray;
            [self.myTableView reloadDataWithAnimation];
            [self showNoRecordsAlert];
        }
    }
}

#pragma mark -Searching

- (void)startSearching {
    
    isSearching = YES;
    self.navigationItem.rightBarButtonItem = nil;
    
    // Add search bar into Navigation bar titleView
    self.navigationItem.titleView = self.mySearchController.searchBar;
    [self.mySearchController.searchBar becomeFirstResponder];
}


- (void)stopSearching {
    
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
        if (_callBackBlock) {
            
            _callBackBlock(NO, [NSMutableArray new]);
            
        }
        
    }];
}


#pragma mark - Helper -

- (void)reloadTableViewWithCompleteModel {
    
    self.myMArySearchResultsInfo = [myInfoArray mutableCopy];
    [self.myTableView reloadDataWithAnimation];
}

-(void)showNoRecordsAlert {
    
    [HELPER fadeAnimationFor:_myAlertBgView alpha:1.0];
    [HELPER fadeAnimationFor:self.myTableView alpha:0.0];
}

-(void)removeNoRecordsAlert {
    
    [HELPER fadeAnimationFor:_myAlertBgView alpha:0.0];
    [HELPER fadeAnimationFor:self.myTableView alpha:1.0];
}

@end
