//
//  LUMenuViewController.m
//  Levare User
//
//  Created by AngMac137 on 11/19/16.
//  Copyright © 2016 AngMac137. All rights reserved.
//

#import "LUMenuViewController.h"

#import "LUFavouritViewController.h"
#import "LUMenuProfileViewController.h"
#import "LUHelpSupportViewController.h"
#import "LUReferViewController.h"
#import "LUFamilyAndFriendsViewController.h"
#import "LUTripHistoryViewController.h"

#import "LUMenuTableViewCell.h"


@interface LUMenuViewController ()

@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) IBOutlet UIView *myHeaderView;
@property (strong, nonatomic) IBOutlet UIImageView *myProfileImage;
@property (strong, nonatomic) IBOutlet UILabel *myNameLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *myProfileImageWidthConstraint;


//Model
@property (strong, nonatomic) NSArray *myInfoArray;
@end

@implementation LUMenuViewController

#pragma mark - View & Model -

#pragma mark -View Life Cycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // setup UI & Content
    [self setupUI];
    [self setupMenuModel];
    
    // Load Contents
    [self loadModel];
}

#pragma mark -View Init

- (void)setupUI {
    
    self.navigationController.navigationBarHidden = YES;
    [self.navigationController.navigationBar setTranslucent:NO];
    
    _myTableView.tableFooterView = [UIView new];
    _myTableView.sectionHeaderHeight = 0;
    _myTableView.sectionFooterHeight = 0;
    
    _myInfoArray = [NSArray new];
    
    
    _myInfoArray = @[@{KEY_TEXT:@"PROFILE", KEY_IMAGE:@"icon_menu_profile"},
                     @{KEY_TEXT:@"TRIP HISTORY", KEY_IMAGE:@"icon_menu_trip"},
                     @{KEY_TEXT:@"MANAGE CARDS", KEY_IMAGE:@"icon_menu_cards"},
                     @{KEY_TEXT:@"FAMILY & FRIENDS", KEY_IMAGE:@"icon_menu_fa_fi"},
                     @{KEY_TEXT:@"FAVOURITES", KEY_IMAGE:@"icon_menu_favourites"},
                     @{KEY_TEXT:@"PROMOTIONS", KEY_IMAGE:@"icon_menu_promotion"},
                     @{KEY_TEXT:@"REFER FRIENDS", KEY_IMAGE:@"icon_menu_refer"},
                     @{KEY_TEXT:@"HELP & SUPPORT", KEY_IMAGE:@"icon_menu_help"}
                     ];
    
    [HELPER addObserverForMyQueryViewUpdatesIn:self];
    
}

#pragma mark -Model

- (void)setupMenuModel {
    /*
     CVN = "";
     "Credit_Card_Number" = "";
     "Customer_Id" = 16;
     "Email_Id" = "arun@gmail.com";
     "Expiry_Date" = "";
     "First_Name" = arun;
     Image = "http://116.212.240.36/SuburbanAPI/ProfileImage/IMG_1299.PNG";
     "Last_Name" = Prasad;
     "Mobile_Number" = "+617502948402";
     Password = 123123;
     "Promo_Code" = LVR16svUn;
     
     view.layer.cornerRadius = radius;
     view.layer.borderWidth = 1;
     view.layer.borderColor = color.CGColor;
     view.clipsToBounds = YES;
     */
    
    
    [HELPER setURLProfileImageForImageView:_myProfileImage URL:[SESSION getUserInfo][0][@"Image"] placeHolderImage:@"icon_no_profile_big.png"];
    
    [HELPER roundCornerForView:_myProfileImage withRadius:35];
    
    _myNameLabel.text = [SESSION getUserInfo][0][@"First_Name"];//TWO_STRING( [SESSION getUserInfo][0][@"First_Name"], [SESSION getUserInfo][0][@"Last_Name"]);
}

- (void)loadModel {
    
    
    NSMutableArray *aMainMutableArray = [NSMutableArray new];
    
    // This to get the array position based on primary location
    
    aMainMutableArray = [[COREDATAMANAGER getFavouriteListInfo] mutableCopy];
    
    if (aMainMutableArray.count == 0) {
        
        [HELPER addFavoriteList:3];
    }
}

