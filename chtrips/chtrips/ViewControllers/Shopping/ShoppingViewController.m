//
//  ShoppingViewController.m
//  chtrips
//
//  Created by Hisoka on 15/3/30.
//  Copyright (c) 2015年 HSK.ltd. All rights reserved.
//

#import "ShoppingViewController.h"
#import "CHMenuPicker.h"

@interface ShoppingViewController ()<CHMenuPickerDelegate>

@property (nonatomic, strong) CHMenuPicker *menuScroll;

@end

@implementation ShoppingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Shopping";
    [self setupScrollView];
}

#pragma mark 初始化样式
- (void) setupScrollView {
    
    self.menuScroll = [[CHMenuPicker alloc] init];
    self.automaticallyAdjustsScrollViewInsets = NO;

    self.menuScroll.menuPickerView.frame = CGRectMake(0, 60, [UIScreen mainScreen].bounds.size.width, 40);
    self.menuScroll.menuPickerView.backgroundColor = [UIColor grayColor];
    self.menuScroll.delegate = self;
    
    
    [self.view addSubview:self.menuScroll.menuPickerView];
    
}

- (void) CHMenuPicker:(CHMenuPicker *)menu didSelectMenu:(unsigned int)menuNum {
    NSLog(@"select menu item is %d", menuNum);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
