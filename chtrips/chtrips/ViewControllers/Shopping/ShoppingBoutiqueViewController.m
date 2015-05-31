//
//  ShoppingBoutiqueViewController.m
//  chtrips
//
//  Created by Hisoka on 15/4/17.
//  Copyright (c) 2015年 HSK.ltd. All rights reserved.
//

#import "ShoppingBoutiqueViewController.h"

@interface ShoppingBoutiqueViewController ()

@end

@implementation ShoppingBoutiqueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.view.backgroundColor = [UIColor redColor];
    self.textLB = [UILabel newAutoLayoutView];
    [self.view addSubview:_textLB];
    
    [_textLB autoAlignAxis:ALAxisVertical toSameAxisOfView:self.view];
    [_textLB autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.view];
    [_textLB autoSetDimensionsToSize:CGSizeMake(50, 20)];
    _textLB.text = self.textStr;

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
