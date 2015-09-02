//
//  ShoppingDGViewController.m
//  chtrips
//
//  Created by Hisoka on 15/6/9.
//  Copyright (c) 2015年 HSK.ltd. All rights reserved.
//

#import "ShoppingDGViewController.h"
#import "DOPDropDownMenu.h"
#import "ShoppingDGTableViewCell.h"
#import "ShoppingPopularityTableViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "ShoppingDGDetailViewController.h"

static NSString * const SHOP_CELL = @"ShoppingDGCell";
static NSString * const SHOP_POP_CELL = @"ShoppingPOPCell";

@interface ShoppingDGViewController () <DOPDropDownMenuDataSource, DOPDropDownMenuDelegate, UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UISegmentedControl *shopSegmented;
@property (nonatomic, strong) NSArray *classifys;
@property (nonatomic, strong) NSArray *cates;
@property (nonatomic, strong) NSArray *movices;
@property (nonatomic, strong) NSArray *hostels;
@property (nonatomic, strong) NSArray *areas;
@property (nonatomic, strong) NSArray *sorts;

@property (nonatomic, strong) UITableView *shopTV;
@property (nonatomic, strong) NSMutableArray *shopData;
@property (nonatomic, strong) UIRefreshControl *refreshTV;

@end

@implementation ShoppingDGViewController

