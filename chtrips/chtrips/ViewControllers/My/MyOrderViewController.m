//
//  MyOrderViewController.m
//  chtrips
//
//  Created by Hisoka on 16/1/7.
//  Copyright © 2016年 HSK.ltd. All rights reserved.
//

#import "MyOrderViewController.h"
#import "CHTabBarControl.h"
#import "MyOrderTableViewCell.h"

static NSString * const MY_ORDER_CELL = @"myOrderCell";

@interface MyOrderViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *tabBarV;
@property (nonatomic, strong) UITableView *orderTV;
@property (nonatomic, strong) NSMutableArray *orderData;
@property (nonatomic, strong) UILabel *defaultLB;

@end

@implementation MyOrderViewController

- (void)viewWillDisappear:(BOOL)animated {
    [[HttpManager instance] cancelAllOperations];
    [SVProgressHUD dismiss];
}

- (void) viewWillAppear:(BOOL)animated {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customizeBackItem];
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    
    [self setStyle];
    [self getOrder];
}

- (void) viewDidAppear:(BOOL)animated {
}

#pragma mark - 初始化样式
- (void) setStyle {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = NSLocalizedString(@"TEXT_ALL_ORDER", nil);

    self.tabBarV = [UIView newAutoLayoutView];
    [self.view addSubview:_tabBarV];
    
    [_tabBarV autoPinToTopLayoutGuideOfViewController:self withInset:0];
    [_tabBarV autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view];
    [_tabBarV autoSetDimensionsToSize:CGSizeMake(ScreenWidth, 44)];
    
    CHTabBarControl *selectControl = [[CHTabBarControl alloc] initWithTitles:@[NSLocalizedString(@"TEXT_ALL_ORDER", nil),
                                                                               NSLocalizedString(@"TEXT_UNPAY", nil),
                                                                               NSLocalizedString(@"TEXT_UNDELIVERED", nil) ,
                                                                               NSLocalizedString(@"TEXT_UNCONFIRM", nil)]];
    
    [selectControl setFrame:CGRectMake(0, 0, ScreenWidth, 44)];
    [selectControl setSelectedIndex:_selectedIndex];
    [selectControl setIndexChangeBlock:^(NSUInteger index) {
        _selectedIndex = index;
        NSLog(@"my order select index %ld", (long)index);
        [self getOrder];
    }];
    
    [_tabBarV addSubview:selectControl];
    
    [selectControl setSelectedIndex:_selectedIndex animated:NO];
    
    self.orderTV = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [self.view addSubview:_orderTV];
    
    [_orderTV autoPinToTopLayoutGuideOfViewController:self withInset:44];
    [_orderTV autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view];
    [_orderTV autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view];
    [_orderTV autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view];
    
    _orderTV.delegate = self;
    _orderTV.dataSource = self;
    _orderTV.separatorStyle = UITableViewCellSeparatorStyleNone;
    _orderTV.backgroundView = nil;
    _orderTV.backgroundColor = [UIColor clearColor];
    _orderTV.hidden = YES;
    
    [_orderTV registerClass:[MyOrderTableViewCell class] forCellReuseIdentifier:MY_ORDER_CELL];
    
    _defaultLB = [UILabel newAutoLayoutView];
    [self.view addSubview:_defaultLB];
    
    [_defaultLB autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.view];
    [_defaultLB autoAlignAxis:ALAxisVertical toSameAxisOfView:self.view];
    [_defaultLB autoSetDimensionsToSize:CGSizeMake(200, 40)];
    _defaultLB.textColor = GRAY_FONT_COLOR;
    _defaultLB.textAlignment = NSTextAlignmentCenter;
    _defaultLB.font = FONT_SIZE_16;
    _defaultLB.text = @"暂无相关内容";
    _defaultLB.hidden = YES;

}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    if ([_orderData count] <= 0) {
        return 0;
    }else{
        return [_orderData count];
    }
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSDictionary *tmp = [_orderData objectAtIndex:section];
    NSInteger proCount = [[tmp objectForKey:@"pro"] count];
    if (proCount <= 0) {
        return 0;
    }else{
        return proCount;
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 45;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 65;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    NSDictionary *tmp = [_orderData objectAtIndex:section];
    
    UIView *headerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 45)];
    headerV.backgroundColor = [UIColor clearColor];
    
    UILabel *orderNumLB = [UILabel newAutoLayoutView];
    [headerV addSubview:orderNumLB];
    
    [orderNumLB autoAlignAxis:ALAxisHorizontal toSameAxisOfView:headerV];
    [orderNumLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:headerV withOffset:10];
    [orderNumLB autoSetDimensionsToSize:CGSizeMake(ScreenWidth - 20, 45)];
    orderNumLB.textColor = BLACK_FONT_COLOR;
    orderNumLB.font = FONT_SIZE_16;
    orderNumLB.text = [tmp objectForKey:@"oid"];
    
    UILabel *statusLB = [UILabel newAutoLayoutView];
    [headerV addSubview:statusLB];
    
    [statusLB autoAlignAxis:ALAxisHorizontal toSameAxisOfView:headerV];
    [statusLB autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:headerV withOffset:-10];
    [statusLB autoSetDimensionsToSize:CGSizeMake(100, 45)];
    statusLB.textColor = RED_COLOR_BG;
    statusLB.font = FONT_SIZE_16;
    statusLB.text = [tmp objectForKey:@"status"];
    
    return headerV;
}

- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    NSDictionary *tmp = [_orderData objectAtIndex:section];
    
    UIView *footerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 45)];
    footerV.backgroundColor = [UIColor clearColor];
    
    UILabel *payPriceLB = [UILabel newAutoLayoutView];
    [footerV addSubview:payPriceLB];
    
    [payPriceLB autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:footerV];
    [payPriceLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:footerV withOffset:10];
    [payPriceLB autoSetDimensionsToSize:CGSizeMake(90, 45)];
    payPriceLB.textColor = BLACK_FONT_COLOR;
    payPriceLB.font = FONT_SIZE_16;
    payPriceLB.text = NSLocalizedString(@"TEXT_FACT_PAY_FEE", nil);
    
    UILabel *priceLB = [UILabel newAutoLayoutView];
    [footerV addSubview:priceLB];
    
    [priceLB autoAlignAxis:ALAxisHorizontal toSameAxisOfView:payPriceLB];
    [priceLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:payPriceLB];
    [priceLB autoSetDimensionsToSize:CGSizeMake(100, 45)];
    priceLB.textColor = RED_COLOR_BG;
    priceLB.font = FONT_SIZE_16;
    priceLB.text = [tmp objectForKey:@"total_fee"];
    
    UILabel *bgLB = [UILabel newAutoLayoutView];
    [footerV addSubview:bgLB];
    
    [bgLB autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:priceLB];
    [bgLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:footerV];
    [bgLB autoSetDimensionsToSize:CGSizeMake(ScreenWidth, 20)];
    bgLB.backgroundColor = GRAY_COLOR_CELL_LINE;
    
    return footerV;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MY_ORDER_CELL forIndexPath:indexPath];
    
    NSDictionary *tmp = [[[_orderData objectAtIndex:indexPath.section] objectForKey:@"pro"] objectAtIndex:indexPath.row];
    
    NSURL *imageUrl = [NSURL URLWithString:[tmp objectForKey:@"thumb"]];
    [cell.proImg sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"defaultPicSmall"]];
    
    cell.titleLB.text = [tmp objectForKey:@"title_zh"];
    cell.priceLB.text = [tmp objectForKey:@"price_zh"];
    cell.totalLB.text = [tmp objectForKey:@"quantity"];
    
    
    return cell;
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
//    CGFloat sectionHeaderHeight = 45;
//    if (scrollView.contentOffset.y <= sectionHeaderHeight && scrollView.contentOffset.y >= 0) {
//        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
//    } else if (scrollView.contentOffset.y >= sectionHeaderHeight) {
//        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
//    }
}

#pragma mark - 获取订单列表
- (void) getOrder {
    
    [SVProgressHUD show];
    _orderTV.scrollEnabled = NO;
//    [_orderTV setContentOffset:CGPointZero animated:YES];
    
    NSMutableDictionary *paramter = [NSMutableDictionary dictionary];
    [paramter setObject:[NSString stringWithFormat:@"%@", [CHSSID SSID]] forKey:@"ssid"];
    [paramter setObject:[self getSelectedIndex:_selectedIndex] forKey:@"status"];
    
    NSLog(@"post data %@", paramter);
    
    [[HttpManager instance] requestWithMethod:@"User/getOrder"
                                   parameters:paramter
                                      success:^(NSDictionary *result) {
                                          
                                          _orderData = [result objectForKey:@"data"];
                                          
                                          if ([_orderData count] <= 0) {
                                              _orderTV.hidden = YES;
                                              _defaultLB.hidden = NO;
                                          }else{
                                              _orderTV.hidden = NO;
                                              _defaultLB.hidden = YES;
                                          }
                                          
                                          [_orderTV reloadData];
                                          
                                          [SVProgressHUD dismiss];
                                          _orderTV.scrollEnabled = YES;
                                      }
                                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                          
                                      }];
}

- (NSString *) getSelectedIndex:(NSInteger)index {
    
    NSString *selectedIndex = @"all";
    
    switch (index) {
        case 0:
            selectedIndex = @"all";
            break;
        case 1:
            selectedIndex = @"4";
            break;
        case 2:
            selectedIndex = @"2";
            break;
        case 3:
            selectedIndex = @"3";
            break;
        default:
            selectedIndex = @"all";
            break;
    }
    
    return selectedIndex;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
