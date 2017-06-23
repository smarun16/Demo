//
//  CustomAlertView.h
//  MetroPark
//
//  Created by anglereit on 14/09/15.
//  Copyright (c) 2015 anglereit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "M13ProgressViewRing.h"

@interface NetworkView : NibLoadedView

@property (weak, nonatomic) IBOutlet UIImageView *alertImageView;
@property (weak, nonatomic) IBOutlet UILabel *alertTitle;
@property (weak, nonatomic) IBOutlet UILabel *alertDescription;
@property (weak, nonatomic) IBOutlet UIView *alertContainer;
@property (weak, nonatomic) IBOutlet UIView *loadingContainer;
@property (weak, nonatomic) IBOutlet UILabel *loadingLabel;
@property (weak, nonatomic) IBOutlet M13ProgressViewRing *progressRing;
@property (weak, nonatomic) IBOutlet UILabel *alertAppoinment;
@property (weak, nonatomic) IBOutlet UILabel *alertAppName;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *alertAppNameWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *alertAppoinmentheightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *PlusLabel;

@end
