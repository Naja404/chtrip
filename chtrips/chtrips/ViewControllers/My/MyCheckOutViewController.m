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

static NSString * const MY_CHECKOUT_CELL = @"myCheckOutCell";
static NSString * const MY_ADDRESS_CELL = @"myAddressCell";
static NSString * const MY_SHIPPING_CELL = @"myShippingCell";
static NSString * const MY_SHIPPING_SELECT_CELL = @"myShippingSelectCell";
static NSString * const MY_PAYMENT_CELL = @"myPaymentCell";
static NSString * const MY_USER_CELL = @"myUserNeedCell";

@interface MyCheckOutViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *checkoutTV;
@property (nonatomic, strong) UIButton *checkOutBTN;
@property (nonatomic, strong) NSArray *sectionTitleArr;
@property (nonatomic, strong) NSArray *shipArr;
@property (nonatomic, strong) NSDictionary *checkOutDic;

@end

@implementation MyCheckOutViewController

- (void) viewWillAppear:(BOOL)animated {
    [self getPreCheckOut:@"1"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[HttpManager instance] cancelAllOperations];
    [SVProgressHUD dismiss];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customizeBackItem];
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    
    [self setStyle];
    [self getPreCheckOut:@"1"];
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
    
    [_checkOutBTN setTitle:@"确认并支付" forState:UIControlStateNormal];
    [_checkOutBTN setBackgroundColor:RED_COLOR_BG];
    
    _sectionTitleArr = @[NSLocalizedString(@"TEXT_SHIPPING_ADDRESS", nil),
                         NSLocalizedString(@"TEXT_CONFIRM_PRICE", nil),
                         NSLocalizedString(@"TEXT_SHIPPING_TYPE", nil),
                         NSLocalizedString(@"TEXT_PAYMENT_TYPE", nil),
                         NSLocalizedString(@"TEXT_USER_NEED", nil)];
    
//    _shipArr = @[@"EMS", @"航空件", @"船运"];
    
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
    if (indexPath.section == 0) {
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
    titleV.backgroundColor = [UIColor blackColor];
    UILabel *titleLB = [UILabel newAutoLayoutView];
    [titleV addSubview:titleLB];
    
    [titleLB autoAlignAxis:ALAxisHorizontal toSameAxisOfView:titleLB];
    [titleLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:titleV withOffset:20];
    [titleLB autoSetDimensionsToSize:CGSizeMake(ScreenWidth, 30)];
    titleLB.font = FONT_SIZE_16;
    titleLB.textColor = BLACK_FONT_COLOR;
    titleLB.text = [NSString stringWithFormat:@"%@", [_sectionTitleArr objectAtIndex:section]];
    titleLB.backgroundColor = GRAY_FONT_COLOR;
    
    return titleV;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyCheckOutTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MY_CHECKOUT_CELL forIndexPath:indexPath];
    cell.titleLB.text = @"商品价格";
    cell.priceLB.text = @"$100.00";
    if (indexPath.section == 0) {
        cell.titleLB.text = @"请选择配送地址";
        cell.priceLB.text = @"";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        NSString *hasAddress = @"yes";
        if ([hasAddress isEqualToString:@"no"]) {
            [cell removeFromSuperview];
            MyCheckOutTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MY_ADDRESS_CELL forIndexPath:indexPath];
            cell.titleLB.text = @"王子林";
            cell.shippingLB.text = @"上海市市辖区黄浦区制造局路787号112室\n13916656990";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return cell;
        }
    }else if (indexPath.section == 1){
        [cell removeFromSuperview];
        
        if (indexPath.row == 0){
            cell.titleLB.text = @"商品总价";
            cell.priceLB.text = [NSString stringWithFormat:@"￥%@", [_checkOutDic objectForKey:@"product_price_total"]];
        }else if (indexPath.row == 1) {
            MyCheckOutTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MY_SHIPPING_CELL forIndexPath:indexPath];
            cell.titleLB.text = @"国际运费";
            cell.priceLB.text = [NSString stringWithFormat:@"￥%@", [_checkOutDic objectForKey:@"shipping_price"]];
            cell.shippingLB.text = [NSString stringWithFormat:@"装箱重量(包括纸箱和防震材料):%@g", [_checkOutDic objectForKey:@"weight_total"]];
            
            return cell;
        }else{
            cell.titleLB.text = @"合计";
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
        
    }else{
        [cell removeFromSuperview];
        MyCheckOutTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MY_USER_CELL forIndexPath:indexPath];
        cell.titleLB.attributedText = [self textFormat:@"点击“确认并支付”,表示您已阅读并同意 用户须知"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        MyAddressViewController *webView = [[MyAddressViewController alloc] init];
        [self.navigationController pushViewController:webView animated:YES];
    }
}

#pragma mark - 获取预览数据
- (void) getPreCheckOut:(NSString *)shipType {
    
    [SVProgressHUD show];
    
    NSMutableDictionary *paramter = [NSMutableDictionary dictionary];
    [paramter setObject:[NSString stringWithFormat:@"%@", [CHSSID SSID]] forKey:@"ssid"];
    [paramter setObject:shipType forKey:@"type"];
    
    [[HttpManager instance] requestWithMethod:@"User/preCheckOut"
                                   parameters:paramter
                                      success:^(NSDictionary *result) {
                                          _checkOutDic = [result objectForKey:@"data"];
                                          
                                          _shipArr = [_checkOutDic objectForKey:@"shipping_type"];
                                          
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
