//
//  DiscoveryViewController.m
//  chtrips
//
//  Created by Hisoka on 15/3/30.
//  Copyright (c) 2015年 HSK.ltd. All rights reserved.
//

#import "DiscoveryViewController.h"
#import "DiscoveryTableViewCell.h"

static NSString * const DISCOVERY_CELL = @"discoveryCell";

@interface DiscoveryViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *discoveryTV;
@property (nonatomic, strong) NSMutableDictionary *discoveryTVData;
@property (nonatomic, strong) UIView *discoveryHV;

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
    
    [self setupDiscoveryTVHeaderView];
    
}

- (void) setupDiscoveryTVHeaderView {
//    self.discoveryHV = [[UIView alloc] initForAutoLayout];
    self.discoveryHV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];

    _discoveryHV.backgroundColor = [UIColor grayColor];
    
    self.discoveryTV.tableHeaderView = _discoveryHV;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}


- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DiscoveryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DISCOVERY_CELL forIndexPath:indexPath];
    cell.textLabel.text = @"产品";
    return cell;
}


@end
