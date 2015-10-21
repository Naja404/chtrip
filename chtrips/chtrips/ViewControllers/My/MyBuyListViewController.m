//
//  MyBuyListViewController.m
//  chtrips
//
//  Created by Hisoka on 15/5/31.
//  Copyright (c) 2015年 HSK.ltd. All rights reserved.
//

#import "MyBuyListViewController.h"
#import "MyBuyListTableViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "ShoppingPopularityDetailViewController.h"
#import "MyBuyListTableViewCell.h"

#define RED_TEXT [UIColor colorWithRed:255/255.0 green:17/255.0 blue:0/255.0 alpha:1]

static NSString * const MY_BUYLIST_CELL = @"MyBuyListCell";


@interface MyBuyListViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *buyListTV;
@property (nonatomic, strong) NSMutableArray *buyListData;
@property (nonatomic, strong) UILabel *priceZH;
@property (nonatomic, strong) UILabel *priceJP;
@property (nonatomic, strong) UIRefreshControl *refreshTV;
@property (nonatomic, strong) UIButton *checkoutBTN;
@property (nonatomic, strong) UIButton *selectAllBTN;
@property (nonatomic, strong) NSString *selectAllStatu;
@property (nonatomic, strong) UIImageView *bgView;
@end

@implementation MyBuyListViewController

- (void)viewWillDisappear:(BOOL)animated {
    [[HttpManager instance] cancelAllOperations];
    [SVProgressHUD dismiss];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customizeBackItem];
    [self getBuyList];
    [self setupBuyListTV];
    [self refresh:self.refreshTV];
    // Do any additional setup after loading the view.
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 设置购物清单tableview
- (void) setupBuyListTV {
    
    self.view.backgroundColor = [UIColor whiteColor];
    

    self.buyListTV = [UITableView newAutoLayoutView];
    [self.view addSubview:_buyListTV];
    
    [_buyListTV autoPinToTopLayoutGuideOfViewController:self withInset:-60];
    [_buyListTV autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view];
    [_buyListTV autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view];
    [_buyListTV autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view withOffset:-47];
    
    _buyListTV.dataSource = self;
    _buyListTV.delegate = self;
    
    self.refreshTV= [[UIRefreshControl alloc] init];
    [_buyListTV addSubview:self.refreshTV];
    
    [_refreshTV addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    
    [self.buyListTV registerClass:[MyBuyListTableViewCell class] forCellReuseIdentifier:MY_BUYLIST_CELL];
    self.buyListTV.hidden = YES;
    
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
    
//    self.checkoutBTN = [UIButton newAutoLayoutView];
//    [totalBar addSubview:_checkoutBTN];
//    
//    [_checkoutBTN autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:totalBar];
//    [_checkoutBTN autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:totalBar];
//    [_checkoutBTN autoSetDimensionsToSize:CGSizeMake(103, 46.5)];
//    _checkoutBTN.backgroundColor = [UIColor colorWithRed:255/255.0 green:17/255.0 blue:0/255.0 alpha:1];
//    [_checkoutBTN setTitle:@"结算(0)" forState:UIControlStateNormal];
    
    self.priceZH = [UILabel newAutoLayoutView];
    [totalBar addSubview:_priceZH];
    
    [_priceZH autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:totalBar withOffset:10];
    [_priceZH autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:totalBar withOffset:-10];
    [_priceZH autoSetDimensionsToSize:CGSizeMake(70, 20)];
    
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
    [totalLB autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:_priceZH];
    [totalLB autoSetDimensionsToSize:CGSizeMake(45, 18)];
    totalLB.textColor = HIGHLIGHT_BLACK_COLOR;
    totalLB.font = [UIFont systemFontOfSize:18];
    totalLB.text = @"合计:";
    
    UILabel *notShipLB = [UILabel newAutoLayoutView];
    [totalBar addSubview:notShipLB];
    
    [notShipLB autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:totalBar withOffset:-5];
    [notShipLB autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:totalBar withOffset:-10];
    [notShipLB autoSetDimensionsToSize:CGSizeMake(50, 12)];
    notShipLB.font = [UIFont systemFontOfSize:12];
    notShipLB.textColor = HIGHLIGHT_BLACK_COLOR;
    notShipLB.text = @"不含运费";
    
    
    self.bgView = [UIImageView newAutoLayoutView];
    [self.view addSubview:_bgView];
    
    [_bgView autoAlignAxis:ALAxisVertical toSameAxisOfView:self.view];
    [_bgView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.view];
    [_bgView autoSetDimensionsToSize:CGSizeMake(95, 105)];
    _bgView.image = [UIImage imageNamed:@"defaultDataPic@2x.jpg"];
    _bgView.hidden = YES;
    
}


#pragma mark 获取扫货清单数据
- (void) getBuyList{
    
    NSMutableDictionary *paramter = [NSMutableDictionary dictionary];
    [SVProgressHUD show];
//    [paramter setObject:[CHSSID SSID] forKey:@"ssid"];
    [paramter setObject:[NSString stringWithFormat:@"%@", [CHSSID SSID]] forKey:@"ssid"];
    
    [[HttpManager instance] requestWithMethod:@"User/getBuyList"
                                   parameters:paramter
                                      success:^(NSDictionary *result) {
                                          self.buyListData = [[result objectForKey:@"data"] objectForKey:@"list"];
                                          NSString *str = [NSString stringWithFormat:@"¥%@", [[result objectForKey:@"data"] objectForKey:@"price_zh_total"]];
                                          self.priceZH.attributedText = [self priceFormat:str];
                                          
//                                          self.checkoutBTN.titleLabel.text = [NSString stringWithFormat:@"结算(%@)", [[result objectForKey:@"data"] objectForKey:@"selectCount"]];
                                          if ([[[result objectForKey:@"data"] objectForKey:@"selectAll"] isEqualToString:@"1"]) {
                                              self.selectAllStatu = @"1";
                                              [self.selectAllBTN setBackgroundImage:[UIImage imageNamed:@"redSelect"] forState:UIControlStateNormal];
                                          }else{
                                              self.selectAllStatu = @"0";
                                            [self.selectAllBTN setBackgroundImage:[UIImage imageNamed:@"redUnSelect"] forState:UIControlStateNormal];
                                          }

                                          if ([self.buyListData count] == 0) {
                                              self.bgView.hidden = NO;
                                              self.buyListTV.hidden = YES;
                                          }else{
                                             [self.buyListTV reloadData];
                                              self.buyListTV.hidden = NO;
                                              self.bgView.hidden = YES;
                                          }
                                          
                                          [SVProgressHUD dismiss];

                                      }
                                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                          [SVProgressHUD dismiss];

                                      }];
}

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
    return [self.buyListData count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyBuyListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MY_BUYLIST_CELL forIndexPath:indexPath];
    
    NSDictionary *cellData = [[NSDictionary alloc] initWithDictionary:[self.buyListData objectAtIndex:indexPath.row]];
    
    NSURL *imageUrl = [NSURL URLWithString:[cellData objectForKey:@"thumb"]];

    [cell.productImage setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"defaultPicSmall"]];
    cell.titleZHLB.text = [cellData objectForKey:@"title_zh"];
    cell.summaryZHLB.text = [cellData objectForKey:@"summary_zh"];
    cell.priceZHLB.text = [NSString stringWithFormat:@"%@ RMB", [cellData objectForKey:@"price_zh"]];
    cell.checkStatu = [cellData objectForKey:@"select"];
    cell.pid = [cellData objectForKey:@"pid"];
    
    if ([cell.checkStatu isEqualToString:@"0"]) {
        [cell.checkBTN setBackgroundImage:[UIImage imageNamed:@"redUnSelect"] forState:UIControlStateNormal];
    }else{
        [cell.checkBTN setBackgroundImage:[UIImage imageNamed:@"redSelect"] forState:UIControlStateNormal];
    }
    
    UITapGestureRecognizer *onceTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickCheckBTN:)];
    cell.checkBTN.userInteractionEnabled = YES;
    [cell.checkBTN addGestureRecognizer:onceTap];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    
    return cell;
}

