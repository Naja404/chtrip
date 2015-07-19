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

static NSString * const PLAY_CELL = @"playCell";

@interface PlayViewController () <DOPDropDownMenuDataSource, DOPDropDownMenuDelegate, UITableViewDataSource, UITableViewDelegate>
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

@end

@implementation PlayViewController

- (void) viewWillAppear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSegmentedControl];
    [self setupDOPMenu];
    [self setupPlayList];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setupSegmentedControl {
    UISegmentedControl *segmented = [[UISegmentedControl alloc] initWithItems:@[@"城市"]];
    segmented.frame = CGRectMake(20.0, 20.0, 60, 30);
    segmented.selectedSegmentIndex = 0;
    self.navigationItem.titleView = segmented;
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
//    return [self.playData count];
    return 15;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PlayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PLAY_CELL];
    cell.bigTitleLB.text = @"猫棒小吃";
    cell.avgLB.text = @"27$/人";
    cell.jpLB.text = @"74,123JPY";
    cell.zhLB.text = @"3,111RMB";
    
    return cell;
    
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    PlayDetailViewController *detailVC = [[PlayDetailViewController alloc] init];
    detailVC.webUrl = @"http://api.atniwo.com/shop.html";
    detailVC.navigationItem.title = @"高岛屋";
    UIBarButtonItem *backBTN = [[UIBarButtonItem alloc] init];
    backBTN.title = @"";
    backBTN.image = [UIImage imageNamed:@"arrowLeft"];
    self.navigationItem.backBarButtonItem = backBTN;
    [self.navigationController pushViewController:detailVC animated:YES];
    
}


- (void) refresh:(UIRefreshControl *)control {
    [control endRefreshing];
    [self.playTV reloadData];
}

@end
