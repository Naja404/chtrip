//
//  MyOrderViewController.m
//  chtrips
//
//  Created by Hisoka on 16/1/7.
//  Copyright © 2016年 HSK.ltd. All rights reserved.
//

#import "MyOrderViewController.h"

@interface MyOrderViewController ()

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

#pragma mark - 初始化样式
- (void) setStyle {
    self.view.backgroundColor = [UIColor whiteColor];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
