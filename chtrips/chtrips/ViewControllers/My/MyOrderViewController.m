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
#import "MyWebViewController.h"
#import "CHAlertPayView.h"
#import "WXApiManager.h"
#import "WXApiRequestHandler.h"
#import <AlipaySDK/AlipaySDK.h>

static NSString * const MY_ORDER_CELL = @"myOrderCell";

@interface MyOrderViewController ()<UITableViewDelegate, UITableViewDataSource, CHAlertPayViewDelegate, WXApiManagerDelegate>

@property (nonatomic, strong) UIView *tabBarV;
@property (nonatomic, strong) UITableView *orderTV;
@property (nonatomic, strong) NSMutableArray *orderData;
@property (nonatomic, strong) UILabel *defaultLB;
@property (nonatomic, strong) CHAlertPayView *payV;

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
    [WXApiManager sharedManager].delegate = self;
    
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
    
    CHTabBarControl *selectControl = [[CHTabBarControl alloc] initWithTitles:@[NSLocalizedString(@"TEXT_UNPAY", nil),
                                                                               NSLocalizedString(@"TEXT_UNDELIVERED", nil) ,
                                                                               NSLocalizedString(@"TEXT_UNCONFIRM", nil),
                                                                               NSLocalizedString(@"TEXT_COMPLETE", nil)]];
    
    [selectControl setFrame:CGRectMake(0, 0, ScreenWidth, 44)];
    [selectControl setSelectedIndex:_selectedIndex];
    [selectControl setIndexChangeBlock:^(NSUInteger index) {
        _selectedIndex = index;
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
    _defaultLB.text = NSLocalizedString(@"TEXT_EMPTY_LABEL", nil);
    _defaultLB.hidden = YES;
    
    self.payV = [[CHAlertPayView alloc] initWithShareView:self];

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
    orderNumLB.text = [tmp objectForKey:@"oid_label"];
    
    UILabel *statusLB = [UILabel newAutoLayoutView];
    [headerV addSubview:statusLB];
    
    [statusLB autoAlignAxis:ALAxisHorizontal toSameAxisOfView:headerV];
    [statusLB autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:headerV withOffset:-10];
    [statusLB autoSetDimensionsToSize:CGSizeMake(100, 45)];
    statusLB.textAlignment = NSTextAlignmentRight;
    statusLB.textColor = RED_CART_BG;
    statusLB.font = FONT_SIZE_16;
    statusLB.text = [tmp objectForKey:@"status_label"];
    
    return headerV;
}

- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    NSDictionary *tmp = [_orderData objectAtIndex:section];
    
    UIView *footerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 45.5)];
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
    priceLB.textColor = RED_CART_BG;
    priceLB.font = FONT_SIZE_16;
    priceLB.text = [tmp objectForKey:@"total_fee"];
    
    UILabel *parentBgLB = [UILabel newAutoLayoutView];
    [footerV addSubview:parentBgLB];
    
    [parentBgLB autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:priceLB withOffset:-0.5];
    [parentBgLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:footerV];
    [parentBgLB autoSetDimensionsToSize:CGSizeMake(ScreenWidth, 21)];
    parentBgLB.backgroundColor = GRAY_COLOR_CELL_LINE;
    
    UILabel *bgLB = [UILabel newAutoLayoutView];
    [footerV addSubview:bgLB];
    
    [bgLB autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:priceLB];
    [bgLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:footerV];
    [bgLB autoSetDimensionsToSize:CGSizeMake(ScreenWidth, 20)];
    bgLB.backgroundColor = GRAY_COLOR_CITY_CELL;
    
    if ([[tmp objectForKey:@"status"] isEqualToString:@"4"]) {
        
        UIButton *payBTN = [UIButton newAutoLayoutView];
        [footerV addSubview:payBTN];
        
        [payBTN autoAlignAxis:ALAxisHorizontal toSameAxisOfView:priceLB];
        [payBTN autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:footerV withOffset:-10];
        [payBTN autoSetDimensionsToSize:CGSizeMake(80, 25)];
        [payBTN setTitle:NSLocalizedString(@"TEXT_PAY_NOW", nil) forState:UIControlStateNormal];
        [payBTN setTitleColor:RED_CART_BG forState:UIControlStateNormal];
        payBTN.titleLabel.font = FONT_SIZE_16;
        payBTN.layer.masksToBounds = YES;
        payBTN.layer.cornerRadius = 3.0f;
        payBTN.layer.borderWidth = 1.0f;
        payBTN.layer.borderColor = RED_CART_BG.CGColor;
        payBTN.tag = section;
        
        UITapGestureRecognizer *payOnceTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(payOrder:)];
        [payBTN addGestureRecognizer:payOnceTap];
        
        UIButton *cancelBTN = [UIButton newAutoLayoutView];
        [footerV addSubview:cancelBTN];
        
        [cancelBTN autoAlignAxis:ALAxisHorizontal toSameAxisOfView:priceLB];
        [cancelBTN autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:payBTN withOffset:-10];
        [cancelBTN autoSetDimensionsToSize:CGSizeMake(45, 25)];
        [cancelBTN setTitle:NSLocalizedString(@"BTN_CANCEL", nil) forState:UIControlStateNormal];
        [cancelBTN setTitleColor:GRAY_FONT_COLOR forState:UIControlStateNormal];
        cancelBTN.titleLabel.font = FONT_SIZE_16;
        cancelBTN.layer.masksToBounds = YES;
        cancelBTN.layer.cornerRadius = 3.0f;
        cancelBTN.layer.borderWidth = 1.0f;
        cancelBTN.layer.borderColor = GRAY_FONT_COLOR.CGColor;
        cancelBTN.tag = section;
        
        UITapGestureRecognizer *cancelOnceTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelOrder:)];
        [cancelBTN addGestureRecognizer:cancelOnceTap];
        
    }
    
    // 待收货 查看物流
    if ([[tmp objectForKey:@"status"] isEqualToString:@"3"]) {
        UIButton *shipBTN = [UIButton newAutoLayoutView];
        [footerV addSubview:shipBTN];
        
        [shipBTN autoAlignAxis:ALAxisHorizontal toSameAxisOfView:priceLB];
        [shipBTN autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:footerV withOffset:-10];
        [shipBTN autoSetDimensionsToSize:CGSizeMake(80, 25)];
        [shipBTN setTitle:NSLocalizedString(@"BTN_VIEW_SHIP", nil) forState:UIControlStateNormal];
        [shipBTN setTitleColor:GRAY_FONT_COLOR forState:UIControlStateNormal];
        shipBTN.titleLabel.font = FONT_SIZE_16;
        shipBTN.layer.masksToBounds = YES;
        shipBTN.layer.cornerRadius = 3.0f;
        shipBTN.layer.borderWidth = 1.0f;
        shipBTN.layer.borderColor = GRAY_FONT_COLOR.CGColor;
        shipBTN.tag = section;
        
        UITapGestureRecognizer *shipOnceTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reviewShip:)];
        [shipBTN addGestureRecognizer:shipOnceTap];
    }
    
    // 已完成 立即评价
    if ([[tmp objectForKey:@"status"] isEqualToString:@"1"]) {
        
        UIButton *shipBTN = [UIButton newAutoLayoutView];
        [footerV addSubview:shipBTN];
        
        [shipBTN autoAlignAxis:ALAxisHorizontal toSameAxisOfView:priceLB];
        [shipBTN autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:footerV withOffset:-10];
        [shipBTN autoSetDimensionsToSize:CGSizeMake(40, 25)];
        [shipBTN setTitle:NSLocalizedString(@"TEXT_SHIP_STATUS_1", nil) forState:UIControlStateNormal];
        [shipBTN setTitleColor:GRAY_FONT_COLOR forState:UIControlStateNormal];
        shipBTN.titleLabel.font = FONT_SIZE_16;
        shipBTN.layer.masksToBounds = YES;
        shipBTN.layer.cornerRadius = 3.0f;
        shipBTN.layer.borderWidth = 1.0f;
        shipBTN.layer.borderColor = GRAY_FONT_COLOR.CGColor;
        shipBTN.tag = section;
        
        UITapGestureRecognizer *shipOnceTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reviewShip:)];
        [shipBTN addGestureRecognizer:shipOnceTap];
        
        if ([[tmp objectForKey:@"has_comment"] isEqualToString:@"0"]) {
            UIButton *commentBTN = [UIButton newAutoLayoutView];
            [footerV addSubview:commentBTN];
            
            [commentBTN autoAlignAxis:ALAxisHorizontal toSameAxisOfView:priceLB];
            [commentBTN autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:shipBTN withOffset:-10];
            [commentBTN autoSetDimensionsToSize:CGSizeMake(80, 25)];
            [commentBTN setTitle:NSLocalizedString(@"BTN_COMMENT_NOW", nil) forState:UIControlStateNormal];
            [commentBTN setTitleColor:GRAY_FONT_COLOR forState:UIControlStateNormal];
            commentBTN.titleLabel.font = FONT_SIZE_16;
            commentBTN.layer.masksToBounds = YES;
            commentBTN.layer.cornerRadius = 3.0f;
            commentBTN.layer.borderWidth = 1.0f;
            commentBTN.layer.borderColor = GRAY_FONT_COLOR.CGColor;
            commentBTN.tag = section;
            
            UITapGestureRecognizer *commentOnceTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentNow:)];
            [commentBTN addGestureRecognizer:commentOnceTap];
            
        }

    }
    
    return footerV;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - 查看物流
