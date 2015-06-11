//
//  CHAutoSlidePageControl.h
//  chtrips
//
//  Created by Hisoka on 15/6/11.
//  Copyright (c) 2015年 HSK.ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CHAutoSlidePageControlDelegate <NSObject>

@optional

- (void) pageControlDidStopAtIndex:(NSInteger)index;

@end

//@interface CHAutoSlidePageControl : UIPageControl
@interface CHAutoSlidePageControl : UIView

@property (nonatomic, assign) NSInteger pageNumbers;
@property (nonatomic, weak) id<CHAutoSlidePageControlDelegate> delegate;

- (id) initWithFrame:(CGRect)frame
         normalImage:(UIImage *)nImage
    highlightedImage:(UIImage *)hImage
          dotsNumber:(NSInteger)pageNum
          sideLength:(NSInteger)size
             dotsGap:(NSInteger)gap;

- (void) setCurrentPage:(NSInteger)pages;
@end
