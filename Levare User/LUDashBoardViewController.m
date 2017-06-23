
//
//  LUDashBoardViewController.m
//  Levare User
//
//  Created by AngMac137 on 11/22/16.
//  Copyright © 2016 AngMac137. All rights reserved.
//

#import "LUDashBoardViewController.h"
#import "CRPSampleLayout.h"
#import "LUDashBoardRequestViewController.h"
#import "LUTestViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "Levare User-Bridging-Header.h"
#import "Levare-Swift.h"


@interface LUDashBoardViewController ()<CLLocationManagerDelegate,
GMSMapViewDelegate, UITextFieldDelegate, UIScrollViewDelegate>

{
    BOOL isFavSource, isForFavLocation;
    BOOL isFavDestination, gettingAddressFromLatLng;
    NSInteger isMapViewChanged;
    NSInteger myDeltingLocation, myServiceIndex;
    
    CLLocationCoordinate2D myLocationCoordinate, myCurrentLocationCoordinate, myCurrentUserlocationCoordinate;
    CLLocationManager *myLocationManager;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
    GMSPolyline *myRoutePolyLine; //your line
    MKPolylineRenderer *myRoutePolyLineView; //overlay view
}

@property (strong, nonatomic) IBOutlet GMSMapView *myMapView;

@property (strong, nonatomic) IBOutlet UIView *mySearchView;
@property (strong, nonatomic) IBOutlet UIView *mySearchSourceView;
@property (strong, nonatomic) IBOutlet UITextField *mySearchSourceTextfield;
@property (strong, nonatomic) IBOutlet UILabel *mySearchSourceLabel;
@property (strong, nonatomic) IBOutlet UIImageView *mySearchSourceImageView;
@property (strong, nonatomic) IBOutlet UIView *mySearchDistinationView;
@property (strong, nonatomic) IBOutlet UITextField *mySearchDistinationTextfield;
@property (strong, nonatomic) IBOutlet UILabel *mySearchDistinationLabel;
@property (strong, nonatomic) IBOutlet UIImageView *mySearchDistinationImageView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *mySearchSourceViewBottomConstraint;
@property (strong, nonatomic) IBOutlet UICollectionView *myCollectionView;
@property (strong, nonatomic) IBOutlet UIButton *mySubmitButton;
@property(strong, nonatomic) IBOutlet UIView *myActivityIndicatorView;
@property (strong, nonatomic) IBOutlet UIImageView *myMapAnnotationImageView;

@property (strong, nonatomic) IBOutlet UIButton *myDestinationFavButton;
@property (strong, nonatomic) IBOutlet UIButton *mySourceFavButton;
@property (strong, nonatomic) IBOutlet UIButton *myCurrentLocationButton;

// Model
@property (nonatomic, strong) NSMutableArray *myInfoMutableArray, *myCancelReasonMutableArray, *mySearchMutableInfo;
@property (nonatomic, strong) NSMutableArray *myMapInfoArray, *myMapLocationMutableArray, *mySignalRConnectionMutableArray;
@property (nonatomic, strong) NSMutableArray *myServiceTypeMutableArray, *myServiceLocationTypeMutableArray, *myRideResponseMutableArray;

@property (nonatomic, strong) NSMutableDictionary *myFavDestMutableDictionary, *myFavSourseMutableDictionary, *myCurrentFavMutableDict;
@property (nonatomic, strong) NSString *myAddressString, *myFavoriteIdString, *myFavoriteDestinationIdString, *myFavPrimaryLocation, *myCountryNameString;
@property (nonatomic, strong) NSIndexPath *myCenterIndexPath;


@end

@implementation LUDashBoardViewController
@synthesize myFavDestMutableDictionary, myFavSourseMutableDictionary, myCurrentFavMutableDict;
@synthesize myAddressString, myFavoriteIdString, myFavoriteDestinationIdString, myFavPrimaryLocation, myCountryNameString;
@synthesize myCenterIndexPath;

#pragma mark - View & Model -

#pragma mark -View Life Cycle

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

-(void)setup {
    
    [self setupModel];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // setup UI & Content
    [self setupUI];
    
    // Load Contents
    [self loadModel];
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewWillAppear:(BOOL)animated {
    
    if ([SESSION getSearchInfo].count) {
        
        _mySearchSourceTextfield.text = [SESSION getSearchInfo][0];
        _mySearchDistinationTextfield.text = [SESSION getSearchInfo][1];
        isFavSource = ([[SESSION getSearchInfo][2] isEqualToString:@"1"]) ? YES : NO;
        isFavDestination = ([[SESSION getSearchInfo][3] isEqualToString:@"1"]) ? YES : NO;
        
        _myMapInfoArray= [NSMutableArray new];
        _myMapLocationMutableArray = [NSMutableArray new];
        
        [_myMapInfoArray addObject:[SESSION getSearchInfo][4]];
        [_myMapInfoArray addObject:[SESSION getSearchInfo][5]];
        
        _mySourceFavButton.selected = isFavSource;
        _myDestinationFavButton.selected = isFavDestination;
        
        _myMapLocationMutableArray = _myMapInfoArray;
        
        NSMutableArray * aMutableArray = [NSMutableArray new];
        [SESSION setSearchInfo:aMutableArray];
        _myMapView.hidden = NO;
    }
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    
    /*
     LUTestViewController *aViewController = [STORY_BOARD instantiateViewControllerWithIdentifier:@"LUTestViewController"];
     
     UINavigationController *aNavigationController = [[UINavigationController alloc]initWithRootViewController:aViewController];
     [self.navigationController presentViewController:aNavigationController animated:YES completion:nil];*/
}

-(void)viewWillDisappear:(BOOL)animated {
    
}

#pragma mark -View Init

- (void)setupUI {
    
    // To set navigation bar to present with navigation
    [self setUpNavigationBar];
    myServiceIndex = 1;
    
    _myMapView.hidden = YES;
    _myMapAnnotationImageView.hidden = NO;
    _myCurrentLocationButton.hidden = NO;
    [HELPER roundCornerForView:_mySearchSourceImageView withRadius:6];
    [HELPER roundCornerForView:_mySearchDistinationImageView withRadius:6];
    
    _mySearchSourceTextfield.delegate = self;
    _mySearchDistinationTextfield.delegate = self;
    
    _myCollectionView.decelerationRate = UIScrollViewDecelerationRateFast;
    myFavDestMutableDictionary = myFavSourseMutableDictionary = [NSMutableDictionary new];
    myDeltingLocation = -1;
    _myDestinationFavButton.userInteractionEnabled = YES;
    _mySourceFavButton.userInteractionEnabled = YES;
    myFavoriteIdString = myFavPrimaryLocation = myFavoriteDestinationIdString = @"";
    
    myCurrentFavMutableDict = [NSMutableDictionary new];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeViewBasedOnFav:) name:VIEW_UPADTE_BASED_ON_FAV_STATUS object:nil];
    
    [HELPER showLoadingIn:self];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self callServiceTypeWebService];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self callFavoriteLocationWebService];
        });
    });
    
    //    _mySearchView.backgroundColor = WHITE_COLOUR;
    
}

#pragma mark -Model

- (void)setupModel {
    
    _myMapInfoArray= [NSMutableArray new];
    _myMapLocationMutableArray = [NSMutableArray new];
    
    geocoder = [[CLGeocoder alloc] init];
    [CLLocationManager locationServicesEnabled];
    myLocationManager = [[CLLocationManager alloc] init];
    myLocationManager.delegate = self;
    myLocationManager.distanceFilter = 1;
    [myLocationManager requestAlwaysAuthorization];
    myLocationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [myLocationManager startUpdatingLocation];
    myCenterIndexPath = [NSIndexPath indexPathForItem:1 inSection:0];
}

- (void)loadModel {
    
    _mySearchTypeEnum = SEARCH_TYPE_SOURCE;
    
    self.myMapView.delegate = self;
    self.myMapView.myLocationEnabled = YES;
    self.myMapView.settings.myLocationButton = NO;
    [self.myMapView setMapType:kGMSTypeNormal];
    
    // _myCurrentLocationButton.hidden = YES;
    _mySearchSourceViewBottomConstraint.constant = 8;
    
}



