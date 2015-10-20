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
#import "UIImageView+AFNetworking.h"
#import "JHChainableAnimations.h"
#import "SearchViewController.h"
#import "PlayDetailViewController.h"
#import "ShoppingDGDetailViewController.h"
#import "LinkWebViewController.h"


static NSString * const DISCOVERY_CELL = @"discoveryCell";

@interface DiscoveryViewController ()<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, UIScrollViewDelegate, UITextFieldDelegate>

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

@end

@implementation DiscoveryViewController

- (void) viewWillDisappear:(BOOL)animated {
    [SVProgressHUD dismiss];
}

- (void) viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self twitterSplash];
    self.navigationItem.title = @"Discovery";
    self.navigationController.navigationBarHidden = YES;
    [self setupDiscoveryTV];
    [self setupSearchNav];
    [self setupLogo];
    [self refresh:self.refreshTV];
    
    
    // Do any additional setup after loading the view.
}


#pragma mark 获取专辑列表

- (void) getAlbumList {
    [SVProgressHUD show];
    self.discoveryTV.scrollEnabled = NO;
    NSMutableDictionary *paramter = [NSMutableDictionary dictionary];
    [paramter setObject:[NSString stringWithFormat:@"%@", [CHSSID SSID]] forKey:@"ssid"];
    
    [[HttpManager instance] requestWithMethod:@"Product/albumList"
                                   parameters:paramter
                                      success:^(NSDictionary *result) {
                                          NSLog(@"album list data is %@", result);
                                          self.discoveryTVData = [[NSMutableArray alloc] initWithArray:[[result objectForKey:@"data"] objectForKey:@"albumList"]];
                                          self.adData = [[NSMutableArray alloc] initWithArray:[[result objectForKey:@"data"] objectForKey:@"adList"]];
                                          [self setupKV:self.adData];
                                          
                                          [self.discoveryTV reloadData];
                                          [SVProgressHUD dismiss];
                                          self.discoveryTV.scrollEnabled = YES;
                                          
                                      }
                                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                          [SVProgressHUD dismiss];
                                      }];
}

