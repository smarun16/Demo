//
//  LUAddFriendsViewController.h
//  Levare User
//
//  Created by angler133 on 08/12/16.
//  Copyright © 2016 AngMac137. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LUAddFriendsViewController : UIViewController 

@property (weak, nonatomic) IBOutlet UITableView *myTblView;
@property (weak, nonatomic) IBOutlet UISearchBar *mySearchBar;
@property (weak, nonatomic) IBOutlet UIView *mySearchView;
@property (weak, nonatomic) IBOutlet UILabel *myLblSearchAlert;
@property (nonatomic, copy) void (^callBackBlock)(BOOL iscallBack, NSMutableArray *aMutableArray);
@property (nonatomic, strong) NSMutableArray *gMAryInfo;
@end
