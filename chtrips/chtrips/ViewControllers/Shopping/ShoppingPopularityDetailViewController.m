//
//  ShoppingPopularityDetailViewController.m
//  chtrips
//
//  Created by Hisoka on 15/4/18.
//  Copyright (c) 2015年 HSK.ltd. All rights reserved.
//

#import "ShoppingPopularityDetailViewController.h"
#import "ShoppingDetailTitleTableViewCell.h"
#import "ShoppingDetailPictureTableViewCell.h"

static NSString * const SHOP_DETAIL_TITLE_CELL = @"shopDetailTitleCell";
static NSString * const SHOP_DETAIL_IMAGE_CELL = @"shopDetailImageCell";

@interface ShoppingPopularityDetailViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *populaDetailTV;

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
    [self setupDetailTV];
    [self setupBuyBar];
    
}

- (void) setupDetailTV {
    self.populaDetailTV = [UITableView newAutoLayoutView];
    [self.view addSubview:_populaDetailTV];
    
    [_populaDetailTV autoPinToTopLayoutGuideOfViewController:self withInset:-65.0];
    [_populaDetailTV autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view];
    [_populaDetailTV autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view];
    [_populaDetailTV autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view];
    
    _populaDetailTV.dataSource = self;
    _populaDetailTV.delegate = self;
    _populaDetailTV.separatorStyle = UITableViewCellAccessoryNone;
    _populaDetailTV.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    
    [self.populaDetailTV registerClass:[ShoppingDetailTitleTableViewCell class] forCellReuseIdentifier:SHOP_DETAIL_TITLE_CELL];
    [self.populaDetailTV registerClass:[ShoppingDetailPictureTableViewCell class] forCellReuseIdentifier:SHOP_DETAIL_IMAGE_CELL];
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

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 200;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row == 0) {
        ShoppingDetailPictureTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SHOP_DETAIL_IMAGE_CELL forIndexPath:indexPath];
        return cell;
    }else{
        ShoppingDetailTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SHOP_DETAIL_TITLE_CELL forIndexPath:indexPath];
        
        cell.titleZHLB.text = [self.dicData objectForKey:@"title_zh"];
        cell.titleJPLB.text = [self.dicData objectForKey:@"title_jp"];
        cell.summaryLB.text = [self.dicData objectForKey:@"summary"];
        return cell;
    }
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