#pragma mark - CollectionView Methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _myInfoMutableArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellIdentifier =@"vehicleCell";
    
    UICollectionViewCell* aCell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    UIImageView *aImageView = [aCell viewWithTag:1];
    UILabel * aVehicleNameLabel = [aCell viewWithTag:2];
    UILabel * aPeopleLabel = [aCell viewWithTag:3];
    
    TagServiceType *aTag = (TagServiceType *)[_myInfoMutableArray objectAtIndex:indexPath.item];
    
    if (indexPath.row == 0 || indexPath.row == _myInfoMutableArray.count - 1) {
        
        aImageView.hidden = YES;
        aVehicleNameLabel.text = @"";
        aPeopleLabel.text = @"";
    }
    
    else {
        
        aImageView.hidden = NO;
        [HELPER setURLProfileImageForImageView:aImageView URL:aTag.service_type_icon placeHolderImage:@"icon_service_car_placeholder"];
        aVehicleNameLabel.text = aTag.service_type_name;
        aPeopleLabel.text =  TWO_STRING(aTag.vehicle_max_range , @" Peoples");
        
        aCell.transform = CGAffineTransformMakeScale(1.0,1.0);
        
        if (myCenterIndexPath != nil) {
            
            if (myCenterIndexPath.row == indexPath.row) {
                
                myServiceIndex = indexPath.row;
                
                [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    
                    aCell.transform = CGAffineTransformMakeScale(1.4,1.41);
                }
                                 completion:^(BOOL finished) {
                                     
                                 }];
            }
            
        }
        
        else {
            
            
        }
    }
    return aCell;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(4, 0, 4, 0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(100, 120);
    
}

-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    // aCell = (UICollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
}

#pragma mark - Scrollview Delegate -

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    CGPoint centerPoint = CGPointMake(self.myCollectionView.frame.size.width / 2 + scrollView.contentOffset.x, self.myCollectionView.frame.size.height /2 + scrollView.contentOffset.y);
    myCenterIndexPath = [self.myCollectionView indexPathForItemAtPoint:centerPoint];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.myCollectionView reloadData];
        
    });
    
    
    
}

#pragma mark - TextField Delegates

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    //  NSString *aUpdateString=[textField.text stringByReplacingCharactersInRange:range withString:string];
    
    
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    if (textField == _mySearchSourceTextfield) {
        
        _mySearchTypeEnum = SEARCH_TYPE_SOURCE;
        // _myCurrentLocationButton.hidden = NO;
        
        if (_mySearchSourceView.userInteractionEnabled == NO) {
            
            _mySearchSourceView.userInteractionEnabled = YES;
            _mySearchDistinationView.userInteractionEnabled = NO;
            _mySearchSourceView.backgroundColor = [UIColor clearColor];
            _mySearchDistinationView.backgroundColor = [HELPER getColorFromHexaDecimal:COLOR_GROUP_TABLE_VIEW];
            
            [UIView transitionWithView:self.view duration:5 options:UIViewAnimationOptionCurveEaseOut animations:^{
                
                // Set your final view position here
                
                if (self.mySearchSourceTextfield.text.length > 0) {
                    
                    _mySourceFavButton.selected = isFavSource;
                    _mySourceFavButton.hidden = NO;
                    _myDestinationFavButton.userInteractionEnabled = NO;
                    _mySourceFavButton.userInteractionEnabled = YES;
                }
                
                _myDestinationFavButton.hidden = YES;
                
                [_mySearchView bringSubviewToFront:_mySearchSourceView];
                [_mySearchView bringSubviewToFront:_mySearchSourceImageView];
                [_mySearchView bringSubviewToFront:_mySearchSourceTextfield];
                [_mySearchView bringSubviewToFront:_mySourceFavButton];
                
            } completion:^(BOOL finished) {
                
            }];
            
            if (_myMapInfoArray.count >= 1) {
                
                NSArray *aLocationArray = [_myMapInfoArray[0] componentsSeparatedByString:@","];
                
                if (aLocationArray.count == 2) {
                    
                    myCurrentFavMutableDict[K_FAVORITE_LATITUDE] = aLocationArray[0];
                    myCurrentFavMutableDict[K_FAVORITE_LONGITUDE] = aLocationArray[1];
                    
                    myLocationCoordinate = CLLocationCoordinate2DMake([aLocationArray[0] doubleValue], [aLocationArray[1] doubleValue]);
                    myCurrentLocationCoordinate = myLocationCoordinate;
                }
                isForFavLocation = YES;
                isMapViewChanged = 1;
                [self showLoadingActivityIndicator];
                [self getAddressFromLocation:myLocationCoordinate];
                
                [self zoomToLocation:myLocationCoordinate];
            }
            return NO;
        }
        else {
            
            [self showGMSAutocompleteViewController];
        }
    }
    else {
        
        _mySearchTypeEnum = SEARCH_TYPE_DESTINATION;
        
        if (_mySearchDistinationView.userInteractionEnabled == NO) {
            
            _mySearchSourceView.userInteractionEnabled = NO;
            _mySearchDistinationView.userInteractionEnabled = YES;
            _mySearchSourceView.backgroundColor = [HELPER getColorFromHexaDecimal:COLOR_GROUP_TABLE_VIEW];
            _mySearchDistinationView.backgroundColor = [UIColor clearColor];
            
            [UIView transitionWithView:self.view duration:5 options:UIViewAnimationOptionCurveEaseOut animations:^{
                
                // Set your final view position here
                
                if (_mySearchDistinationTextfield.text.length) {
                    
                    _myDestinationFavButton.selected = isFavDestination;
                    _myDestinationFavButton.hidden = NO;
                    _myDestinationFavButton.userInteractionEnabled = YES;
                    _mySourceFavButton.userInteractionEnabled = NO;
                }
                _mySourceFavButton.hidden = YES;
                //  [HELPER setCardViewEfforForView:_mySearchDistinationView];
                //  [HELPER removeCardViewEfforFromView:_mySearchSourceView];
                
                [_mySearchView bringSubviewToFront:_mySearchDistinationView];
                [_mySearchView bringSubviewToFront:_mySearchDistinationImageView];
                [_mySearchView bringSubviewToFront:_mySearchDistinationTextfield];
                [_mySearchView bringSubviewToFront:_myDestinationFavButton];
                
            } completion:^(BOOL finished) {
                
            }];
            
            if (_myMapInfoArray.count > 1) {
                
                NSArray *aLocationArray = [_myMapInfoArray[1] componentsSeparatedByString:@","];
                
                if (aLocationArray.count == 2) {
                    
                    myCurrentFavMutableDict[K_FAVORITE_LATITUDE] = aLocationArray[0];
                    myCurrentFavMutableDict[K_FAVORITE_LONGITUDE] = aLocationArray[1];
                    
                    myLocationCoordinate = CLLocationCoordinate2DMake([aLocationArray[0] doubleValue], [aLocationArray[1] doubleValue]);
                    myCurrentLocationCoordinate = myLocationCoordinate;
                }
                
                isForFavLocation = YES;
                isMapViewChanged = 1;
                [self showLoadingActivityIndicator];
                [self getAddressFromLocation:myLocationCoordinate];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [self zoomToLocation:myLocationCoordinate];
                });
                
            }
            return NO;
        }
        else {
            
            [self showGMSAutocompleteViewController];
        }
    }
    
    
    return NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField.returnKeyType == UIReturnKeyNext) {
        
    }
    else {
        
        [self.view endEditing:YES];
    }
    
    return YES;
}


#pragma mark - UIButton methods -


