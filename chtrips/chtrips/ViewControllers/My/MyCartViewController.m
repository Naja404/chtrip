//
//  MyCartViewController.m
//  chtrips
//
//  Created by Hisoka on 16/1/7.
//  Copyright © 2016年 HSK.ltd. All rights reserved.
//

#import "MyCartViewController.h"
#import "MyCartTableViewCell.h"
#import "ShoppingDGDetailViewController.h"
#import "MyCheckOutViewController.h"

#define RED_TEXT [UIColor colorWithRed:255/255.0 green:17/255.0 blue:0/255.0 alpha:1]

static NSString * const MY_CARTLIST_CELL = @"MycartListCell";


@interface MyCartViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *cartListTV;
@property (nonatomic, strong) NSMutableArray *cartListData;
@property (nonatomic, strong) UILabel *priceZH;
@property (nonatomic, strong) UILabel *priceJP;
@property (nonatomic, strong) UIRefreshControl *refreshTV;
@property (nonatomic, strong) UIButton *checkoutBTN;
@property (nonatomic, strong) UIButton *selectAllBTN;
@property (nonatomic, strong) NSString *selectAllStatu;
@property (nonatomic, strong) UIImageView *bgView;

@end

@implementation MyCartViewController

- (void)viewWillDisappear:(BOOL)animated {
    [[HttpManager instance] cancelAllOperations];
    [SVProgressHUD dismiss];
}

- (void) viewWillAppear:(BOOL)animated {
    [self refresh:self.refreshTV];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customizeBackItem];
    [self getCartList];
    [self setupCartTV];
    [self refresh:self.refreshTV];
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 设置购物清单tableview
- (void) setupCartTV {
    self.navigationItem.title = NSLocalizedString(@"TEXT_MY_CART", nil);
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.cartListTV = [UITableView newAutoLayoutView];
    [self.view addSubview:_cartListTV];
    
    [_cartListTV autoPinToTopLayoutGuideOfViewController:self withInset:-60];
    [_cartListTV autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view];
    [_cartListTV autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view];
    [_cartListTV autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view withOffset:-47];
    
    _cartListTV.dataSource = self;
    _cartListTV.delegate = self;
    _cartListTV.separatorStyle = UITableViewCellAccessoryNone;
    _cartListTV.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    
    self.refreshTV= [[UIRefreshControl alloc] init];
    [_cartListTV addSubview:self.refreshTV];
    
    [_refreshTV addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    
    [_cartListTV registerClass:[MyCartTableViewCell class] forCellReuseIdentifier:MY_CARTLIST_CELL];
    _cartListTV.hidden = YES;
    
    // 设置总计栏
    UIView *totalBar = [UIView newAutoLayoutView];
    
    [self.view addSubview:totalBar];
    
    [totalBar autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view];
    [totalBar autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view];
    [totalBar autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view];
    [totalBar autoSetDimensionsToSize:CGSizeMake(ScreenWidth, 47)];
    totalBar.backgroundColor = [UIColor colorWithRed:254/255.0 green:255/255.0 blue:255/255.0 alpha:1];
    
    UILabel *topLine = [UILabel newAutoLayoutView];
    [totalBar addSubview:topLine];
    
    [topLine autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:totalBar];
    [topLine autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:totalBar];
    [topLine autoSetDimensionsToSize:CGSizeMake(ScreenWidth, 0.5)];
    topLine.backgroundColor = [UIColor colorWithRed:217/255.0 green:218/255.0 blue:219/255.0 alpha:1];
    
    self.selectAllBTN = [UIButton newAutoLayoutView];
    [totalBar addSubview:_selectAllBTN];
    
    [_selectAllBTN autoAlignAxis:ALAxisHorizontal toSameAxisOfView:totalBar];
    [_selectAllBTN autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:totalBar withOffset:10];
    [_selectAllBTN autoSetDimensionsToSize:CGSizeMake(20, 20)];
    [_selectAllBTN setBackgroundImage:[UIImage imageNamed:@"redUnSelect"] forState:UIControlStateNormal];
    [_selectAllBTN addTarget:self action:@selector(clickSelectAllBTN) forControlEvents:UIControlEventTouchUpInside];
    
    self.checkoutBTN = [UIButton newAutoLayoutView];
    [totalBar addSubview:_checkoutBTN];

    [_checkoutBTN autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:totalBar];
    [_checkoutBTN autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:totalBar];
    [_checkoutBTN autoSetDimensionsToSize:CGSizeMake(103, 46.5)];
    _checkoutBTN.backgroundColor = RED_TEXT;
    [_checkoutBTN setTitle:[NSString stringWithFormat:NSLocalizedString(@"BTN_CHECKOUT", nil), @"0"] forState:UIControlStateNormal];
    [_checkoutBTN addTarget:self action:@selector(pushCheckOutVC) forControlEvents:UIControlEventTouchUpInside];
    
    self.priceZH = [UILabel newAutoLayoutView];
    [totalBar addSubview:_priceZH];
    
    [_priceZH autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:totalBar withOffset:10];
    [_priceZH autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:_checkoutBTN withOffset:-10];
    [_priceZH autoSetDimensionsToSize:CGSizeMake(120, 20)];
    
    NSMutableAttributedString *price = [[NSMutableAttributedString alloc] initWithString:@"0.00"];
    
    [price addAttribute:NSForegroundColorAttributeName value:RED_TEXT range:NSMakeRange(0, 1)];
    [price addAttribute:NSForegroundColorAttributeName value:RED_TEXT range:NSMakeRange(1, 3)];
    
    [price addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, 1)];
    [price addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(1, 3)];
    _priceZH.attributedText = price;
    _priceZH.textAlignment = NSTextAlignmentRight;
    
    UILabel *totalLB = [UILabel newAutoLayoutView];
    [totalBar addSubview:totalLB];
    
    [totalLB autoAlignAxis:ALAxisHorizontal toSameAxisOfView:_priceZH];
    [totalLB autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_selectAllBTN withOffset:10];
    [totalLB autoSetDimensionsToSize:CGSizeMake(45, 18)];
    totalLB.textColor = HIGHLIGHT_BLACK_COLOR;
    totalLB.font = [UIFont systemFontOfSize:18];
    totalLB.text = NSLocalizedString(@"TEXT_TOTAL", nil);
    
    UILabel *notShipLB = [UILabel newAutoLayoutView];
    [totalBar addSubview:notShipLB];
    
    [notShipLB autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:totalBar withOffset:-5];
    [notShipLB autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:_checkoutBTN withOffset:-10];
    [notShipLB autoSetDimensionsToSize:CGSizeMake(50, 12)];
    notShipLB.font = [UIFont systemFontOfSize:12];
    notShipLB.textColor = HIGHLIGHT_BLACK_COLOR;
    notShipLB.text = NSLocalizedString(@"TEXT_NOT_INCLUDE_SHIPPING", nil);
    
    
    self.bgView = [UIImageView newAutoLayoutView];
    [self.view addSubview:_bgView];
    
    [_bgView autoAlignAxis:ALAxisVertical toSameAxisOfView:self.view];
    [_bgView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.view];
    [_bgView autoSetDimensionsToSize:CGSizeMake(90, 70)];
    _bgView.image = [UIImage imageNamed:@"defaultDataPic"];
    _bgView.hidden = YES;
    
}