- (void) reviewShip:(id)sender {
    UIButton *button = (UIButton *)[(UITapGestureRecognizer *)sender view];
    
    NSDictionary *tmp = [_orderData objectAtIndex:button.tag];
    
    MyWebViewController *webVC = [[MyWebViewController alloc] init];
    
    webVC.webUrl = [tmp objectForKey:@"ship_url"];
    
    webVC.navigationItem.title = NSLocalizedString(@"TEXT_SHIP_STATUS", nil);
    
    [self.navigationController pushViewController:webVC animated:YES];
}

#pragma mark - 立即评价
- (void) commentNow:(id)sender {
    UIButton *button = (UIButton *)[(UITapGestureRecognizer *)sender view];
    
    NSDictionary *tmp = [_orderData objectAtIndex:button.tag];
    
    MyWebViewController *webVC = [[MyWebViewController alloc] init];
    
    webVC.webUrl = [tmp objectForKey:@"comment_url"];
    
    webVC.navigationItem.title = NSLocalizedString(@"TEXT_PUBLICSH_COMMENT", nil);
    
    [self.navigationController pushViewController:webVC animated:YES];
}

#pragma mark - 取消订单
- (void) cancelOrder:(id)sender {
    
    UIButton *button = (UIButton *)[(UITapGestureRecognizer *)sender view];
    
    NSDictionary *tmp = [_orderData objectAtIndex:button.tag];
    
    [SVProgressHUD show];
    _orderTV.scrollEnabled = NO;
    
    NSMutableDictionary *paramter = [NSMutableDictionary dictionary];
    [paramter setObject:[NSString stringWithFormat:@"%@", [CHSSID SSID]] forKey:@"ssid"];
    [paramter setObject:[tmp objectForKey:@"oid"] forKey:@"oid"];
    [paramter setObject:[self getSelectedIndex:_selectedIndex] forKey:@"status"];
    
    [[HttpManager instance] requestWithMethod:@"User/cancelOrder"
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
                                          [SVProgressHUD showErrorWithStatus:[error localizedDescription] maskType:SVProgressHUDMaskTypeBlack];
                                      }];
}

