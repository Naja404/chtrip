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
#import "PlayDetailViewController.h"

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

@property (nonatomic, strong) NSArray *bigCate;
@property (nonatomic, strong) NSArray *smallCate;
@property (nonatomic, strong) NSArray *brand;
@property (nonatomic, strong) NSArray *allBrand;
@property (nonatomic, strong) NSArray *price;
@property (nonatomic, strong) NSString *selectCate;
@property (nonatomic, strong) NSString *selectBrand;
@property (nonatomic, strong) NSString *selectSort;

@property (nonatomic, strong) UITableView *shopTV;
@property (nonatomic, strong) NSMutableArray *shopData;
@property (nonatomic, strong) UIRefreshControl *refreshTV;

@property (nonatomic, strong) NSString *proNextPageNum;
@property (nonatomic, strong) NSString *shopNextPageNum;

@end

@implementation ShoppingDGViewController

- (void) viewWillAppear:(BOOL)animated {
    self.hidesBottomBarWhenPushed = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.proNextPageNum = @"1";
    self.shopNextPageNum = @"1";
    
    [self setupSegmentedControl];
    [self setupDOPMenu];
    
    [self setupShopList];
//    [self getProductList:self.proNextPageNum];
    [self refresh];

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
    
//    [self.shopData removeAllObjects];
    
    [self refresh];
}

- (void) setupDOPMenu {
    self.selectCate = @"";
    self.selectBrand = @"";
    self.selectSort = @"";
    // 数据
    self.bigCate = @[@"类别", @"潮流服饰", @"美妆护理", @"箱包钟表", @"数码家电", @"母婴宝贝", @"食品饮料", @"动漫天地"];
    
    self.smallCate = @[@[],
                       @[@"女装", @"男装", @"男鞋", @"女鞋", @"户外运动", @"童装"],
                       @[@"香水彩妆", @"面部护理", @"护发美体", @"女性护理", @"男士护理", @"日常医药"],
                       @[@"潮流女包", @"时尚男包", @"钟表", @"奢侈品", @"精美礼品"],
                       @[@"大家电", @"小家电", @"厨房电器", @"手机通讯", @"摄影摄像", @"电脑游戏"],
                       @[@"母婴奶粉", @"营养辅食", @"尿裤湿巾", @"洗护清洁", @"孕妇用品", @"宝宝用品"],
                       @[@"饼干糕点", @"糖果巧克力", @"咖啡饮料", @"零食", @"酒水饮料", @"各地特长"],
                       @[@"动漫书籍", @"动漫手办", @"动漫模型", @"动漫游戏", @"动漫服饰"]];
    self.brand = @[@"品牌", @"热门品牌", @"全部品牌"];
    
    self.allBrand = @[@[],
                      @[@"索尼", @"资生堂", @"尼康", @"优衣库", @"DHC", @"精工"],
                      @[@"资生堂", @"索尼", @"尼康", @"佳能", @"东芝", @"蝶翠诗", @"DHC", @"高丝",
                        @"欧泊莱", @"爱普生", @"松下", @"夏普", @"富士通", @"卡西欧", @"奥林",
                        @"西铁城", @"先锋", @"精工", @"Hello Kitty", @"日立", @"格力高", @"富士施",
                        @"姬芮ZA", @"京瓷", @"美津浓", @"安尚秀", @"优衣库", @"雪肌兰"]];
    self.sorts = @[@"价格", @"200以下", @"200-500", @"1000-2000", @"2000-5000", @"5000-10000", @"1万以上"];
    
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
        return self.bigCate.count;
    }else if (column == 1){
        return self.brand.count;
    }else {
        return self.sorts.count;
    }
}

- (NSString *)menu:(DOPDropDownMenu *)menu titleForRowAtIndexPath:(DOPIndexPath *)indexPath
{
    if (indexPath.column == 0) {
//        return self.classifys[indexPath.row];
        return self.bigCate[indexPath.row];
    } else if (indexPath.column == 1){
//        return self.areas[indexPath.row];
        return self.brand[indexPath.row];
    } else {
//        return self.sorts[indexPath.row];
        return self.sorts[indexPath.row];
    }
}

- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfItemsInRow:(NSInteger)row column:(NSInteger)column
{
    if (column == 0) {
        return [self.smallCate[row] count];
//        if (row == 0) {
//           return self.bigCate.count;
//        } else if (row == 2){
//            return self.brand.count;
//        } else if (row == 3){
//            return self.sorts.count;
//        }
    }else if (column == 1){
        return [self.allBrand[row] count];
    }else{
//        return self.sorts.count;
    }
    
    return 0;
}