- (void)leftBarButtonTapEvent {
    
    [APPDELEGATE.sideMenu toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}
- (IBAction)selectVehicleTapped:(id)sender {
    
    
    if (_mySearchSourceTextfield.text.length == 0) {
        
        [HELPER showNotificationSuccessIn:self withMessage:@"Please choose your From location"];
        return;
    }
    
    else if (_mySearchDistinationTextfield.text.length == 0) {
        
        [HELPER showNotificationSuccessIn:self withMessage:@"Please choose your To location"];
        return;
    }
    
    else {
        
        if (_myMapInfoArray.count < 2) {
            
            _myMapInfoArray = _myMapLocationMutableArray;
        }
        NSMutableArray * aMutableArray = [NSMutableArray new];
        
        [aMutableArray addObject:_mySearchSourceTextfield.text];
        [aMutableArray addObject:_mySearchDistinationTextfield.text];
        [aMutableArray addObject:(isFavSource) ? @"1" : @"0"];
        [aMutableArray addObject:(isFavDestination) ? @"1" : @"0"];
        [aMutableArray addObject:_myMapInfoArray[0]];
        [aMutableArray addObject:_myMapInfoArray[1]];
        
        [SESSION setSearchInfo:aMutableArray];
        
        
        DashBoardRequestViewController *aViewController = [STORY_BOARD instantiateViewControllerWithIdentifier:@"DashBoardRequestViewController"];
         aViewController.gMapMutableInfo = [NSMutableArray new];
         aViewController.gMapMutableInfo = _myMapInfoArray;
        aViewController.gServiceTag = _myInfoMutableArray[myServiceIndex];
        
        NSMutableArray *arrayOfLocation = [[NSMutableArray alloc]init];
        [arrayOfLocation addObject:[NSString stringWithFormat:@"%@",_mySearchSourceTextfield.text]];
        [arrayOfLocation addObject:[NSString stringWithFormat:@"%@",_mySearchDistinationTextfield.text]];
        
        aViewController.gSearchInfoArray = arrayOfLocation;
        aViewController.isFavSource = isFavSource;
        aViewController.isFavDestination = isFavDestination;
        aViewController.gfavoriteIdString = myFavoriteIdString;
        aViewController.gFavoriteDestinationIdString = myFavoriteDestinationIdString;
        
        
        [self.navigationController pushViewController:aViewController animated:YES];
    }
}

- (IBAction)favSourceButtonTapped:(id)sender {
    
    if (isFavSource) {
        
        [self callDeleteWebService];
    }
    else {
        
        // To add the location as favorite
        [self addOrDeletebasedOnTheButtonStatus];
    }
}
- (IBAction)favDescButtonTapped:(id)sender {
    
    if (isFavDestination) {
        
        [self callDeleteWebService];
    }
    else {
        
        [self addOrDeletebasedOnTheButtonStatus];
    }
}
- (IBAction)currentLocationButtonTapped:(id)sender {
    
    self.myMapView.myLocationEnabled = YES;
    [myLocationManager startUpdatingLocation];
    
    // _myCurrentLocationButton.hidden = YES;
}

#pragma mark - GMSAUTO COMPLETE -

- (void)showGMSAutocompleteViewController {
    
    // To change favorite id based on the field for delete action
    
    if (_mySearchTypeEnum == SEARCH_TYPE_SOURCE) {
        
        _mySourceFavButton.selected = isFavSource;
        _mySourceFavButton.hidden = NO;
        _myDestinationFavButton.userInteractionEnabled = NO;
        _mySourceFavButton.userInteractionEnabled = YES;
    }
    else {
        
        _myDestinationFavButton.selected = isFavDestination;
        _myDestinationFavButton.hidden = NO;
        _myDestinationFavButton.userInteractionEnabled = YES;
        _mySourceFavButton.userInteractionEnabled = NO;
    }
    
    LUFavouriteSearchViewController * aViewController = [STORY_BOARD instantiateViewControllerWithIdentifier:@"LUFavouriteSearchViewController"];
    aViewController.gLocationCoordinate = _myMapView.myLocation.coordinate;
    aViewController.callBackBlock =^(BOOL isCallBack, NSMutableArray *aMutableArray){
        
        if (isCallBack) {
            
            // Do something with the selected place
            
            NSMutableDictionary *aMDictionary = [NSMutableDictionary new];
            
            aMDictionary[K_FAVORITE_LATITUDE] = [aMutableArray objectAtIndex:0][K_FAVORITE_LATITUDE];
            aMDictionary[K_FAVORITE_LONGITUDE] = [aMutableArray objectAtIndex:0][K_FAVORITE_LONGITUDE];
            aMDictionary[K_FAVORITE_ADDRESS] = [aMutableArray objectAtIndex:0][K_FAVORITE_ADDRESS];
            aMDictionary[K_FAVORITE_DISPLAY_NAME] = @"";
            aMDictionary[K_FAVORITE_PRIMARY_LOCATION] = @"";
            aMDictionary[K_FAVORITE_ID] = @"";
            
            myCurrentFavMutableDict[K_FAVORITE_LATITUDE] = aMutableArray[0][K_FAVORITE_LATITUDE];
            myCurrentFavMutableDict[K_FAVORITE_LONGITUDE] = aMutableArray[0][K_FAVORITE_LONGITUDE];
            myCurrentFavMutableDict[K_FAVORITE_ADDRESS] = [aMutableArray objectAtIndex:0][K_FAVORITE_ADDRESS];
            
            
            myLocationCoordinate = CLLocationCoordinate2DMake([[aMutableArray objectAtIndex:0][K_FAVORITE_LATITUDE] doubleValue], [[aMutableArray objectAtIndex:0][K_FAVORITE_LONGITUDE] doubleValue]);
            myCurrentLocationCoordinate = myLocationCoordinate;
            
            // Set text in textfield based on the search
            if (_mySearchTypeEnum == SEARCH_TYPE_SOURCE) {
                
                if (_myMapInfoArray.count) {
                    
                    if ( _myMapInfoArray.count > 1)
                        [_myMapInfoArray replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"%@,%@",aMDictionary[K_FAVORITE_LATITUDE],aMDictionary[K_FAVORITE_LONGITUDE]]];
                    else
                        [_myMapInfoArray addObject:[NSString stringWithFormat:@"%@,%@",aMDictionary[K_FAVORITE_LATITUDE],aMDictionary[K_FAVORITE_LONGITUDE]]];
                }
                else
                    [_myMapInfoArray addObject:[NSString stringWithFormat:@"%@,%@",aMDictionary[K_FAVORITE_LATITUDE],aMDictionary[K_FAVORITE_LONGITUDE]]];
                
                myFavSourseMutableDictionary = aMDictionary;
                _myDestinationFavButton.hidden = YES;
                _mySourceFavButton.hidden = NO;
                _myDestinationFavButton.userInteractionEnabled = NO;
                _mySourceFavButton.userInteractionEnabled = YES;
                _mySearchSourceView.userInteractionEnabled = YES;
                _mySearchDistinationView.userInteractionEnabled = NO;
                _mySearchSourceView.backgroundColor = [UIColor clearColor];
                _mySearchDistinationView.backgroundColor = [HELPER getColorFromHexaDecimal:COLOR_GROUP_TABLE_VIEW];
                _mySearchSourceTextfield.text = [aMutableArray objectAtIndex:0][K_FAVORITE_ADDRESS];
                
                if (isFavSource) {
                    
                    _mySourceFavButton.selected = YES;
                    isFavSource = YES;
                }
                else {
                    
                    _myDestinationFavButton.selected = YES;
                    isFavDestination = YES;
                }
                
            }
            else {
                
                if (_myMapInfoArray.count) {
                    
                    if ( _myMapInfoArray.count > 1)
                        [_myMapInfoArray replaceObjectAtIndex:1 withObject:[NSString stringWithFormat:@"%@,%@",aMDictionary[K_FAVORITE_LATITUDE],aMDictionary[K_FAVORITE_LONGITUDE]]];
                    else
                        [_myMapInfoArray addObject:[NSString stringWithFormat:@"%@,%@",aMDictionary[K_FAVORITE_LATITUDE],aMDictionary[K_FAVORITE_LONGITUDE]]];
                }
                else
                    [_myMapInfoArray addObject:[NSString stringWithFormat:@"%@,%@",aMDictionary[K_FAVORITE_LATITUDE],aMDictionary[K_FAVORITE_LONGITUDE]]];
                
                myFavDestMutableDictionary = aMDictionary;
                _myDestinationFavButton.hidden = NO;
                _mySourceFavButton.hidden = YES;
                _myDestinationFavButton.userInteractionEnabled = YES;
                _mySourceFavButton.userInteractionEnabled = NO;
                _mySearchSourceView.userInteractionEnabled = NO;
                _mySearchDistinationView.userInteractionEnabled = YES;
                _mySearchSourceView.backgroundColor = [HELPER getColorFromHexaDecimal:COLOR_GROUP_TABLE_VIEW];
                _mySearchDistinationView.backgroundColor = [UIColor clearColor];
                _mySearchDistinationTextfield.text = [aMutableArray objectAtIndex:0][K_FAVORITE_ADDRESS];
                
            }
            isMapViewChanged = 0;
            isForFavLocation = YES;
            
            [self showLoadingActivityIndicator];
            [self getAddressFromSearchedLocation:myLocationCoordinate];
            [self zoomToLocation:myLocationCoordinate];
        }
        else {
            
            if (_mySearchTypeEnum == SEARCH_TYPE_SOURCE) {
                
                if (_mySearchSourceTextfield.text.length) {
                    
                    _mySourceFavButton.selected = isFavSource;
                    _mySourceFavButton.hidden = NO;
                    _myDestinationFavButton.userInteractionEnabled = NO;
                    _mySourceFavButton.userInteractionEnabled = YES;
                }
                else
                    _mySourceFavButton.hidden = YES;
            }
            else {
                
                if (_mySearchDistinationTextfield.text.length) {
                    
                    _myDestinationFavButton.selected = isFavDestination;
                    _myDestinationFavButton.hidden = NO;
                    _myDestinationFavButton.userInteractionEnabled = YES;
                    _mySourceFavButton.userInteractionEnabled = NO;
                }
                else
                    _myDestinationFavButton.hidden = YES;
            }
        }
    };
    UINavigationController *aNavigationController = [[UINavigationController alloc]initWithRootViewController:aViewController];
    [self.navigationController presentViewController:aNavigationController animated:YES completion:nil];
}


