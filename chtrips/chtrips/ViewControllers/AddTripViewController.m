//
//  AddTripViewController.m
//  chtrips
//
//  Created by Hisoka on 15/3/11.
//  Copyright (c) 2015年 HSK.ltd. All rights reserved.
//

#import "AddTripViewController.h"
#import "AddTripTableViewCell.h"
#import "AddTripDateTableViewCell.h"
#import "AddTripFrontTableViewCell.h"
#import "AddTripNameTableViewCell.h"
#import "TripListViewController.h"

#import "NSDate+Fomatter.h"
#import "NSDate-Utilities.h"
#import "NSDate+DateTools.h"
#import "ZBPhotoTaker.h"
#import "ZBActionSheetDatePicker.h"

#import "ChtripCDManager.h"

static NSString * const CELL_ADDTRIP = @"addTripCell";
static NSString * const CELL_ADDTRIP_DATE = @"addTripDateCell";
static NSString * const CELL_ADDTRIP_FRONT = @"addTripFrontCell";
static NSString * const CELL_ADDTRIP_NAME = @"addTripNameCell";
static NSInteger  const SECTION_DATE = 1;
static NSInteger const SECTION_FRONT = 0;
static NSInteger const ROW_FRONT = 0;

@interface AddTripViewController ()<UITextFieldDelegate, ZBActionSheetDatePickerDelegate, UIActionSheetDelegate>

@property (nonatomic, retain) UITableView *addTripTV;
@property (nonatomic, strong) AddTripDateTableViewCell *tripDateCell;
@property (nonatomic, strong) AddTripFrontTableViewCell *tripFrontCell;
@property (nonatomic, strong) AddTripNameTableViewCell *tripNameCell;

@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) ZBActionSheetDatePicker *datePicker;
@property (nonatomic, strong) ZBPhotoTaker *photoTaker;
@property (nonatomic, strong) NSData *frontImgData;
@property (nonatomic, strong) NSString *keyBoardShow;

@end

@implementation AddTripViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.startDate = [NSDate tomorrowNoon];
    
    [self setupAddTripTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 设置添加行程封面
- (void) setupAddTripTableView
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(clickSaveBTN)];
    
    self.addTripTV = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _addTripTV.translatesAutoresizingMaskIntoConstraints = NO;

    _addTripTV.dataSource = self;
    _addTripTV.delegate = self;
    
    [self.view addSubview:_addTripTV];
    
    [_addTripTV autoPinToTopLayoutGuideOfViewController:self withInset:-85.0];
    [_addTripTV autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view];
    [_addTripTV autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view];
    [_addTripTV autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view];
    
    [self.addTripTV registerClass:[AddTripDateTableViewCell class] forCellReuseIdentifier:CELL_ADDTRIP_DATE];
    [self.addTripTV registerClass:[AddTripFrontTableViewCell class] forCellReuseIdentifier:CELL_ADDTRIP_FRONT];
    [self.addTripTV registerClass:[AddTripNameTableViewCell class] forCellReuseIdentifier:CELL_ADDTRIP_NAME];
    
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20.0;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 2;
            break;
            
        default:
            return 1;
            break;
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0 && indexPath.section == 0) {
        return 150;
    }else{
        return 50;
    }
}

#pragma mark 设置cell
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    if (indexPath.section == SECTION_DATE) {
        
        self.tripDateCell = [tableView dequeueReusableCellWithIdentifier:CELL_ADDTRIP_DATE forIndexPath:indexPath];
        
        _tripDateCell.titleLB.text = NSLocalizedString(@"TEXT_START_DATE", Nil);
        _tripDateCell.dateLB.text = [self.startDate mediumStyleString];
        
        cell = _tripDateCell;
    }else{
        
        if (indexPath.row == 0) {
            
            self.tripFrontCell = [tableView dequeueReusableCellWithIdentifier:CELL_ADDTRIP_FRONT forIndexPath:indexPath];
            cell = _tripFrontCell;
        }else{
            
            self.tripNameCell = [tableView dequeueReusableCellWithIdentifier:CELL_ADDTRIP_NAME forIndexPath:indexPath];
            _tripNameCell.tripNameInput.delegate = self;
            cell = _tripNameCell;
        }
        
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark 时间选择
- (void) datePickerDidSelectDate:(NSDate *)date pickerController:(ZBActionSheetDatePicker *)pickerController
{
    self.startDate = date;
    
    [self.addTripTV reloadData];
}

#pragma mark 时间选择取消
- (void) datePickerDidCancel:(ZBActionSheetDatePicker *)pickerController
{
    
}

#pragma mark cell选择事件
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == SECTION_DATE) {
        if ([_keyBoardShow isEqualToString:@"YES"]) {
            [self.view endEditing:YES];
        }
        self.datePicker = Nil;
        NSDate *date = [NSDate tomorrowNoon];
        self.datePicker = [[ZBActionSheetDatePicker alloc] initWithMode:UIDatePickerModeDate initialDate:date delegate:self];
    }
    
    if (indexPath.section == SECTION_FRONT) {
        if (indexPath.row == ROW_FRONT) {
            UIActionSheet *frontAction = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"BTN_CHOOSE_PICTURE", Nil)
                                                                     delegate:self
                                                            cancelButtonTitle: NSLocalizedString(@"BTN_CANCEL", Nil)
                                                       destructiveButtonTitle:Nil
                                                            otherButtonTitles:NSLocalizedString(@"BTN_CAMERA", Nil), NSLocalizedString(@"BTN_ALBUM", Nil), nil];
            [frontAction showInView:self.view];
        }
    }
}

