//
//  MyCheckOutViewController.m
//  chtrips
//
//  Created by Hisoka on 16/1/11.
//  Copyright © 2016年 HSK.ltd. All rights reserved.
//

#import "MyCheckOutViewController.h"
#import "MyCheckOutTableViewCell.h"
#import "MyAddressViewController.h"
#import "MyWebViewController.h"
#import "WXApiManager.h"
#import "WXApiRequestHandler.h"
#import "MyOrderViewController.h"
#import <AlipaySDK/AlipaySDK.h>

static NSString * const MY_CHECKOUT_CELL = @"myCheckOutCell";
static NSString * const MY_ADDRESS_CELL = @"myAddressCell";
static NSString * const MY_SHIPPING_CELL = @"myShippingCell";
static NSString * const MY_SHIPPING_SELECT_CELL = @"myShippingSelectCell";
static NSString * const MY_PAYMENT_CELL = @"myPaymentCell";
static NSString * const MY_USER_CELL = @"myUserNeedCell";

@interface MyCheckOutViewController ()<UITableViewDelegate, UITableViewDataSource, WXApiManagerDelegate>

@property (nonatomic, strong) UITableView *checkoutTV;
@property (nonatomic, strong) UIButton *checkOutBTN;
@property (nonatomic, strong) NSArray *sectionTitleArr;
@property (nonatomic, strong) NSArray *shipArr;
@property (nonatomic, strong) NSDictionary *checkOutDic;
@property (nonatomic, strong) NSDictionary *addressDic;
@property (nonatomic, strong) NSString *shipType;
@property (nonatomic, strong) NSString *payType;

@end

@implementation MyCheckOutViewController

- (void) viewWillAppear:(BOOL)animated {
    
    NSString *tmpId = [[TMCache sharedCache] objectForKey:@"addressId"];
    if (tmpId != nil) {
        
        _addressId = tmpId;
        
        [[TMCache sharedCache] removeObjectForKey:@"addressId"];
    }
    
    [self getPreCheckOut:_shipType addressId:_addressId];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[HttpManager instance] cancelAllOperations];
    [SVProgressHUD dismiss];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customizeBackItem];
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    
    [WXApiManager sharedManager].delegate = self;
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    
    [self setStyle];
    [self getPreCheckOut:_shipType addressId:_addressId];
}

#pragma mark - 初始化样式
- (void) setStyle {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = NSLocalizedString(@"TEXT_CONFIRM_ORDER", nil);
    
    self.checkoutTV = [UITableView newAutoLayoutView];
    [self.view addSubview:_checkoutTV];
    
    [_checkoutTV autoPinToTopLayoutGuideOfViewController:self withInset:-64];
    [_checkoutTV autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view];
    [_checkoutTV autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view withOffset:-50];
    [_checkoutTV autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view];
    
    _checkoutTV.delegate = self;
    _checkoutTV.dataSource = self;
    
    [_checkoutTV registerClass:[MyCheckOutTableViewCell class] forCellReuseIdentifier:MY_CHECKOUT_CELL];
    [_checkoutTV registerClass:[MyCheckOutTableViewCell class] forCellReuseIdentifier:MY_ADDRESS_CELL];
    [_checkoutTV registerClass:[MyCheckOutTableViewCell class] forCellReuseIdentifier:MY_SHIPPING_CELL];
    [_checkoutTV registerClass:[MyCheckOutTableViewCell class] forCellReuseIdentifier:MY_SHIPPING_SELECT_CELL];
    [_checkoutTV registerClass:[MyCheckOutTableViewCell class] forCellReuseIdentifier:MY_PAYMENT_CELL];
    [_checkoutTV registerClass:[MyCheckOutTableViewCell class] forCellReuseIdentifier:MY_USER_CELL];
    
    self.checkOutBTN = [UIButton newAutoLayoutView];
    [self.view addSubview:_checkOutBTN];
    
    [_checkOutBTN autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_checkoutTV];
    [_checkOutBTN autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view];
    [_checkOutBTN autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view];
    [_checkOutBTN autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view];
    
    [_checkOutBTN setTitle:NSLocalizedString(@"BTN_CONFIRM_PAY", nil) forState:UIControlStateNormal];
    [_checkOutBTN setBackgroundColor:RED_CART_BG];
    [_checkOutBTN addTarget:self action:@selector(clickCheckOutBTN) forControlEvents:UIControlEventTouchUpInside];
    
    _sectionTitleArr = @[NSLocalizedString(@"TEXT_SHIPPING_ADDRESS", nil),
                         NSLocalizedString(@"TEXT_CONFIRM_PRICE", nil),
                         NSLocalizedString(@"TEXT_SHIPPING_TYPE", nil),
                         NSLocalizedString(@"TEXT_PAYMENT_TYPE", nil),
                         NSLocalizedString(@"TEXT_USER_NEED", nil)];
    
//    _shipArr = @[@"EMS", @"航空件", @"船运"];
    _addressId = @"0";
    _shipType = @"1";
    _payType = @"wxpay";
    
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        return 3;
    }else if (section == 2){
        return [_shipArr count];
    }else{
        return 1;
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 || indexPath.section == 3) {
        return 80;
    }else if (indexPath.section == 1){
        if (indexPath.row == 1) {
            return 80;
        }else{
            return 60;
        }
    }else{
        return 60;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

//- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    return 30;
//}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *titleV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
    titleV.backgroundColor = GRAY_COLOR_CELL_LINE;
    UILabel *titleLB = [UILabel newAutoLayoutView];
    [titleV addSubview:titleLB];
    
    [titleLB autoAlignAxis:ALAxisHorizontal toSameAxisOfView:titleLB];
    [titleLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:titleV withOffset:20];
    [titleLB autoSetDimensionsToSize:CGSizeMake(ScreenWidth, 30)];
    titleLB.font = FONT_SIZE_16;
    titleLB.textColor = GRAY_FONT_COLOR;
    titleLB.text = [NSString stringWithFormat:@"%@", [_sectionTitleArr objectAtIndex:section]];
    titleLB.backgroundColor = GRAY_COLOR_CELL_LINE;
    
    return titleV;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyCheckOutTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MY_CHECKOUT_CELL forIndexPath:indexPath];