#pragma mark - Helper -

#pragma mark -Acitivity Indicator

- (void)showLoadingActivityIndicator {
    
    [self.view bringSubviewToFront:self.myActivityIndicatorView];
    [HELPER fadeAnimationFor:self.myActivityIndicatorView alpha:1.0];
}

- (void)hideLoadingActivityIndicator {
    
    [HELPER fadeAnimationFor:self.myActivityIndicatorView alpha:0.0];
}

#pragma mark - Location -

#pragma mark -Delegate

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
    
    if (locations.count) {
        
        CLLocation *aLocation = locations[0];
        
        // This is method is getting called as soon as screen is loaded but the lat lng is incorrect, its not user location so below code is a workaround
        if (aLocation.coordinate.longitude == -40.0) {
            return;
        }
        
        [manager stopUpdatingLocation];
        
        // Set text in textfield based on the search
        if (_mySearchTypeEnum == SEARCH_TYPE_SOURCE) {
            
            _myDestinationFavButton.hidden = YES;
            _mySourceFavButton.selected = isFavSource;
            _mySourceFavButton.hidden = NO;
            _myDestinationFavButton.userInteractionEnabled = NO;
            _mySourceFavButton.userInteractionEnabled = YES;
            _mySearchSourceView.userInteractionEnabled = YES;
            _mySearchDistinationView.userInteractionEnabled = NO;
            _mySearchSourceView.backgroundColor = [UIColor clearColor];
            _mySearchDistinationView.backgroundColor = [HELPER getColorFromHexaDecimal:COLOR_GROUP_TABLE_VIEW];
        }
        else {
            
            _myDestinationFavButton.hidden = NO;
            _myDestinationFavButton.selected = isFavDestination;
            _myDestinationFavButton.userInteractionEnabled = YES;
            _mySourceFavButton.userInteractionEnabled = NO;
            _mySourceFavButton.hidden = YES;
            _mySearchSourceView.userInteractionEnabled = NO;
            _mySearchDistinationView.userInteractionEnabled = YES;
            _mySearchSourceView.backgroundColor = [HELPER getColorFromHexaDecimal:COLOR_GROUP_TABLE_VIEW];
            _mySearchDistinationView.backgroundColor = [UIColor clearColor];
        }
        
        myLocationCoordinate = aLocation.coordinate;
        myCurrentLocationCoordinate = myLocationCoordinate;
        
        NSMutableDictionary *aMDictionary = [NSMutableDictionary new];
        
        aMDictionary[K_FAVORITE_LATITUDE] = [NSString stringWithFormat:@"%f",myLocationCoordinate.latitude];
        aMDictionary[K_FAVORITE_LONGITUDE] = [NSString stringWithFormat:@"%f",myLocationCoordinate.longitude];
        
        myCurrentFavMutableDict[K_FAVORITE_LATITUDE] = aMDictionary[K_FAVORITE_LATITUDE];
        myCurrentFavMutableDict[K_FAVORITE_LONGITUDE] = aMDictionary[K_FAVORITE_LONGITUDE];
        
        [self setFavoriteBasedOnSelectedAddress:aMDictionary];
        
        isForFavLocation = NO;
        
        CLLocation *aCurrentLocation = [[CLLocation alloc] initWithLatitude:aLocation.coordinate.latitude longitude:aLocation.coordinate.longitude];
        CLLocation *aMapLocation = [[CLLocation alloc] initWithLatitude:_myMapView.camera.target.latitude longitude:_myMapView.camera.target.longitude];
        
        CLLocationDistance distance = [aCurrentLocation distanceFromLocation:aMapLocation];
        
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            isMapViewChanged = 2;
            [self getAddressFromLocation:myLocationCoordinate];
            [self zoomToLocation:myLocationCoordinate];
            [HELPER removeLoadingIn:self];
        });
    }
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    
    NSLog(@"locationError - %@", [error description]);
    
    [manager stopUpdatingLocation];
    
    [self hideLoadingActivityIndicator];
    [HELPER removeLoadingIn:self];
    [HELPER showRetryAlertIn:self details:ALERT_UNABLE_TO_FETCH_LOCATION_DICT retryBlock:^{
        
        [HELPER showLoadingIn:self text:@"Fetching your location"];
        [HELPER removeRetryAlertIn:self];
        
        [manager startUpdatingLocation];
    }];
}

#pragma mark - MKMapView -

#pragma mark -Map Helper

- (BOOL)mapViewRegionDidChangeFromUserInteraction {
    
    UIView *view = self.myMapView.subviews.firstObject;
    
    //  Look through gesture recognizers to determine whether this region change is from user interaction
    for(UIGestureRecognizer *recognizer in view.gestureRecognizers) {
        
        if(recognizer.state == UIGestureRecognizerStateBegan || recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateChanged) {
            return YES;
        }
    }
    
    return NO;
}

#pragma mark -Delegate

static BOOL mapChangedFromUserInteraction = NO;

-(void)mapView:(GMSMapView *)mapView willMove:(BOOL)gesture {
    
    mapChangedFromUserInteraction = gesture;
    
    myCurrentLocationCoordinate = mapView.camera.target;
}

static float lastZoomLevel;

- (void)mapView:(GMSMapView *)mapView didChangeCameraPosition:(GMSCameraPosition *)position {
    
    myCurrentLocationCoordinate = position.target;
}

- (void)mapView:(GMSMapView *)mapView idleAtCameraPosition:(GMSCameraPosition *)position {
    
    float zoom = mapView.camera.zoom;
    
    if (lastZoomLevel == 0 || lastZoomLevel == zoom) {
        /*
         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
         
         [self addMarkerLocation];
         });*/
    }
    else {
        
    }
    lastZoomLevel = zoom;
    
    if (mapChangedFromUserInteraction) {
        // user changed map region
        [self showLoadingActivityIndicator];
        
        isMapViewChanged = 2;
        
        NSMutableDictionary *aMDictionary = [NSMutableDictionary new];
        
        aMDictionary[K_FAVORITE_LATITUDE] = [NSString stringWithFormat:@"%f",position.target.latitude];
        aMDictionary[K_FAVORITE_LONGITUDE] = [NSString stringWithFormat:@"%f",position.target.longitude];
        
        myCurrentFavMutableDict[K_FAVORITE_LATITUDE] = aMDictionary[K_FAVORITE_LATITUDE];
        myCurrentFavMutableDict[K_FAVORITE_LONGITUDE] = aMDictionary[K_FAVORITE_LONGITUDE];
        
        [self getAddressFromLocation:position.target];
        
        if (_mySearchTypeEnum == SEARCH_TYPE_DESTINATION) {
            
            //_myCurrentLocationButton.hidden = YES;
            myCurrentLocationCoordinate = position.target;
        }
        else {
            
            
            //  _myCurrentLocationButton.hidden = NO;
            myCurrentLocationCoordinate = position.target;
        }
    }
}

