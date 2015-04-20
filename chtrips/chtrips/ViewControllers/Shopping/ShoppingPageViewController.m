//
//  ShoppingPageViewController.m
//  chtrips
//
//  Created by Hisoka on 15/4/17.
//  Copyright (c) 2015年 HSK.ltd. All rights reserved.
//

#import "ShoppingPageViewController.h"

#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define navHeight 80.0

@interface ShoppingPageViewController ()<UIPageViewControllerDataSource, UIPageViewControllerDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, assign) NSInteger navCount;
@property (nonatomic, assign) float navWidth;
@property (nonatomic, assign) NSInteger currentVCIndex;
@property (nonatomic, assign) BOOL isRecycle;
@property (nonatomic, assign) BOOL isPageChangeWithAnimation;

@end

@implementation ShoppingPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self loadNavScrollView];
    [self loadPageViewController];
    [self switchToViewControllerAtIndex:0];
}

#pragma mark 初始化数据
- (void) initData {
    self.currentVCIndex = 0;
    self.navTitleViewsArr = [NSMutableArray array];
    self.viewControllerArr = [NSMutableArray array];
    self.navCount = self.navTitlesArr.count;
    self.navWidth = [self.dataSource widthOfNav];
    self.isRecycle = [self.dataSource canPageViewControllerRecycle];
    self.isPageChangeWithAnimation = [self.dataSource canPageViewControllerAnimation];
}

#pragma mark 载入导航scroll
- (void) loadNavScrollView {
    self.navScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, navHeight, ScreenWidth, 20)];
    self.navScrollView.delegate = self;
    self.navScrollView.backgroundColor = [UIColor clearColor];
    self.navScrollView.showsHorizontalScrollIndicator = NO;
    self.navScrollView.contentSize = CGSizeMake((self.navCount -1)*self.navWidth+ScreenWidth, 20);
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.navigationItem.titleView = self.navScrollView;
    
    for (NSInteger i = 0; i < self.navCount; i++) {
        UILabel *navTitLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2+self.navWidth*(i-0.5), 0, self.navWidth, 20)];
        navTitLab.backgroundColor = [UIColor clearColor];
        navTitLab.text = [self.navTitlesArr objectAtIndexedSubscript:i];
        navTitLab.font = [UIFont systemFontOfSize:16];
        navTitLab.textColor = [UIColor blackColor];
        navTitLab.textAlignment = NSTextAlignmentCenter;
        navTitLab.userInteractionEnabled = YES;
        [self.navScrollView addSubview:navTitLab];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tagGesture:)];
        tap.numberOfTapsRequired = 1;
        [navTitLab addGestureRecognizer:tap];
        
        [self.navTitleViewsArr addObject:navTitLab];
    }
}

- (void) loadPageViewController {
    for (NSInteger i = 0; i < self.navCount; i++) {
        UIViewController *vc = [self.dataSource viewPageController:self contentViewControllerForNavAtIndex:i];
        [self.viewControllerArr addObject:vc];
    }
    
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    [self addChildViewController:self.pageViewController];
    
    self.pageViewController.dataSource = self;
    self.pageViewController.delegate = self;
    
    self.contentView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.contentView = self.pageViewController.view;
    [self.view addSubview:self.contentView];
}

- (void)switchToViewControllerAtIndex:(NSInteger)index {
    [self navTitSelectedAtIndex:index];
    [self transitionToViewControllerAtIndex:index];
}

- (void)navTitSelectedAtIndex:(NSInteger)index {
    CGPoint point = CGPointMake(index*self.navWidth, 0);
    
    for (NSInteger i = 0; i < self.navCount; i++) {
        UILabel *titLab = [self.navTitleViewsArr objectAtIndex:i];
        titLab.textColor = [UIColor blackColor];
        titLab.font = [UIFont systemFontOfSize:16];
    }
    
    UILabel *titLab = [self.navTitleViewsArr objectAtIndex:index];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.navScrollView.contentOffset = point;
        titLab.textColor = [UIColor redColor];
        titLab.font = [UIFont systemFontOfSize:18];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)transitionToViewControllerAtIndex:(NSInteger)index {
    UIViewController *viewController = [self viewControllerAtIndex:index];
    
    if (!viewController) {
        viewController = [[UIViewController alloc] init];
        viewController.view = [[UIView alloc] init];
        viewController.view.backgroundColor = [UIColor redColor];
    }
    
    if (index == self.currentVCIndex) {
        [self.pageViewController setViewControllers:@[viewController]
                                          direction:UIPageViewControllerNavigationDirectionForward
                                           animated:NO
                                         completion:^(BOOL finished) {
                                         }];
    } else {
        NSInteger direction = 0;
        if (index == self.viewControllerArr.count - 1 && self.currentVCIndex == 0) {
            direction = UIPageViewControllerNavigationDirectionReverse;
        } else if (index == 0 && self.currentVCIndex == self.viewControllerArr.count - 1) {
            direction = UIPageViewControllerNavigationDirectionForward;
        } else if (index < self.currentVCIndex) {
            direction = UIPageViewControllerNavigationDirectionReverse;
        } else {
            direction = UIPageViewControllerNavigationDirectionForward;
        }
        
        [self.pageViewController setViewControllers:@[viewController]
                                          direction:direction
                                           animated:self.isPageChangeWithAnimation
                                         completion:^(BOOL completed){// none
                                         }];
    }
    
    self.currentVCIndex = index;
}


- (NSInteger)indexOfViewController:(UIViewController *)viewController {
    NSInteger index = [self.viewControllerArr indexOfObject:viewController];
    return index;
}

- (UIViewController *)viewControllerAtIndex:(NSInteger)index {
    UIViewController *vc = [self.viewControllerArr objectAtIndex:index];
    return vc;
}

- (NSInteger)indexOfNavTit:(UILabel *)lab {
    NSInteger index = [self.navTitleViewsArr indexOfObject:lab];
    return index;
}

#pragma mark - UIGesture Method
- (void)tagGesture:(UITapGestureRecognizer *)gesture {
    UILabel *navTitLab = (UILabel *)gesture.view;
    NSInteger index = [self indexOfNavTit:navTitLab];
    
    if (index != self.currentVCIndex) {
        [self switchToViewControllerAtIndex:index];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    CGPoint point = scrollView.contentOffset;
    
    float displace = point.x+self.navWidth/2-1.0;
    NSInteger navIndex = displace / self.navWidth;
    NSLog(@"displace--->%f/%ld",displace, (long)navIndex);
    
    //    [self switchToViewControllerAtIndex:navIndex];
}

#pragma mark - UIPageViewControllerDataSource
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSInteger index = [self indexOfViewController:viewController];
    if (index == 0) {
        if (self.isRecycle) {
            index = self.navCount - 1;
        } else {
            return nil;
        }
    } else {
        index--;
    }
    
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSInteger index = [self indexOfViewController:viewController];
    if (index == self.navCount - 1) {
        if (self.isRecycle) {
            index = 0;
        } else {
            return nil;
        }
    } else {
        index++;
    }
    return [self viewControllerAtIndex:index];
}

#pragma mark - UIPageViewControllerDelegate
- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers {
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {
    UIViewController *viewController = self.pageViewController.viewControllers[0];
    
    NSUInteger index = [self indexOfViewController:viewController];
    [self navTitSelectedAtIndex:index];
    
    self.currentVCIndex = index;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
