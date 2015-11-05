//
//  ShoppingPopularityViewController.m
//  chtrips
//
//  Created by Hisoka on 15/4/17.
//  Copyright (c) 2015年 HSK.ltd. All rights reserved.
//

#import "ShoppingPopularityViewController.h"
#import "ShoppingPopularityTableViewCell.h"
#import "ShoppingPopularityDetailViewController.h"
#import "AFNetworking.h"

static NSString * const SHOP_POPULA_CELL = @"ShoppingPopulaCell";

@interface ShoppingPopularityViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *popularityTV;
@property (nonatomic, strong) NSMutableArray *tableData;

@end

@implementation ShoppingPopularityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getProductList];
    [self setupPopulaTV];
    
}

#pragma mark 获取产品列表
- (void) getProductList {
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:@"http://api.atniwo.com/"]];
    [manager GET:@"Product/proList" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON is %@ ", responseObject);
        self.tableData = [[NSMutableArray alloc] initWithArray:[[responseObject objectForKey:@"data"] objectForKey:@"proList"]];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error is %@ ", error);
    }];
}

#pragma mark 设置人气列表
- (void) setupPopulaTV {
    self.popularityTV = [UITableView newAutoLayoutView];
    [self.view addSubview:_popularityTV];
    
    [_popularityTV autoPinToTopLayoutGuideOfViewController:self withInset:0];
    [_popularityTV autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view];
    [_popularityTV autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view];
    [_popularityTV autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view withOffset:-48.0];
    
    _popularityTV.dataSource = self;
    _popularityTV.delegate = self;
    
//    [self makeTableViewData];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [_popularityTV addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];

    [self.popularityTV registerClass:[ShoppingPopularityTableViewCell class] forCellReuseIdentifier:SHOP_POPULA_CELL];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.tableData count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ShoppingPopularityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SHOP_POPULA_CELL forIndexPath:indexPath];
    
//    NSArray *cellData = [[NSArray alloc] initWithArray:[self.tableData objectAtIndex:indexPath.row]];
    NSDictionary *cellData = [[NSDictionary alloc] initWithDictionary:[self.tableData objectAtIndex:indexPath.row]];
    NSURL *imageUrl = [NSURL URLWithString:[cellData objectForKey:@"thumb"]];
//    cell.productImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", [cellData objectForKey:@"image"]]];
    [cell.productImage setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"productDemo3"]];
    cell.titleZHLB.text = [cellData objectForKey:@"title_zh"];
    cell.titleJPLB.text = [cellData objectForKey:@"title_jp"];
    cell.priceZHLB.text = [cellData objectForKey:@"price_zh"];
    cell.priceJPLB.text = [cellData objectForKey:@"price_jp"];
    cell.summaryLB.text = [cellData objectForKey:@"summary"];
    
    return cell;
}

- (void) makeTableViewData {
    NSDictionary *dic1 = [[NSDictionary alloc] initWithObjectsAndKeys:@"尼康 D7200", @"title_zh",
                                                                    @"買い物リスト", @"title_jp",
                                                                    @"productDemo1", @"image",
                                                                    @"999.00", @"price_zh",
                                                                    @"2000.12", @"price_jp",
                                                                    @"人気世界最小相机", @"summary",
                          nil];
    NSDictionary *dic2 = [[NSDictionary alloc] initWithObjectsAndKeys:@"游戏机", @"title_zh",
                          @"アクティビティ", @"title_jp",
                          @"productDemo2", @"image",
                          @"123.00", @"price_zh",
                          @"656.89", @"price_jp",
                          @"買い物買い物買い", @"summary",
                          nil];
    NSDictionary *dic3 = [[NSDictionary alloc] initWithObjectsAndKeys:@"水果机", @"title_zh",
                          @"アクティビティ", @"title_jp",
                          @"productDemo3", @"image",
                          @"292.22", @"price_zh",
                          @"1440.89", @"price_jp",
                          @"世界最小水果", @"summary",
                          nil];

    self.tableData = [[NSMutableArray alloc] initWithObjects:dic1, dic2, dic3, nil];
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ShoppingPopularityDetailViewController *detailPopulaVC = [[ShoppingPopularityDetailViewController alloc] init];
    detailPopulaVC.navigationItem.title = [[self.tableData objectAtIndex:indexPath.row] objectForKey:@"title_zh"];
    detailPopulaVC.dicData = [[NSDictionary alloc] initWithDictionary:[self.tableData objectAtIndex:indexPath.row]];
    
    [self.navigationController pushViewController:detailPopulaVC animated:YES];
}

- (void)refresh:(UIRefreshControl *)control {
    [control endRefreshing];
    [self.popularityTV reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
