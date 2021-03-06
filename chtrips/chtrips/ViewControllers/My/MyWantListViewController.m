//
//  MyWantListViewController.m
//  chtrips
//
//  Created by Hisoka on 15/8/24.
//  Copyright (c) 2015年 HSK.ltd. All rights reserved.
//

#import "MyWantListViewController.h"
#import "PlayTableViewCell.h"
#import "PlayDetailViewController.h"
#import "PlayInsideDetailViewController.h"

static NSString * const WANTGO_CELL = @"wantGoCell";

@interface MyWantListViewController ()<UITableViewDataSource, UITableViewDelegate>


@property (nonatomic, strong) UITableView *wantGoTV;
@property (nonatomic, strong) NSMutableArray *wantGoData;
@property (nonatomic, strong) UIRefreshControl *refreshTV;
@property (nonatomic, strong) UIImageView *bgView;


@end

@implementation MyWantListViewController


- (void)viewWillDisappear:(BOOL)animated {
    [[HttpManager instance] cancelAllOperations];
    [SVProgressHUD dismiss];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self customizeBackItem];
    [self setupWantGoTV];
    [self refresh:self.refreshTV];
    self.automaticallyAdjustsScrollViewInsets = NO;

    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) setupWantGoTV {
    self.view.backgroundColor = [UIColor whiteColor];
    self.wantGoTV = [UITableView newAutoLayoutView];
    [self.view addSubview:_wantGoTV];
    
    [_wantGoTV autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.view withOffset:64];
    [_wantGoTV autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view];
    [_wantGoTV autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view];
    [_wantGoTV autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view];
    
    _wantGoTV.delegate = self;
    _wantGoTV.dataSource = self;
    _wantGoTV.separatorStyle = UITableViewCellAccessoryNone;
    
    self.refreshTV = [[UIRefreshControl alloc] init];
    [_wantGoTV addSubview:_refreshTV];
    [_refreshTV addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    
    [self.wantGoTV registerClass:[PlayTableViewCell class] forCellReuseIdentifier:WANTGO_CELL];
    self.wantGoTV.hidden = YES;
    
    self.bgView = [UIImageView newAutoLayoutView];
    [self.view addSubview:_bgView];
    
    [_bgView autoAlignAxis:ALAxisVertical toSameAxisOfView:self.view];
    [_bgView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.view];
    [_bgView autoSetDimensionsToSize:CGSizeMake(90, 70)];
    _bgView.image = [UIImage imageNamed:@"defaultDataPic"];
    _bgView.hidden = YES;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 85;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.wantGoData count] <= 0) {
        return 0;
    }else{
        return [self.wantGoData count];
    }
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
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

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    
//    PlayDetailViewController *detailVC = [[PlayDetailViewController alloc] init];
//    NSDictionary *cellData = [[NSDictionary alloc] initWithDictionary:[self.wantGoData objectAtIndex:indexPath.row]];
//    
//    detailVC.webUrl = [NSString stringWithFormat:@"http://api.nijigo.com/Product/showShopDetail?sid=%@", [cellData objectForKey:@"saler_id"]];
//    detailVC.sid = [NSString stringWithFormat:@"%@", [cellData objectForKey:@"saler_id"]];
//    detailVC.navigationItem.title = [cellData objectForKey:@"name"];
//    detailVC.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:detailVC animated:YES];
    
    
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
}

#pragma mark - cell编辑
- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSDictionary *tmpData = [self.wantGoData objectAtIndex:indexPath.row];
        [self.wantGoData removeObjectAtIndex:indexPath.row];
        
        NSArray *indexPaths = @[indexPath];
        [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationLeft];
        
        [self upWantList:@"2" sid:[tmpData objectForKey:@"saler_id"]];
    }
}

- (void) upWantList:(NSString *)type sid:(NSString *)sid {
    
    [SVProgressHUD show];
    NSMutableDictionary *paramter = [NSMutableDictionary dictionary];
    [paramter setObject:[NSString stringWithFormat:@"%@", [CHSSID SSID]] forKey:@"ssid"];
    [paramter setObject:type forKey:@"type"];
    [paramter setObject:sid forKey:@"sid"];
    
    [[HttpManager instance] requestWithMethod:@"User/setWantGo"
                                   parameters:paramter
                                      success:^(NSDictionary *result) {
                                          
                                          self.wantGoData = [[result objectForKey:@"data"] mutableCopy];
                                          
                                          if ([self.wantGoData count] == 0) {
                                              self.wantGoTV.hidden = YES;
                                              self.bgView.hidden = NO;
                                          }else{
                                              [self.wantGoTV reloadData];
                                              self.bgView.hidden = YES;
                                              self.wantGoTV.hidden = NO;
                                          }
                                          
                                          
                                          [SVProgressHUD dismiss];
                                      }
                                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                          [SVProgressHUD showInfoWithStatus:[error localizedDescription] maskType:SVProgressHUDMaskTypeBlack];
                                      }];
}

#pragma mark 获取商家列表
- (void) getWantGoList {
    [SVProgressHUD show];
    NSMutableDictionary *paramter = [NSMutableDictionary dictionary];
    //    [paramter setObject:[CHSSID SSID] forKey:@"ssid"];
    [paramter setObject:[NSString stringWithFormat:@"%@", [CHSSID SSID]] forKey:@"ssid"];
    
    [[HttpManager instance] requestWithMethod:@"User/getWantList"
                                   parameters:paramter
                                      success:^(NSDictionary *result) {

                                          self.wantGoData = [[result objectForKey:@"data"] mutableCopy];
                                          
                                          if ([self.wantGoData count] == 0) {
                                              self.wantGoTV.hidden = YES;
                                              self.bgView.hidden = NO;
                                          }else{
                                             [self.wantGoTV reloadData];
                                              self.bgView.hidden = YES;
                                              self.wantGoTV.hidden = NO;
                                          }
                                          
                                          
                                          [SVProgressHUD dismiss];
                                      }
                                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                          [SVProgressHUD showInfoWithStatus:[error localizedDescription] maskType:SVProgressHUDMaskTypeBlack];
                                      }];
}

- (void) refresh:(UIRefreshControl *)control {
    [control beginRefreshing];
    [self getWantGoList];
    [control endRefreshing];
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
