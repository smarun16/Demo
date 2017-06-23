//
//  LUFavouriteSearchViewController.h
//  Levare
//
//  Created by Arun Prasad.S, ANGLER - EIT on 11/01/17.
//  Copyright © 2017 AngMac137. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LUFavouriteSearchViewControllerDelegate <NSObject>

-(void)getSelectedAddressFromGMSList: (NSMutableDictionary *)aMutableDict iscallBack:(BOOL)iscallBack;

@end

@interface LUFavouriteSearchViewController : UIViewController<LUFavouriteSearchViewControllerDelegate>

@property (nonatomic) BOOL isFromSwiftDasbordScreen;
@property (nonatomic, weak) id <LUFavouriteSearchViewControllerDelegate> gDelegate;
@property (nonatomic, copy) void (^callBackBlock)(BOOL iscallBack, NSMutableArray *aMutableArray);
@property (nonatomic) CLLocationCoordinate2D gLocationCoordinate;
@end
