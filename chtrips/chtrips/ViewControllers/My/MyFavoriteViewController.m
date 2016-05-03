//
//  MyFavoriteViewController.m
//  chtrips
//
//  Created by Hisoka on 16/4/25.
//  Copyright © 2016年 HSK.ltd. All rights reserved.
//

#import "MyFavoriteViewController.h"
#import "DiscoveryTableViewCell.h"
#import "PlayInsideDetailViewController.h"
#import "ShoppingDGDetailViewController.h"
#import "DiscoveryDetailViewController.h"
#import "HMSegmentedControl.h"
#import "PlayTableViewCell.h"
#import "MyBuyListTableViewCell.h"

static NSString * const ALBUM_CELL = @"albumCell";
static NSString * const WANTGO_CELL = @"wantGoCell";
static NSString * const WANTBUY_CELL = @"wantBuyCell";

@interface MyFavoriteViewController ()<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *bgScrollV;
@property (nonatomic, strong) UITableView *wantGoTV;
@property (nonatomic, strong) UITableView *wantBuyTV;
@property (nonatomic, strong) UITableView *albumTV;
@property (nonatomic, strong) NSMutableArray *albumData;
@property (nonatomic, strong) NSMutableArray *wantGoData;
@property (nonatomic, strong) NSMutableDictionary *wantBuyData;
@property (nonatomic, strong) UIRefreshControl *refreshTV;
@property (nonatomic, strong) UIImageView *bgView;
@property (nonatomic, strong) UIView *cateMenuView;
@property (nonatomic, strong) HMSegmentedControl *segmentedControl;
@property (nonatomic, strong) UILabel *wantGoLB;
@property (nonatomic, strong) UILabel *wantBuyLB;
@property (nonatomic, strong) UILabel *albumLB;

@end

@implementation MyFavoriteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [super viewDidLoad];
    [self customizeBackItem];
    [self initTableView];
    [self refresh:self.refreshTV];
  
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
}

