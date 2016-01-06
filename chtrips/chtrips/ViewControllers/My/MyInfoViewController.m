//
//  MyInfoViewController.m
//  chtrips
//
//  Created by Hisoka on 15/11/3.
//  Copyright © 2015年 HSK.ltd. All rights reserved.
//

#import "MyInfoViewController.h"
#import "MyInfoNormalTableViewCell.h"
#import "MyInfoAvatarTableViewCell.h"
#import "MyInfoNickNameViewController.h"
#import "MyInfoSexViewController.h"
#import "ZBPhotoTaker.h"
#import "MyInfoMobileViewController.h"

static NSString * const MY_INFO_CELL = @"myInfoCell";
static NSString * const MY_INFO_NORMAL_CELL = @"myNormalCell";

@interface MyInfoViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *myInfoTV;
@property (nonatomic, strong) NSArray *cellTitle;
@property (nonatomic, strong) NSArray *cellVal;
@property (nonatomic, strong) UIButton *logoutBTN;
@property (nonatomic, strong) ZBPhotoTaker *photoTaker;

@end

@implementation MyInfoViewController

- (void) viewWillAppear:(BOOL)animated {
    self.cellVal = [[TMCache sharedCache] objectForKey:@"userInfo"];
    [_myInfoTV reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customizeBackItem];
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    
    [self setStyle];
}

- (void) setStyle {
    self.navigationItem.title = NSLocalizedString(@"TEXT_MY_INFO", nil);
    self.view.backgroundColor = GRAY_COLOR_CITY_CELL;
    
    self.cellTitle = @[@"", NSLocalizedString(@"TEXT_NICKNAME", nil), NSLocalizedString(@"TEXT_MOBILE", nil), NSLocalizedString(@"TEXT_SEX", nil), NSLocalizedString(@"TEXT_MY_ADDRESS", nil)];
    
    self.myInfoTV = [UITableView newAutoLayoutView];
    [self.view addSubview:_myInfoTV];
    
    [_myInfoTV autoPinToTopLayoutGuideOfViewController:self withInset:-64.0];
    [_myInfoTV autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view];
    [_myInfoTV autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view];
    [_myInfoTV autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view];
    
    _myInfoTV.delegate = self;
    _myInfoTV.dataSource = self;
    _myInfoTV.separatorStyle = UITableViewCellSeparatorStyleNone;
    _myInfoTV.backgroundColor = GRAY_COLOR_CITY_CELL;

    
    [_myInfoTV registerClass:[MyInfoNormalTableViewCell class] forCellReuseIdentifier:MY_INFO_NORMAL_CELL];
    [_myInfoTV registerClass:[MyInfoAvatarTableViewCell class] forCellReuseIdentifier:MY_INFO_CELL];
    
    self.logoutBTN = [UIButton newAutoLayoutView];
    [self.view addSubview:_logoutBTN];
    
    [_logoutBTN autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view];
    [_logoutBTN autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view];
    [_logoutBTN autoSetDimensionsToSize:CGSizeMake(ScreenWidth, 50)];
    [_logoutBTN setTitle:NSLocalizedString(@"BTN_LOGOUT", nil) forState:UIControlStateNormal];
    [_logoutBTN addTarget:self action:@selector(logoutAction) forControlEvents:UIControlEventTouchUpInside];
    _logoutBTN.titleLabel.textAlignment = NSTextAlignmentCenter;
    _logoutBTN.backgroundColor = ORINGE_COLOR_BG;
    
}

- (void) logoutAction {
    [[TMCache sharedCache] setObject:@"0" forKey:@"loginStatus"];
    [[TMCache sharedCache] setObject:@"" forKey:@"userAvatar"];
    [[TMCache sharedCache] setObject:@"" forKey:@"userInfo"];
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return ScreenWidth / 2.3;
    }else{
        return 40;
    }
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row == 0) {
        MyInfoAvatarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MY_INFO_CELL];

        NSURL *imageUrl = [NSURL URLWithString:[[TMCache sharedCache] objectForKey:@"userAvatar"]];
        [cell.avatarImg setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"defaultPicBig"]];
        
