//
//  RatingView.m
//  RatingView
//
//  Created by Tanguy Hélesbeux on 14/10/13.
//  Copyright (c) 2013 Tanguy Hélesbeux. All rights reserved.
//

#import "RatingView.h"

@interface RatingView()



@end

@implementation RatingView

#define EXCEPTION_NAME @"RatingView : Invalid settings."
#define EXCEPTION_MESSAGE @"Could not determine items size with min, max and interval values defined."

- (UIImageView *)backImageView
{
    if (!_backImageView)
    {
        CGRect backViewFrame = self.bounds;
        backViewFrame.size.height = self.itemWidth;
        backViewFrame.size.width = self.itemWidth * self.itemsCount;
        backViewFrame.origin.y = (self.bounds.size.height - backViewFrame.size.height)/2;
        backViewFrame.origin.x = (self.bounds.size.width - backViewFrame.size.width)/2;
        _backImageView = [[UIImageView alloc] initWithFrame:backViewFrame];
        _backImageView.tintColor = [UIColor lightGrayColor];

        [_backImageView setBackgroundColor:[UIColor colorWithPatternImage:self.backImage]];
    }
    return _backImageView;
}

- (UIImageView *)frontImageView
{
    if (!_frontImageView)
    {
        CGRect frontViewFrame = self.bounds;
        frontViewFrame.size.height = self.itemWidth;
        frontViewFrame.size.width = 0;
        frontViewFrame.origin.y = (self.bounds.size.height - frontViewFrame.size.height)/2;
        frontViewFrame.origin.x = self.backImageView.frame.origin.x;
        _frontImageView = [[UIImageView alloc] initWithFrame:frontViewFrame];
        _frontImageView.tintColor = [UIColor orangeColor];

        [_frontImageView setBackgroundColor:[UIColor colorWithPatternImage:self.frontImage]];
    }
    return _frontImageView;
}

- (UIImage *)backImage
{
    if (!_backImage)
    {
        CGSize backImgSize = CGSizeMake(self.itemWidth, self.itemWidth);
        _backImage = [self imageWithImage:[UIImage imageNamed:self.unSelectedImageName] scaledToSize:backImgSize];
    }
    return _backImage;
}

- (UIImage *)frontImage
{
    if (!_frontImage)
    {
        UIImage *image  = [UIImage imageNamed:self.selectedImageName];
        
        CGSize frontImgSize = CGSizeMake(self.itemWidth, self.itemWidth);
        _frontImage = [self imageWithImage:image scaledToSize:frontImgSize];
    }
    return _frontImage;
}

- (id)initWithFrame:(CGRect)frame
  selectedImageName:(NSString *)selectedImage
    unSelectedImage:(NSString *)unSelectedImage
           minValue:(NSInteger)min maxValue:(NSInteger)max
      intervalValue:(CGFloat)interval
         stepByStep:(BOOL)stepByStep
{
    self = [self initWithFrame:frame];
    if (self)
    {
        _stepByStep = stepByStep;
        _maxValue = max;
        _minValue = min;
        _intervalValue = interval;
        
        _selectedImageName = selectedImage;
        _unSelectedImageName = unSelectedImage;
        
        _itemsCount = _maxValue - _minValue;
        _itemWidth = frame.size.width / _itemsCount;
        _itemWidth = MIN(_itemWidth, frame.size.height);
        
        float testClipCounts = (_maxValue - _minValue)/_intervalValue;
        _clipsCount = round(testClipCounts);
        
        if (testClipCounts == _clipsCount) {
            _clipInterval = _itemWidth * _itemsCount / _clipsCount;
        } else {
            [NSException raise:EXCEPTION_NAME format:EXCEPTION_MESSAGE];
        }
        
        [self addSubview:self.backImageView];
        [self addSubview:self.frontImageView];
    }
    return self;
}

