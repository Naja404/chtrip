//
//  AddSubTripViewController.m
//  chtrips
//
//  Created by Hisoka on 15/3/13.
//  Copyright (c) 2015年 HSK.ltd. All rights reserved.
//

#import "AddSubTripViewController.h"
#import "AddSubTripTableViewCell.h"
#import "AddSubTripLocationTableViewCell.h"
#import "AddSubTripEndTimeTableViewCell.h"

#import "NSDate-Utilities.h"
#import "NSDate+Fomatter.h"
#import "ZBActionSheetDatePicker.h"

#import "ChtripCDManager.h"

static NSString * const ADD_TRIPSUB_CELL = @"AddSubTripCell";
static NSString * const ADD_END_TIME_CELL = @"AddSubTripEndTimeCell";
static NSString * const ADD_LOCATION_CELL = @"AddSubTripLocationCell";
//static NSInteger const START_TIME_ROW = 0;
static NSInteger const END_DATE_SECTION = 1;

@interface AddSubTripViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, ZBActionSheetDatePickerDelegate>

@property (nonatomic, strong) UITableView *addSubTripTV;
@property (nonatomic, strong) AddSubTripTableViewCell *addSubTripCell;
@property (nonatomic, strong) AddSubTripEndTimeTableViewCell *addSubTripEndTimeCell;
@property (nonatomic, strong) AddSubTripLocationTableViewCell *addSubTripLocationCell;
@property (nonatomic, strong) ZBActionSheetDatePicker *datePicker;
@property (nonatomic, strong) NSDate *subTime;
@property (nonatomic, strong) NSString *keyBoardShow;

@end

@implementation AddSubTripViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupAddSubTripTV];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 设置addSubTrip tableview
- (void) setupAddSubTripTV
{
    [self setupNav];
    
    self.addSubTripTV = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _addSubTripTV.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_addSubTripTV];
    
    _addSubTripTV.dataSource = self;
    _addSubTripTV.delegate = self;
    
    [_addSubTripTV autoPinToTopLayoutGuideOfViewController:self withInset:-100.0];
    [_addSubTripTV autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view];
    [_addSubTripTV autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view];
    [_addSubTripTV autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view];
    
    [self.addSubTripTV registerClass:[AddSubTripTableViewCell class] forCellReuseIdentifier:ADD_TRIPSUB_CELL];
    [self.addSubTripTV registerClass:[AddSubTripLocationTableViewCell class] forCellReuseIdentifier:ADD_LOCATION_CELL];
    [self.addSubTripTV registerClass:[AddSubTripEndTimeTableViewCell class] forCellReuseIdentifier:ADD_END_TIME_CELL];
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
            cell = _addSubTripLocationCell;
        }else{
            self.addSubTripCell = [tableView dequeueReusableCellWithIdentifier:ADD_TRIPSUB_CELL forIndexPath:indexPath];
            _addSubTripCell.inputField.placeholder = NSLocalizedString(@"TEXT_SUB_TRIP", Nil);
            _addSubTripCell.inputField.delegate = self;
            _addSubTripCell.iconImgView.image = [UIImage imageNamed:@"tripTitle"];
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
            NSLog(@"if yes");
            [self.view endEditing:YES];
            //        [_addSubTripCell.inputField resignFirstResponder];
            //        [_addSubTripLocationCell.inputField resignFirstResponder];
        }
        
        self.datePicker = Nil;
        NSDate *date = [NSDate tomorrowNoon];
        self.datePicker = [[ZBActionSheetDatePicker alloc] initWithMode:UIDatePickerModeTime initialDate:date delegate:self];
    }else{
        NSLog(@"other");
    }
}

#pragma mark 时间选择
- (void) datePickerDidSelectDate:(NSDate *)date pickerController:(ZBActionSheetDatePicker *)pickerController
{
    
    self.subTime = date;
    
    [self.addSubTripTV reloadData];
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
    ChtripCDManager *TripCD = [[ChtripCDManager alloc] init];
    
    NSDictionary *subTripDate = [[NSDictionary alloc] initWithObjectsAndKeys:self.keyID, @"keyID",
                                                                            _addSubTripLocationCell.inputField.text, @"subAddress",
                                                                            self.subDate, @"subDate",
                                                                            @"12:00", @"subEndTime",
                                                                            @"经纬度lat", @"subLat",
                                                                            @"经纬度lng", @"subLng",
                                                                            @"10:12", @"subStartTime",
                                                                            _addSubTripCell.inputField.text, @"subTitle",
                                 nil];
    
    if ([TripCD addSubTripSections:subTripDate]) {
        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"TEXT_ADD_TRIP_SUCCESS", Nil) maskType:SVProgressHUDMaskTypeClear];
    }else{
        [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"TEXT_ADD_TRIP_FAILD", Nil) maskType:SVProgressHUDMaskTypeClear];
    }
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma  mark return keybord
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"should return ");
    self.keyBoardShow = @"NO";
    
    [textField resignFirstResponder];
    return YES;
}

#pragma mark 键盘弹出
- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"begin yes");
    self.keyBoardShow = @"YES";
}

#pragma mark 键盘隐藏
- (void) textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"end no");
    self.keyBoardShow = @"NO";
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