//        NSData *avatarData = [[TMCache sharedCache] objectForKey:@"userAvatarData"];
//        if (avatarData) {
//            cell.avatarImg.image = [UIImage imageWithData:avatarData];
//        }else{
//            NSURL *imageUrl = [NSURL URLWithString:[[TMCache sharedCache] objectForKey:@"userAvatar"]];
//            NSURLRequest *imageReqUrl = [NSURLRequest requestWithURL:imageUrl];
//            //            [cell.avatarImg setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"defaultPicBig"]];
//            [cell.avatarImg setImageWithURLRequest:imageReqUrl placeholderImage:[UIImage imageNamed:@"defaultPicBig"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
//                [[TMCache sharedCache] setObject:UIImagePNGRepresentation(image) forKey:@"userAvatarData"];
//            } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
//                
//            }];
//        }
        
        return cell;
    }else{
        MyInfoNormalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MY_INFO_NORMAL_CELL];
        
        if (indexPath.row != 2) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;// 右侧箭头
        }
        
        if (indexPath.row == 4) {
            cell.cutLineLB.hidden = YES;
            cell.valLB.text = @"";
        }else{
            cell.cutLineLB.hidden = NO;
            cell.valLB.text = [_cellVal objectAtIndex:indexPath.row];
        }
        
        cell.textLB.text = [_cellTitle objectAtIndex:indexPath.row];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self uploadAvatar];
        });
        
    }else if(indexPath.row == 1) {
        MyInfoNickNameViewController *nickNameVC = [[MyInfoNickNameViewController alloc] init];
        nickNameVC.nickName = [[[TMCache sharedCache] objectForKey:@"userInfo"] objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:nickNameVC animated:YES];
    }else if (indexPath.row == 2) {
        NSString *hasBand = [[TMCache sharedCache] objectForKey:@"mobileHasBand"];

        if ([hasBand isEqualToString:@"0"]) {
            MyInfoMobileViewController *mobileVC = [[MyInfoMobileViewController alloc] init];
            [self.navigationController pushViewController:mobileVC animated:YES];
        }
        
    }else if(indexPath.row == 3) {
        MyInfoSexViewController *sexVC = [[MyInfoSexViewController alloc] init];
        sexVC.sex = [NSString stringWithFormat:@"%@", [[[TMCache sharedCache] objectForKey:@"userInfo"] objectAtIndex:indexPath.row]];
        [self.navigationController pushViewController:sexVC animated:YES];
    }else if (indexPath.row == 4) {
        
    }
}

- (void) uploadAvatar {
    self.photoTaker = Nil;
    self.photoTaker = [[ZBPhotoTaker alloc] initWithViewController:self];
    
    [_photoTaker takePhotoFrom:ZBPhotoTakerSourceFromGallery allowsEditing:YES finished:^(UIImage *image) {
        [SVProgressHUD show];
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        [parameters setObject:[NSString stringWithFormat:@"%@", [CHSSID SSID]] forKey:@"ssid"];
        [parameters setObject:@"avatar" forKey:@"type"];
        
        [[HttpManager instance] uploadFile:@"Util/uploadFile" imageData:image parameters:parameters success:^(NSDictionary *result) {
            
            NSString *alertTmp = [[result objectForKey:@"data"] objectForKey:@"info"];
            NSArray *userInfoTmp = [[result objectForKey:@"data"] objectForKey:@"user_info"];
            
            [[TMCache sharedCache] setObject:userInfoTmp forKey:@"userInfo"];
            
            [[TMCache sharedCache] setObject:[[result objectForKey:@"data"] objectForKey:@"avatar"] forKey:@"userAvatar"];

            [_myInfoTV reloadData];
            
            [SVProgressHUD showInfoWithStatus:alertTmp maskType:SVProgressHUDMaskTypeBlack];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            [SVProgressHUD showErrorWithStatus:[error localizedDescription] maskType:SVProgressHUDMaskTypeBlack];
            
        }];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