- (void)zoomToLocation:(CLLocationCoordinate2D)aCoordinate {
    
    GMSCameraPosition *cameraPosition = [GMSCameraPosition cameraWithLatitude:aCoordinate.latitude  longitude:aCoordinate.longitude zoom:17];
    [self.myMapView animateToCameraPosition:cameraPosition];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        _myMapView.hidden = NO;
    });
}

- (void)checkLocationAccessibilityAndStartUpdatingLocation {
    
    if ([HELPER isLocationAccessAllowed]) {
        
        [HELPER removeRetryAlertIn:self];
        [myLocationManager startUpdatingLocation];
    }
    else {
        
        [HELPER removeAlertIn:self];
        [HELPER showRetryAlertIn:self details:@{KEY_ALERT_TITLE:ALERT_RETRY_TITLE,KEY_ALERT_DESC:ALERT_UNABLE_TO_FETCH_LOCATION@". Please make sure that 'Location Service' is enabled and 'location is allowed to access' in Settings.",KEY_ALERT_IMAGE:ALERT_NO_LOCATION} retryBlock:^{
            
            if ([HELPER isLocationAccessAllowed]) {
                
                [HELPER showLoadingIn:self text:@"Fetching your location"];
                [HELPER removeRetryAlertIn:self];
                
                [myLocationManager startUpdatingLocation];
            }
            else {
                
                // Goto settings
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            }
        }];
    }
    
}

- (void)getAddressFromSearchedLocation:(CLLocationCoordinate2D)newLocation {
    
    
    if (gettingAddressFromLatLng == NO) {
        
        if (![HTTPMANAGER isNetworkRechable]) {
            
            
            [HELPER showRetryAlertIn:self details:ALERT_NO_INTERNET_DICT retryBlock:^{
                
                [self getAddressFromSearchedLocation:newLocation];
            }];
            
            return;
        }
        
        NSString *aString = [NSString stringWithFormat:@"%f,%f", newLocation .latitude, newLocation .longitude];
        
        gettingAddressFromLatLng = YES;
        
        // Set text in textfield based on the search
        if (_mySearchTypeEnum == SEARCH_TYPE_SOURCE) {
            
            if (!isForFavLocation)
                _mySearchSourceTextfield.text = @"";
            
            _mySearchSourceTextfield.placeholder = @"Finding location...";
            
        }
        else {
            
            if (!isForFavLocation)
                _mySearchDistinationTextfield.text = @"";
            
            _mySearchDistinationTextfield.placeholder = @"Finding location...";
        }
        
        [[GMSGeocoder geocoder] reverseGeocodeCoordinate:newLocation completionHandler:^(GMSReverseGeocodeResponse *aResponse, NSError *aError) {
            
            BOOL aSuccess = NO;
            if (aError == nil) {
                
                GMSAddress *aAddress = aResponse.firstResult;
                
                NSMutableDictionary *aMDictionary = [NSMutableDictionary new];
                
                aMDictionary[K_FAVORITE_LATITUDE] = [NSString stringWithFormat:@"%f",aResponse.firstResult.coordinate.latitude];
                aMDictionary[K_FAVORITE_LONGITUDE] = [NSString stringWithFormat:@"%f",aResponse.firstResult.coordinate.longitude];
                aMDictionary[K_FAVORITE_ADDRESS] = ([aAddress.lines[0] isEqualToString:@"Unnamed Road"]) ? aAddress.lines[1] : aAddress.lines[0];
                aMDictionary[K_FAVORITE_DISPLAY_NAME] = @"";
                aMDictionary[K_FAVORITE_PRIMARY_LOCATION] = @"";
                aMDictionary[K_FAVORITE_ID] = @"";
                
                
                
                if (aAddress) {
                    //(aAddress.lines.count > 0) ? aAddress.lines[1] : aAddress.lines[0]
                    aSuccess = YES;
                    
                    // Set text in textfield based on the search
                    if (_mySearchTypeEnum == SEARCH_TYPE_SOURCE) {
                        
                        if (isMapViewChanged == 2)
                            myFavSourseMutableDictionary = aMDictionary;
                        
                        _mySearchSourceTextfield.placeholder = @"Search location...";
                    }
                    else if (_mySearchTypeEnum == SEARCH_TYPE_DESTINATION) {
                        
                        if (isMapViewChanged == 2)
                            myFavDestMutableDictionary = aMDictionary;
                        
                        _mySearchSourceTextfield.placeholder = @"Search location...";
                    }
                    
                    // Set text in textfield based on the search
                    if (_mySearchTypeEnum == SEARCH_TYPE_SOURCE) {
                        
                        if (!isForFavLocation) {
                            
                            myAddressString = aMDictionary[K_FAVORITE_ADDRESS];
                            _mySearchSourceTextfield.text = [([myAddressString substringToIndex:1]) isEqualToString:@","] ? [myAddressString substringFromIndex:1] : myAddressString;
                        }
                        
                        if (_myMapLocationMutableArray.count)
                            [_myMapLocationMutableArray replaceObjectAtIndex:0 withObject:aString];
                        else
                            [_myMapLocationMutableArray addObject:aString];
                        
                    }
                    else if (_mySearchTypeEnum == SEARCH_TYPE_DESTINATION) {
                        
                        if (!isForFavLocation) {
                            
                            myAddressString = aMDictionary[K_FAVORITE_ADDRESS];
                            _mySearchDistinationTextfield.text = [([myAddressString substringToIndex:1]) isEqualToString:@","] ? [myAddressString substringFromIndex:1] : myAddressString;
                        }
                        
                        if (_myMapLocationMutableArray.count) {
                            if ( _myMapLocationMutableArray.count > 1)
                                [_myMapLocationMutableArray replaceObjectAtIndex:1 withObject:aString];
                            else
                                [_myMapLocationMutableArray addObject:aString];
                        }
                        else
                            [_myMapLocationMutableArray addObject:aString];
                    }
                    _myMapInfoArray = _myMapLocationMutableArray;
                }
                if (isForFavLocation)
                    isForFavLocation = NO;
                
                
                if (_mySearchTypeEnum == SEARCH_TYPE_SOURCE) {
                    
                    myFavSourseMutableDictionary[K_FAVORITE_LATITUDE] = aMDictionary[K_FAVORITE_LATITUDE];
                    myFavSourseMutableDictionary[K_FAVORITE_LONGITUDE] = aMDictionary[K_FAVORITE_LONGITUDE];
                    
                    [self setFavoriteBasedOnSelectedAddress:myFavSourseMutableDictionary];
                    
                }
                else {
                    
                    myFavDestMutableDictionary[K_FAVORITE_LATITUDE] = aMDictionary[K_FAVORITE_LATITUDE];
                    myFavDestMutableDictionary[K_FAVORITE_LONGITUDE] = aMDictionary[K_FAVORITE_LONGITUDE];
                    
                    [self setFavoriteBasedOnSelectedAddress:myFavDestMutableDictionary];
                }
                
            }
            
            if (aSuccess == NO) {
                // Unable to get user locality so display error
                myAddressString = ALERT_UNABLE_TO_FETCH_LOCATION@". Move the map to try again";
            }
            else {
                
                myLocationCoordinate = newLocation;
            }
            
            
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                if (_mySearchTypeEnum == SEARCH_TYPE_SOURCE) {
                    
                    _myMapAnnotationImageView.image = [UIImage imageNamed:IMAGE_FROM_MARKER];
                    
                }
                else
                    _myMapAnnotationImageView.image = [UIImage imageNamed:IMAGE_TO_MARKER];
            });
            
            
            
            [self hideLoadingActivityIndicator];
            gettingAddressFromLatLng = NO;
        }];
        
        [self hideLoadingActivityIndicator];
    }
}

