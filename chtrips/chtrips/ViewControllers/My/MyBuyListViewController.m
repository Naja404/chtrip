//
//  MyBuyListViewController.m
//  chtrips
//
//  Created by Hisoka on 15/5/31.
//  Copyright (c) 2015年 HSK.ltd. All rights reserved.
//

#import "MyBuyListViewController.h"
#import "MyBuyListTableViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "ShoppingPopularityDetailViewController.h"

static NSString * const MY_BUYLIST_CELL = @"MyBuyListCell";


@interface MyBuyListViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *buyListTV;
@property (nonatomic, strong) NSMutableArray *buyListData;
@property (nonatomic, strong) UILabel *priceZH;
@property (nonatomic, strong) UILabel *priceJP;

@end

@implementation MyBuyListViewController

- (void) viewWillAppear:(BOOL)animated{
    
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getBuyList];
    [self setupBuyListTV];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 设置购物清单tableview
- (void) setupBuyListTV {
    self.view.backgroundColor = [UIColor whiteColor];
    

    self.buyListTV = [UITableView newAutoLayoutView];
    [self.view addSubview:_buyListTV];
    
    [_buyListTV autoPinToTopLayoutGuideOfViewController:self withInset:-60];
    [_buyListTV autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view];
    [_buyListTV autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view];
    [_buyListTV autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view];
    
    _buyListTV.dataSource = self;
    _buyListTV.delegate = self;
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [_buyListTV addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    
    [self.buyListTV registerClass:[MyBuyListTableViewCell class] forCellReuseIdentifier:MY_BUYLIST_CELL];
    
    // 设置总计栏
    UIView *totalBar = [UIView newAutoLayoutView];
    
    [self.view addSubview:totalBar];
    
    [totalBar autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view];
    [totalBar autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view];
    [totalBar autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view];
    [totalBar autoSetDimensionsToSize:CGSizeMake(ScreenWidth, 80)];
    
    totalBar.backgroundColor = [UIColor blackColor];
    
    UILabel *totalLB = [UILabel newAutoLayoutView];
    [totalBar addSubview:totalLB];
    
    [totalLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:totalBar];
    [totalLB autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:totalBar];
    [totalLB autoSetDimensionsToSize:CGSizeMake(40, 14)];
    totalLB.backgroundColor = [UIColor whiteColor];
    totalLB.text = @"合计:";
    
    self.priceZH = [UILabel newAutoLayoutView];
    [totalBar addSubview:_priceZH];
    
    [_priceZH autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:totalLB];
    [_priceZH autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:totalBar];
    [_priceZH autoSetDimensionsToSize:CGSizeMake(80, 14)];
    _priceZH.backgroundColor = [UIColor whiteColor];
    _priceZH.text = @"0.00";
    
    self.priceJP = [UILabel newAutoLayoutView];
    [totalBar addSubview:_priceJP];
    
    [_priceJP autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_priceZH];
    [_priceJP autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:totalBar];
    [_priceJP autoSetDimensionsToSize:CGSizeMake(100, 14)];
    _priceJP.backgroundColor = [UIColor whiteColor];
    _priceJP.text = @"0.00";
    
}

#pragma mark 下拉刷新
- (void)refresh:(UIRefreshControl *)control {
    [control endRefreshing];
    [self.buyListTV reloadData];
}

#pragma mark 获取扫货清单数据
- (void) getBuyList{
    
    NSMutableDictionary *paramter = [NSMutableDictionary dictionary];
    [paramter setObject:[CHSSID SSID] forKey:@"ssid"];
    
    [[HttpManager instance] requestWithMethod:@"User/getBuyList"
                                   parameters:paramter
                                      success:^(NSDictionary *result) {
                                          self.buyListData = [[result objectForKey:@"data"] objectForKey:@"list"];
                                          self.priceZH.text = [NSString stringWithFormat:@"¥ %@", [[result objectForKey:@"data"] objectForKey:@"price_zh_total"]];
                                          self.priceJP.text = [NSString stringWithFormat:@"円 %@", [[result objectForKey:@"data"] objectForKey:@"price_jp_total"]];
                                      }
                                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                          
                                      }];
}


- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.buyListData count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyBuyListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MY_BUYLIST_CELL forIndexPath:indexPath];
    
    NSDictionary *cellData = [[NSDictionary alloc] initWithDictionary:[self.buyListData objectAtIndex:indexPath.row]];
    
    NSURL *imageUrl = [NSURL URLWithString:[cellData objectForKey:@"thumb"]];

    [cell.productImage setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"productDemo3"]];
    cell.titleZHLB.text = [cellData objectForKey:@"title_zh"];
    cell.titleJPLB.text = [cellData objectForKey:@"title_jp"];
    cell.priceZHLB.text = [cellData objectForKey:@"price_zh"];
    cell.priceJPLB.text = [cellData objectForKey:@"price_jp"];
    cell.summaryLB.text = [cellData objectForKey:@"summary"];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    
//    ShoppingPopularityDetailViewController *detailPopulaVC = [[ShoppingPopularityDetailViewController alloc] init];
//    detailPopulaVC.navigationItem.title = [[self.buyListData objectAtIndex:indexPath.row] objectForKey:@"title_zh"];
//    detailPopulaVC.dicData = [[NSDictionary alloc] initWithDictionary:[self.buyListData objectAtIndex:indexPath.row]];
//    
//    [self.navigationController pushViewController:detailPopulaVC animated:YES];
}


@end