- (NSString *)menu:(DOPDropDownMenu *)menu titleForItemsInRowAtIndexPath:(DOPIndexPath *)indexPath
{
    if (indexPath.column == 0) {
        
        return self.smallCate[indexPath.row][indexPath.item];
//        
//        if (indexPath.row == 0) {
//            return self.cates[indexPath.item];
//        } else if (indexPath.row == 2){
//            return self.movices[indexPath.item];
//        } else if (indexPath.row == 3){
//            return self.hostels[indexPath.item];
//        }
    }else if (indexPath.column == 1) {
        return self.allBrand[indexPath.row][indexPath.item];
    }else{
        return self.sorts[indexPath.item];
    }
    
    return nil;
}

- (void)menu:(DOPDropDownMenu *)menu didSelectRowAtIndexPath:(DOPIndexPath *)indexPath
{
    if (indexPath.item >= 0) {
//        NSLog(@"点击了 %ld - %ld - %ld 项目",indexPath.column,indexPath.row,indexPath.item);
        
        if (indexPath.column == 0) {
//            NSLog(@"点击了%@", self.smallCate[indexPath.row][(int)indexPath.item]);
            self.selectCate = self.smallCate[indexPath.row][indexPath.item];
        }else if (indexPath.column == 1){
            self.selectBrand = self.allBrand[indexPath.row][indexPath.item];
//            NSLog(@"点击了%@", self.allBrand[indexPath.row][(int)indexPath.item]);
        }else{
            self.selectSort = self.sorts[indexPath.item];
//            NSLog(@"点击了%@", self.sorts[indexPath.item]);
        }
        
        [self refresh];
        
    }else {
//        NSLog(@"点击了 %ld - %ld 项目",indexPath.column,indexPath.row);
        if (indexPath.row == 0) {
            if (indexPath.column == 0) {
                self.selectCate = @"";
            }else if (indexPath.column == 1) {
                self.selectBrand = @"";
            }else{
                self.selectSort = @"";
            }
            [self refresh];
        }
        
        if (indexPath.row > 0 && indexPath.column == 2) {
            self.selectSort = self.sorts[indexPath.row];
            [self refresh];
        }

    }

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 获取产品列表
- (void) getProductList:(NSString *)PageNum {
    [SVProgressHUD show];
    NSMutableDictionary *paramter = [NSMutableDictionary dictionary];
//    [paramter setObject:[CHSSID SSID] forKey:@"ssid"];
    [paramter setObject:[NSString stringWithFormat:@"%@", [CHSSID SSID]] forKey:@"ssid"];
    [paramter setObject:PageNum forKey:@"pageNum"];
    [paramter setObject:self.selectCate forKey:@"cate"];
    [paramter setObject:self.selectBrand forKey:@"brand"];
    [paramter setObject:self.selectSort forKey:@"sort"];
    
    [[HttpManager instance] requestWithMethod:@"Product/proList"
                                   parameters:paramter
                                      success:^(NSDictionary *result) {
                                          NSLog(@"Productlist data is %@", result);
                                          if ([PageNum isEqualToString:@"1"]) {
                                              self.shopData = [[NSMutableArray alloc] initWithArray:[[result objectForKey:@"data"] objectForKey:@"proList"]];
                                              [self.shopTV reloadData];
                                              [self.shopTV.header endRefreshing];
                                          }else{
                                              [self.shopData addObjectsFromArray:[[result objectForKey:@"data"] objectForKey:@"proList"]];
                                              [self.shopTV reloadData];
                                              [self.shopTV.footer endRefreshing];
                                          }
                                          
                                          if ([[[result objectForKey:@"data"] objectForKey:@"hasMore"] isEqualToString:@"1"]) {
                                              self.proNextPageNum = [[result objectForKey:@"data"] objectForKey:@"nextPageNum"];
                                          }
                                          [SVProgressHUD dismiss];
                                      }
                                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                          [self.shopTV.header endRefreshing];
                                          [self.shopTV.footer endRefreshing];
                                          [SVProgressHUD dismiss];
                                      }];

}

