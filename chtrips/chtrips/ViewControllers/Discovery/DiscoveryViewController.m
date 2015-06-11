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

static NSString * const DISCOVERY_CELL = @"discoveryCell";

@interface DiscoveryViewController ()<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UITableView *discoveryTV;
@property (nonatomic, strong) NSMutableDictionary *discoveryTVData;
@property (nonatomic, strong) UIView *discoveryHV;
@property (nonatomic, strong) UIScrollView *adScrollView;
@property (nonatomic, strong) UIPageControl *adPageControl;
@property (nonatomic, strong) CHAutoSlideScrollView *kvScrollView;

@end

@implementation DiscoveryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Discovery";
    [self setupDiscoveryTV];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setupDiscoveryTV {
    self.discoveryTV = [UITableView newAutoLayoutView];
    [self.view addSubview:_discoveryTV];
    
    [_discoveryTV autoPinToTopLayoutGuideOfViewController:self withInset:-65.0];
    [_discoveryTV autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view];
    [_discoveryTV autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view];
    [_discoveryTV autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view];

    
    _discoveryTV.delegate = self;
    _discoveryTV.dataSource = self;
    
    [self.discoveryTV registerClass:[DiscoveryTableViewCell class] forCellReuseIdentifier:DISCOVERY_CELL];
    
    [self setupKV];
    
}

- (void) setupKV {
    NSMutableArray *viewsArray = [@[] mutableCopy];
    
    for (int i = 0; i < 3; ++i) {
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.frame = CGRectMake(ScreenWidth * i, 0, ScreenWidth, 200);
        imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"ad%d.jpg", i + 1]];
        [viewsArray addObject:imgView];
    }
    
    self.discoveryHV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];

    self.kvScrollView = [[CHAutoSlideScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 200) animationDuration:5];
    
    [self.discoveryHV removeFromSuperview];
    
    self.kvScrollView.totalPagesCount = ^NSInteger(void){
        return viewsArray.count;
    };
    
    self.kvScrollView.fetchContentViewAtIndex = ^UIView *(NSInteger pageIndex){
        return viewsArray[pageIndex];
    };
    
    self.kvScrollView.TapActionBlock = ^(NSInteger pageIndex){
        NSLog(@"点击了第%d个kv", pageIndex);
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
    return 10;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}


- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DiscoveryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DISCOVERY_CELL forIndexPath:indexPath];
    cell.titleLB.text = @"松本清特惠专场";
    cell.leftLB.text = @"剩余 20 天";
    cell.bgImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"ad0%d.jpg", indexPath.row]];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DiscoveryDetailViewController *detail = [[DiscoveryDetailViewController alloc] init];
    
    [self.navigationController pushViewController:detail animated:YES];
}


@end