#pragma mark - 初始化tableview
- (void) initTableView {
    self.view.backgroundColor = [UIColor whiteColor];

    self.cateMenuView = [UIView newAutoLayoutView];
    [self.view addSubview:_cateMenuView];
    
    [_cateMenuView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.view withOffset:64];
    [_cateMenuView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view];
    [_cateMenuView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view];
    [_cateMenuView autoSetDimensionsToSize:CGSizeMake(ScreenWidth, 30)];
    _cateMenuView.backgroundColor = MENU_DEFAULT_COLOR;
    
    self.segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[NSLocalizedString(@"TEXT_ALBUM", nil), NSLocalizedString(@"TEXT_MY_WANT_GO", nil), NSLocalizedString(@"TEXT_WANT_BUY", nil)]];
    [_segmentedControl setFrame:CGRectMake(0, 0, ScreenWidth, 44)];
    [_segmentedControl setBackgroundColor:[UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1]];
    [_segmentedControl setSelectionIndicatorMode:HMSelectionIndicatorResizesToStringWidth];
    
    __weak typeof (self) weakSelf = self;
    
    [_segmentedControl setIndexChangeBlock:^(NSUInteger index) {
        [weakSelf.bgScrollV setContentOffset:CGPointMake(ScreenWidth*index, 0) animated:YES];
    }];
    
    [self.cateMenuView addSubview:_segmentedControl];
    
    
    self.bgScrollV = [UIScrollView newAutoLayoutView];
    [self.view addSubview:_bgScrollV];
    
    [_bgScrollV autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_cateMenuView withOffset:14];
    [_bgScrollV autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view];
    [_bgScrollV autoSetDimensionsToSize:CGSizeMake(ScreenWidth, ScreenHeight - 108)];
    _bgScrollV.delegate = self;
    _bgScrollV.contentSize = CGSizeMake(ScreenWidth*3, ScreenHeight - 108);
    _bgScrollV.pagingEnabled = YES;
    _bgScrollV.showsHorizontalScrollIndicator = NO;
    
    // 专辑
    self.albumTV = [UITableView newAutoLayoutView];
    [_bgScrollV addSubview:_albumTV];
    
    [_albumTV autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:_bgScrollV];
    [_albumTV autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_bgScrollV];
    [_albumTV autoSetDimensionsToSize:CGSizeMake(ScreenWidth, ScreenHeight - 108)];
    
    _albumTV.delegate = self;
    _albumTV.dataSource = self;
    _albumTV.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [_albumTV registerClass:[DiscoveryTableViewCell class] forCellReuseIdentifier:ALBUM_CELL];
    
    self.albumLB = [UILabel newAutoLayoutView];
    [_bgScrollV addSubview:_albumLB];
    
    [_albumLB autoAlignAxis:ALAxisVertical toSameAxisOfView:_albumTV];
    [_albumLB autoAlignAxis:ALAxisHorizontal toSameAxisOfView:_albumTV];
    [_albumLB autoSetDimensionsToSize:CGSizeMake(ScreenWidth, 40)];
    _albumLB.textAlignment = NSTextAlignmentCenter;
    _albumLB.text = NSLocalizedString(@"TEXT_EMPTY_LABEL", nil);
    _albumLB.textColor = GRAY_FONT_COLOR;
    _albumLB.hidden = YES;
    
    // 我想去
    self.wantGoTV = [UITableView newAutoLayoutView];
    [_bgScrollV addSubview:_wantGoTV];
    
    [_wantGoTV autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:_bgScrollV];
    [_wantGoTV autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_albumTV];
    [_wantGoTV autoSetDimensionsToSize:CGSizeMake(ScreenWidth, ScreenHeight - 108)];
    
    _wantGoTV.delegate = self;
    _wantGoTV.dataSource = self;
    _wantGoTV.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [_wantGoTV registerClass:[PlayTableViewCell class] forCellReuseIdentifier:WANTGO_CELL];
    
    self.wantGoLB = [UILabel newAutoLayoutView];
    [_bgScrollV addSubview:_wantGoLB];
    
    [_wantGoLB autoAlignAxis:ALAxisVertical toSameAxisOfView:_wantGoTV];
    [_wantGoLB autoAlignAxis:ALAxisHorizontal toSameAxisOfView:_wantGoTV];
    [_wantGoLB autoSetDimensionsToSize:CGSizeMake(ScreenWidth, 40)];
    _wantGoLB.textAlignment = NSTextAlignmentCenter;
    _wantGoLB.text = NSLocalizedString(@"TEXT_EMPTY_LABEL", nil);
    _wantGoLB.textColor = GRAY_FONT_COLOR;
    _wantGoLB.hidden = YES;
    
    // 我想买
    self.wantBuyTV = [UITableView newAutoLayoutView];
    [_bgScrollV addSubview:_wantBuyTV];
    
    [_wantBuyTV autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:_bgScrollV];
    [_wantBuyTV autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_wantGoTV];
    [_wantBuyTV autoSetDimensionsToSize:CGSizeMake(ScreenWidth, ScreenHeight - 108)];
    
    _wantBuyTV.delegate = self;
    _wantBuyTV.dataSource = self;
    _wantBuyTV.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [_wantBuyTV registerClass:[MyBuyListTableViewCell class] forCellReuseIdentifier:WANTBUY_CELL];
    
    self.wantBuyLB = [UILabel newAutoLayoutView];
    [_bgScrollV addSubview:_wantBuyLB];
    
    [_wantBuyLB autoAlignAxis:ALAxisVertical toSameAxisOfView:_wantBuyTV];
    [_wantBuyLB autoAlignAxis:ALAxisHorizontal toSameAxisOfView:_wantBuyTV];
    [_wantBuyLB autoSetDimensionsToSize:CGSizeMake(ScreenWidth, 40)];
    _wantBuyLB.textAlignment = NSTextAlignmentCenter;
    _wantBuyLB.text = NSLocalizedString(@"TEXT_EMPTY_LABEL", nil);
    _wantBuyLB.textColor = GRAY_FONT_COLOR;
    _wantBuyLB.hidden = YES;
    
}
#pragma mark - 监控scrollview 滑动并指向分类下
- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    NSUInteger currentPage = floor((_bgScrollV.contentOffset.x - ScreenWidth / 2) / ScreenWidth) + 1;
    [_segmentedControl setSelectedIndex:currentPage animated:YES];
    
}