- (void) viewWillAppear:(BOOL)animated {
    self.hidesBottomBarWhenPushed = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSegmentedControl];
    [self setupDOPMenu];
    
    [self setupShopList];
    [self getProductList];

    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void) setupSegmentedControl {
    self.shopSegmented = [[UISegmentedControl alloc] initWithItems:@[@"人气商品",@"商家"]];
    _shopSegmented.frame = CGRectMake(20.0, 20.0, 150, 30);
    _shopSegmented.selectedSegmentIndex = 0;
    _shopSegmented.tintColor = [UIColor redColor];
    [_shopSegmented addTarget:self action:@selector(shopSegmentAction:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = _shopSegmented;
}

- (void) shopSegmentAction:(id)sender {
    int selectIndex = _shopSegmented.selectedSegmentIndex;
    
    [self.shopData removeAllObjects];
    
    if (selectIndex == 1) {
        [self getShopList];
    }else{
        [self getProductList];
    }
}

- (void) setupDOPMenu {
    // 数据
    self.classifys = @[@"类别",@"小家电",@"大家电",@"宅"];
    self.cates = @[@"手机",@"手环",@"鼠标键盘",@"电脑",@"音响",@"耳机"];
    self.movices = @[@"苹果",@"三星",@"HTC"];
    self.hostels = @[@"PSP",@"xbox",@"手办",@"口袋书",@"初音"];
    self.areas = @[@"品牌",@"尼康",@"索尼",@"万代",@"3A",@"HotToys"];
    self.sorts = @[@"价格",@"从高到底",@"从低到高"];
    
    // 添加下拉菜单
    DOPDropDownMenu *menu = [[DOPDropDownMenu alloc] initWithOrigin:CGPointMake(0, 64) andHeight:44];
    menu.delegate = self;
    menu.dataSource = self;
    [self.view addSubview:menu];
    
    [menu selectDefalutIndexPath];
}

#pragma mark DOPMenu

- (NSInteger)numberOfColumnsInMenu:(DOPDropDownMenu *)menu
{
    return 3;
}

- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column
{
    if (column == 0) {
        return self.classifys.count;
    }else if (column == 1){
        return self.areas.count;
    }else {
        return self.sorts.count;
    }
}

- (NSString *)menu:(DOPDropDownMenu *)menu titleForRowAtIndexPath:(DOPIndexPath *)indexPath
{
    if (indexPath.column == 0) {
        return self.classifys[indexPath.row];
    } else if (indexPath.column == 1){
        return self.areas[indexPath.row];
    } else {
        return self.sorts[indexPath.row];
    }
}

- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfItemsInRow:(NSInteger)row column:(NSInteger)column
{
    if (column == 0) {
        if (row == 0) {
           return self.cates.count;
        } else if (row == 2){
            return self.movices.count;
        } else if (row == 3){
            return self.hostels.count;
        }
    }
    return 0;
}

- (NSString *)menu:(DOPDropDownMenu *)menu titleForItemsInRowAtIndexPath:(DOPIndexPath *)indexPath
{
    if (indexPath.column == 0) {
        if (indexPath.row == 0) {
            return self.cates[indexPath.item];
        } else if (indexPath.row == 2){
            return self.movices[indexPath.item];
        } else if (indexPath.row == 3){
            return self.hostels[indexPath.item];
        }
    }
    return nil;
}

- (void)menu:(DOPDropDownMenu *)menu didSelectRowAtIndexPath:(DOPIndexPath *)indexPath
{
    if (indexPath.item >= 0) {
    }else {
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 获取产品列表
- (void) getProductList {
    [SVProgressHUD show];
    NSMutableDictionary *paramter = [NSMutableDictionary dictionary];
//    [paramter setObject:[CHSSID SSID] forKey:@"ssid"];
    [paramter setObject:[NSString stringWithFormat:@"%@", [CHSSID SSID]] forKey:@"ssid"];
    
    [[HttpManager instance] requestWithMethod:@"Product/proList"
                                   parameters:paramter
                                      success:^(NSDictionary *result) {
                                          NSLog(@"Productlist data is %@", result);
                                          self.shopData = [[NSMutableArray alloc] initWithArray:[[result objectForKey:@"data"] objectForKey:@"proList"]];
                                          [self.shopTV reloadData];
                                          [SVProgressHUD dismiss];
                                      }
                                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                          [SVProgressHUD dismiss];
                                      }];

}

#pragma mark 获取商家列表
- (void) getShopList {
    
    [SVProgressHUD show];
    
    NSMutableDictionary *paramter = [NSMutableDictionary dictionary];
//    [paramter setObject:[CHSSID SSID] forKey:@"ssid"];
    [paramter setObject:[NSString stringWithFormat:@"%@", [CHSSID SSID]] forKey:@"ssid"];
    [paramter setObject:@"1" forKey:@"shopType"];
    
    [[HttpManager instance] requestWithMethod:@"Product/shopList"
                                   parameters:paramter
                                      success:^(NSDictionary *result) {
                                          NSLog(@"shoplist data is %@", result);
                                          self.shopData = [[NSMutableArray alloc] initWithArray:[[result objectForKey:@"data"] objectForKey:@"shopList"]];
                                          [self.shopTV reloadData];
                                          [SVProgressHUD dismiss];
                                          
                                      }
                                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                          [SVProgressHUD dismiss];
                                          
                                      }];

}

#pragma mark shop tableview
- (void) setupShopList {
    self.shopTV = [UITableView newAutoLayoutView];
    [self.view addSubview:_shopTV];
    
    [_shopTV autoPinToTopLayoutGuideOfViewController:self withInset:44];
    [_shopTV autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view];
    [_shopTV autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view];
    [_shopTV autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view withOffset:-48];
    
    _shopTV.delegate = self;
    _shopTV.dataSource = self;
    _shopTV.separatorStyle = UITableViewCellAccessoryNone;
    
    self.refreshTV = [[UIRefreshControl alloc] init];
    [_shopTV addSubview:_refreshTV];
    [_refreshTV addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    
    [self.shopTV registerClass:[ShoppingPopularityTableViewCell class] forCellReuseIdentifier:SHOP_POP_CELL];
    [self.shopTV registerClass:[ShoppingDGTableViewCell class] forCellReuseIdentifier:SHOP_CELL];
    [self.shopTV reloadData];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 85;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if ([self.shopData count] <= 0) {
        return 0;
    }else{
        return [self.shopData count];
    }
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    int selectIndex = _shopSegmented.selectedSegmentIndex;
    
    if (selectIndex == 1) {
        ShoppingDGTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SHOP_CELL forIndexPath:indexPath];
        
        NSDictionary *cellData = [[NSDictionary alloc] initWithDictionary:[self.shopData objectAtIndex:indexPath.row]];
        
        NSURL *imageUrl = [NSURL URLWithString:[cellData objectForKey:@"pic_url"]];
        
        [cell.proImg setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"defaultPic.jpg"]];
        cell.bigTitleLB.text = [cellData objectForKey:@"name"];
        cell.avgLB.text = [cellData objectForKey:@"avg_price"];
        cell.areaLB.text = [NSString stringWithFormat:@"%@", [cellData objectForKey:@"area"]];
        cell.cateLB.text = [NSString stringWithFormat:@"%@", [cellData objectForKey:@"category"]];
        
        NSInteger starSize = [[cellData objectForKey:@"avg_rating"] intValue];
        
        UIImageView *grayStar = [UIImageView newAutoLayoutView];
        [cell.contentView addSubview:grayStar];
        
        [grayStar autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:cell.bigTitleLB withOffset:starSize];
        [grayStar autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:cell.bigTitleLB withOffset:5];
        [grayStar autoSetDimensionsToSize:CGSizeMake(85 - starSize, 18)];
        grayStar.backgroundColor = [UIColor whiteColor];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }else{
        ShoppingPopularityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SHOP_POP_CELL forIndexPath:indexPath];
        
        NSDictionary *cellData = [[NSDictionary alloc] initWithDictionary:[self.shopData objectAtIndex:indexPath.row]];
        
        NSURL *imageUrl = [NSURL URLWithString:[cellData objectForKey:@"thumb"]];
        
        [cell.productImage setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"defaultPic.jpg"]];
        cell.titleZHLB.text = [cellData objectForKey:@"title_zh"];
        cell.titleJPLB.text = [cellData objectForKey:@"title_jp"];
        cell.priceZHLB.text = [cellData objectForKey:@"price_zh"];
        cell.priceJPLB.text = [cellData objectForKey:@"price_jp"];
        cell.summaryLB.text = [cellData objectForKey:@"summary_zh"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }

}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *cellData = [[NSDictionary alloc] initWithDictionary:[self.shopData objectAtIndex:indexPath.row]];
    
    ShoppingDGDetailViewController *detailVC = [[ShoppingDGDetailViewController alloc] init];
    NSLog(@"indexPath is %@", indexPath);
    if (self.shopSegmented.selectedSegmentIndex == 1) {
        detailVC.webUrl = [NSString stringWithFormat:@"http://api.atniwo.com/Product/showShopDetail?sid=%@", [cellData objectForKey:@"saler_id"]];
        detailVC.navigationItem.title = [cellData objectForKey:@"name"];
    }else{
        detailVC.webUrl = [NSString stringWithFormat:@"http://api.atniwo.com/Product/showProDetail?pid=%@", [cellData objectForKey:@"pid"]];
        detailVC.navigationItem.title = [cellData objectForKey:@"title_zh"];
    }

    detailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
    
}


- (void) refresh:(UIRefreshControl *)control {
    [control beginRefreshing];
    [control endRefreshing];
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
