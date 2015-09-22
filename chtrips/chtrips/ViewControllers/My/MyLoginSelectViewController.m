//
//  MyLoginSelectViewController.m
//  chtrips
//
//  Created by Hisoka on 15/9/18.
//  Copyright (c) 2015年 HSK.ltd. All rights reserved.
//

#import "MyLoginSelectViewController.h"

@interface MyLoginSelectViewController ()

@end

@implementation MyLoginSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupStyle];
}

- (void) setupStyle {
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *cancelBTN = [UIButton newAutoLayoutView];
    [self.view addSubview:cancelBTN];
    
    [cancelBTN autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.view withOffset:20];
    [cancelBTN autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view withOffset:-10];
    [cancelBTN autoSetDimensionsToSize:CGSizeMake(52, 52)];
//    cancelBTN.imageView.image = [UIImage imageNamed:@"loginCancel"];
    [cancelBTN setImage:[UIImage imageNamed:@"loginCancel"] forState:UIControlStateNormal];
    [cancelBTN addTarget:self action:@selector(backMyView) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *bgImg = [UIImageView newAutoLayoutView];
    [self.view addSubview:bgImg];
    
    [bgImg autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.view];
    [bgImg autoAlignAxis:ALAxisVertical toSameAxisOfView:self.view];
    [bgImg autoSetDimensionsToSize:CGSizeMake(159, 98)];
    bgImg.image = [UIImage imageNamed:@"loginBg"];
    
    UIButton *wechatBTN = [UIButton newAutoLayoutView];
    [self.view addSubview:wechatBTN];
    
    [wechatBTN autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.view withOffset:-100];
    [wechatBTN autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view withOffset:10];
    [wechatBTN autoSetDimensionsToSize:CGSizeMake(138, 50)];
    [wechatBTN setImage:[UIImage imageNamed:@"loginWeChat@2x.jpg"] forState:UIControlStateNormal];
    [wechatBTN addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *weiboBTN = [UIButton newAutoLayoutView];
    [self.view addSubview:weiboBTN];
    
    [weiboBTN autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:wechatBTN];
    [weiboBTN autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view withOffset:-10];
    [weiboBTN autoSetDimensionsToSize:CGSizeMake(138, 50)];
    [weiboBTN setImage:[UIImage imageNamed:@"loginWeibo@2x.jpg"] forState:UIControlStateNormal];
    [weiboBTN addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];

}

- (void) backMyView {
//    [self.navigationController popToRootViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