#pragma mark - 设置专辑列表
- (void) setAlbumList {
    self.view.backgroundColor = [UIColor whiteColor];
    self.albumTV = [UITableView newAutoLayoutView];
    [self.view addSubview:_albumTV];
    
    [_albumTV autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.view withOffset:64];
    [_albumTV autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view];
    [_albumTV autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view];
    [_albumTV autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view];
    
    _albumTV.delegate = self;
    _albumTV.dataSource = self;
    _albumTV.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.refreshTV = [[UIRefreshControl alloc] init];
    [_albumTV addSubview:_refreshTV];
    [_refreshTV addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    
    [self.albumTV registerClass:[DiscoveryTableViewCell class] forCellReuseIdentifier:ALBUM_CELL];
    self.albumTV.hidden = YES;
    
    self.bgView = [UIImageView newAutoLayoutView];
    [self.view addSubview:_bgView];
    
    [_bgView autoAlignAxis:ALAxisVertical toSameAxisOfView:self.view];
    [_bgView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.view];
    [_bgView autoSetDimensionsToSize:CGSizeMake(90, 70)];
    _bgView.image = [UIImage imageNamed:@"defaultDataPic"];
    _bgView.hidden = YES;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == _wantGoTV) {
        if ([self.wantGoData count] <= 0) {
            return 0;
        }else{
            return [self.wantGoData count];
        }
    }else if (tableView == _wantBuyTV){
        if ([[self.wantBuyData objectForKey:@"list"] count] <= 0) {
            return 0;
        }else{
            return [[self.wantBuyData objectForKey:@"list"] count];
        }

    }else{
        if ([self.albumData count] <= 0) {
            return 0;
        }else{
            return [self.albumData count];
        }
    }
    
    return 0;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == _albumTV) {
        if (indexPath.row == self.albumData.count - 1) {
            return ScreenWidth;
        }else{
            return ScreenWidth + 10;
        }
    }
    
    return 85;
}


- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == _wantGoTV) {
        
        PlayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:WANTGO_CELL];
        
        NSDictionary *cellData = [[NSDictionary alloc] initWithDictionary:[self.wantGoData objectAtIndex:indexPath.row]];
        
        NSURL *imageUrl = [NSURL URLWithString:[cellData objectForKey:@"pic_url"]];
        [cell.proImg sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"defaultPicSmall"]];
        
        cell.bigTitleLB.text = [cellData objectForKey:@"name"];
        cell.avgLB.text = [cellData objectForKey:@"avg_price"];
        cell.areaLB.text = [NSString stringWithFormat:@"%@", [cellData objectForKey:@"area"]];
        cell.cateLB.text = [NSString stringWithFormat:@"%@", [cellData objectForKey:@"category"]];
        cell.starImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"star_%@", [cellData objectForKey:@"avg_rating"]]];
        
        if ([[cellData objectForKey:@"is_gnav"] isEqualToString:@"1"]) {
            cell.sourceLB.hidden = NO;
        }else{
            cell.sourceLB.hidden = YES;
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    
    if (tableView == _wantBuyTV) {
        MyBuyListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:WANTBUY_CELL forIndexPath:indexPath];
        
        NSDictionary *cellData = [[NSDictionary alloc] initWithDictionary:[[self.wantBuyData objectForKey:@"list"] objectAtIndex:indexPath.row]];
        
        NSURL *imageUrl = [NSURL URLWithString:[cellData objectForKey:@"thumb"]];
        
        [cell.productImage sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"defaultPicSmall"]];
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
    
    
    if (tableView == _albumTV) {
        DiscoveryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ALBUM_CELL forIndexPath:indexPath];
        
        NSDictionary *cellData = [[NSDictionary alloc] initWithDictionary:[self.albumData objectAtIndex:indexPath.row]];
        
        NSURL *imageUrl = [NSURL URLWithString:[cellData objectForKey:@"path"]];
        [cell.bgImg sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"defaultPicBig"]];
        
        cell.titleLB.text = [[cellData objectForKey:@"title"] stringByReplacingOccurrencesOfString:@"*" withString:@"\n"];
        cell.timeLB.text = [cellData objectForKey:@"outTime"];
        
        if (![[cellData objectForKey:@"address_title"] isEqualToString:@""]) {
            cell.mapLB.text = [cellData objectForKey:@"address_title"];
            cell.locationImg.hidden = NO;
        }else{
            cell.mapLB.text = @"";
            cell.locationImg.hidden = YES;
        }
        
        if ([[cellData objectForKey:@"title_btn"] isEqualToString:@""]) {
            cell.buyBTN.text = @"";
            cell.buyBTN.hidden = YES;
        }else{
            cell.buyBTN.text = [cellData objectForKey:@"title_btn"];
            cell.buyBTN.hidden = NO;
            cell.buyBTN.backgroundColor = [self setBuyBTN:[cellData objectForKey:@"colorNum"]];
        }
        
        if ([[cellData objectForKey:@"activityTime"] isEqualToString:@"0"]) {
            cell.activityTimeLB.text = @"";
            cell.activityTimeLB.hidden = YES;
        }else{
            cell.activityTimeLB.text =[cellData objectForKey:@"activityTime"];
            cell.activityTimeLB.hidden = NO;
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    
    return nil;
}

