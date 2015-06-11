//
//  CHAutoSlideScrollView.m
//  chtrips
//
//  Created by Hisoka on 15/6/11.
//  Copyright (c) 2015年 HSK.ltd. All rights reserved.
//

#import "CHAutoSlideScrollView.h"
#import "CHAutoSlidePageControl.h"
#import "NSTimer+Addition.h"

@interface CHAutoSlideScrollView () <UIScrollViewDelegate>
{
    CGFloat scrollViewStartContentOffsetX;
}

@property (nonatomic, assign) NSInteger currentPageIndex;
@property (nonatomic, assign) NSInteger totalPageCount;
@property (nonatomic, strong) NSMutableArray *contentViews;
@property (nonatomic, assign) UIScrollView *scrollView;
@property (nonatomic, strong) NSTimer *animationTimer;
@property (nonatomic, assign) NSTimeInterval animationDuration;
@property (nonatomic, strong) CHAutoSlidePageControl *pageControl;

@end


@implementation CHAutoSlideScrollView

- (CHAutoSlidePageControl *) pageControl {
    if (self.totalPageCount > 1) {
        if (!_pageControl) {
            NSInteger totalPageCounts = self.totalPageCount;
            CGFloat dotGapWidth = 8.0;
            
            UIImage *normalDotImage = [UIImage imageNamed:@"yellowpoint"];
            UIImage *highlightDotImage = [UIImage imageNamed:@"redpoint"];
            CGFloat pageControlWidth = totalPageCounts * normalDotImage.size.width + (totalPageCounts - 1) * dotGapWidth;
            CGRect pageControlFram = CGRectMake(CGRectGetMidX(self.scrollView.frame) - 0.5 *pageControlWidth, 0.9 * CGRectGetHeight(self.scrollView.frame), pageControlWidth, normalDotImage.size.height);
            
            _pageControl = [[CHAutoSlidePageControl alloc] initWithFrame:pageControlFram
                                                             normalImage:normalDotImage
                                                        highlightedImage:highlightDotImage
                                                              dotsNumber:totalPageCounts 
                                                              sideLength:dotGapWidth
                                                                 dotsGap:dotGapWidth];
            _pageControl.hidden = NO;
        }
    }
    
    return _pageControl;
}

- (void) setTotalPagesCount:(NSInteger (^)(void))totalPagesCount {
    self.totalPageCount = totalPagesCount();
    
    if (self.totalPageCount > 0) {
        if (self.totalPageCount > 1) {
            self.scrollView.scrollEnabled = YES;
            self.scrollView.contentOffset = CGPointMake(CGRectGetWidth(self.scrollView.frame), 0);
            [self.animationTimer resumeTimerAfterTimeInterval:self.animationDuration];
        }else{
            self.scrollView.scrollEnabled = NO;
        }
        [self configContentView];
        [self addSubview:self.pageControl];
        
    }
}

- (void) setFetchContentViewAtIndex:(UIView *(^)(NSInteger))fetchContentViewAtIndex {
    _fetchContentViewAtIndex = fetchContentViewAtIndex;
    // 加入第一页
    [self configContentView];
}

- (void) setCurrentPageIndex:(NSInteger)currentPageIndex {
    _currentPageIndex = currentPageIndex;
    [self.pageControl setCurrentPage:_currentPageIndex];
}

- (id) initWithFrame:(CGRect)frame animationDuration:(NSTimeInterval)animationDuration {
    self = [self initWithFrame:frame];
    
    if (animationDuration > 0.0) {
        self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:(self.animationDuration = animationDuration)
                                                               target:self
                                                             selector:@selector(animationTimerDidFired:)
                                                             userInfo:nil
                                                              repeats:YES];
        [self.animationTimer pauseTimer];
    }
    
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.autoresizesSubviews = YES;
        self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        self.scrollView.autoresizingMask = 0xFF;
        self.scrollView.contentMode = UIViewContentModeCenter;
        self.scrollView.contentSize = CGSizeMake(3 * CGRectGetWidth(self.scrollView.frame), CGRectGetHeight(self.scrollView.frame));
        self.scrollView.delegate = self;
        self.scrollView.pagingEnabled = YES;
        [self addSubview:self.scrollView];
        
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.currentPageIndex = 0;
        self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:(self.animationDuration = 3)
                                                               target:self
                                                             selector:@selector(animationTimerDidFired:)
                                                             userInfo:nil
                                                              repeats:YES];
        [self.animationTimer pauseTimer];
    }
    
    return self;
}

