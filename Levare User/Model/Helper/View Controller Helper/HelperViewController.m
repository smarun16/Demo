//
//  HelperViewController.m
//  Shopping Mall
//
//  Created by anglereit on 06/08/15.
//  Copyright (c) 2015 anglereit. All rights reserved.
//

#import "HelperViewController.h"

@interface HelperViewController ()<HelperViewControllerProtocal>

@end

@implementation HelperViewController

#pragma mark -
#pragma mark Refresh Control For TableView
#pragma mark - 

#pragma mark -setup

- (void)setRefreshControlFor:(UITableView *)aTableView {
    
    UITableViewController *tableViewController = [[UITableViewController alloc] init];
    [self addChildViewController:tableViewController];
    tableViewController.tableView = aTableView;
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc]init];
    tableViewController.refreshControl = refreshControl;
    
    [refreshControl addTarget:self action:@selector(refreshList:) forControlEvents:UIControlEventValueChanged];
    refreshControl.tintColor = [HELPER getColorFromHexaDecimal:COLOR_APP_PRIMARY];
    
    /*[UIView animateWithDuration:0.5 animations:^{
        [self beginRefreshingFor:aTableView];
    }];*/
    
}


#pragma mark -Actions

- (void)beginRefreshingFor:(UITableView *)aTableView {
    
    for (UIRefreshControl *refreshControl in aTableView.subviews) {
        
        if ([refreshControl isKindOfClass:[UIRefreshControl class]]) {
            
            if (aTableView.contentOffset.y == 0) {
                
                [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^(void){
                    
                    aTableView.contentOffset = CGPointMake(0, -refreshControl.frame.size.height);
                    [refreshControl beginRefreshing];

                } completion:^(BOOL finished){
                    
                    [self setAttributedText:[SESSION getLastUpdatedTimeFor:NSStringFromClass([self class])] refreshContoller:refreshControl];
                    
                    [refreshControl layoutIfNeeded];
                    
                    NSLog(@"HelperViewController= %@",[SESSION getLastUpdatedTimeFor:NSStringFromClass([self class])]);

                    
                    self.helperIsRefreshing = YES;
                    [self refreshList :refreshControl];
                    
                }];
            }
            
            
            break;
        }
    }
}

- (void)endRefreshingFor:(UITableView *)aTableView {
    
    for (UIRefreshControl *refreshControl in aTableView.subviews) {
        
        if ([refreshControl isKindOfClass:[UIRefreshControl class]]) {
            
            [SESSION setLastUpdatedTime:[HELPER getCurrentDateInFormat:@"dd-MM-yyyy hh:mm a"] module:NSStringFromClass([self class])];
            
            self.helperIsRefreshing = NO;
            [refreshControl endRefreshing];
            break;
        }
    }
}

- (void)setHidden:(BOOL)isHidden for:(UITableView *)aTableView {
    
    for (UIRefreshControl *refreshControl in aTableView.subviews) {
        
        if ([refreshControl isKindOfClass:[UIRefreshControl class]]) {
            
            [refreshControl setAlpha:isHidden ? 0 : 1];
            break;
        }
    }
}

#pragma mark -Helper Methods

- (void)setAttributedText:(NSString *)lastUpdatedTime refreshContoller:(UIRefreshControl *)refreshControl {
    
    lastUpdatedTime = @"";
    NSString *message;
    
    if (lastUpdatedTime.length == 0 || [lastUpdatedTime isEqualToString:@"0000-00-00T00:00:00"]) {
        message = @"Loading..";
    }
    else {
        
        message = lastUpdatedTime.length != 0 ? [NSString stringWithFormat:@"Last updated: %@", lastUpdatedTime] : @"Loading..";
    }
    
    NSDictionary *attributes = [[NSDictionary alloc] initWithObjectsAndKeys:[UIColor lightGrayColor],NSForegroundColorAttributeName, [UIFont systemFontOfSize:11], NSFontAttributeName, nil];
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:message attributes:attributes];
    refreshControl.attributedTitle = attributedString;
    
}

- (void)updateRefreshTimeForTableView:(UITableView*)aTableView {
    
    for (UIRefreshControl *refreshControl in aTableView.subviews) {
        
        if ([refreshControl isKindOfClass:[UIRefreshControl class]]) {
            
            [self setAttributedText:[SESSION getLastUpdatedTimeFor:NSStringFromClass([self class])] refreshContoller:refreshControl];
            self.helperIsRefreshing = YES;
            break;
        }
        
    }
    
}

#pragma mark -
#pragma mark Refresh Control For CollectionView
#pragma mark -

#pragma mark -setup

- (void)setRefreshControlForCollectionView:(UICollectionView *)aCollectionView {
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc]init];
    [aCollectionView addSubview:refreshControl];
    aCollectionView.alwaysBounceVertical = YES;
    [refreshControl addTarget:self action:@selector(refreshListForCollectionView:) forControlEvents:UIControlEventValueChanged];
    refreshControl.tintColor = [HELPER getColorFromHexaDecimal:COLOR_APP_PRIMARY];
}


#pragma mark -Actions

- (void)beginRefreshingForCollectionView:(UICollectionView *)aCollectionView {
    
    for (UIRefreshControl *refreshControl in aCollectionView.subviews) {
        
        if ([refreshControl isKindOfClass:[UIRefreshControl class]]) {
            
            if (aCollectionView.contentOffset.y == 0) {
                
                [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^(void){
                    
                    aCollectionView.contentOffset = CGPointMake(0, -refreshControl.frame.size.height);
                    [refreshControl beginRefreshing];
                    
                } completion:^(BOOL finished){
                    
                    [self setAttributedText:[SESSION getLastUpdatedTimeFor:NSStringFromClass([self class])] refreshContoller:refreshControl];
                    [refreshControl layoutIfNeeded];
                    
                    NSLog(@"HelperViewController= %@",[SESSION getLastUpdatedTimeFor:NSStringFromClass([self class])]);
                    
                    self.helperIsRefreshing = YES;
                    [self refreshListForCollectionView:refreshControl];
                    
                }];
            }
            
            
            break;
        }
    }
}

- (void)endRefreshingForCollectionView:(UICollectionView *)aCollectionView {
    
    for (UIRefreshControl *refreshControl in aCollectionView.subviews) {
        
        if ([refreshControl isKindOfClass:[UIRefreshControl class]]) {
            
            [SESSION setLastUpdatedTime:[HELPER getCurrentDateInFormat:@"dd-MM-yyyy hh:mm a"] module:NSStringFromClass([self class])];
            
            self.helperIsRefreshing = NO;
            [refreshControl endRefreshing];
            break;
        }
    }
}

- (void)setHiddenForCollectionView:(BOOL)isHidden for:(UICollectionView *)aCollectionView {
    
    for (UIRefreshControl *refreshControl in aCollectionView.subviews) {
        
        if ([refreshControl isKindOfClass:[UIRefreshControl class]]) {
            
            [refreshControl setAlpha:isHidden ? 0 : 1];
            break;
        }
    }
}


- (void)updateRefreshTimeForCollectionView:(UICollectionView *)aCollectionView{
    
    for (UIRefreshControl *refreshControl in aCollectionView.subviews) {
        
        if ([refreshControl isKindOfClass:[UIRefreshControl class]]) {
            
            [self setAttributedText:[SESSION getLastUpdatedTimeFor:NSStringFromClass([self class])] refreshContoller:refreshControl];
            self.helperIsRefreshing = YES;
            break;
        }
    }
}


#pragma mark -
#pragma mark Tap to retry
#pragma mark -

@end
