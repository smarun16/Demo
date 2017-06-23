//
//  LUChatViewController.h
//  Levare User
//
//  Created by Arun Prasad.S, ANGLER - EIT on 26/12/16.
//  Copyright © 2016 AngMac137. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface LUChatViewController : UIViewController

@property (nonatomic, strong) NSMutableArray *myDriverMutableInfo;
@property (nonatomic, copy) void (^callBackBlock)(BOOL iscallBack, BOOL isRequestCancel);
@property (nonatomic, strong) NSString *gTripIdString, *gUserIdString;



@end
