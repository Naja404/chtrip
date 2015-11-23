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
@property (nonatomic, strong) NSString *hasMoreData;
@property (nonatomic, strong) DOPDropDownMenu *dopMenu;
@property (nonatomic, assign) BOOL isProduct;
@property (nonatomic, strong) UIImageView *bgView;

@end

@implementation ShoppingDGViewController

- (void) viewWillDisappear:(BOOL)animated {
    [[HttpManager instance] cancelAllOperations];
    [SVProgressHUD dismiss];
}

- (void) viewWillAppear:(BOOL)animated {
    self.hidesBottomBarWhenPushed = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.proNextPageNum = @"1";
    self.shopNextPageNum = @"1";
    
    [self setupSegmentedControl];
    [self setProductDOPMenu];
    [self setupDOPMenu];
    
    [self setupShopList];
    [self refresh:YES];

    self.automaticallyAdjustsScrollViewInsets = NO;
    
}

- (void) setupSegmentedControl {
    self.shopSegmented = [[UISegmentedControl alloc] initWithItems:@[@"人气商品",@"商家"]];
    _shopSegmented.frame = CGRectMake(20.0, 20.0, 150, 30);
    _shopSegmented.selectedSegmentIndex = 0;
    _shopSegmented.tintColor = RED_COLOR_BG;
    [_shopSegmented addTarget:self action:@selector(shopSegmentAction:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = _shopSegmented;
}

- (void) setStatusBarBG {
    UIView *statusBG = [[UIView alloc] initWithFrame:CGRectMake(0, -20, ScreenWidth, 20)];
    
    statusBG.backgroundColor = [UIColor blackColor];
    
    [self.navigationController.navigationBar addSubview:statusBG];
    
}

- (void) shopSegmentAction:(id)sender {
    if (_shopSegmented.selectedSegmentIndex == 1) {
        [self setSHopDOPMenu];
    }else{
        [self setProductDOPMenu];
    }
    [_dopMenu reloadData];
    
    [self refresh:YES];
}

- (void) setSHopDOPMenu {
   
    self.selectCate = @"";
    self.selectBrand = @"";
    self.selectSort = @"";
    // 数据
    self.bigCate = @[@"城市", @"热门城市", @"全部城市"];
    
    self.smallCate = @[@[],
                       @[@"东京", @"大阪", @"名古屋", @"冲绳", @"京都", @"北海道", @"神户"],
                       @[@"东京", @"大阪", @"名古屋", @"冲绳", @"京都", @"北海道", @"神户",
                         @"鹿儿岛", @"福冈", @"静冈", @"广岛", @"长崎", @"栃木県", @"千叶县",
                         @"泉佐野", @"茨城県", @"静岡県"]];
    self.brand = @[@"门店类别", @"百货商场", @"专卖店", @"街区", @"杂货店", @"特产店",
                      @"免税店", @"药妆店", @"奥特莱斯", @"集市", @"电器店",
                      @"商业街", @"精品店", @"折扣店", @"购物街", @"工艺礼品",
                      @"书店画廊", @"二手店市场", @"食品药品", @"礼品店", @"书店"];

    self.sorts = @[@"星级", @"三星", @"四星", @"五星"];
    self.isProduct = NO;
}

- (void) setProductDOPMenu {
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
                      @[@"花王", @"先锋", @"精工", @"佳能", @"奥尔滨", @"索尼", @"欧泊莱", @"姬芮", @"优衣库", @"蝶翠诗"],
                      @[@"蝶翠诗", @"优衣库", @"姬芮ZA", @"欧泊莱", @"索尼", @"RMK", @"凯朵", @"奥尔滨", @"茵芙莎",
                        @"美津浓", @"佳能", @"精工", @"西铁城", @"先锋", @"植村秀", @"卡西欧", @"爱普生", @"尼康",
                        @"花王", @"芳凯尔", @"松下", @"高丝", @"安尚秀", @"娜丽丝", @"SK-Ⅱ", @"资生堂", @"格力高",
                        @"盛田屋", @"乐敦制药", @"薬師堂"]];
    self.sorts = @[@"价格", @"200以下", @"200-500", @"1000-2000", @"2000-5000", @"5000-10000", @"1万以上"];
    self.isProduct = YES;
}

- (void) setupDOPMenu {
    
    // 添加下拉菜单
    self.dopMenu = [[DOPDropDownMenu alloc] initWithOrigin:CGPointMake(0, 64) andHeight:44];
    _dopMenu.delegate = self;
    _dopMenu.dataSource = self;
    [self.view addSubview:_dopMenu];
    
    [_dopMenu selectDefalutIndexPath];
    
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
        return self.bigCate[indexPath.row];
    } else if (indexPath.column == 1){
        return self.brand[indexPath.row];
    } else {
        return self.sorts[indexPath.row];
    }
}

- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfItemsInRow:(NSInteger)row column:(NSInteger)column
{
    if (column == 0) {
        return [self.smallCate[row] count];
    }else if (column == 1){
        if (self.isProduct) {
           return [self.allBrand[row] count];
        }
    }else{

    }
    
    return 0;
}

- (NSString *)menu:(DOPDropDownMenu *)menu titleForItemsInRowAtIndexPath:(DOPIndexPath *)indexPath
{
    if (indexPath.column == 0) {
        return self.smallCate[indexPath.row][indexPath.item];
    }else if (indexPath.column == 1) {
        if (self.isProduct) {
            return self.allBrand[indexPath.row][indexPath.item];
        }else{
            return self.brand[indexPath.item];
        }
    }else{
        return self.sorts[indexPath.item];
    }
    
    return nil;
}

- (void)menu:(DOPDropDownMenu *)menu didSelectRowAtIndexPath:(DOPIndexPath *)indexPath
{
    NSLog(@"点击了 %ld - %ld 项目",indexPath.column,indexPath.row);
    if (indexPath.item >= 0) {
        if (indexPath.column == 0) {
            self.selectCate = self.smallCate[indexPath.row][indexPath.item];
        }else if (indexPath.column == 1){
            if (self.isProduct) {
                self.selectBrand = self.allBrand[indexPath.row][indexPath.item];
            }else{
                self.selectBrand = self.brand[indexPath.item];
            }
        }else{
            self.selectSort = self.sorts[indexPath.item];
        }
        
        [self refresh:NO];
        
    }else {
        if (indexPath.row == 0) {
            if (indexPath.column == 0) {
                self.selectCate = @"";
            }else if (indexPath.column == 1) {
                self.selectBrand = @"";
            }else{
                self.selectSort = @"";
            }
            [self refresh:NO];
        }
        
        if (indexPath.row > 0 && indexPath.column == 1) {
            if (!self.isProduct) {
                self.selectBrand = self.brand[indexPath.row];
                [self refresh:NO];
            }
        }
        
        if (indexPath.row > 0 && indexPath.column == 2) {
            self.selectSort = self.sorts[indexPath.row];
            [self refresh:NO];
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
    self.shopTV.scrollEnabled = NO;
    NSMutableDictionary *paramter = [NSMutableDictionary dictionary];
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
                                              self.hasMoreData = @"1";
                                          }else{
                                              self.proNextPageNum = @"1";
                                              self.hasMoreData = @"0";
                                          }
                                          
                                          if ([self.shopData count] > 0) {
                                              _shopTV.hidden = NO;
                                              _bgView.hidden = YES;
                                          }else{
                                              _shopTV.hidden = YES;
                                              _bgView.hidden = NO;
                                          }
                                          
                                          [SVProgressHUD dismiss];
                                          self.shopTV.scrollEnabled = YES;
                                      }
                                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                          [self.shopTV.header endRefreshing];
                                          [self.shopTV.footer endRefreshing];
                                          [SVProgressHUD dismiss];
                                          self.shopTV.scrollEnabled = YES;
                                      }];

}

