//
//  EditSubTripViewController.m
//  chtrips
//
//  Created by Hisoka on 15/3/23.
//  Copyright (c) 2015年 HSK.ltd. All rights reserved.
//

#import "EditSubTripViewController.h"

#import "AddSubTripTableViewCell.h"
#import "AddSubTripLocationTableViewCell.h"
#import "AddSubTripEndTimeTableViewCell.h"
#import "AddSubTripLocationViewController.h"

#import "NSDate-Utilities.h"
#import "NSDate+Fomatter.h"
#import "ZBActionSheetDatePicker.h"

#import "ChtripCDManager.h"

static NSString * const ADD_TRIPSUB_CELL = @"AddSubTripCell";
static NSString * const ADD_END_TIME_CELL = @"AddSubTripEndTimeCell";
static NSString * const ADD_LOCATION_CELL = @"AddSubTripLocationCell";
//static NSInteger const START_TIME_ROW = 0;
static NSInteger const END_DATE_SECTION = 1;

@interface EditSubTripViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, ZBActionSheetDatePickerDelegate, AddSubTripLocationViewControllerDelegate>

@property (nonatomic, strong) UITableView *editSubTripTV;
@property (nonatomic, strong) AddSubTripTableViewCell *addSubTripCell;
@property (nonatomic, strong) AddSubTripEndTimeTableViewCell *addSubTripEndTimeCell;
@property (nonatomic, strong) AddSubTripLocationTableViewCell *addSubTripLocationCell;
@property (nonatomic, strong) ZBActionSheetDatePicker *datePicker;
@property (nonatomic, strong) NSString *keyBoardShow;


@end

@implementation EditSubTripViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupEditSubTripTV];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark 设置addSubTrip tableview
- (void) setupEditSubTripTV
{
    [self setupNav];
    
    self.editSubTripTV = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _editSubTripTV.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_editSubTripTV];
    
    _editSubTripTV.dataSource = self;
    _editSubTripTV.delegate = self;
    
    [_editSubTripTV autoPinToTopLayoutGuideOfViewController:self withInset:-100.0];
    [_editSubTripTV autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view];
    [_editSubTripTV autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view];
    [_editSubTripTV autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view];
    
    [self.editSubTripTV registerClass:[AddSubTripTableViewCell class] forCellReuseIdentifier:ADD_TRIPSUB_CELL];
    [self.editSubTripTV registerClass:[AddSubTripLocationTableViewCell class] forCellReuseIdentifier:ADD_LOCATION_CELL];
    [self.editSubTripTV registerClass:[AddSubTripEndTimeTableViewCell class] forCellReuseIdentifier:ADD_END_TIME_CELL];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }else{
        return 1;
    }
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    if (indexPath.section == END_DATE_SECTION) {
        self.addSubTripEndTimeCell = [tableView dequeueReusableCellWithIdentifier:ADD_END_TIME_CELL forIndexPath:indexPath];
        
        _addSubTripEndTimeCell.titleLB.text = NSLocalizedString(@"TEXT_TIME", Nil);
        _addSubTripEndTimeCell.timeLB.textColor = [UIColor blueColor];
        
        if (_subTime == nil) {
            _addSubTripEndTimeCell.timeLB.text = @"12:00";
        }else{
            _addSubTripEndTimeCell.timeLB.text = [_subTime hourAndMinute];
        }
        
        cell = _addSubTripEndTimeCell;
        
    }else{
        
        
        if (indexPath.row == 1) {
            self.addSubTripLocationCell = [tableView dequeueReusableCellWithIdentifier:ADD_LOCATION_CELL forIndexPath:indexPath];
            _addSubTripLocationCell.inputField.placeholder = NSLocalizedString(@"TEXT_SUB_TRIP_LOCATION", Nil);
            _addSubTripLocationCell.iconImgView.image = [UIImage imageNamed:@"tripLocation"];
            _addSubTripLocationCell.inputField.delegate = self;
            _addSubTripLocationCell.inputField.text = _subAddressName;
            
            UITapGestureRecognizer *onceTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickLocationIcon)];
            [_addSubTripLocationCell addGestureRecognizer:onceTap];
            
            
            cell = _addSubTripLocationCell;
        }else{
            self.addSubTripCell = [tableView dequeueReusableCellWithIdentifier:ADD_TRIPSUB_CELL forIndexPath:indexPath];
            _addSubTripCell.inputField.placeholder = NSLocalizedString(@"TEXT_SUB_TRIP", Nil);
            _addSubTripCell.inputField.delegate = self;
            _addSubTripCell.iconImgView.image = [UIImage imageNamed:@"tripTitle"];
            _addSubTripCell.inputField.text = _subTripName;
            cell = _addSubTripCell;
        }
        
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 1) {
        if ([_keyBoardShow isEqualToString:@"YES"]) {
            [self.view endEditing:YES];
            //        [_addSubTripCell.inputField resignFirstResponder];
            //        [_addSubTripLocationCell.inputField resignFirstResponder];
        }
        
        self.datePicker = Nil;
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[_subDate doubleValue]];
        self.datePicker = [[ZBActionSheetDatePicker alloc] initWithMode:UIDatePickerModeTime initialDate:date delegate:self];
    }else{
        NSLog(@"other");
    }
}