- (void)setupSelectedImageName:(NSString *)selectedImage
    unSelectedImage:(NSString *)unSelectedImage
           minValue:(NSInteger)min maxValue:(NSInteger)max
      intervalValue:(CGFloat)interval
         stepByStep:(BOOL)stepByStep
{
    if (self)
    {
        _stepByStep = stepByStep;
        _maxValue = max;
        _minValue = min;
        _intervalValue = interval;
        
        _selectedImageName = selectedImage;
        _unSelectedImageName = unSelectedImage;
        
        _itemsCount = _maxValue - _minValue;
        _itemWidth = self.frame.size.width / _itemsCount;
        _itemWidth = MIN(_itemWidth, self.frame.size.height);
        
        float testClipCounts = (_maxValue - _minValue)/_intervalValue;
        _clipsCount = round(testClipCounts);
        
        if (testClipCounts == _clipsCount) {
            _clipInterval = _itemWidth * _itemsCount / _clipsCount;
        } else {
            [NSException raise:EXCEPTION_NAME format:EXCEPTION_MESSAGE];
        }
        
        [self addSubview:self.backImageView];
        [self addSubview:self.frontImageView];
    }
   
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        UIPanGestureRecognizer* panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        panRecognizer.minimumNumberOfTouches = 1;
        panRecognizer.delegate = self;
        UITapGestureRecognizer* tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        tapRecognizer.numberOfTapsRequired = 1;
        tapRecognizer.delegate = self;
        
        [self addGestureRecognizer:panRecognizer];
        [self addGestureRecognizer:tapRecognizer];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        UIPanGestureRecognizer* panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        panRecognizer.minimumNumberOfTouches = 1;
        panRecognizer.delegate = self;
        UITapGestureRecognizer* tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        tapRecognizer.numberOfTapsRequired = 1;
        tapRecognizer.delegate = self;
        
        [self addGestureRecognizer:panRecognizer];
        [self addGestureRecognizer:tapRecognizer];
    }
    return self;
}

- (void)handlePan:(UIPanGestureRecognizer *)recognizer
{
    CGPoint translation = [recognizer locationInView:self.frontImageView];
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
        {
            [self selectItemWithLocation:translation withCallback:YES];
            break;
        }
            
        case UIGestureRecognizerStateEnded:
        {
            [self selectItemWithLocation:[recognizer locationInView:self] withCallback:YES];
            break;
        }
            
        default: // When moving
        {
            if (self.stepByStep)
            {
                [self selectItemWithLocation:translation withCallback:YES];
            } else {
                if ((translation.x >= 0) && (translation.x <= self.clipsCount * self.clipInterval))
                {
                    CGRect newFrame = self.frontImageView.frame;
                    newFrame.size.width = translation.x;
                    self.frontImageView.frame = newFrame;
                }
            }
        }
            break;
    }
}

- (void)handleTap:(UITapGestureRecognizer *)recognizer
{
    CGPoint location = [recognizer locationInView:self.frontImageView];
    [self selectItemWithLocation:location withCallback:YES];
}

- (void)selectItemWithLocation:(CGPoint)location withCallback:(BOOL)callBack
{
    NSInteger intX = round(location.x);
    
    NSInteger remaining = intX % self.clipInterval;
    NSInteger fullClipsNumber = (intX - remaining) / self.clipInterval;
    
    if ((remaining - self.clipInterval/2) > 0)
    {
        fullClipsNumber ++; // rounded correction
    }
    
    [self setValueWithAnimation:(fullClipsNumber * self.intervalValue)];
    
    if ([self.delegate respondsToSelector:@selector(rateChanged:)] && callBack)
    {
        [self.delegate rateChanged:self];
    }
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)setValue:(CGFloat)value
{
    _value = MAX(value, self.minValue);
    _value =  MIN(_value, self.maxValue);
    CGRect tempFrame = self.frontImageView.frame;
    tempFrame.size.width = _value * self.itemWidth;
    tempFrame.origin.x = self.backImageView.frame.origin.x;

    self.frontImageView.frame = tempFrame;
    
}

- (void)setValueWithAnimation:(CGFloat)value
{
    _value = MAX(value, self.minValue);
    _value =  MIN(_value, self.maxValue);
    CGRect tempFrame = self.frontImageView.frame;
    tempFrame.size.width = _value * self.itemWidth;
    tempFrame.origin.x = self.backImageView.frame.origin.x;

    [UIView animateWithDuration:1.0 animations:^{
        self.frontImageView.frame = tempFrame;
    }];
}

@end
