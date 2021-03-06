//
//  DiscoveryViewController.m
//  chtrips
//
//  Created by Hisoka on 15/3/30.
//  Copyright (c) 2015年 HSK.ltd. All rights reserved.
//

#import "DiscoveryViewController.h"
#import "DiscoveryTableViewCell.h"
#import "DiscoveryDetailViewController.h"
#import "CHAutoSlideScrollView.h"
#import "JHChainableAnimations.h"
#import "SearchViewController.h"
#import "PlayDetailViewController.h"
#import "ShoppingDGDetailViewController.h"
#import "LinkWebViewController.h"
#import "IntroViewController.h"
#import <UIImageView-PlayGIF/YFGIFImageView.h>
#import "SDCycleScrollView.h"


static NSString * const DISCOVERY_CELL = @"discoveryCell";

@interface DiscoveryViewController ()<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, UITextFieldDelegate, SDCycleScrollViewDelegate>

@property (nonatomic, strong) UITableView *discoveryTV;
@property (nonatomic, strong) NSMutableArray *discoveryTVData;
@property (nonatomic, strong) NSMutableArray *adData;
@property (nonatomic, strong) UIView *discoveryHV;
@property (nonatomic, strong) UIScrollView *adScrollView;
@property (nonatomic, strong) UIPageControl *adPageControl;
@property (nonatomic, strong) CHAutoSlideScrollView *kvScrollView;
@property (nonatomic, strong) UIView *searchView;
@property (nonatomic, strong) UITextField *searchField;
@property (nonatomic, strong) UIRefreshControl *refreshTV;

@property (strong, nonatomic) UIActivityIndicatorView *indicatorView;

@property (nonatomic, strong) NSString *hasMoreData;
@property (nonatomic, strong) NSString *nextPageNum;

@end

@implementation DiscoveryViewController

- (void) viewWillDisappear:(BOOL)animated {
    [SVProgressHUD dismiss];
}

- (void) viewWillAppear:(BOOL)animated{

//    NSString *isNew = [[TMCache sharedCache] objectForKey:@"ver097"];
//    if (![isNew isEqualToString:@"YES"]) [self setIntroView];
    
    self.hidesBottomBarWhenPushed = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    
    [self setupDiscoveryTV];
    [self setupSearchNav];
    [self setupLogo];
    [self refresh:YES];
}


#pragma mark - 获取专辑列表

- (void) getAlbumList:(NSString *)pageNum isFirst:(BOOL)isFirst {
    [SVProgressHUD show];
    self.discoveryTV.scrollEnabled = NO;
    NSMutableDictionary *paramter = [NSMutableDictionary dictionary];
    [paramter setObject:pageNum forKey:@"pageNum"];
    [paramter setObject:[NSString stringWithFormat:@"%@", [CHSSID SSID]] forKey:@"ssid"];
    [paramter setObject:CHVersion forKey:@"ver"];
    
    [[HttpManager instance] requestWithMethod:@"Product/albumList"
                                   parameters:paramter
                                      success:^(NSDictionary *result) {
                                          
                                          if (isFirst) {
                                              self.adData = [[NSMutableArray alloc] initWithArray:[[result objectForKey:@"data"] objectForKey:@"adList"]];
                                              [self setupKV:self.adData];
                                          }
                                          
                                          if ([pageNum isEqualToString:@"1"]) {
                                              [self.discoveryTVData removeAllObjects];
                                              self.discoveryTVData = [[NSMutableArray alloc] initWithArray:[[result objectForKey:@"data"] objectForKey:@"albumList"]];
                                              [self.discoveryTV reloadData];
                                              [self.discoveryTV.header endRefreshing];
                                          }else{
                                              [self.discoveryTVData addObjectsFromArray:[[result objectForKey:@"data"] objectForKey:@"albumList"]];
                                              [self.discoveryTV reloadData];
                                              [self.discoveryTV.footer endRefreshing];
                                          }
                                          
                                          if ([[[result objectForKey:@"data"] objectForKey:@"hasMore"] isEqualToString:@"0"]) {
                                              self.nextPageNum = @"1";
                                              self.hasMoreData = @"0";
                                          }else{
                                              self.nextPageNum = [[result objectForKey:@"data"] objectForKey:@"nextPageNum"];
                                              self.hasMoreData = @"1";
                                          }
                                          [SVProgressHUD dismiss];
                                          self.discoveryTV.scrollEnabled = YES;
                                          
                                      }
                                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                          [SVProgressHUD showInfoWithStatus:[error localizedDescription] maskType:SVProgressHUDMaskTypeBlack];
                                      }];
}

