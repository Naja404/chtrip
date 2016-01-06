//
//  MyAddressViewController.m
//  chtrips
//
//  Created by Hisoka on 16/1/5.
//  Copyright © 2016年 HSK.ltd. All rights reserved.
//

#import "MyAddressViewController.h"
#import "MyAddressTableViewCell.h"

static NSString * const MY_ADDRESS_CELL = @"myAddressCell";

@interface MyAddressViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *myAddressTV;

@end

@implementation MyAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customizeBackItem];
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    
    [self setStyle];
}

- (void) setStyle {
    
    self.navigationItem.title = NSLocalizedString(@"TEXT_MY_ADDRESS", nil);
    
    self.myAddressTV = [UITableView newAutoLayoutView];
    [self.view addSubview:_myAddressTV];
    
    [_myAddressTV autoPinToTopLayoutGuideOfViewController:self withInset:-64.0];
    [_myAddressTV autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view];
    [_myAddressTV autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view];
    [_myAddressTV autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view];
    
    _myAddressTV.delegate = self;
    _myAddressTV.dataSource = self;
    _myAddressTV.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [_myAddressTV registerClass:[MyAddressTableViewCell class] forCellReuseIdentifier:MY_ADDRESS_CELL];
    
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MY_ADDRESS_CELL forIndexPath:indexPath];
    
    return cell;
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
