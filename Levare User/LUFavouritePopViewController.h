//
//  LUFavouritePopViewController.h
//  Levare User
//
//  Created by AngMac137 on 12/8/16.
//  Copyright © 2016 AngMac137. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LUFavouritePopViewControllerDelegate <NSObject>

-(void)getSelectedAddressAsFavorite: (NSMutableArray *)aMutableArray iscallBack:(BOOL)iscallBack;

@end


@interface LUFavouritePopViewController : UIViewController<LUFavouritePopViewControllerDelegate>

@property (nonatomic) BOOL isForPromoCode, isForReferalCode, isFromSwiftScreen;
@property (nonatomic, weak) id <LUFavouritePopViewControllerDelegate> gDelegate;

@property (nonatomic, strong) NSMutableDictionary *gMutableDictionary;
@property (nonatomic, copy) void (^callBackBlock)(BOOL iscallBack, NSMutableArray *aMutableArray);
@property (nonatomic, copy) void (^promoCodeCallBackBlock)(BOOL iscallBack, NSString *aString, NSString *aPromoString);

@end
