//
//  CHAutoSlidePageControl.m
//  chtrips
//
//  Created by Hisoka on 15/6/11.
//  Copyright (c) 2015年 HSK.ltd. All rights reserved.
//

#import "CHAutoSlidePageControl.h"

@interface CHAutoSlidePageControl ()

@property (nonatomic, strong) UIImage *normalDotImage;
@property (nonatomic, strong) UIImage *highlightedDotImage;
@property (nonatomic, strong) NSMutableArray *dotsArray;
@property (nonatomic, assign) float dotsSize;
@property (nonatomic, assign) float showSize;
@property (nonatomic, assign) NSInteger dotsGap;
@property (nonatomic, retain) UIImageView *highlightedDotImageView;

@end

@implementation CHAutoSlidePageControl

- (id) initWithFrame:(CGRect)frame
         normalImage:(UIImage *)nImage
    highlightedImage:(UIImage *)hImage
          dotsNumber:(NSInteger)pageNum
          sideLength:(NSInteger)size
             dotsGap:(NSInteger)gap {
    if ((self = [super initWithFrame:frame])) {
        self.pageNumbers = pageNum;
        self.userInteractionEnabled = YES;
        self.dotsGap = gap;
        self.dotsSize = size;
        self.dotsArray = [NSMutableArray array];
//        self.normalDotImage = nImage;
        self.normalDotImage = [self setColorToImage:1 green:139 blue:10];
//        self.highlightedDotImage = hImage;
//        self.highlightedDotImage = [self setColorToImage:255 green:156 blue:0];
        self.highlightedDotImage = [self setColorToImage:7 green:0 blue:0];

        self.showSize = ScreenWidth / self.pageNumbers;
        UIImageView *dotImageView_h = [[UIImageView alloc] initWithImage:self.highlightedDotImage];
        [dotImageView_h.layer setMasksToBounds:NO];
        
//        dotImageView_h.frame = CGRectMake(0, 0, self.dotsSize, self.dotsSize);
        dotImageView_h.frame = CGRectMake(0, 0, self.showSize, 5);
        self.highlightedDotImageView = dotImageView_h;
        
        for (int i = 0; i != self.pageNumbers; ++i) {
            UIImageView *dotsImageView = [[UIImageView alloc] init];
            dotsImageView.userInteractionEnabled = YES;
            dotsImageView.frame = CGRectMake(self.showSize * i, 0, self.showSize, 5);
            dotsImageView.tag = 100 + i;
            
            if (i == 0) {
                self.highlightedDotImageView.frame = CGRectMake(self.showSize * i, 0, self.showSize, 5);
            }
            
//            dotsImageView.image = self.normalDotImage;
            dotsImageView.image = [self setColorToImage:(i + 1) green:0 blue:0];
            [dotsImageView.layer setMasksToBounds:NO];
            
            UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dotsDidTouched:)];
            
            [dotsImageView addGestureRecognizer:gestureRecognizer];

            [self addSubview:dotsImageView];
        }
        
        [self addSubview:self.highlightedDotImageView];
    }
    
    return self;
}

- (void) dotsDidTouched:(id)sender {
    if (self.delegate && [self.delegate  respondsToSelector:@selector(pageControlDidStopAtIndex:)]) {
        [self.delegate pageControlDidStopAtIndex:[[sender view] tag] - 100];
    }
}

- (void) setCurrentPage:(NSInteger)pages {
    if (self.normalDotImage || self.highlightedDotImageView) {
//        CGRect newRect = CGRectMake((self.dotsSize + self.dotsGap) * pages, 0, self.dotsSize, self.dotsSize);
        CGRect newRect = CGRectMake(self.showSize * pages, 0, self.showSize, 5);
        
        [UIView animateWithDuration:0.0f
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
            self.highlightedDotImageView.frame = newRect;
                            }
                         completion:^(BOOL finished) {}];
    }
}

- (UIImage *) setColorToImage:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue {
    
    float imageWidth = ScreenWidth / self.pageNumbers;
    
    CGSize imageSize = CGSizeMake(imageWidth, 5);
    UIGraphicsBeginImageContextWithOptions(imageSize, 0, [UIScreen mainScreen].scale);

    switch (red) {
        case 1:
            [RED_COLOR_BG set];
            break;
        case 2:
            [BLUE_COLOR_BG set];
            break;
        case 3:
            [ORINGE_COLOR_BG set];
            break;
        case 4:
            [GREEN_COLOR_BG set];
            break;
        case 5:
            [[UIColor blueColor] set];
            break;
        default:
            [GRAY_FONT_COLOR set];
            break;
    }
    
    UIRectFill(CGRectMake(0, 0, imageSize.width, imageSize.height));
    UIImage *pressedColorImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return pressedColorImg;
}



@end
