//
//  IntroViewController.m
//  chtrips
//
//  Created by Hisoka on 16/1/28.
//  Copyright © 2016年 HSK.ltd. All rights reserved.
//

#import "IntroViewController.h"

@interface IntroViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *introV;
@property (nonatomic, strong) NSArray *imgArr;

@end

@implementation IntroViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setStyle];
}

- (void) setStyle {
    self.navigationController.navigationBarHidden = YES;

    self.imgArr = @[@"bgIntro1", @"bgIntro2"];
    
    self.introV = [UIScrollView newAutoLayoutView];
    [self.view addSubview:_introV];
    
    [_introV autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.view withOffset:-20];
    [_introV autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view];
    [_introV autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view];
    [_introV autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view];
    
    
    
    for (int i = 0; i < [_imgArr count]; i++) {
        UIView *bgView = [[UIView alloc] init];
        bgView.frame = CGRectMake(ScreenWidth * i, 0, ScreenWidth, ScreenHeight);
        
        UIImageView *bgImg = [UIImageView newAutoLayoutView];
        [bgView addSubview:bgImg];
        
        [bgImg autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:bgView];
        [bgImg autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:bgView];
        [bgImg autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:bgView];
        [bgImg autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:bgView];
        
        if (i + 1 == [_imgArr count]) {
            UIButton *popBTN = [UIButton newAutoLayoutView];
            [bgView addSubview:popBTN];
            
            [popBTN autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:bgView];
            [popBTN autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:bgView];
            [popBTN autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:bgView];
            [popBTN autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:bgView];
            [popBTN addTarget:self action:@selector(dismissView) forControlEvents:UIControlEventTouchUpInside];
        }
        
        bgImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", [_imgArr objectAtIndex:i]]];
        
        [_introV addSubview:bgView];
    }
    
    _introV.contentSize = CGSizeMake(ScreenWidth * [_imgArr count], ScreenHeight);
    _introV.contentOffset = CGPointMake(CGRectGetWidth(_introV.frame), 0);
    _introV.pagingEnabled = YES;
    _introV.showsHorizontalScrollIndicator = NO;
    _introV.showsVerticalScrollIndicator = NO;
    _introV.delegate = self;
}

- (void) dismissView {
    
    [[TMCache sharedCache] setObject:@"YES" forKey:@"ver097"];
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