- (void)getAddressFromLocation:(CLLocationCoordinate2D)newLocation {
    
    
    if (gettingAddressFromLatLng == NO) {
        
        if (![HTTPMANAGER isNetworkRechable]) {
            
            
            [HELPER showRetryAlertIn:self details:ALERT_NO_INTERNET_DICT retryBlock:^{
                
                [self getAddressFromLocation:newLocation];
            }];
            
            return;
        }
        
        NSString *aString = [NSString stringWithFormat:@"%f,%f", newLocation .latitude, newLocation .longitude];
        
        gettingAddressFromLatLng = YES;
        
        // Set text in textfield based on the search
        if (_mySearchTypeEnum == SEARCH_TYPE_SOURCE) {
            
            if (!isForFavLocation)
                _mySearchSourceTextfield.text = @"";
            
            _mySearchSourceTextfield.placeholder = @"Finding location...";
            
        }
        else {
            
            if (!isForFavLocation)
                _mySearchDistinationTextfield.text = @"";
            
            _mySearchDistinationTextfield.placeholder = @"Finding location...";
        }
        
        [[GMSGeocoder geocoder] reverseGeocodeCoordinate:newLocation completionHandler:^(GMSReverseGeocodeResponse *aResponse, NSError *aError) {
            
            BOOL aSuccess = NO;
            if (aError == nil) {
                
                GMSAddress *aAddress = aResponse.firstResult;
                
                NSMutableDictionary *aMDictionary = [NSMutableDictionary new];
                
                aMDictionary[K_FAVORITE_LATITUDE] = [NSString stringWithFormat:@"%f",aResponse.firstResult.coordinate.latitude];
                aMDictionary[K_FAVORITE_LONGITUDE] = [NSString stringWithFormat:@"%f",aResponse.firstResult.coordinate.longitude];
                aMDictionary[K_FAVORITE_ADDRESS] = [aAddress.lines componentsJoinedByString:@","];
                //([aAddress.lines[0] isEqualToString:@"Unnamed Road"]) ? aAddress.lines[1] : aAddress.lines[0];
                aMDictionary[K_FAVORITE_DISPLAY_NAME] = @"";
                aMDictionary[K_FAVORITE_PRIMARY_LOCATION] = @"";
                aMDictionary[K_FAVORITE_ID] = @"";
                
                
                
                if (aAddress) {
                    //(aAddress.lines.count > 0) ? aAddress.lines[1] : aAddress.lines[0]
                    aSuccess = YES;
                    
                    // Set text in textfield based on the search
                    if (_mySearchTypeEnum == SEARCH_TYPE_SOURCE) {
                        
                        if (isMapViewChanged == 2)
                            myFavSourseMutableDictionary = aMDictionary;
                        
                        _mySearchSourceTextfield.placeholder = @"Search location...";
                    }
                    else if (_mySearchTypeEnum == SEARCH_TYPE_DESTINATION) {
                        
                        if (isMapViewChanged == 2)
                            myFavDestMutableDictionary = aMDictionary;
                        
                        _mySearchSourceTextfield.placeholder = @"Search location...";
                    }
                    
                    // Set text in textfield based on the search
                    if (_mySearchTypeEnum == SEARCH_TYPE_SOURCE) {
                        
                        if (!isForFavLocation) {
                            
                            myAddressString = aMDictionary[K_FAVORITE_ADDRESS];
                            _mySearchSourceTextfield.text = [([myAddressString substringToIndex:1]) isEqualToString:@","] ? [myAddressString substringFromIndex:1] : myAddressString;
                        }
                        
                        if (_myMapLocationMutableArray.count)
                            [_myMapLocationMutableArray replaceObjectAtIndex:0 withObject:aString];
                        else
                            [_myMapLocationMutableArray addObject:aString];
                        
                    }
                    else if (_mySearchTypeEnum == SEARCH_TYPE_DESTINATION) {
                        
                        if (!isForFavLocation) {
                            
                            myAddressString = aMDictionary[K_FAVORITE_ADDRESS];
                            _mySearchDistinationTextfield.text = [([myAddressString substringToIndex:1]) isEqualToString:@","] ? [myAddressString substringFromIndex:1] : myAddressString;
                        }
                        
                        if (_myMapLocationMutableArray.count) {
                            if ( _myMapLocationMutableArray.count > 1)
                                [_myMapLocationMutableArray replaceObjectAtIndex:1 withObject:aString];
                            else
                                [_myMapLocationMutableArray addObject:aString];
                        }
                        else
                            [_myMapLocationMutableArray addObject:aString];
                    }
                    _myMapInfoArray = _myMapLocationMutableArray;
                }
                if (isForFavLocation)
                    isForFavLocation = NO;
                
                
                if (_mySearchTypeEnum == SEARCH_TYPE_SOURCE) {
                    
                    myFavSourseMutableDictionary[K_FAVORITE_LATITUDE] = aMDictionary[K_FAVORITE_LATITUDE];
                    myFavSourseMutableDictionary[K_FAVORITE_LONGITUDE] = aMDictionary[K_FAVORITE_LONGITUDE];
                    
                    [self setFavoriteBasedOnSelectedAddress:myFavSourseMutableDictionary];
                    
                }
                else {
                    
                    myFavDestMutableDictionary[K_FAVORITE_LATITUDE] = aMDictionary[K_FAVORITE_LATITUDE];
                    myFavDestMutableDictionary[K_FAVORITE_LONGITUDE] = aMDictionary[K_FAVORITE_LONGITUDE];
                    
                    [self setFavoriteBasedOnSelectedAddress:myFavDestMutableDictionary];
                }
                
            }
            
            if (aSuccess == NO) {
                // Unable to get user locality so display error
                myAddressString = ALERT_UNABLE_TO_FETCH_LOCATION@". Move the map to try again";
            }
            else {
                
                myLocationCoordinate = newLocation;
            }
            
            
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                if (_mySearchTypeEnum == SEARCH_TYPE_SOURCE) {
                    
                    _myMapAnnotationImageView.image = [UIImage imageNamed:IMAGE_FROM_MARKER];
                }
                else
                    _myMapAnnotationImageView.image = [UIImage imageNamed:IMAGE_TO_MARKER];
            });
            
            
            
            [self hideLoadingActivityIndicator];
            gettingAddressFromLatLng = NO;
        }];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.9 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            if (_mySearchTypeEnum == SEARCH_TYPE_SOURCE) {
                
                if ([_mySearchSourceTextfield.text isEqualToString:@""])
                    _mySearchSourceTextfield.text = (myCurrentFavMutableDict.count) ? myCurrentFavMutableDict[K_FAVORITE_ADDRESS] :  @"";
            }
            else if (_mySearchTypeEnum == SEARCH_TYPE_DESTINATION) {
                
                if ([_mySearchSourceTextfield.text isEqualToString:@""])
                    _mySearchDistinationTextfield.text = (myCurrentFavMutableDict.count) ? myCurrentFavMutableDict[K_FAVORITE_ADDRESS] : @"";
            }
        });
        
        [self hideLoadingActivityIndicator];
    }
}

#pragma mark - Custom methods

-(void)setUpNavigationBar {
    
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
    label.text = TITLE_DASHBOARD;
    [label sizeToFit];
    
    self.navigationItem.leftBarButtonItem  = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:IMAGE_MENU] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonTapEvent)];
}

// Hide Keyboard
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    NSLog(@"%lu active touches",[[event touchesForView:self.view] count]);
    
    if ([[event touchesForView:self.myMapView] count] > 1)
        _myMapView.settings.allowScrollGesturesDuringRotateOrZoom = NO;
    else
        _myMapView.settings.allowScrollGesturesDuringRotateOrZoom = YES;
    
    [super touchesBegan:touches withEvent:event] ;
}

