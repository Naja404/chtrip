//
//  ShoppingPopularityDetailViewController.m
//  chtrips
//
//  Created by Hisoka on 15/4/18.
//  Copyright (c) 2015年 HSK.ltd. All rights reserved.
//

#import "ShoppingPopularityDetailViewController.h"

@interface ShoppingPopularityDetailViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *detailScrollView;

@end

@implementation ShoppingPopularityDetailViewController

- (void) viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupDetailStyle];
    
    // Do any additional setup after loading the view.
}

- (void) setupDetailStyle {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply
                                                                                           target:self
                                                                                           action:@selector(navShareClick)];
    [self setupDetailScrollView];
    [self setupBuyBar];
    
}

- (void) setupDetailScrollView {
    UIView *backgroundView = [UIView newAutoLayoutView];
    [self.view addSubview:backgroundView];
    
    [backgroundView autoPinToTopLayoutGuideOfViewController:self withInset:0];
    [backgroundView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view];
    [backgroundView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view];
    [backgroundView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view withOffset:-40];
    
    backgroundView.backgroundColor = [UIColor blackColor];
    
//    self.detailScrollView = [];
}

- (void) setupBuyBar {
    UIView *buyBar = [UIView newAutoLayoutView];
    
    [self.view addSubview:buyBar];
    
//    [buyBar autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view];
    [buyBar autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view];
    [buyBar autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view];
    [buyBar autoSetDimensionsToSize:CGSizeMake(self.view.frame.size.width, 40)];
    buyBar.backgroundColor = [UIColor whiteColor];
    
    UIButton *shopCartBTN = [UIButton newAutoLayoutView];
    [buyBar addSubview:shopCartBTN];
    [shopCartBTN autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:buyBar withOffset:-10];
    [shopCartBTN autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:buyBar withOffset:5];
    [shopCartBTN autoSetDimensionsToSize:CGSizeMake(120, 30)];
    [shopCartBTN setTitle:@"加入扫货清单" forState:UIControlStateNormal];
    shopCartBTN.backgroundColor = [UIColor redColor];

    UIImageView *priceJPImg = [UIImageView newAutoLayoutView];
    [buyBar addSubview:priceJPImg];
    [priceJPImg autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:buyBar withOffset:5];
    [priceJPImg autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:buyBar withOffset:10];
    [priceJPImg autoSetDimensionsToSize:CGSizeMake(16, 16)];
    priceJPImg.image = [UIImage imageNamed:@"japanFlagIcon"];
    
    UILabel *priceJPLB = [UILabel newAutoLayoutView];
    [buyBar addSubview:priceJPLB];
    [priceJPLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:priceJPImg withOffset:2];
    [priceJPLB autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:buyBar withOffset:8];
    [priceJPLB autoSetDimensionsToSize:CGSizeMake(70, 20)];
    priceJPLB.text = @"1000.29";
    priceJPLB.font = [UIFont fontWithName:@"Georgia-Italic" size:15];

    
    UIImageView *priceZHImg = [UIImageView newAutoLayoutView];
    [buyBar addSubview:priceZHImg];
    [priceZHImg autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:priceJPLB withOffset:10];
    [priceZHImg autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:buyBar withOffset:10];
    [priceZHImg autoSetDimensionsToSize:CGSizeMake(16, 16)];
    priceZHImg.image = [UIImage imageNamed:@"chinaFlagIcon"];
    
    UILabel *priceZHLB = [UILabel newAutoLayoutView];
    [buyBar addSubview:priceZHLB];
    [priceZHLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:priceZHImg withOffset:2];
    [priceZHLB autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:buyBar withOffset:8];
    [priceZHLB autoSetDimensionsToSize:CGSizeMake(100, 20)];
    priceZHLB.text = @"966.12";
    priceZHLB.font = [UIFont fontWithName:@"Georgia-Italic" size:15];

}

#pragma mark 分享按钮
- (void) navShareClick {
    NSLog(@"share btn click");
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
