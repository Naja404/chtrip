//
//  MyOrderViewController.m
//  chtrips
//
//  Created by Hisoka on 16/1/7.
//  Copyright © 2016年 HSK.ltd. All rights reserved.
//

#import "MyOrderViewController.h"
#import "CHTabBarControl.h"

@interface MyOrderViewController ()

@property (nonatomic, strong) UIView *tabBarV;

@end

@implementation MyOrderViewController

- (void)viewWillDisappear:(BOOL)animated {
    [[HttpManager instance] cancelAllOperations];
    [SVProgressHUD dismiss];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customizeBackItem];
    
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    
    [self setStyle];
}

- (void) viewDidAppear:(BOOL)animated {
}

#pragma mark - 初始化样式
- (void) setStyle {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = NSLocalizedString(@"TEXT_ALL_ORDER", nil);

    self.tabBarV = [UIView newAutoLayoutView];
    [self.view addSubview:_tabBarV];
    
    [_tabBarV autoPinToTopLayoutGuideOfViewController:self withInset:0];
    [_tabBarV autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view];
    [_tabBarV autoSetDimensionsToSize:CGSizeMake(ScreenWidth, 44)];
    
    CHTabBarControl *selectControl = [[CHTabBarControl alloc] initWithTitles:@[NSLocalizedString(@"TEXT_ALL_ORDER", nil),
                                                                               NSLocalizedString(@"TEXT_UNPAY", nil),
                                                                               NSLocalizedString(@"TEXT_UNDELIVERED", nil) ,
                                                                               NSLocalizedString(@"TEXT_UNCONFIRM", nil)]];
    [selectControl setFrame:CGRectMake(0, 0, ScreenWidth, 44)];
    [selectControl setIndexChangeBlock:^(NSUInteger index) {
        NSLog(@"my order select index %ld", (long)index);
    }];
    
    [_tabBarV addSubview:selectControl];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