#pragma mark - UITable view Delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _myInfoArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    LUMenuTableViewCell *aCell;
    
    if (!aCell) {
        
        [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LUMenuTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LUMenuTableViewCell class])];
        
        aCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LUMenuTableViewCell class])];
    }
    
    aCell.backgroundColor = [UIColor clearColor];
    aCell.contentView.backgroundColor = aCell.backgroundColor;
    
    
    
    aCell.gTitleLabel.text = _myInfoArray[indexPath.row][KEY_TEXT];
    aCell.gImageView.image = [[UIImage imageNamed:_myInfoArray[indexPath.row][KEY_IMAGE]] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    aCell.gImageView.tintColor = WHITE_COLOUR;
    
    
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
    
    if ([_myInfoArray[indexPath.row][KEY_TEXT] isEqualToString:@"PROFILE"]) {
        
        LUMenuProfileViewController *aViewController = [STORY_BOARD instantiateViewControllerWithIdentifier:@"LUMenuProfileViewController"];
        [self moveToViewController:aViewController];
    }
    else if ([_myInfoArray[indexPath.row][KEY_TEXT] isEqualToString:@"TRIP HISTORY"]) {
        
        LUTripHistoryViewController *aViewController = [STORY_BOARD instantiateViewControllerWithIdentifier:@"LUTripHistoryViewController"];
        [self moveToViewController:aViewController];
    }
    else if ([_myInfoArray[indexPath.row][KEY_TEXT] isEqualToString:@"MANAGE CARDS"]) {
        
        LUPaymentOptionViewController *aViewController = [STORY_BOARD instantiateViewControllerWithIdentifier:@"LUPaymentOptionViewController"];
       // aViewController.isFromOTPScreen = YES;
        
        [self moveToViewController:aViewController];
    }
    else if ([_myInfoArray[indexPath.row][KEY_TEXT] isEqualToString:@"FAVOURITES"]) {
        
        LUFavouritViewController *aViewController = [STORY_BOARD instantiateViewControllerWithIdentifier:@"LUFavouritViewController"];
        
        [self moveToViewController:aViewController];
    }
    else if ([_myInfoArray[indexPath.row][KEY_TEXT] isEqualToString:@"FAMILY & FRIENDS"]) {
        
        LUFamilyAndFriendsViewController *aViewController = [LUFamilyAndFriendsViewController new];
        aViewController.isForFamilyFriendsScreen = YES;
        [self moveToViewController:aViewController];
    }
    else  if ([_myInfoArray[indexPath.row][KEY_TEXT] isEqualToString:@"HELP & SUPPORT"]) {
        
        LUHelpSupportViewController *aViewController = [STORY_BOARD instantiateViewControllerWithIdentifier:@"LUHelpSupportViewController"];
        [self moveToViewController:aViewController];
    }
    else if ([_myInfoArray[indexPath.row][KEY_TEXT] isEqualToString:@"REFER FRIENDS"]) {
        
        LUReferViewController *aViewController = [STORY_BOARD instantiateViewControllerWithIdentifier:@"LUReferViewController"];
        [self moveToViewController:aViewController];
    }
    else if ([_myInfoArray[indexPath.row][KEY_TEXT] isEqualToString:@"PROMOTIONS"]) {
        
        LUFavouritePopViewController * aViewController = [STORY_BOARD instantiateViewControllerWithIdentifier:@"LUFavouritePopViewController"];
        [aViewController setModalPresentationStyle:UIModalPresentationOverCurrentContext];
        aViewController.isForPromoCode = YES;
        
        // To present view controller on the top of all view controller with clear background
        [APPDELEGATE.window.rootViewController presentViewController:aViewController animated:YES completion:^{
            
        }];
    }
}

#pragma mark - UIButton methods -

-(void)leftBarButtonTapEvent {
    
}

-(void)rightBarButtonTapEvent {
    
}

#pragma mark - Helper -

-(void)moveToViewController:(UIViewController *)aViewController {
    
    UINavigationController *aNavigationController = [[UINavigationController alloc]initWithRootViewController:aViewController];
    [self.navigationController presentViewController:aNavigationController animated:YES completion:^{
        [APPDELEGATE.sideMenu closeDrawerAnimated:YES completion:^(BOOL finished) {
            
            NSMutableArray * aMutableArray = [NSMutableArray new];
            [SESSION setSearchInfo:aMutableArray];
        }];
    }];
}

-(void)updateViewForQuerytatusChange {
    
    [HELPER removeObserverForMyQueryViewUpdatesIn:self];
    [self setupMenuModel];
}

@end
