//
//  MyViewController.m
//  chtrips
//
//  Created by Hisoka on 15/3/30.
//  Copyright (c) 2015年 HSK.ltd. All rights reserved.
//

#import "MyViewController.h"
#import "MyAvatarTableViewCell.h"

static NSString * const MY_AVATAR_CELL = @"myAvatarCell";

@interface MyViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *myTV;

@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"My";
    // Do any additional setup after loading the view.
    [self setupMyStyle];
}

- (void) setupMyStyle {
    self.myTV = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _myTV.translatesAutoresizingMaskIntoConstraints = NO;

    [self.view addSubview:_myTV];
    
    [_myTV autoPinToTopLayoutGuideOfViewController:self withInset:-65.0];
    [_myTV autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view];
    [_myTV autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view];
    [_myTV autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view];
    
    _myTV.dataSource = self;
    _myTV.delegate = self;
    
    [self.myTV registerClass:[MyAvatarTableViewCell class] forCellReuseIdentifier:MY_AVATAR_CELL];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else if(section == 1){
        return 3;
    }else{
        return 2;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 80;
    }else{
        return 40;
    }
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyAvatarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MY_AVATAR_CELL forIndexPath:indexPath];
    
    if (indexPath.section == 0 && indexPath.row == 0) {

    }else{
        cell.avatarImg.image = nil;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
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