- (void) setupLogo {
    
    UIView *imgView = [UIView newAutoLayoutView];
    [self.searchView addSubview:imgView];
    
    [imgView autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:_searchView withOffset:20];
    [imgView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:_searchView];
    [imgView autoSetDimensionsToSize:CGSizeMake(66, 30)];
    imgView.backgroundColor = [UIColor grayColor];
    imgView.clipsToBounds = YES;
    
    UIImageView *imgbg = [UIImageView newAutoLayoutView];
    [imgView addSubview:imgbg];
    
    [imgbg autoAlignAxis:ALAxisVertical toSameAxisOfView:imgView];
    [imgbg autoAlignAxis:ALAxisHorizontal toSameAxisOfView:imgView];
    [imgbg autoSetDimensionsToSize:CGSizeMake(70, 70)];
    imgbg.image = [UIImage imageNamed:@"goLogoBg"];
    imgbg.clipsToBounds = YES;
    imgbg.rotate(360).animate(90.0);
    
    UIImageView *imgLogo = [UIImageView newAutoLayoutView];
    [imgView addSubview:imgLogo];
    
    [imgLogo autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:imgView];
    [imgLogo autoAlignAxis:ALAxisHorizontal toSameAxisOfView:imgView];
    [imgLogo autoSetDimensionsToSize:CGSizeMake(66, 30)];
    imgLogo.image = [UIImage imageNamed:@"goLogoEmpty"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setupSearchNav {
    
    self.searchView = [UIView newAutoLayoutView];
    [self.view addSubview:_searchView];
    
    [_searchView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.view withOffset:20];
    [_searchView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view];
    [_searchView autoSetDimensionsToSize:CGSizeMake(ScreenWidth, 44)];
    
    _searchView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *bgView = [UIImageView newAutoLayoutView];
    [self.searchView addSubview:bgView];
    
    
    [bgView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:_searchView withOffset:-20];
    [bgView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:_searchView];
    [bgView autoSetDimensionsToSize:CGSizeMake(180, 25)];
    bgView.image = [UIImage imageNamed:@"searchBarbg"];
    
    UIImageView *iconView = [UIImageView newAutoLayoutView];
    [self.searchView addSubview:iconView];
    
    [iconView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:bgView withOffset:5];
    [iconView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:bgView];
    [iconView autoSetDimensionsToSize:CGSizeMake(15, 15)];
    iconView.image = [UIImage imageNamed:@"searchIcon"];
    
    self.searchField = [UITextField newAutoLayoutView];
    [self.searchView addSubview:_searchField];
    self.searchField.delegate = self;
    
    [_searchField autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:_searchView withOffset:-15];
    [_searchField autoAlignAxis:ALAxisHorizontal toSameAxisOfView:_searchView];
    [_searchField autoSetDimensionsToSize:CGSizeMake(150, 30)];
    _searchField.placeholder = @"彩虹Go!";
    
    
}

- (void) setupDiscoveryTV {
    self.discoveryTV = [UITableView newAutoLayoutView];
    [self.view addSubview:_discoveryTV];
    
    //    [_discoveryTV autoPinToTopLayoutGuideOfViewController:self withInset:-65.0];
    [_discoveryTV autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.view withOffset:44];
//    [_discoveryTV autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:self.view];
//    [_discoveryTV autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:self.view];
    [_discoveryTV autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view];
    [_discoveryTV autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view];

    [_discoveryTV autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view];
    
    
    _discoveryTV.delegate = self;
    _discoveryTV.dataSource = self;
    _discoveryTV.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.refreshTV = [[UIRefreshControl alloc] init];
    [_discoveryTV addSubview:_refreshTV];
    [_refreshTV addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    
    [self.discoveryTV registerClass:[DiscoveryTableViewCell class] forCellReuseIdentifier:DISCOVERY_CELL];
    
    
}

- (void) setupKV:(NSMutableArray *)adData {
    
    NSMutableArray *viewsArray = [@[] mutableCopy];
    
    for (int i = 0; i < 4; ++i) {
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.frame = CGRectMake(ScreenWidth * i, 0, ScreenWidth, 142);
//        imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"ad%d.jpg", i + 1]];
        ;
        NSURL *imageUrl = [NSURL URLWithString:[[adData objectAtIndex:i] objectForKey:@"path"]];
        [imgView setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"defaultPicHorizontal"]];
        
        [viewsArray addObject:imgView];
    }
    
    self.discoveryHV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 152)];
    
    self.kvScrollView = [[CHAutoSlideScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 142) animationDuration:5];
    
    [self.discoveryHV removeFromSuperview];
    
    self.kvScrollView.totalPagesCount = ^NSInteger(void){
        return viewsArray.count;
    };
    
    self.kvScrollView.fetchContentViewAtIndex = ^UIView *(NSInteger pageIndex){
        return viewsArray[pageIndex];
    };
    
    self.kvScrollView.TapActionBlock = ^(NSInteger pageIndex){
//        NSLog(@"点击了第%d个kv", pageIndex);

        NSString *adType = [NSString stringWithFormat:@"%@", [[adData objectAtIndex:pageIndex] objectForKey:@"type"]];
        
        if ([adType isEqualToString:@"1"]) {
            ShoppingDGDetailViewController *detailVC = [[ShoppingDGDetailViewController alloc] init];
            
            detailVC.webUrl = [NSString stringWithFormat:@"http://api.atniwo.com/Product/showProDetail?pid=%@", [[adData objectAtIndex:pageIndex] objectForKey:@"pid"]];
            detailVC.pid = [NSString stringWithFormat:@"%@", [[adData objectAtIndex:pageIndex] objectForKey:@"pid"]];
            detailVC.zhPriceStr = [NSString stringWithFormat:@"%@", [[adData objectAtIndex:pageIndex] objectForKey:@"price_zh"]];
            detailVC.hasNav = @"1";
            detailVC.navigationItem.title = [[adData objectAtIndex:pageIndex] objectForKey:@"title"];
            detailVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:detailVC animated:YES];
            
        }else if ([adType isEqualToString:@"2"]) {
            PlayDetailViewController *detailVC = [[PlayDetailViewController alloc] init];
            
            detailVC.webUrl = [NSString stringWithFormat:@"http://api.atniwo.com/Product/showShopDetail?sid=%@", [[adData objectAtIndex:pageIndex] objectForKey:@"pid"]];
            detailVC.sid = [NSString stringWithFormat:@"%@", [[adData objectAtIndex:pageIndex] objectForKey:@"pid"]];
            detailVC.navigationItem.title = [[adData objectAtIndex:pageIndex] objectForKey:@"title"];
            detailVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:detailVC animated:YES];
            
        }else if ([adType isEqualToString:@"3"]) {
            DiscoveryDetailViewController *detail = [[DiscoveryDetailViewController alloc] init];
            
            detail.webUrl = [NSString stringWithFormat:@"http://api.atniwo.com/Product/showAlbum?aid=%@", [[adData objectAtIndex:pageIndex] objectForKey:@"pid"]];
            detail.navigationItem.title = [[adData objectAtIndex:pageIndex] objectForKey:@"title"];
            
            detail.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:detail animated:YES];
        }else if ([adType isEqualToString:@"4"]) {
            LinkWebViewController *detail = [[LinkWebViewController alloc] init];
            
            detail.webUrl = [NSString stringWithFormat:@"%@", [[adData objectAtIndex:pageIndex] objectForKey:@"url"]];
            detail.navigationItem.title = [[adData objectAtIndex:pageIndex] objectForKey:@"title"];
            detail.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:detail animated:YES];
        }
    };
    
    [self.discoveryHV addSubview:self.kvScrollView];
    self.discoveryTV.tableHeaderView = _discoveryHV;
}