- (void) setupLogo {
    
    UIView *imgView = [UIView newAutoLayoutView];
    [self.searchView addSubview:imgView];
    

    
    
//    [imgView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_searchView withOffset:10];
    [imgView autoAlignAxis:ALAxisVertical toSameAxisOfView:_searchView];
    [imgView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:_searchView];
    [imgView autoSetDimensionsToSize:CGSizeMake(66, 30)];
    imgView.backgroundColor = [UIColor clearColor];
    imgView.clipsToBounds = YES;
    

    NSData *gif = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"logo" ofType:@"gif"]];
    YFGIFImageView *gifView = [[YFGIFImageView alloc] initWithFrame:CGRectMake(0, 0, 66, 30)];
    gifView.gifData = gif;
    
    [imgView addSubview:gifView];
    
    [gifView startGIF];
    
    gifView.userInteractionEnabled = YES;
    
//
//    UIImageView *imgbg = [UIImageView newAutoLayoutView];
//    [imgView addSubview:imgbg];
//    
//    [imgbg autoAlignAxis:ALAxisVertical toSameAxisOfView:imgView];
//    [imgbg autoAlignAxis:ALAxisHorizontal toSameAxisOfView:imgView];
//    [imgbg autoSetDimensionsToSize:CGSizeMake(70, 70)];
//    imgbg.backgroundColor = [UIColor clearColor];
//    
//    imgbg.image = [UIImage imageNamed:@"goLogoBg"];
//    imgbg.clipsToBounds = YES;
//    imgbg.rotate(360).animate(20.0);
//    
//    UIImageView *imgLogo = [UIImageView newAutoLayoutView];
//    [imgView addSubview:imgLogo];
//    
//    [imgLogo autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:imgView];
//    [imgLogo autoAlignAxis:ALAxisHorizontal toSameAxisOfView:imgView];
//    [imgLogo autoSetDimensionsToSize:CGSizeMake(66, 30)];
//    imgLogo.image = [UIImage imageNamed:@"goLogoEmpty"];
//    imgLogo.backgroundColor = [UIColor clearColor];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setupSearchNav {
    
    self.searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
    
    self.navigationItem.titleView = _searchView;
    
}

- (void) pushSearchPage {

}

- (void) setupDiscoveryTV {
    self.discoveryTV = [UITableView newAutoLayoutView];
    [self.view addSubview:_discoveryTV];
    
    [_discoveryTV autoPinToTopLayoutGuideOfViewController:self withInset:0];
    [_discoveryTV autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view];
    [_discoveryTV autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view];
    [_discoveryTV autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view withOffset:-48];
    
    _discoveryTV.delegate = self;
    _discoveryTV.dataSource = self;
    _discoveryTV.separatorStyle = UITableViewCellSeparatorStyleNone;
    _discoveryTV.scrollsToTop = YES;
    
    [self.discoveryTV registerClass:[DiscoveryTableViewCell class] forCellReuseIdentifier:DISCOVERY_CELL];

}