#pragma mark - 结算按钮 
- (void) pushCheckOutVC {
    MyCheckOutViewController *myCheckoutVC = [[MyCheckOutViewController alloc] init];
    [self.navigationController pushViewController:myCheckoutVC animated:YES];
}

#pragma mark - 获取扫货清单数据
- (void) getCartList{
    
    NSMutableDictionary *paramter = [NSMutableDictionary dictionary];
    [SVProgressHUD show];
    [paramter setObject:[NSString stringWithFormat:@"%@", [CHSSID SSID]] forKey:@"ssid"];
    
    [[HttpManager instance] requestWithMethod:@"User/getCart"
                                   parameters:paramter
                                      success:^(NSDictionary *result) {
                                          
                                          NSDictionary *tmpData = [result objectForKey:@"data"];
                                          
                                          self.cartListData = [[tmpData objectForKey:@"list"] mutableCopy];
                                          NSString *str = [NSString stringWithFormat:@"¥%@", [tmpData objectForKey:@"price_zh_total"]];
                                          self.priceZH.attributedText = [self priceFormat:str];
                                          
                                          [_checkoutBTN setTitle:[NSString stringWithFormat:NSLocalizedString(@"BTN_CHECKOUT", nil), [tmpData objectForKey:@"select_count"]] forState:UIControlStateNormal];
                                          
                                          if ([[tmpData objectForKey:@"select_count"] isEqualToString:@"0"]) {
                                              _checkoutBTN.enabled = NO;
                                              _checkoutBTN.backgroundColor = GRAY_FONT_COLOR;
                                          }else{
                                              _checkoutBTN.enabled = YES;
                                              _checkoutBTN.backgroundColor = RED_TEXT;
                                          }
                                          
                                          if ([[tmpData objectForKey:@"select_all"] isEqualToString:@"1"]) {
                                              self.selectAllStatu = @"1";
                                              [self.selectAllBTN setBackgroundImage:[UIImage imageNamed:@"redSelect"] forState:UIControlStateNormal];
                                          }else{
                                              self.selectAllStatu = @"0";
                                              [self.selectAllBTN setBackgroundImage:[UIImage imageNamed:@"redUnSelect"] forState:UIControlStateNormal];
                                          }
                                          
                                          if ([self.cartListData count] == 0) {
                                              self.bgView.hidden = NO;
                                              _cartListTV.hidden = YES;
                                          }else{
                                              [_cartListTV reloadData];
                                              _cartListTV.hidden = NO;
                                              self.bgView.hidden = YES;
                                          }
                                          
                                          [SVProgressHUD dismiss];
                                          
                                      }
                                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                          [SVProgressHUD dismiss];
                                          
                                      }];
}