#pragma mark - 设置 想买 结算
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

#pragma mark - 更新想买
- (void) upBuyList:(NSString *)type pid:(NSString *)pid {
    
    NSMutableDictionary *paramter = [NSMutableDictionary dictionary];
    [SVProgressHUD show];
    [paramter setObject:[NSString stringWithFormat:@"%@", [CHSSID SSID]] forKey:@"ssid"];
    [paramter setObject:type forKey:@"type"];
    [paramter setObject:pid forKey:@"pid"];
    
    [[HttpManager instance] requestWithMethod:@"User/setBuyList"
                                   parameters:paramter
                                      success:^(NSDictionary *result) {
                                          
//                                          NSDictionary *tmpData = [result objectForKey:@"data"];
//                                          self.buyListData = [[tmpData objectForKey:@"list"] mutableCopy];
//                                          
//                                          NSString *str = [NSString stringWithFormat:@"¥%@", [[result objectForKey:@"data"] objectForKey:@"price_zh_total"]];
//                                          self.priceZH.attributedText = [self priceFormat:str];
//                                          
//                                          //                                          self.checkoutBTN.titleLabel.text = [NSString stringWithFormat:@"结算(%@)", [[result objectForKey:@"data"] objectForKey:@"selectCount"]];
//                                          
//                                          if ([[[result objectForKey:@"data"] objectForKey:@"selectAll"] isEqualToString:@"1"]) {
//                                              self.selectAllStatu = @"1";
//                                              [self.selectAllBTN setBackgroundImage:[UIImage imageNamed:@"redSelect"] forState:UIControlStateNormal];
//                                          }else{
//                                              self.selectAllStatu = @"0";
//                                              [self.selectAllBTN setBackgroundImage:[UIImage imageNamed:@"redUnSelect"] forState:UIControlStateNormal];
//                                          }
//                                          
//                                          [self.buyListTV reloadData];
                                          [SVProgressHUD dismiss];
                                      }
     
                                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                          [SVProgressHUD showInfoWithStatus:[error localizedDescription] maskType:SVProgressHUDMaskTypeBlack];
                                      }];
}

