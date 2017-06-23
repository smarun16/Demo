//
//  LUFamilyAndFriendsViewController.h
//  Levare User
//
//  Created by angler133 on 08/12/16.
//  Copyright © 2016 AngMac137. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LUFamilyAndFriendsViewController : UIViewController

@property (strong, nonatomic) NSMutableArray *gMAryExistingContactInfo;

@property (weak, nonatomic) IBOutlet UIButton *myBtnAddContacts;
@property (weak, nonatomic) IBOutlet UITableView *myTblView;
@property (nonatomic) BOOL isForFamilyFriendsScreen;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *myNextButtonHeightConstraint;
@property (strong, nonatomic) IBOutlet UIButton *myNextButton;
@property (strong, nonatomic) NSArray *gInfoArray;
@end
