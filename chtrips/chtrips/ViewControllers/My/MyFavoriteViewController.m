//
//  MyFavoriteViewController.m
//  chtrips
//
//  Created by Hisoka on 16/4/25.
//  Copyright © 2016年 HSK.ltd. All rights reserved.
//

#import "MyFavoriteViewController.h"
#import "DiscoveryTableViewCell.h"
#import "DiscoveryDetailViewController.h"

static NSString * const ALBUM_CELL = @"albumCell";

@interface MyFavoriteViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *albumTV;
@property (nonatomic, strong) NSMutableArray *albumData;
@property (nonatomic, strong) UIRefreshControl *refreshTV;
@property (nonatomic, strong) UIImageView *bgView;

@end

@implementation MyFavoriteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [super viewDidLoad];
    [self customizeBackItem];
    [self setAlbumList];
    [self refresh:self.refreshTV];
  
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
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
    if ([self.albumData count] <= 0) {
        return 0;
    }else{
        return [self.albumData count];
    }
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.albumData.count - 1) {
        return ScreenWidth;
    }else{
        return ScreenWidth + 10;
    }
}


- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
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
    
    DiscoveryDetailViewController *detail = [[DiscoveryDetailViewController alloc] init];
    NSDictionary *cellData = [[NSDictionary alloc] initWithDictionary:[self.albumData objectAtIndex:indexPath.row]];
    
    detail.webUrl = [NSString stringWithFormat:@"http://api.nijigo.com/Product/showAlbum/aid/%@/ssid/%@.html", [cellData objectForKey:@"aid"], [CHSSID SSID]];
    detail.albumDic = cellData;
    detail.navigationItem.title = [cellData objectForKey:@"type_name"];
    
    detail.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:detail animated:YES];
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
    [self getAlbumList];
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
