//
//  PlayViewController.m
//  chtrips
//
//  Created by Hisoka on 15/3/30.
//  Copyright (c) 2015年 HSK.ltd. All rights reserved.
//

#import "PlayViewController.h"
#import "PlayTableViewCell.h"
#import "PlayDetailViewController.h"
#import "CitySelectViewController.h"
#import "PopoverView.h"
#import "HMSegmentedControl.h"

static NSString * const PLAY_CELL = @"playCell";

@interface PlayViewController () <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate, CitySelectViewControllerDelegate>
@property (nonatomic, strong) UISegmentedControl *shopSegmented;
@property (nonatomic, strong) NSArray *classifys;
@property (nonatomic, strong) NSArray *cates;
@property (nonatomic, strong) NSArray *movices;
@property (nonatomic, strong) NSArray *hostels;
@property (nonatomic, strong) NSArray *areas;
@property (nonatomic, strong) NSArray *sorts;

@property (nonatomic, strong) UITableView *playTV;
@property (nonatomic, strong) NSMutableArray *playData;
@property (nonatomic, strong) UIRefreshControl *refreshTV;
@property (nonatomic, strong) NSString *selectIndex;
@property (nonatomic, strong) NSString *nextPageNum;
@property (nonatomic, strong) NSString *selectCityName;
@property (nonatomic, strong) NSString *hasMoreData;

@property (nonatomic, strong) UIButton *cityBTN;
@property (nonatomic, strong) UIView *cateMenuView;
@property (nonatomic, strong) UISegmentedControl *playSegmented;
@property (nonatomic, strong) UIImageView *bgView;

@end

@implementation PlayViewController

- (void) viewWillDisappear:(BOOL)animated {
    [[HttpManager instance] cancelAllOperations];
    [SVProgressHUD dismiss];
}

- (void) viewWillAppear:(BOOL)animated {
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)viewDidLoad {
    self.selectIndex = @"2";
    self.nextPageNum = @"2";
    NSString *selectCity = [[TMCache sharedCache] objectForKey:@"selectCityName"];
    
    if (selectCity == nil) {
        selectCity = @"东京";
        self.selectCityName = selectCity;
    }else{
        self.selectCityName = selectCity;
    }
    
    [super viewDidLoad];
    [self setupCityBTN];
//    [self setupDOPMenu];
    [self setupPlayList];
    [self setupCateMenu];
    [self getCityList];
    [self refresh];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark 获取商家列表
- (void) getShopList:(NSString *)PageNum {
    [SVProgressHUD show];
    self.playTV.scrollEnabled = NO;
    NSMutableDictionary *paramter = [NSMutableDictionary dictionary];
//    [paramter setObject:[CHSSID SSID] forKey:@"ssid"];
    [paramter setObject:[NSString stringWithFormat:@"%@", [CHSSID SSID]] forKey:@"ssid"];
    [paramter setObject:self.selectIndex forKey:@"shopType"];
    [paramter setObject:PageNum forKey:@"pageNum"];
    [paramter setObject:self.selectCityName forKey:@"cityName"];
    
    [[HttpManager instance] requestWithMethod:@"Product/shopList"
                                   parameters:paramter
                                      success:^(NSDictionary *result) {
                                          NSLog(@"shoplist data is %@", result);
                                          if ([PageNum isEqualToString:@"1"]) {
                                              self.playData = [[NSMutableArray alloc] initWithArray:[[result objectForKey:@"data"] objectForKey:@"shopList"]];
                                              [self.playTV reloadData];
                                              [self.playTV.header endRefreshing];
                                          }else{
                                              [self.playData addObjectsFromArray:[[result objectForKey:@"data"] objectForKey:@"shopList"]];
                                              [self.playTV reloadData];
                                              [self.playTV.footer endRefreshing];
                                          }
                                          
                                          if ([[[result objectForKey:@"data"] objectForKey:@"hasMore"] isEqualToString:@"0"]) {
                                              self.nextPageNum = @"1";
                                              self.hasMoreData = @"0";
                                          }else{
                                              self.nextPageNum = [[result objectForKey:@"data"] objectForKey:@"nextPageNum"];
                                              self.hasMoreData = @"1";
                                          }
                                          
                                          if ([self.playData count] > 0) {
                                              _playTV.hidden = NO;
                                              _bgView.hidden = YES;
                                          }else{
                                              _playTV.hidden = YES;
                                              _bgView.hidden = NO;
                                          }
                                          
                                          [SVProgressHUD dismiss];
                                          self.playTV.scrollEnabled = YES;
                                      }
                                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                          [self.playTV.header endRefreshing];
                                          [SVProgressHUD dismiss];
                                      }];
}

- (void) setupCityBTN {
    
    self.cityBTN = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 75, 30)];
    
    [_cityBTN setTitle:_selectCityName forState:UIControlStateNormal];
    _cityBTN.titleLabel.textColor = [UIColor whiteColor];
    _cityBTN.titleLabel.font = [UIFont systemFontOfSize:14];
    _cityBTN.backgroundColor = RED_COLOR_BG;
    _cityBTN.layer.cornerRadius = 5;
    [_cityBTN addTarget:self action:@selector(showCityMenu:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.titleView = self.cityBTN;
}

- (void) showCityMenu:(UIButton *)sender {
    
    CitySelectViewController *cityView = [[CitySelectViewController alloc] init];
    cityView.cityData = [[TMCache sharedCache] objectForKey:@"cityList"];
    cityView.delegate = self;
    
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:cityView];

    [self.navigationController presentViewController:navVC animated:YES completion:nil];
    
}