#pragma mark 获取商家列表
- (void) getShopList:(NSString *)PageNum {
    
    [SVProgressHUD show];
    self.shopTV.scrollEnabled = NO;
    
    NSMutableDictionary *paramter = [NSMutableDictionary dictionary];
    [paramter setObject:[NSString stringWithFormat:@"%@", [CHSSID SSID]] forKey:@"ssid"];
    [paramter setObject:@"1" forKey:@"shopType"];
    [paramter setObject:PageNum forKey:@"pageNum"];
    [paramter setObject:self.selectCate forKey:@"cityName"];
    [paramter setObject:self.selectBrand forKey:@"category"];
    [paramter setObject:self.selectSort forKey:@"sort"];
    NSLog(@"shoplist paramter is %@", paramter);
    
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
                                              self.hasMoreData = @"1";
                                          }else{
                                              self.shopNextPageNum = @"1";
                                              self.hasMoreData = @"0";
                                          }
                                          
                                          if ([self.shopData count] > 0) {
                                              _shopTV.hidden = NO;
                                              _bgView.hidden = YES;
                                          }else{
                                              _shopTV.hidden = YES;
                                              _bgView.hidden = NO;
                                          }
                                          
                                          [SVProgressHUD dismiss];
                                          self.shopTV.scrollEnabled = YES;
                                      }
                                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                          [self.shopTV.header endRefreshing];
                                          [self.shopTV.footer endRefreshing];
                                          [SVProgressHUD dismiss];
                                          self.shopTV.scrollEnabled = YES;
                                          
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
    
    [self.shopTV registerClass:[ShoppingPopularityTableViewCell class] forCellReuseIdentifier:SHOP_POP_CELL];
    [self.shopTV registerClass:[ShoppingDGTableViewCell class] forCellReuseIdentifier:SHOP_CELL];
    
    self.bgView = [UIImageView newAutoLayoutView];
    [self.view addSubview:_bgView];
    
    [_bgView autoAlignAxis:ALAxisVertical toSameAxisOfView:self.view];
    [_bgView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.view];
    [_bgView autoSetDimensionsToSize:CGSizeMake(90, 70)];
    _bgView.image = [UIImage imageNamed:@"defaultDataPic"];
    _bgView.hidden = YES;
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
        
        [cell.proImg setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"defaultPicSmall"]];
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
        
        [cell.productImage setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"defaultPicSmall"]];
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

        detailVC.webUrl = [NSString stringWithFormat:@"http://api.nijigo.com/Product/showShopDetail?sid=%@", [cellData objectForKey:@"saler_id"]];
        detailVC.sid = [NSString stringWithFormat:@"%@", [cellData objectForKey:@"saler_id"]];
        detailVC.navigationItem.title = [cellData objectForKey:@"name"];
        detailVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detailVC animated:YES];

    }else{
        ShoppingDGDetailViewController *detailVC = [[ShoppingDGDetailViewController alloc] init];

        detailVC.webUrl = [NSString stringWithFormat:@"http://api.nijigo.com/Product/showProDetail?pid=%@", [cellData objectForKey:@"pid"]];
        detailVC.pid = [NSString stringWithFormat:@"%@", [cellData objectForKey:@"pid"]];
        detailVC.zhPriceStr = [NSString stringWithFormat:@"%@", [cellData objectForKey:@"price_zh"]];
        detailVC.navigationItem.title = [cellData objectForKey:@"title_zh"];
        detailVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detailVC animated:YES];

    }

    
}


- (void) refresh:(BOOL)isReload {
    // 停止所有网络请求
    [[HttpManager instance] cancelAllOperations];
    [self.shopTV.header endRefreshing];
    [self.shopTV.footer endRefreshing];
    [SVProgressHUD dismiss];
    
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
        
        if ([self.hasMoreData isEqualToString:@"1"]) {
            self.shopTV.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                if (self.shopSegmented.selectedSegmentIndex == 1) {
                    if ([self.shopNextPageNum isEqualToString:@"1"]) {
                        [self.shopTV.footer noticeNoMoreData];
                    }else{
                       [self getShopList:self.shopNextPageNum];
                    }
                }else{
                    if ([self.proNextPageNum isEqualToString:@"1"]) {
                        [self.shopTV.footer noticeNoMoreData];
                    }else{
                        [self getProductList:self.proNextPageNum];
                    }
                }
            }];
        }else{
            [self.shopTV.footer noticeNoMoreData];
        }
        

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
