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
#import "PopoverView.h"
#import "HMSegmentedControl.h"
#import "UIImageView+AFNetworking.h"

static NSString * const PLAY_CELL = @"playCell";

@interface PlayViewController () <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>
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


@property (nonatomic, strong) UIButton *cityBTN;

@property (nonatomic, strong) UIView *cateMenuView;

@end

@implementation PlayViewController

- (void) viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidLoad {
    self.selectIndex = @"2";
    self.nextPageNum = @"2";
    
    [super viewDidLoad];
    [self setupCityBTN];
//    [self setupDOPMenu];
    [self setupPlayList];
    [self setupCateMenu];
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
    NSMutableDictionary *paramter = [NSMutableDictionary dictionary];
//    [paramter setObject:[CHSSID SSID] forKey:@"ssid"];
    [paramter setObject:[NSString stringWithFormat:@"%@", [CHSSID SSID]] forKey:@"ssid"];
    [paramter setObject:self.selectIndex forKey:@"shopType"];
    [paramter setObject:PageNum forKey:@"pageNum"];
    
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
                                          
                                          if (![[[result objectForKey:@"data"] objectForKey:@"hasMore"] isEqualToString:@"0"]) {
                                              self.nextPageNum = [[result objectForKey:@"data"] objectForKey:@"nextPageNum"];
                                          }
                                          
                                          [SVProgressHUD dismiss];

                                      }
                                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                          [self.playTV.header endRefreshing];
                                          [SVProgressHUD dismiss];
                                      }];
}

- (void) setupCityBTN {
    self.cityBTN = [UIButton newAutoLayoutView];
    
    [self.view addSubview:_cityBTN];
   
    [_cityBTN autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.view withOffset:25];
//    [_cityBTN autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.navigationController.view];
    [_cityBTN autoAlignAxis:ALAxisVertical toSameAxisOfView:self.view];
    [_cityBTN autoSetDimensionsToSize:CGSizeMake(50, 25)];
    [_cityBTN setTitle:@"城市" forState:UIControlStateNormal];
    _cityBTN.backgroundColor = [UIColor redColor];
    _cityBTN.layer.cornerRadius = 5;
    
    [_cityBTN addTarget:self action:@selector(showCityMenu:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void) showCityMenu:(UIButton *)sender {
    CGPoint point = CGPointMake(sender.frame.origin.x + sender.frame.size.width/2, sender.frame.origin.y + sender.frame.size.height);
    NSArray *titles = @[@"东京", @"奈良", @"横滨", @"大阪"];
    PopoverView *pop = [[PopoverView alloc] initWithPoint:point titles:titles images:nil];
    pop.selectRowAtIndex = ^(NSInteger index){
        self.cityBTN.titleLabel.text = [titles objectAtIndex:index];
    };
    [pop show];
    
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
    [segmentedControl setFrame:CGRectMake(0, 0, ScreenWidth, 30)];
    [segmentedControl setBackgroundColor:[UIColor colorWithRed:237/255.0 green:239/255.0 blue:240/255.0 alpha:1]];
    [segmentedControl setSelectionIndicatorMode:HMSelectionIndicatorResizesToStringWidth];
    [segmentedControl setIndexChangeBlock:^(NSUInteger index) {
        self.selectIndex = [NSString stringWithFormat:@"%d", (index + 2)];
        [self.playTV scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
        
        [self getShopList:@"1"];
        
    }];
    [self.cateMenuView addSubview:segmentedControl];

}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
}

#pragma mark play tableview
- (void) setupPlayList {
    self.playTV = [UITableView newAutoLayoutView];
    [self.view addSubview:_playTV];
    
    [_playTV autoPinToTopLayoutGuideOfViewController:self withInset:74];
    [_playTV autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view];
    [_playTV autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view];
    [_playTV autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view withOffset:-48];
    
    _playTV.delegate = self;
    _playTV.dataSource = self;
    
    [self.playTV registerClass:[PlayTableViewCell class] forCellReuseIdentifier:PLAY_CELL];

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
    [cell.proImg setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"defaultPic.jpg"]];
    
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
    
    detailVC.webUrl = [NSString stringWithFormat:@"http://api.atniwo.com/Product/showShopDetail?sid=%@", [cellData objectForKey:@"saler_id"]];
    detailVC.sid = [NSString stringWithFormat:@"%@", [cellData objectForKey:@"saler_id"]];
    detailVC.navigationItem.title = [cellData objectForKey:@"name"];
    detailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
    
}


- (void) reloadData {

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
        self.playTV.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [self getShopList:self.nextPageNum];
        }];
    }
}

@end