//    cell.titleLB.text = @"商品价格";
//    cell.priceLB.text = @"$100.00";
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == 0) {
        cell.titleLB.text = NSLocalizedString(@"TEXT_SELECT_ADDRESS", nil);
        cell.priceLB.text = @"";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

        if ([_addressDic count] > 0) {
            [cell removeFromSuperview];
            MyCheckOutTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MY_ADDRESS_CELL forIndexPath:indexPath];
            cell.titleLB.text = [_addressDic objectForKey:@"name"];
            cell.shippingLB.text = [_addressDic objectForKey:@"address"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return cell;
        }
    }else if (indexPath.section == 1){
        [cell removeFromSuperview];
        
        if (indexPath.row == 0){
            cell.titleLB.text = NSLocalizedString(@"TEXT_PRODUCT_TOTAL_FEE", nil);
            cell.priceLB.text = [NSString stringWithFormat:@"￥%@", [_checkOutDic objectForKey:@"product_price_total"]];
        }else if (indexPath.row == 1) {
            MyCheckOutTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MY_SHIPPING_CELL forIndexPath:indexPath];
            cell.titleLB.text = NSLocalizedString(@"TEXT_INTALNATIONAL_SHIP", nil);
            cell.priceLB.text = [NSString stringWithFormat:@"￥%@", [_checkOutDic objectForKey:@"shipping_price"]];
            cell.shippingLB.text = [NSString stringWithFormat:NSLocalizedString(@"TEXT_SHIP_NOTE", nil), [_checkOutDic objectForKey:@"weight_total"]];
            
            return cell;
        }else{
            cell.titleLB.text = NSLocalizedString(@"TEXT_TOTAL_FEE", nil);
            cell.priceLB.text = [NSString stringWithFormat:@"￥%@", [_checkOutDic objectForKey:@"price_total"]];
        }
    }else if (indexPath.section == 2){
        
        [cell removeFromSuperview];
        
        MyCheckOutTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MY_SHIPPING_SELECT_CELL forIndexPath:indexPath];
        
        NSDictionary *tmpShip = [_shipArr objectAtIndex:indexPath.row];
        
        cell.titleLB.text = [tmpShip objectForKey:@"name"];
        cell.shippingLB.text = [tmpShip objectForKey:@"ship_day"];
        cell.priceLB.text = [NSString stringWithFormat:@"￥%@", [tmpShip objectForKey:@"shipping_zh"]];
        
        if ([[tmpShip objectForKey:@"selected"] isEqualToString:@"1"]) {
            cell.selectImg.image = [UIImage imageNamed:@"checkboxChecked"];
        }else{
            cell.selectImg.image = [UIImage imageNamed:@"checkboxUncheck"];
        }
        
        return cell;
    }else if (indexPath.section == 3){
        [cell removeFromSuperview];
        
        MyCheckOutTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MY_PAYMENT_CELL forIndexPath:indexPath];
        cell.tapPayAction = ^(NSInteger index){
            if (index == 1) {
                _payType = @"wxpay";
            }else if (index == 2){
                _payType = @"alipay";
            }
        };
        return cell;
    }else{
        [cell removeFromSuperview];
        MyCheckOutTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MY_USER_CELL forIndexPath:indexPath];
        cell.titleLB.attributedText = [self textFormat:NSLocalizedString(@"TEXT_CHECKOUT_NOTE", nil)];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        MyAddressViewController *addressV = [[MyAddressViewController alloc] init];
        addressV.hasEdit = NO;
        if ([_addressDic count] > 0) {
            addressV.selectedID = [_addressDic objectForKey:@"id"];
        }
        [self.navigationController pushViewController:addressV animated:YES];
    }else if(indexPath.section == 2){
        _shipType = [[_shipArr objectAtIndex:indexPath.row] objectForKey:@"id"];
        
        [self getPreCheckOut:_shipType addressId:_addressId];
    }else if (indexPath.section == 4) {
        MyWebViewController *webVC = [[MyWebViewController alloc] init];
        
        webVC.webUrl = @"http://api.nijigo.com/Product/userProtocol/type/1.html";
        
        webVC.navigationItem.title = NSLocalizedString(@"TEXT_USER_NEED", nil);
        
        [self.navigationController pushViewController:webVC animated:YES];
    }
}

