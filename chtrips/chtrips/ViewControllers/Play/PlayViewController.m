//
//  PlayViewController.m
//  chtrips
//
//  Created by Hisoka on 15/3/30.
//  Copyright (c) 2015年 HSK.ltd. All rights reserved.
//

#import "PlayViewController.h"
#import "PlayTableViewCell.h"
#import "DOPDropDownMenu.h"
#import "PlayDetailViewController.h"
#import "PopoverView.h"
#import "HMSegmentedControl.h"
#import "UIImageView+AFNetworking.h"

static NSString * const PLAY_CELL = @"playCell";

@interface PlayViewController () <DOPDropDownMenuDataSource, DOPDropDownMenuDelegate, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>
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


@property (nonatomic, strong) UIButton *cityBTN;

@property (nonatomic, strong) UIView *cateMenuView;

@end

@implementation PlayViewController

- (void) viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    self.selectIndex = @"2";
    
    [super viewDidLoad];
    [self getShopList];
    [self setupCityBTN];
    [self setupDOPMenu];
    [self setupPlayList];
    [self setupCityMenu];
    [self setupCateMenu];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setupCityMenu {

}

#pragma mark 获取商家列表
- (void) getShopList {
    NSMutableDictionary *paramter = [NSMutableDictionary dictionary];
    [paramter setObject:[CHSSID SSID] forKey:@"ssid"];
    [paramter setObject:self.selectIndex forKey:@"shopType"];
    
    [[HttpManager instance] requestWithMethod:@"Product/shopList"
                                   parameters:paramter
                                      success:^(NSDictionary *result) {
                                          NSLog(@"shoplist data is %@", result);
                                          self.playData = [[NSMutableArray alloc] initWithArray:[[result objectForKey:@"data"] objectForKey:@"shopList"]];
                                          
                                      }
                                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                          
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
        NSLog(@"select index:%d", index);
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
        [self reloadShopTVData];
        NSLog(@"select index %i", (index + 2));
    }];
    [self.cateMenuView addSubview:segmentedControl];

}

- (void) reloadShopTVData {
    [self getShopList];
    [self.playTV reloadData];
    
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

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
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

#pragma mark play tableview
- (void) setupPlayList {
    self.playTV = [UITableView newAutoLayoutView];
    [self.view addSubview:_playTV];
    
    [_playTV autoPinToTopLayoutGuideOfViewController:self withInset:64];
    [_playTV autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view];
    [_playTV autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view];
    [_playTV autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view withOffset:-48];
    
    _playTV.delegate = self;
    _playTV.dataSource = self;
    _playTV.separatorStyle = UITableViewCellAccessoryNone;
    
    self.refreshTV = [[UIRefreshControl alloc] init];
    [_playTV addSubview:_refreshTV];
    [_refreshTV addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    
    [self.playTV registerClass:[PlayTableViewCell class] forCellReuseIdentifier:PLAY_CELL];
//    [self.playTV registerClass:[ShoppingDGTableViewCell class] forCellReuseIdentifier:SHOP_CELL];
    [self.playTV reloadData];
    
}


- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 85;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.playData count];
//    return 15;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PlayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PLAY_CELL];
    
    NSDictionary *cellData = [[NSDictionary alloc] initWithDictionary:[self.playData objectAtIndex:indexPath.row]];
    
    NSURL *imageUrl = [NSURL URLWithString:[cellData objectForKey:@"pic_url"]];
    [cell.proImg setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"productDemo3"]];
    
    cell.bigTitleLB.text = [cellData objectForKey:@"name"];
    cell.avgLB.text = [cellData objectForKey:@"avg_price"];
    cell.jpLB.text = @"74,123JPY";
    cell.zhLB.text = @"3,111RMB";
    
    return cell;
    
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    PlayDetailViewController *detailVC = [[PlayDetailViewController alloc] init];
    NSDictionary *cellData = [[NSDictionary alloc] initWithDictionary:[self.playData objectAtIndex:indexPath.row]];
    
    detailVC.webUrl = [NSString stringWithFormat:@"http://api.atniwo.com/Product/showShopDetail?sid=%@", [cellData objectForKey:@"saler_id"]];
    detailVC.navigationItem.title = [cellData objectForKey:@"name"];
    UIBarButtonItem *backBTN = [[UIBarButtonItem alloc] init];
    backBTN.title = @"";
    backBTN.image = [UIImage imageNamed:@"arrowLeft"];
    self.navigationItem.backBarButtonItem = backBTN;
    detailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
    
}


- (void) refresh:(UIRefreshControl *)control {
    [control endRefreshing];
    [self.playTV reloadData];
}

@end