#pragma mark 封面选择标签代理
- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    self.photoTaker = Nil;
    self.photoTaker = [[ZBPhotoTaker alloc] initWithViewController:self];
    
    NSString *selectTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    if ([selectTitle isEqualToString:NSLocalizedString(@"BTN_CAMERA", Nil)]) {
        [_photoTaker takePhotoFrom:ZBPhotoTakerSourceFromCamera allowsEditing:YES finished:^(UIImage *image) {
            _tripFrontCell.frontImgView.image = image;
//            _frontImgData = UIImageJPEGRepresentation(image, 1);
            _frontImgData = UIImagePNGRepresentation(image);
            [_addTripTV reloadData];
        }];
    }
    
    if ([selectTitle isEqualToString:NSLocalizedString(@"BTN_ALBUM", Nil)]) {
        [_photoTaker takePhotoFrom:ZBPhotoTakerSourceFromGallery allowsEditing:YES finished:^(UIImage *image) {
            _tripFrontCell.frontImgView.image = image;
//            _frontImgData = UIImageJPEGRepresentation(image, 1);
            _frontImgData = UIImagePNGRepresentation(image);
            [_addTripTV reloadData];
        }];
    }
}

#pragma mark 开始编辑输入框的时候，软键盘出现，执行此事件
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.keyBoardShow = @"YES";
    
    CGRect frame = textField.frame;
    int offset = frame.origin.y + 32 - (self.view.frame.size.height - 516.0);//键盘高度216
    
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    if(offset > 0)
        self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView commitAnimations];
}

#pragma mark 当用户按下return键或者按回车键，keyboard消失
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    self.keyBoardShow = @"NO";
    [textField resignFirstResponder];
    return YES;
}

#pragma mark 输入框编辑完成以后，将视图恢复到原始状态
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    self.keyBoardShow = @"NO";
    self.view.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}

#pragma mark 设置封面图片
- (NSData *) setupFrontImg
{
    if (_frontImgData) {
        return _frontImgData;
    }else{
        return Nil;
    }
}

#pragma mark 点击保存
- (void) clickSaveBTN
{
    NSString *tripName = @"";
    
    if ([self.tripNameCell.tripNameInput.text isEqualToString:@""]) {
//        [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"TEXT_PLACE_INPUT_TRIP_NAME", Nil) maskType:SVProgressHUDMaskTypeBlack];
//        return;
        tripName = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"TEXT_DEFAULT_TRIPNAME", Nil), [self.startDate formattedDateWithFormat:@"YYYY.MM.dd"]];
    }else{
        tripName = self.tripNameCell.tripNameInput.text;
    }
    
    ChtripCDManager *TripCD = [[ChtripCDManager alloc] init];
    
    NSString *keyID = [TripCD makeKeyID];
    
    NSDictionary *tripData = [[NSDictionary alloc] initWithObjectsAndKeys:keyID, @"keyID",
                                                                            [NSNumber numberWithDouble:[self.startDate timeIntervalSince1970]], @"startDate",
                                                                            [NSNumber numberWithDouble:[[self.startDate setupNoonByNum:2] timeIntervalSince1970]], @"endDate",
                                                                            tripName, @"tripName",
                                                                            [self setupFrontImg], @"frontData",
                                                                            nil];

    NSString *saveStatus = @"0";
    
    if ([TripCD addTrip:tripData]) {
        
        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"TEXT_ADD_TRIP_SUCCESS", Nil) maskType:SVProgressHUDMaskTypeBlack];
        [self setupSubTripSection:keyID startDate:self.startDate ChtripCDManager:TripCD];
        saveStatus = @"1";
    }else{
        [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"TEXT_ADD_TRIP_FAILD", Nil) maskType:SVProgressHUDMaskTypeBlack];
    }

    [self popToRoot:saveStatus keyID:keyID tripName:self.tripNameCell.tripNameInput.text];
    
}

#pragma mark 设定子行程sections
- (void) setupSubTripSection:(NSString *)keyID startDate:(NSDate *)startDate ChtripCDManager:(ChtripCDManager *)TripCD
{
    for (int i = 0; i < 3; i++) {
        NSDictionary *subTripData = [[NSDictionary alloc] initWithObjectsAndKeys:keyID, @"keyID",
                                                                                [TripCD makeKeyID], @"subID",
                                                                                [NSNumber numberWithDouble:[[self.startDate setupNoonByNum:i] timeIntervalSince1970]], @"subDate",
                                                                                @"section", @"subTitle",
                                                                                nil];
        
        [TripCD addSubTripSections:subTripData];
    }
}

#pragma mark 返回到主页面
- (void) popToRoot:(NSString *) saveStatus keyID:(NSString *)keyID tripName:(NSString *)tripName
{
//    TripListViewController *tripList = [TripListViewController alloc];
//    tripList.saveStatus = saveStatus;
    
//    [_delegate gotoEditedController:saveStatus keyID:keyID tripName:tripName];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
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