#pragma mark - 设置价格样式
- (NSMutableAttributedString *) priceFormat:(NSString *)str {
    NSMutableAttributedString *price = [[NSMutableAttributedString alloc] initWithString:str];
    
    NSUInteger rangLength = str.length - 3;
    
    [price addAttribute:NSForegroundColorAttributeName value:RED_TEXT range:NSMakeRange(0, rangLength)];
    [price addAttribute:NSForegroundColorAttributeName value:RED_TEXT range:NSMakeRange(rangLength, 3)];
    
    [price addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, rangLength)];
    [price addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(rangLength, 3)];
    
    return price;
}
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 85;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.cartListData count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyCartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MY_CARTLIST_CELL forIndexPath:indexPath];
    
    NSDictionary *cellData = [self.cartListData objectAtIndex:indexPath.row];
    
    NSURL *imageUrl = [NSURL URLWithString:[cellData objectForKey:@"thumb"]];
    
    [cell.productImage sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"defaultPicSmall"]];
    cell.titleZHLB.text = [cellData objectForKey:@"title_zh"];
    cell.summaryZHLB.text = [cellData objectForKey:@"summary_zh"];
    cell.priceZHLB.text = [NSString stringWithFormat:@"￥%@", [cellData objectForKey:@"price_zh"]];
    cell.checkStatu = [cellData objectForKey:@"select"];
    cell.pid = [cellData objectForKey:@"pid"];
    cell.proTotalLB.text = [cellData objectForKey:@"total"];
    
    if ([cell.checkStatu isEqualToString:@"0"]) {
        [cell.checkBTN setBackgroundImage:[UIImage imageNamed:@"redUnSelect"] forState:UIControlStateNormal];
        cell.selectState = NO;
    }else{
        [cell.checkBTN setBackgroundImage:[UIImage imageNamed:@"redSelect"] forState:UIControlStateNormal];
        cell.selectState = YES;
    }
    
    UITapGestureRecognizer *onceTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickCheckBTN:)];
    cell.checkBTN.userInteractionEnabled = YES;
    [cell.checkBTN addGestureRecognizer:onceTap];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    cell.plusProBTN.tag = [cell.pid intValue];
    cell.tapPlusBTNAction = ^(NSInteger index){
        [self upCartList:@"6" pid:[NSString stringWithFormat:@"%ld", (long)index]];
        
    };
    
    cell.minusProBTN.tag = [cell.pid intValue];
    cell.tapMinusBTNAction = ^(NSInteger index){

        [self upCartList:@"5" pid:[NSString stringWithFormat:@"%ld", (long)index]];
    };
    
    if ([[cellData objectForKey:@"minus"] isEqualToString:@"0"]) {
        cell.minusProBTN.hidden = YES;
    }else{
        cell.minusProBTN.hidden = NO;
    }
    
    if ([[cellData objectForKey:@"plus"] isEqualToString:@"0"]) {
        cell.plusProBTN.hidden = YES;
    }else{
        cell.plusProBTN.hidden = NO;
    }
    
    return cell;
}

#pragma mark - 设置cell编辑风格
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCellEditingStyle cellStyle = UITableViewCellEditingStyleNone;
    
    if ([tableView isEqual:_cartListTV]) cellStyle = UITableViewCellEditingStyleDelete;
    
    return cellStyle;
}

