//
//  ShoppingDetailPictureTableViewCell.h
//  chtrips
//
//  Created by Hisoka on 15/4/22.
//  Copyright (c) 2015年 HSK.ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShoppingDetailPictureTableViewCell : UITableViewCell<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *imgScrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSArray *imgArr;

- (void) setupImgScrollView;
@end