#pragma mark - 立即支付
- (void) payOrder:(id)sender {
    
    UIButton *button = (UIButton *)[(UITapGestureRecognizer *)sender view];
    
    NSDictionary *tmp = [_orderData objectAtIndex:button.tag];
    
    _payV.oid = [tmp objectForKey:@"oid"];
    
    [_payV show];
    
    __weak typeof (self) weakSelf = self;
    _payV.tapPayAction = ^(NSString *payType, NSString *oid){
        
        [SVProgressHUD show];

        NSMutableDictionary *paramter = [NSMutableDictionary dictionary];
        [paramter setObject:[NSString stringWithFormat:@"%@", [CHSSID SSID]] forKey:@"ssid"];
        [paramter setObject:oid forKey:@"oid"];
        [paramter setObject:payType forKey:@"pay"];
        
        [[HttpManager instance] requestWithMethod:@"User/changePay"
                                       parameters:paramter
                                          success:^(NSDictionary *result) {
                                              
                                              NSDictionary *tmp = [result objectForKey:@"data"];
                                              
                                              if ([payType isEqualToString:@"wxpay"]) {
                                                  [WXApiRequestHandler jumpToWXPay:tmp];
                                              }else if ([payType isEqualToString:@"alipay"]){
                                                  
                                                  NSURL *tmpUrl = [NSURL URLWithString:@"alipay://"];
                                                  
                                                  if ([[UIApplication sharedApplication] canOpenURL:tmpUrl]) {
                                                      [[AlipaySDK defaultService] payOrder:[tmp objectForKey:@"app_url"] fromScheme:@"nijigo" callback:^(NSDictionary *resultDic) {
                                                          
                                                          if ([[resultDic objectForKey:@"resultStatus"] isEqualToString:@"9000"]) {
                                                              [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"TEXT_PAY_SUCCESS", nil) maskType:SVProgressHUDMaskTypeBlack];
                                                          }else{
                                                              [SVProgressHUD showInfoWithStatus:[resultDic objectForKey:@"memo"] maskType:SVProgressHUDMaskTypeBlack];
                                                          }
                                                          
//                                                          [self performSelector:@selector(popToRootVC) withObject:nil afterDelay:1.5f];
                                                      }];
                                                  }else{
//                                                      MyWebViewController *myWebVC = [[MyWebViewController alloc] init];
//                                                      myWebVC.navigationItem.title = @"支付宝支付";
//                                                      myWebVC.webUrl = [tmp objectForKey:@"wap_url"];
//                                                      myWebVC.isRoot = YES;
//                                                      [self.navigationController pushViewController:myWebVC animated:YES];
                                                  }
                                              }
                                              
                                              [weakSelf getOrder];
                                              
                                              [SVProgressHUD dismiss];
                                          }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                              [SVProgressHUD showInfoWithStatus:[error localizedDescription] maskType:SVProgressHUDMaskTypeBlack];
                                          }];
    };
}

