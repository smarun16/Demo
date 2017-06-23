//
//  CardTableViewCell.h
//  MetroPark
//
//  Created by anglereit on 01/09/15.
//  Copyright (c) 2015 anglereit. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BKCardNumberField.h"
#import "BKCardExpiryField.h"

@interface CardTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UITextField *cardPartNumberTextField;

@property (weak, nonatomic) IBOutlet BKCardNumberField *cardNumberTextField;


@property (weak, nonatomic) IBOutlet UITextField *cardHolderNameTextField;

@property (weak, nonatomic) IBOutlet BKCardExpiryField *cardExpiryDate;
@property (weak, nonatomic) IBOutlet UITextField *cardCVV;

@end