#pragma mark - 获取预览数据
- (void) getPreCheckOut:(NSString *)shipType addressId:(NSString *)addressId {
    
    [SVProgressHUD show];
    
    NSMutableDictionary *paramter = [NSMutableDictionary dictionary];
    [paramter setObject:[NSString stringWithFormat:@"%@", [CHSSID SSID]] forKey:@"ssid"];
    [paramter setObject:addressId forKey:@"aid"];
    [paramter setObject:shipType forKey:@"ship"];
    
    [[HttpManager instance] requestWithMethod:@"User/preCheckOut"
                                   parameters:paramter
                                      success:^(NSDictionary *result) {
                                          
                                          _checkOutDic = [result objectForKey:@"data"];
                                          
                                          _shipArr = [_checkOutDic objectForKey:@"shipping_type"];
                                          _addressDic = [_checkOutDic objectForKey:@"address"];
                                          if ([_addressDic count] > 0) {
                                              _addressId = [_addressDic objectForKey:@"id"];
                                          }
                                          
                                          [_checkoutTV reloadData];
                                          
                                          [SVProgressHUD dismiss];
                                      }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                          [SVProgressHUD showInfoWithStatus:[error localizedDescription] maskType:SVProgressHUDMaskTypeBlack];
                                      }];
}

#pragma mark - 设置价格样式
- (NSMutableAttributedString *) textFormat:(NSString *)str {
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:str];
    
    NSRange range = [str rangeOfString:@" "];
    NSUInteger rangLength = str.length - range.location;
    
    [text addAttribute:NSForegroundColorAttributeName value:RED_COLOR_BG range:NSMakeRange(range.location, rangLength)];
    
    [text addAttribute:NSFontAttributeName value:FONT_SIZE_16 range:NSMakeRange(range.location, rangLength)];
    
    return text;
}

#pragma mark - 确认并支付按钮
- (void) clickCheckOutBTN {
    
    if ([_addressId isEqualToString:@"0"]) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"TEXT_SELECT_ADDRESS", nil)];
        return;
    }
    
    [SVProgressHUD show];
    
    NSMutableDictionary *paramter = [NSMutableDictionary dictionary];
    [paramter setObject:[NSString stringWithFormat:@"%@", [CHSSID SSID]] forKey:@"ssid"];
    [paramter setObject:_addressId forKey:@"aid"];
    [paramter setObject:_payType forKey:@"pay"];
    [paramter setObject:@"1" forKey:@"ship"];
    
    [[HttpManager instance] requestWithMethod:@"User/payOrder"
                                   parameters:paramter
                                      success:^(NSDictionary *result) {

                                          NSDictionary *tmp = [result objectForKey:@"data"];
                                          
                                          if ([_payType isEqualToString:@"wxpay"]) {
                                              [WXApiRequestHandler jumpToWXPay:tmp];
                                          }else if ([_payType isEqualToString:@"alipay"]){
                                              
                                              NSURL *tmpUrl = [NSURL URLWithString:@"alipay://"];
                                              
                                              if ([[UIApplication sharedApplication] canOpenURL:tmpUrl]) {
                                                  [[AlipaySDK defaultService] payOrder:[tmp objectForKey:@"app_url"] fromScheme:@"nijigo" callback:^(NSDictionary *resultDic) {

                                                      
                                                      if ([[resultDic objectForKey:@"resultStatus"] isEqualToString:@"9000"]) {
                                                          [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"TEXT_PAY_SUCCESS", nil) maskType:SVProgressHUDMaskTypeBlack];
                                                      }else{
                                                          [SVProgressHUD showInfoWithStatus:[resultDic objectForKey:@"memo"] maskType:SVProgressHUDMaskTypeBlack];
                                                      }
                                                      
                                                      [self performSelector:@selector(popToRootVC) withObject:nil afterDelay:1.5f];
                                                  }];
                                              }else{
                                                  MyWebViewController *myWebVC = [[MyWebViewController alloc] init];
                                                  myWebVC.navigationItem.title = NSLocalizedString(@"TEXT_ALIPAY_PAY", nil);
                                                  myWebVC.webUrl = [tmp objectForKey:@"wap_url"];
                                                  myWebVC.isRoot = YES;
                                                  [self.navigationController pushViewController:myWebVC animated:YES];
                                              }
                                          }
                                          
                                          [SVProgressHUD dismiss];
                                      }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                          [SVProgressHUD showInfoWithStatus:[error localizedDescription] maskType:SVProgressHUDMaskTypeBlack];
                                      }];
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

    [self performSelector:@selector(popToRootVC) withObject:nil afterDelay:1.5f];

}

#pragma mark - 返回root页面
- (void) popToRootVC {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
