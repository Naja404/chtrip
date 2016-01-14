//
//  MyAddressViewController.m
//  chtrips
//
//  Created by Hisoka on 16/1/5.
//  Copyright © 2016年 HSK.ltd. All rights reserved.
//

#import "MyAddressViewController.h"
#import "MyAddressTableViewCell.h"
#import "MyWebViewController.h"

static NSString * const MY_ADDRESS_CELL = @"myAddressCell";

@interface MyAddressViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *myAddressTV;
@property (nonatomic, strong) NSArray *myAddressData;
@property (nonatomic, strong) NSString *addUrl;

@end

@implementation MyAddressViewController

- (void) viewWillAppear:(BOOL)animated {
    [self getAddress];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customizeBackItem];
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    
    [self setStyle];
    [self getAddress];
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
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"新增" style:UIBarButtonItemStyleDone target:self action:@selector(pushAddressVC)];
    
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([_myAddressData count] <= 0) {
        return 0;
    }else{
        return [_myAddressData count];
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MY_ADDRESS_CELL forIndexPath:indexPath];
    
    NSDictionary *tmpData = [_myAddressData objectAtIndex:indexPath.row];
    
    cell.nameLB.text = [tmpData objectForKey:@"name"];
    cell.mobileLB.text = [tmpData objectForKey:@"mobile"];
    cell.addressLB.text = [tmpData objectForKey:@"address"];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    NSDictionary *tmpData = [_myAddressData objectAtIndex:indexPath.row];
    
    MyWebViewController *webVC = [[MyWebViewController alloc] init];
    
    webVC.navigationItem.title = NSLocalizedString(@"TEXT_EDIT_ADDRESS", nil);
    webVC.webUrl = [tmpData objectForKey:@"edit_url"];
    webVC.actionName = @"editAddress";
    [self.navigationController pushViewController:webVC animated:YES];
}

#pragma mark - 获取收货地址
- (void) getAddress {
    NSMutableDictionary *paramter = [NSMutableDictionary dictionary];
    [paramter setObject:[NSString stringWithFormat:@"%@", [CHSSID SSID]] forKey:@"ssid"];
    
    [[HttpManager instance] requestWithMethod:@"User/getAddress"
                                   parameters:paramter
                                      success:^(NSDictionary *result) {
                                          NSDictionary *tmp = [result objectForKey:@"data"];
                                          _myAddressData = [tmp objectForKey:@"list"];
                                          _addUrl = [tmp objectForKey:@"add_url"];
                                          
                                          if (_myAddressTV != NULL) {
                                              if ([_myAddressData count] > 0) {
                                                  _myAddressTV.hidden = NO;
                                                  [_myAddressTV reloadData];
                                              }else{
                                                  _myAddressTV.hidden = YES;
                                                  [self setEmptyStyle];
                                              }
                                          }
                                      }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                          
                                      }];
}

#pragma mark - 设置空数据样式
- (void) setEmptyStyle {
    UILabel *defaultLB = [UILabel newAutoLayoutView];
    [self.view addSubview:defaultLB];
    
    [defaultLB autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.view];
    [defaultLB autoAlignAxis:ALAxisVertical toSameAxisOfView:self.view];
    [defaultLB autoSetDimensionsToSize:CGSizeMake(150, 30)];
    defaultLB.backgroundColor = [UIColor clearColor];
    defaultLB.textAlignment = NSTextAlignmentCenter;
    defaultLB.text = @"暂无收货地址";
    defaultLB.textColor = [UIColor grayColor];
}

- (void) pushAddressVC {
    MyWebViewController *webVC = [[MyWebViewController alloc] init];
    
    webVC.webUrl = _addUrl;
    webVC.navigationItem.title = NSLocalizedString(@"TEXT_ADD_ADDRESS", nil);
    webVC.actionName = @"subAddress";
    
    [self.navigationController pushViewController:webVC animated:YES];
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
