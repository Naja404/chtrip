//
//  ShoppingDGViewController.m
//  chtrips
//
//  Created by Hisoka on 15/6/9.
//  Copyright (c) 2015年 HSK.ltd. All rights reserved.
//

#import "ShoppingDGViewController.h"

@interface ShoppingDGViewController ()
@property (nonatomic, strong) UISegmentedControl *shopSegmented;

@end

@implementation ShoppingDGViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSegmentedControl];
    // Do any additional setup after loading the view.
}

- (void) setupSegmentedControl {
    self.shopSegmented = [[UISegmentedControl alloc] initWithItems:@[@"人气商品",@"商家"]];
    _shopSegmented.frame = CGRectMake(20.0, 20.0, 150, 30);
    _shopSegmented.selectedSegmentIndex = 1;
    self.navigationItem.titleView = _shopSegmented;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