-(void)addOrDeletebasedOnTheButtonStatus  {
    
    // To add  the location as favorite
    
    LUFavouritePopViewController * aViewController = [STORY_BOARD instantiateViewControllerWithIdentifier:@"LUFavouritePopViewController"];
    [aViewController setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    aViewController.isForPromoCode = NO;
    aViewController.gMutableDictionary = (_mySearchTypeEnum == SEARCH_TYPE_SOURCE) ? myFavSourseMutableDictionary : myFavDestMutableDictionary;
    aViewController.callBackBlock = ^(BOOL isCallBack, NSMutableArray *aMArray) {
        
        if (isCallBack) {
            
            NSMutableArray *aMainMutableArray = [NSMutableArray new];
            
            aMainMutableArray = [[COREDATAMANAGER getFavouriteListInfo] mutableCopy];
            
            for (int i = 0; i < aMainMutableArray.count; i++) {
                
                TagFavouriteType *aTag = [aMainMutableArray objectAtIndex:i];
                
                BOOL isFavrite;
                
                NSString *aLatitude = [NSString stringWithFormat:@"%@",aTag.favourite_latitude];
                NSString *aLongitude = [NSString stringWithFormat:@"%@",aTag.favourite_longitude];
                
                
                NSString *aCurrentLatitude = [NSString stringWithFormat:@"%@",myCurrentFavMutableDict[K_FAVORITE_LATITUDE]];
                NSString *aCurrentLongitude = [NSString stringWithFormat:@"%@",myCurrentFavMutableDict[K_FAVORITE_LONGITUDE]];
                
                if (_mySearchTypeEnum == SEARCH_TYPE_SOURCE) {
                    
                    if ([[aCurrentLatitude substringToIndex:8] isEqualToString:aLatitude] && [[aCurrentLongitude substringToIndex:8] isEqualToString:aLongitude]) {
                        
                        myFavSourseMutableDictionary[K_FAVORITE_ID] = aTag.favourite_type_id;
                        myFavoriteIdString = aTag.favourite_type_id;
                        if (_mySearchTypeEnum == SEARCH_TYPE_SOURCE) {
                            
                            isFavSource = YES;
                            _mySourceFavButton.selected = isFavSource;
                            _myDestinationFavButton.userInteractionEnabled = NO;
                            _mySourceFavButton.userInteractionEnabled = YES;
                        }
                        else {
                            
                            isFavDestination = YES;
                            _myDestinationFavButton.selected = isFavDestination;
                            _myDestinationFavButton.userInteractionEnabled = YES;
                            _mySourceFavButton.userInteractionEnabled = NO;
                        }
                    }
                }
                else {
                    
                    if ([[aCurrentLatitude substringToIndex:8] isEqualToString:aLatitude] && [[aCurrentLongitude substringToIndex:8] isEqualToString:aLongitude]) {
                        
                        myFavDestMutableDictionary[K_FAVORITE_ID] = aTag.favourite_type_id;
                        myFavoriteDestinationIdString = aTag.favourite_type_id;
                        
                        if (_mySearchTypeEnum == SEARCH_TYPE_SOURCE) {
                            
                            isFavSource = YES;
                            _mySourceFavButton.selected = isFavSource;
                            _myDestinationFavButton.userInteractionEnabled = NO;
                            _mySourceFavButton.userInteractionEnabled = YES;
                        }
                        else {
                            
                            isFavDestination = YES;
                            _myDestinationFavButton.selected = isFavDestination;
                            _myDestinationFavButton.userInteractionEnabled = YES;
                            _mySourceFavButton.userInteractionEnabled = NO;
                        }
                    }
                }
            }
        }
    };
    
    [self presentViewController:aViewController animated:YES completion:^{
        
    }];
}

-(void)setFavoriteBasedOnSelectedAddress:(NSMutableDictionary *)aMDictionary {
    
    NSMutableArray *aMainMutableArray = [NSMutableArray new];
    aMainMutableArray = [[COREDATAMANAGER getFavouriteListInfo] mutableCopy];
    
    BOOL isFavrite = false;
    
    for (int i = 0; i < aMainMutableArray.count; i++) {
        
        TagFavouriteType *aTag = [aMainMutableArray objectAtIndex:i];
        
        
        NSString *aLatitude = [NSString stringWithFormat:@"%@",aTag.favourite_latitude];
        NSString *aLongitude = [NSString stringWithFormat:@"%@",aTag.favourite_longitude];
        
        NSString *aCurrentLatitude = [NSString stringWithFormat:@"%@",myCurrentFavMutableDict[K_FAVORITE_LATITUDE]];
        NSString *aCurrentLongitude = [NSString stringWithFormat:@"%@",myCurrentFavMutableDict[K_FAVORITE_LONGITUDE]];
        
        if (aCurrentLatitude.length < 8) {
            
            aCurrentLatitude = [HELPER setZeroAfterValue:aCurrentLatitude numberOfZero:8 - aCurrentLatitude.length];
        }
        if (aCurrentLongitude.length < 8) {
            
            aCurrentLongitude = [HELPER setZeroAfterValue:aCurrentLongitude numberOfZero:8 - aCurrentLongitude.length];
        }
        
        if([[aCurrentLatitude substringToIndex:8] isEqualToString:aLatitude] && [[aCurrentLongitude substringToIndex:8] isEqualToString:aLongitude]) {
            
            
            isFavrite = YES;
            if (_mySearchTypeEnum == SEARCH_TYPE_SOURCE) {
                
                
                _mySourceFavButton.selected = YES;
                isFavSource = YES;
                myFavSourseMutableDictionary[K_FAVORITE_ID] = aTag.favourite_type_id;
                myFavoriteIdString = aTag.favourite_type_id;
                myFavPrimaryLocation = aTag.favourite_primary_location;
            }
            else {
                
                _myDestinationFavButton.selected = YES;
                isFavDestination = YES;
                myFavDestMutableDictionary[K_FAVORITE_ID] = aTag.favourite_type_id;
                myFavoriteDestinationIdString = aTag.favourite_type_id;
                myFavPrimaryLocation = aTag.favourite_primary_location;
            }
        }
        else {
            
            if (!isFavrite) {
                
                if (_mySearchTypeEnum == SEARCH_TYPE_SOURCE) {
                    
                    _mySourceFavButton.selected = NO;
                    isFavSource = NO;
                }
                else {
                    
                    _myDestinationFavButton.selected = NO;
                    isFavDestination = NO;
                }
            }
        }
    }
}


-(UIImage *)image:(UIImage*)originalImage scaledToSize:(CGSize)size {
    
    //avoid redundant drawing
    if (CGSizeEqualToSize(originalImage.size, size))
    {
        return originalImage;
    }
    
    //create drawing context
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0f);
    
    //draw
    [originalImage drawInRect:CGRectMake(0.0f, 0.0f, size.width, size.height)];
    
    //capture resultant image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //return image
    return image;
}


#pragma mark - Web Srevice -

-(void)callServiceTypeWebService {
    
    if (![HTTPMANAGER isNetworkRechable]) {
        
        NSMutableDictionary *aDictAlert = [NSMutableDictionary new];
        
        aDictAlert[KEY_ALERT_TITLE]  = SCREEN_TITLE_DASHBOARD;
        aDictAlert[KEY_ALERT_DESC]  = [NSString stringWithFormat:@"%@. Tap to try again",ALERT_NO_INTERNET_DESC];
        aDictAlert[KEY_ALERT_IMAGE]  = ALERT_NO_LOCATION;
        
        // List is empty so show 'Tap to retry' view
        [HELPER showRetryAlertIn:self details:aDictAlert retryBlock:^{
            
            if ([HTTPMANAGER isNetworkRechable]) {
                
                [HELPER removeRetryAlertIn:self];
                [HELPER removeLoadingIn:self];
                [self callServiceTypeWebService];
            }
        }];
        return;
    }
    
    [HTTPMANAGER getServiceTypeWithcompletedBlock:^(NSDictionary *response) {
        
        if ([response[kRESPONSE][kRESPONSE_CODE] intValue] == kSUCCESS_CODE) {
            
            _myInfoMutableArray = [[COREDATAMANAGER getServiceListInfo] mutableCopy];
            [self.myCollectionView reloadData];
            
            
        }
        else {
            
            [HELPER showNotificationSuccessIn:self withMessage:response[kRESPONSE][kRESPONSE_MESSAGE]];
        }
        
    } failedBlock:^(NSError *error) {
        
        {
            
            if (error.code == NSURLErrorTimedOut)
                [HELPER showRetryAlertIn:self details:ALERT_SIGNALR_UNABLE_TO_REACH_DICT retryBlock:^{
                    
                    if ([HTTPMANAGER isNetworkRechable]) {
                        
                        [HELPER removeRetryAlertIn:self];
                        [HELPER showLoadingIn:self];
                        [self callServiceTypeWebService];
                    }
                }];
            else
                [HELPER showNotificationSuccessIn:self withMessage:MESSAGE_SOMETHING_WENT_WRONG];
        }        [HELPER removeLoadingIn:self];
    }];
}