#pragma mark 时间选择
- (void) datePickerDidSelectDate:(NSDate *)date pickerController:(ZBActionSheetDatePicker *)pickerController
{
    
    self.subTime = date;
    
    [self.editSubTripTV reloadData];
}
#pragma mark 时间取消
- (void) datePickerDidCancel:(ZBActionSheetDatePicker *)pickerController
{
    
}

#pragma mark 设置nav内容
- (void) setupNav
{
    UIBarButtonItem *navCancelBTN = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"BTN_CANCEL", Nil)
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:@selector(navCancelBTN)];
    self.navigationItem.leftBarButtonItem = navCancelBTN;
    
    UIBarButtonItem *navSaveBTN = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"BTN_SAVE", Nil)
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(navSaveBTN)];
    self.navigationItem.rightBarButtonItem = navSaveBTN;
    
}

#pragma mark nav取消按钮
- (void) navCancelBTN
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark nav保存按钮
- (void) navSaveBTN
{
    
    if ([_addSubTripCell.inputField.text isEqualToString:@""]) {
        [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"TEXT_PLACE_INPUT_TRIP_NAME", Nil) maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    
    if ([_addSubTripLocationCell.inputField.text isEqualToString:@""]) {
        [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"TEXT_PLACE_INPUT_ADDRESS", Nil) maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    
    ChtripCDManager *TripCD = [[ChtripCDManager alloc] init];
    
    NSDictionary *subTripData = [[NSDictionary alloc] initWithObjectsAndKeys:self.keyID, @"keyID",
                                 self.subID, @"subID",
                                 _addSubTripLocationCell.inputField.text, @"subAddress",
                                 self.subDate, @"subDate",
                                 [NSNumber numberWithDouble:[_subTime timeIntervalSince1970]], @"subEndTime",
                                 self.lat, @"subLat",
                                 self.lng, @"subLng",
                                 [NSNumber numberWithDouble:[_subTime timeIntervalSince1970]], @"subStartTime",
                                 _addSubTripCell.inputField.text, @"subTitle",
                                 nil];
    
    
    if ([TripCD updateSubTrip:subTripData]) {
        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"TEXT_EDIT_TRIP_SUCCESS", Nil) maskType:SVProgressHUDMaskTypeBlack];
    }else{
        [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"TEXT_EDIT_TRIP_FAILD", Nil) maskType:SVProgressHUDMaskTypeBlack];
    }
    
    [self.editSubTripDelegate refreshTableView];
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma  mark return keybord
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    self.keyBoardShow = @"NO";
    
    [textField resignFirstResponder];
    return YES;
}

#pragma mark 键盘弹出
- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    self.keyBoardShow = @"YES";
}

#pragma mark 键盘隐藏
- (void) textFieldDidEndEditing:(UITextField *)textField
{
    self.keyBoardShow = @"NO";
}

#pragma mark 点击地址icon
- (void) onClickLocationIcon
{
    AddSubTripLocationViewController *addLocationVC = [[AddSubTripLocationViewController alloc] init];
    addLocationVC.AddSubLocationDelegate = self;
    
    [self.navigationController pushViewController:addLocationVC animated:YES];
}

#pragma mark 地址选择后delegata
- (void) setupSubLocationText:(NSString *)Address Lat:(NSString *)lat Lng:(NSString *)lng
{
    _addSubTripLocationCell.inputField.text = Address;
    self.lat = lat;
    self.lng = lng;
}


@end