- (id) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.autoresizesSubviews = YES;
        self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        self.scrollView.autoresizingMask = 0xFF;
        self.scrollView.contentMode = UIViewContentModeCenter;
        self.scrollView.contentSize = CGSizeMake(3 * CGRectGetWidth(self.scrollView.frame), CGRectGetHeight(self.scrollView.frame));
        self.scrollView.delegate = self;
        self.scrollView.pagingEnabled = YES;
        [self addSubview:self.scrollView];
        self.currentPageIndex = 0;
    }
    
    return self;
}

- (void) configContentView {
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self setScrollViewContentDataSource];
    
    NSInteger counter = 0;
    for (UIView *contentView in self.contentViews) {
        contentView.userInteractionEnabled = YES;
        UILongPressGestureRecognizer *longTapGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longTapGestureAction:)];
        [contentView addGestureRecognizer:longTapGesture];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentViewTapAction:)];
        [contentView addGestureRecognizer:tapGesture];
        
        CGRect rightRect = contentView.frame;
        rightRect.origin = CGPointMake(CGRectGetWidth(self.scrollView.frame) * (counter++), 0);
        
        contentView.frame = rightRect;
        [self.scrollView addSubview:contentView];
    }
    
    if (self.totalPageCount > 1) {
        [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width, 0)];
    }
}

// 设置scrollview的content数据源
- (void) setScrollViewContentDataSource{
    NSInteger previousPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex - 1];
    NSInteger rearPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex + 1];
    
    if (self.contentViews == nil) {
        self.contentViews = [@[] mutableCopy];
    }
    [self.contentViews removeAllObjects];
    
    if (self.fetchContentViewAtIndex) {
        id set = (self.totalPageCount == 1) ? [NSSet setWithObjects:@(previousPageIndex), @(_currentPageIndex), @(rearPageIndex), nil] : @[@(previousPageIndex), @(_currentPageIndex), @(rearPageIndex)];
        
        for (NSNumber *tempNumber in set) {
            NSInteger tempIndex = [tempNumber integerValue];
            if ([self isValidArrayIndex:tempIndex]) {
                [self.contentViews addObject:self.fetchContentViewAtIndex(tempIndex)];
            }
        }
    }
}

- (BOOL) isValidArrayIndex:(NSInteger)index {
    if (index >= 0 && index <= self.totalPageCount - 1) {
        return YES;
    }else{
        return NO;
    }
}

- (NSInteger) getValidNextPageIndexWithPageIndex:(NSInteger)currentPageIndex {
    if (currentPageIndex == -1) {
        return self.totalPageCount - 1;
    }else if (currentPageIndex == self.totalPageCount) {
        return 0;
    } else {
        return currentPageIndex;
    }
}

- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    scrollViewStartContentOffsetX = scrollView.contentOffset.x;
    [self.animationTimer pauseTimer];
}

- (void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self.animationTimer resumeTimerAfterTimeInterval:self.animationDuration];
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat contentOffsetX = scrollView.contentOffset.x;
    if (self.totalPageCount == 2) {
        if (scrollViewStartContentOffsetX < contentOffsetX) {
            UIView *tempView = (UIView *)[self.contentViews lastObject];
            tempView.frame = (CGRect){{2 * CGRectGetWidth(scrollView.frame), 0}, tempView.frame.size};
        } else if (scrollViewStartContentOffsetX > contentOffsetX) {
            UIView *tempView = (UIView *)[self.contentViews firstObject];
            tempView.frame = (CGRect){{0,0}, tempView.frame.size};
        }
    }
    
    if (contentOffsetX >= (2 * CGRectGetWidth(scrollView.frame))) {
        self.currentPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex + 1];
        [self configContentView];
    }
    
    if (contentOffsetX <= 0) {
        self.currentPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex - 1];
        [self configContentView];
    }
}

- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [scrollView setContentOffset:CGPointMake(CGRectGetWidth(scrollView.frame), 0) animated:YES];
}

- (void) longTapGestureAction:(UILongPressGestureRecognizer *)tapGesture {
    if (tapGesture.state == UIGestureRecognizerStateBegan) {
        [self.animationTimer pauseTimer];
    }
    
    if (tapGesture.state == UIGestureRecognizerStateEnded) {
        [self.animationTimer pauseTimer];
    }
}

- (void) animationTimerDidFired:(NSTimer *)timer {
    CGPoint newOffset = CGPointMake(self.scrollView.contentOffset.x + CGRectGetWidth(self.scrollView.frame), self.scrollView.contentOffset.y);
    [self.scrollView setContentOffset:newOffset animated:YES];
}

- (void) contentViewTapAction:(UITapGestureRecognizer *)tap {
    if (self.TapActionBlock) {
        self.TapActionBlock(self.currentPageIndex);
    }
}





@end