- (void) getCityList {
    
    NSMutableDictionary *paramter = [NSMutableDictionary dictionary];
    [paramter setObject:[NSString stringWithFormat:@"%@", [CHSSID SSID]] forKey:@"ssid"];
    [paramter setObject:CHVersion forKey:@"ver"];
    
    [[HttpManager instance] requestWithMethod:@"Product/cityList"
                                   parameters:paramter
                                      success:^(NSDictionary *result) {
                                          NSString *cityListVersion = [[TMCache sharedCache] objectForKey:@"cityListVersion"];
                                          
                                          if (![[[result objectForKey:@"data"] objectForKey:@"version"] isEqualToString:cityListVersion]) {
                                              [[TMCache sharedCache] setObject:[[result objectForKey:@"data"] objectForKey:@"cityList"] forKey:@"cityList"];
                                          }
                                      }
                                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                      }];
}


- (void) setupCateMenu {
    self.cateMenuView = [UIView newAutoLayoutView];
    [self.view addSubview:_cateMenuView];
    
    [_cateMenuView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.view withOffset:64];
    [_cateMenuView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view];
    [_cateMenuView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view];
    [_cateMenuView autoSetDimensionsToSize:CGSizeMake(ScreenWidth, 30)];
    _cateMenuView.backgroundColor = MENU_DEFAULT_COLOR;
    
    HMSegmentedControl *segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"美食", @"酒店", @"景点"]];
    [segmentedControl setFrame:CGRectMake(0, 0, ScreenWidth, 44)];
    [segmentedControl setBackgroundColor:[UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1]];
    [segmentedControl setSelectionIndicatorMode:HMSelectionIndicatorResizesToStringWidth];
    [segmentedControl setIndexChangeBlock:^(NSUInteger index) {
        self.selectIndex = [NSString stringWithFormat:@"%lu", (index + 2)];
        [self.playTV scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
        
        [self getShopList:@"1"];
//        
    }];
    [self.cateMenuView addSubview:segmentedControl];

}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
}

#pragma mark play tableview
- (void) setupPlayList {
    self.playTV = [UITableView newAutoLayoutView];
    [self.view addSubview:_playTV];
    
    [_playTV autoPinToTopLayoutGuideOfViewController:self withInset:44];
    [_playTV autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view];
    [_playTV autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view];
    [_playTV autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view withOffset:-48];
    
    _playTV.delegate = self;
    _playTV.dataSource = self;
    _playTV.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.playTV registerClass:[PlayTableViewCell class] forCellReuseIdentifier:PLAY_CELL];
    
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
    if ([self.playData count] <= 0) {
        return 0;
    }else{
        return [self.playData count];
    }
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PlayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PLAY_CELL];
    
    NSDictionary *cellData = [[NSDictionary alloc] initWithDictionary:[self.playData objectAtIndex:indexPath.row]];
    
    NSURL *imageUrl = [NSURL URLWithString:[cellData objectForKey:@"pic_url"]];
    [cell.proImg setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"defaultPicSmall"]];
    
    cell.bigTitleLB.text = [cellData objectForKey:@"name"];
    cell.avgLB.text = [cellData objectForKey:@"avg_price"];
    cell.areaLB.text = [NSString stringWithFormat:@"%@", [cellData objectForKey:@"area"]];
    cell.cateLB.text = [NSString stringWithFormat:@"%@", [cellData objectForKey:@"category"]];
    cell.starImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"star_%@", [cellData objectForKey:@"avg_rating"]]];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    PlayDetailViewController *detailVC = [[PlayDetailViewController alloc] init];
    NSDictionary *cellData = [[NSDictionary alloc] initWithDictionary:[self.playData objectAtIndex:indexPath.row]];
    
    detailVC.webUrl = [NSString stringWithFormat:@"http://api.nijigo.com/Product/showShopDetail?sid=%@", [cellData objectForKey:@"saler_id"]];
    detailVC.sid = [NSString stringWithFormat:@"%@", [cellData objectForKey:@"saler_id"]];
    if ([_selectIndex isEqualToString:@"3"]) {
        detailVC.isHotel = @"1";
    }else{
        detailVC.isHotel = @"0";
    }
    detailVC.navigationItem.title = [cellData objectForKey:@"name"];
    detailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
    
}


- (void) refresh {
    self.playTV.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getShopList:@"1"];
    }];
    [self.playTV.header beginRefreshing];
}

- (void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView.contentOffset.y + scrollView.frame.size.height >= scrollView.contentSize.height) {
        [self.playTV.footer beginRefreshing];
        
        if ([self.hasMoreData isEqualToString:@"1"]) {
            self.playTV.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                if (![self.nextPageNum isEqualToString:@"1"]) {
                    [self getShopList:self.nextPageNum];
                }else{
                    [self.playTV.footer noticeNoMoreData];
                }

            }];
        }else{
            [self.playTV.footer noticeNoMoreData];
        }
        

    }
}

- (void) didSelectCity:(NSString *)cityName {
    if ([cityName isEqualToString:@"全日本"]) {
        [[TMCache sharedCache] setObject:@"东京" forKey:@"selectCityName"];
        self.selectCityName = @"东京";
    }else{
        [[TMCache sharedCache] setObject:cityName forKey:@"selectCityName"];
        self.selectCityName = cityName;
    }
    
    [self.cityBTN setTitle:self.selectCityName forState:UIControlStateNormal];
    
    [self refresh];
}

@end