#pragma mark - WXApiManagerDelegate
- (void)managerDidRecvMessageResponse:(SendMessageToWXResp *)response {
    
    switch (response.errCode) {
        case WXSuccess:
            // 支付成功
            [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"TEXT_PAY_SUCCESS", nil) maskType:SVProgressHUDMaskTypeBlack];
            break;
        case WXErrCodeCommon:
            // 支付失败
            [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"TEXT_PAY_FAILD", nil) maskType:SVProgressHUDMaskTypeBlack];
            break;
        case WXErrCodeUserCancel:
            // 用户取消支付
            [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"TEXT_CANCEL_PAY", nil) maskType:SVProgressHUDMaskTypeBlack];
            break;
        default:
            [SVProgressHUD showInfoWithStatus:@"#Error App 00366" maskType:SVProgressHUDMaskTypeBlack];
            break;
    }
    
    [self getOrder];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MY_ORDER_CELL forIndexPath:indexPath];
    
    NSDictionary *tmp = [[[_orderData objectAtIndex:indexPath.section] objectForKey:@"pro"] objectAtIndex:indexPath.row];
    
    NSURL *imageUrl = [NSURL URLWithString:[tmp objectForKey:@"thumb"]];
    [cell.proImg sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"defaultPicSmall"]];
    
    cell.titleLB.text = [tmp objectForKey:@"title_zh"];
    cell.priceLB.text = [tmp objectForKey:@"price_zh"];
    cell.totalLB.text = [tmp objectForKey:@"quantity"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
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
    
    NSString *selectedIndex = @"4";
    
    switch (index) {
        case 0:
            selectedIndex = @"4";
            break;
        case 1:
            selectedIndex = @"2";
            break;
        case 2:
            selectedIndex = @"3";
            break;
        case 3:
            selectedIndex = @"10";
            break;
        default:
            selectedIndex = @"4";
            break;
    }
    
    return selectedIndex;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
