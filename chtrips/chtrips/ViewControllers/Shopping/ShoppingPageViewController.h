//
//  ShoppingPageViewController.h
//  chtrips
//
//  Created by Hisoka on 15/4/17.
//  Copyright (c) 2015年 HSK.ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ShoppingPageViewControllerDataSource;
@protocol ShoppingPageViewControllerDelegate;


@interface ShoppingPageViewController : UIViewController

@property (nonatomic, strong) NSMutableArray *viewControllerArr;
@property (nonatomic, strong) NSMutableArray *navTitleViewsArr;
@property (nonatomic, strong) NSMutableArray *navTitlesArr;

@property (nonatomic, strong) UIScrollView *navScrollView;
@property (nonatomic, assign) id<ShoppingPageViewControllerDataSource> dataSource;
@property (nonatomic, assign) id<ShoppingPageViewControllerDelegate> delegate;

- (void) loadPageViewController;
- (void) loadNavScrollView;

@end


@protocol ShoppingPageViewControllerDataSource <NSObject>

// 导航数
- (NSInteger) numOfPages;
// 导航宽度
- (float) widthOfNav;
// 导航标题
- (NSString *) titleOfNavAtIndex:(NSInteger)index;
// pageView
- (UIViewController *) viewPageController:(ShoppingPageViewController *)shoppingPageViewController contentViewControllerForNavAtIndex:(NSInteger)index;
// 是否循环
- (BOOL) canPageViewControllerRecycle;
// 是否动画切换
- (BOOL) canPageViewControllerAnimation;

@end


@protocol ShoppingPageViewControllerDelegate <NSObject>

@optional
- (UIViewController *)viewPageController:(ShoppingPageViewController *)shoppingPageViewController pageViewControllerChangeAtIndex:(NSInteger)index;

@end