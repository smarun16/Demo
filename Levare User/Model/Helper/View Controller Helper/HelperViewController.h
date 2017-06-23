//
//  HelperViewController.h
//  Shopping Mall
//
//  Created by anglereit on 06/08/15.
//  Copyright (c) 2015 anglereit. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HelperViewControllerProtocal <NSObject>

@optional
- (void)refreshList:(UIRefreshControl*)aSender;
- (void)refreshListForCollectionView:(UIRefreshControl*)aSender;

@end


@interface HelperViewController : UIViewController

//////////////// Properties //////////////

@property (nonatomic) BOOL helperIsRefreshing;

//////////////// Methods //////////////

#pragma mark - Pull to Refresh
/*!
 * @description
 * Add RefreshControl to tableView
 *
 * @param tableView
 * TableView to which RefreshControl must be added
 *
 */
- (void)setRefreshControlFor:(UITableView *)aTableView;

/*!
 * @description
 * Perform pull to refresh
 *
 * @param tableView
 * Refresh Control's TableView
 *
 */
- (void)beginRefreshingFor:(UITableView *)aTableView;

/*!
 * @description
 * Stop pull to refresh
 *
 * @param tableView
 * Refresh Control's TableView
 *
 */
- (void)endRefreshingFor:(UITableView *)aTableView;

/*!
 * @description
 * Show or Hide RefreshControl
 *
 * @param isHidden
 * YES - hide   NO - Show
 *
 * @param tableView
 * Refresh Control's TableView
 *
 */
- (void)setHidden:(BOOL)isHidden for:(UITableView *)aTableView;

/*!
 * @description
 * Update last refreshed time in RefreshControl
 *
 * @param tableView
 * Refresh Control's TableView
 *
 */
- (void)updateRefreshTimeForTableView:(UITableView*)aTableView;



#pragma mark -
#pragma mark - Pull to Refresh For CollectionView
#pragma mark -


/*!
 * @description
 * Add RefreshControl to CollectionView
 *
 * @param CollectionView
 * CollectionView to which RefreshControl must be added
 *
 */
- (void)setRefreshControlForCollectionView:(UICollectionView *)aCollectionView;

/*!
 * @description
 * Perform pull to refresh
 *
 * @param CollectionView
 * Refresh Control's CollectionView
 *
 */
- (void)beginRefreshingForCollectionView:(UICollectionView *)aCollectionView;

/*!
 * @description
 * Stop pull to refresh
 *
 * @param CollectionView
 * Refresh Control's CollectionView
 *
 */
- (void)endRefreshingForCollectionView:(UICollectionView *)aCollectionView;

/*!
 * @description
 * Show or Hide RefreshControl
 *
 * @param isHidden
 * YES - hide   NO - Show
 *
 * @param CollectionView
 * Refresh Control's CollectionView
 *
 */
- (void)setHiddenForCollectionView:(BOOL)isHidden for:(UICollectionView *)aCollectionView;

/*!
 * @description
 * Update last refreshed time in RefreshControl
 *
 * @param CollectionView
 * Refresh Control's CollectionView
 *
 */
- (void)updateRefreshTimeForCollectionView:(UICollectionView*)aCollectionView;

@end