// update with 2016-3-28
- (void) setupKV:(NSMutableArray *)adData {
    
    NSMutableArray *temp = [NSMutableArray new];
    [adData enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL * stop) {
        if (idx == nil) {
            [temp addObject:[[adData objectAtIndex:0] objectForKey:@"path"]];
        }else{
            [temp addObject:[[adData objectAtIndex:idx] objectForKey:@"path"]];
        }
    }];
    
    self.discoveryHV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth / 2.25 + 10)];
    
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth / 2.25) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    [self.discoveryHV removeFromSuperview];
    
    cycleScrollView.imageURLStringsGroup = temp;

    cycleScrollView.autoScrollTimeInterval = 5.0;
    
    __weak typeof (self) weakSelf = self;

    cycleScrollView.clickItemOperationBlock = ^(NSInteger pageIndex) {
        
        NSLog(@">>>>>  %ld", (long)pageIndex);
        
        NSString *adType = [NSString stringWithFormat:@"%@", [[adData objectAtIndex:pageIndex] objectForKey:@"type"]];
        
        if ([adType isEqualToString:@"1"]) {
            ShoppingDGDetailViewController *detailVC = [[ShoppingDGDetailViewController alloc] init];
            
            detailVC.webUrl = [NSString stringWithFormat:@"http://api.nijigo.com/Product/showProDetailNew?pid=%@", [[adData objectAtIndex:pageIndex] objectForKey:@"pid"]];
            detailVC.pid = [NSString stringWithFormat:@"%@", [[adData objectAtIndex:pageIndex] objectForKey:@"pid"]];
            detailVC.zhPriceStr = [NSString stringWithFormat:@"%@", [[adData objectAtIndex:pageIndex] objectForKey:@"price_zh"]];
            detailVC.hasNav = @"1";
            detailVC.navigationItem.title = [[adData objectAtIndex:pageIndex] objectForKey:@"title"];
            detailVC.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:detailVC animated:YES];
            
        }else if ([adType isEqualToString:@"2"]) {
            PlayDetailViewController *detailVC = [[PlayDetailViewController alloc] init];
            
            detailVC.webUrl = [NSString stringWithFormat:@"http://api.nijigo.com/Product/showShopDetail?sid=%@", [[adData objectAtIndex:pageIndex] objectForKey:@"pid"]];
            detailVC.sid = [NSString stringWithFormat:@"%@", [[adData objectAtIndex:pageIndex] objectForKey:@"pid"]];
            detailVC.navigationItem.title = [[adData objectAtIndex:pageIndex] objectForKey:@"title"];
            detailVC.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:detailVC animated:YES];
            
        }else if ([adType isEqualToString:@"3"]) {
            DiscoveryDetailViewController *detail = [[DiscoveryDetailViewController alloc] init];
            
            detail.webUrl = [NSString stringWithFormat:@"http://api.nijigo.com/Product/showAlbum?aid=%@", [[adData objectAtIndex:pageIndex] objectForKey:@"pid"]];
            detail.navigationItem.title = [[adData objectAtIndex:pageIndex] objectForKey:@"title"];
            
            detail.hidesBottomBarWhenPushed = YES;
            
            [weakSelf.navigationController pushViewController:detail animated:YES];
        }else if ([adType isEqualToString:@"4"]) {
            LinkWebViewController *detail = [[LinkWebViewController alloc] init];
            
            detail.webUrl = [NSString stringWithFormat:@"%@", [[adData objectAtIndex:pageIndex] objectForKey:@"url"]];
            detail.navigationItem.title = [[adData objectAtIndex:pageIndex] objectForKey:@"title"];
            detail.hidesBottomBarWhenPushed = YES;
            
            [weakSelf.navigationController pushViewController:detail animated:YES];
        }
        
        
    };
    

    [self.discoveryHV addSubview:cycleScrollView];

    self.discoveryTV.tableHeaderView = _discoveryHV;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    int page = scrollView.contentOffset.x / scrollView.frame.size.width;
    _adPageControl.currentPage = page;
}


- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.discoveryTVData count] <= 0) {
        return 0;
    }else{
        return [self.discoveryTVData count];
    }
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ScreenWidth + 10;
}


- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DiscoveryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DISCOVERY_CELL forIndexPath:indexPath];
    
    NSDictionary *cellData = [[NSDictionary alloc] initWithDictionary:[self.discoveryTVData objectAtIndex:indexPath.row]];
    
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
    
    if ([[cellData objectForKey:@"pro_type"] isEqualToString:@"0"]) {
        cell.productTypeImg.hidden = YES;
    }else{
        
        cell.productTypeImg.hidden = NO;
        
        if ([[cellData objectForKey:@"pro_type"] isEqualToString:@"1"]) {
            cell.productTypeImg.image = [UIImage imageNamed:@"albumType1"];
        }else{
            cell.productTypeImg.image = [UIImage imageNamed:@"albumType2"];
        }
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
    NSDictionary *cellData = [[NSDictionary alloc] initWithDictionary:[self.discoveryTVData objectAtIndex:indexPath.row]];
    
    detail.webUrl = [NSString stringWithFormat:@"http://api.nijigo.com/Product/showAlbum/aid/%@/ssid/%@.html", [cellData objectForKey:@"aid"], [CHSSID SSID]];
//    detail.webUrl = @"http://api.nijigo.com/Product/showAlbum/aid/418/ssid/e2b0388da966dba73e21fd529affa4d5.html";
    detail.albumDic = cellData;
    detail.navigationItem.title = [cellData objectForKey:@"type_name"];
    
    detail.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:detail animated:YES];
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.searchField resignFirstResponder];
}

- (void) scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    [self.searchField resignFirstResponder];
}

- (void) refresh:(BOOL)isFirst {
    
    self.discoveryTV.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getAlbumList:@"1" isFirst:isFirst];
    }];
    [self.discoveryTV.header beginRefreshing];
}

- (void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (scrollView.contentOffset.y + scrollView.frame.size.height >= scrollView.contentSize.height) {
        [self.discoveryTV.footer beginRefreshing];
        
        if ([self.hasMoreData isEqualToString:@"1"]) {
            self.discoveryTV.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                if (![self.nextPageNum isEqualToString:@"1"]) {
                    [self getAlbumList:self.nextPageNum isFirst:NO];
                }else{
                    [self.discoveryTV.footer noticeNoMoreData];
                }
            }];
        }else{
            [self.discoveryTV.footer noticeNoMoreData];
        }
    }
}

- (void) setIntroView {
    IntroViewController *introVC = [[IntroViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:introVC];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

@end
