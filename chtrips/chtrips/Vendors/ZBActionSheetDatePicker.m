//
//  ZBActionSheetDatePicker.m
//  WithTrip
//
//  Created by Zhou Bin on 14-4-10.
//  Copyright (c) 2014年 Zhou Bin. All rights reserved.
//

#import "ZBActionSheetDatePicker.h"
#import "NSDate+Fomatter.h"
#import "NSDate-Utilities.h"

//最小的分种间隔
//static NSInteger const MINUTE_INTERVAL = 15;

@interface ZBActionSheetDatePicker ()
@property (nonatomic, strong) UIView *view;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, weak) UIView *parentView;
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) UIToolbar *toolBar;
@property (nonatomic) UIDatePickerMode pickerMode;
@property (nonatomic, strong) NSLayoutConstraint *constraintToBottom;
@property (nonatomic, strong) UILabel *yearLabel;
@property (nonatomic, strong) NSDate *initialDate;
@property (nonatomic) NSInteger intervalMinute;
@end

@implementation ZBActionSheetDatePicker

- (NSDate *)dateByAddYear:(NSInteger)year toDate:(NSDate *)date {
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setYear:year];
    NSDate *dateByAddingYear = [cal dateByAddingComponents:components toDate:date options:0];
    return dateByAddingYear;
}

- (void)setup {
    
    self.view = [[UIView alloc] initForAutoLayout];
    [_parentView addSubview:_view];
    _view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    [_view autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    
    self.containerView = [[UIView alloc] initForAutoLayout];
    [_view addSubview:_containerView];
    [_containerView setUserInteractionEnabled:YES];
    
    [_containerView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_parentView];
    [_containerView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:_parentView];
    self.constraintToBottom = [_containerView autoPinEdge:ALEdgeBottom
                                                                  toEdge:ALEdgeBottom
                                                                  ofView:_parentView
                                                              withOffset:260.0];
    
    [self.view layoutIfNeeded];
    _constraintToBottom.constant = 0;
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
    
    [_containerView autoSetDimension:ALDimensionHeight toSize:260.0];
    _containerView.backgroundColor = [UIColor whiteColor];
    
    self.datePicker = [[UIDatePicker alloc] initForAutoLayout];
    _datePicker.datePickerMode = _pickerMode;
    [_datePicker addTarget:self
                    action:@selector(valueChanged:)
          forControlEvents:UIControlEventValueChanged];
    
    _datePicker.minuteInterval = _intervalMinute;
    
    [_containerView addSubview:_datePicker];
    [_datePicker autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:_containerView];
    [_datePicker autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_containerView];
    
    self.toolBar = [[UIToolbar alloc] initForAutoLayout];
    [_containerView addSubview:_toolBar];
    [_toolBar autoSetDimension:ALDimensionHeight toSize:44.0];
    [_toolBar autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_containerView];
    [_toolBar autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:_containerView];
    [_toolBar autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:_containerView];
    
    self.yearLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70, 30)];
    [_yearLabel setFont:[UIFont fontWithName:@"Arial" size:18.0]];
    [_yearLabel setTextAlignment:NSTextAlignmentCenter];
    _yearLabel.backgroundColor = [UIColor clearColor];
    _yearLabel.text = [NSString stringWithFormat:@"%ld",(long)[[NSDate date] year]];
//    if (IS_OS_6_OR_EALIER) {
//        [_yearLabel setTextColor:[UIColor whiteColor]];
//    }
    
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(handleCancel:)];
    
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(handleDone:)];
    
    UIBarButtonItem *dateLabelItem = [[UIBarButtonItem alloc] initWithCustomView:_yearLabel];
    
    UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *rightSpacing = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    rightSpacing.width = 10;
    
    UIBarButtonItem *leftArrow = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"pre_Arrow.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(decreaseYear)];
    UIBarButtonItem *rightArrow = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"next_Arrow.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(increaseYear)];
    
    NSArray *items = nil;
    
    if (_pickerMode == UIDatePickerModeDateAndTime) {
        items = @[leftArrow, dateLabelItem, rightArrow, flex, cancel, done, rightSpacing];
    }else {
        items = @[flex, cancel, done, rightSpacing];
    }
    
    if (_initialDate) {
        [_datePicker setDate:_initialDate];
    }
    
    [_toolBar setItems:items];
}

- (instancetype)initWithMode:(UIDatePickerMode)mode
                 initialDate:(NSDate *)date
                    delegate:(id<ZBActionSheetDatePickerDelegate>)delegate {
    
    return [self initWithMode:mode initialDate:date minuteInterval:1 delegate:delegate];

}

- (instancetype)initWithMode:(UIDatePickerMode)mode
                    delegate:(id<ZBActionSheetDatePickerDelegate>)delegate {
    
    return [self initWithMode:mode initialDate:nil minuteInterval:15 delegate:delegate];
    
}

- (instancetype)initWithMode:(UIDatePickerMode)mode
                 initialDate:(NSDate *)date
              minuteInterval:(NSInteger)minute
                    delegate:(id<ZBActionSheetDatePickerDelegate>)delegate {
    
    self = [super init];
    if (self) {
        self.parentView = [UIApplication sharedApplication].keyWindow;
        self.delegate = delegate;
        self.pickerMode = mode;
        self.intervalMinute = minute;
        self.initialDate = date;
        [self setup];
    }
    
    return self;
    
}

- (void)dismiss {
    _constraintToBottom.constant = 260.0;
    self.view .backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0];
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [_view removeFromSuperview];
    }];
}

- (void)datePickerCancel:(UIBarButtonItem *)sender {
    [self dismiss];
    if ([self.delegate respondsToSelector:@selector(datePickerDidCancel:)]) {
        [self.delegate datePickerDidCancel:self];
    }
}

- (void)handleDone:(UIBarButtonItem *)sender {
    [self dismiss];
    NSDate *date = _datePicker.date;
    if ([self.delegate respondsToSelector:@selector(datePickerDidSelectDate:pickerController:)]) {
        [self.delegate datePickerDidSelectDate:date pickerController:self];
    }
}

- (void)handleCancel:(UIBarButtonItem *)sender {
    [self dismiss];
    if ([self.delegate respondsToSelector:@selector(datePickerDidCancel:)]) {
        [self.delegate datePickerDidCancel:self];
    }
}

- (void)handleTapGesture:(UITapGestureRecognizer *)gr {
    [self dismiss];
    if ([self.delegate respondsToSelector:@selector(datePickerDidCancel:)]) {
        [self.delegate datePickerDidCancel:self];
    }
}

- (void)valueChanged:(UIDatePicker *)picker {
    NSDate *date = picker.date;
    _yearLabel.text = [NSString stringWithFormat:@"%ld",(long)[date year]];
}

//减少年份
- (void)decreaseYear {
    NSDate *date  = [self dateByAddYear:-1 toDate:_datePicker.date];
    _yearLabel.text = [NSString stringWithFormat:@"%ld",(long)[date year]];
    [_datePicker setDate:date animated:NO];
}

//增加年份
- (void)increaseYear {
    NSDate *date = [self dateByAddYear:1 toDate:_datePicker.date];
    _yearLabel.text = [NSString stringWithFormat:@"%ld",(long)[date year]];
    [_datePicker setDate:date animated:NO];
}


@end
