//
//  LUTestViewController.m
//  Levare
//
//  Created by Arun Prasad.S, ANGLER - EIT on 15/02/17.
//  Copyright © 2017 AngMac137. All rights reserved.
//

#import "LUTestViewController.h"

@interface LUTestViewController ()

@property (strong, nonatomic) IBOutlet HMSegmentedControl *segmentController;
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) IBOutlet UIView *myBgView;
@property (strong, nonatomic) IBOutlet MKMapView *myMapView;
@end

@implementation LUTestViewController

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
    
    [NAVIGATION setTitleWithBarButtonItems:SCREEN_TITLE_DASHBOARD forViewController:self showLeftBarButton:IMAGE_MENU showRightBarButton:nil];
}

#pragma mark -Model

- (void)setupModel {
    
    // Segment Control
    
    self.segmentController.sectionTitles = @[@"Car",@"Mini Car",@"Van"];
    
    self.segmentController.selectedSegmentIndex = 0;
    self.segmentController.backgroundColor = [HELPER getColorFromHexaDecimal:COLOR_GROUP_TABLE_VIEW];
    self.segmentController.titleTextAttributes = @{ NSFontAttributeName : [UIFont systemFontOfSize:12.0f],
                                            NSForegroundColorAttributeName : [UIColor blackColor],};
    self.segmentController.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : [UIColor darkGrayColor]};
    self.segmentController.selectionIndicatorColor = [UIColor blackColor];
    self.segmentController.selectionStyle = HMSegmentedControlSelectionStyleBox;
    self.segmentController.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    [self.segmentController addTarget:self action:@selector(segmentedControlValueChanged:) forControlEvents:UIControlEventValueChanged];

    
}

- (void)loadModel {
    
}

#pragma mark - HM Segment Controller -

-(void)segmentedControlValueChanged:(HMSegmentedControl *)sender {
    
}

#pragma mark - UITable view Delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 3;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    
    return [UIView new];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 25;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellIdentifier =@"Cell";
    
    UITableViewCell *aCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (aCell == nil) {
        
        aCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    UIImageView *gImageView = (UIImageView *)[aCell viewWithTag:1];
    UILabel *gTitleLabel = (UILabel *)[aCell viewWithTag:2];
    UILabel *gFareEstimationLabel = (UILabel *)[aCell viewWithTag:3];
    UILabel *gTimeLabel = (UILabel *)[aCell viewWithTag:4];
    
    if (indexPath.row == 0) {
        
        gImageView.image = [UIImage imageNamed:@"icon_car"];
        gTitleLabel.text = @"Normal Service";
        gFareEstimationLabel.text = @"$300 - $400";
        gTimeLabel.text = @"20 Minutes";
    }
    else if (indexPath.row == 1) {
        
        gImageView.image = [UIImage imageNamed:@"icon_big_car"];
        gTitleLabel.text = @"Levare Lux";
        gFareEstimationLabel.text = @"$350 - $450";
        gTimeLabel.text = @"18 Minutes";
    }
    else {
        
        gImageView.image = [UIImage imageNamed:@"icon_van"];
        gTitleLabel.text = @"Levare Max";
        gFareEstimationLabel.text = @"$400 - $500";
        gTimeLabel.text = @"15 Minutes";
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
}

@end