- (void) setupDiscoveryTVHeaderView {
    //    self.discoveryHV = [[UIView alloc] initForAutoLayout];
    self.discoveryHV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    
    self.adScrollView = [UIScrollView newAutoLayoutView];
    [self.discoveryHV addSubview:_adScrollView];
    
    [_adScrollView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:_discoveryHV];
    [_adScrollView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:_discoveryHV];
    [_adScrollView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_discoveryHV];
    [_adScrollView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:_discoveryHV];
    [_adScrollView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:_discoveryHV];
    _adScrollView.contentSize = CGSizeMake(ScreenWidth * 3, _adScrollView.frame.size.height);
    _adScrollView.delegate = self;
    _adScrollView.showsHorizontalScrollIndicator = NO;
    
    // 设置分页
    _adScrollView.pagingEnabled = YES;
    
    for (int i = 0; i < 3; i++) {
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.frame = CGRectMake(ScreenWidth * i, 0, ScreenWidth, 200);
        imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"ad%d.jpg", i + 1]];
        //        NSURL *imageUrl = [NSURL URLWithString:[self.imgArr objectAtIndex:i]];
        //        [imgView setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"productDemo3"]];
        
        //                imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", [self.imgArr objectAtIndex:i]]];
        
        [_adScrollView addSubview:imgView];
        
    }
    
    self.adPageControl = [[UIPageControl alloc] init];
    
    //    self.adPageControl = [UIPageControl newAutoLayoutView];
    
    _adPageControl.center = CGPointMake(ScreenWidth / 2, 180);
    _adPageControl.bounds = CGRectMake(0, 0, 16*(3-1)+16, 16);
    _adPageControl.numberOfPages = 3;
    _adPageControl.pageIndicatorTintColor = [UIColor colorWithRed:184.0/255 green:184.0/255 blue:184.0/255 alpha:1];
    _adPageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    _adPageControl.enabled = NO;
    
    [_discoveryHV addSubview:_adPageControl];
    
    _discoveryHV.backgroundColor = [UIColor clearColor];
    
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
    return ScreenWidth;
}


- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DiscoveryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DISCOVERY_CELL forIndexPath:indexPath];
    
    NSDictionary *cellData = [[NSDictionary alloc] initWithDictionary:[self.discoveryTVData objectAtIndex:indexPath.row]];
    
    NSURL *imageUrl = [NSURL URLWithString:[cellData objectForKey:@"path"]];
    [cell.bgImg setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"defaultPicBig"]];
    
    cell.titleLB.text = [cellData objectForKey:@"title"];
    cell.timeLB.text = [cellData objectForKey:@"outTime"];

    if (![[cellData objectForKey:@"address_title"] isEqualToString:@""]) {
        cell.mapLB.text = [cellData objectForKey:@"address_title"];
        cell.locationImg.hidden = NO;
    }else{
        cell.mapLB.text = @"";
        cell.locationImg.hidden = YES;
    }

    cell.buyBTN.backgroundColor = [self setBuyBTN:[cellData objectForKey:@"colorNum"]];
    
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
    
    detail.webUrl = [NSString stringWithFormat:@"http://api.atniwo.com/Product/showAlbum?aid=%@", [cellData objectForKey:@"aid"]];
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

- (void) refresh:(UIRefreshControl *)control {
    [control beginRefreshing];
    [self getAlbumList];
    [control endRefreshing];
}


@end
