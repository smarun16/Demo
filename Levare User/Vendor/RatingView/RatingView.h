//
//  RatingView.h
//  RatingView
//
//  Created by Tanguy Hélesbeux on 14/10/13.
//  Copyright (c) 2013 Tanguy Hélesbeux. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE

@protocol RatingViewDelegate;

@interface RatingView : UIView <UIGestureRecognizerDelegate>

@property (strong, nonatomic) UIImageView *backImageView;
@property (strong, nonatomic) UIImageView *frontImageView;

@property (strong, nonatomic) UIImage *backImage;
@property (strong, nonatomic) UIImage *frontImage;

@property (strong, readwrite, nonatomic) NSString *selectedImageName;
@property (strong, readwrite, nonatomic) NSString *unSelectedImageName;

@property (nonatomic) NSInteger minValue;
@property (nonatomic) NSInteger maxValue;
@property (nonatomic) CGFloat intervalValue;

@property (nonatomic) NSInteger itemsCount;
@property (nonatomic) NSInteger itemWidth;

@property (nonatomic) NSInteger clipInterval;
@property (nonatomic) NSInteger clipsCount;

@property (nonatomic) BOOL stepByStep;


@property (assign) id <RatingViewDelegate>  delegate;

@property (readwrite, nonatomic) CGFloat value;

- (id)initWithFrame:(CGRect)frame
  selectedImageName:(NSString *)selectedImage
    unSelectedImage:(NSString *)unSelectedImage
           minValue:(NSInteger)min maxValue:(NSInteger)max
      intervalValue:(CGFloat)interval
         stepByStep:(BOOL)stepByStep;

- (void)setupSelectedImageName:(NSString *)selectedImage
               unSelectedImage:(NSString *)unSelectedImage
                      minValue:(NSInteger)min maxValue:(NSInteger)max
                 intervalValue:(CGFloat)interval
                    stepByStep:(BOOL)stepByStep;

- (void)setValueWithAnimation:(CGFloat)value;

@end

@protocol RatingViewDelegate <NSObject>
@optional

- (void)rateChanged:(RatingView *)sender;


@end