- (void) clickCheckBTN:(UITapGestureRecognizer *)gr {
    
    MyBuyListTableViewCell *cell = (MyBuyListTableViewCell *) [[[gr view] superview] superview];
    
    if ([cell.checkStatu isEqualToString:@"0"]) {
        [cell.checkBTN setBackgroundImage:[UIImage imageNamed:@"redSelect"] forState:UIControlStateNormal];
        cell.checkStatu = @"1";
    }else{
        [cell.checkBTN setBackgroundImage:[UIImage imageNamed:@"redUnSelect"] forState:UIControlStateNormal];
        cell.checkStatu = @"0";
    }
    
    [self upBuyList:cell.checkStatu pid:cell.pid];
    
}

- (void) clickSelectAllBTN {
    if ([self.selectAllStatu isEqualToString:@"0"]) {
        [self upBuyList:@"3" pid:@"0"];
    }else{
        [self upBuyList:@"4" pid:@"0"];
    }
}

#pragma mark 更新选中数据

- (void) upBuyList:(NSString *)type pid:(NSString *)pid {
    
    NSMutableDictionary *paramter = [NSMutableDictionary dictionary];
    [SVProgressHUD show];
    [paramter setObject:[NSString stringWithFormat:@"%@", [CHSSID SSID]] forKey:@"ssid"];
    [paramter setObject:type forKey:@"type"];
    [paramter setObject:pid forKey:@"pid"];
    
    [[HttpManager instance] requestWithMethod:@"User/setBuyList"
                                   parameters:paramter
                                      success:^(NSDictionary *result) {
                                          self.buyListData = [[result objectForKey:@"data"] objectForKey:@"list"];
                                          NSString *str = [NSString stringWithFormat:@"¥%@", [[result objectForKey:@"data"] objectForKey:@"price_zh_total"]];
                                          self.priceZH.attributedText = [self priceFormat:str];
                                          
//                                          self.checkoutBTN.titleLabel.text = [NSString stringWithFormat:@"结算(%@)", [[result objectForKey:@"data"] objectForKey:@"selectCount"]];
                                          
                                          if ([[[result objectForKey:@"data"] objectForKey:@"selectAll"] isEqualToString:@"1"]) {
                                              self.selectAllStatu = @"1";
                                              [self.selectAllBTN setBackgroundImage:[UIImage imageNamed:@"redSelect"] forState:UIControlStateNormal];
                                          }else{
                                              self.selectAllStatu = @"0";
                                              [self.selectAllBTN setBackgroundImage:[UIImage imageNamed:@"redUnSelect"] forState:UIControlStateNormal];
                                          }

                                          [self.buyListTV reloadData];
                                          [SVProgressHUD dismiss];
                                      }
     
                                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                          [SVProgressHUD dismiss];
                                      }];
}


#pragma mark 下拉刷新
- (void) refresh:(UIRefreshControl *)control {
    [control beginRefreshing];
    [self getBuyList];
    [control endRefreshing];
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
