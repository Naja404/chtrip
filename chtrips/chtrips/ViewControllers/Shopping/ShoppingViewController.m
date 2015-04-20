//
//  ShoppingViewController.m
//  chtrips
//
//  Created by Hisoka on 15/3/30.
//  Copyright (c) 2015年 HSK.ltd. All rights reserved.
//

#import "ShoppingViewController.h"
#import "ShoppingPopularityViewController.h"
#import "ShoppingBoutiqueViewController.h"

@interface ShoppingViewController ()<ShoppingPageViewControllerDataSource, ShoppingPageViewControllerDelegate>

@end

@implementation ShoppingViewController

- (void) viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationItem.title = @"Shopping";
}

- (instancetype) init {
    self = [super init];
    
    if (self) {
        NSArray *titleArr = @[@"人气", @"特惠", @"精品", @"分类", @"活动", @"商圈"];
        self.navTitlesArr = [NSMutableArray arrayWithArray:titleArr];
        self.dataSource = self;
        self.delegate = self;
    }
    
    return self;
}

- (NSInteger) numOfPages {
    return self.navTitlesArr.count;
}

- (float) widthOfNav {
    return 60.0;
}

- (NSString *) titleOfNavAtIndex:(NSInteger)index {
    return [self.navTitlesArr objectAtIndex:index];
}

- (UIViewController *) viewPageController:(ShoppingPageViewController *)shoppingPageViewController contentViewControllerForNavAtIndex:(NSInteger)index {
    
    if (index == 0) {
        ShoppingPopularityViewController *pageVC = [[ShoppingPopularityViewController alloc] init];
        return pageVC;
    }else{
        ShoppingBoutiqueViewController *pageVC = [[ShoppingBoutiqueViewController alloc] init];
        pageVC.textStr = [self.navTitlesArr objectAtIndex:index];
        return pageVC;
    }
}

- (BOOL) canPageViewControllerRecycle {
    return NO;
}

- (BOOL) canPageViewControllerAnimation {
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