#pragma mark 获取商家列表
- (void) getShopList:(NSString *)PageNum {
    
    [SVProgressHUD show];
    
    NSMutableDictionary *paramter = [NSMutableDictionary dictionary];
    [paramter setObject:[NSString stringWithFormat:@"%@", [CHSSID SSID]] forKey:@"ssid"];
    [paramter setObject:@"1" forKey:@"shopType"];
    [paramter setObject:PageNum forKey:@"pageNum"];
    
    [[HttpManager instance] requestWithMethod:@"Product/shopList"
                                   parameters:paramter
                                      success:^(NSDictionary *result) {
                                          NSLog(@"shoplist data is %@", result);
                                          if ([PageNum isEqualToString:@"1"]) {
                                              self.shopData = [[NSMutableArray alloc] initWithArray:[[result objectForKey:@"data"] objectForKey:@"shopList"]];
                                              [self.shopTV reloadData];
                                              [self.shopTV.header endRefreshing];
                                          }else{
                                              [self.shopData addObjectsFromArray:[[result objectForKey:@"data"] objectForKey:@"shopList"]];
                                              [self.shopTV reloadData];
                                              [self.shopTV.footer endRefreshing];
                                          }
                                          
                                          if ([[[result objectForKey:@"data"] objectForKey:@"hasMore"] isEqualToString:@"1"]) {
                                              self.shopNextPageNum = [[result objectForKey:@"data"] objectForKey:@"nextPageNum"];
                                          }
                                          [SVProgressHUD dismiss];
                                          
                                      }
                                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                          [self.shopTV.header endRefreshing];
                                          [self.shopTV.footer endRefreshing];
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
//    _shopTV.separatorStyle = UITableViewCellAccessoryNone;
    
    [self.shopTV registerClass:[ShoppingPopularityTableViewCell class] forCellReuseIdentifier:SHOP_POP_CELL];
    [self.shopTV registerClass:[ShoppingDGTableViewCell class] forCellReuseIdentifier:SHOP_CELL];
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
    
    if (self.shopSegmented.selectedSegmentIndex == 1) {
        ShoppingDGTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SHOP_CELL forIndexPath:indexPath];
        
        NSDictionary *cellData = [[NSDictionary alloc] initWithDictionary:[self.shopData objectAtIndex:indexPath.row]];
        
        NSURL *imageUrl = [NSURL URLWithString:[cellData objectForKey:@"pic_url"]];
        
        [cell.proImg setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"defaultPic.jpg"]];
        cell.bigTitleLB.text = [cellData objectForKey:@"name"];
        cell.avgLB.text = [cellData objectForKey:@"avg_price"];
        cell.areaLB.text = [NSString stringWithFormat:@"%@", [cellData objectForKey:@"area"]];
        cell.cateLB.text = [NSString stringWithFormat:@"%@", [cellData objectForKey:@"category"]];
        cell.starImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"star_%@", [cellData objectForKey:@"avg_rating"]]];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }else{
        ShoppingPopularityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SHOP_POP_CELL forIndexPath:indexPath];
        
        NSDictionary *cellData = [[NSDictionary alloc] initWithDictionary:[self.shopData objectAtIndex:indexPath.row]];
        
        NSURL *imageUrl = [NSURL URLWithString:[cellData objectForKey:@"thumb"]];
        
        [cell.productImage setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"defaultPic.jpg"]];
        cell.titleZHLB.text = [cellData objectForKey:@"title_zh"];
        cell.summaryZHLB.text = [cellData objectForKey:@"summary_zh"];
        cell.priceZHLB.text = [cellData objectForKey:@"price_zh"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }

}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *cellData = [[NSDictionary alloc] initWithDictionary:[self.shopData objectAtIndex:indexPath.row]];
    
    if (self.shopSegmented.selectedSegmentIndex == 1) {
        PlayDetailViewController *detailVC = [[PlayDetailViewController alloc] init];

        detailVC.webUrl = [NSString stringWithFormat:@"http://api.atniwo.com/Product/showShopDetail?sid=%@", [cellData objectForKey:@"saler_id"]];
        detailVC.sid = [NSString stringWithFormat:@"%@", [cellData objectForKey:@"saler_id"]];
        detailVC.navigationItem.title = [cellData objectForKey:@"name"];
        detailVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detailVC animated:YES];

    }else{
        ShoppingDGDetailViewController *detailVC = [[ShoppingDGDetailViewController alloc] init];

        detailVC.webUrl = [NSString stringWithFormat:@"http://api.atniwo.com/Product/showProDetail?pid=%@", [cellData objectForKey:@"pid"]];
        detailVC.pid = [NSString stringWithFormat:@"%@", [cellData objectForKey:@"pid"]];
        detailVC.zhPriceStr = [NSString stringWithFormat:@"%@", [cellData objectForKey:@"price_zh"]];
        detailVC.navigationItem.title = [cellData objectForKey:@"title_zh"];
        detailVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detailVC animated:YES];

    }

    
}


- (void) refresh {
    
        self.shopTV.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            self.shopNextPageNum = @"1";
            self.proNextPageNum = @"1";
            
            if (self.shopSegmented.selectedSegmentIndex == 1) {
                [self getShopList:self.shopNextPageNum];
            }else{
                [self getProductList:self.proNextPageNum];
            }
        }];
    
    [self.shopTV.header beginRefreshing];

}

- (void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView.contentOffset.y + scrollView.frame.size.height >= scrollView.contentSize.height) {

        [self.shopTV.footer beginRefreshing];
        
        self.shopTV.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            if (self.shopSegmented.selectedSegmentIndex == 1) {
                [self getShopList:self.shopNextPageNum];
            }else{
                [self getProductList:self.proNextPageNum];
            }
        }];
    }
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