- (void)callDeleteWebService {
    
    // http://192.168.0.48/PPTCustomer/API/CustomerFavourites/DeleteFavourites?StrJson={"Favourites_Info":{"Fav_Id":"11","Customer_Id":"49"} }
    
    if (![HTTPMANAGER isNetworkRechable]) {
        
        NSMutableDictionary *aDictAlert = [NSMutableDictionary new];
        
        aDictAlert[KEY_ALERT_TITLE]  = SCREEN_TITLE_DASHBOARD;
        aDictAlert[KEY_ALERT_DESC]  = [NSString stringWithFormat:@"%@. Tap to try again",ALERT_NO_INTERNET_DESC];
        aDictAlert[KEY_ALERT_IMAGE]  = ALERT_NO_LOCATION;
        
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
    
    aMutableDict[K_FAVORITE_ID] = (_mySearchTypeEnum == SEARCH_TYPE_SOURCE) ? myFavoriteIdString : myFavoriteDestinationIdString;
    aMutableDict[K_CUSTOMER_ID] = [SESSION getUserInfo][0][K_CUSTOMER_ID];
    
    aLoginMutableDict[@"Favourites_Info"] = aMutableDict;
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:aLoginMutableDict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *string = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    aParameterMutableDict[@"StrJson"] = string;
    
    [HELPER showLoadingIn:self];
    
    [HTTPMANAGER deleteFavoriteType:aParameterMutableDict primaryLocatio:myFavPrimaryLocation completedBlock:^(NSDictionary *response) {
        
        if ([response[kRESPONSE][kRESPONSE_CODE] intValue] == kSUCCESS_CODE) {
            
            if (_mySearchTypeEnum == SEARCH_TYPE_SOURCE) {
                
                isFavSource = NO;
                _mySourceFavButton.selected = isFavSource;
                _myDestinationFavButton.userInteractionEnabled = NO;
                _mySourceFavButton.userInteractionEnabled = YES;
            }
            else {
                
                isFavDestination = NO;
                _myDestinationFavButton.selected = isFavDestination;
                _myDestinationFavButton.userInteractionEnabled = YES;
                _mySourceFavButton.userInteractionEnabled = NO;
            }
            
        }
        else if ([response[kRESPONSE][kRESPONSE_CODE] intValue] == K_NO_DATA_CODE || [response[kRESPONSE][kRESPONSE_CODE] intValue] == k_BAD_REQUEST) {
            
            if (_mySearchTypeEnum == SEARCH_TYPE_SOURCE) {
                
                isFavSource = NO;
                _mySourceFavButton.selected = isFavSource;
                _myDestinationFavButton.userInteractionEnabled = NO;
                _mySourceFavButton.userInteractionEnabled = YES;
            }
            else {
                
                isFavDestination = NO;
                _myDestinationFavButton.selected = isFavDestination;
                _myDestinationFavButton.userInteractionEnabled = YES;
                _mySourceFavButton.userInteractionEnabled = NO;
            }
            
            // [HELPER showNotificationSuccessIn:self withMessage:response[kRESPONSE][kRESPONSE_MESSAGE]];
        }
        else
            [HELPER showNotificationSuccessIn:self withMessage:MESSAGE_SOMETHING_WENT_WRONG];
        
        [HELPER removeLoadingIn:self];
        
    } failedBlock:^(NSError *error) {
        
        {
            
            if (error.code == NSURLErrorTimedOut)
                [HELPER showRetryAlertIn:self details:ALERT_SIGNALR_UNABLE_TO_REACH_DICT retryBlock:^{
                    
                    if ([HTTPMANAGER isNetworkRechable]) {
                        
                        [HELPER removeRetryAlertIn:self];
                        [HELPER showLoadingIn:self];
                        [self callDeleteWebService];
                    }
                }];
            else
                [HELPER showNotificationSuccessIn:self withMessage:MESSAGE_SOMETHING_WENT_WRONG];
        }
        [HELPER removeLoadingIn:self];
    }];
}

#pragma mark - Favorite Web service


- (void)callFavoriteLocationWebService {
    
    if (![HTTPMANAGER isNetworkRechable]) {
        
        NSMutableDictionary *aDictAlert = [NSMutableDictionary new];
        
        aDictAlert[KEY_ALERT_TITLE]  = SCREEN_TITLE_DASHBOARD;
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
    
    
    [HTTPMANAGER getFavoriteType:aParameterMutableDict completedBlock:^(NSDictionary *response) {
        
        if ([response[kRESPONSE][kRESPONSE_CODE] intValue] == kSUCCESS_CODE) {
            
            
            
        }
        else if ([response[kRESPONSE][kRESPONSE_CODE] intValue] == k_BAD_REQUEST || [response[kRESPONSE][kRESPONSE_CODE] intValue] == K_NO_DATA_CODE) {
            
        }
        else {
            
        }
        
        [HELPER removeLoadingIn:self];
        
    } failedBlock:^(NSError *error) {
        
        {
            
            if (error.code == NSURLErrorTimedOut)
                [HELPER showRetryAlertIn:self details:ALERT_SIGNALR_UNABLE_TO_REACH_DICT retryBlock:^{
                    
                    if ([HTTPMANAGER isNetworkRechable]) {
                        
                        [HELPER removeRetryAlertIn:self];
                        [HELPER showLoadingIn:self];
                        [self callFavoriteLocationWebService];
                    }
                }];
            else
                [HELPER showNotificationSuccessIn:self withMessage:MESSAGE_SOMETHING_WENT_WRONG];
        }
        [HELPER removeLoadingIn:self];
    }];
}

-(void)setLocalNotification : (NSMutableDictionary *)aDictionary {
    
    // To set Local Notification
    
    if (SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(@"10.0")) {
        
        if ([[UIApplication sharedApplication] isRegisteredForRemoteNotifications] == YES) {
            
            NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
            
            [calendar setTimeZone:[NSTimeZone localTimeZone]];
            
            NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond|NSCalendarUnitTimeZone fromDate:[NSDate date]];
            
            
            UNMutableNotificationContent *objNotificationContent = [[UNMutableNotificationContent alloc] init];
            objNotificationContent.title = APP_NAME;
            objNotificationContent.body = aDictionary[KEY_TITLE];
            objNotificationContent.sound = [UNNotificationSound defaultSound];
            
            /// 4. update application icon badge number
            objNotificationContent.badge = @([[UIApplication sharedApplication] applicationIconBadgeNumber] + 1);
            
            
            UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger
                                                          triggerWithTimeInterval:10.f repeats:NO];
            
            
            UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:aDictionary[KEY_TEXT]
                                                                                  content:objNotificationContent trigger:trigger];
            /// 3. schedule localNotification
            UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
            
            [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
                
                if(settings) {
                    
                    if([settings authorizationStatus] == UNAuthorizationStatusAuthorized) {
                        
                        [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
                            
                            if (error) {
                                
                                NSLog(@"Problem while scheduling local Notification! %@", [error localizedDescription]);
                                
                            }
                            
                        }];
                        
                    } else {
                        
                        NSLog(@"Notification access not granted");
                        
                    }
                    
                }
                
            }];
        }
    }
    
    else {
        UILocalNotification* aLocalNotification = [[UILocalNotification alloc] init];
        aLocalNotification.fireDate = [NSDate date];
        aLocalNotification.alertBody = aDictionary[KEY_TITLE];
        aLocalNotification.alertTitle = APP_NAME;
        aLocalNotification.timeZone = [NSTimeZone defaultTimeZone];
        aLocalNotification.soundName = UILocalNotificationDefaultSoundName;
        aLocalNotification.userInfo = nil;
        aLocalNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
        
        [[UIApplication sharedApplication] scheduleLocalNotification:aLocalNotification];
    }
}

-(void)changeViewBasedOnFav:(NSNotification *)notification {
    
    [self setFavoriteBasedOnSelectedAddress:nil];
}
@end