- (UIColor *) setBuyBTN:(NSString *)colorNum {
    
    if ([colorNum isEqualToString:@"1"]) {
        return RED_COLOR_BG;
    }else if ([colorNum isEqualToString:@"2"]){
        return BLUE_COLOR_BG;
    }else if ([colorNum isEqualToString:@"3"]){
        return ORINGE_COLOR_BG;
    }else{
        return GREEN_COLOR_BG;
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (tableView == _wantGoTV) {
        // 新版商家详情
        PlayInsideDetailViewController *detailVC = [[PlayInsideDetailViewController alloc] init];
        NSDictionary *cellData = [[NSDictionary alloc] initWithDictionary:[self.wantGoData objectAtIndex:indexPath.row]];
        
        detailVC.sid = [cellData objectForKey:@"saler_id"];
        if ([[cellData objectForKey:@"type"]  isEqualToString:@"3"]) {
            detailVC.isHotel = @"1";
        }else{
            detailVC.isHotel = @"0";
        }
        detailVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detailVC animated:YES];
        
    }else if(tableView == _wantBuyTV) {
        
        NSDictionary *cellData = [[NSDictionary alloc] initWithDictionary:[[self.wantBuyData objectForKey:@"list"] objectAtIndex:indexPath.row]];
        
        ShoppingDGDetailViewController *detailVC = [[ShoppingDGDetailViewController alloc] init];
        
        detailVC.webUrl = [NSString stringWithFormat:@"http://api.nijigo.com/Product/showProDetailNew?pid=%@", [cellData objectForKey:@"pid"]];
        detailVC.pid = [NSString stringWithFormat:@"%@", [cellData objectForKey:@"pid"]];
        detailVC.zhPriceStr = [NSString stringWithFormat:@"%@", [cellData objectForKey:@"price_zh"]];
        detailVC.navigationItem.title = [cellData objectForKey:@"title_zh"];
        detailVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detailVC animated:YES];
        
    }else{
        
        DiscoveryDetailViewController *detail = [[DiscoveryDetailViewController alloc] init];
        NSDictionary *cellData = [[NSDictionary alloc] initWithDictionary:[self.albumData objectAtIndex:indexPath.row]];
        
        detail.webUrl = [NSString stringWithFormat:@"http://api.nijigo.com/Product/showAlbum/aid/%@/ssid/%@.html", [cellData objectForKey:@"aid"], [CHSSID SSID]];
        detail.albumDic = cellData;
        detail.navigationItem.title = [cellData objectForKey:@"type_name"];
        
        detail.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:detail animated:YES];
    }

}

#pragma makr - 获取收藏列表
- (void) getFavoriteList {
    [SVProgressHUD show];
    
    NSMutableDictionary *paramter = [NSMutableDictionary dictionary];
    [paramter setObject:[NSString stringWithFormat:@"%@", [CHSSID SSID]] forKey:@"ssid"];
    
    [[HttpManager instance] requestWithMethod:@"User/getFavoriteList"
                                   parameters:paramter
                                      success:^(NSDictionary *result) {
                                          
                                          self.albumData = [[result objectForKey:@"data"] objectForKey:@"album"];
                                          self.wantGoData = [[result objectForKey:@"data"] objectForKey:@"want_go"];
                                          self.wantBuyData = [[result objectForKey:@"data"] objectForKey:@"want_buy"];
                                          
                                          if (self.albumData.count <= 0) {
                                              _albumTV.hidden = YES;
                                              _albumLB.hidden = NO;
                                          }
                                          
                                          if (self.wantGoData.count <= 0) {
                                              _wantGoTV.hidden = YES;
                                              _wantGoLB.hidden = NO;
                                          }
                                          
                                          if ([[self.wantBuyData objectForKey:@"list"] count] <= 0){
                                              _wantBuyTV.hidden = YES;
                                              _wantBuyLB.hidden = NO;
                                          }
                                          
                                          [_albumTV reloadData];
                                          [_wantBuyTV reloadData];
                                          [_wantGoTV reloadData];
                                          
                                          [SVProgressHUD dismiss];
                                      }
                                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                          [SVProgressHUD showInfoWithStatus:[error localizedDescription] maskType:SVProgressHUDMaskTypeBlack];
                                      }];
}

#pragma makr - 获取专辑列表
- (void) getAlbumList {
    [SVProgressHUD show];
    
    NSMutableDictionary *paramter = [NSMutableDictionary dictionary];
    [paramter setObject:[NSString stringWithFormat:@"%@", [CHSSID SSID]] forKey:@"ssid"];
    
    [[HttpManager instance] requestWithMethod:@"User/getAlbumList"
                                   parameters:paramter
                                      success:^(NSDictionary *result) {
                                          
                                          self.albumData = [[result objectForKey:@"data"] mutableCopy];
                                          
                                          if ([self.albumData count] == 0) {
                                              self.albumTV.hidden = YES;
                                              self.bgView.hidden = NO;
                                          }else{
                                              [self.albumTV reloadData];
                                              self.bgView.hidden = YES;
                                              self.albumTV.hidden = NO;
                                          }
                                          
                                          [SVProgressHUD dismiss];
                                      }
                                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                          [SVProgressHUD showInfoWithStatus:[error localizedDescription] maskType:SVProgressHUDMaskTypeBlack];
                                      }];
}

- (void) refresh:(UIRefreshControl *)control {
    [control beginRefreshing];
    [self getFavoriteList];
    [control endRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
