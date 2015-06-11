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
        self.userInteractionEnabled = YES;
        self.dotsGap = gap;
        self.dotsSize = size;
        self.dotsArray = [NSMutableArray array];
        self.normalDotImage = nImage;
        self.highlightedDotImage = hImage;
        self.pageNumbers = pageNum;
        
        UIImageView *dotImageView_h = [[UIImageView alloc] initWithImage:self.highlightedDotImage];
        [dotImageView_h.layer setMasksToBounds:NO];
        
        dotImageView_h.frame = CGRectMake(0, 0, self.dotsSize, self.dotsSize);
        self.highlightedDotImageView = dotImageView_h;
        
        for (int i = 0; i != self.pageNumbers; ++i) {
            UIImageView *dotsImageView = [[UIImageView alloc] init];
            dotsImageView.userInteractionEnabled = YES;
            dotsImageView.frame = CGRectMake((size + gap) * i, 0, size, size);
            dotsImageView.tag = 100 + i;
            
            if (i == 0) {
                self.highlightedDotImageView.frame = CGRectMake((size + gap) * i, 0, size, size);
            }
            
            dotsImageView.image = self.normalDotImage;
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
        CGRect newRect = CGRectMake((self.dotsSize + self.dotsGap) * pages, 0, self.dotsSize, self.dotsSize);
        
        [UIView animateWithDuration:0.0f
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
            self.highlightedDotImageView.frame = newRect;
                            }
                         completion:^(BOOL finished) {}];
    }
}

@end