#pragma mark - cell编辑
- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {

        NSDictionary *tmpData = [_cartListData objectAtIndex:indexPath.row];
        [_cartListData removeObjectAtIndex:indexPath.row];

        NSArray *indexPaths = @[indexPath];
        [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationLeft];

        [self upCartList:@"2" pid:[tmpData objectForKey:@"pid"]];
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *cellData = [self.cartListData objectAtIndex:indexPath.row];
    
    ShoppingDGDetailViewController *detailVC = [[ShoppingDGDetailViewController alloc] init];
    
    detailVC.webUrl = [NSString stringWithFormat:@"http://api.nijigo.com/Product/showProDetail?pid=%@", [cellData objectForKey:@"pid"]];
    detailVC.pid = [NSString stringWithFormat:@"%@", [cellData objectForKey:@"pid"]];
    detailVC.zhPriceStr = [NSString stringWithFormat:@"%@", [cellData objectForKey:@"price_zh"]];
    detailVC.navigationItem.title = [cellData objectForKey:@"title_zh"];
    detailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - 单选按钮
- (void) clickCheckBTN:(UITapGestureRecognizer *)gr {
    
    MyCartTableViewCell *cell = (MyCartTableViewCell *) [[[gr view] superview] superview];
    
    if ([cell.checkStatu isEqualToString:@"0"]) {
        [cell.checkBTN setBackgroundImage:[UIImage imageNamed:@"redSelect"] forState:UIControlStateNormal];
        cell.checkStatu = @"1";
    }else{
        [cell.checkBTN setBackgroundImage:[UIImage imageNamed:@"redUnSelect"] forState:UIControlStateNormal];
        cell.checkStatu = @"0";
    }
    
    [self upCartList:cell.checkStatu pid:cell.pid];
    
}

#pragma mark - 全选按钮
- (void) clickSelectAllBTN {
    if ([self.selectAllStatu isEqualToString:@"0"]) {
        [self upCartList:@"3" pid:@"0"];
    }else{
        [self upCartList:@"4" pid:@"0"];
    }
}

#pragma mark - 更新选中数据
- (void) upCartList:(NSString *)type pid:(NSString *)pid {
    
    NSMutableDictionary *paramter = [NSMutableDictionary dictionary];
    [SVProgressHUD show];
    [paramter setObject:[NSString stringWithFormat:@"%@", [CHSSID SSID]] forKey:@"ssid"];
    [paramter setObject:type forKey:@"type"];
    [paramter setObject:pid forKey:@"pid"];
    
    [[HttpManager instance] requestWithMethod:@"User/setCart"
                                   parameters:paramter
                                      success:^(NSDictionary *result) {
                                          NSDictionary *tmpData = [result objectForKey:@"data"];
                                          self.cartListData = [[tmpData objectForKey:@"list"] mutableCopy];
                                          NSString *str = [NSString stringWithFormat:@"¥%@", [tmpData objectForKey:@"price_zh_total"]];
                                          self.priceZH.attributedText = [self priceFormat:str];

                                          [_checkoutBTN setTitle:[NSString stringWithFormat:@"结算(%@)", [tmpData objectForKey:@"select_count"]] forState:UIControlStateNormal];
                                          
                                          if ([[tmpData objectForKey:@"select_count"] isEqualToString:@"0"]) {
                                              _checkoutBTN.enabled = NO;
                                              _checkoutBTN.backgroundColor = GRAY_FONT_COLOR;
                                          }else{
                                              _checkoutBTN.enabled = YES;
                                              _checkoutBTN.backgroundColor = RED_TEXT;
                                          }
                                          
                                          if ([[tmpData objectForKey:@"select_all"] isEqualToString:@"1"]) {
                                              self.selectAllStatu = @"1";
                                              [self.selectAllBTN setBackgroundImage:[UIImage imageNamed:@"redSelect"] forState:UIControlStateNormal];
                                          }else{
                                              self.selectAllStatu = @"0";
                                              [self.selectAllBTN setBackgroundImage:[UIImage imageNamed:@"redUnSelect"] forState:UIControlStateNormal];
                                          }
                                          
                                          [_cartListTV reloadData];
                                          [SVProgressHUD dismiss];
                                      }
     
                                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                          [SVProgressHUD showInfoWithStatus:[error localizedDescription] maskType:SVProgressHUDMaskTypeBlack];
                                      }];
}

#pragma mark 下拉刷新
- (void) refresh:(UIRefreshControl *)control {
    [control beginRefreshing];
    [self getCartList];
    [control endRefreshing];
}

@end
