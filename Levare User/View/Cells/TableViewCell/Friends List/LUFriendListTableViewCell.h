//
//  LUFriendListTableViewCell.h
//  Levare User
//
//  Created by angler133 on 08/12/16.
//  Copyright © 2016 AngMac137. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LUFriendListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *gContainerView;

@property (weak, nonatomic) IBOutlet UIImageView *gImgView;
@property (weak, nonatomic) IBOutlet UILabel *gLblName;
@property (weak, nonatomic) IBOutlet UILabel *gLblDescription;
@end
