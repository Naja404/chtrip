//
//  CHAutoSlideScrollView.h
//  chtrips
//
//  Created by Hisoka on 15/6/11.
//  Copyright (c) 2015年 HSK.ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CHAutoSlideScrollView : UIView

@property (nonatomic, readonly) UIScrollView *scrollView;

- (id)initWithFrame:(CGRect)frame animationDuration:(NSTimeInterval)animationDuration;

@property (nonatomic, copy) NSInteger (^totalPagesCount)(void);
// 获取第pageIndex个位置的contentView
@property (nonatomic, copy) UIView *(^fetchContentViewAtIndex)(NSInteger pageIndex);
// 点击scrollview 停止播放
@property (nonatomic, copy) void (^TapActionBlock)(NSInteger pageIndex);

@end
